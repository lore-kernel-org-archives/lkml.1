Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYGIOhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYGIOhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYGIOhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:37:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38477 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbYGIOhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:37:24 -0400
Message-ID: <4874CD22.20502@sgi.com>
Date: Wed, 09 Jul 2008 07:37:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com> <m1r6a4c5im.fsf@frodo.ebiederm.org>
In-Reply-To: <m1r6a4c5im.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Unfortunately it's back to the problem of faulting before x86_64_start_kernel()
>> and grub just immediately reboots.  So I'm back at analyzing assembler and
>> config differences.
> 
> Ok.  That is a narrow window of code.  So it shouldn't be too bad, nasty though.
> 
> If you would like to trace through it I have attached my serial port
> debugging routines that I use in that part of the code.
> 
> Eric
> 
> 

Very cool, thanks!!!  I will start using this.  (I have been using the trick
to replace printk with early_printk so messages come out immediately instead
of from the log buf.)

I've been able to make some more progress.  I've gotten to a point where it
panics from stack overflow.  I've verified this by bumping THREAD_ORDER and
it boots fine.  Now tracking down stack usages.  (I have found a couple of new
functions using set_cpus_allowed(..., CPU_MASK_ALL) instead of
set_cpus_allowed_ptr(... , CPU_MASK_ALL_PTR).  But these are not in the calling
sequence so subsequently are not the cause.

One weird thing is early_idt_handler seems to have been called and that's one
thing our simulator does not mimic for standard Intel FSB systems - early pending
interrupts.  (It's designed after all to mimic our h/w, and of course it's been
booting fine under that environment.) 

Two patches are in the queue to reduce this stack usage:

	Subject: [PATCH 1/1] sched: Reduce stack size in isolated_cpu_setup()
	Subject: [PATCH 1/1] kthread: Reduce stack pressure in create_kthread and kthreadd

The other stack pigs are:

1640 sched_domain_node_span
1576 tick_notify
1576 setup_IO_APIC_irq
1576 move_task_off_dead_cpu
1560 arch_setup_ht_irq
1560 __assign_irq_vector
1544 tick_handle_oneshot_broadcast
1352 zc0301_ioctl_v4l2
1336 i2o_cfg_compat_ioctl
1192 sn9c102_ioctl_v4l2
1176 __build_sched_domains
1152 e1000_check_options
1144 __build_all_zonelists
1128 setup_IO_APIC
1096 sched_balance_self
1096 _cpu_down
1080 do_ida_request
1064 sched_rt_period_timer
1064 native_smp_call_function_mask
1048 setup_timer_IRQ0_pin
1048 setup_ioapic_dest
1048 set_ioapic_affinity_irq
1048 set_ht_irq_affinity
1048 pci_device_probe
1048 native_machine_crash_shutdown
1032 tick_do_periodic_broadcast
1032 sched_setaffinity
1032 native_flush_tlb_others
1032 local_cpus_show
1032 local_cpulist_show
1032 irq_select_affinity
1032 irq_complete_move
1032 irq_affinity_write_proc
1032 ioapic_retrigger_irq
1032 flush_tlb_mm
1032 flush_tlb_current_task
1032 fixup_irqs
1032 do_cciss_request
1032 create_irq
1024 uv_vector_allocation_domain
1024 uv_send_IPI_allbutself
1024 smp_call_function_single
1024 smp_call_function
1024 physflat_send_IPI_allbutself
1024 pci_bus_show_cpuaffinity
1024 move_masked_irq
1024 flush_tlb_page
1024 flat_send_IPI_allbutself
1000 security_load_policy

Only a few of these though I would think might get called early in
the boot, that might also be contributing to the stack overflow.

Oh yeah, I looked very closely at the differences in the assembler
for vmlinux when compiled with 4.2.0 (fails) and 4.2.4 (which boots
with the above mentioned THREAD_ORDER change) and except for some
weirdness around ident_complete it seems to be the same code.  But
the per_cpu variables are in a completely different address order.
I wouldn't think that the -j10 for make could cause this but I can
verify that with -j1.  But in any case, I'm sticking with 4.2.4 for
now.

Thanks,
Mike
