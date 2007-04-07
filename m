Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXDGA3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXDGA3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXDGA3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:29:01 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbXDGA3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:29:00 -0400
Date: Fri, 6 Apr 2007 17:28:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD
 sharing
Message-Id: <20070406172844.12f7b8e7.akpm@linux-foundation.org>
In-Reply-To: <4616DFB2.4020802@goop.org>
References: <20070404191151.009821039@goop.org>
	<20070404191205.392155702@goop.org>
	<20070406164139.08cd343b.akpm@linux-foundation.org>
	<4616DFB2.4020802@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 17:02:58 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > All this paravirt stuff isn't making the kernel any prettier, is it?
> >   
> 
> You're too kind.  wli's comment on the first version of this patch was
> something along the lines of "this patch causes a surprising amount of
> damage for what little it achieves".

Damn, I wish I'd said that.

> >> ...
> >>  
> >> -#ifndef CONFIG_X86_PAE
> >> -void vmalloc_sync_all(void)
> >> +void _vmalloc_sync_all(void)
> >>  {
> >>  	/*
> >>  	 * Note that races in the updates of insync and start aren't
> >> @@ -600,6 +599,8 @@ void vmalloc_sync_all(void)
> >>  	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
> >>  	static unsigned long start = TASK_SIZE;
> >>  	unsigned long address;
> >> +
> >> +	BUG_ON(SHARED_KERNEL_PMD);
> >>  
> >>  	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
> >>  	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
> >> @@ -623,4 +624,3 @@ void vmalloc_sync_all(void)
> >>  			start = address + PGDIR_SIZE;
> >>  	}
> >>  }
> >>     
> >
> > This is a functional change for non-paravirt kernels.  Non-PAE kernels now
> > get a vmalloc_sync_all().  How come?
> >   
> 
> You mean PAE kernels get a vmalloc_sync_all?

err, yes.

> When we're in PAE mode, but SHARED_KERNEL_PMD is false (which is true
> for Xen, but not for native execution), then the kernel mappings are not
> implicitly shared between processes.  This means that the vmalloc
> mappings are not shared, and so need to be explicitly synchronized
> between pagetables, like in the !PAE case.

head spins.

> > Your change clashes pretty fundamantally with
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch,
> > and
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/move-die-notifier-handling-to-common-code.patch
> > _does_ make the kernel prettier.
> >   
> 
> Hm, it doesn't look like a deep clash.  Dropping the inline function and
> just putting the "if (SHARED_KERNEL_PMD) return;" at the start of the
> real vmalloc_sync_all() would work fine.

Something like that.  I don't want to redo my patch if we're going to change
your patch ;)

> And I like vmalloc_sync_all() being a non-arch-specific interface; it
> cleans up another of the xen patches.

OK.

> > But I'm a bit reluctant to rework
> > move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
> > (somehow) until I understand why your patch is a) futzing with non-PAE,
> > non-paravirt code
> 
> There should be no functional difference for non-paravirt code, PAE or
> non-PAE.
> 
> >  and b) overengineered.
> >   
> 
> Overall, or just this bit?

this bit.

> > Why didn't you just stick a
> >
> > 	if (SHARED_KERNEL_PMD)
> > 		return;
> >
> > into vmalloc_sync_all()?
> >   
> 
> That would work, but when building !PARAVIRT && PAE, SHARED_KERNEL_PMD
> is just constant 1, so it would end up making a pointless function
> call.  With the wrapper, the call disappears entirely.  It probably
> doesn't matter, but I didn't want anyone to complain about making the
> !PARAVIRT generated code worse (hi, Ingo!).

vmalloc_sync_all() is a) tremendously slow and b) only called by
register_die_notifier().  We can afford to add a few cycles to it.

> However, if you're making vmalloc_sync_all a weak function anyway, then
> there's no difference with the paravirt patches in place.  The
> 
> 	if (SHARED_KERNEL_PMD)
> 		return;
> 
> will evaluate to
> 
> 	if (1)
> 		return;
> 

