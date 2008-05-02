Return-Path: <linux-kernel-owner+w=401wt.eu-S937063AbYEBWWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937063AbYEBWWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbYEBWWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:22:08 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51359 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbYEBWWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:22:06 -0400
Date: Fri, 2 May 2008 18:22:00 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, uclinux-dist-devel@blackfin.uclinux.org,
       richterd@citi.umich.edu
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080502222200.GQ21918@fieldses.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429214231.GC26468@fieldses.org> <20080501062432.GT5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501062432.GT5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 07:24:32AM +0100, Al Viro wrote:
> On Tue, Apr 29, 2008 at 05:42:31PM -0400, J. Bruce Fields wrote:
> > The most likely consequences are that a local reader gets out-of-date
> > data for a file that a Samba client has modified.
> > 
> > I suppose that re-checking the d_count and i_count after step 3 might
> > close the race.
>  
> The hell it might.

Yeah, looking back at the code, I suppose by the time we've added the
new lease to the inode's lock list, we've already broken conflicting
leases.  OK.

> Leases are broken, plain and simple.  Not to mention
> anything else, a couple of threads with shared descriptor table will
> bypass these checks happily.

I lost you there.

> 
> FWIW, that's far from the worst problem in fs/locks.c, and not even the
> worst one with leases.
> 
> That, BTW, is a fine demonstration of the reasons why application-specific
> kernel warts(tm) are bad.  Lease support is samba-only turd; so's dnotify,
> with its lovely problems.  And interfaces like that *suck*; they are
> developed with one application in mind and that leads to "we know how it
> will be used" mentality.  With obvious implications for quality of review
> they get from their developers...

I honestly don't understand how exactly Samba uses leases; it'd be
extremely useful to have a concise list of requirements from them.  I
know that they don't really meet the nfsv4 server's requirements (any
bugs aside).

> Al, currently crawling through struct file_lock review and extremely annoyed
> by the amount of turds being found...

Thanks, it's been long in need of more attention--details welcomed.

--b.
