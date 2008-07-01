Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbYGASr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbYGASr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYGASrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:47:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52528 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755039AbYGASre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:47:34 -0400
Message-ID: <486A7BC4.7010204@sgi.com>
Date: Tue, 01 Jul 2008 11:47:32 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [RFC 0/5] percpu: Optimize percpu accesses
References: <20080701121634.865966000@polaris-admin.engr.sgi.com> <20080701145417.GB18522@elte.hu> <20080701150313.GA30476@elte.hu>
In-Reply-To: <20080701150313.GA30476@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> 
> full bootlog and config can be found at:
> 
>   http://redhat.com/~mingo/misc/crashlog-Tue_Jul__1_16_48_45_CEST_2008.bad
>   http://redhat.com/~mingo/misc/config-Tue_Jul__1_16_48_45_CEST_2008.bad
> 
> (another 64-bit testbox crashed as well, so this should be readily 
> reproducible.)
> 
> i've pushed this tree out to tip/tmp.core/percpu-zerobased.Jul__1_16_48 
> topic branch, that is the 2.6.26-rc8-tip-00250-g90874b0 kernel you can 
> see in the crashlog.
> 
> 	Ingo

Ok, two problems here.  First, it's getting a stack overflow (proved by
increasing THREAD_ORDER to 4 [probably 2 would work as well.])

Second, the following change caused the panic below.  I'll dissect the
object code to see if I can spot the problem.  It does sounds a bit like
the previous discussion in this thread:

"Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference"

About the stack overflow, the largest users are listed last (this is after
applying the "sched: Reduce stack size in isolated_cpu_setup()" patch which
I just sent.)  My gcc (4.2.0) says this for "stackprotector".

#warning You have selected the CONFIG_CC_STACKPROTECTOR option, 
but the gcc used does not support this.

... is there a known version where this _is_ supported?  Or any other
advice on tracking this down?

[I did take your advice and broke out every change in the last patch of the
patchset into individual patches.  Was fairly easy in this case, and pinpointed
the failing change very quickly.]

Thanks!
Mike

---
 include/asm-x86/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/include/asm-x86/thread_info.h	2008-07-01 10:41:33.000000000 -0700
+++ linux-2.6.tip/include/asm-x86/thread_info.h	2008-07-01 10:49:15.172370813 -0700
@@ -200,7 +200,8 @@ static inline struct thread_info *curren
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
+	ti = (void *)(x86_read_percpu(pda.kernelstack) +
+						PDA_STACKOFFSET - THREAD_SIZE);
 	return ti;
 }
 
ccessful
[    0.188000] CPU0: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    0.199685] Using local APIC timer interrupts.
[    0.208000] APIC timer calibration result 20781829
[    0.212000] Detected 20.781 MHz APIC timer.
[    0.216000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[    0.216000] IP: [<0000000000000000>]
[    0.216000] PGD 0
[    0.216000] Oops: 0010 [1] SMP
[    0.216000] CPU 0
[    0.216000] Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip-ingo-bad-0701-00208-g79a4d68-dirty #17
[    0.216000] RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
[    0.216000] RSP: 0000:ffff81022ed1fe18  EFLAGS: 00010282
[    0.216000] RAX: 0000000000000001 RBX: ffff81022ed1fe84 RCX: ffffffff80ca6750
[    0.216000] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffffffff80ca6750
[    0.216000] RBP: ffff81022ed1fe50 R08: 0000000000000000 R09: ffff8100010ff710
[    0.216000] R10: ffff8100010ed740 R11: 0000000000000000 R12: 00000000fffffffd
[    0.216000] R13: ffffffff80ca7790 R14: 0000000000000001 R15: 0000000000000003
[    0.216000] FS:  0000000000000000(0000) GS:ffff8100010eb000(0000) knlGS:0000000000000000
[    0.216000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.216000] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[    0.216000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.216000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.216000] Process swapper (pid: 1, threadinfo ffff81022ed10000, task ffff81022ec930e0)
[    0.216000] Stack:  ffffffff8024b800 0000000000000000 0000000000000001 0000000000000001
[    0.216000]  00000000fffffff0 ffffffff80e263a0 0000000000092fd0 ffff81022ed1fe60
[    0.216000]  ffffffff8024b880 ffff81022ed1fea0 ffffffff808e8526 0000000000000008
[    0.216000] Call Trace:
[    0.216000]  [<ffffffff8024b800>] ? notifier_call_chain+0x38/0x60
[    0.216000]  [<ffffffff8024b880>] __raw_notifier_call_chain+0xe/0x10
[    0.216000]  [<ffffffff808e8526>] cpu_up+0xa8/0x138
[    0.216000]  [<ffffffff80ded993>] kernel_init+0xcf/0x316
[    0.216000]  [<ffffffff8020d458>] child_rip+0xa/0x12
[    0.216000]  [<ffffffff8020c8f5>] ? restore_args+0x0/0x30
[    0.216000]  [<ffffffff80ded8c4>] ? kernel_init+0x0/0x316
[    0.216000]  [<ffffffff8020d44e>] ? child_rip+0x0/0x12
[    0.216000]
[    0.216000]
[    0.216000] Code:  Bad RIP value.
[    0.216000] RIP  [<0000000000000000>]
[    0.216000]  RSP <ffff81022ed1fe18>
[    0.216000] CR2: 0000000000000000

Stack usages >= 1000 bytes:

2184 __build_sched_domains
2056 kthreadd
1576 tick_notify
1576 setup_IO_APIC_irq
1576 move_task_off_dead_cpu
1560 arch_setup_ht_irq
1560 __assign_irq_vector
1544 tick_handle_oneshot_broadcast
1352 zc0301_ioctl_v4l2
1336 i2o_cfg_compat_ioctl
1192 sn9c102_ioctl_v4l2
1152 e1000_check_options
1128 setup_IO_APIC
1096 _cpu_down
1080 sched_balance_self
1080 do_ida_request
1064 native_smp_call_function_mask
1048 setup_timer_IRQ0_pin
1048 setup_ioapic_dest
1048 set_ioapic_affinity_irq
1048 set_ht_irq_affinity
1048 sched_rt_period_timer
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

