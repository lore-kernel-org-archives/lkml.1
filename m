Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYBYMNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYBYMNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYBYMMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:12:55 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59297 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbYBYMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:12:53 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWSN6O-04-0J3-01
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Mon, 25 Feb 2008 13:09:51 +0100
From: "Hans Rosenfeld" <hans.rosenfeld@amd.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       "Adam Litke" <aglitke@gmail.com>, "nacc" <nacc@linux.vnet.ibm.com>,
       "Jon Tollefson" <kniht@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages
 and return page size
Message-ID: <20080225120951.GA5963@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com>
 <1203733096.14838.154.camel@cinder.waste.org>
 <1203791461.11305.135.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
In-Reply-To: <1203791461.11305.135.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 25 Feb 2008 12:08:58.0704 (UTC)
 FILETIME=[337B9500:01C877A7]
X-WSS-ID: 6BDC6FD12IW13227301-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 10:31:01AM -0800, Dave Hansen wrote:
> > > - 4 bits for the page size, with 0 meaning native page size (4k on x86,
> > >   8k on alpha, ...) and values 1-15 being specific to the architecture
> > >   (I used 1 for 2M, 2 for 4M and 3 for 1G for x86)
> 
> "Native page size" probably a bad idea.  ppc64 can use 64k or 4k for its
> "native" page size and has 16MB large pages (as well as some others).
> To make it even more confusing, you can have a 64k kernel page size with
> 4k mmu mappings!
> 
> That said, this is a decent idea as long as we know that nobody will
> ever have more than 16 page sizes.  

Then a better way to encode the page size would be returning the page
shift. This would need 6 bits instead of 4, but it would probably be
enough for any 64 bit architecture.


> > This is ok-ish, but I can't say I like it much. Especially the page size
> > field.
> > 
> > But I don't really have many ideas here. Perhaps having a bit saying
> > "this entry is really a continuation of the previous one". Then any page
> > size can be trivially represented. This might also make the code on both
> > sides simpler?

I don't like the idea of parsing thousands of entries just to find out
that I'm using a huge page. It would be much better to just get the page
size one way or the other in the first entry one reads.


> > > -static int add_to_pagemap(unsigned long addr, u64 pfn,
> > > +struct ppte {
> > > +	uint64_t paddr:58;
> > > +	uint64_t psize:4;
> > > +	uint64_t swap:1;
> > > +	uint64_t present:1;
> > > +};
> 
> It'd be nice to keep the current convention, which is to stay away from
> bitfields.

I like them, they make the code much more readable.


> > > +#ifdef CONFIG_X86
> > > +	if (pmd_huge(*pmd)) {
> > > +		struct ppte ppte = { 
> > > +			.paddr = pmd_pfn(*pmd) << PAGE_SHIFT,
> > > +			.psize = (HPAGE_SHIFT == 22 ?
> > > +				  PM_PSIZE_4M : PM_PSIZE_2M),
> > > +			.swap  = 0,
> > > +			.present = 1,
> > > +		};
> > > +
> > > +		for(; addr != end; addr += PAGE_SIZE) {
> > > +			err = add_to_pagemap(addr, ppte, pm);
> > > +			if (err)
> > > +				return err;
> > > +		}
> > > +	} else
> > > +#endif
> 
> It's great to make this support huge pages, but things like this
> probably need their own function.  Putting an #ifdef in the middle of
> here makes it a lot harder to read.  Just think of when powerpc, ia64
> and x86_64 get their grubby mitts in here. ;)

AFAIK the way huge pages are used on x86 differs much from other
architectures. While on x86 the address translation stops at some upper
table for a huge page, other architectures encode the page size in the
pte (at least the ones I looked at did). So pmd_huge() (and soon
pud_huge()) are very x86-specific and return just 0 on other archs, and
this code would be optimized away for them. All that would be necessary
for other archs is to eventually get the page size from the pte and put
it in the psize field.

The #ifdef could go away if pmd_pfn() was defined as 0 for !x86, it
wouldn't make sense to use it anyway.



-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown


