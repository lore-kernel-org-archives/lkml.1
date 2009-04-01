Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZDAXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZDAXnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZDAXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:43:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZDAXnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:43:07 -0400
Date: Wed, 1 Apr 2009 19:42:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Maneesh Soni <maneesh@in.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu into
 spinlock
In-Reply-To: <20090327124532.GA9963@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0904011939170.30963@gandalf.stny.rr.com>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com>
 <20090327124532.GA9963@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Mar 2009, Maneesh Soni wrote:
> > Hi Steven,
> > 
> > I still the oops with the patch,
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> > PGD 1d68e9067 PUD 1e6cdf067 PMD 0 
> > Oops: 0000 [#1] SMP 
> > last sysfs file: /sys/devices/pci0000:0c/0000:0c:00.0/irq
> > CPU 5 
> > Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
> > Pid: 6095, comm: cat Not tainted 2.6.29-tip-test #2 eserver xSeries 366-[88632RA]-
> > RIP: 0010:[<ffffffff802d2259>]  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> > RSP: 0000:ffff8801e6d03ea0  EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff8800281989a0 RCX: 0000000000000046
> > RDX: ffff8800281989a0 RSI: ffffffff8020d56d RDI: ffffffff811de480
> > RBP: ffff8801e6d03ed0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000046
> > R13: ffff88022f232820 R14: 0000000000000000 R15: 0000000000000005
> > FS:  00007f98b94cb6e0(0000) GS:ffff88002818b000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000008 CR3: 0000000224595000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process cat (pid: 6095, threadinfo ffff8801e6d02000, task ffff8801d6935040)
> > Stack:
> >  ffff8801d6935040 ffff880224981230 ffff88002819dd40 0000003b4ae00aa0
> >  00007fffc14df830 ffff88002819dd40 ffff8801e6d03f70 ffffffff806f8264
> >  0000000000000002 ffff8801e6d03f48 ffff8801d6935040 ffff88022f232820
> > Call Trace:
> >  [<ffffffff806f8264>] schedule+0xd99/0x10f9
> >  [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> >  [<ffffffff8027d2cb>] ? delayed_work_timer_fn+0x0/0x38
> >  [<ffffffff8020d56d>] retint_careful+0x12/0x2e
> > Code: 2d ad de f2 00 75 77 48 63 05 ac de f2 00 48 8b 4d 00 45 89 f0 48 8b 3d 8e de f2 00 48 8b 71 08 48 8b 5c c7 28 48 8b 01 4c 89 e1 <48> 8b 50 08 e8 f6 9f ff ff 48 8b 3d 6f de f2 00 48 8b 75 d0 45 
> > RIP  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> >  RSP <ffff8801e6d03ea0>
> > CR2: 0000000000000008
> > 


> 0xffffffff802d2208 <probe_wakeup_sched_switch+129>:	lock xadd %ax,0xf2debf(%rip)        # 0xffffffff812000d0 <wakeup_lock>
> 0xffffffff802d2211 <probe_wakeup_sched_switch+138>:	cmp    %ah,%al
> 0xffffffff802d2213 <probe_wakeup_sched_switch+140>:	je     0xffffffff802d221f <probe_wakeup_sched_switch+152>
> 0xffffffff802d2215 <probe_wakeup_sched_switch+142>:	pause  
> 0xffffffff802d2217 <probe_wakeup_sched_switch+144>:	mov    0xf2deb3(%rip),%al        # 0xffffffff812000d0 <wakeup_lock>
> 0xffffffff802d221d <probe_wakeup_sched_switch+150>:	jmp    0xffffffff802d2211 <probe_wakeup_sched_switch+138>
> 0xffffffff802d221f <probe_wakeup_sched_switch+152>:	cmpl   $0x0,0x9fb02a(%rip)        # 0xffffffff80ccd250 <tracer_enabled>
> 0xffffffff802d2226 <probe_wakeup_sched_switch+159>:	je     0xffffffff802d22ac <probe_wakeup_sched_switch+293>
> 0xffffffff802d222c <probe_wakeup_sched_switch+165>:	cmp    0xf2dead(%rip),%r13        # 0xffffffff812000e0 <wakeup_task>
> 0xffffffff802d2233 <probe_wakeup_sched_switch+172>:	jne    0xffffffff802d22ac <probe_wakeup_sched_switch+293>
> 0xffffffff802d2235 <probe_wakeup_sched_switch+174>:	movslq 0xf2deac(%rip),%rax        # 0xffffffff812000e8 <wakeup_cpu>
> 0xffffffff802d223c <probe_wakeup_sched_switch+181>:	mov    0x0(%rbp),%rcx
> 0xffffffff802d2240 <probe_wakeup_sched_switch+185>:	mov    %r14d,%r8d
> 0xffffffff802d2243 <probe_wakeup_sched_switch+188>:	mov    0xf2de8e(%rip),%rdi        # 0xffffffff812000d8 <wakeup_trace>
> 0xffffffff802d224a <probe_wakeup_sched_switch+195>:	mov    0x8(%rcx),%rsi
> 0xffffffff802d224e <probe_wakeup_sched_switch+199>:	mov    0x28(%rdi,%rax,8),%rbx
> 0xffffffff802d2253 <probe_wakeup_sched_switch+204>:	mov    (%rcx),%rax
> 0xffffffff802d2256 <probe_wakeup_sched_switch+207>:	mov    %r12,%rcx
> 0xffffffff802d2259 <probe_wakeup_sched_switch+210>:	mov    0x8(%rax),%rdx   <<<<<<<<<===================== Here.
> 0xffffffff802d225d <probe_wakeup_sched_switch+214>:	callq  0xffffffff802cc258 <trace_function>
> 0xffffffff802d2262 <probe_wakeup_sched_switch+219>:	mov    0xf2de6f(%rip),%rdi        # 0xffffffff812000d8 <wakeup_trace>
> 0xffffffff802d2269 <probe_wakeup_sched_switch+226>:	mov    -0x30(%rbp),%rsi
> 0xffffffff802d226d <probe_wakeup_sched_switch+230>:	mov    %r14d,%r8d
> 0xffffffff802d2270 <probe_wakeup_sched_switch+233>:	mov    %r13,%rdx
> 0xffffffff802d2273 <probe_wakeup_sched_switch+236>:	mov    %r12,%rcx
> 0xffffffff802d2276 <probe_wakeup_sched_switch+239>:	callq  0xffffffff802cd5b---Type <return> to continue, or q <return> to quit---
> 2 <tracing_sched_switch_trace>



> It seems CALLER_ADDR is not correct? 


Hi Maneesh,

Could you try this patch and see if it keeps your system from crashing?

Thanks,

-- Steve

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a331ec3..dbf3f8f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -917,10 +917,15 @@ retint_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq %rdi
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq %rbp
+	call  1f
+1:	mov  %rsp, %rbp
+	CFI_ADJUST_CFA_OFFSET	24
 	call  schedule
+	addq $8, %rsp /* skip call */
+	popq %rbp
 	popq %rdi
-	CFI_ADJUST_CFA_OFFSET	-8
+	CFI_ADJUST_CFA_OFFSET	-24
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
