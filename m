Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXKHCOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXKHCOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXKHCOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:14:25 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:57269 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbXKHCOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:14:21 -0500
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 21:14:20 EST
Date: Thu, 8 Nov 2007 01:45:27 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: linux-kernel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-ID: <20071108014527.GA2474@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=-0.9, required 7, autolearn=disabled,
	RCVD_IN_NERDS_IE -3.50, SARE_BAYES_5x8 0.80, SARE_BAYES_6x8 0.80,
	SARE_BAYES_7x8 1.00)
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of days ago I tried to use oprofile with a recent build of
2.6.24-rc1, this resulted in a oops 'BUG: unable to handle kernel paging
request at virtual address'.

The oops is readily reproducible on my main machine, the steps for me
are, run opcontrol --init, and then opcontrol --start, then straight
away or within a few seconds I get the oops.  I have tried to reproduce
it on another machine with a slightly lower spec, but I wasn't too.

I've spent some time investigating the problem.  Using git bisect the
oops first triggers with commit 574a60421c8ea5383a54ebee1f37fa871d00e1b9
(i386: make callgraph use dump_trace() on i386/x86_64).

The oops occurs in the dump_trace function when the context pointer is
referenced on the marked line.

arch/x86/kernel/traps_32.c, dump_trace()

	while (1) {
		struct thread_info *context;
		context = (struct thread_info *)
			((unsigned long)stack & (~(THREAD_SIZE - 1)));
		ebp = print_context_stack(context, stack, ebp, ops, data);
		/* Should be after the line below, but somewhere
		   in early boot context comes out corrupted and we
		   can't reference it -AK */
		if (ops->stack(data, "IRQ") < 0)
			break;
--->		stack = (unsigned long*)context->previous_esp;
		if (!stack)
			break;
		touch_nmi_watchdog();
	}

In the second and thrid oops with CONFIG_FRAME_POINTER disable the oops
is trigger below.

arch/x86/kernel/traps_32.c, print_context_stack()

	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
		unsigned long addr;

--->		addr = *stack++;
		if (__kernel_text_address(addr))
			ops->address(data, addr);
	}

It seems that for some reason the previous_esp value in one of the
struct thread_info is not being written/updated correctly or is getting
corrupted.

I've tried a number of different build options, including very minimal
configs, enabling/disabling CONFIG_FRAME_POINTER, CONFIG_4KSTACKS,
different versions of gcc, changing around the installed pci cards, with
no effect.

The machine is a fairly old 32-bit Athlon, so I haven't ruled out a
hardware fault though the machine has been working fine up-until now and
works fine with other kernel versions.  I've already run memtest+ for
about about 30 minutes, I'm going to run it again overnight after I've
sent this email.

Any suggestions as to what might be causing these oopses?

Robert



# Config below
[  114.301541] BUG: unable to handle kernel paging request at virtual address 1449f034
[  114.393361] printing eip: 80102aac *pde = 00000000 
[  114.452204] Oops: 0000 [#1] 
[  114.486924] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables pppoe pppox oprofile ppp_generic slhc usbhid hid uhci_hcd pcspkr usbcore
[  114.744215] 
[  114.762098] Pid: 1648, comm: sleep Not tainted (2.6.24-rc2 #3)
[  114.831956] EIP: 0060:[<80102aac>] EFLAGS: 00010046 CPU: 0
[  114.897665] EIP is at dump_trace+0x86/0x9d
[  114.946727] EAX: 00000000 EBX: 803f8eec ECX: e084e888 EDX: 80345ef4
[  115.021782] ESI: 1449f000 EDI: 1449fff8 EBP: 803f8eec ESP: 803f8ed8
[  115.096840]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  115.161502] Process sleep (pid: 1648, ti=803f8000 task=820936f0 task.ti=83587000)
[  115.249032] Stack: 803f8eec 8010b60b 83587e28 8014716b 83587e28 803f8f1c e084b596 e084e888 
[  115.350806]        803f8efc 00000010 803f8f24 8010b396 803f8f1c e084a274 00000000 8014716b 
[  115.452685]        83587e28 803f8f34 e084a314 00000000 00000001 83587e28 00000000 803f8f4c 
[  115.554564] Call Trace:
[  115.586167]  [<80102add>] show_trace_log_lvl+0x1a/0x2f
[  115.647916]  [<80102b8d>] show_stack_log_lvl+0x9b/0xa3
[  115.709668]  [<80102c37>] show_registers+0xa2/0x16b
[  115.768299]  [<80102df5>] die+0xf5/0x1c3
[  115.815494]  [<802f5957>] do_page_fault+0x440/0x519
[  115.874127]  [<802f44e2>] error_code+0x6a/0x70
[  115.927562]  [<e084b596>] x86_backtrace+0x4b/0x9d [oprofile]
[  115.995550]  [<e084a314>] oprofile_add_ext_sample+0x96/0xa6 [oprofile]
[  116.073934]  [<e084a3d5>] oprofile_add_sample+0x2e/0x34 [oprofile]
[  116.148160]  [<e084b509>] timer_notify+0xa/0xe [oprofile]
[  116.213028]  [<80111c7b>] profile_tick+0x20/0x54
[  116.268540]  [<80126fab>] tick_sched_timer+0x81/0xbb
[  116.328213]  [<80122d54>] hrtimer_interrupt+0x128/0x1b4
[  116.391002]  [<801043d1>] timer_interrupt+0x14/0x1b
[  116.449635]  [<8012e1b4>] handle_IRQ_event+0x21/0x48
[  116.509307]  [<8012f57b>] handle_level_irq+0xae/0xbb
[  116.568978]  [<801037fa>] do_IRQ+0xa3/0xc9
[  116.618255]  =======================
[  116.661082] Code: fb 77 16 8b 4d 08 8b 45 0c 8b 53 04 ff 51 08 8b 03 39 d8 76 04 89 c3 eb e2 8b 4d 08 ba f4 5e 34 80 8b 45 0c ff 51 0c 85 c0 78 10 <8b> 4e 34 85 c9 74 09 89 cb e8 97 b3 02 00 eb af 5e 5f 5b 5e 5f 
[  116.896546] EIP: [<80102aac>] dump_trace+0x86/0x9d SS:ESP 0068:803f8ed8
[  116.976179] Kernel panic - not syncing: Fatal exception in interrupt



# Config below, CONFIG_FRAME_POINTER=n
[   83.940713] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000a
[   84.042991] printing eip: 801029fe *pde = 00000000 
[   84.101834] Oops: 0000 [#1] 
[   84.136555] Modules linked in: pppoe pppox oprofile ppp_generic slhc usbhid hid uhci_hcd usbcore pcspkr
[   84.250595] 
[   84.268478] Pid: 1527, comm: net.agent Not tainted (2.6.24-rc2 #4)
[   84.342493] EIP: 0060:[<801029fe>] EFLAGS: 00010093 CPU: 0
[   84.408201] EIP is at dump_trace+0x52/0x8b
[   84.457263] EAX: 00000000 EBX: 0000000a ECX: 0000000a EDX: 820c7200
[   84.532318] ESI: 00000001 EDI: 00000000 EBP: 00000ffc ESP: 803eef00
[   84.607376]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   84.672038] Process net.agent (pid: 1527, ti=803ee000 task=820c7200 task.ti=82b76000)
[   84.763726] Stack: 8201e940 82b76f6c 00000001 80149592 82b76f6c e084b463 e084e750 803eef20 
[   84.865605]        00000010 803f114c 8010aef0 803f121c e084a24c 00000000 00000001 80149592 
[   84.967276]        e084a2ef 00000000 00000001 82b76f6c 00000000 82b76f6c e084a3a7 00000001 
[   85.068840] Call Trace:
[   85.100445]  [<80149592>] sys_close+0x4e/0x9e
[   85.152840]  [<e084b463>] x86_backtrace+0x4c/0xa1 [oprofile]
[   85.220827]  [<8010aef0>] update_curr+0x52/0xc8
[   85.275303]  [<e084a24c>] log_sample+0x82/0x8b [oprofile]
[   85.340172]  [<80149592>] sys_close+0x4e/0x9e
[   85.392565]  [<e084a2ef>] oprofile_add_ext_sample+0x9a/0xaa [oprofile]
[   85.470950]  [<e084a3a7>] oprofile_add_sample+0x2b/0x30 [oprofile]
[   85.545173]  [<e084b3ed>] timer_notify+0x7/0xa [oprofile]
[   85.610043]  [<801114ff>] profile_tick+0x1d/0x52
[   85.665557]  [<80125e60>] tick_sched_timer+0x7a/0xb5
[   85.725230]  [<80121d90>] hrtimer_interrupt+0x124/0x1b4
[   85.788018]  [<80125de6>] tick_sched_timer+0x0/0xb5
[   85.846651]  [<8010423a>] timer_interrupt+0x11/0x17
[   85.905282]  [<8012ceec>] handle_IRQ_event+0x1a/0x3f
[   85.964953]  [<8012e232>] handle_level_irq+0xa3/0xb1
[   86.024624]  [<8012e18f>] handle_level_irq+0x0/0xb1
[   86.083257]  [<801036bb>] do_IRQ+0x9e/0xc2
[   86.132533]  [<8010267f>] common_interrupt+0x23/0x28
[   86.192205]  [<80149592>] sys_close+0x4e/0x9e
[   86.244599]  [<801024fa>] syscall_call+0x7/0xb
[   86.298033]  =======================
[   86.340862] Code: 02 00 00 89 df 81 e7 00 f0 ff ff 8d af fc 0f 00 00 eb 10 8b 4c 24 18 89 f2 8b 44 24 1c ff 51 08 83 c3 04 39 fb 76 23 39 eb 77 1f <8b> 33 89 f0 e8 dd ab 01 00 85 c0 74 e8 eb d9 8b 4f 34 85 c9 74 
[   86.575702] EIP: [<801029fe>] dump_trace+0x52/0x8b SS:ESP 0068:803eef00
[   86.655334] Kernel panic - not syncing: Fatal exception in interrupt



# Config below, CONFIG_FRAME_POINTER=n, CONFIG_4KSTACKS=n
[  103.735109] BUG: unable to handle kernel paging request at virtual address 001200d2
[  103.827010] printing eip: 80102a04 *pde = 00000000 
[  103.885853] Oops: 0000 [#1] 
[  103.920571] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables pppoe pppox oprofile ppp_generic slhc usbhid hid uhci_hcd pcspkr usbcore
[  104.177555] 
[  104.195438] Pid: 1643, comm: ls Not tainted (2.6.24-rc2 #5)
[  104.262176] EIP: 0060:[<80102a04>] EFLAGS: 00010093 CPU: 0
[  104.327883] EIP is at dump_trace+0x52/0x8b
[  104.376944] EAX: 00000000 EBX: 001200d2 ECX: 001200d2 EDX: 82134210
[  104.452000] ESI: 00000001 EDI: 00120000 EBP: 00121ffc ESP: 83537d34
[  104.527058]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  104.591721] Process ls (pid: 1643, ti=83536000 task=82134210 task.ti=83536000)
[  104.676133] Stack: 00000000 83537e4c 00000001 80145d2f 83537e4c e084b463 e084e750 83537d54 
[  104.778010]        00000010 803f114c 8010ad94 803f121c e084a24c 00000000 00000001 80145d2f 
[  104.879368]        e084a2ef 00000000 00000001 83537e4c 00000000 83537e4c e084a3a7 00000001 
[  104.980830] Call Trace:
[  105.012435]  [<80145d2f>] check_poison_obj+0xa6/0x186
[  105.073146]  [<e084b463>] x86_backtrace+0x4c/0xa1 [oprofile]
[  105.141135]  [<8010ad94>] update_curr+0x52/0xc8
[  105.195608]  [<e084a24c>] log_sample+0x82/0x8b [oprofile]
[  105.260477]  [<80145d2f>] check_poison_obj+0xa6/0x186
[  105.321187]  [<e084a2ef>] oprofile_add_ext_sample+0x9a/0xaa [oprofile]
[  105.399572]  [<e084a3a7>] oprofile_add_sample+0x2b/0x30 [oprofile]
[  105.473798]  [<e084b3ed>] timer_notify+0x7/0xa [oprofile]
[  105.538665]  [<801113af>] profile_tick+0x1d/0x52
[  105.594180]  [<80125d38>] tick_sched_timer+0x7a/0xb5
[  105.653851]  [<80121c68>] hrtimer_interrupt+0x124/0x1b4
[  105.716641]  [<80125cbe>] tick_sched_timer+0x0/0xb5
[  105.775274]  [<801040de>] timer_interrupt+0x11/0x17
[  105.833904]  [<8012cdc4>] handle_IRQ_event+0x1a/0x3f
[  105.893577]  [<8012e10a>] handle_level_irq+0xa3/0xb1
[  105.953248]  [<8010356c>] do_IRQ+0x72/0x88
[  106.002524]  [<801a235f>] prio_tree_insert+0x11d/0x1e7
[  106.064275]  [<8010267f>] common_interrupt+0x23/0x28
[  106.123948]  [<80145d2f>] check_poison_obj+0xa6/0x186
[  106.184657]  [<802eb0c4>] _read_unlock_irq+0x5/0x7
[  106.242249]  [<8012f045>] find_lock_page+0x74/0x7c
[  106.299841]  [<80130e33>] filemap_fault+0x1a1/0x2f3
[  106.358475]  [<80145ef0>] cache_alloc_debugcheck_after+0x20/0x167
[  106.431660]  [<8015066c>] getname+0x14/0x86
[  106.481973]  [<801471f7>] kmem_cache_alloc+0x54/0x8a
[  106.541646]  [<8015066c>] getname+0x14/0x86
[  106.591961]  [<8015066c>] getname+0x14/0x86
[  106.642276]  [<80151df7>] __user_walk_fd+0x12/0x45
[  106.699869]  [<80148ce1>] sys_faccessat+0x99/0x12d
[  106.757464]  [<802ec311>] do_page_fault+0x1d6/0x537
[  106.816095]  [<801483d7>] filp_close+0x48/0x4f
[  106.869527]  [<80148d94>] sys_access+0x1f/0x23
[  106.922962]  [<801024fa>] syscall_call+0x7/0xb
[  106.976398]  =======================
[  107.019224] Code: 02 00 00 89 df 81 e7 00 e0 ff ff 8d af fc 1f 00 00 eb 10 8b 4c 24 18 89 f2 8b 44 24 1c ff 51 08 83 c3 04 39 fb 76 23 39 eb 77 1f <8b> 33 89 f0 e8 af aa 01 00 85 c0 74 e8 eb d9 8b 4f 34 85 c9 74 
[  107.253647] EIP: [<80102a04>] dump_trace+0x52/0x8b SS:ESP 0068:83537d34
[  107.333282] Kernel panic - not syncing: Fatal exception in interrupt



processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 8
model name	: AMD Athlon(tm) XP 2000+
stepping	: 0
cpu MHz		: 1662.040
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
bogomips	: 3326.91
clflush size	: 32



00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 [IGD4-1P] System Controller (rev 13)
	Flags: bus master, medium devsel, latency 32
	Memory at e8000000 (32-bit, prefetchable) [size=32M]
	Memory at ed002000 (32-bit, prefetchable) [size=4K]
	I/O ports at a000 [disabled] [size=4]
	Capabilities: <access denied>

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 [IGD4-1P] AGP Bridge (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 32
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: ea000000-ebffffff
	Prefetchable memory behind bridge: e0000000-e7ffffff

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
	Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: <access denied>

00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Subsystem: VIA Technologies, Inc. VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
	Flags: medium devsel
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at a400 [size=16]
	Capabilities: <access denied>

00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 16) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Flags: bus master, medium devsel, latency 32, IRQ 10
	I/O ports at a800 [size=32]
	Capabilities: <access denied>

00:07.4 SMBus: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
	Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
	Flags: medium devsel, IRQ 9
	Capabilities: <access denied>

00:08.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Flags: bus master, medium devsel, latency 32, IRQ 11
	I/O ports at b000 [size=256]
	Memory at ed000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

00:09.0 Mass storage controller: Silicon Image, Inc. SiI 3112 [SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. SiI 3112 SATALink Controller
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 15
	I/O ports at b400 [size=8]
	I/O ports at b800 [size=4]
	I/O ports at bc00 [size=8]
	I/O ports at c000 [size=4]
	I/O ports at c400 [size=16]
	Memory at ed001000 (32-bit, non-prefetchable) [size=512]
	[virtual] Expansion ROM at 70000000 [disabled] [size=512K]
	Capabilities: <access denied>

00:0d.0 Network controller: Compaq Computer Corporation Netelligent 10/100 TX PCI UTP (rev 10)
	Flags: bus master, user-definable features, medium devsel, latency 32, IRQ 10
	I/O ports at c800 [size=16]
	Memory at ed003000 (32-bit, non-prefetchable) [size=16]
	[virtual] Expansion ROM at 70080000 [disabled] [size=64K]

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon R200 QL [Radeon 8500 LE] (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc Radeon 8500
	Flags: bus master, stepping, 66MHz, medium devsel, latency 32, IRQ 11
	Memory at e0000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 9000 [size=256]
	Memory at eb000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at ea000000 [disabled] [size=128K]
	Capabilities: <access denied>



[    0.000000] Linux version 2.6.24-rc2 (bob@earth) (gcc version 4.2.3 20071014 (prerelease) (Debian 4.2.2-3)) #3 Wed Nov 7 21:11:52 GMT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005fff3000 - 0000000060000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 1535MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   393200
[    0.000000]   HighMem    393200 ->   393200
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   393200
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP 000F6A90, 0014 (r0 761686)
[    0.000000] ACPI: RSDT 5FFF3000, 0028 (r1 761686 AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 5FFF3040, 0074 (r1 761686 AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 5FFF30C0, 3005 (r1 761686 AWRDACPI     1000 MSFT  100000C)
[    0.000000] ACPI: FACS 5FFF0000, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:9fff0000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390129
[    0.000000] Kernel command line: root=/dev/sda3 ro console=ttyS1,9600 console=tty0 single
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=803f8000 soft=803f7000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1662.021 MHz processor.
[   25.674108] Console: colour VGA+ 80x25
[   25.674113] console [tty0] enabled
[   25.675542] console [ttyS1] enabled
[   27.990732] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
[   28.079544] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
[   28.222223] Memory: 1555096k/1572800k available (2013k kernel code, 17200k reserved, 856k data, 148k init, 0k highmem)
[   28.350263] virtual kernel memory layout:
[   28.350265]     fixmap  : 0xfffe9000 - 0xfffff000   (  88 kB)
[   28.350267]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   28.350269]     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
[   28.350271]     lowmem  : 0x80000000 - 0xdfff0000   (1535 MB)
[   28.350273]       .init : 0x803cf000 - 0x803f4000   ( 148 kB)
[   28.350275]       .data : 0x802f746a - 0x803cd73c   ( 856 kB)
[   28.350276]       .text : 0x80100000 - 0x802f746a   (2013 kB)
[   28.880022] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   29.057496] Calibrating delay using timer specific routine.. 3326.90 BogoMIPS (lpj=6653812)
[   29.157828] Mount-cache hash table entries: 512
[   29.212498] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   29.297942] CPU: L2 Cache: 256K (64 bytes/line)
[   29.352218] Compat vDSO mapped to ffffe000.
[   29.402325] CPU: AMD Athlon(tm) XP 2000+ stepping 00
[   29.462193] Checking 'hlt' instruction... OK.
[   29.526934] Freeing SMP alternatives: 0k freed
[   29.580183] ACPI: Core revision 20070126
[   29.630722] ACPI: setting ELCR to 0200 (from 8e00)
[   29.689632] net_namespace: 64 bytes
[   29.732219] NET: Registered protocol family 16
[   29.786076] ACPI: bus type pci registered
[   29.865435] PCI: PCI BIOS revision 2.10 entry at 0xfb680, last bus=1
[   29.941539] PCI: Using configuration type 1
[   29.991645] Setting up standard PCI resources
[   30.061699] ACPI: Interpreter enabled
[   30.105584] ACPI: (supports S0 S5)
[   30.146750] ACPI: Using PIC for interrupt routing
[   30.211613] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   30.269462] PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
[   30.343440] PCI quirk: region 5000-500f claimed by vt82c686 SMB
[   30.433085] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
[   30.522210] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 *15)
[   30.611465] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   30.714756] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
[   30.804053] Linux Plug and Play Support v0.97 (c) Adam Belay
[   30.871979] pnp: PnP ACPI init
[   30.908584] ACPI: bus type pnp registered
[   30.961182] pnp: PnP ACPI: found 11 devices
[   31.011259] ACPI: ACPI bus type pnp unregistered
[   31.067393] SCSI subsystem initialized
[   31.112883] PCI: Using ACPI for IRQ routing
[   31.162936] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   31.297201] ACPI: RTC can wake from S4
[   31.342049] Time: tsc clocksource has been installed.
[   31.413210] system 00:00: iomem range 0xd0800-0xd3fff has been reserved
[   31.492377] system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
[   31.575748] system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[   31.659122] system 00:00: iomem range 0xfc000-0xfffff could not be reserved
[   31.774060] PCI: Bridge: 0000:00:01.0
[   31.817864]   IO window: 9000-9fff
[   31.858619]   MEM window: ea000000-ebffffff
[   31.908724]   PREFETCH window: e0000000-e7ffffff
[   31.964071] NET: Registered protocol family 2
[   32.053049] IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
[   32.139588] TCP established hash table entries: 131072 (order: 9, 2621440 bytes)
[   32.234694] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[   32.317948] TCP: Hash tables configured (established 131072 bind 65536)
[   32.397123] TCP reno registered
[   32.447175] io scheduler noop registered
[   32.494115] io scheduler anticipatory registered (default)
[   32.560402] input: Power Button (FF) as /devices/virtual/input/input0
[   32.637572] ACPI: Power Button (FF) [PWRF]
[   32.686924] input: Power Button (CM) as /devices/virtual/input/input1
[   32.764085] ACPI: Power Button (CM) [PWRB]
[   32.813338] ACPI: Fan [FAN] (on)
[   32.852425] ACPI: Processor [CPU0] (supports 2 throttling states)
[   32.926700] ACPI: Thermal Zone [THRM] (32 C)
[   33.000920] Linux agpgart interface v0.102
[   33.050155] agpgart: Detected AMD 761 chipset
[   33.107217] agpgart: AGP aperture is 32M @ 0xe8000000
[   33.167956] [drm] Initialized drm 1.1.0 20060810
[   33.224137] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   33.292923] ACPI: PCI Interrupt 0000:01:05.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   33.397721] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   33.468610] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   33.561587] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   33.633738] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   33.706583] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   33.773666] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   34.657248] floppy0: no floppy controllers found
[   34.712589] ThunderLAN driver v1.15
[   34.755275] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   34.824114] ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[   34.931419] TLAN: eth0 irq=10, io=c800, Compaq Netelligent 10/100 TX PCI UTP, Rev. 16
[   35.025200] TLAN: 1 device installed, PCI: 1  EISA: 0
[   35.085815] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   35.159783] 8139cp 0000:00:08.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
[   35.260831] 8139cp 0000:00:08.0: Try the "8139too" driver instead.
[   35.334992] 8139too Fast Ethernet driver 0.9.28
[   35.389239] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   35.494719] eth1: RealTek RTL8139 at 0xe082a000, 00:c0:df:0b:f9:a4, IRQ 11
[   35.577103] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   35.653170] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   35.749173] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:07.1
[   35.842900] PCI: Enabling device 0000:00:07.1 (0000 -> 0001)
[   35.910678] VP_IDE: not 100% native mode: will probe irqs later
[   35.981572] VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
[   36.074294] VP_IDE: IDE port disabled
[   36.118163] VP_IDE: IDE port disabled
[   37.286311] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 15
[   37.355166] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 15 (level, low) -> IRQ 15
[   37.459866] scsi0 : sata_sil
[   37.494570] scsi1 : sata_sil
[   37.529281] ata1: SATA max UDMA/100 mmio m512@0xed001000 tf 0xed001080 irq 15
[   37.614735] ata2: SATA max UDMA/100 mmio m512@0xed001000 tf 0xed0010c0 irq 15
[   38.008420] ata1: SATA link down (SStatus 0 SControl 310)
[   38.540296] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   38.621481] ata2.00: ATA-7: Maxtor 6L300S0, BANC1G10, max UDMA/133
[   38.695471] ata2.00: 586114704 sectors, multi 16: LBA48 NCQ (not used)
[   38.789425] ata2.00: configured for UDMA/100
[   38.840816] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BANC PQ: 0 ANSI: 5
[   38.938086] sd 1:0:0:0: [sda] 586114704 512-byte hardware sectors (300091 MB)
[   39.023586] sd 1:0:0:0: [sda] Write Protect is off
[   39.080985] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.189390] sd 1:0:0:0: [sda] 586114704 512-byte hardware sectors (300091 MB)
[   39.274845] sd 1:0:0:0: [sda] Write Protect is off
[   39.332247] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.440553]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   39.545275] sd 1:0:0:0: [sda] Attached SCSI disk
[   39.601496] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   39.675481] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   39.791399] serio: i8042 KBD port at 0x60,0x64 irq 1
[   39.851276] mice: PS/2 mouse device common for all mice
[   39.975727] atkbd.c: Failed to enable keyboard on isa0060/serio0
[   40.047866] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[   40.176335] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[   40.249350] rtc0: alarms up to one year, y3k
[   40.300679] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 23 06:09:18 2007 UTC).
[   40.409872] ALSA device list:
[   40.445395]   No soundcards found.
[   40.486138] TCP cubic registered
[   40.524836] NET: Registered protocol family 1
[   40.577015] NET: Registered protocol family 17
[   40.630229] Using IPI Shortcut mode
[   40.672295] rtc_cmos 00:04: setting the system clock to 2007-11-07 23:51:00 (1194479460)
[   40.803622] EXT3-fs: INFO: recovery required on readonly filesystem.
[   40.879717] EXT3-fs: write access will be enabled during recovery.
[   40.987489] kjournald starting.  Commit interval 5 seconds
[   41.053252] EXT3-fs: sda3: orphan cleanup on readonly fs
[   41.116962] EXT3-fs: sda3: 5 orphan inodes deleted
[   41.174334] EXT3-fs: recovery complete.
[   41.221984] EXT3-fs: mounted filesystem with ordered data mode.
[   41.292903] VFS: Mounted root (ext3 filesystem) readonly.
[   41.357853] Freeing unused kernel memory: 148k freed
[   43.564731] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   43.667369] usbcore: registered new interface driver usbfs
[   43.733182] usbcore: registered new interface driver hub
[   43.897281] usbcore: registered new device driver usb
[   44.020618] USB Universal Host Controller Interface driver v3.0
[   44.091940] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[   44.196488] uhci_hcd 0000:00:07.2: UHCI Host Controller
[   44.259362] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
[   44.347952] uhci_hcd 0000:00:07.2: detected 2 ports
[   44.406395] uhci_hcd 0000:00:07.2: irq 10, io base 0x0000a800
[   44.475640] usb usb1: configuration #1 chosen from 1 choice
[   44.542443] hub 1-0:1.0: USB hub found
[   44.587371] hub 1-0:1.0: 2 ports detected
[   44.985089] usb usb1: Product: UHCI Host Controller
[   45.043540] usb usb1: Manufacturer: Linux 2.6.24-rc2 uhci_hcd
[   45.112395] usb usb1: SerialNumber: 0000:00:07.2
[   45.534575] usb 1-2: new low speed USB device using uhci_hcd and address 2
[   45.792018] usb 1-2: configuration #1 chosen from 1 choice
[   45.864285] usb 1-2: Product: USB Mouse
[   45.910236] usb 1-2: Manufacturer: Logitech
[   46.140329] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:07.2/usb1/1-2/1-2:1.0/input/input4
[   46.283060] input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:07.2-2
[   46.373076] usbcore: registered new interface driver usbhid
[   46.439776] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   46.777505] Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 across:1004052k
[   47.155875] EXT3 FS on sda3, internal journal
[   48.550393] kjournald starting.  Commit interval 5 seconds
[   48.616513] EXT3 FS on sda1, internal journal
[   48.668925] EXT3-fs: mounted filesystem with ordered data mode.
[   48.760651] kjournald starting.  Commit interval 5 seconds
[   48.826504] EXT3 FS on sda5, internal journal
[   48.878919] EXT3-fs: mounted filesystem with ordered data mode.
[   48.967269] kjournald starting.  Commit interval 5 seconds
[   49.036706] EXT3 FS on sda6, internal journal
[   49.089134] EXT3-fs: mounted filesystem with ordered data mode.
[   50.796055] TLAN: eth0: Starting autonegotiation.
[   52.850744] TLAN:  Giving autonegotiation more time.
[   52.910153] TLAN:  Please check that your adapter has
[   52.970656] TLAN:  been properly connected to a HUB or Switch.
[   53.040517] TLAN:  Trying to establish link in the background...
[   60.848765] TLAN: eth0: Autonegotiation complete.
[   60.949760] TLAN: eth0: Link active
[   72.166769] TLAN: eth0: Starting autonegotiation.
[   74.221491] TLAN:  Giving autonegotiation more time.
[   74.280967] TLAN:  Please check that your adapter has
[   74.341472] TLAN:  been properly connected to a HUB or Switch.
[   74.411331] TLAN:  Trying to establish link in the background...
[   74.793292] eth1: link down
[   75.200085] PPP generic driver version 2.4.2
[   82.479413] TLAN: eth0: Autonegotiation complete.
[   82.636392] TLAN: eth0: Link active
[   84.221082] oprofile: using timer interrupt.
[   90.464193] NET: Registered protocol family 24
[   91.580151] ip_tables: (C) 2000-2006 Netfilter Core Team
[   91.730333] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   96.659855] dsl_in:IN=ppp0 OUT= MAC= SRC=86.97.187.75 DST=212.2.167.212 LEN=52 TOS=0x00 PREC=0x00 TTL=116 ID=30620 DF PROTO=TCP SPT=2530 DPT=38537 WINDOW=65535 RES=0x00 SYN URGP=0 
[  108.093920] dsl_in:IN=ppp0 OUT= MAC= SRC=212.2.100.117 DST=212.2.167.212 LEN=48 TOS=0x00 PREC=0x00 TTL=110 ID=18041 DF PROTO=TCP SPT=58794 DPT=135 WINDOW=16384 RES=0x00 SYN URGP=0 
[  114.301541] BUG: unable to handle kernel paging request at virtual address 1449f034
[  114.393361] printing eip: 80102aac *pde = 00000000 
[  114.452204] Oops: 0000 [#1] 
[  114.486924] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables pppoe pppox oprofile ppp_generic slhc usbhid hid uhci_hcd pcspkr usbcore
[  114.744215] 
[  114.762098] Pid: 1648, comm: sleep Not tainted (2.6.24-rc2 #3)
[  114.831956] EIP: 0060:[<80102aac>] EFLAGS: 00010046 CPU: 0
[  114.897665] EIP is at dump_trace+0x86/0x9d
[  114.946727] EAX: 00000000 EBX: 803f8eec ECX: e084e888 EDX: 80345ef4
[  115.021782] ESI: 1449f000 EDI: 1449fff8 EBP: 803f8eec ESP: 803f8ed8
[  115.096840]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  115.161502] Process sleep (pid: 1648, ti=803f8000 task=820936f0 task.ti=83587000)
[  115.249032] Stack: 803f8eec 8010b60b 83587e28 8014716b 83587e28 803f8f1c e084b596 e084e888 
[  115.350806]        803f8efc 00000010 803f8f24 8010b396 803f8f1c e084a274 00000000 8014716b 
[  115.452685]        83587e28 803f8f34 e084a314 00000000 00000001 83587e28 00000000 803f8f4c 
[  115.554564] Call Trace:
[  115.586167]  [<80102add>] show_trace_log_lvl+0x1a/0x2f
[  115.647916]  [<80102b8d>] show_stack_log_lvl+0x9b/0xa3
[  115.709668]  [<80102c37>] show_registers+0xa2/0x16b
[  115.768299]  [<80102df5>] die+0xf5/0x1c3
[  115.815494]  [<802f5957>] do_page_fault+0x440/0x519
[  115.874127]  [<802f44e2>] error_code+0x6a/0x70
[  115.927562]  [<e084b596>] x86_backtrace+0x4b/0x9d [oprofile]
[  115.995550]  [<e084a314>] oprofile_add_ext_sample+0x96/0xa6 [oprofile]
[  116.073934]  [<e084a3d5>] oprofile_add_sample+0x2e/0x34 [oprofile]
[  116.148160]  [<e084b509>] timer_notify+0xa/0xe [oprofile]
[  116.213028]  [<80111c7b>] profile_tick+0x20/0x54
[  116.268540]  [<80126fab>] tick_sched_timer+0x81/0xbb
[  116.328213]  [<80122d54>] hrtimer_interrupt+0x128/0x1b4
[  116.391002]  [<801043d1>] timer_interrupt+0x14/0x1b
[  116.449635]  [<8012e1b4>] handle_IRQ_event+0x21/0x48
[  116.509307]  [<8012f57b>] handle_level_irq+0xae/0xbb
[  116.568978]  [<801037fa>] do_IRQ+0xa3/0xc9
[  116.618255]  =======================
[  116.661082] Code: fb 77 16 8b 4d 08 8b 45 0c 8b 53 04 ff 51 08 8b 03 39 d8 76 04 89 c3 eb e2 8b 4d 08 ba f4 5e 34 80 8b 45 0c ff 51 0c 85 c0 78 10 <8b> 4e 34 85 c9 74 09 89 cb e8 97 b3 02 00 eb af 5e 5f 5b 5e 5f 
[  116.896546] EIP: [<80102aac>] dump_trace+0x86/0x9d SS:ESP 0068:803f8ed8
[  116.976179] Kernel panic - not syncing: Fatal exception in interrupt



#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc2
# Wed Nov  7 20:52:14 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
CONFIG_MK7=y
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_UP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_UP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
CONFIG_SATA_SIL24=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=y
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CX2341X=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_CORE_ATTACH=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
# CONFIG_DVB_BUDGET_AV is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_S5H1409 is not set

#
# Tuners/PLL support
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TDA827X is not set
# CONFIG_DVB_TUNER_QT1010 is not set
# CONFIG_DVB_TUNER_MT2060 is not set
# CONFIG_DVB_TUNER_MT2266 is not set
# CONFIG_DVB_TUNER_MT2131 is not set
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_TUA6100 is not set
CONFIG_VIDEO_TUNER=m
# CONFIG_VIDEO_TUNER_CUSTOMIZE is not set
CONFIG_TUNER_MT20XX=m
CONFIG_TUNER_TDA8290=m
CONFIG_TUNER_TEA5761=m
CONFIG_TUNER_TEA5767=m
CONFIG_TUNER_SIMPLE=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=y
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_KPROBES=y
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y



