Return-Path: <linux-kernel-owner+w=401wt.eu-S2992483AbXEBCnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992483AbXEBCnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992530AbXEBCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:43:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXEBCnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:43:16 -0400
Date: Tue, 1 May 2007 22:42:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
Message-ID: <20070502024242.GC6935@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
	linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
References: <4637AC3D.6000008@freedesktop.org> <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 02:43:30PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Tue, 1 May 2007, Josh Triplett wrote:
 > > 
 > > Does this still apply?  Do current versions of GCC still have this problem?
 > > If not, can the option and warning go away?
 > 
 > Even if current versions of gcc don't triple the build time (and for the 
 > kernel, I suspect it doesn't, because we've tried to clean up our header 
 > files), the generated _code_ will invariably suck.

FWIW, I do sparse runs on the fedora development kernels as part of
our daily builds now, and of the latest ones at
http://people.redhat.com/davej/kernels/Fedora/fc7/warnings.txt
(concatenated warning logs from i586/i686/x86_64/ppc/ppc64/s390 builds)
that 'expensive pointer subtraction' turns up 3705 times.
Interestingly, 1873 of those instances are from include/linux/mm.h
on the x86-64 build.

It's complaining about this line...

static __always_inline void *lowmem_page_address(struct page *page)
{
        return __va(page_to_pfn(page) << PAGE_SHIFT);
}

...

unsigned long page_to_pfn(struct page *page)
{
        return __page_to_pfn(page);
}

...

#define __page_to_pfn(page)     ((unsigned long)((page) - mem_map) + \
                                 ARCH_PFN_OFFSET)

looks like the other two variants of __page_to_pfn also use similar arithmatic.

	Dave

-- 
http://www.codemonkey.org.uk
