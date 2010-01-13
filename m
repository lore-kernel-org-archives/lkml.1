Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290Ab0AMSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0AMSo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328Ab0AMSo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:44:28 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:35675 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0AMSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:44:26 -0500
Date: Wed, 13 Jan 2010 13:43:45 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: 2.6.33rc4 RCU hang mm spin_lock deadlock(?) after running libvirtd -
 reproducible.
In-reply-to: <20100112014909.GB10869@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Message-id: <4B4E1461.4010806@majjas.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_lvPnfRe27lfwB+3pLSDaIg)"
References: <4B49015D.9000903@majjas.com> <4B4A341B.6010800@majjas.com>
 <20100112014909.GB10869@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_lvPnfRe27lfwB+3pLSDaIg)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

[Originally posted as: "Re: 2.6.33RC3 libvirtd ->sky2 & rcu oops (was 
Sky2 oops - Driver    tries to sync DMA memory it has not allocated)"]

On 1/11/2010 8:49 PM, Paul E. McKenney wrote:
> On Sun, Jan 10, 2010 at 03:10:03PM -0500, Michael Breuer wrote:
>    
>> On 1/9/2010 5:21 PM, Michael Breuer wrote:
>>      
>>> Hi,
>>>
>>> Attempting to move back to mainline after my recent 2.6.32 issues...
>>> Config is make oldconfig from working 2.6.32 config. Patch for af_packet.c
>>> (for skb issue found in 2.6.32) included. Attaching .config and NMI
>>> backtraces.
>>>
>>> System becomes unusable after bringing up the network:
>>>
>>> ...
> RCU stall warnings are usually due to an infinite loop somewhere in the
> kernel.  If you are running !CONFIG_PREEMPT, then any infinite loop not
> containing some call to schedule will get you a stall warning.  If you
> are running CONFIG_PREEMPT, then the infinite loop is in some section of
> code with preemption disabled (or irqs disabled).
>
> The stall-warning dump will normally finger one or more of the CPUs.
> Since you are getting repeated warnings, look at the stacks and see
> which of the most-recently-called functions stays the same in successive
> stack traces.  This information should help you finger the infinite (or
> longer than average) loop.
> ...
>    
I can now recreate this simply by "service start libvirtd" on an F12 
box. My earlier report that suggested this had something to do with the 
sky2 driver was incorrect. Interestingly, it's always CPU1 whenever I 
start libvirtd.
Attaching two of the traces (I've got about ten, but they're all pretty 
much the same). Looks pretty consistent - libvirtd in CPU1 is hung 
forking. Not sure why yet - perhaps someone who knows this better than I 
can jump in.
Summary of hang appears to be libvirtd forks - two threads show with 
same pid deadlocked on a spin_lock
> Then if looking at the stack traces doesn't locate the offending loop,
> bisection might help.
>    
It would, however it's going to be really difficult as I wasn't able to 
get this far with rc1 & rc2 :(
> 							Thanx, Paul
>
>    
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>      


--Boundary_(ID_lvPnfRe27lfwB+3pLSDaIg)
Content-type: text/plain; name=stall1
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=stall1

Jan 13 12:59:25 mail kernel: INFO: RCU detected CPU 1 stall (t=10000 jiffies)
Jan 13 12:59:25 mail kernel: sending NMI to all CPUs:
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 4
Jan 13 12:59:25 mail kernel: CPU 4 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff8803325b5e38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff8803325b5fd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff8803325b5e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2a90f9 R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 0000003a542a5010 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325b4000, task ffff8803325b8000)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff88032eb285a8 ffff88032eb28000 ffff8803325b5e58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff8803325b5e78 ffffffff812ab088 000000004b4e09fd ffff88032eb285a8
Jan 13 12:59:25 mail kernel: <0> ffff8803325b5ed8 ffffffff812ab348 0000000000000000 0000000000000322
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 1
Jan 13 12:59:25 mail kernel: CPU 1 
Jan 13 12:59:25 mail kernel: Pid: 7809, comm: libvirtd Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff812560d8>]  [<ffffffff812560d8>] __const_udelay+0x37/0x44
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff880028223dc8  EFLAGS: 00000002
Jan 13 12:59:25 mail kernel: RAX: 0000000001062560 RBX: 0000000000000001 RCX: ffff880028220000
Jan 13 12:59:25 mail kernel: RDX: 0000000027d22b08 RSI: 0000000000000002 RDI: 0000000000418958
Jan 13 12:59:25 mail kernel: RBP: ffff880028223dc8 R08: ffff880028223ce8 R09: 0000000000000000
Jan 13 12:59:25 mail kernel: R10: 0000000000000004 R11: ffff880330e1de00 R12: ffff8800282303f0
Jan 13 12:59:25 mail kernel: R13: ffffffff81a50600 R14: ffff880028223f48 R15: ffff880028223f48
Jan 13 12:59:25 mail kernel: FS:  00007fbdf8da27e0(0000) GS:ffff880028220000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 00000000004479d0 CR3: 00000002d525f000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process libvirtd (pid: 7809, threadinfo ffff8802a726c000, task ffff8802ba04c680)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff880028223de8 ffffffff810206eb ffffffff91a24769 ffffffff81a50600
Jan 13 12:59:25 mail kernel: <0> ffff880028223e38 ffffffff8109814b 00000000000103c0 ffff8802a726da38
Jan 13 12:59:25 mail kernel: <0> ffff880028223e58 0000000000000001 0000000000000001 0000000000000000
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <IRQ> 
Jan 13 12:59:25 mail kernel: [<ffffffff810206eb>] arch_trigger_all_cpu_backtrace+0x57/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff8109814b>] __rcu_pending+0x6e/0x2a5
Jan 13 12:59:25 mail kernel: [<ffffffff810983b7>] rcu_check_callbacks+0x35/0x10a
Jan 13 12:59:25 mail kernel: [<ffffffff81057b37>] update_process_times+0x41/0x5c
Jan 13 12:59:25 mail kernel: [<ffffffff81071cba>] tick_sched_timer+0x77/0xa0
Jan 13 12:59:25 mail kernel: [<ffffffff81067f08>] __run_hrtimer+0xb8/0x117
Jan 13 12:59:25 mail kernel: [<ffffffff81071c43>] ? tick_sched_timer+0x0/0xa0
Jan 13 12:59:25 mail kernel: [<ffffffff81068187>] hrtimer_interrupt+0xc7/0x1b5
Jan 13 12:59:25 mail kernel: [<ffffffff814575c6>] ? trace_hardirqs_off_thunk+0x3a/0x6c
Jan 13 12:59:25 mail kernel: [<ffffffff8145cb14>] smp_apic_timer_interrupt+0x81/0x94
Jan 13 12:59:25 mail kernel: [<ffffffff8100a5d3>] apic_timer_interrupt+0x13/0x20
Jan 13 12:59:25 mail kernel: <EOI> 
Jan 13 12:59:25 mail kernel: [<ffffffff810447be>] ? set_cpus_allowed_ptr+0x22/0x14b
Jan 13 12:59:25 mail kernel: [<ffffffff810f2a7b>] ? spin_lock+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff81087d79>] cpuset_attach_task+0x27/0x9b
Jan 13 12:59:25 mail kernel: [<ffffffff81087e77>] cpuset_attach+0x8a/0x133
Jan 13 12:59:25 mail kernel: [<ffffffff81042d2c>] ? sched_move_task+0x104/0x110
Jan 13 12:59:25 mail kernel: [<ffffffff81085dbd>] cgroup_attach_task+0x4e1/0x53f
Jan 13 12:59:25 mail kernel: [<ffffffff81084f48>] ? cgroup_populate_dir+0x77/0xff
Jan 13 12:59:25 mail kernel: [<ffffffff81086073>] cgroup_clone+0x258/0x2ac
Jan 13 12:59:25 mail kernel: [<ffffffff81088d04>] ns_cgroup_clone+0x58/0x75
Jan 13 12:59:25 mail kernel: [<ffffffff81048f3d>] copy_process+0xcef/0x13af
Jan 13 12:59:25 mail kernel: [<ffffffff810d963c>] ? handle_mm_fault+0x355/0x7ff
Jan 13 12:59:25 mail kernel: [<ffffffff81049768>] do_fork+0x16b/0x309
Jan 13 12:59:25 mail kernel: [<ffffffff81252ab2>] ? __up_read+0x8e/0x97
Jan 13 12:59:25 mail kernel: [<ffffffff81068c92>] ? up_read+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff8145a779>] ? do_page_fault+0x280/0x2cc
Jan 13 12:59:25 mail kernel: [<ffffffff81010f2e>] sys_clone+0x28/0x2a
Jan 13 12:59:25 mail kernel: [<ffffffff81009f33>] stub_clone+0x13/0x20
Jan 13 12:59:25 mail kernel: [<ffffffff81009bf2>] ? system_call_fastpath+0x16/0x1b
Jan 13 12:59:25 mail kernel: Code: 80 56 01 00 48 8d 04 bd 00 00 00 00 65 8b 0c 25 38 e3 00 00 48 63 c9 48 8b 0c cd 20 fa ad 81 48 69 94 0a 98 00 00 00 fa 00 00 00 <f7> e2 48 8d 7a 01 e8 ad ff ff ff c9 c3 55 48 89 e5 0f 1f 44 00 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 7809, comm: libvirtd Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff812560d8>] ? __const_udelay+0x37/0x44
Jan 13 12:59:25 mail kernel: <<EOE>>  <IRQ>  [<ffffffff810206eb>] arch_trigger_all_cpu_backtrace+0x57/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff8109814b>] __rcu_pending+0x6e/0x2a5
Jan 13 12:59:25 mail kernel: [<ffffffff810983b7>] rcu_check_callbacks+0x35/0x10a
Jan 13 12:59:25 mail kernel: [<ffffffff81057b37>] update_process_times+0x41/0x5c
Jan 13 12:59:25 mail kernel: [<ffffffff81071cba>] tick_sched_timer+0x77/0xa0
Jan 13 12:59:25 mail kernel: [<ffffffff81067f08>] __run_hrtimer+0xb8/0x117
Jan 13 12:59:25 mail kernel: [<ffffffff81071c43>] ? tick_sched_timer+0x0/0xa0
Jan 13 12:59:25 mail kernel: [<ffffffff81068187>] hrtimer_interrupt+0xc7/0x1b5
Jan 13 12:59:25 mail kernel: [<ffffffff814575c6>] ? trace_hardirqs_off_thunk+0x3a/0x6c
Jan 13 12:59:25 mail kernel: [<ffffffff8145cb14>] smp_apic_timer_interrupt+0x81/0x94
Jan 13 12:59:25 mail kernel: [<ffffffff8100a5d3>] apic_timer_interrupt+0x13/0x20
Jan 13 12:59:25 mail kernel: <EOI>  [<ffffffff810447be>] ? set_cpus_allowed_ptr+0x22/0x14b
Jan 13 12:59:25 mail kernel: [<ffffffff810f2a7b>] ? spin_lock+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff81087d79>] cpuset_attach_task+0x27/0x9b
Jan 13 12:59:25 mail kernel: [<ffffffff81087e77>] cpuset_attach+0x8a/0x133
Jan 13 12:59:25 mail kernel: [<ffffffff81042d2c>] ? sched_move_task+0x104/0x110
Jan 13 12:59:25 mail kernel: [<ffffffff81085dbd>] cgroup_attach_task+0x4e1/0x53f
Jan 13 12:59:25 mail kernel: [<ffffffff81084f48>] ? cgroup_populate_dir+0x77/0xff
Jan 13 12:59:25 mail kernel: [<ffffffff81086073>] cgroup_clone+0x258/0x2ac
Jan 13 12:59:25 mail kernel: [<ffffffff81088d04>] ns_cgroup_clone+0x58/0x75
Jan 13 12:59:25 mail kernel: [<ffffffff81048f3d>] copy_process+0xcef/0x13af
Jan 13 12:59:25 mail kernel: [<ffffffff810d963c>] ? handle_mm_fault+0x355/0x7ff
Jan 13 12:59:25 mail kernel: [<ffffffff81049768>] do_fork+0x16b/0x309
Jan 13 12:59:25 mail kernel: [<ffffffff81252ab2>] ? __up_read+0x8e/0x97
Jan 13 12:59:25 mail kernel: [<ffffffff81068c92>] ? up_read+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff8145a779>] ? do_page_fault+0x280/0x2cc
Jan 13 12:59:25 mail kernel: [<ffffffff81010f2e>] sys_clone+0x28/0x2a
Jan 13 12:59:25 mail kernel: [<ffffffff81009f33>] stub_clone+0x13/0x20
Jan 13 12:59:25 mail kernel: [<ffffffff81009bf2>] ? system_call_fastpath+0x16/0x1b
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 6
Jan 13 12:59:25 mail kernel: CPU 6 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff8803325e5e38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff8803325e5fd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff8803325e5e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2a9d4e R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282c0000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 00007fe9aa1b6000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325e4000, task ffff8803325dc680)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff88032eb2a5a8 ffff88032eb2a000 ffff8803325e5e58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff8803325e5e78 ffffffff812ab088 000000004b4e09fd ffff88032eb2a5a8
Jan 13 12:59:25 mail kernel: <0> ffff8803325e5ed8 ffffffff812ab348 0000000000000000 0000000000000314
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 2
Jan 13 12:59:25 mail kernel: CPU 2 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff88033256de38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff88033256dfd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff88033256de48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 0000000000000400 R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2ac0cf R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 00007f15e00ed000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff88033256c000, task ffff880332562f00)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff880331e5e5a8 ffff880331e5e000 ffff88033256de58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff88033256de78 ffffffff812ab088 000000004b4e09fd ffff880331e5e5a8
Jan 13 12:59:25 mail kernel: <0> ffff88033256ded8 ffffffff812ab348 0000000000000000 0000000000000318
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 3
Jan 13 12:59:25 mail kernel: CPU 3 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff88033259fe38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff88033259ffd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff88033259fe48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2ab4ba R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff880028260000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 00007fc73f1c7000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff88033259e000, task ffff880332579780)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff880331e5f5a8 ffff880331e5f000 ffff88033259fe58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff88033259fe78 ffffffff812ab088 000000004b4e09fd ffff880331e5f5a8
Jan 13 12:59:25 mail kernel: <0> ffff88033259fed8 ffffffff812ab348 0000000000000000 000000000000031d
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 7
Jan 13 12:59:25 mail kernel: CPU 7 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff880331c01e38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff880331c01fd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff880331c01e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2a841f R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282e0000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 0000003a54576190 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff880331c00000, task ffff8803325f2f00)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff88032eb2b5a8 ffff88032eb2b000 ffff880331c01e58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff880331c01e78 ffffffff812ab088 000000004b4e09fd ffff88032eb2b5a8
Jan 13 12:59:25 mail kernel: <0> ffff880331c01ed8 ffffffff812ab348 0000000000000000 0000000000000307
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 0
Jan 13 12:59:25 mail kernel: CPU 0 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffffffff81a01e28  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffffffff81a01fd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffffffff81a01e38 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2ad623 R14: ffffffffffffffff R15: 00000000000936b0
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 000000000243f018 CR3: 0000000001a34000 CR4: 00000000000006f0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a3c020)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff880331e5c5a8 ffff880331e5c000 ffffffff81a01e48 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffffffff81a01e68 ffffffff812ab088 000000004b4e09fd ffff880331e5c5a8
Jan 13 12:59:25 mail kernel: <0> ffffffff81a01ec8 ffffffff812ab348 0000000000000000 0000000000000317
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff8144485a>] rest_init+0x7e/0x80
Jan 13 12:59:25 mail kernel: [<ffffffff81b00d83>] start_kernel+0x427/0x432
Jan 13 12:59:25 mail kernel: [<ffffffff81b002bc>] x86_64_start_reservations+0xa7/0xab
Jan 13 12:59:25 mail kernel: [<ffffffff81b003b8>] x86_64_start_kernel+0xf8/0x107
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff8144485a>] rest_init+0x7e/0x80
Jan 13 12:59:25 mail kernel: [<ffffffff81b00d83>] start_kernel+0x427/0x432
Jan 13 12:59:25 mail kernel: [<ffffffff81b002bc>] x86_64_start_reservations+0xa7/0xab
Jan 13 12:59:25 mail kernel: [<ffffffff81b003b8>] x86_64_start_kernel+0xf8/0x107
Jan 13 12:59:25 mail kernel: NMI backtrace for cpu 5
Jan 13 12:59:25 mail kernel: CPU 5 
Jan 13 12:59:25 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:25 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: RSP: 0018:ffff8803325d1e38  EFLAGS: 00000046
Jan 13 12:59:25 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:25 mail kernel: RDX: 0000000000000000 RSI: ffff8803325d1fd8 RDI: 0000000000000003
Jan 13 12:59:25 mail kernel: RBP: ffff8803325d1e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:25 mail kernel: R10: 0000000000000000 R11: 00000000000005fe R12: 0000000000000001
Jan 13 12:59:25 mail kernel: R13: 118884aafc2ad4cd R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:25 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282a0000(0000) knlGS:0000000000000000
Jan 13 12:59:25 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:25 mail kernel: CR2: 00007fe7a12a8000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:25 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:25 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:25 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325d0000, task ffff8803325bde00)
Jan 13 12:59:25 mail kernel: Stack:
Jan 13 12:59:25 mail kernel: ffff88032eb295a8 ffff88032eb29000 ffff8803325d1e58 ffffffff8101e23e
Jan 13 12:59:25 mail kernel: <0> ffff8803325d1e78 ffffffff812ab088 000000004b4e09fd ffff88032eb295a8
Jan 13 12:59:25 mail kernel: <0> ffff8803325d1ed8 ffffffff812ab348 0000000000000000 0000000000000313
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:25 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:25 mail kernel: Call Trace:
Jan 13 12:59:25 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:25 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:25 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:25 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:25 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:25 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:25 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:25 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:25 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:25 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:25 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:25 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242

--Boundary_(ID_lvPnfRe27lfwB+3pLSDaIg)
Content-type: text/plain; name=stall2
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=stall2

Jan 13 12:59:55 mail kernel: INFO: RCU detected CPU 1 stall (t=40000 jiffies)
Jan 13 12:59:55 mail kernel: sending NMI to all CPUs:
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 4
Jan 13 12:59:55 mail kernel: CPU 4 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff8803325b5e38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff8803325b5fd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff8803325b5e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e3f85 R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00007fee47bf8d7f CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325b4000, task ffff8803325b8000)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff88032eb285a8 ffff88032eb28000 ffff8803325b5e58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff8803325b5e78 ffffffff812ab088 000000004b4e0a1b ffff88032eb285a8
Jan 13 12:59:55 mail kernel: <0> ffff8803325b5ed8 ffffffff812ab348 0000000000000000 0000000000000318
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 6
Jan 13 12:59:55 mail kernel: CPU 6 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff8803325e5e38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff8803325e5fd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff8803325e5e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e4c6d R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282c0000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00007fa18eb54000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325e4000, task ffff8803325dc680)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff88032eb2a5a8 ffff88032eb2a000 ffff8803325e5e58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff8803325e5e78 ffffffff812ab088 000000004b4e0a1b ffff88032eb2a5a8
Jan 13 12:59:55 mail kernel: <0> ffff8803325e5ed8 ffffffff812ab348 0000000000000000 0000000000000319
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 2
Jan 13 12:59:55 mail kernel: CPU 2 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff88033256de38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff88033256dfd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff88033256de48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000003fe R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e6f4a R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00007fe9aa1b6000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff88033256c000, task ffff880332562f00)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff880331e5e5a8 ffff880331e5e000 ffff88033256de58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff88033256de78 ffffffff812ab088 000000004b4e0a1b ffff880331e5e5a8
Jan 13 12:59:55 mail kernel: <0> ffff88033256ded8 ffffffff812ab348 0000000000000000 000000000000031b
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 1
Jan 13 12:59:55 mail kernel: CPU 1 
Jan 13 12:59:55 mail kernel: Pid: 7809, comm: libvirtd Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff8101096b>]  [<ffffffff8101096b>] native_read_tsc+0x6/0x16
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff880028223d78  EFLAGS: 00000006
Jan 13 12:59:55 mail kernel: RAX: 000000009330ba6c RBX: ffffffff9330ba30 RCX: 000000009330ba30
Jan 13 12:59:55 mail kernel: RDX: 0000000000000247 RSI: 0000000000000002 RDI: 000000000028c6e9
Jan 13 12:59:55 mail kernel: RBP: ffff880028223d78 R08: ffff880028223ce8 R09: 0000000000000000
Jan 13 12:59:55 mail kernel: R10: 0000000000000004 R11: ffff880330e1de00 R12: 000000000028c6e9
Jan 13 12:59:55 mail kernel: R13: 0000000000000001 R14: ffff880028223f48 R15: ffff880028223f48
Jan 13 12:59:55 mail kernel: FS:  00007fbdf8da27e0(0000) GS:ffff880028220000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00000000004479d0 CR3: 00000002d525f000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process libvirtd (pid: 7809, threadinfo ffff8802a726c000, task ffff8802ba04c680)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff880028223da8 ffffffff81256147 0000000000000001 ffff8800282303f0
Jan 13 12:59:55 mail kernel: <0> ffffffff81a50600 ffff880028223f48 ffff880028223db8 ffffffff8125609f
Jan 13 12:59:55 mail kernel: <0> ffff880028223dc8 ffffffff812560e3 ffff880028223de8 ffffffff810206eb
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <IRQ> 
Jan 13 12:59:55 mail kernel: [<ffffffff81256147>] delay_tsc+0x37/0x80
Jan 13 12:59:55 mail kernel: [<ffffffff8125609f>] __delay+0xf/0x11
Jan 13 12:59:55 mail kernel: [<ffffffff812560e3>] __const_udelay+0x42/0x44
Jan 13 12:59:55 mail kernel: [<ffffffff810206eb>] arch_trigger_all_cpu_backtrace+0x57/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff8109814b>] __rcu_pending+0x6e/0x2a5
Jan 13 12:59:55 mail kernel: [<ffffffff810983b7>] rcu_check_callbacks+0x35/0x10a
Jan 13 12:59:55 mail kernel: [<ffffffff81057b37>] update_process_times+0x41/0x5c
Jan 13 12:59:55 mail kernel: [<ffffffff81071cba>] tick_sched_timer+0x77/0xa0
Jan 13 12:59:55 mail kernel: [<ffffffff81067f08>] __run_hrtimer+0xb8/0x117
Jan 13 12:59:55 mail kernel: [<ffffffff81071c43>] ? tick_sched_timer+0x0/0xa0
Jan 13 12:59:55 mail kernel: [<ffffffff81068187>] hrtimer_interrupt+0xc7/0x1b5
Jan 13 12:59:55 mail kernel: [<ffffffff814575c6>] ? trace_hardirqs_off_thunk+0x3a/0x6c
Jan 13 12:59:55 mail kernel: [<ffffffff8145cb14>] smp_apic_timer_interrupt+0x81/0x94
Jan 13 12:59:55 mail kernel: [<ffffffff8100a5d3>] apic_timer_interrupt+0x13/0x20
Jan 13 12:59:55 mail kernel: <EOI> 
Jan 13 12:59:55 mail kernel: [<ffffffff810447c1>] ? set_cpus_allowed_ptr+0x25/0x14b
Jan 13 12:59:55 mail kernel: [<ffffffff810f2a7b>] ? spin_lock+0xe/0x10
Jan 13 12:59:55 mail kernel: [<ffffffff81087d79>] cpuset_attach_task+0x27/0x9b
Jan 13 12:59:55 mail kernel: [<ffffffff81087e77>] cpuset_attach+0x8a/0x133
Jan 13 12:59:55 mail kernel: [<ffffffff81042d2c>] ? sched_move_task+0x104/0x110
Jan 13 12:59:55 mail kernel: [<ffffffff81085dbd>] cgroup_attach_task+0x4e1/0x53f
Jan 13 12:59:55 mail kernel: [<ffffffff81084f48>] ? cgroup_populate_dir+0x77/0xff
Jan 13 12:59:55 mail kernel: [<ffffffff81086073>] cgroup_clone+0x258/0x2ac
Jan 13 12:59:55 mail kernel: [<ffffffff81088d04>] ns_cgroup_clone+0x58/0x75
Jan 13 12:59:55 mail kernel: [<ffffffff81048f3d>] copy_process+0xcef/0x13af
Jan 13 12:59:55 mail kernel: [<ffffffff810d963c>] ? handle_mm_fault+0x355/0x7ff
Jan 13 12:59:55 mail kernel: [<ffffffff81049768>] do_fork+0x16b/0x309
Jan 13 12:59:55 mail kernel: [<ffffffff81252ab2>] ? __up_read+0x8e/0x97
Jan 13 12:59:55 mail kernel: [<ffffffff81068c92>] ? up_read+0xe/0x10
Jan 13 12:59:55 mail kernel: [<ffffffff8145a779>] ? do_page_fault+0x280/0x2cc
Jan 13 12:59:55 mail kernel: [<ffffffff81010f2e>] sys_clone+0x28/0x2a
Jan 13 12:59:55 mail kernel: [<ffffffff81009f33>] stub_clone+0x13/0x20
Jan 13 12:59:55 mail kernel: [<ffffffff81009bf2>] ? system_call_fastpath+0x16/0x1b
Jan 13 12:59:55 mail kernel: Code: 57 24 00 c9 c3 90 90 90 55 40 88 f8 48 89 e5 e6 70 e4 71 c9 c3 55 40 88 f0 48 89 e5 e6 70 40 88 f8 e6 71 c9 c3 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 55 48 89 e5 41 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 7809, comm: libvirtd Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff8101096b>] ? native_read_tsc+0x6/0x16
Jan 13 12:59:55 mail kernel: <<EOE>>  <IRQ>  [<ffffffff81256147>] delay_tsc+0x37/0x80
Jan 13 12:59:55 mail kernel: [<ffffffff8125609f>] __delay+0xf/0x11
Jan 13 12:59:55 mail kernel: [<ffffffff812560e3>] __const_udelay+0x42/0x44
Jan 13 12:59:55 mail kernel: [<ffffffff810206eb>] arch_trigger_all_cpu_backtrace+0x57/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff8109814b>] __rcu_pending+0x6e/0x2a5
Jan 13 12:59:55 mail kernel: [<ffffffff810983b7>] rcu_check_callbacks+0x35/0x10a
Jan 13 12:59:55 mail kernel: [<ffffffff81057b37>] update_process_times+0x41/0x5c
Jan 13 12:59:55 mail kernel: [<ffffffff81071cba>] tick_sched_timer+0x77/0xa0
Jan 13 12:59:55 mail kernel: [<ffffffff81067f08>] __run_hrtimer+0xb8/0x117
Jan 13 12:59:55 mail kernel: [<ffffffff81071c43>] ? tick_sched_timer+0x0/0xa0
Jan 13 12:59:55 mail kernel: [<ffffffff81068187>] hrtimer_interrupt+0xc7/0x1b5
Jan 13 12:59:55 mail kernel: [<ffffffff814575c6>] ? trace_hardirqs_off_thunk+0x3a/0x6c
Jan 13 12:59:55 mail kernel: [<ffffffff8145cb14>] smp_apic_timer_interrupt+0x81/0x94
Jan 13 12:59:55 mail kernel: [<ffffffff8100a5d3>] apic_timer_interrupt+0x13/0x20
Jan 13 12:59:55 mail kernel: <EOI>  [<ffffffff810447c1>] ? set_cpus_allowed_ptr+0x25/0x14b
Jan 13 12:59:55 mail kernel: [<ffffffff810f2a7b>] ? spin_lock+0xe/0x10
Jan 13 12:59:55 mail kernel: [<ffffffff81087d79>] cpuset_attach_task+0x27/0x9b
Jan 13 12:59:55 mail kernel: [<ffffffff81087e77>] cpuset_attach+0x8a/0x133
Jan 13 12:59:55 mail kernel: [<ffffffff81042d2c>] ? sched_move_task+0x104/0x110
Jan 13 12:59:55 mail kernel: [<ffffffff81085dbd>] cgroup_attach_task+0x4e1/0x53f
Jan 13 12:59:55 mail kernel: [<ffffffff81084f48>] ? cgroup_populate_dir+0x77/0xff
Jan 13 12:59:55 mail kernel: [<ffffffff81086073>] cgroup_clone+0x258/0x2ac
Jan 13 12:59:55 mail kernel: [<ffffffff81088d04>] ns_cgroup_clone+0x58/0x75
Jan 13 12:59:55 mail kernel: [<ffffffff81048f3d>] copy_process+0xcef/0x13af
Jan 13 12:59:55 mail kernel: [<ffffffff810d963c>] ? handle_mm_fault+0x355/0x7ff
Jan 13 12:59:55 mail kernel: [<ffffffff81049768>] do_fork+0x16b/0x309
Jan 13 12:59:55 mail kernel: [<ffffffff81252ab2>] ? __up_read+0x8e/0x97
Jan 13 12:59:55 mail kernel: [<ffffffff81068c92>] ? up_read+0xe/0x10
Jan 13 12:59:55 mail kernel: [<ffffffff8145a779>] ? do_page_fault+0x280/0x2cc
Jan 13 12:59:55 mail kernel: [<ffffffff81010f2e>] sys_clone+0x28/0x2a
Jan 13 12:59:55 mail kernel: [<ffffffff81009f33>] stub_clone+0x13/0x20
Jan 13 12:59:55 mail kernel: [<ffffffff81009bf2>] ? system_call_fastpath+0x16/0x1b
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 7
Jan 13 12:59:55 mail kernel: CPU 7 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff880331c01e38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff880331c01fd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff880331c01e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e3244 R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282e0000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 000000000199f058 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff880331c00000, task ffff8803325f2f00)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff88032eb2b5a8 ffff88032eb2b000 ffff880331c01e58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff880331c01e78 ffffffff812ab088 000000004b4e0a1b ffff88032eb2b5a8
Jan 13 12:59:55 mail kernel: <0> ffff880331c01ed8 ffffffff812ab348 0000000000000000 0000000000000309
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 3
Jan 13 12:59:55 mail kernel: CPU 3 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff88033259fe38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff88033259ffd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff88033259fe48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e6383 R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff880028260000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00007fc73f1c7000 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff88033259e000, task ffff880332579780)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff880331e5f5a8 ffff880331e5f000 ffff88033259fe58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff88033259fe78 ffffffff812ab088 000000004b4e0a1b ffff880331e5f5a8
Jan 13 12:59:55 mail kernel: <0> ffff88033259fed8 ffffffff812ab348 0000000000000000 0000000000000323
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 0
Jan 13 12:59:55 mail kernel: CPU 0 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffffffff81a01e28  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffffffff81a01fd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffffffff81a01e38 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000002ff R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e83f4 R14: ffffffffffffffff R15: 00000000000936b0
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 00000000018331b0 CR3: 0000000001a34000 CR4: 00000000000006f0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a3c020)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff880331e5c5a8 ffff880331e5c000 ffffffff81a01e48 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffffffff81a01e68 ffffffff812ab088 000000004b4e0a1b ffff880331e5c5a8
Jan 13 12:59:55 mail kernel: <0> ffffffff81a01ec8 ffffffff812ab348 0000000000000000 0000000000000314
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff8144485a>] rest_init+0x7e/0x80
Jan 13 12:59:55 mail kernel: [<ffffffff81b00d83>] start_kernel+0x427/0x432
Jan 13 12:59:55 mail kernel: [<ffffffff81b002bc>] x86_64_start_reservations+0xa7/0xab
Jan 13 12:59:55 mail kernel: [<ffffffff81b003b8>] x86_64_start_kernel+0xf8/0x107
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff8144485a>] rest_init+0x7e/0x80
Jan 13 12:59:55 mail kernel: [<ffffffff81b00d83>] start_kernel+0x427/0x432
Jan 13 12:59:55 mail kernel: [<ffffffff81b002bc>] x86_64_start_reservations+0xa7/0xab
Jan 13 12:59:55 mail kernel: [<ffffffff81b003b8>] x86_64_start_kernel+0xf8/0x107
Jan 13 12:59:55 mail kernel: NMI backtrace for cpu 5
Jan 13 12:59:55 mail kernel: CPU 5 
Jan 13 12:59:55 mail kernel: Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1 P6T DELUXE V2/System Product Name
Jan 13 12:59:55 mail kernel: RIP: 0010:[<ffffffff81011655>]  [<ffffffff81011655>] mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: RSP: 0018:ffff8803325d1e38  EFLAGS: 00000046
Jan 13 12:59:55 mail kernel: RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000001
Jan 13 12:59:55 mail kernel: RDX: 0000000000000000 RSI: ffff8803325d1fd8 RDI: 0000000000000003
Jan 13 12:59:55 mail kernel: RBP: ffff8803325d1e48 R08: 0000000000000000 R09: 0000000000000002
Jan 13 12:59:55 mail kernel: R10: 0000000000000000 R11: 00000000000005fe R12: 0000000000000001
Jan 13 12:59:55 mail kernel: R13: 118884b1f84e8572 R14: 0000000000000000 R15: 0000000000000000
Jan 13 12:59:55 mail kernel: FS:  0000000000000000(0000) GS:ffff8800282a0000(0000) knlGS:0000000000000000
Jan 13 12:59:55 mail kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 13 12:59:55 mail kernel: CR2: 0000003a542a5010 CR3: 0000000001a34000 CR4: 00000000000006e0
Jan 13 12:59:55 mail kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 13 12:59:55 mail kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 13 12:59:55 mail kernel: Process swapper (pid: 0, threadinfo ffff8803325d0000, task ffff8803325bde00)
Jan 13 12:59:55 mail kernel: Stack:
Jan 13 12:59:55 mail kernel: ffff88032eb295a8 ffff88032eb29000 ffff8803325d1e58 ffffffff8101e23e
Jan 13 12:59:55 mail kernel: <0> ffff8803325d1e78 ffffffff812ab088 000000004b4e0a1b ffff88032eb295a8
Jan 13 12:59:55 mail kernel: <0> ffff8803325d1ed8 ffffffff812ab348 0000000000000000 0000000000000313
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 12:59:55 mail kernel: Code: 25 08 cc 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 09 48 89 d8 4c 89 e1 0f 01 c9 <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 65 48 
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc4WITHMMAPNODMARSKY2SKBMAYPULL-00001-g033d717-dirty #1
Jan 13 12:59:55 mail kernel: Call Trace:
Jan 13 12:59:55 mail kernel: <NMI>  [<ffffffff81008889>] ? show_regs+0x2b/0x30
Jan 13 12:59:55 mail kernel: [<ffffffff81459268>] nmi_watchdog_tick+0xc2/0x1a0
Jan 13 12:59:55 mail kernel: [<ffffffff81458879>] do_nmi+0xc4/0x28e
Jan 13 12:59:55 mail kernel: [<ffffffff81458270>] nmi+0x20/0x39
Jan 13 12:59:55 mail kernel: [<ffffffff81011655>] ? mwait_idle_with_hints+0x82/0x87
Jan 13 12:59:55 mail kernel: <<EOE>>  [<ffffffff8101e23e>] acpi_processor_ffh_cstate_enter+0x32/0x34
Jan 13 12:59:55 mail kernel: [<ffffffff812ab088>] acpi_idle_do_entry+0x26/0x46
Jan 13 12:59:55 mail kernel: [<ffffffff812ab348>] acpi_idle_enter_bm+0x1d0/0x28a
Jan 13 12:59:55 mail kernel: [<ffffffff8145a7d9>] ? notifier_call_chain+0x14/0x63
Jan 13 12:59:55 mail kernel: [<ffffffff81390b5c>] cpuidle_idle_call+0x9e/0xfa
Jan 13 12:59:55 mail kernel: [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
Jan 13 12:59:55 mail kernel: [<ffffffff81450ff5>] start_secondary+0x201/0x242
Jan 13 13:00:17 mail nmbd[5145]: [2010/01/13 13:00:17,  0] nmbd/nmbd_become_lmb.c:395(become_local_master_stage2)
Jan 13 13:00:17 mail nmbd[5145]:   *****
Jan 13 13:00:17 mail nmbd[5145]:   
Jan 13 13:00:17 mail nmbd[5145]:   Samba name server MAJJAS is now a local master browser for workgroup MAJJAS on subnet 192.168.122.1
Jan 13 13:00:17 mail nmbd[5145]:   
Jan 13 13:00:17 mail nmbd[5145]:   *****

--Boundary_(ID_lvPnfRe27lfwB+3pLSDaIg)--
