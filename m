Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZA2XGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZA2XGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZA2XGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:06:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZA2XGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:06:03 -0500
Subject: Re: 2.6.28-rt on PowerPC
From: Steven Rostedt <srostedt@redhat.com>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 29 Jan 2009 18:00:43 -0500
Message-Id: <1233270043.3833.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-01-30 at 00:34 +0300, Anton Vorontsov wrote:
> Hi Steven,
> 
> I know 2.6.28-rt isn't yet ready, but I could not resist to try
> it anyway. ;-)
> 
> Here are few issues and ways to solve them:
> 
> Currently the -rt tree doesn't link for arch/powerpc:
> 
>   LD      .tmp_vmlinux1
>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>   (.text+0x27bc): undefined reference to `__call_bad_lock_func'
>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>   (.text+0x28b0): undefined reference to `__call_bad_lock_func'
>   make: *** [.tmp_vmlinux1] Error 1

Thanks! I have not yet had the chance to apply any arch patches yet. I
do plan on doing so after getting the code mostly working on x86.

> 
> This can be trivially fixed:
> 
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 838857f..cc7dd12 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -183,7 +183,7 @@ int show_interrupts(struct seq_file *p, void *v)
>  
>  	if (i < NR_IRQS) {
>  		desc = get_irq_desc(i);
> -		acquire_lock_irqsave(&desc->lock, flags);
> +		spin_lock_irqsave(&desc->lock, flags);
>  		action = desc->action;
>  		if (!action || !action->handler)
>  			goto skip;
> @@ -204,7 +204,7 @@ int show_interrupts(struct seq_file *p, void *v)
>  			seq_printf(p, ", %s", action->name);
>  		seq_putc(p, '\n');
>  skip:
> -		release_lock_irqrestore(&desc->lock, flags);
> +		spin_unlock_irqrestore(&desc->lock, flags);
>  	} else if (i == NR_IRQS) {
>  #if defined(CONFIG_PPC32) && defined(CONFIG_TAU_INT)
>  		if (tau_initialized){
> 
> --
> 
> 
> 
> While booting, this bug appears:
> 
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> in_atomic(): 1 [00010001], irqs_disabled(): 1, pid: 1, name: swapper
> Call Trace:
> [cf82f9a0] [c0008be8] show_stack+0x4c/0x16c (unreliable)
> [cf82f9e0] [c001c184] __might_sleep+0xd8/0xf8
> [cf82f9f0] [c02b7758] rt_spin_lock+0x30/0x78
> [cf82fa00] [c001853c] ipic_mask_irq+0x3c/0xb0
> [cf82fa20] [c0054064] handle_level_irq+0x40/0x178
> [cf82fa40] [c00068ec] do_IRQ+0x68/0xe0
> [cf82fa50] [c0012924] ret_from_except+0x0/0x14
> --- Exception: 501 at internal_add_timer+0x4/0xe0
> 
> This is trivially solved by converting arch/powerpc/sysdev/ipic.c
> back to spinlocks (ipic_lock).
> 
> Assuming that converting-back is automatic, there are few other
> chained interrupt controllers you might want to convert-back:
> 
> arch/powerpc/sysdev/i8259.c (i8259_lock)
> arch/powerpc/sysdev/mpic.c (mpic_lock)
> arch/powerpc/sysdev/qe_lib/qe_ic.c (qe_ic_lock)

Thanks! I'll add them to the file:

	scripts/convert-locks-list


> 
> 
> 
> After this, kernel boots up to the userspace, but then bugs in the
> middle (note: this is NFS boot, network activity etc.)...
> 
> INIT: version 2.86 booting
> Starting the hotplug events dispatcher: udevd.
> Synthesizing the initial hotplug events...done.
> Waiting for /dev to be fully populated...done.
> Activating swap...done.
> Remounting root filesystem...done.
> Checking all file systems: fsck
> fsck 1.40 (29-Jun-2007)
> Checking SELinux contexts: selinux-basics.
> Starting network interfaces: done.
> Starting portmap daemon....
> Cleaning: /tmp /var/lock /var/run done.
> Setting pseudo-terminal access permissions...done.
> Updating /etc/motd...done.
> INIT: Entering runlevel: 3
> Starting irqbalance.
> Starting system log daemon: syslogd
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> in_atomic(): 1 [00000100], irqs_disabled(): 0, pid: 7, name: sirq-net-rx/0
> Call Trace:
> [cf84bc20] [c0008be8] show_stack+0x4c/0x16c (unreliable)
> [cf84bc60] [c001c194] __might_sleep+0xd8/0xf8
> [cf84bc70] [c02b7768] rt_spin_lock+0x30/0x78
> [cf84bc80] [c00800e0] kmem_cache_alloc+0x50/0x17c
> [cf84bcb0] [c02568a4] ip_append_data+0x974/0x978
> [cf84bd30] [c027aa0c] icmp_push_reply+0x54/0x128
> [cf84bd50] [c027b59c] icmp_send+0x284/0x380
> [cf84be40] [c0277328] __udp4_lib_rcv+0x3d4/0x5a0
> [cf84bea0] [c0253208] ip_local_deliver_finish+0x74/0x128
> [cf84bec0] [c0252fd0] ip_rcv_finish+0x148/0x30c
> [cf84bf00] [c0236774] netif_receive_skb+0x21c/0x2e8
> [cf84bf30] [c0238ecc] process_backlog+0x98/0x138
> [cf84bf60] [c0238b24] net_rx_action+0xd4/0x198
> [cf84bf90] [c002989c] ksoftirqd+0x108/0x23c
> [cf84bfd0] [c003c918] kthread+0x48/0x84
> [cf84bff0] [c00120b0] kernel_thread+0x4c/0x68
> BUG: scheduling while atomic: sirq-net-rx/0/7/0x10000101, CPU#0
> Modules linked in:
> Call Trace:
> [cf84bee0] [c0008be8] show_stack+0x4c/0x16c (unreliable)
> [cf84bf20] [c001e418] __schedule_bug+0x6c/0x80
> [cf84bf30] [c02b5fdc] schedule+0x2e8/0x31c
> [cf84bf70] [c001e460] __cond_resched+0x34/0x60
> [cf84bf80] [c02b6348] _cond_resched+0x50/0x58
> [cf84bf90] [c00298b8] ksoftirqd+0x124/0x23c
> [cf84bfd0] [c003c918] kthread+0x48/0x84
> [cf84bff0] [c00120b0] kernel_thread+0x4c/0x68

Turn on CONFIG_PREEMPT_TRACE (not TRACER) and it should show the
location that left preemption disabled.

> 
> 
> And now this looks like not PowerPC specific... Converting mm/slab.c
> back to spinlocks results in another, but similar bug in anther mm
> routine:

Oh, mm/slab.c should not have spinlocks.

> 
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> in_atomic(): 1 [00000001], irqs_disabled(): 0, pid: 1003, name: net.agent
> Call Trace:
> [cf057c40] [c0008be8] show_stack+0x4c/0x16c (unreliable)
> [cf057c80] [c001c194] __might_sleep+0xd8/0xf8
> [cf057c90] [c02b7768] rt_spin_lock+0x30/0x78
> [cf057ca0] [c005d0ec] free_hot_cold_page+0xf8/0x35c
> [cf057cc0] [c007f0b0] kmem_freepages+0xd8/0x134
> [cf057cd0] [c007f620] slab_destroy+0x38/0xe0
> [cf057cf0] [c007f814] free_block+0x14c/0x158
> [cf057d30] [c007f174] cache_flusharray+0x68/0x150
> [cf057d60] [c007f4fc] kmem_cache_free+0x110/0x140
> [cf057d80] [c006eb04] remove_vma+0x78/0xc0
> [cf057d90] [c006eccc] exit_mmap+0x180/0x208
> [cf057dc0] [c00210c8] mmput+0x64/0x114
> [cf057de0] [c008b580] exec_mmap+0xd8/0x1b4
> [cf057e10] [c008b7c4] flush_old_exec+0x50/0x1d0
> [cf057e40] [c00c2fac] load_elf_binary+0x2b0/0x96c
> [cf057eb0] [c008ad6c] search_binary_handler+0xf4/0x31c
> [cf057ef0] [c008c220] do_execve+0x1b4/0x1ec
> [cf057f20] [c000983c] sys_execve+0x50/0x7c
> [cf057f40] [c001228c] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfeab104
>     LR = 0x10024540
> 
> ..proves that "convert-back" trick isn't panacea. ;-) So, before
> I'll dig into this.. is this known issue? Any ideas of proper
> fixing?
> 
> FWIW, following options enabled:
> 
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_PREEMPT_RT=y
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_PREEMPT_SOFTIRQS=y
> CONFIG_PREEMPT_HARDIRQS=y
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_SLAB=y
> CONFIG_SLABINFO=y
> # CONFIG_HIGHMEM is not set
> 
> Thanks,
> 
> p.s. Btw, having the convert-back script in scripts/ would be
> useful. Could not find it anywhere.

It is, but it is called convert-locks-list ;-)
Yeah, you can blame me for bad naming.

-- Steve


