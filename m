Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYL3Gfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYL3Gfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYL3Gf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:35:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:45134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYL3Gf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:35:28 -0500
Date: Tue, 30 Dec 2008 07:35:24 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-ID: <20081230063524.GA14132@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de> <20081229151731.2a2c5a02.akpm@linux-foundation.org> <20081230040118.GA27679@wotan.suse.de> <m1tz8m41yj.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tz8m41yj.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 10:22:12PM -0800, Eric W. Biederman wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
> >> On Thu, 18 Dec 2008 22:15:43 +0100
> >> Nick Piggin <npiggin@suse.de> wrote:
> >> 
> >> > Hi,
> >> > 
> >> > I've debugged a problem where i386+pae systems with more than a few CPUs
> >> > blow up at boot in the kmap_atomic code.
> >> 
> >> ping?
> >
> > No further progress here, I'm waiting on input for how to fix this
> > "nicely". Meantime, clearing the early fixmap pte I guess works, but
> > you lose a page... is it possible to put it into .initdata or is
> > there some issue with that? (I guess on a PAE kernel, 4K isn't a
> > big deal).
> >
> >  
> >> > The problem is that the kmap_atomic pte pages all need to be contiguous
> >> > memory because the pte is calculated via the first kmap pte page + an
> >> > offset (so as not to have to walk the page tables every time).
> >> > 
> >> > The fixmap setup code crudely allocates contiguous pte pages, which is fine,
> >> > but if it finds an already populated pmd entry, then it will not switch it
> >> > to a new, contiguous pte page. So the early fixmap introduces a discontig
> >> > page table right in the middle of the kmap atomic fixmaps.
> 
> Where is this?

Where is what?

 
> >> > Commenting out the eaarly fixmap setup in head_32.S gets everything working
> >> > properly. What would be the best way to fix this? Could we put the early
> >> > fixmap page table in initdata, and then have the fixmap setup proper first
> >> > clear its corresponding pmd entry?
> 
> Why would we want or need to?

So the fixmap allocator allocates contiguous pagetables. Wasn't my
description clear enough?

 
> >> How come users/testers aren't reporting this?
> >
> > Because apparently nobody tests 32-bit PAE systems with more than a couple
> > of CPUs anymore. This bug comes from HW vendor doing testing of SLES11.
> 
> Hmm.
> 
> I have taken a quick skim and I am not seeming the part of the code you are
> talking about.  Is the problem code in mainline?
> 
> I'm guessing it has something to do with reserve_top_address() being called
> with a bad value in the normal case.  But I don't see it being called
> at all in the normal case.

Yes I think so. one_page_table_init will not allocate a new pte page if
one already exists, so it will not be contiguous with previous/subsequent
pages with the early fixmap pte there. page_table_range_init explains why
that is a problem (this code seems terribly fragile and prone to breakage
but I don't want to expend theeffort on it -- still, I have a patch to
panic the kernel if it breaks its guarantee of contiguous page tables,
which makes breakage easily visible).


