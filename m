Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbXHAAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbXHAAN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbXHAANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:13:49 -0400
Received: from waste.org ([66.93.16.53]:36603 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758715AbXHAANs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:13:48 -0400
Date: Tue, 31 Jul 2007 19:14:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: /proc/$pid/pagemap troubles
Message-ID: <20070801001404.GY11115@waste.org>
References: <1185914174.18414.184.camel@localhost> <20070731213718.GW11115@waste.org> <1185921790.18414.223.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185921790.18414.223.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 03:43:10PM -0700, Dave Hansen wrote:
> On Tue, 2007-07-31 at 16:37 -0500, Matt Mackall wrote:
> > 
> > > So, a couple of questions.  Don't we need to support
> > non-sizeof(unsigned
> > > long)-aligned reads?
> > 
> > Why? We should obviously never return more data than we were asked for
> > (that's clearly a bug), but lots of things refuse to read or write
> > stuff that isn't well sized and aligned. 
> 
> For the 1-byte stuff at the beginning of the file, I think it makes
> perfect sense:
> 
> 	char __big_endian;
> 	int big_endian;
> 	read(fd, &__big_endian, 1);
> 	big_endian = __big_endian;

True.
 
> > > Do we _really_ need that header in each and every file?
> > 
> > Well there's either a header or there isn't.
> 
> I just mean that perhaps we should be putting some of that stuff in a
> global file.  I think there's some added simplicity both in the kernel
> and in the userspace programs if we just let "*ppos << PAGE_SHIFT ==
> vaddr".

Absolutely. It's the source of both of the long read bugs you
mentioned. But there are also advantages to having it attached.

> I was going to send you a patch, but since you're updating anyway, could
> you add some symbolic names like this:
> 
> #define PAGEMAP_ENTRY_SIZE_BYTES        sizeof(unsigned long)
> #define PAGEMAP_HEADER_SIZE_BYTES       sizeof(unsigned long)
> #define PAGEMAP_MAX_VIRT_PFN            (((~0UL) >> PAGE_SHIFT) + 1)
> #define PAGEMAP_BUFFER_SLOTS		(PAGE_SIZE/PAGEMAP_ENTRY_SIZE_BYTES)
> #define PAGEMAP_UNPOPULATED_PAGE	(-1UL)

I suppose.

> +       evpfn = min((src + count) / sizeof(unsigned long),
> +                   ((~0UL) >> PAGE_SHIFT) + 1);
> 
> Should that hunk of code be any different for 32-bit processes on a
> 64-bit kernel?  Do we want to use TASK_SIZE_OF() or restrict these to
> actual virtual address space (which is only 48 bits on x86_64).

No. A page for a 32-bit task can line anywhere in the >32-bit physical
address space.

> It also seems that we need some replacement for the CONFIG_HIGHPTE
> #ifdefs.  What is the basic reason for those?  The copy_to_user() called
> by add_to_pagemap()->flush_pagemap() conflicts with the kmap_atomic()
> from pte_offset_map()?

My not-yet-working code uses get_user_pages and does away with all the
double-buffering and a bunch of the locking issues. 

> As I think about it, do we really even need to walk the VMA list at all?
> We don't do anything differently if an address is inside a VMA.  We just
> save time by not walking the pagetables for areas that we know are
> zeroed.  But, we won't be able to walk down to the PTE level in most
> cases, anyway.  So, it probably won't waste _that_ much time.

Perhaps not.

> +struct pagemapread {
> +       struct mm_struct *mm;
> +       unsigned long next;
> +       unsigned long *buf;
> +       pte_t *ptebuf;
> +       unsigned long pos;
> +       size_t count;
> +       int index;
> +       char __user *out;
> +};
> 
> Just looking at the structure, it's _really_ hard to tell what fields go
> with other fields, and it took me a while to unravel it all.  There's
> also some redundancy in it, which I find a bit confusing.

Most of those go away with the get_user_pages approach.

-- 
Mathematics is the supreme nostalgia of our time.
