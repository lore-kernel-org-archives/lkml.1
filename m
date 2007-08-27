Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbXH0Uhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbXH0Uhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbXH0UhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:37:22 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46594 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXH0UhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:37:20 -0400
Date: Mon, 27 Aug 2007 21:37:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bogus hotplug cpu warning
In-Reply-To: <20070827111802.8d0a675b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708272126050.29594@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
 <20070827111802.8d0a675b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Andrew Morton wrote:
> On Mon, 27 Aug 2007 16:06:19 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online after
> > bootup: current_is_keventd is right to note its use of smp_processor_id
> > is preempt-safe, but should use raw_smp_processor_id to avoid the warning.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > 
> > --- 2.6.23-rc3-git10/kernel/workqueue.c	2007-07-26 19:49:58.000000000 +0100
> > +++ linux/kernel/workqueue.c	2007-08-26 18:59:16.000000000 +0100
> > @@ -635,7 +635,7 @@ int keventd_up(void)
> >  int current_is_keventd(void)
> >  {
> >  	struct cpu_workqueue_struct *cwq;
> > -	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */
> > +	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
> >  	int ret = 0;
> >  
> >  	BUG_ON(!keventd_wq);
> 
> But lib/smp_processor_id.c:debug_smp_processor_id() does
> 
> 	/*
> 	 * Kernel threads bound to a single CPU can safely use
> 	 * smp_processor_id():
> 	 */
> 	this_mask = cpumask_of_cpu(this_cpu);
> 
> 	if (cpus_equal(current->cpus_allowed, this_mask))
> 		goto out;
> 
> So I assume that this warning was triggering because some non-keventd,
> non-pinned task is calling current_is_keventd()?

That's right, the x86_64 (and the ia64) do_boot_cpu() functions (called
when onlining a cpu) do a check on current_is_keventd(): commented thus
 * During cold boot process, keventd thread is not spun up yet.
 * When we do cpu hot-add, we create idle threads on the fly, we should
 * not acquire any attributes from the calling context. Hence the clean
 * way to create kernel_threads() is to do that from keventd().
 * We do the current_is_keventd() due to the fact that ACPI notifier
 * was also queuing to keventd() and when the caller is already running
 * in context of keventd(), we would end up with locking up the keventd
 * thread.
though I've not tried to think that through.

> So I agree with the patch, but not with its description.

I don't see which part of the description you disagree with, but please
do improve it if you can.  The actual trace (when powersaved was saving
power by onlining a cpu I'd tried to exclude with maxcpus=1 ;) was this:

 BUG: using smp_processor_id() in preemptible [00000001] code: powersaved/3368
 caller is current_is_keventd+0x9/0x3d
 
 Call Trace:
  [<ffffffff8031e5f5>] debug_smp_processor_id+0xc1/0xd4
  [<ffffffff802453f3>] current_is_keventd+0x9/0x3d
  [<ffffffff80219c9b>] do_boot_cpu+0x19e/0x3c9
  [<ffffffff80219ad4>] do_fork_idle+0x0/0x29
  [<ffffffff80219fb7>] __cpu_up+0xd4/0x107
  [<ffffffff80252932>] _cpu_up+0xd9/0x17a
  [<ffffffff80252a09>] cpu_up+0x36/0x4d
  [<ffffffff8038f7ca>] store_online+0x52/0x81
  [<ffffffff8038b575>] sysdev_store+0x3c/0x3e
  [<ffffffff802cfed4>] flush_write_buffer+0x63/0x81
  [<ffffffff802cff5b>] sysfs_write_file+0x69/0x8f
  [<ffffffff8046e5d9>] _spin_unlock_irqrestore+0x16/0x30
  [<ffffffff8028aea3>] vfs_write+0xc5/0x186
  [<ffffffff8024c180>] up_write+0xd/0xf
  [<ffffffff8028b02f>] sys_write+0x51/0x7a
  [<ffffffff8020bc5e>] system_call+0x7e/0x83

Hugh
