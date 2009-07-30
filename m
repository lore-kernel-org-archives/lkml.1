Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZG3K3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZG3K3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZG3K3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:29:51 -0400
Received: from mail.pawisda.de ([213.157.4.156]:60266 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZG3K3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:29:50 -0400
Subject: Re: Warning during suspend with MS-7310 mainboard
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, rusty@rustcorp.com.au, davej@redhat.com,
       mark.langsdorf@amd.com
In-Reply-To: <1248936650.3313.6.camel@queen>
References: <1248936650.3313.6.camel@queen>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 12:27:51 +0200
Message-Id: <1248949671.3313.10.camel@queen>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

bisecting was faster than expected, reverting the commit removes the warning
http://patchwork.kernel.org/patch/29746/


1ff6e97f1d993dff2f9b6f4a9173687370660232 is first bad commit
commit 1ff6e97f1d993dff2f9b6f4a9173687370660232
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Jun 12 20:55:37 2009 +0930

    [CPUFREQ] cpumask: avoid playing with cpus_allowed in powernow-k8.c
    
    cpumask: avoid playing with cpus_allowed in powernow-k8.c
    
    It's generally a very bad idea to mug some process's cpumask: it could
    legitimately and reasonably be changed by root, which could break us
    (if done before our code) or them (if we restore the wrong value).
    
    I did not replace powernowk8_target; it needs fixing, but it grabs a
    mutex (so no smp_call_function_single here) but Mark points out it can
    be called multiple times per second, so work_on_cpu is too heavy.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: cpufreq@vger.kernel.org
    Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

:040000 040000 652d439088bdff0c275b3eec34bfd9c2481ee8a3 d5b5b112d3817d065bac80259189b335e04caed5 M	arch

Regards, Eric

On Thu, 2009-07-30 at 08:50 +0200, Eric Sesterhenn wrote:
> hi,
> 
> with 2.6.31-rc4 and todays -git i get the following warning, which did not occur with 2.6.30
> -rc4 is the first .31 kernel i tested on this box. This happens during test_suspend=standby during
> boot. Not sure if i find the time to do a bisect, but will try.
> 
> [    5.762460] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-8/2-8:1.0/input/input2
> [    5.762806] generic-usb 0003:046D:C03D.0003: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-8/input0
> [    5.763011] (elapsed 1.28 seconds) done.
> [    5.763108] PM: Entering standby sleep
> [    5.763149] Suspending console(s) (use no_console_suspend to debug)
> [    5.816837] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [    5.817087] sd 0:0:0:0: [sda] Stopping disk
> [    6.187771] ACPI handle has no context!
> [    6.189661] parport_pc 00:06: disabled
> [    6.191359] serial 00:05: disabled
> [    6.191858] forcedeth 0000:00:0a.0: wake-up capability disabled by ACPI
> [    6.191869] forcedeth 0000:00:0a.0: PME# disabled
> [    6.191967] forcedeth 0000:00:0a.0: PCI INT A disabled
> [    6.204457] sata_nv 0000:00:08.0: PCI INT A disabled
> [    6.220225] sata_nv 0000:00:07.0: PCI INT A disabled
> [    6.236182] ata6: port disabled. ignoring.
> [    6.252516] Intel ICH 0000:00:04.0: PCI INT A disabled
> [    6.252636] ehci_hcd 0000:00:02.1: PCI INT B disabled
> [    6.252702] ohci_hcd 0000:00:02.0: PCI INT A disabled
> [    6.253037] PM: suspend devices took 0.492 seconds
> [    6.254355] ehci_hcd 0000:00:02.1: PME# disabled
> [    6.268246] ohci_hcd 0000:00:02.0: PME# disabled
> [    6.284385] ACPI: Preparing to enter system sleep state S1
> [    6.288334] Disabling non-boot CPUs ...
> [    6.292678] CPU 1 is now offline
> [    6.292682] lockdep: fixing up alternatives.
> [    6.292690] SMP alternatives: switching to UP code
> [    6.304892] CPU0 attaching NULL sched-domain.
> [    6.305021] CPU1 attaching NULL sched-domain.
> [    6.305096] CPU0 attaching NULL sched-domain.
> [    6.307651] CPU1 is down
> [    6.308116] ------------[ cut here ]------------
> [    6.308116] WARNING: at kernel/smp.c:289 smp_call_function_single+0x11a/0x1c0()
> [    6.308116] Hardware name: MS-7310
> [    6.308116] Modules linked in:
> [    6.308116] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc4-00350-g658874f #39
> [    6.308116] Call Trace:
> [    6.308116]  [<ffffffff81054340>] warn_slowpath_common+0x80/0xd0
> [    6.308116]  [<ffffffff81020c30>] ? query_values_on_cpu+0x0/0x70
> [    6.308116]  [<ffffffff810543b2>] warn_slowpath_null+0x22/0x40
> [    6.308116]  [<ffffffff8108f8fa>] smp_call_function_single+0x11a/0x1c0
> [    6.308116]  [<ffffffff810209ec>] powernowk8_get+0x4c/0xa0
> [    6.308116]  [<ffffffff813f5ee2>] cpufreq_suspend+0xc2/0x140
> [    6.308116]  [<ffffffff812fc759>] sysdev_suspend+0xa9/0x310
> [    6.308116]  [<ffffffff8109615e>] suspend_devices_and_enter+0x1be/0x230
> [    6.308116]  [<ffffffff8109631a>] enter_state+0x14a/0x170
> [    6.308116]  [<ffffffff81096369>] pm_suspend+0x29/0x50
> [    6.308116]  [<ffffffff8178e0f2>] test_suspend+0x17a/0x1c9
> [    6.308116]  [<ffffffff8178df78>] ? test_suspend+0x0/0x1c9
> [    6.308116]  [<ffffffff8100907b>] do_one_initcall+0x4b/0x1a0
> [    6.308116]  [<ffffffff817778c8>] kernel_init+0x164/0x1d0
> [    6.308116]  [<ffffffff8100c83a>] child_rip+0xa/0x20
> [    6.308116]  [<ffffffff8100c1c0>] ? restore_args+0x0/0x30
> [    6.308116]  [<ffffffff81777764>] ? kernel_init+0x0/0x1d0
> [    6.308116]  [<ffffffff8100c830>] ? child_rip+0x0/0x20
> [    6.308116] ---[ end trace a7919e7f17c0a727 ]---
> [    6.308116] Back to C!
> [    6.314111] Enabling non-boot CPUs ...
> [    6.315133] lockdep: fixing up alternatives.
> [    6.315139] SMP alternatives: switching to SMP code
> [    6.326277] Booting processor 1 APIC 0x1 ip 0x6000
> [    6.303707] Initializing CPU#1
> [    6.341237] Calibrating delay using timer specific routine.. 2010.34 BogoMIPS (lpj=4020681)
> [    6.341237] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    6.341237] CPU: L2 Cache: 512K (64 bytes/line)
> [    6.341237] CPU: Physical Processor ID: 0
> [    6.341237] CPU: Processor Core ID: 1
> [    6.341237] mce: CPU supports 5 MCE banks
> [    6.416276] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
> [    6.416340] CPU0 attaching NULL sched-domain.
> [    6.417054] Switched to high resolution mode on CPU 1
> [    6.460106] CPU0 attaching sched-domain:
> [    6.460112]  domain 0: span 0-1 level MC
> [    6.460117]   groups: 0 1
> [    6.460133] CPU1 attaching sched-domain:
> [    6.460137]  domain 0: span 0-1 level MC
> [    6.460142]   groups: 1 0
> [    6.462076] CPU1 is up
> [    6.462083] ACPI: Waking up from system sleep state S1
> [    6.480063] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf (was 0x1030100, writing 0x1030105)
> [    6.480105] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00003)
> [    6.480135] ohci_hcd 0000:00:02.0: PME# disabled
> [    6.496074] ehci_hcd 0000:00:02.1: restoring config space at offset 0xf (was 0x1030200, writing 0x103020f)
> [    6.496115] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00002)
> [    6.496147] ehci_hcd 0000:00:02.1: PME# disabled
> [    6.512100] pata_amd 0000:00:06.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00005)
> [    6.528089] sata_nv 0000:00:07.0: restoring config space at offset 0xf (was 0x1030100, writing 0x1030106)
> [    6.528130] sata_nv 0000:00:07.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
> [    6.544115] sata_nv 0000:00:08.0: restoring config space at offset 0xf (was 0x1030100, writing 0x103010a)
> [    6.544154] sata_nv 0000:00:08.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
> [    6.560071] forcedeth 0000:00:0a.0: restoring config space at offset 0xf (was 0x14010100, writing 0x1401010b)
> [    6.560112] forcedeth 0000:00:0a.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
> [    6.561340] nForce2_smbus 0000:00:01.1: PME# disabled
> [    6.561356] ohci_hcd 0000:00:02.0: PME# disabled
> [    6.561379] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 23 (level, low) -> IRQ 23
> [    6.561392] ohci_hcd 0000:00:02.0: setting latency timer to 64
> [    6.584064] ehci_hcd 0000:00:02.1: PME# disabled
> [    6.584080] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 20 (level, low) -> IRQ 20
> [    6.584091] ehci_hcd 0000:00:02.1: setting latency timer to 64
> [    6.584166] Intel ICH 0000:00:04.0: PCI INT A -> Link[LACI] -> GSI 22 (level, low) -> IRQ 22
> [    6.584178] Intel ICH 0000:00:04.0: setting latency timer to 64
> [    6.594150] pata_amd 0000:00:06.0: setting latency timer to 64
> [    6.594262] sata_nv 0000:00:07.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
> [    6.594274] sata_nv 0000:00:07.0: setting latency timer to 64
> [    6.594371] sata_nv 0000:00:08.0: PCI INT A -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
> [    6.594382] sata_nv 0000:00:08.0: setting latency timer to 64
> [    6.594424] pci 0000:00:09.0: setting latency timer to 64
> [    6.594493] forcedeth 0000:00:0a.0: wake-up capability disabled by ACPI
> [    6.594503] forcedeth 0000:00:0a.0: PME# disabled
> [    6.608440] ata6: port disabled. ignoring.
> [    6.767115] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    6.767281] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    6.772306] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
> [    6.772313] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
> [    6.772402] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
> [    6.772427] ata2.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
> [    6.788330] ata2.00: configured for UDMA/100
> [    6.884030] Clocksource tsc unstable (delta = -250010099 ns)
> [    7.113182] pci 0000:05:00.0: PME# disabled
> [    7.120488] serial 00:05: activated
> [    7.129217] parport_pc 00:06: activated
> [    7.130131] sd 0:0:0:0: [sda] Starting disk
> [    7.316059] ata4: SATA link down (SStatus 0 SControl 300)
> [    7.332057] ata3: SATA link down (SStatus 0 SControl 300)
> [   11.420358] ata1.00: configured for UDMA/133
> [   11.431177] sda: detected capacity change from 0 to 250059350016
> [   11.714770] PM: resume devices took 5.152 seconds
> [   11.714775] ------------[ cut here ]------------
> [   11.714789] WARNING: at kernel/power/suspend_test.c:52 suspend_test_finish+0xa2/0xb0()
> [   11.714794] Hardware name: MS-7310
> [   11.714797] Component: resume devices
> [   11.714800] Modules linked in:
> [   11.714809] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc4-00350-g658874f #39
> [   11.714813] Call Trace:
> [   11.714826]  [<ffffffff81054340>] warn_slowpath_common+0x80/0xd0
> [   11.714835]  [<ffffffff8105441b>] warn_slowpath_fmt+0x4b/0x70
> [   11.714843]  [<ffffffff810964d2>] suspend_test_finish+0xa2/0xb0
> [   11.714852]  [<ffffffff81096075>] suspend_devices_and_enter+0xd5/0x230
> [   11.714859]  [<ffffffff8109631a>] enter_state+0x14a/0x170
> [   11.714867]  [<ffffffff81096369>] pm_suspend+0x29/0x50
> [   11.714876]  [<ffffffff8178e0f2>] test_suspend+0x17a/0x1c9
> [   11.714884]  [<ffffffff8178df78>] ? test_suspend+0x0/0x1c9
> [   11.714894]  [<ffffffff8100907b>] do_one_initcall+0x4b/0x1a0
> [   11.714905]  [<ffffffff817778c8>] kernel_init+0x164/0x1d0
> [   11.714914]  [<ffffffff8100c83a>] child_rip+0xa/0x20
> [   11.714922]  [<ffffffff8100c1c0>] ? restore_args+0x0/0x30
> [   11.714931]  [<ffffffff81777764>] ? kernel_init+0x0/0x1d0
> [   11.714938]  [<ffffffff8100c830>] ? child_rip+0x0/0x20
> [   11.714943] ---[ end trace a7919e7f17c0a728 ]---
> [   11.721610] PM: Finishing wakeup.
> [   11.721615] Restarting tasks ... done.
> 
> 
> Warning is this WARN_ON_ONCE:
> 
>         /*
>          * prevent preemption and reschedule on another processor,
>          * as well as CPU removal
>          */
>         this_cpu = get_cpu();
> 
>         /* Can deadlock when called with interrupts disabled */
>         WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
> 
> 
> alice snakebyte # lspci 
> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f3)
> 00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
> 00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
> 00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
> 00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
> 00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
> 00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
> 00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
> 00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
> 00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
> 00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
> 00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
> 00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 05:00.0 VGA compatible controller: nVidia Corporation GeForce 7100 GS (rev a1)
> 
> snakebyte@alice ~ $ cat /proc/cpuinfo 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 75
> model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
> stepping	: 2
> cpu MHz		: 1000.000
> cache size	: 512 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
> bogomips	: 2010.38
> TLB size	: 1024 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp tm stc
> 
> processor	: 1
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 75
> model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
> stepping	: 2
> cpu MHz		: 1000.000
> cache size	: 512 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> apicid		: 1
> initial apicid	: 1
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
> bogomips	: 2010.38
> TLB size	: 1024 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp tm stc
> 
> nakebyte@alice /usr/src/linux/scripts $ bash ./ver_linux 
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>  
> Linux alice 2.6.31-rc4-00350-g658874f #39 SMP PREEMPT Thu Jul 30 08:20:46 CEST 2009 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux
>  
> Gnu C                  4.4.1
> Gnu make               3.81
> binutils               2.19.1
> util-linux             ./ver_linux: line 23: fdformat: command not found
> mount                  support
> module-init-tools      found
> Linux C Library        2.10.1
> Dynamic linker (ldd)   2.10.1
> Procps                 3.2.8
> Kbd                    1.15
> Sh-utils               7.4
> Modules Loaded         
> 
> snakebyte@alice /usr/src/linux/scripts $ emerge -s util-linux
> Searching...   
> [ Results for search key : util-linux ]
> [ Applications found : 1 ]
>  
> *  sys-apps/util-linux
>       Latest version available: 2.16
> 
> 
> Regards, Eric
> 

