Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYCFJCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYCFJCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYCFJBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:01:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbYCFJBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:01:24 -0500
Date: Thu, 6 Mar 2008 10:00:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080306090029.GA6215@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In particular, the block layer changes should hopefully have sorted 
> themselves out, and CD burning etc hopefully works for people again. 

hm, tonight's randconfig bootrun produced a failing (soft-hung) kernel 
after about 120 iterations - and the log i captured _seems_ to indicate 
some block IO (or libata) completion weirdness.

unfortunately, it's not readily reproducible, and i triggered it with 
about 100 sched.git and 300 x86.git patches applied. BUT, virtually the 
same 100+300 patches queue produced a successful 1000+ randconfig 
testrun over the last weekend so i'm reasonably sure the regression is 
new and came in via upstream. Also, the config is UP (and it's a rather 
simple config in other aspects as well), so this must be something 
rather fundamental, not an SMP race.

I just spent about an hour trying to figure out a pattern but the bug 
just doesnt reproduce after 20 bootup attempts with the same bzImage. 
When it hung then it hung for hours, so the condition is permanent.

I've attached the bootup log which includes the SysRq-T output and the 
config. The hang seems to occur because an rc.sysinit task is not coming 
back from io_schedule():

rc.sysinit    D f75bcc24     0  1922   1893
       f761c810 00000086 f75bcd38 f75bcc24 1954bff5 00000015 f7746000 f761c974 
       f761c974 f7c17698 c180e7a8 f7747cc4 00000000 f7747ccc c180e7a8 c097bff7 
       c01a3acb c097c27d c01a3aa0 f7872a90 00000002 c01a3aa0 f7747e48 c097c2fc 
Call Trace:
 [<c097bff7>] io_schedule+0x37/0x70
 [<c01a3acb>] sync_buffer+0x2b/0x30
 [<c097c27d>] __wait_on_bit+0x4d/0x80
 [<c01a3aa0>] sync_buffer+0x0/0x30
 [<c01a3aa0>] sync_buffer+0x0/0x30
 [<c097c2fc>] out_of_line_wait_on_bit+0x4c/0x60
 [<c0142340>] wake_bit_function+0x0/0x40
 [<c01a3a51>] __wait_on_buffer+0x21/0x30
 [<c0209915>] ext3_bread+0x55/0x70
 [<c020cff8>] ext3_find_entry+0x258/0x660
 [<c03a0026>] avc_has_perm+0x46/0x50
 [<c03a0d14>] inode_has_perm+0x44/0x80
 [<c020de69>] ext3_lookup+0x29/0xa0
 [<c0189f90>] do_lookup+0x130/0x180
 [<c018b540>] __link_path_walk+0x340/0xd50
 [<c03a0d14>] inode_has_perm+0x44/0x80
 [<c018bf8a>] link_path_walk+0x3a/0xa0
 [<c016feb4>] __do_fault+0x1a4/0x3d0
 [<c018c1b7>] do_path_lookup+0x77/0x210
 [<c018cb57>] __user_walk_fd+0x27/0x40
 [<c01860d5>] vfs_stat_fd+0x15/0x40
 [<c016feb4>] __do_fault+0x1a4/0x3d0
 [<c01861ef>] sys_stat64+0xf/0x30
 [<c0125a5d>] do_page_fault+0x2ad/0x670
 [<c03db6cc>] trace_hardirqs_on_thunk+0xc/0x10
 [<c0115a5f>] sysenter_past_esp+0x5f/0x90
 =======================

So the last known-good kernel would be last Friday's -git:

  commit d395991c117d43bfca97101a931a41d062a93852
  Merge: b73384f... b445c56...
  Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
  Date:   Fri Feb 29 16:54:33 2008 -0800

but ... "git-log d395991c117d4.. block/" does not show anything 
particularly exciting. Note that the IO scheduler in question is:

  CONFIG_DEFAULT_IOSCHED="anticipatory"

so it's not the usual CFQ - that's due to randconfig.

	Ingo

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hang.log"

Linux version 2.6.25-rc4-sched-devel.git-x86-latest.git (mingo@dione) (gcc version 4.2.2) #166 PREEMPT Wed Mar 5 21:56:09 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
using polling idle threads.
127MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32497 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=tty console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled selinux=0 nmi_watchdog=2 idle=poll
debug: sysrq always enabled.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2160.191 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
console handover: boot [earlyser0] -> real [ttyS0]
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1024744k/1048512k available (8697k kernel code, 23204k reserved, 3074k data, 516k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffea000 - 0xfffff000   (  84 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0c82000 - 0xc0d03000   ( 516 kB)
      .data : 0xc097e42b - 0xc0c7ecc8   (3074 kB)
      .text : 0xc0100000 - 0xc097e42b   (8697 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4323.15 BogoMIPS (lpj=8646300)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0828)
PM: Adding info for No Bus:platform
Calling initcall 0xc0cbb7b0: init_cpufreq_transition_notifier_list+0x0/0x10()
initcall 0xc0cbb7b0: init_cpufreq_transition_notifier_list+0x0/0x10() returned 0.
initcall 0xc0cbb7b0 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x10()
Calling initcall 0xc0cbe980: net_ns_init+0x0/0x180()
net_namespace: 156 bytes
initcall 0xc0cbe980: net_ns_init+0x0/0x180() returned 0.
initcall 0xc0cbe980 ran for 3 msecs: net_ns_init+0x0/0x180()
Calling initcall 0xc0c87a60: cpufreq_tsc+0x0/0x10()
initcall 0xc0c87a60: cpufreq_tsc+0x0/0x10() returned 0.
initcall 0xc0c87a60 ran for 0 msecs: cpufreq_tsc+0x0/0x10()
Calling initcall 0xc0c89ea0: reboot_init+0x0/0x10()
initcall 0xc0c89ea0: reboot_init+0x0/0x10() returned 0.
initcall 0xc0c89ea0 ran for 0 msecs: reboot_init+0x0/0x10()
Calling initcall 0xc0c8c420: sysctl_init+0x0/0x30()
initcall 0xc0c8c420: sysctl_init+0x0/0x30() returned 0.
initcall 0xc0c8c420 ran for 0 msecs: sysctl_init+0x0/0x30()
Calling initcall 0xc0c8cb40: ksysfs_init+0x0/0xa0()
initcall 0xc0c8cb40: ksysfs_init+0x0/0xa0() returned 0.
initcall 0xc0c8cb40 ran for 0 msecs: ksysfs_init+0x0/0xa0()
Calling initcall 0xc0c8cee0: init_jiffies_clocksource+0x0/0x10()
initcall 0xc0c8cee0: init_jiffies_clocksource+0x0/0x10() returned 0.
initcall 0xc0c8cee0 ran for 0 msecs: init_jiffies_clocksource+0x0/0x10()
Calling initcall 0xc0c8d090: pm_init+0x0/0x30()
initcall 0xc0c8d090: pm_init+0x0/0x30() returned 0.
initcall 0xc0c8d090 ran for 0 msecs: pm_init+0x0/0x30()
Calling initcall 0xc0c8f990: filelock_init+0x0/0x30()
initcall 0xc0c8f990: filelock_init+0x0/0x30() returned 0.
initcall 0xc0c8f990 ran for 0 msecs: filelock_init+0x0/0x30()
Calling initcall 0xc0c90240: init_misc_binfmt+0x0/0x40()
initcall 0xc0c90240: init_misc_binfmt+0x0/0x40() returned 0.
initcall 0xc0c90240 ran for 0 msecs: init_misc_binfmt+0x0/0x40()
Calling initcall 0xc0c90280: init_script_binfmt+0x0/0x10()
initcall 0xc0c90280: init_script_binfmt+0x0/0x10() returned 0.
initcall 0xc0c90280 ran for 0 msecs: init_script_binfmt+0x0/0x10()
Calling initcall 0xc0c90290: init_elf_binfmt+0x0/0x10()
initcall 0xc0c90290: init_elf_binfmt+0x0/0x10() returned 0.
initcall 0xc0c90290 ran for 0 msecs: init_elf_binfmt+0x0/0x10()
Calling initcall 0xc0c91f80: debugfs_init+0x0/0x50()
initcall 0xc0c91f80: debugfs_init+0x0/0x50() returned 0.
initcall 0xc0c91f80 ran for 0 msecs: debugfs_init+0x0/0x50()
Calling initcall 0xc0c92820: securityfs_init+0x0/0x50()
initcall 0xc0c92820: securityfs_init+0x0/0x50() returned 0.
initcall 0xc0c92820 ran for 0 msecs: securityfs_init+0x0/0x50()
Calling initcall 0xc0c938e0: random32_init+0x0/0x20()
initcall 0xc0c938e0: random32_init+0x0/0x20() returned 0.
initcall 0xc0c938e0 ran for 0 msecs: random32_init+0x0/0x20()
Calling initcall 0xc0cbb7c0: cpufreq_core_init+0x0/0x30()
initcall 0xc0cbb7c0: cpufreq_core_init+0x0/0x30() returned 0.
initcall 0xc0cbb7c0 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
Calling initcall 0xc0cbe860: sock_init+0x0/0x50()
initcall 0xc0cbe860: sock_init+0x0/0x50() returned 0.
initcall 0xc0cbe860 ran for 0 msecs: sock_init+0x0/0x50()
Calling initcall 0xc0cbf3f0: netpoll_init+0x0/0x30()
initcall 0xc0cbf3f0: netpoll_init+0x0/0x30() returned 0.
initcall 0xc0cbf3f0 ran for 0 msecs: netpoll_init+0x0/0x30()
Calling initcall 0xc0cbf910: netlink_proto_init+0x0/0x140()
NET: Registered protocol family 16
initcall 0xc0cbf910: netlink_proto_init+0x0/0x140() returned 0.
initcall 0xc0cbf910 ran for 3 msecs: netlink_proto_init+0x0/0x140()
Calling initcall 0xc0c937d0: kobject_uevent_init+0x0/0x40()
initcall 0xc0c937d0: kobject_uevent_init+0x0/0x40() returned 0.
initcall 0xc0c937d0 ran for 0 msecs: kobject_uevent_init+0x0/0x40()
Calling initcall 0xc0c939d0: pcibus_class_init+0x0/0x10()
initcall 0xc0c939d0: pcibus_class_init+0x0/0x10() returned 0.
initcall 0xc0c939d0 ran for 0 msecs: pcibus_class_init+0x0/0x10()
Calling initcall 0xc0c93fc0: pci_driver_init+0x0/0x10()
initcall 0xc0c93fc0: pci_driver_init+0x0/0x10() returned 0.
initcall 0xc0c93fc0 ran for 0 msecs: pci_driver_init+0x0/0x10()
Calling initcall 0xc0c94360: backlight_class_init+0x0/0x40()
initcall 0xc0c94360: backlight_class_init+0x0/0x40() returned 0.
initcall 0xc0c94360 ran for 0 msecs: backlight_class_init+0x0/0x40()
Calling initcall 0xc0c95e40: video_output_class_init+0x0/0xa()
initcall 0xc0c95e40: video_output_class_init+0x0/0xa() returned 0.
initcall 0xc0c95e40 ran for 0 msecs: video_output_class_init+0x0/0xa()
Calling initcall 0xc0c970c6: dock_init+0x0/0x48()
No dock devices found.
initcall 0xc0c970c6: dock_init+0x0/0x48() returned 0.
initcall 0xc0c970c6 ran for 3 msecs: dock_init+0x0/0x48()
Calling initcall 0xc0c9710e: bay_init+0x0/0x48()
initcall 0xc0c9710e: bay_init+0x0/0x48() returned -19.
initcall 0xc0c9710e ran for 0 msecs: bay_init+0x0/0x48()
Calling initcall 0xc0c98320: tty_class_init+0x0/0x20()
initcall 0xc0c98320: tty_class_init+0x0/0x20() returned 0.
initcall 0xc0c98320 ran for 0 msecs: tty_class_init+0x0/0x20()
Calling initcall 0xc0c98dc0: vtconsole_class_init+0x0/0xb0()
PM: Adding info for No Bus:vtcon0
initcall 0xc0c98dc0: vtconsole_class_init+0x0/0xb0() returned 0.
initcall 0xc0c98dc0 ran for 3 msecs: vtconsole_class_init+0x0/0xb0()
Calling initcall 0xc0cbb090: eisa_init+0x0/0x20()
EISA bus registered
initcall 0xc0cbb090: eisa_init+0x0/0x20() returned 0.
initcall 0xc0cbb090 ran for 3 msecs: eisa_init+0x0/0x20()
Calling initcall 0xc0c87850: arch_kdebugfs_init+0x0/0x10()
initcall 0xc0c87850: arch_kdebugfs_init+0x0/0x10() returned 0.
initcall 0xc0c87850 ran for 0 msecs: arch_kdebugfs_init+0x0/0x10()
Calling initcall 0xc0c878e0: init_pit_clocksource+0x0/0xa0()
initcall 0xc0c878e0: init_pit_clocksource+0x0/0xa0() returned 0.
initcall 0xc0c878e0 ran for 0 msecs: init_pit_clocksource+0x0/0xa0()
Calling initcall 0xc0c88650: mtrr_if_init+0x0/0x50()
initcall 0xc0c88650: mtrr_if_init+0x0/0x50() returned 0.
initcall 0xc0c88650 ran for 0 msecs: mtrr_if_init+0x0/0x50()
Calling initcall 0xc0c8a180: kdump_buf_page_init+0x0/0x30()
initcall 0xc0c8a180: kdump_buf_page_init+0x0/0x30() returned 0.
initcall 0xc0c8a180 ran for 0 msecs: kdump_buf_page_init+0x0/0x30()
Calling initcall 0xc0c941d0: acpi_pci_init+0x0/0x50()
ACPI: bus type pci registered
initcall 0xc0c941d0: acpi_pci_init+0x0/0x50() returned 0.
initcall 0xc0c941d0 ran for 3 msecs: acpi_pci_init+0x0/0x50()
Calling initcall 0xc0c96d36: init_acpi_device_notify+0x0/0x3f()
initcall 0xc0c96d36: init_acpi_device_notify+0x0/0x3f() returned 0.
initcall 0xc0c96d36 ran for 0 msecs: init_acpi_device_notify+0x0/0x3f()
Calling initcall 0xc0cbcd20: dmi_id_init+0x0/0x290()
PM: Adding info for No Bus:id
initcall 0xc0cbcd20: dmi_id_init+0x0/0x290() returned 0.
initcall 0xc0cbcd20 ran for 0 msecs: dmi_id_init+0x0/0x290()
Calling initcall 0xc0cbd750: pci_access_init+0x0/0x50()
PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
PCI: Using configuration type 1 for base access
initcall 0xc0cbd750: pci_access_init+0x0/0x50() returned 0.
initcall 0xc0cbd750 ran for 11 msecs: pci_access_init+0x0/0x50()
Calling initcall 0xc0c86150: request_standard_resources+0x0/0x70()
Setting up standard PCI resources
initcall 0xc0c86150: request_standard_resources+0x0/0x70() returned 0.
initcall 0xc0c86150 ran for 7 msecs: request_standard_resources+0x0/0x70()
Calling initcall 0xc0c87840: topology_init+0x0/0x10()
initcall 0xc0c87840: topology_init+0x0/0x10() returned 0.
initcall 0xc0c87840 ran for 0 msecs: topology_init+0x0/0x10()
Calling initcall 0xc0c881c0: mtrr_init_finialize+0x0/0x40()
initcall 0xc0c881c0: mtrr_init_finialize+0x0/0x40() returned 0.
initcall 0xc0c881c0 ran for 0 msecs: mtrr_init_finialize+0x0/0x40()
Calling initcall 0xc0c8c840: param_sysfs_init+0x0/0x180()
initcall 0xc0c8c840: param_sysfs_init+0x0/0x180() returned 0.
initcall 0xc0c8c840 ran for 3 msecs: param_sysfs_init+0x0/0x180()
Calling initcall 0xc014ffd0: pm_sysrq_init+0x0/0x20()
initcall 0xc014ffd0: pm_sysrq_init+0x0/0x20() returned 0.
initcall 0xc014ffd0 ran for 0 msecs: pm_sysrq_init+0x0/0x20()
Calling initcall 0xc0c8f020: readahead_init+0x0/0x10()
initcall 0xc0c8f020: readahead_init+0x0/0x10() returned 0.
initcall 0xc0c8f020 ran for 0 msecs: readahead_init+0x0/0x10()
Calling initcall 0xc0c8ff90: init_bio+0x0/0xe0()
initcall 0xc0c8ff90: init_bio+0x0/0xe0() returned 0.
initcall 0xc0c8ff90 ran for 0 msecs: init_bio+0x0/0xe0()
Calling initcall 0xc0c93480: blk_settings_init+0x0/0x20()
initcall 0xc0c93480: blk_settings_init+0x0/0x20() returned 0.
initcall 0xc0c93480 ran for 0 msecs: blk_settings_init+0x0/0x20()
Calling initcall 0xc0c934a0: blk_ioc_init+0x0/0x30()
initcall 0xc0c934a0: blk_ioc_init+0x0/0x30() returned 0.
initcall 0xc0c934a0 ran for 0 msecs: blk_ioc_init+0x0/0x30()
Calling initcall 0xc0c934d0: genhd_device_init+0x0/0x30()
initcall 0xc0c934d0: genhd_device_init+0x0/0x30() returned 0.
initcall 0xc0c934d0 ran for 0 msecs: genhd_device_init+0x0/0x30()
Calling initcall 0xc0c94220: fbmem_init+0x0/0x90()
initcall 0xc0c94220: fbmem_init+0x0/0x90() returned 0.
initcall 0xc0c94220 ran for 0 msecs: fbmem_init+0x0/0x90()
Calling initcall 0xc0c96b1a: acpi_init+0x0/0x21c()
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
initcall 0xc0c96b1a: acpi_init+0x0/0x21c() returned 0.
initcall 0xc0c96b1a ran for 19 msecs: acpi_init+0x0/0x21c()
Calling initcall 0xc0c96e4e: acpi_scan_init+0x0/0xef()
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXPWRBN:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:ATK0110:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:08
PM: Adding info for acpi:PNP0C0F:09
PM: Adding info for acpi:PNP0C0F:0a
PM: Adding info for acpi:PNP0C0F:0b
PM: Adding info for acpi:PNP0C0F:0c
PM: Adding info for acpi:PNP0C0F:0d
PM: Adding info for acpi:PNP0C0F:0e
PM: Adding info for acpi:PNP0C0F:0f
PM: Adding info for acpi:PNP0C0F:10
PM: Adding info for acpi:PNP0C0F:11
PM: Adding info for acpi:PNP0C0F:12
PM: Adding info for acpi:PNP0C0F:13
PM: Adding info for acpi:PNP0C0F:14
PM: Adding info for acpi:PNP0C0F:15
PM: Adding info for acpi:PNP0C0F:16
PM: Adding info for acpi:PNP0C0F:17
PM: Adding info for acpi:PNP0C0F:18
PM: Adding info for acpi:PNP0C0F:19
PM: Adding info for acpi:PNP0C0F:1a
PM: Adding info for acpi:PNP0C0F:1b
PM: Adding info for acpi:PNP0C0F:1c
PM: Adding info for acpi:PNP0C0F:1d
PM: Adding info for acpi:PNP0C0F:1e
PM: Adding info for acpi:PNP0C0F:1f
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0F13:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNPB006:00
PM: Adding info for acpi:PNPB02F:00
PM: Adding info for acpi:PNP0C02:02
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:LNXTHERM:01
initcall 0xc0c96e4e: acpi_scan_init+0x0/0xef() returned 0.
initcall 0xc0c96e4e ran for 282 msecs: acpi_scan_init+0x0/0xef()
Calling initcall 0xc0c96f3d: acpi_ec_init+0x0/0x51()
initcall 0xc0c96f3d: acpi_ec_init+0x0/0x51() returned 0.
initcall 0xc0c96f3d ran for 0 msecs: acpi_ec_init+0x0/0x51()
Calling initcall 0xc0c97156: acpi_pci_root_init+0x0/0x21()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:01.1
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:04.0
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:09.0
PM: Adding info for pci:0000:00:0a.0
PM: Adding info for pci:0000:00:0b.0
PM: Adding info for pci:0000:00:0c.0
PM: Adding info for pci:0000:00:0d.0
PM: Adding info for pci:0000:00:0e.0
PM: Adding info for pci:0000:00:18.0
PM: Adding info for pci:0000:00:18.1
PM: Adding info for pci:0000:00:18.2
PM: Adding info for pci:0000:00:18.3
PM: Adding info for pci:0000:05:07.0
PM: Adding info for No Bus:0000:05
PM: Adding info for No Bus:0000:04
PM: Adding info for No Bus:0000:03
PM: Adding info for No Bus:0000:02
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.1
PM: Adding info for No Bus:0000:01
initcall 0xc0c97156: acpi_pci_root_init+0x0/0x21() returned 0.
initcall 0xc0c97156 ran for 160 msecs: acpi_pci_root_init+0x0/0x21()
Calling initcall 0xc0c97231: acpi_pci_link_init+0x0/0x3f()
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
initcall 0xc0c97231: acpi_pci_link_init+0x0/0x3f() returned 0.
initcall 0xc0c97231 ran for 202 msecs: acpi_pci_link_init+0x0/0x3f()
Calling initcall 0xc0c972eb: acpi_power_init+0x0/0x65()
initcall 0xc0c972eb: acpi_power_init+0x0/0x65() returned 0.
initcall 0xc0c972eb ran for 0 msecs: acpi_power_init+0x0/0x65()
Calling initcall 0xc0c97350: acpi_system_init+0x0/0x1fc()
initcall 0xc0c97350: acpi_system_init+0x0/0x1fc() returned 0.
initcall 0xc0c97350 ran for 0 msecs: acpi_system_init+0x0/0x1fc()
Calling initcall 0xc0c976e2: acpi_cm_sbs_init+0x0/0x3()
initcall 0xc0c976e2: acpi_cm_sbs_init+0x0/0x3() returned 0.
initcall 0xc0c976e2 ran for 0 msecs: acpi_cm_sbs_init+0x0/0x3()
Calling initcall 0xc0c97740: pnp_init+0x0/0x20()
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall 0xc0c97740: pnp_init+0x0/0x20() returned 0.
initcall 0xc0c97740 ran for 3 msecs: pnp_init+0x0/0x20()
Calling initcall 0xc0c97960: pnpacpi_init+0x0/0x90()
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
 00:01: calling quirk 0xc0453ae0: quirk_supermicro_h8dce_system+0x0/0x190()
PM: Adding info for pnp:00:01
pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:02: calling quirk 0xc0453ae0: quirk_supermicro_h8dce_system+0x0/0x190()
PM: Adding info for pnp:00:02
pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
PM: Adding info for pnp:00:03
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
PM: Adding info for pnp:00:04
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
PM: Adding info for pnp:00:05
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
PM: Adding info for pnp:00:06
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
PM: Adding info for pnp:00:07
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
PM: Adding info for pnp:00:08
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
PM: Adding info for pnp:00:09
pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
PM: Adding info for pnp:00:0a
pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
PM: Adding info for pnp:00:0b
pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
PM: Adding info for pnp:00:0c
pnp 00:0c: Plug and Play ACPI device, IDs PNPb006 (active)
PM: Adding info for pnp:00:0d
pnp 00:0d: Plug and Play ACPI device, IDs PNPb02f (active)
 00:0e: calling quirk 0xc0453ae0: quirk_supermicro_h8dce_system+0x0/0x190()
PM: Adding info for pnp:00:0e
pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnpacpi: exceeded the max number of mem resources: 12
 00:0f: calling quirk 0xc0453ae0: quirk_supermicro_h8dce_system+0x0/0x190()
PM: Adding info for pnp:00:0f
pnp 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
initcall 0xc0c97960: pnpacpi_init+0x0/0x90() returned 0.
initcall 0xc0c97960 ran for 171 msecs: pnpacpi_init+0x0/0x90()
Calling initcall 0xc0c988e0: misc_init+0x0/0x70()
initcall 0xc0c988e0: misc_init+0x0/0x70() returned 0.
initcall 0xc0c988e0 ran for 0 msecs: misc_init+0x0/0x70()
Calling initcall 0xc094fef0: cn_init+0x0/0xc0()
initcall 0xc094fef0: cn_init+0x0/0xc0() returned 0.
initcall 0xc094fef0 ran for 0 msecs: cn_init+0x0/0xc0()
Calling initcall 0xc0ca07f0: phy_init+0x0/0x30()
initcall 0xc0ca07f0: phy_init+0x0/0x30() returned 0.
initcall 0xc0ca07f0 ran for 0 msecs: phy_init+0x0/0x30()
Calling initcall 0xc0ca98b0: init_scsi+0x0/0x90()
SCSI subsystem initialized
initcall 0xc0ca98b0: init_scsi+0x0/0x90() returned 0.
initcall 0xc0ca98b0 ran for 3 msecs: init_scsi+0x0/0x90()
Calling initcall 0xc0cb4fd0: ata_init+0x0/0x3b0()
libata version 3.00 loaded.
initcall 0xc0cb4fd0: ata_init+0x0/0x3b0() returned 0.
initcall 0xc0cb4fd0 ran for 3 msecs: ata_init+0x0/0x3b0()
Calling initcall 0xc0cb6ef0: usb_init+0x0/0x120()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc0cb6ef0: usb_init+0x0/0x120() returned 0.
initcall 0xc0cb6ef0 ran for 11 msecs: usb_init+0x0/0x120()
Calling initcall 0xc0cb88e0: serio_init+0x0/0x90()
initcall 0xc0cb88e0: serio_init+0x0/0x90() returned 0.
initcall 0xc0cb88e0 ran for 0 msecs: serio_init+0x0/0x90()
Calling initcall 0xc0cb8f00: gameport_init+0x0/0x90()
initcall 0xc0cb8f00: gameport_init+0x0/0x90() returned 0.
initcall 0xc0cb8f00 ran for 0 msecs: gameport_init+0x0/0x90()
Calling initcall 0xc0cb9340: input_init+0x0/0xf0()
initcall 0xc0cb9340: input_init+0x0/0xf0() returned 0.
initcall 0xc0cb9340 ran for 0 msecs: input_init+0x0/0xf0()
Calling initcall 0xc0cba3a0: rtc_init+0x0/0x50()
initcall 0xc0cba3a0: rtc_init+0x0/0x50() returned 0.
initcall 0xc0cba3a0 ran for 0 msecs: rtc_init+0x0/0x50()
Calling initcall 0xc0cba740: i2c_init+0x0/0x60()
i2c-core: driver [dummy] registered
initcall 0xc0cba740: i2c_init+0x0/0x60() returned 0.
initcall 0xc0cba740 ran for 3 msecs: i2c_init+0x0/0x60()
Calling initcall 0xc0cbaef0: tps_init+0x0/0x90()
tps65010: version 2 May 2005
i2c-core: driver [tps65010] registered
i2c-core: driver [tps65010] unregistered
tps65010: re-probe ...
i2c-core: driver [tps65010] registered
i2c-core: driver [tps65010] unregistered
tps65010: re-probe ...
i2c-core: driver [tps65010] registered
i2c-core: driver [tps65010] unregistered
tps65010: no chip?
initcall 0xc0cbaef0: tps_init+0x0/0x90() returned -19.
initcall 0xc0cbaef0 ran for 57 msecs: tps_init+0x0/0x90()
Calling initcall 0xc0cbb020: power_supply_class_init+0x0/0x30()
initcall 0xc0cbb020: power_supply_class_init+0x0/0x30() returned 0.
initcall 0xc0cbb020 ran for 0 msecs: power_supply_class_init+0x0/0x30()
Calling initcall 0xc0cbb060: thermal_init+0x0/0x30()
initcall 0xc0cbb060: thermal_init+0x0/0x30() returned 0.
initcall 0xc0cbb060 ran for 0 msecs: thermal_init+0x0/0x30()
Calling initcall 0xc0cbb870: mmc_init+0x0/0x80()
initcall 0xc0cbb870: mmc_init+0x0/0x80() returned 0.
initcall 0xc0cbb870 ran for 0 msecs: mmc_init+0x0/0x80()
Calling initcall 0xc0cbd1a0: dma_bus_init+0x0/0x20()
initcall 0xc0cbd1a0: dma_bus_init+0x0/0x20() returned 0.
initcall 0xc0cbd1a0 ran for 0 msecs: dma_bus_init+0x0/0x20()
Calling initcall 0xc0cbd410: ac97_bus_init+0x0/0x10()
initcall 0xc0cbd410: ac97_bus_init+0x0/0x10() returned 0.
initcall 0xc0cbd410 ran for 0 msecs: ac97_bus_init+0x0/0x10()
Calling initcall 0xc0cbdcf0: pci_acpi_init+0x0/0xb0()
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
initcall 0xc0cbdcf0: pci_acpi_init+0x0/0xb0() returned 0.
initcall 0xc0cbdcf0 ran for 3 msecs: pci_acpi_init+0x0/0xb0()
Calling initcall 0xc0cbdda0: pci_legacy_init+0x0/0xf0()
initcall 0xc0cbdda0: pci_legacy_init+0x0/0xf0() returned 0.
initcall 0xc0cbdda0 ran for 0 msecs: pci_legacy_init+0x0/0xf0()
Calling initcall 0xc0cbe3b0: pcibios_irq_init+0x0/0x420()
initcall 0xc0cbe3b0: pcibios_irq_init+0x0/0x420() returned 0.
initcall 0xc0cbe3b0 ran for 0 msecs: pcibios_irq_init+0x0/0x420()
Calling initcall 0xc0cbe7d0: pcibios_init+0x0/0x90()
initcall 0xc0cbe7d0: pcibios_init+0x0/0x90() returned 0.
initcall 0xc0cbe7d0 ran for 49 msecs: pcibios_init+0x0/0x90()
Calling initcall 0xc0cbe910: proto_init+0x0/0x30()
initcall 0xc0cbe910: proto_init+0x0/0x30() returned 0.
initcall 0xc0cbe910 ran for 0 msecs: proto_init+0x0/0x30()
Calling initcall 0xc0cbedb0: net_dev_init+0x0/0x130()
initcall 0xc0cbedb0: net_dev_init+0x0/0x130() returned 0.
initcall 0xc0cbedb0 ran for 0 msecs: net_dev_init+0x0/0x130()
Calling initcall 0xc0cbef20: neigh_init+0x0/0x70()
initcall 0xc0cbef20: neigh_init+0x0/0x70() returned 0.
initcall 0xc0cbef20 ran for 0 msecs: neigh_init+0x0/0x70()
Calling initcall 0xc0cbf420: fib_rules_init+0x0/0xb0()
initcall 0xc0cbf420: fib_rules_init+0x0/0xb0() returned 0.
initcall 0xc0cbf420 ran for 0 msecs: fib_rules_init+0x0/0xb0()
Calling initcall 0xc0cbfa50: genl_init+0x0/0xc0()
initcall 0xc0cbfa50: genl_init+0x0/0xc0() returned 0.
initcall 0xc0cbfa50 ran for 0 msecs: genl_init+0x0/0xc0()
Calling initcall 0xc0cc1020: wanrouter_init+0x0/0x40()
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall 0xc0cc1020: wanrouter_init+0x0/0x40() returned 0.
initcall 0xc0cc1020 ran for 3 msecs: wanrouter_init+0x0/0x40()
Calling initcall 0xc0cc1590: irda_init+0x0/0xb0()
irda_init()
NET: Registered protocol family 23
initcall 0xc0cc1590: irda_init+0x0/0xb0() returned 0.
initcall 0xc0cc1590 ran for 3 msecs: irda_init+0x0/0xb0()
Calling initcall 0xc0cc1cc0: atm_init+0x0/0xb0()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xc0cc1cc0: atm_init+0x0/0xb0() returned 0.
initcall 0xc0cc1cc0 ran for 3 msecs: atm_init+0x0/0xb0()
Calling initcall 0xc0cc2b90: wireless_nlevent_init+0x0/0x30()
initcall 0xc0cc2b90: wireless_nlevent_init+0x0/0x30() returned 0.
initcall 0xc0cc2b90 ran for 0 msecs: wireless_nlevent_init+0x0/0x30()
Calling initcall 0xc0cc2cc0: sysctl_init+0x0/0x20()
initcall 0xc0cc2cc0: sysctl_init+0x0/0x20() returned 0.
initcall 0xc0cc2cc0 ran for 0 msecs: sysctl_init+0x0/0x20()
Calling initcall 0xc0c8a7b0: hpet_late_init+0x0/0x100()
initcall 0xc0c8a7b0: hpet_late_init+0x0/0x100() returned -19.
initcall 0xc0c8a7b0 ran for 0 msecs: hpet_late_init+0x0/0x100()
Calling initcall 0xc0c8cde0: clocksource_done_booting+0x0/0x10()
initcall 0xc0c8cde0<6>Time: tsc clocksource has been installed.
: clocksource_done_booting+0x0/0x10() returned 0.
initcall 0xc0c8cde0 ran for 0 msecs: clocksource_done_booting+0x0/0x10()
Calling initcall 0xc0c8d5f0: tracer_alloc_buffers+0x0/0x510()
tracer: 128 pages allocated for 16384<6> entries of 32 bytes
   actual entries 16384
initcall 0xc0c8d5f0: tracer_alloc_buffers+0x0/0x510() returned 0.
initcall 0xc0c8d5f0 ran for 7 msecs: tracer_alloc_buffers+0x0/0x510()
Calling initcall 0xc0c8f910: init_pipe_fs+0x0/0x50()
initcall 0xc0c8f910: init_pipe_fs+0x0/0x50() returned 0.
initcall 0xc0c8f910 ran for 0 msecs: init_pipe_fs+0x0/0x50()
Calling initcall 0xc0c900e0: eventpoll_init+0x0/0x70()
initcall 0xc0c900e0: eventpoll_init+0x0/0x70() returned 0.
initcall 0xc0c900e0 ran for 0 msecs: eventpoll_init+0x0/0x70()
Calling initcall 0xc0c90150: anon_inode_init+0x0/0xf0()
initcall 0xc0c90150: anon_inode_init+0x0/0xf0() returned 0.
initcall 0xc0c90150 ran for 0 msecs: anon_inode_init+0x0/0xf0()
Calling initcall 0xc0c96da3: acpi_rtc_init+0x0/0xab()
ACPI: RTC can wake from S4
initcall 0xc0c96da3: acpi_rtc_init+0x0/0xab() returned 0.
initcall 0xc0c96da3 ran for 2 msecs: acpi_rtc_init+0x0/0xab()
Calling initcall 0xc0c9754c: acpi_event_init+0x0/0x42()
initcall 0xc0c9754c: acpi_event_init+0x0/0x42() returned 0.
initcall 0xc0c9754c ran for 0 msecs: acpi_event_init+0x0/0x42()
Calling initcall 0xc0c97860: pnp_system_init+0x0/0x10()
pnp: the driver 'system' has been registered
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x4080-0x40ff has been reserved
system 00:01: ioport range 0x4400-0x447f has been reserved
system 00:01: ioport range 0x4480-0x44ff has been reserved
system 00:01: ioport range 0x4800-0x487f has been reserved
system 00:01: ioport range 0x4880-0x48ff has been reserved
system 00:01: driver attached
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:02: driver attached
system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0e: driver attached
system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:0f: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:0f: iomem range 0xfefff000-0xfeffffff could not be reserved
system 00:0f: iomem range 0xfff80000-0xfff80fff could not be reserved
system 00:0f: driver attached
initcall 0xc0c97860: pnp_system_init+0x0/0x10() returned 0.
initcall 0xc0c97860 ran for 132 msecs: pnp_system_init+0x0/0x10()
Calling initcall 0xc0c98220: chr_dev_init+0x0/0xc0()
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
initcall 0xc0c98220: chr_dev_init+0x0/0xc0() returned 0.
initcall 0xc0c98220 ran for 28 msecs: chr_dev_init+0x0/0xc0()
Calling initcall 0xc0c9d9c0: firmware_class_init+0x0/0x70()
initcall 0xc0c9d9c0: firmware_class_init+0x0/0x70() returned 0.
initcall 0xc0c9d9c0 ran for 0 msecs: firmware_class_init+0x0/0x70()
Calling initcall 0xc0ca0af0: loopback_init+0x0/0x10()
PM: Adding info for No Bus:lo
initcall 0xc0ca0af0: loopback_init+0x0/0x10() returned 0.
initcall 0xc0ca0af0 ran for 2 msecs: loopback_init+0x0/0x10()
Calling initcall 0xc0cbb850: cpufreq_gov_performance_init+0x0/0x10()
initcall 0xc0cbb850: cpufreq_gov_performance_init+0x0/0x10() returned 0.
initcall 0xc0cbb850 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x10()
Calling initcall 0xc0cbcfe0: init_acpi_pm_clocksource+0x0/0x1c0()
initcall 0xc0cbcfe0: init_acpi_pm_clocksource+0x0/0x1c0() returned 0.
initcall 0xc0cbcfe0 ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x1c0()
Calling initcall 0xc0cbd370: ssb_modinit+0x0/0x50()
initcall 0xc0cbd370: ssb_modinit+0x0/0x50() returned 0.
initcall 0xc0cbd370 ran for 0 msecs: ssb_modinit+0x0/0x50()
Calling initcall 0xc0cbd420: pcibios_assign_resources+0x0/0xa0()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: 0xda000000-0xda0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: b000-bfff
  MEM window: 0xd8000000-0xd9ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
initcall 0xc0cbd420: pcibios_assign_resources+0x0/0xa0() returned 0.
initcall 0xc0cbd420 ran for 72 msecs: pcibios_assign_resources+0x0/0xa0()
Calling initcall 0xc0cc0510: inet_init+0x0/0x330()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc0cc0510: inet_init+0x0/0x330() returned 0.
initcall 0xc0cc0510 ran for 27 msecs: inet_init+0x0/0x330()
Calling initcall 0xc0c85740: default_rootfs+0x0/0x70()
initcall 0xc0c85740: default_rootfs+0x0/0x70() returned 0.
initcall 0xc0c85740 ran for 0 msecs: default_rootfs+0x0/0x70()
Calling initcall 0xc0c857d0: svm_init+0x0/0x20()
has_svm: svm not available
kvm: no hardware support
initcall 0xc0c857d0: svm_init+0x0/0x20() returned -95.
initcall 0xc0c857d0 ran for 5 msecs: svm_init+0x0/0x20()
initcall at 0xc0c857d0: svm_init+0x0/0x20(): returned with error code -95
Calling initcall 0xc0c86610: i8259A_init_sysfs+0x0/0x20()
initcall 0xc0c86610: i8259A_init_sysfs+0x0/0x20() returned 0.
initcall 0xc0c86610 ran for 0 msecs: i8259A_init_sysfs+0x0/0x20()
Calling initcall 0xc0c86730: sbf_init+0x0/0x160()
initcall 0xc0c86730: sbf_init+0x0/0x160() returned 0.
initcall 0xc0c86730 ran for 0 msecs: sbf_init+0x0/0x160()
Calling initcall 0xc0c87820: i8237A_init_sysfs+0x0/0x20()
initcall 0xc0c87820: i8237A_init_sysfs+0x0/0x20() returned 0.
initcall 0xc0c87820 ran for 0 msecs: i8237A_init_sysfs+0x0/0x20()
Calling initcall 0xc0cc3440: cache_sysfs_init+0x0/0x270()
initcall 0xc0cc3440: cache_sysfs_init+0x0/0x270() returned 0.
initcall 0xc0cc3440 ran for 0 msecs: cache_sysfs_init+0x0/0x270()
Calling initcall 0xc0c88120: thermal_throttle_init_device+0x0/0x40()
initcall 0xc0c88120: thermal_throttle_init_device+0x0/0x40() returned 0.
initcall 0xc0c88120 ran for 0 msecs: thermal_throttle_init_device+0x0/0x40()
Calling initcall 0xc0c88160: init_nonfatal_mce_checker+0x0/0x50()
Machine check exception polling timer started.
initcall 0xc0c88160: init_nonfatal_mce_checker+0x0/0x50() returned 0.
initcall 0xc0c88160 ran for 4 msecs: init_nonfatal_mce_checker+0x0/0x50()
Calling initcall 0xc0c889c0: powernow_k6_init+0x0/0x80()
initcall 0xc0c889c0: powernow_k6_init+0x0/0x80() returned -19.
initcall 0xc0c889c0 ran for 0 msecs: powernow_k6_init+0x0/0x80()
Calling initcall 0xc0c89110: cpufreq_gx_init+0x0/0x160()
initcall 0xc0c89110: cpufreq_gx_init+0x0/0x160() returned -19.
initcall 0xc0c89110 ran for 0 msecs: cpufreq_gx_init+0x0/0x160()
Calling initcall 0xc0c89270: speedstep_init+0x0/0x220()
initcall 0xc0c89270: speedstep_init+0x0/0x220() returned -19.
initcall 0xc0c89270 ran for 0 msecs: speedstep_init+0x0/0x220()
Calling initcall 0xc0c89490: speedstep_init+0x0/0x100()
initcall 0xc0c89490: speedstep_init+0x0/0x100() returned -19.
initcall 0xc0c89490 ran for 0 msecs: speedstep_init+0x0/0x100()
Calling initcall 0xc0c89ee0: microcode_init+0x0/0xa0()
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
initcall 0xc0c89ee0: microcode_init+0x0/0xa0() returned 0.
initcall 0xc0c89ee0 ran for 16 msecs: microcode_init+0x0/0xa0()
Calling initcall 0xc0c8b680: aes_init+0x0/0x10()
initcall 0xc0c8b680: aes_init+0x0/0x10() returned 0.
initcall 0xc0c8b680 ran for 0 msecs: aes_init+0x0/0x10()
Calling initcall 0xc0c8c210: create_proc_profile+0x0/0x50()
initcall 0xc0c8c210: create_proc_profile+0x0/0x50() returned 0.
initcall 0xc0c8c210 ran for 0 msecs: create_proc_profile+0x0/0x50()
Calling initcall 0xc0c8c2f0: ioresources_init+0x0/0x40()
initcall 0xc0c8c2f0: ioresources_init+0x0/0x40() returned 0.
initcall 0xc0c8c2f0 ran for 0 msecs: ioresources_init+0x0/0x40()
Calling initcall 0xc0c8c480: uid_cache_init+0x0/0x90()
initcall 0xc0c8c480: uid_cache_init+0x0/0x90() returned 0.
initcall 0xc0c8c480 ran for 0 msecs: uid_cache_init+0x0/0x90()
Calling initcall 0xc0c8c9c0: init_posix_timers+0x0/0x90()
initcall 0xc0c8c9c0: init_posix_timers+0x0/0x90() returned 0.
initcall 0xc0c8c9c0 ran for 0 msecs: init_posix_timers+0x0/0x90()
Calling initcall 0xc0c8ca50: init_posix_cpu_timers+0x0/0xa0()
initcall 0xc0c8ca50: init_posix_cpu_timers+0x0/0xa0() returned 0.
initcall 0xc0c8ca50 ran for 0 msecs: init_posix_cpu_timers+0x0/0xa0()
Calling initcall 0xc0c8cb10<6>Switched to NOHz mode on CPU #0
: nsproxy_cache_init+0x0/0x30()
initcall 0xc0c8cb10: nsproxy_cache_init+0x0/0x30() returned 0.
initcall 0xc0c8cb10 ran for 0 msecs: nsproxy_cache_init+0x0/0x30()
Calling initcall 0xc0c8cc50: timekeeping_init_device+0x0/0x20()
initcall 0xc0c8cc50: timekeeping_init_device+0x0/0x20() returned 0.
initcall 0xc0c8cc50 ran for 0 msecs: timekeeping_init_device+0x0/0x20()
Calling initcall 0xc0c8cdf0: init_clocksource_sysfs+0x0/0x40()
initcall 0xc0c8cdf0: init_clocksource_sysfs+0x0/0x40() returned 0.
initcall 0xc0c8cdf0 ran for 0 msecs: init_clocksource_sysfs+0x0/0x40()
Calling initcall 0xc0c8cef0: init_timer_list_procfs+0x0/0x30()
initcall 0xc0c8cef0: init_timer_list_procfs+0x0/0x30() returned 0.
initcall 0xc0c8cef0 ran for 0 msecs: init_timer_list_procfs+0x0/0x30()
Calling initcall 0xc0c8cf80: init+0x0/0xd0()
initcall 0xc0c8cf80: init+0x0/0xd0() returned 0.
initcall 0xc0c8cf80 ran for 0 msecs: init+0x0/0xd0()
Calling initcall 0xc0c8d050: proc_dma_init+0x0/0x20()
initcall 0xc0c8d050: proc_dma_init+0x0/0x20() returned 0.
initcall 0xc0c8d050 ran for 0 msecs: proc_dma_init+0x0/0x20()
Calling initcall 0xc0c8d070: kallsyms_init+0x0/0x20()
initcall 0xc0c8d070: kallsyms_init+0x0/0x20() returned 0.
initcall 0xc0c8d070 ran for 0 msecs: kallsyms_init+0x0/0x20()
Calling initcall 0xc0c8d0c0: ikconfig_init+0x0/0x40()
initcall 0xc0c8d0c0: ikconfig_init+0x0/0x40() returned 0.
initcall 0xc0c8d0c0 ran for 0 msecs: ikconfig_init+0x0/0x40()
Calling initcall 0xc0c8d190: audit_init+0x0/0x100()
audit: initializing netlink socket (disabled)
type=2000 audit(1204789649.758:1): initialized
audit: cannot initialize inotify handle
initcall 0xc0c8d190: audit_init+0x0/0x100() returned 0.
initcall 0xc0c8d190 ran for 11 msecs: audit_init+0x0/0x100()
Calling initcall 0xc0c8d4c0: relay_init+0x0/0x10()
initcall 0xc0c8d4c0: relay_init+0x0/0x10() returned 0.
initcall 0xc0c8d4c0 ran for 0 msecs: relay_init+0x0/0x10()
Calling initcall 0xc0c8d4d0: utsname_sysctl_init+0x0/0x10()
initcall 0xc0c8d4d0: utsname_sysctl_init+0x0/0x10() returned 0.
initcall 0xc0c8d4d0 ran for 0 msecs: utsname_sysctl_init+0x0/0x10()
Calling initcall 0xc0c8db00: init_irqsoff_tracer+0x0/0x10()
initcall 0xc0c8db00: init_irqsoff_tracer+0x0/0x10() returned 0.
initcall 0xc0c8db00 ran for 0 msecs: init_irqsoff_tracer+0x0/0x10()
Calling initcall 0xc0c8e7e0: init_per_zone_pages_min+0x0/0x50()
initcall 0xc0c8e7e0: init_per_zone_pages_min+0x0/0x50() returned 0.
initcall 0xc0c8e7e0 ran for 0 msecs: init_per_zone_pages_min+0x0/0x50()
Calling initcall 0xc0c8f010: pdflush_init+0x0/0x10()
initcall 0xc0c8f010: pdflush_init+0x0/0x10() returned 0.
initcall 0xc0c8f010 ran for 0 msecs: pdflush_init+0x0/0x10()
Calling initcall 0xc0c8f050: kswapd_init+0x0/0x10()
initcall 0xc0c8f050: kswapd_init+0x0/0x10() returned 0.
initcall 0xc0c8f050 ran for 0 msecs: kswapd_init+0x0/0x10()
Calling initcall 0xc0c8f140: init_emergency_pool+0x0/0x60()
highmem bounce pool size: 64 pages
initcall 0xc0c8f140: init_emergency_pool+0x0/0x60() returned 0.
initcall 0xc0c8f140 ran for 3 msecs: init_emergency_pool+0x0/0x60()
Calling initcall 0xc0c8f1a0: hugetlb_init+0x0/0x90()
Total HugeTLB memory allocated, 0
initcall 0xc0c8f1a0: hugetlb_init+0x0/0x90() returned 0.
initcall 0xc0c8f1a0 ran for 2 msecs: hugetlb_init+0x0/0x90()
Calling initcall 0xc0c8f420: init_tmpfs+0x0/0xd0()
initcall 0xc0c8f420: init_tmpfs+0x0/0xd0() returned 0.
initcall 0xc0c8f420 ran for 0 msecs: init_tmpfs+0x0/0xd0()
Calling initcall 0xc0c8f540: cpucache_init+0x0/0x10()
initcall 0xc0c8f540: cpucache_init+0x0/0x10() returned 0.
initcall 0xc0c8f540 ran for 0 msecs: cpucache_init+0x0/0x10()
Calling initcall 0xc0c8f960: fasync_init+0x0/0x30()
initcall 0xc0c8f960: fasync_init+0x0/0x30() returned 0.
initcall 0xc0c8f960 ran for 0 msecs: fasync_init+0x0/0x30()
Calling initcall 0xc0c8fee0: aio_setup+0x0/0x60()
initcall 0xc0c8fee0: aio_setup+0x0/0x60() returned 0.
initcall 0xc0c8fee0 ran for 0 msecs: aio_setup+0x0/0x60()
Calling initcall 0xc0c902a0: init_mbcache+0x0/0x10()
initcall 0xc0c902a0: init_mbcache+0x0/0x10() returned 0.
initcall 0xc0c902a0 ran for 0 msecs: init_mbcache+0x0/0x10()
Calling initcall 0xc0c90770: configfs_init+0x0/0xe0()
initcall 0xc0c90770: configfs_init+0x0/0xe0() returned 0.
initcall 0xc0c90770 ran for 0 msecs: configfs_init+0x0/0xe0()
Calling initcall 0xc0c90850: init_devpts_fs+0x0/0x40()
initcall 0xc0c90850: init_devpts_fs+0x0/0x40() returned 0.
initcall 0xc0c90850 ran for 0 msecs: init_devpts_fs+0x0/0x40()
Calling initcall 0xc0c90930: init_dlm+0x0/0x70()
PM: Adding info for No Bus:dlm-control
DLM (built Mar  5 2008 21:55:01) installed
initcall 0xc0c90930: init_dlm+0x0/0x70() returned 0.
initcall 0xc0c90930 ran for 7 msecs: init_dlm+0x0/0x70()
Calling initcall 0xc0c90a40: init_reiserfs_fs+0x0/0x80()
initcall 0xc0c90a40: init_reiserfs_fs+0x0/0x80() returned 0.
initcall 0xc0c90a40 ran for 0 msecs: init_reiserfs_fs+0x0/0x80()
Calling initcall 0xc0c90ac0: init_ext3_fs+0x0/0x60()
initcall 0xc0c90ac0: init_ext3_fs+0x0/0x60() returned 0.
initcall 0xc0c90ac0 ran for 0 msecs: init_ext3_fs+0x0/0x60()
Calling initcall 0xc0c90bc0: journal_init+0x0/0xd0()
initcall 0xc0c90bc0: journal_init+0x0/0xd0() returned 0.
initcall 0xc0c90bc0 ran for 0 msecs: journal_init+0x0/0xd0()
Calling initcall 0xc0c90c90: init_cramfs_fs+0x0/0x30()
initcall 0xc0c90c90: init_cramfs_fs+0x0/0x30() returned 0.
initcall 0xc0c90c90 ran for 0 msecs: init_cramfs_fs+0x0/0x30()
Calling initcall 0xc0c90cc0: init_ramfs_fs+0x0/0x10()
initcall 0xc0c90cc0: init_ramfs_fs+0x0/0x10() returned 0.
initcall 0xc0c90cc0 ran for 0 msecs: init_ramfs_fs+0x0/0x10()
Calling initcall 0xc0c90d10: init_hugetlbfs_fs+0x0/0xa0()
initcall 0xc0c90d10: init_hugetlbfs_fs+0x0/0xa0() returned 0.
initcall 0xc0c90d10 ran for 0 msecs: init_hugetlbfs_fs+0x0/0xa0()
Calling initcall 0xc0c90db0: init_coda+0x0/0x170()
PM: Adding info for No Bus:cfs0
PM: Adding info for No Bus:cfs1
PM: Adding info for No Bus:cfs2
PM: Adding info for No Bus:cfs3
PM: Adding info for No Bus:cfs4
initcall 0xc0c90db0: init_coda+0x0/0x170() returned 0.
initcall 0xc0c90db0 ran for 14 msecs: init_coda+0x0/0x170()
Calling initcall 0xc0c90f50: init_fat_fs+0x0/0x50()
initcall 0xc0c90f50: init_fat_fs+0x0/0x50() returned 0.
initcall 0xc0c90f50 ran for 0 msecs: init_fat_fs+0x0/0x50()
Calling initcall 0xc0c90fa0: init_vfat_fs+0x0/0x10()
initcall 0xc0c90fa0: init_vfat_fs+0x0/0x10() returned 0.
initcall 0xc0c90fa0 ran for 0 msecs: init_vfat_fs+0x0/0x10()
Calling initcall 0xc0c91050: init_nfs_fs+0x0/0xb0()
initcall 0xc0c91050: init_nfs_fs+0x0/0xb0() returned 0.
initcall 0xc0c91050 ran for 0 msecs: init_nfs_fs+0x0/0xb0()
Calling initcall 0xc0c912a0: init_nfsd+0x0/0xc0()
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall 0xc0c912a0: init_nfsd+0x0/0xc0() returned 0.
initcall 0xc0c912a0 ran for 4 msecs: init_nfsd+0x0/0xc0()
Calling initcall 0xc0c91360: init_nlm+0x0/0x20()
initcall 0xc0c91360: init_nlm+0x0/0x20() returned 0.
initcall 0xc0c91360 ran for 0 msecs: init_nlm+0x0/0x20()
Calling initcall 0xc0c91380: init_nls_cp775+0x0/0x10()
initcall 0xc0c91380: init_nls_cp775+0x0/0x10() returned 0.
initcall 0xc0c91380 ran for 0 msecs: init_nls_cp775+0x0/0x10()
Calling initcall 0xc0c91390: init_nls_cp852+0x0/0x10()
initcall 0xc0c91390: init_nls_cp852+0x0/0x10() returned 0.
initcall 0xc0c91390 ran for 0 msecs: init_nls_cp852+0x0/0x10()
Calling initcall 0xc0c913a0: init_nls_cp855+0x0/0x10()
initcall 0xc0c913a0: init_nls_cp855+0x0/0x10() returned 0.
initcall 0xc0c913a0 ran for 0 msecs: init_nls_cp855+0x0/0x10()
Calling initcall 0xc0c913b0: init_nls_cp857+0x0/0x10()
initcall 0xc0c913b0: init_nls_cp857+0x0/0x10() returned 0.
initcall 0xc0c913b0 ran for 0 msecs: init_nls_cp857+0x0/0x10()
Calling initcall 0xc0c913c0: init_nls_cp861+0x0/0x10()
initcall 0xc0c913c0: init_nls_cp861+0x0/0x10() returned 0.
initcall 0xc0c913c0 ran for 0 msecs: init_nls_cp861+0x0/0x10()
Calling initcall 0xc0c913d0: init_nls_cp862+0x0/0x10()
initcall 0xc0c913d0: init_nls_cp862+0x0/0x10() returned 0.
initcall 0xc0c913d0 ran for 0 msecs: init_nls_cp862+0x0/0x10()
Calling initcall 0xc0c913e0: init_nls_cp936+0x0/0x10()
initcall 0xc0c913e0: init_nls_cp936+0x0/0x10() returned 0.
initcall 0xc0c913e0 ran for 0 msecs: init_nls_cp936+0x0/0x10()
Calling initcall 0xc0c913f0: init_nls_cp1251+0x0/0x10()
initcall 0xc0c913f0: init_nls_cp1251+0x0/0x10() returned 0.
initcall 0xc0c913f0 ran for 0 msecs: init_nls_cp1251+0x0/0x10()
Calling initcall 0xc0c91400: init_nls_ascii+0x0/0x10()
initcall 0xc0c91400: init_nls_ascii+0x0/0x10() returned 0.
initcall 0xc0c91400 ran for 0 msecs: init_nls_ascii+0x0/0x10()
Calling initcall 0xc0c91410: init_nls_iso8859_1+0x0/0x10()
initcall 0xc0c91410: init_nls_iso8859_1+0x0/0x10() returned 0.
initcall 0xc0c91410 ran for 0 msecs: init_nls_iso8859_1+0x0/0x10()
Calling initcall 0xc0c91420: init_nls_iso8859_4+0x0/0x10()
initcall 0xc0c91420: init_nls_iso8859_4+0x0/0x10() returned 0.
initcall 0xc0c91420 ran for 0 msecs: init_nls_iso8859_4+0x0/0x10()
Calling initcall 0xc0c91430: init_nls_iso8859_7+0x0/0x10()
initcall 0xc0c91430: init_nls_iso8859_7+0x0/0x10() returned 0.
initcall 0xc0c91430 ran for 0 msecs: init_nls_iso8859_7+0x0/0x10()
Calling initcall 0xc0c91440: init_nls_iso8859_15+0x0/0x10()
initcall 0xc0c91440: init_nls_iso8859_15+0x0/0x10() returned 0.
initcall 0xc0c91440 ran for 0 msecs: init_nls_iso8859_15+0x0/0x10()
Calling initcall 0xc0c91450: init_nls_koi8_r+0x0/0x10()
initcall 0xc0c91450: init_nls_koi8_r+0x0/0x10() returned 0.
initcall 0xc0c91450 ran for 0 msecs: init_nls_koi8_r+0x0/0x10()
Calling initcall 0xc0c91460: init_nls_utf8+0x0/0x30()
initcall 0xc0c91460: init_nls_utf8+0x0/0x30() returned 0.
initcall 0xc0c91460 ran for 0 msecs: init_nls_utf8+0x0/0x30()
Calling initcall 0xc0c914c0: init_sysv_fs+0x0/0x50()
initcall 0xc0c914c0: init_sysv_fs+0x0/0x50() returned 0.
initcall 0xc0c914c0 ran for 0 msecs: init_sysv_fs+0x0/0x50()
Calling initcall 0xc0c91510: init_ncp_fs+0x0/0x60()
initcall 0xc0c91510: init_ncp_fs+0x0/0x60() returned 0.
initcall 0xc0c91510 ran for 0 msecs: init_ncp_fs+0x0/0x60()
Calling initcall 0xc0c91570: init_hpfs_fs+0x0/0x60()
initcall 0xc0c91570: init_hpfs_fs+0x0/0x60() returned 0.
initcall 0xc0c91570 ran for 0 msecs: init_hpfs_fs+0x0/0x60()
Calling initcall 0xc0c915d0: init_efs_fs+0x0/0x70()
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall 0xc0c915d0: init_efs_fs+0x0/0x70() returned 0.
initcall 0xc0c915d0 ran for 3 msecs: init_efs_fs+0x0/0x70()
Calling initcall 0xc0c91640: init_affs_fs+0x0/0x60()
initcall 0xc0c91640: init_affs_fs+0x0/0x60() returned 0.
initcall 0xc0c91640 ran for 0 msecs: init_affs_fs+0x0/0x60()
Calling initcall 0xc0c916a0: init_qnx4_fs+0x0/0x70()
QNX4 filesystem 0.2.3 registered.
initcall 0xc0c916a0: init_qnx4_fs+0x0/0x70() returned 0.
initcall 0xc0c916a0 ran for 2 msecs: init_qnx4_fs+0x0/0x70()
Calling initcall 0xc0c91710: init_autofs_fs+0x0/0x10()
initcall 0xc0c91710: init_autofs_fs+0x0/0x10() returned 0.
initcall 0xc0c91710 ran for 0 msecs: init_autofs_fs+0x0/0x10()
Calling initcall 0xc0c91720: init_adfs_fs+0x0/0x60()
initcall 0xc0c91720: init_adfs_fs+0x0/0x60() returned 0.
initcall 0xc0c91720 ran for 0 msecs: init_adfs_fs+0x0/0x60()
Calling initcall 0xc0c917e0: fuse_init+0x0/0x110()
fuse init (API version 7.9)
PM: Adding info for No Bus:fuse
initcall 0xc0c917e0: fuse_init+0x0/0x110() returned 0.
initcall 0xc0c917e0 ran for 5 msecs: fuse_init+0x0/0x110()
Calling initcall 0xc0c91900: init_jfs_fs+0x0/0x200()
JFS: nTxBlock = 8007, nTxLock = 64057
initcall 0xc0c91900: init_jfs_fs+0x0/0x200() returned 0.
initcall 0xc0c91900 ran for 5 msecs: init_jfs_fs+0x0/0x200()
Calling initcall 0xc0c91e50: init_xfs_fs+0x0/0x60()
SGI XFS with security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
initcall 0xc0c91e50: init_xfs_fs+0x0/0x60() returned 0.
initcall 0xc0c91e50 ran for 9 msecs: init_xfs_fs+0x0/0x60()
Calling initcall 0xc0c91f00: init_befs_fs+0x0/0x80()
BeFS version: 0.9.3
initcall 0xc0c91f00: init_befs_fs+0x0/0x80() returned 0.
initcall 0xc0c91f00 ran for 1 msecs: init_befs_fs+0x0/0x80()
Calling initcall 0xc0c91fd0: ocfs2_init+0x0/0x250()
OCFS2 1.5.0
initcall 0xc0c91fd0: ocfs2_init+0x0/0x250() returned 0.
initcall 0xc0c91fd0 ran for 1 msecs: ocfs2_init+0x0/0x250()
Calling initcall 0xc0c92250: init_o2nm+0x0/0xe0()
OCFS2 Node Manager 1.5.0
initcall 0xc0c92250: init_o2nm+0x0/0xe0() returned 0.
initcall 0xc0c92250 ran for 2 msecs: init_o2nm+0x0/0xe0()
Calling initcall 0xc0c92330: dlm_init+0x0/0xd0()
OCFS2 DLM 1.5.0
initcall 0xc0c92330: dlm_init+0x0/0xd0() returned 0.
initcall 0xc0c92330 ran for 1 msecs: dlm_init+0x0/0xd0()
Calling initcall 0xc0c92400: init_dlmfs_fs+0x0/0xc0()
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
initcall 0xc0c92400: init_dlmfs_fs+0x0/0xc0() returned 0.
initcall 0xc0c92400 ran for 4 msecs: init_dlmfs_fs+0x0/0xc0()
Calling initcall 0xc0c92550: init_gfs2_fs+0x0/0x130()
GFS2 (built Mar  5 2008 21:55:10) installed
initcall 0xc0c92550: init_gfs2_fs+0x0/0x130() returned 0.
initcall 0xc0c92550 ran for 4 msecs: init_gfs2_fs+0x0/0x130()
Calling initcall 0xc0c92680: init_lock_dlm+0x0/0x90()
PM: Adding info for No Bus:lock_dlm_plock
Lock_DLM (built Mar  5 2008 21:55:13) installed
initcall 0xc0c92680: init_lock_dlm+0x0/0x90() returned 0.
initcall 0xc0c92680 ran for 7 msecs: init_lock_dlm+0x0/0x90()
Calling initcall 0xc0c92710: init_mqueue_fs+0x0/0xc0()
initcall 0xc0c92710: init_mqueue_fs+0x0/0xc0() returned 0.
initcall 0xc0c92710 ran for 0 msecs: init_mqueue_fs+0x0/0xc0()
Calling initcall 0xc0c92a40: init_sel_fs+0x0/0x60()
initcall 0xc0c92a40: init_sel_fs+0x0/0x60() returned 0.
initcall 0xc0c92a40 ran for 0 msecs: init_sel_fs+0x0/0x60()
Calling initcall 0xc0c92aa0: selnl_init+0x0/0x50()
initcall 0xc0c92aa0: selnl_init+0x0/0x50() returned 0.
initcall 0xc0c92aa0 ran for 0 msecs: selnl_init+0x0/0x50()
Calling initcall 0xc0c92af0: sel_netif_init+0x0/0x60()
initcall 0xc0c92af0: sel_netif_init+0x0/0x60() returned 0.
initcall 0xc0c92af0 ran for 0 msecs: sel_netif_init+0x0/0x60()
Calling initcall 0xc0c92b50: sel_netnode_init+0x0/0x50()
initcall 0xc0c92b50: sel_netnode_init+0x0/0x50() returned 0.
initcall 0xc0c92b50 ran for 0 msecs: sel_netnode_init+0x0/0x50()
Calling initcall 0xc0c92ba0: aurule_init+0x0/0x30()
initcall 0xc0c92ba0: aurule_init+0x0/0x30() returned 0.
initcall 0xc0c92ba0 ran for 0 msecs: aurule_init+0x0/0x30()
Calling initcall 0xc0c92c70: crypto_algapi_init+0x0/0x10()
initcall 0xc0c92c70: crypto_algapi_init+0x0/0x10() returned 0.
initcall 0xc0c92c70 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
Calling initcall 0xc0c92ca0: chainiv_module_init+0x0/0x10()
initcall 0xc0c92ca0: chainiv_module_init+0x0/0x10() returned 0.
initcall 0xc0c92ca0 ran for 0 msecs: chainiv_module_init+0x0/0x10()
Calling initcall 0xc0c92cb0: eseqiv_module_init+0x0/0x10()
initcall 0xc0c92cb0: eseqiv_module_init+0x0/0x10() returned 0.
initcall 0xc0c92cb0 ran for 0 msecs: eseqiv_module_init+0x0/0x10()
Calling initcall 0xc0c92cc0: seqiv_module_init+0x0/0x10()
initcall 0xc0c92cc0: seqiv_module_init+0x0/0x10() returned 0.
initcall 0xc0c92cc0 ran for 0 msecs: seqiv_module_init+0x0/0x10()
Calling initcall 0xc0c92cd0: cryptomgr_init+0x0/0x10()
initcall 0xc0c92cd0: cryptomgr_init+0x0/0x10() returned 0.
initcall 0xc0c92cd0 ran for 0 msecs: cryptomgr_init+0x0/0x10()
Calling initcall 0xc0c92ce0: hmac_module_init+0x0/0x10()
initcall 0xc0c92ce0: hmac_module_init+0x0/0x10() returned 0.
initcall 0xc0c92ce0 ran for 0 msecs: hmac_module_init+0x0/0x10()
Calling initcall 0xc0c92cf0: crypto_xcbc_module_init+0x0/0x10()
initcall 0xc0c92cf0: crypto_xcbc_module_init+0x0/0x10() returned 0.
initcall 0xc0c92cf0 ran for 0 msecs: crypto_xcbc_module_init+0x0/0x10()
Calling initcall 0xc0c92d00: init+0x0/0x70()
initcall 0xc0c92d00: init+0x0/0x70() returned 0.
initcall 0xc0c92d00 ran for 0 msecs: init+0x0/0x70()
Calling initcall 0xc0c92d70: init+0x0/0x10()
initcall 0xc0c92d70: init+0x0/0x10() returned 0.
initcall 0xc0c92d70 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c92d80: init+0x0/0x10()
initcall 0xc0c92d80: init+0x0/0x10() returned 0.
initcall 0xc0c92d80 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c92d90: init+0x0/0x10()
initcall 0xc0c92d90: init+0x0/0x10() returned 0.
initcall 0xc0c92d90 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c92da0: init+0x0/0x40()
initcall 0xc0c92da0: init+0x0/0x40() returned 0.
initcall 0xc0c92da0 ran for 0 msecs: init+0x0/0x40()
Calling initcall 0xc0c92de0: crypto_ecb_module_init+0x0/0x10()
initcall 0xc0c92de0: crypto_ecb_module_init+0x0/0x10() returned 0.
initcall 0xc0c92de0 ran for 0 msecs: crypto_ecb_module_init+0x0/0x10()
Calling initcall 0xc0c92df0: crypto_cbc_module_init+0x0/0x10()
initcall 0xc0c92df0: crypto_cbc_module_init+0x0/0x10() returned 0.
initcall 0xc0c92df0 ran for 0 msecs: crypto_cbc_module_init+0x0/0x10()
Calling initcall 0xc0c92e00: crypto_pcbc_module_init+0x0/0x10()
initcall 0xc0c92e00: crypto_pcbc_module_init+0x0/0x10() returned 0.
initcall 0xc0c92e00 ran for 0 msecs: crypto_pcbc_module_init+0x0/0x10()
Calling initcall 0xc0c92e10: crypto_module_init+0x0/0x10()
initcall 0xc0c92e10: crypto_module_init+0x0/0x10() returned 0.
initcall 0xc0c92e10 ran for 0 msecs: crypto_module_init+0x0/0x10()
Calling initcall 0xc0c92e20: crypto_module_init+0x0/0x10()
initcall 0xc0c92e20: crypto_module_init+0x0/0x10() returned 0.
initcall 0xc0c92e20 ran for 0 msecs: crypto_module_init+0x0/0x10()
Calling initcall 0xc0c92e30: crypto_ctr_module_init+0x0/0x40()
initcall 0xc0c92e30: crypto_ctr_module_init+0x0/0x40() returned 0.
initcall 0xc0c92e30 ran for 0 msecs: crypto_ctr_module_init+0x0/0x40()
Calling initcall 0xc0c92e70: crypto_ccm_module_init+0x0/0x60()
initcall 0xc0c92e70: crypto_ccm_module_init+0x0/0x60() returned 0.
initcall 0xc0c92e70 ran for 0 msecs: crypto_ccm_module_init+0x0/0x60()
Calling initcall 0xc0c92ed0: init+0x0/0x40()
initcall 0xc0c92ed0: init+0x0/0x40() returned 0.
initcall 0xc0c92ed0 ran for 0 msecs: init+0x0/0x40()
Calling initcall 0xc0c92f10: aes_init+0x0/0x370()
initcall 0xc0c92f10: aes_init+0x0/0x370() returned 0.
initcall 0xc0c92f10 ran for 0 msecs: aes_init+0x0/0x370()
Calling initcall 0xc0c93280: init+0x0/0x10()
initcall 0xc0c93280: init+0x0/0x10() returned 0.
initcall 0xc0c93280 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93290: init+0x0/0x10()
initcall 0xc0c93290: init+0x0/0x10() returned 0.
initcall 0xc0c93290 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c932a0: arc4_init+0x0/0x10()
initcall 0xc0c932a0: arc4_init+0x0/0x10() returned 0.
initcall 0xc0c932a0 ran for 0 msecs: arc4_init+0x0/0x10()
Calling initcall 0xc0c932b0: init+0x0/0x70()
initcall 0xc0c932b0: init+0x0/0x70() returned 0.
initcall 0xc0c932b0 ran for 0 msecs: init+0x0/0x70()
Calling initcall 0xc0c93320: init+0x0/0x10()
initcall 0xc0c93320: init+0x0/0x10() returned 0.
initcall 0xc0c93320 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93330: init+0x0/0x10()
initcall 0xc0c93330: init+0x0/0x10() returned 0.
initcall 0xc0c93330 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93340: seed_init+0x0/0x10()
initcall 0xc0c93340: seed_init+0x0/0x10() returned 0.
initcall 0xc0c93340 ran for 0 msecs: seed_init+0x0/0x10()
Calling initcall 0xc0c93350: init+0x0/0x10()
initcall 0xc0c93350: init+0x0/0x10() returned 0.
initcall 0xc0c93350 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93360: michael_mic_init+0x0/0x10()
initcall 0xc0c93360: michael_mic_init+0x0/0x10() returned 0.
initcall 0xc0c93360 ran for 0 msecs: michael_mic_init+0x0/0x10()
Calling initcall 0xc0c93370: init+0x0/0x10()
initcall 0xc0c93370: init+0x0/0x10() returned 0.
initcall 0xc0c93370 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93380: crypto_authenc_module_init+0x0/0x10()
initcall 0xc0c93380: crypto_authenc_module_init+0x0/0x10() returned 0.
initcall 0xc0c93380 ran for 0 msecs: crypto_authenc_module_init+0x0/0x10()
Calling initcall 0xc0c93390: init+0x0/0x10()
initcall 0xc0c93390: init+0x0/0x10() returned 0.
initcall 0xc0c93390 ran for 0 msecs: init+0x0/0x10()
Calling initcall 0xc0c93680: bsg_init+0x0/0x120()
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall 0xc0c93680: bsg_init+0x0/0x120() returned 0.
initcall 0xc0c93680 ran for 5 msecs: bsg_init+0x0/0x120()
Calling initcall 0xc0c937a0: noop_init+0x0/0x10()
io scheduler noop registered
initcall 0xc0c937a0: noop_init+0x0/0x10() returned 0.
initcall 0xc0c937a0 ran for 2 msecs: noop_init+0x0/0x10()
Calling initcall 0xc0c937b0: as_init+0x0/0x10()
io scheduler anticipatory registered (default)
initcall 0xc0c937b0: as_init+0x0/0x10() returned 0.
initcall 0xc0c937b0 ran for 4 msecs: as_init+0x0/0x10()
Calling initcall 0xc0c937c0: deadline_init+0x0/0x10()
io scheduler deadline registered
initcall 0xc0c937c0: deadline_init+0x0/0x10() returned 0.
initcall 0xc0c937c0 ran for 2 msecs: deadline_init+0x0/0x10()
Calling initcall 0xc0c93920: audit_classes_init+0x0/0x50()
initcall 0xc0c93920: audit_classes_init+0x0/0x50() returned 0.
initcall 0xc0c93920 ran for 0 msecs: audit_classes_init+0x0/0x50()
Calling initcall 0xc093f170: pci_init+0x0/0x40()
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:00.0: Boot video device
initcall 0xc093f170: pci_init+0x0/0x40() returned 0.
initcall 0xc093f170 ran for 51 msecs: pci_init+0x0/0x40()
Calling initcall 0xc0c94020: pci_proc_init+0x0/0x70()
initcall 0xc0c94020: pci_proc_init+0x0/0x70() returned 0.
initcall 0xc0c94020 ran for 0 msecs: pci_proc_init+0x0/0x70()
Calling initcall 0xc0c94090: pci_hotplug_init+0x0/0x50()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall 0xc0c94090: pci_hotplug_init+0x0/0x50() returned 0.
initcall 0xc0c94090 ran for 4 msecs: pci_hotplug_init+0x0/0x50()
Calling initcall 0xc0c940e0: dummyphp_init+0x0/0x80()
fakephp: Fake PCI Hot Plug Controller Driver
initcall 0xc0c940e0: dummyphp_init+0x0/0x80() returned 0.
initcall 0xc0c940e0 ran for 4 msecs: dummyphp_init+0x0/0x80()
Calling initcall 0xc0c943a0: corgibl_init+0x0/0x10()
initcall 0xc0c943a0: corgibl_init+0x0/0x10() returned 0.
initcall 0xc0c943a0 ran for 0 msecs: corgibl_init+0x0/0x10()
Calling initcall 0xc0c943b0: progearbl_init+0x0/0x60()
PM: Adding info for platform:progear-bl
ALI M7101 PMU not found.
initcall 0xc0c943b0: progearbl_init+0x0/0x60() returned 0.
initcall 0xc0c943b0 ran for 5 msecs: progearbl_init+0x0/0x60()
Calling initcall 0xc0c94410: display_class_init+0x0/0x70()
initcall 0xc0c94410: display_class_init+0x0/0x70() returned 0.
initcall 0xc0c94410 ran for 0 msecs: display_class_init+0x0/0x70()
Calling initcall 0xc0c94480: cyber2000fb_init+0x0/0xc0()
initcall 0xc0c94480: cyber2000fb_init+0x0/0xc0() returned 0.
initcall 0xc0c94480 ran for 0 msecs: cyber2000fb_init+0x0/0xc0()
Calling initcall 0xc0c94540: pm2fb_init+0x0/0x130()
initcall 0xc0c94540: pm2fb_init+0x0/0x130() returned 0.
initcall 0xc0c94540 ran for 0 msecs: pm2fb_init+0x0/0x130()
Calling initcall 0xc0c94670: pm3fb_init+0x0/0xf0()
initcall 0xc0c94670: pm3fb_init+0x0/0xf0() returned 0.
initcall 0xc0c94670 ran for 0 msecs: pm3fb_init+0x0/0xf0()
Calling initcall 0xc0c94760: atyfb_init+0x0/0x1f0()
initcall 0xc0c94760: atyfb_init+0x0/0x1f0() returned 0.
initcall 0xc0c94760 ran for 0 msecs: atyfb_init+0x0/0x1f0()
Calling initcall 0xc0941530: aty128fb_init+0x0/0x160()
initcall 0xc0941530: aty128fb_init+0x0/0x160() returned 0.
initcall 0xc0941530 ran for 0 msecs: aty128fb_init+0x0/0x160()
Calling initcall 0xc0c949c0: sisfb_init+0x0/0x760()
initcall 0xc0c949c0: sisfb_init+0x0/0x760() returned 0.
initcall 0xc0c949c0 ran for 0 msecs: sisfb_init+0x0/0x760()
Calling initcall 0xc0c95120: kyrofb_init+0x0/0xd0()
initcall 0xc0c95120: kyrofb_init+0x0/0xd0() returned 0.
initcall 0xc0c95120 ran for 0 msecs: kyrofb_init+0x0/0xd0()
Calling initcall 0xc0c951f0: savagefb_init+0x0/0x70()
initcall 0xc0c951f0: savagefb_init+0x0/0x70() returned 0.
initcall 0xc0c951f0 ran for 0 msecs: savagefb_init+0x0/0x70()
Calling initcall 0xc0c95260: neofb_init+0x0/0x130()
initcall 0xc0c95260: neofb_init+0x0/0x130() returned 0.
initcall 0xc0c95260 ran for 0 msecs: neofb_init+0x0/0x130()
Calling initcall 0xc0c95390: tdfxfb_init+0x0/0x100()
initcall 0xc0c95390: tdfxfb_init+0x0/0x100() returned 0.
initcall 0xc0c95390 ran for 0 msecs: tdfxfb_init+0x0/0x100()
Calling initcall 0xc0c95490: vmlfb_init+0x0/0x90()
vmlfb: initializing
initcall 0xc0c95490: vmlfb_init+0x0/0x90() returned 0.
initcall 0xc0c95490 ran for 1 msecs: vmlfb_init+0x0/0x90()
Calling initcall 0xc0c95520: cr_pll_init+0x0/0xd0()
Could not find Carillo Ranch MCH device.
initcall 0xc0c95520: cr_pll_init+0x0/0xd0() returned -19.
initcall 0xc0c95520 ran for 3 msecs: cr_pll_init+0x0/0xd0()
Calling initcall 0xc0c955f0: s3fb_init+0x0/0xd0()
initcall 0xc0c955f0: s3fb_init+0x0/0xd0() returned 0.
initcall 0xc0c955f0 ran for 0 msecs: s3fb_init+0x0/0xd0()
Calling initcall 0xc0c956c0: arkfb_init+0x0/0x50()
initcall 0xc0c956c0: arkfb_init+0x0/0x50() returned 0.
initcall 0xc0c956c0 ran for 0 msecs: arkfb_init+0x0/0x50()
Calling initcall 0xc0c95710: hgafb_init+0x0/0x50()
PM: Adding info for platform:hgafb.0
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
initcall 0xc0c95710: hgafb_init+0x0/0x50() returned 0.
initcall 0xc0c95710 ran for 9 msecs: hgafb_init+0x0/0x50()
Calling initcall 0xc094c060: sstfb_init+0x0/0x1a0()
initcall 0xc094c060: sstfb_init+0x0/0x1a0() returned 0.
initcall 0xc094c060 ran for 0 msecs: sstfb_init+0x0/0x1a0()
Calling initcall 0xc0c95a30: s1d13xxxfb_init+0x0/0x30()
initcall 0xc0c95a30: s1d13xxxfb_init+0x0/0x30() returned 0.
initcall 0xc0c95a30 ran for 0 msecs: s1d13xxxfb_init+0x0/0x30()
Calling initcall 0xc094d840: uvesafb_init+0x0/0x3b0()
PM: Adding info for platform:uvesafb.0
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
initcall 0xc094d840: uvesafb_init+0x0/0x3b0() returned 0.
initcall 0xc094d840 ran for 24 msecs: uvesafb_init+0x0/0x3b0()
Calling initcall 0xc0c95a60: efifb_init+0x0/0x50()
initcall 0xc0c95a60: efifb_init+0x0/0x50() returned -19.
initcall 0xc0c95a60 ran for 0 msecs: efifb_init+0x0/0x50()
Calling initcall 0xc0c9622e: acpi_reserve_resources+0x0/0xc4()
initcall 0xc0c9622e: acpi_reserve_resources+0x0/0xc4() returned 0.
initcall 0xc0c9622e ran for 0 msecs: acpi_reserve_resources+0x0/0xc4()
Calling initcall 0xc0c97204: irqrouter_init_sysfs+0x0/0x2d()
initcall 0xc0c97204: irqrouter_init_sysfs+0x0/0x2d() returned 0.
initcall 0xc0c97204 ran for 0 msecs: irqrouter_init_sysfs+0x0/0x2d()
Calling initcall 0xc0c9758e: toshiba_acpi_init+0x0/0x154()
initcall 0xc0c9758e: toshiba_acpi_init+0x0/0x154() returned -19.
initcall 0xc0c9758e ran for 0 msecs: toshiba_acpi_init+0x0/0x154()
Calling initcall 0xc0c976e5: acpi_smb_hc_init+0x0/0x11()
initcall 0xc0c976e5: acpi_smb_hc_init+0x0/0x11() returned 0.
initcall 0xc0c976e5 ran for 0 msecs: acpi_smb_hc_init+0x0/0x11()
Calling initcall 0xc0c976f6: acpi_sbs_init+0x0/0x4a()
initcall 0xc0c976f6: acpi_sbs_init+0x0/0x4a() returned 0.
initcall 0xc0c976f6 ran for 0 msecs: acpi_sbs_init+0x0/0x4a()
Calling initcall 0xc0c982e0: rand_initialize+0x0/0x30()
initcall 0xc0c982e0: rand_initialize+0x0/0x30() returned 0.
initcall 0xc0c982e0 ran for 0 msecs: rand_initialize+0x0/0x30()
Calling initcall 0xc0c98340: tty_init+0x0/0x1d0()
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
initcall 0xc0c98340: tty_init+0x0/0x1d0() returned 0.
initcall 0xc0c98340 ran for 197 msecs: tty_init+0x0/0x1d0()
Calling initcall 0xc0c98540: pty_init+0x0/0x3a0()
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyef
initcall 0xc0c98540: pty_init+0x0/0x3a0() returned 0.
initcall 0xc0c98540 ran for 1480 msecs: pty_init+0x0/0x3a0()
Calling initcall 0xc0c98e90: espserial_init+0x0/0x660()
ESP serial driver version 2.2 (DMA 0)
PM: Adding info for No Bus:ttyP0
PM: Adding info for No Bus:ttyP1
PM: Adding info for No Bus:ttyP2
PM: Adding info for No Bus:ttyP3
PM: Adding info for No Bus:ttyP4
PM: Adding info for No Bus:ttyP5
PM: Adding info for No Bus:ttyP6
PM: Adding info for No Bus:ttyP7
PM: Adding info for No Bus:ttyP8
PM: Adding info for No Bus:ttyP9
PM: Adding info for No Bus:ttyP10
PM: Adding info for No Bus:ttyP11
PM: Adding info for No Bus:ttyP12
PM: Adding info for No Bus:ttyP13
PM: Adding info for No Bus:ttyP14
PM: Adding info for No Bus:ttyP15
PM: Adding info for No Bus:ttyP16
PM: Adding info for No Bus:ttyP17
PM: Adding info for No Bus:ttyP18
PM: Adding info for No Bus:ttyP19
PM: Adding info for No Bus:ttyP20
PM: Adding info for No Bus:ttyP21
PM: Adding info for No Bus:ttyP22
PM: Adding info for No Bus:ttyP23
PM: Adding info for No Bus:ttyP24
PM: Adding info for No Bus:ttyP25
PM: Adding info for No Bus:ttyP26
PM: Adding info for No Bus:ttyP27
PM: Adding info for No Bus:ttyP28
PM: Adding info for No Bus:ttyP29
PM: Adding info for No Bus:ttyP30
PM: Adding info for No Bus:ttyP31
PM: Adding info for No Bus:ttyP32
PM: Adding info for No Bus:ttyP33
PM: Adding info for No Bus:ttyP34
PM: Adding info for No Bus:ttyP35
PM: Adding info for No Bus:ttyP36
PM: Adding info for No Bus:ttyP37
PM: Adding info for No Bus:ttyP38
PM: Adding info for No Bus:ttyP39
PM: Adding info for No Bus:ttyP40
PM: Adding info for No Bus:ttyP41
PM: Adding info for No Bus:ttyP42
PM: Adding info for No Bus:ttyP43
PM: Adding info for No Bus:ttyP44
PM: Adding info for No Bus:ttyP45
PM: Adding info for No Bus:ttyP46
PM: Adding info for No Bus:ttyP47
PM: Adding info for No Bus:ttyP48
PM: Adding info for No Bus:ttyP49
PM: Adding info for No Bus:ttyP50
PM: Adding info for No Bus:ttyP51
PM: Adding info for No Bus:ttyP52
PM: Adding info for No Bus:ttyP53
PM: Adding info for No Bus:ttyP54
PM: Adding info for No Bus:ttyP55
PM: Adding info for No Bus:ttyP56
PM: Adding info for No Bus:ttyP57
PM: Adding info for No Bus:ttyP58
PM: Adding info for No Bus:ttyP59
PM: Adding info for No Bus:ttyP60
PM: Adding info for No Bus:ttyP61
PM: Adding info for No Bus:ttyP62
PM: Adding info for No Bus:ttyP63
initcall 0xc0c98e90: espserial_init+0x0/0x660() returned 0.
initcall 0xc0c98e90 ran for 193 msecs: espserial_init+0x0/0x660()
Calling initcall 0xc0c994f0: specialix_init_module+0x0/0x410()
sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
sx: derived from work (c) D.Gorodchanin 1994-1996.
sx: DTR/RTS pin is RTS when CRTSCTS is on.
PM: Adding info for No Bus:ttyW0
PM: Adding info for No Bus:ttyW1
PM: Adding info for No Bus:ttyW2
PM: Adding info for No Bus:ttyW3
PM: Adding info for No Bus:ttyW4
PM: Adding info for No Bus:ttyW5
PM: Adding info for No Bus:ttyW6
PM: Adding info for No Bus:ttyW7
PM: Adding info for No Bus:ttyW8
PM: Adding info for No Bus:ttyW9
PM: Adding info for No Bus:ttyW10
PM: Adding info for No Bus:ttyW11
PM: Adding info for No Bus:ttyW12
PM: Adding info for No Bus:ttyW13
PM: Adding info for No Bus:ttyW14
PM: Adding info for No Bus:ttyW15
PM: Adding info for No Bus:ttyW16
PM: Adding info for No Bus:ttyW17
PM: Adding info for No Bus:ttyW18
PM: Adding info for No Bus:ttyW19
PM: Adding info for No Bus:ttyW20
PM: Adding info for No Bus:ttyW21
PM: Adding info for No Bus:ttyW22
PM: Adding info for No Bus:ttyW23
PM: Adding info for No Bus:ttyW24
PM: Adding info for No Bus:ttyW25
PM: Adding info for No Bus:ttyW26
PM: Adding info for No Bus:ttyW27
PM: Adding info for No Bus:ttyW28
PM: Adding info for No Bus:ttyW29
PM: Adding info for No Bus:ttyW30
PM: Adding info for No Bus:ttyW31
PM: Adding info for No Bus:ttyW32
PM: Adding info for No Bus:ttyW33
PM: Adding info for No Bus:ttyW34
PM: Adding info for No Bus:ttyW35
PM: Adding info for No Bus:ttyW36
PM: Adding info for No Bus:ttyW37
PM: Adding info for No Bus:ttyW38
PM: Adding info for No Bus:ttyW39
PM: Adding info for No Bus:ttyW40
PM: Adding info for No Bus:ttyW41
PM: Adding info for No Bus:ttyW42
PM: Adding info for No Bus:ttyW43
PM: Adding info for No Bus:ttyW44
PM: Adding info for No Bus:ttyW45
PM: Adding info for No Bus:ttyW46
PM: Adding info for No Bus:ttyW47
PM: Adding info for No Bus:ttyW48
PM: Adding info for No Bus:ttyW49
PM: Adding info for No Bus:ttyW50
PM: Adding info for No Bus:ttyW51
PM: Adding info for No Bus:ttyW52
PM: Adding info for No Bus:ttyW53
PM: Adding info for No Bus:ttyW54
PM: Adding info for No Bus:ttyW55
PM: Adding info for No Bus:ttyW56
PM: Adding info for No Bus:ttyW57
PM: Adding info for No Bus:ttyW58
PM: Adding info for No Bus:ttyW59
PM: Adding info for No Bus:ttyW60
PM: Adding info for No Bus:ttyW61
PM: Adding info for No Bus:ttyW62
PM: Adding info for No Bus:ttyW63
sx0: specialix IO8+ Board at 0x100 not found.
sx1: specialix IO8+ Board at 0x180 not found.
sx2: specialix IO8+ Board at 0x250 not found.
sx3: specialix IO8+ Board at 0x260 not found.
PM: Removing info for No Bus:ttyW0
PM: Removing info for No Bus:ttyW1
PM: Removing info for No Bus:ttyW2
PM: Removing info for No Bus:ttyW3
PM: Removing info for No Bus:ttyW4
PM: Removing info for No Bus:ttyW5
PM: Removing info for No Bus:ttyW6
PM: Removing info for No Bus:ttyW7
PM: Removing info for No Bus:ttyW8
PM: Removing info for No Bus:ttyW9
PM: Removing info for No Bus:ttyW10
PM: Removing info for No Bus:ttyW11
PM: Removing info for No Bus:ttyW12
PM: Removing info for No Bus:ttyW13
PM: Removing info for No Bus:ttyW14
PM: Removing info for No Bus:ttyW15
PM: Removing info for No Bus:ttyW16
PM: Removing info for No Bus:ttyW17
PM: Removing info for No Bus:ttyW18
PM: Removing info for No Bus:ttyW19
PM: Removing info for No Bus:ttyW20
PM: Removing info for No Bus:ttyW21
PM: Removing info for No Bus:ttyW22
PM: Removing info for No Bus:ttyW23
PM: Removing info for No Bus:ttyW24
PM: Removing info for No Bus:ttyW25
PM: Removing info for No Bus:ttyW26
PM: Removing info for No Bus:ttyW27
PM: Removing info for No Bus:ttyW28
PM: Removing info for No Bus:ttyW29
PM: Removing info for No Bus:ttyW30
PM: Removing info for No Bus:ttyW31
PM: Removing info for No Bus:ttyW32
PM: Removing info for No Bus:ttyW33
PM: Removing info for No Bus:ttyW34
PM: Removing info for No Bus:ttyW35
PM: Removing info for No Bus:ttyW36
PM: Removing info for No Bus:ttyW37
PM: Removing info for No Bus:ttyW38
PM: Removing info for No Bus:ttyW39
PM: Removing info for No Bus:ttyW40
PM: Removing info for No Bus:ttyW41
PM: Removing info for No Bus:ttyW42
PM: Removing info for No Bus:ttyW43
PM: Removing info for No Bus:ttyW44
PM: Removing info for No Bus:ttyW45
PM: Removing info for No Bus:ttyW46
PM: Removing info for No Bus:ttyW47
PM: Removing info for No Bus:ttyW48
PM: Removing info for No Bus:ttyW49
PM: Removing info for No Bus:ttyW50
PM: Removing info for No Bus:ttyW51
PM: Removing info for No Bus:ttyW52
PM: Removing info for No Bus:ttyW53
PM: Removing info for No Bus:ttyW54
PM: Removing info for No Bus:ttyW55
PM: Removing info for No Bus:ttyW56
PM: Removing info for No Bus:ttyW57
PM: Removing info for No Bus:ttyW58
PM: Removing info for No Bus:ttyW59
PM: Removing info for No Bus:ttyW60
PM: Removing info for No Bus:ttyW61
PM: Removing info for No Bus:ttyW62
PM: Removing info for No Bus:ttyW63
sx: No specialix IO8+ boards detected.
initcall 0xc0c994f0: specialix_init_module+0x0/0x410() returned -5.
initcall 0xc0c994f0 ran for 424 msecs: specialix_init_module+0x0/0x410()
initcall at 0xc0c994f0: specialix_init_module+0x0/0x410(): returned with error code -5
Calling initcall 0xc0c99900: moxa_init+0x0/0x220()
MOXA Intellio family driver version 5.1k
PM: Adding info for No Bus:ttyMX0
PM: Adding info for No Bus:ttyMX1
PM: Adding info for No Bus:ttyMX2
PM: Adding info for No Bus:ttyMX3
PM: Adding info for No Bus:ttyMX4
PM: Adding info for No Bus:ttyMX5
PM: Adding info for No Bus:ttyMX6
PM: Adding info for No Bus:ttyMX7
PM: Adding info for No Bus:ttyMX8
PM: Adding info for No Bus:ttyMX9
PM: Adding info for No Bus:ttyMX10
PM: Adding info for No Bus:ttyMX11
PM: Adding info for No Bus:ttyMX12
PM: Adding info for No Bus:ttyMX13
PM: Adding info for No Bus:ttyMX14
PM: Adding info for No Bus:ttyMX15
PM: Adding info for No Bus:ttyMX16
PM: Adding info for No Bus:ttyMX17
PM: Adding info for No Bus:ttyMX18
PM: Adding info for No Bus:ttyMX19
PM: Adding info for No Bus:ttyMX20
PM: Adding info for No Bus:ttyMX21
PM: Adding info for No Bus:ttyMX22
PM: Adding info for No Bus:ttyMX23
PM: Adding info for No Bus:ttyMX24
PM: Adding info for No Bus:ttyMX25
PM: Adding info for No Bus:ttyMX26
PM: Adding info for No Bus:ttyMX27
PM: Adding info for No Bus:ttyMX28
PM: Adding info for No Bus:ttyMX29
PM: Adding info for No Bus:ttyMX30
PM: Adding info for No Bus:ttyMX31
PM: Adding info for No Bus:ttyMX32
PM: Adding info for No Bus:ttyMX33
PM: Adding info for No Bus:ttyMX34
PM: Adding info for No Bus:ttyMX35
PM: Adding info for No Bus:ttyMX36
PM: Adding info for No Bus:ttyMX37
PM: Adding info for No Bus:ttyMX38
PM: Adding info for No Bus:ttyMX39
PM: Adding info for No Bus:ttyMX40
PM: Adding info for No Bus:ttyMX41
PM: Adding info for No Bus:ttyMX42
PM: Adding info for No Bus:ttyMX43
PM: Adding info for No Bus:ttyMX44
PM: Adding info for No Bus:ttyMX45
PM: Adding info for No Bus:ttyMX46
PM: Adding info for No Bus:ttyMX47
PM: Adding info for No Bus:ttyMX48
PM: Adding info for No Bus:ttyMX49
PM: Adding info for No Bus:ttyMX50
PM: Adding info for No Bus:ttyMX51
PM: Adding info for No Bus:ttyMX52
PM: Adding info for No Bus:ttyMX53
PM: Adding info for No Bus:ttyMX54
PM: Adding info for No Bus:ttyMX55
PM: Adding info for No Bus:ttyMX56
PM: Adding info for No Bus:ttyMX57
PM: Adding info for No Bus:ttyMX58
PM: Adding info for No Bus:ttyMX59
PM: Adding info for No Bus:ttyMX60
PM: Adding info for No Bus:ttyMX61
PM: Adding info for No Bus:ttyMX62
PM: Adding info for No Bus:ttyMX63
PM: Adding info for No Bus:ttyMX64
PM: Adding info for No Bus:ttyMX65
PM: Adding info for No Bus:ttyMX66
PM: Adding info for No Bus:ttyMX67
PM: Adding info for No Bus:ttyMX68
PM: Adding info for No Bus:ttyMX69
PM: Adding info for No Bus:ttyMX70
PM: Adding info for No Bus:ttyMX71
PM: Adding info for No Bus:ttyMX72
PM: Adding info for No Bus:ttyMX73
PM: Adding info for No Bus:ttyMX74
PM: Adding info for No Bus:ttyMX75
PM: Adding info for No Bus:ttyMX76
PM: Adding info for No Bus:ttyMX77
PM: Adding info for No Bus:ttyMX78
PM: Adding info for No Bus:ttyMX79
PM: Adding info for No Bus:ttyMX80
PM: Adding info for No Bus:ttyMX81
PM: Adding info for No Bus:ttyMX82
PM: Adding info for No Bus:ttyMX83
PM: Adding info for No Bus:ttyMX84
PM: Adding info for No Bus:ttyMX85
PM: Adding info for No Bus:ttyMX86
PM: Adding info for No Bus:ttyMX87
PM: Adding info for No Bus:ttyMX88
PM: Adding info for No Bus:ttyMX89
PM: Adding info for No Bus:ttyMX90
PM: Adding info for No Bus:ttyMX91
PM: Adding info for No Bus:ttyMX92
PM: Adding info for No Bus:ttyMX93
PM: Adding info for No Bus:ttyMX94
PM: Adding info for No Bus:ttyMX95
PM: Adding info for No Bus:ttyMX96
PM: Adding info for No Bus:ttyMX97
PM: Adding info for No Bus:ttyMX98
PM: Adding info for No Bus:ttyMX99
PM: Adding info for No Bus:ttyMX100
PM: Adding info for No Bus:ttyMX101
PM: Adding info for No Bus:ttyMX102
PM: Adding info for No Bus:ttyMX103
PM: Adding info for No Bus:ttyMX104
PM: Adding info for No Bus:ttyMX105
PM: Adding info for No Bus:ttyMX106
PM: Adding info for No Bus:ttyMX107
PM: Adding info for No Bus:ttyMX108
PM: Adding info for No Bus:ttyMX109
PM: Adding info for No Bus:ttyMX110
PM: Adding info for No Bus:ttyMX111
PM: Adding info for No Bus:ttyMX112
PM: Adding info for No Bus:ttyMX113
PM: Adding info for No Bus:ttyMX114
PM: Adding info for No Bus:ttyMX115
PM: Adding info for No Bus:ttyMX116
PM: Adding info for No Bus:ttyMX117
PM: Adding info for No Bus:ttyMX118
PM: Adding info for No Bus:ttyMX119
PM: Adding info for No Bus:ttyMX120
PM: Adding info for No Bus:ttyMX121
PM: Adding info for No Bus:ttyMX122
PM: Adding info for No Bus:ttyMX123
PM: Adding info for No Bus:ttyMX124
PM: Adding info for No Bus:ttyMX125
PM: Adding info for No Bus:ttyMX126
PM: Adding info for No Bus:ttyMX127
PM: Adding info for No Bus:ttyMX128
initcall 0xc0c99900: moxa_init+0x0/0x220() returned 0.
initcall 0xc0c99900 ran for 401 msecs: moxa_init+0x0/0x220()
Calling initcall 0xc0c99b20: mxser_module_init+0x0/0x6f0()
MOXA Smartio/Industio family driver version 2.0.3
initcall 0xc0c99b20: mxser_module_init+0x0/0x6f0() returned 0.
initcall 0xc0c99b20 ran for 4 msecs: mxser_module_init+0x0/0x6f0()
Calling initcall 0xc0c9a210: isicom_init+0x0/0x160()
initcall 0xc0c9a210: isicom_init+0x0/0x160() returned 0.
initcall 0xc0c9a210 ran for 0 msecs: isicom_init+0x0/0x160()
Calling initcall 0xc0c9a370: n_hdlc_init+0x0/0x90()
HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
N_HDLC line discipline registered.
initcall 0xc0c9a370: n_hdlc_init+0x0/0x90() returned 0.
initcall 0xc0c9a370 ran for 8 msecs: n_hdlc_init+0x0/0x90()
Calling initcall 0xc0c9a400: sx_init+0x0/0x380()
PM: Adding info for No Bus:sxctl
initcall 0xc0c9a400: sx_init+0x0/0x380() returned 0.
initcall 0xc0c9a400 ran for 2 msecs: sx_init+0x0/0x380()
Calling initcall 0xc0c9a780: rio_init+0x0/0xd00()
PM: Adding info for No Bus:rioctl
PM: Removing info for No Bus:rioctl
initcall 0xc0c9a780: rio_init+0x0/0xd00() returned -5.
initcall 0xc0c9a780 ran for 6 msecs: rio_init+0x0/0xd00()
initcall at 0xc0c9a780: rio_init+0x0/0xd00(): returned with error code -5
Calling initcall 0xc0c9b480: raw_init+0x0/0xc0()
PM: Adding info for No Bus:rawctl
initcall 0xc0c9b480: raw_init+0x0/0xc0() returned 0.
initcall 0xc0c9b480 ran for 2 msecs: raw_init+0x0/0xc0()
Calling initcall 0xc0c9b680: lp_init_module+0x0/0x230()
lp: driver loaded but no devices found
initcall 0xc0c9b680: lp_init_module+0x0/0x230() returned 0.
initcall 0xc0c9b680 ran for 3 msecs: lp_init_module+0x0/0x230()
Calling initcall 0xc0c9b8b0: r3964_init+0x0/0x40()
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall 0xc0c9b8b0: r3964_init+0x0/0x40() returned 0.
initcall 0xc0c9b8b0 ran for 3 msecs: r3964_init+0x0/0x40()
Calling initcall 0xc0c9b8f0: applicom_init+0x0/0x4b0()
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall 0xc0c9b8f0: applicom_init+0x0/0x4b0() returned -6.
initcall 0xc0c9b8f0 ran for 13 msecs: applicom_init+0x0/0x4b0()
initcall at 0xc0c9b8f0: applicom_init+0x0/0x4b0(): returned with error code -6
Calling initcall 0xc0c9bda0: hpet_init+0x0/0x70()
PM: Adding info for No Bus:hpet
initcall 0xc0c9bda0: hpet_init+0x0/0x70() returned 0.
initcall 0xc0c9bda0 ran for 2 msecs: hpet_init+0x0/0x70()
Calling initcall 0xc0c9be10: nvram_init+0x0/0x80()
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
initcall 0xc0c9be10: nvram_init+0x0/0x80() returned 0.
initcall 0xc0c9be10 ran for 5 msecs: nvram_init+0x0/0x80()
Calling initcall 0xc0c9be90: toshiba_init+0x0/0x3a0()
toshiba: not a supported Toshiba laptop
initcall 0xc0c9be90: toshiba_init+0x0/0x3a0() returned -19.
initcall 0xc0c9be90 ran for 3 msecs: toshiba_init+0x0/0x3a0()
Calling initcall 0xc0c9c230: i8k_init+0x0/0x240()
initcall 0xc0c9c230: i8k_init+0x0/0x240() returned -19.
initcall 0xc0c9c230 ran for 0 msecs: i8k_init+0x0/0x240()
Calling initcall 0xc0c9c470: pc8736x_gpio_init+0x0/0x390()
PM: Adding info for platform:pc8736x_gpio.0
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: no device found
PM: Removing info for platform:pc8736x_gpio.0
initcall 0xc0c9c470: pc8736x_gpio_init+0x0/0x390() returned -19.
initcall 0xc0c9c470 ran for 16 msecs: pc8736x_gpio_init+0x0/0x390()
Calling initcall 0xc0c9c800: nsc_gpio_init+0x0/0x10()
nsc_gpio initializing
initcall 0xc0c9c800: nsc_gpio_init+0x0/0x10() returned 0.
initcall 0xc0c9c800 ran for 1 msecs: nsc_gpio_init+0x0/0x10()
Calling initcall 0xc0c9c810: tlclk_init+0x0/0x1a0()
telclk_interrup = 0xf non-mcpbl0010 hw.
initcall 0xc0c9c810: tlclk_init+0x0/0x1a0() returned -6.
initcall 0xc0c9c810 ran for 3 msecs: tlclk_init+0x0/0x1a0()
initcall at 0xc0c9c810: tlclk_init+0x0/0x1a0(): returned with error code -6
Calling initcall 0xc0c9c9f0: agp_init+0x0/0x20()
Linux agpgart interface v0.103
initcall 0xc0c9c9f0: agp_init+0x0/0x20() returned 0.
initcall 0xc0c9c9f0 ran for 2 msecs: agp_init+0x0/0x20()
Calling initcall 0xc0c9ca10: agp_ati_init+0x0/0x30()
initcall 0xc0c9ca10: agp_ati_init+0x0/0x30() returned 0.
initcall 0xc0c9ca10 ran for 0 msecs: agp_ati_init+0x0/0x30()
Calling initcall 0xc0c9ca40: agp_efficeon_init+0x0/0x50()
initcall 0xc0c9ca40: agp_efficeon_init+0x0/0x50() returned 0.
initcall 0xc0c9ca40 ran for 0 msecs: agp_efficeon_init+0x0/0x50()
Calling initcall 0xc0c9ca90: agp_intel_init+0x0/0x30()
initcall 0xc0c9ca90: agp_intel_init+0x0/0x30() returned 0.
initcall 0xc0c9ca90 ran for 0 msecs: agp_intel_init+0x0/0x30()
Calling initcall 0xc0c9cac0: agp_nvidia_init+0x0/0x30()
initcall 0xc0c9cac0: agp_nvidia_init+0x0/0x30() returned 0.
initcall 0xc0c9cac0 ran for 0 msecs: agp_nvidia_init+0x0/0x30()
Calling initcall 0xc0c9caf0: agp_serverworks_init+0x0/0x30()
initcall 0xc0c9caf0: agp_serverworks_init+0x0/0x30() returned 0.
initcall 0xc0c9caf0 ran for 0 msecs: agp_serverworks_init+0x0/0x30()
Calling initcall 0xc0c9cb20: agp_via_init+0x0/0x30()
initcall 0xc0c9cb20: agp_via_init+0x0/0x30() returned 0.
initcall 0xc0c9cb20 ran for 0 msecs: agp_via_init+0x0/0x30()
Calling initcall 0xc0c9cb50: drm_core_init+0x0/0x120()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc0c9cb50: drm_core_init+0x0/0x120() returned 0.
initcall 0xc0c9cb50 ran for 3 msecs: drm_core_init+0x0/0x120()
Calling initcall 0xc0c9cc70: radeon_init+0x0/0x20()
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK3] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:01:00.0 to 64
PM: Adding info for No Bus:card0
[drm] Initialized radeon 1.28.0 20060524 on minor 0
initcall 0xc0c9cc70: radeon_init+0x0/0x20() returned 0.
initcall 0xc0c9cc70 ran for 26 msecs: radeon_init+0x0/0x20()
Calling initcall 0xc0c9cc90: i830_init+0x0/0x20()
initcall 0xc0c9cc90: i830_init+0x0/0x20() returned 0.
initcall 0xc0c9cc90 ran for 0 msecs: i830_init+0x0/0x20()
Calling initcall 0xc0c9ccb0: savage_init+0x0/0x20()
initcall 0xc0c9ccb0: savage_init+0x0/0x20() returned 0.
initcall 0xc0c9ccb0 ran for 0 msecs: savage_init+0x0/0x20()
Calling initcall 0xc0c9ccd0: via_init+0x0/0x20()
initcall 0xc0c9ccd0: via_init+0x0/0x20() returned 0.
initcall 0xc0c9ccd0 ran for 0 msecs: via_init+0x0/0x20()
Calling initcall 0xc0c9cdb0: hangcheck_init+0x0/0xa0()
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
initcall 0xc0c9cdb0: hangcheck_init+0x0/0xa0() returned 0.
initcall 0xc0c9cdb0 ran for 10 msecs: hangcheck_init+0x0/0xa0()
Calling initcall 0xc0c9ce50: cn_proc_init+0x0/0x30()
initcall 0xc0c9ce50: cn_proc_init+0x0/0x30() returned 0.
initcall 0xc0c9ce50 ran for 0 msecs: cn_proc_init+0x0/0x30()
Calling initcall 0xc094ffb0: i810fb_init+0x0/0x380()
initcall 0xc094ffb0: i810fb_init+0x0/0x380() returned 0.
initcall 0xc094ffb0 ran for 0 msecs: i810fb_init+0x0/0x380()
Calling initcall 0xc0c9d1a0: serial8250_init+0x0/0x100()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
initcall 0xc0c9d1a0: serial8250_init+0x0/0x100() returned 0.
initcall 0xc0c9d1a0 ran for 26 msecs: serial8250_init+0x0/0x100()
Calling initcall 0xc0c9d2a0: serial8250_pnp_init+0x0/0x10()
pnp: the driver 'serial' has been registered
PM: Removing info for No Bus:ttyS0
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
serial 00:08: driver attached
initcall 0xc0c9d2a0: serial8250_pnp_init+0x0/0x10() returned 0.
initcall 0xc0c9d2a0 ran for 16 msecs: serial8250_pnp_init+0x0/0x10()
Calling initcall 0xc0c9d2b0: serial8250_pci_init+0x0/0x20()
initcall 0xc0c9d2b0: serial8250_pci_init+0x0/0x20() returned 0.
initcall 0xc0c9d2b0 ran for 0 msecs: serial8250_pci_init+0x0/0x20()
Calling initcall 0xc0c9d720: jsm_init_module+0x0/0x50()
initcall 0xc0c9d720: jsm_init_module+0x0/0x50() returned 0.
initcall 0xc0c9d720 ran for 0 msecs: jsm_init_module+0x0/0x50()
Calling initcall 0xc0c9d770: parport_default_proc_register+0x0/0x20()
initcall 0xc0c9d770: parport_default_proc_register+0x0/0x20() returned 0.
initcall 0xc0c9d770 ran for 0 msecs: parport_default_proc_register+0x0/0x20()
Calling initcall 0xc0c9d790: parport_ax88796_init+0x0/0x10()
initcall 0xc0c9d790: parport_ax88796_init+0x0/0x10() returned 0.
initcall 0xc0c9d790 ran for 0 msecs: parport_ax88796_init+0x0/0x10()
Calling initcall 0xc0c9d980: isa_bus_init+0x0/0x40()
PM: Adding info for No Bus:isa
initcall 0xc0c9d980: isa_bus_init+0x0/0x40() returned 0.
initcall 0xc0c9d980 ran for 2 msecs: isa_bus_init+0x0/0x40()
Calling initcall 0xc0c9ddc0: floppy_init+0x0/0xcf0()
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PM: Adding info for platform:floppy.0
PM: Adding info for No Bus:fd0
initcall 0xc0c9ddc0: floppy_init+0x0/0xcf0() returned 0.
initcall 0xc0c9ddc0 ran for 30 msecs: floppy_init+0x0/0xcf0()
Calling initcall 0xc0c9eae0: brd_init+0x0/0x170()
PM: Adding info for No Bus:ram0
PM: Adding info for No Bus:ram1
PM: Adding info for No Bus:ram2
PM: Adding info for No Bus:ram3
PM: Adding info for No Bus:ram4
PM: Adding info for No Bus:ram5
PM: Adding info for No Bus:ram6
PM: Adding info for No Bus:ram7
PM: Adding info for No Bus:ram8
PM: Adding info for No Bus:ram9
PM: Adding info for No Bus:ram10
PM: Adding info for No Bus:ram11
PM: Adding info for No Bus:ram12
PM: Adding info for No Bus:ram13
PM: Adding info for No Bus:ram14
PM: Adding info for No Bus:ram15
brd: module loaded
initcall 0xc0c9eae0: brd_init+0x0/0x170() returned 0.
initcall 0xc0c9eae0 ran for 47 msecs: brd_init+0x0/0x170()
Calling initcall 0xc0c9ec50: loop_init+0x0/0x180()
PM: Adding info for No Bus:loop0
PM: Adding info for No Bus:loop1
PM: Adding info for No Bus:loop2
PM: Adding info for No Bus:loop3
PM: Adding info for No Bus:loop4
PM: Adding info for No Bus:loop5
PM: Adding info for No Bus:loop6
PM: Adding info for No Bus:loop7
loop: module loaded
initcall 0xc0c9ec50: loop_init+0x0/0x180() returned 0.
initcall 0xc0c9ec50 ran for 24 msecs: loop_init+0x0/0x180()
Calling initcall 0xc0c9f320: cpqarray_init+0x0/0x280()
Compaq SMART2 Driver (v 2.6.0)
initcall 0xc0c9f320: cpqarray_init+0x0/0x280() returned 0.
initcall 0xc0c9f320 ran for 2 msecs: cpqarray_init+0x0/0x280()
Calling initcall 0xc04f4b90: DAC960_init_module+0x0/0x50()
PM: Adding info for No Bus:dac960_gam
initcall 0xc04f4b90: DAC960_init_module+0x0/0x50() returned 0.
initcall 0xc04f4b90 ran for 3 msecs: DAC960_init_module+0x0/0x50()
Calling initcall 0xc0c9f940: init_cryptoloop+0x0/0x20()
initcall 0xc0c9f940: init_cryptoloop+0x0/0x20() returned 0.
initcall 0xc0c9f940 ran for 0 msecs: init_cryptoloop+0x0/0x20()
Calling initcall 0xc0c9f960: carm_init+0x0/0x20()
initcall 0xc0c9f960: carm_init+0x0/0x20() returned 0.
initcall 0xc0c9f960 ran for 0 msecs: carm_init+0x0/0x20()
Calling initcall 0xc0c9f980: sm501_base_init+0x0/0x20()
initcall 0xc0c9f980: sm501_base_init+0x0/0x20() returned 0.
initcall 0xc0c9f980 ran for 0 msecs: sm501_base_init+0x0/0x20()
Calling initcall 0xc0c9f9a0: e1000_init_module+0x0/0x80()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xc0c9f9a0: e1000_init_module+0x0/0x80() returned 0.
initcall 0xc0c9f9a0 ran for 8 msecs: e1000_init_module+0x0/0x80()
Calling initcall 0xc0c9fa20: ipg_init_module+0x0/0x20()
initcall 0xc0c9fa20: ipg_init_module+0x0/0x20() returned 0.
initcall 0xc0c9fa20 ran for 0 msecs: ipg_init_module+0x0/0x20()
Calling initcall 0xc0c9fa40: cxgb3_init_module+0x0/0x20()
initcall 0xc0c9fa40: cxgb3_init_module+0x0/0x20() returned 0.
initcall 0xc0c9fa40 ran for 0 msecs: cxgb3_init_module+0x0/0x20()
Calling initcall 0xc0c9fc10: bonding_init+0x0/0x880()
Ethernet Channel Bonding Driver: v3.2.4 (January 28, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
PM: Adding info for No Bus:bond0
initcall 0xc0c9fc10: bonding_init+0x0/0x880() returned 0.
initcall 0xc0c9fc10 ran for 23 msecs: bonding_init+0x0/0x880()
Calling initcall 0xc0ca0490: atl1_init_module+0x0/0x20()
initcall 0xc0ca0490: atl1_init_module+0x0/0x20() returned 0.
initcall 0xc0ca0490 ran for 0 msecs: atl1_init_module+0x0/0x20()
Calling initcall 0xc0ca04b0: happy_meal_probe+0x0/0x20()
initcall 0xc0ca04b0: happy_meal_probe+0x0/0x20() returned 0.
initcall 0xc0ca04b0 ran for 0 msecs: happy_meal_probe+0x0/0x20()
Calling initcall 0xc0ca04d0: cas_init+0x0/0x40()
initcall 0xc0ca04d0: cas_init+0x0/0x40() returned 0.
initcall 0xc0ca04d0 ran for 0 msecs: cas_init+0x0/0x40()
Calling initcall 0xc0ca0510: pcnet32_init_module+0x0/0x130()
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
initcall 0xc0ca0510: pcnet32_init_module+0x0/0x130() returned 0.
initcall 0xc0ca0510 ran for 4 msecs: pcnet32_init_module+0x0/0x130()
Calling initcall 0xc0ca0640: e100_init_module+0x0/0x50()
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xc0ca0640: e100_init_module+0x0/0x50() returned 0.
initcall 0xc0ca0640 ran for 8 msecs: e100_init_module+0x0/0x50()
Calling initcall 0xc0ca0690: epic_init+0x0/0x20()
initcall 0xc0ca0690: epic_init+0x0/0x20() returned 0.
initcall 0xc0ca0690 ran for 0 msecs: epic_init+0x0/0x20()
Calling initcall 0xc0ca06b0: sis900_init_module+0x0/0x20()
initcall 0xc0ca06b0: sis900_init_module+0x0/0x20() returned 0.
initcall 0xc0ca06b0 ran for 0 msecs: sis900_init_module+0x0/0x20()
Calling initcall 0xc0ca06d0: tg3_init+0x0/0x20()
initcall 0xc0ca06d0: tg3_init+0x0/0x20() returned 0.
initcall 0xc0ca06d0 ran for 0 msecs: tg3_init+0x0/0x20()
Calling initcall 0xc0ca06f0: bnx2x_init+0x0/0x20()
initcall 0xc0ca06f0: bnx2x_init+0x0/0x20() returned 0.
initcall 0xc0ca06f0 ran for 0 msecs: bnx2x_init+0x0/0x20()
Calling initcall 0xc0ca0710: skge_init_module+0x0/0x50()
initcall 0xc0ca0710: skge_init_module+0x0/0x50() returned 0.
initcall 0xc0ca0710 ran for 0 msecs: skge_init_module+0x0/0x50()
Calling initcall 0xc0ca0760: rhine_init+0x0/0x70()
initcall 0xc0ca0760: rhine_init+0x0/0x70() returned 0.
initcall 0xc0ca0760 ran for 0 msecs: rhine_init+0x0/0x70()
Calling initcall 0xc0ca07d0: starfire_init+0x0/0x20()
initcall 0xc0ca07d0: starfire_init+0x0/0x20() returned 0.
initcall 0xc0ca07d0 ran for 0 msecs: starfire_init+0x0/0x20()
Calling initcall 0xc0ca0830: marvell_init+0x0/0x70()
initcall 0xc0ca0830: marvell_init+0x0/0x70() returned 0.
initcall 0xc0ca0830 ran for 0 msecs: marvell_init+0x0/0x70()
Calling initcall 0xc0ca08a0: qs6612_init+0x0/0x10()
initcall 0xc0ca08a0: qs6612_init+0x0/0x10() returned 0.
initcall 0xc0ca08a0 ran for 0 msecs: qs6612_init+0x0/0x10()
Calling initcall 0xc0ca08b0: smsc_init+0x0/0x10()
initcall 0xc0ca08b0: smsc_init+0x0/0x10() returned 0.
initcall 0xc0ca08b0 ran for 0 msecs: smsc_init+0x0/0x10()
Calling initcall 0xc0ca08c0: realtek_init+0x0/0x10()
initcall 0xc0ca08c0: realtek_init+0x0/0x10() returned 0.
initcall 0xc0ca08c0 ran for 0 msecs: realtek_init+0x0/0x10()
Calling initcall 0xc0ca08d0: fixed_mdio_bus_init+0x0/0x90()
PM: Adding info for platform:Fixed MDIO bus.0
Fixed MDIO Bus: probed
initcall 0xc0ca08d0: fixed_mdio_bus_init+0x0/0x90() returned 0.
initcall 0xc0ca08d0 ran for 5 msecs: fixed_mdio_bus_init+0x0/0x90()
Calling initcall 0xc0ca0960: sundance_init+0x0/0x20()
initcall 0xc0ca0960: sundance_init+0x0/0x20() returned 0.
initcall 0xc0ca0960 ran for 0 msecs: sundance_init+0x0/0x20()
Calling initcall 0xc0ca09d0: net_olddevs_init+0x0/0x120()
initcall 0xc0ca09d0: net_olddevs_init+0x0/0x120() returned 0.
initcall 0xc0ca09d0 ran for 0 msecs: net_olddevs_init+0x0/0x120()
Calling initcall 0xc0ca0b70: sb1000_init+0x0/0x10()
pnp: the driver 'sb1000' has been registered
initcall 0xc0ca0b70: sb1000_init+0x0/0x10() returned 0.
initcall 0xc0ca0b70 ran for 3 msecs: sb1000_init+0x0/0x10()
Calling initcall 0xc0ca0cb0: hp100_module_init+0x0/0x50()
initcall 0xc0ca0cb0: hp100_module_init+0x0/0x50() returned 0.
initcall 0xc0ca0cb0 ran for 0 msecs: hp100_module_init+0x0/0x50()
Calling initcall 0xc0ca2310: b44_init+0x0/0x50()
initcall 0xc0ca2310: b44_init+0x0/0x50() returned 0.
initcall 0xc0ca2310 ran for 0 msecs: b44_init+0x0/0x50()
Calling initcall 0xc0ca2360: init_nic+0x0/0x20()
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PM: Adding info for No Bus:eth0
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
initcall 0xc0ca2360: init_nic+0x0/0x20() returned 0.
initcall 0xc0ca2360 ran for 536 msecs: init_nic+0x0/0x20()
Calling initcall 0xc0ca2380: dummy_init_module+0x0/0xc0()
PM: Adding info for No Bus:dummy0
initcall 0xc0ca2380: dummy_init_module+0x0/0xc0() returned 0.
initcall 0xc0ca2380 ran for 3 msecs: dummy_init_module+0x0/0xc0()
Calling initcall 0xc0ca2440: macvlan_init_module+0x0/0x50()
initcall 0xc0ca2440: macvlan_init_module+0x0/0x50() returned 0.
initcall 0xc0ca2440 ran for 0 msecs: macvlan_init_module+0x0/0x50()
Calling initcall 0xc0ca3160: rtl8139_init_module+0x0/0x20()
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [LNK2] -> GSI 11 (level, low) -> IRQ 11
PM: Adding info for No Bus:eth1
eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xc0ca3160: rtl8139_init_module+0x0/0x20() returned 0.
initcall 0xc0ca3160 ran for 26 msecs: rtl8139_init_module+0x0/0x20()
Calling initcall 0xc0ca3b60: depca_module_init+0x0/0xf0()
PM: Adding info for platform:depca.0
PM: Removing info for platform:depca.0
PM: Adding info for platform:depca.1
PM: Removing info for platform:depca.1
initcall 0xc0ca3b60: depca_module_init+0x0/0xf0() returned 0.
initcall 0xc0ca3b60 ran for 13 msecs: depca_module_init+0x0/0xf0()
Calling initcall 0xc0ca4630: lp486e_init_module+0x0/0x2a0()
eth%d: i82596 initialization timed out
initcall 0xc0ca4630: lp486e_init_module+0x0/0x2a0() returned -19.
initcall 0xc0ca4630 ran for 3 msecs: lp486e_init_module+0x0/0x2a0()
Calling initcall 0xc0ca48d0: eql_init_module+0x0/0x60()
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
PM: Adding info for No Bus:eql
initcall 0xc0ca48d0: eql_init_module+0x0/0x60() returned 0.
initcall 0xc0ca48d0 ran for 9 msecs: eql_init_module+0x0/0x60()
Calling initcall 0xc0ca49c0: veth_init+0x0/0x20()
initcall 0xc0ca49c0: veth_init+0x0/0x20() returned 0.
initcall 0xc0ca49c0 ran for 0 msecs: veth_init+0x0/0x20()
Calling initcall 0xc0ca49e0: rtl8169_init_module+0x0/0x20()
initcall 0xc0ca49e0: rtl8169_init_module+0x0/0x20() returned 0.
initcall 0xc0ca49e0 ran for 0 msecs: rtl8169_init_module+0x0/0x20()
Calling initcall 0xc0ca4a00: olympic_pci_init+0x0/0x20()
initcall 0xc0ca4a00: olympic_pci_init+0x0/0x20() returned 0.
initcall 0xc0ca4a00 ran for 0 msecs: olympic_pci_init+0x0/0x20()
Calling initcall 0xc0ca4a20: streamer_init_module+0x0/0x20()
initcall 0xc0ca4a20: streamer_init_module+0x0/0x20() returned 0.
initcall 0xc0ca4a20 ran for 0 msecs: streamer_init_module+0x0/0x20()
Calling initcall 0xc0ca4a40: abyss_init+0x0/0x20()
initcall 0xc0ca4a40: abyss_init+0x0/0x20() returned 0.
initcall 0xc0ca4a40 ran for 0 msecs: abyss_init+0x0/0x20()
Calling initcall 0xc0ca4b20: proteon_init+0x0/0x4b0()
PM: Adding info for platform:proteon.0
PM: Removing info for platform:proteon.0
PM: Adding info for platform:proteon.1
PM: Removing info for platform:proteon.1
PM: Adding info for platform:proteon.2
PM: Removing info for platform:proteon.2
proteon.c: 0 cards found.
proteon.c: No cards found.
initcall 0xc0ca4b20: proteon_init+0x0/0x4b0() returned -19.
initcall 0xc0ca4b20 ran for 25 msecs: proteon_init+0x0/0x4b0()
Calling initcall 0xc0ca4fd0: arcnet_init+0x0/0x70()
arcnet loaded.
initcall 0xc0ca4fd0: arcnet_init+0x0/0x70() returned 0.
initcall 0xc0ca4fd0 ran for 1 msecs: arcnet_init+0x0/0x70()
Calling initcall 0xc0ca5040: com90xx_init+0x0/0x10c0()
arcnet: COM90xx chipset support
S3: No ARCnet cards found.
initcall 0xc0ca5040: com90xx_init+0x0/0x10c0() returned -5.
initcall 0xc0ca5040 ran for 289 msecs: com90xx_init+0x0/0x10c0()
initcall at 0xc0ca5040: com90xx_init+0x0/0x10c0(): returned with error code -5
Calling initcall 0xc0ca6220: com90io_init+0x0/0x4a0()
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
initcall 0xc0ca6220: com90io_init+0x0/0x4a0() returned -19.
initcall 0xc0ca6220 ran for 16 msecs: com90io_init+0x0/0x4a0()
Calling initcall 0xc0ca6740: arc_rimi_init+0x0/0x510()
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
initcall 0xc0ca6740: arc_rimi_init+0x0/0x510() returned -5.
initcall 0xc0ca6740 ran for 17 msecs: arc_rimi_init+0x0/0x510()
initcall at 0xc0ca6740: arc_rimi_init+0x0/0x510(): returned with error code -5
Calling initcall 0xc0ca6c50: catc_init+0x0/0x30()
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
initcall 0xc0ca6c50: catc_init+0x0/0x30() returned 0.
initcall 0xc0ca6c50 ran for 9 msecs: catc_init+0x0/0x30()
Calling initcall 0xc0ca6c80: kaweth_init+0x0/0x30()
drivers/net/usb/kaweth.c: Driver loading
usbcore: registered new interface driver kaweth
initcall 0xc0ca6c80: kaweth_init+0x0/0x30() returned 0.
initcall 0xc0ca6c80 ran for 7 msecs: kaweth_init+0x0/0x30()
Calling initcall 0xc0ca6cb0: usb_irda_init+0x0/0x30()
usbcore: registered new interface driver irda-usb
USB IrDA support registered
initcall 0xc0ca6cb0: usb_irda_init+0x0/0x30() returned 0.
initcall 0xc0ca6cb0 ran for 6 msecs: usb_irda_init+0x0/0x30()
Calling initcall 0xc0ca6ce0: w83977af_init+0x0/0x500()
w83977af_init()
w83977af_open()
w83977af_probe()
w83977af_probe(), Wrong chip version<7>w83977af_probe()
w83977af_probe(), Wrong chip versioninitcall 0xc0ca6ce0: w83977af_init+0x0/0x500() returned -19.
initcall 0xc0ca6ce0 ran for 12 msecs: w83977af_init+0x0/0x500()
Calling initcall 0xc0ca71e0: donauboe_init+0x0/0x20()
initcall 0xc0ca71e0: donauboe_init+0x0/0x20() returned 0.
initcall 0xc0ca71e0 ran for 0 msecs: donauboe_init+0x0/0x20()
Calling initcall 0xc0ca8070: smsc_ircc_init+0x0/0x680()
initcall 0xc0ca8070: smsc_ircc_init+0x0/0x680() returned -19.
initcall 0xc0ca8070 ran for 0 msecs: smsc_ircc_init+0x0/0x680()
Calling initcall 0xc0ca8bc0: ali_ircc_init+0x0/0x7f0()
initcall 0xc0ca8bc0: ali_ircc_init+0x0/0x7f0() returned -19.
initcall 0xc0ca8bc0 ran for 0 msecs: ali_ircc_init+0x0/0x7f0()
Calling initcall 0xc0ca93b0: via_ircc_init+0x0/0x60()
initcall 0xc0ca93b0: via_ircc_init+0x0/0x60() returned 0.
initcall 0xc0ca93b0 ran for 0 msecs: via_ircc_init+0x0/0x60()
Calling initcall 0xc0ca9410: mcs_init+0x0/0x40()
usbcore: registered new interface driver mcs7780
initcall 0xc0ca9410: mcs_init+0x0/0x40() returned 0.
initcall 0xc0ca9410 ran for 4 msecs: mcs_init+0x0/0x40()
Calling initcall 0xc0ca9450: irtty_sir_init+0x0/0x40()
initcall 0xc0ca9450: irtty_sir_init+0x0/0x40() returned 0.
initcall 0xc0ca9450 ran for 0 msecs: irtty_sir_init+0x0/0x40()
Calling initcall 0xc0ca9490: sir_wq_init+0x0/0x30()
initcall 0xc0ca9490: sir_wq_init+0x0/0x30() returned 0.
initcall 0xc0ca9490 ran for 0 msecs: sir_wq_init+0x0/0x30()
Calling initcall 0xc0ca94c0: tekram_sir_init+0x0/0x50()
irda_register_dongle : registering dongle "Tekram IR-210B" (0).
initcall 0xc0ca94c0: tekram_sir_init+0x0/0x50() returned 0.
initcall 0xc0ca94c0 ran for 5 msecs: tekram_sir_init+0x0/0x50()
Calling initcall 0xc0ca9510: old_belkin_sir_init+0x0/0x10()
irda_register_dongle : registering dongle "Old Belkin SmartBeam" (7).
initcall 0xc0ca9510: old_belkin_sir_init+0x0/0x10() returned 0.
initcall 0xc0ca9510 ran for 5 msecs: old_belkin_sir_init+0x0/0x10()
Calling initcall 0xc0ca9520: act200l_sir_init+0x0/0x10()
irda_register_dongle : registering dongle "ACTiSYS ACT-IR200L" (10).
initcall 0xc0ca9520: act200l_sir_init+0x0/0x10() returned 0.
initcall 0xc0ca9520 ran for 5 msecs: act200l_sir_init+0x0/0x10()
Calling initcall 0xc0ca9530: ks959_init+0x0/0x20()
usbcore: registered new interface driver ks959-sir
initcall 0xc0ca9530: ks959_init+0x0/0x20() returned 0.
initcall 0xc0ca9530 ran for 4 msecs: ks959_init+0x0/0x20()
Calling initcall 0xc0ca9570: init_netconsole+0x0/0x200()
console [netcon0] enabled
Clocksource tsc unstable (delta = 9373990636 ns)
Time: acpi_pm clocksource has been installed.
netconsole: network logging started
initcall 0xc0ca9570: init_netconsole+0x0/0x200() returned 0.
initcall 0xc0ca9570 ran for 10630 msecs: init_netconsole+0x0/0x200()
Calling initcall 0xc0ca9770: netxen_init_module+0x0/0x50()
initcall 0xc0ca9770: netxen_init_module+0x0/0x50() returned 0.
initcall 0xc0ca9770 ran for 0 msecs: netxen_init_module+0x0/0x50()
Calling initcall 0xc0ca97c0: niu_init+0x0/0x50()
initcall 0xc0ca97c0: niu_init+0x0/0x50() returned 0.
initcall 0xc0ca97c0 ran for 0 msecs: niu_init+0x0/0x50()
Calling initcall 0xc0ca9810: dabusb_init+0x0/0xa0()
usbcore: registered new interface driver dabusb
drivers/media/video/dabusb.c: v1.54:DAB-USB Interface Driver for Linux (c)1999
initcall 0xc0ca9810: dabusb_init+0x0/0xa0() returned 0.
initcall 0xc0ca9810 ran for 10 msecs: dabusb_init+0x0/0xa0()
Calling initcall 0xc0ca9bb0: scsi_tgt_init+0x0/0x90()
PM: Adding info for No Bus:tgt
initcall 0xc0ca9bb0: scsi_tgt_init+0x0/0x90() returned 0.
initcall 0xc0ca9bb0 ran for 2 msecs: scsi_tgt_init+0x0/0x90()
Calling initcall 0xc0ca9c40: spi_transport_init+0x0/0x30()
initcall 0xc0ca9c40: spi_transport_init+0x0/0x30() returned 0.
initcall 0xc0ca9c40 ran for 0 msecs: spi_transport_init+0x0/0x30()
Calling initcall 0xc0ca9c70: fc_transport_init+0x0/0x50()
initcall 0xc0ca9c70: fc_transport_init+0x0/0x50() returned 0.
initcall 0xc0ca9c70 ran for 0 msecs: fc_transport_init+0x0/0x50()
Calling initcall 0xc0ca9cc0: iscsi_transport_init+0x0/0xf0()
Loading iSCSI transport class v2.0-868.
initcall 0xc0ca9cc0: iscsi_transport_init+0x0/0xf0() returned 0.
initcall 0xc0ca9cc0 ran for 3 msecs: iscsi_transport_init+0x0/0xf0()
Calling initcall 0xc0ca9db0: sas_transport_init+0x0/0xb0()
initcall 0xc0ca9db0: sas_transport_init+0x0/0xb0() returned 0.
initcall 0xc0ca9db0 ran for 0 msecs: sas_transport_init+0x0/0xb0()
Calling initcall 0xc0ca9e60: sas_class_init+0x0/0x30()
initcall 0xc0ca9e60: sas_class_init+0x0/0x30() returned 0.
initcall 0xc0ca9e60 ran for 0 msecs: sas_class_init+0x0/0x30()
Calling initcall 0xc0cac340: BusLogic_init+0x0/0x13c0()
initcall 0xc0cac340: BusLogic_init+0x0/0x13c0() returned 0.
initcall 0xc0cac340 ran for 0 msecs: BusLogic_init+0x0/0x13c0()
Calling initcall 0xc0cad880: aha152x_init+0x0/0x4e0()
initcall 0xc0cad880: aha152x_init+0x0/0x4e0() returned 0.
initcall 0xc0cad880 ran for 0 msecs: aha152x_init+0x0/0x4e0()
Calling initcall 0xc0cadd60: ahc_linux_init+0x0/0x60()
initcall 0xc0cadd60: ahc_linux_init+0x0/0x60() returned 0.
initcall 0xc0cadd60 ran for 0 msecs: ahc_linux_init+0x0/0x60()
Calling initcall 0xc0caddc0: ahd_linux_init+0x0/0x80()
initcall 0xc0caddc0: ahd_linux_init+0x0/0x80() returned 0.
initcall 0xc0caddc0 ran for 0 msecs: ahd_linux_init+0x0/0x80()
Calling initcall 0xc0cade40: aac_init+0x0/0x60()
Adaptec aacraid driver 1.1-5[2455]-ms
initcall 0xc0cade40: aac_init+0x0/0x60() returned 0.
initcall 0xc0cade40 ran for 3 msecs: aac_init+0x0/0x60()
Calling initcall 0xc0cadea0: init_this_scsi_driver+0x0/0x100()
initcall 0xc0cadea0: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cadea0 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cadfa0: aic94xx_init+0x0/0x150()
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall 0xc0cadfa0: aic94xx_init+0x0/0x150() returned 0.
initcall 0xc0cadfa0 ran for 5 msecs: aic94xx_init+0x0/0x150()
Calling initcall 0xc0cae0f0: ips_module_init+0x0/0x1f0()
initcall 0xc0cae0f0: ips_module_init+0x0/0x1f0() returned -19.
initcall 0xc0cae0f0 ran for 0 msecs: ips_module_init+0x0/0x1f0()
Calling initcall 0xc0cae2e0: init_this_scsi_driver+0x0/0x100()
scsi: <fdomain> Detection failed (no card)
initcall 0xc0cae2e0: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cae2e0 ran for 3 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cae480: init_this_scsi_driver+0x0/0x100()
initcall 0xc0cae480: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cae480 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0caee70: init_this_scsi_driver+0x0/0x100()
initcall 0xc0caee70: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0caee70 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0caf8d0: init_this_scsi_driver+0x0/0x100()
initcall 0xc0caf8d0: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0caf8d0 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cb0160: init_this_scsi_driver+0x0/0x100()
sym53c416.c: Version 1.0.0-ac
initcall 0xc0cb0160: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cb0160 ran for 2 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cb0730: qla1280_init+0x0/0x20()
initcall 0xc0cb0730: qla1280_init+0x0/0x20() returned 0.
initcall 0xc0cb0730 ran for 0 msecs: qla1280_init+0x0/0x20()
Calling initcall 0xc0cb0750: qla2x00_module_init+0x0/0x120()
QLogic Fibre Channel HBA Driver
initcall 0xc0cb0750: qla2x00_module_init+0x0/0x120() returned 0.
initcall 0xc0cb0750 ran for 2 msecs: qla2x00_module_init+0x0/0x120()
Calling initcall 0xc0cb0900: init_this_scsi_driver+0x0/0x100()
initcall 0xc0cb0900: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cb0900 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cb0f90: dmx3191d_init+0x0/0x20()
initcall 0xc0cb0f90: dmx3191d_init+0x0/0x20() returned 0.
initcall 0xc0cb0f90 ran for 0 msecs: dmx3191d_init+0x0/0x20()
Calling initcall 0xc0cb0fc0: init_this_scsi_driver+0x0/0x100()
initcall 0xc0cb0fc0: init_this_scsi_driver+0x0/0x100() returned -19.
initcall 0xc0cb0fc0 ran for 0 msecs: init_this_scsi_driver+0x0/0x100()
Calling initcall 0xc0cb15d0: sym2_init+0x0/0xf0()
initcall 0xc0cb15d0: sym2_init+0x0/0xf0() returned 0.
initcall 0xc0cb15d0 ran for 0 msecs: sym2_init+0x0/0xf0()
Calling initcall 0xc0cb16c0: dc390_module_init+0x0/0x80()
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
initcall 0xc0cb16c0: dc390_module_init+0x0/0x80() returned 0.
initcall 0xc0cb16c0 ran for 10 msecs: dc390_module_init+0x0/0x80()
Calling initcall 0xc0cb1790: megaraid_init+0x0/0xb0()
initcall 0xc0cb1790: megaraid_init+0x0/0xb0() returned 0.
initcall 0xc0cb1790 ran for 0 msecs: megaraid_init+0x0/0xb0()
Calling initcall 0xc0cb1840: mraid_mm_init+0x0/0x80()
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
PM: Adding info for No Bus:megadev0
initcall 0xc0cb1840: mraid_mm_init+0x0/0x80() returned 0.
initcall 0xc0cb1840 ran for 8 msecs: mraid_mm_init+0x0/0x80()
Calling initcall 0xc0cb18c0: megaraid_init+0x0/0x90()
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
initcall 0xc0cb18c0: megaraid_init+0x0/0x90() returned 0.
initcall 0xc0cb18c0 ran for 5 msecs: megaraid_init+0x0/0x90()
Calling initcall 0xc0cb1950: megasas_init+0x0/0x130()
megasas: 00.00.03.16-rc1 Thu. Nov. 07 10:09:32 PDT 2007
initcall 0xc0cb1950: megasas_init+0x0/0x130() returned 0.
initcall 0xc0cb1950 ran for 4 msecs: megasas_init+0x0/0x130()
Calling initcall 0xc0cb3730: gdth_init+0x0/0xee0()
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
initcall 0xc0cb3730: gdth_init+0x0/0xee0() returned -19.
initcall 0xc0cb3730 ran for 8 msecs: gdth_init+0x0/0xee0()
Calling initcall 0xc0cb48f0: tw_init+0x0/0x30()
3ware Storage Controller device driver for Linux v1.26.02.002.
initcall 0xc0cb48f0: tw_init+0x0/0x30() returned 0.
initcall 0xc0cb48f0 ran for 5 msecs: tw_init+0x0/0x30()
Calling initcall 0xc0cb4920: init_nsp32+0x0/0x30()
nsp32: loading...
initcall 0xc0cb4920: init_nsp32+0x0/0x30() returned 0.
initcall 0xc0cb4920 ran for 1 msecs: init_nsp32+0x0/0x30()
Calling initcall 0xc0cb4950: hptiop_module_init+0x0/0x30()
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
initcall 0xc0cb4950: hptiop_module_init+0x0/0x30() returned 0.
initcall 0xc0cb4950 ran for 4 msecs: hptiop_module_init+0x0/0x30()
Calling initcall 0xc0cb4a90: init_st+0x0/0x170()
st: Version 20080221, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
initcall 0xc0cb4a90: init_st+0x0/0x170() returned 0.
initcall 0xc0cb4a90 ran for 9 msecs: init_st+0x0/0x170()
Calling initcall 0xc0cb4ce0: init_osst+0x0/0x120()
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
Driver 'osst' needs updating - please use bus_type methods
initcall 0xc0cb4ce0: init_osst+0x0/0x120() returned 0.
initcall 0xc0cb4ce0 ran for 15 msecs: init_osst+0x0/0x120()
Calling initcall 0xc0cb4e00: init_sd+0x0/0xb0()
Driver 'sd' needs updating - please use bus_type methods
initcall 0xc0cb4e00: init_sd+0x0/0xb0() returned 0.
initcall 0xc0cb4e00 ran for 4 msecs: init_sd+0x0/0xb0()
Calling initcall 0xc0cb4eb0: init_sr+0x0/0x50()
Driver 'sr' needs updating - please use bus_type methods
initcall 0xc0cb4eb0: init_sr+0x0/0x50() returned 0.
initcall 0xc0cb4eb0 ran for 4 msecs: init_sr+0x0/0x50()
Calling initcall 0xc0cb4f00: init_sg+0x0/0xd0()
initcall 0xc0cb4f00: init_sg+0x0/0xd0() returned 0.
initcall 0xc0cb4f00 ran for 0 msecs: init_sg+0x0/0xd0()
Calling initcall 0xc0cb5380: ahci_init+0x0/0x20()
initcall 0xc0cb5380: ahci_init+0x0/0x20() returned 0.
initcall 0xc0cb5380 ran for 0 msecs: ahci_init+0x0/0x20()
Calling initcall 0xc0cb53a0: piix_init+0x0/0x20()
initcall 0xc0cb53a0: piix_init+0x0/0x20() returned 0.
initcall 0xc0cb53a0 ran for 0 msecs: piix_init+0x0/0x20()
Calling initcall 0xc0cb53c0: pdc_ata_init+0x0/0x20()
initcall 0xc0cb53c0: pdc_ata_init+0x0/0x20() returned 0.
initcall 0xc0cb53c0 ran for 0 msecs: pdc_ata_init+0x0/0x20()
Calling initcall 0xc0cb53e0: qs_ata_init+0x0/0x20()
initcall 0xc0cb53e0: qs_ata_init+0x0/0x20() returned 0.
initcall 0xc0cb53e0 ran for 0 msecs: qs_ata_init+0x0/0x20()
Calling initcall 0xc0cb5400: sil_init+0x0/0x20()
initcall 0xc0cb5400: sil_init+0x0/0x20() returned 0.
initcall 0xc0cb5400 ran for 0 msecs: sil_init+0x0/0x20()
Calling initcall 0xc0cb5420: sil24_init+0x0/0x20()
initcall 0xc0cb5420: sil24_init+0x0/0x20() returned 0.
initcall 0xc0cb5420 ran for 0 msecs: sil24_init+0x0/0x20()
Calling initcall 0xc0cb5440: svia_init+0x0/0x20()
initcall 0xc0cb5440: svia_init+0x0/0x20() returned 0.
initcall 0xc0cb5440 ran for 0 msecs: svia_init+0x0/0x20()
Calling initcall 0xc0cb5460: vsc_sata_init+0x0/0x20()
initcall 0xc0cb5460: vsc_sata_init+0x0/0x20() returned 0.
initcall 0xc0cb5460 ran for 0 msecs: vsc_sata_init+0x0/0x20()
Calling initcall 0xc0cb5480: sis_init+0x0/0x20()
initcall 0xc0cb5480: sis_init+0x0/0x20() returned 0.
initcall 0xc0cb5480 ran for 0 msecs: sis_init+0x0/0x20()
Calling initcall 0xc0cb54a0: mv_init+0x0/0x40()
initcall 0xc0cb54a0: mv_init+0x0/0x40() returned 0.
initcall 0xc0cb54a0 ran for 0 msecs: mv_init+0x0/0x40()
Calling initcall 0xc0cb54e0: ali_init+0x0/0x20()
initcall 0xc0cb54e0: ali_init+0x0/0x20() returned 0.
initcall 0xc0cb54e0 ran for 0 msecs: ali_init+0x0/0x20()
Calling initcall 0xc0cb5500: amd_init+0x0/0x20()
pata_amd 0000:00:06.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi0 : pata_amd
PM: Adding info for No Bus:host0
scsi1 : pata_amd
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x701f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
ata2.01: configured for UDMA/33
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sda
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda3
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:sda6
PM: Adding info for No Bus:sda7
PM: Adding info for No Bus:sda8
PM: Adding info for No Bus:sda9
PM: Adding info for No Bus:sda10
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
PM: Adding info for No Bus:target1:0:1
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:1:0
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:sr0
sr 1:0:1:0: Attached scsi CD-ROM sr0
sr 1:0:1:0: Attached scsi generic sg1 type 5
initcall 0xc0cb5500: amd_init+0x0/0x20() returned 0.
initcall 0xc0cb5500 ran for 932 msecs: amd_init+0x0/0x20()
Calling initcall 0xc0cb5520: artop_init+0x0/0x20()
initcall 0xc0cb5520: artop_init+0x0/0x20() returned 0.
initcall 0xc0cb5520 ran for 0 msecs: artop_init+0x0/0x20()
Calling initcall 0xc0cb5540: atiixp_init+0x0/0x20()
initcall 0xc0cb5540: atiixp_init+0x0/0x20() returned 0.
initcall 0xc0cb5540 ran for 0 msecs: atiixp_init+0x0/0x20()
Calling initcall 0xc0cb5560: cmd640_init+0x0/0x20()
initcall 0xc0cb5560: cmd640_init+0x0/0x20() returned 0.
initcall 0xc0cb5560 ran for 0 msecs: cmd640_init+0x0/0x20()
Calling initcall 0xc0cb5580: cs5520_init+0x0/0x20()
initcall 0xc0cb5580: cs5520_init+0x0/0x20() returned 0.
initcall 0xc0cb5580 ran for 0 msecs: cs5520_init+0x0/0x20()
Calling initcall 0xc0cb55a0: cs5530_init+0x0/0x20()
initcall 0xc0cb55a0: cs5530_init+0x0/0x20() returned 0.
initcall 0xc0cb55a0 ran for 0 msecs: cs5530_init+0x0/0x20()
Calling initcall 0xc0cb55c0: cs5535_init+0x0/0x20()
initcall 0xc0cb55c0: cs5535_init+0x0/0x20() returned 0.
initcall 0xc0cb55c0 ran for 0 msecs: cs5535_init+0x0/0x20()
Calling initcall 0xc0cb55e0: cs5536_init+0x0/0x20()
initcall 0xc0cb55e0: cs5536_init+0x0/0x20() returned 0.
initcall 0xc0cb55e0 ran for 0 msecs: cs5536_init+0x0/0x20()
Calling initcall 0xc0cb5600: cy82c693_init+0x0/0x20()
initcall 0xc0cb5600: cy82c693_init+0x0/0x20() returned 0.
initcall 0xc0cb5600 ran for 0 msecs: cy82c693_init+0x0/0x20()
Calling initcall 0xc0cb5620: it821x_init+0x0/0x20()
initcall 0xc0cb5620: it821x_init+0x0/0x20() returned 0.
initcall 0xc0cb5620 ran for 0 msecs: it821x_init+0x0/0x20()
Calling initcall 0xc0cb5640: it8213_init+0x0/0x20()
initcall 0xc0cb5640: it8213_init+0x0/0x20() returned 0.
initcall 0xc0cb5640 ran for 0 msecs: it8213_init+0x0/0x20()
Calling initcall 0xc0cb5660: jmicron_init+0x0/0x20()
initcall 0xc0cb5660: jmicron_init+0x0/0x20() returned 0.
initcall 0xc0cb5660 ran for 0 msecs: jmicron_init+0x0/0x20()
Calling initcall 0xc0cb5680: ns87410_init+0x0/0x20()
initcall 0xc0cb5680: ns87410_init+0x0/0x20() returned 0.
initcall 0xc0cb5680 ran for 0 msecs: ns87410_init+0x0/0x20()
Calling initcall 0xc0cb56a0: opti_init+0x0/0x20()
initcall 0xc0cb56a0: opti_init+0x0/0x20() returned 0.
initcall 0xc0cb56a0 ran for 0 msecs: opti_init+0x0/0x20()
Calling initcall 0xc0cb56c0: optidma_init+0x0/0x20()
initcall 0xc0cb56c0: optidma_init+0x0/0x20() returned 0.
initcall 0xc0cb56c0 ran for 0 msecs: optidma_init+0x0/0x20()
Calling initcall 0xc0cb56e0: oldpiix_init+0x0/0x20()
initcall 0xc0cb56e0: oldpiix_init+0x0/0x20() returned 0.
initcall 0xc0cb56e0 ran for 0 msecs: oldpiix_init+0x0/0x20()
Calling initcall 0xc0cb5700: pdc202xx_init+0x0/0x20()
initcall 0xc0cb5700: pdc202xx_init+0x0/0x20() returned 0.
initcall 0xc0cb5700 ran for 0 msecs: pdc202xx_init+0x0/0x20()
Calling initcall 0xc0cb58d0: qdi_init+0x0/0x1e0()
initcall 0xc0cb58d0: qdi_init+0x0/0x1e0() returned -19.
initcall 0xc0cb58d0 ran for 0 msecs: qdi_init+0x0/0x1e0()
Calling initcall 0xc0cb5ab0: radisys_init+0x0/0x20()
initcall 0xc0cb5ab0: radisys_init+0x0/0x20() returned 0.
initcall 0xc0cb5ab0 ran for 0 msecs: radisys_init+0x0/0x20()
Calling initcall 0xc0cb5ad0: via_init+0x0/0x20()
initcall 0xc0cb5ad0: via_init+0x0/0x20() returned 0.
initcall 0xc0cb5ad0 ran for 0 msecs: via_init+0x0/0x20()
Calling initcall 0xc0cb5af0: sl82c105_init+0x0/0x20()
initcall 0xc0cb5af0: sl82c105_init+0x0/0x20() returned 0.
initcall 0xc0cb5af0 ran for 0 msecs: sl82c105_init+0x0/0x20()
Calling initcall 0xc0cb5b10: sis_init+0x0/0x20()
initcall 0xc0cb5b10: sis_init+0x0/0x20() returned 0.
initcall 0xc0cb5b10 ran for 0 msecs: sis_init+0x0/0x20()
Calling initcall 0xc0cb5b30: triflex_init+0x0/0x20()
initcall 0xc0cb5b30: triflex_init+0x0/0x20() returned 0.
initcall 0xc0cb5b30 ran for 0 msecs: triflex_init+0x0/0x20()
Calling initcall 0xc0cb5b50: pacpi_init+0x0/0x20()
initcall 0xc0cb5b50: pacpi_init+0x0/0x20() returned 0.
initcall 0xc0cb5b50 ran for 0 msecs: pacpi_init+0x0/0x20()
Calling initcall 0xc0cb5b70: legacy_init+0x0/0xa80()
initcall 0xc0cb5b70: legacy_init+0x0/0xa80() returned -19.
initcall 0xc0cb5b70 ran for 0 msecs: legacy_init+0x0/0xa80()
Calling initcall 0xc0cb65f0: fusion_init+0x0/0x100()
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
initcall 0xc0cb65f0: fusion_init+0x0/0x100() returned 0.
initcall 0xc0cb65f0 ran for 6 msecs: fusion_init+0x0/0x100()
Calling initcall 0xc0cb66f0: mptfc_init+0x0/0xf0()
Fusion MPT FC Host driver 3.04.06
initcall 0xc0cb66f0: mptfc_init+0x0/0xf0() returned 0.
initcall 0xc0cb66f0 ran for 2 msecs: mptfc_init+0x0/0xf0()
Calling initcall 0xc0cb67e0: mptsas_init+0x0/0xe0()
Fusion MPT SAS Host driver 3.04.06
initcall 0xc0cb67e0: mptsas_init+0x0/0xe0() returned 0.
initcall 0xc0cb67e0 ran for 3 msecs: mptsas_init+0x0/0xe0()
Calling initcall 0xc0cb68c0: mptctl_init+0x0/0x100()
Fusion MPT misc device (ioctl) driver 3.04.06
PM: Adding info for No Bus:mptctl
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall 0xc0cb68c0: mptctl_init+0x0/0x100() returned 0.
initcall 0xc0cb68c0 ran for 14 msecs: mptctl_init+0x0/0x100()
Calling initcall 0xc0cb6ce0: cdrom_init+0x0/0x10()
initcall 0xc0cb6ce0: cdrom_init+0x0/0x10() returned 0.
initcall 0xc0cb6ce0 ran for 0 msecs: cdrom_init+0x0/0x10()
Calling initcall 0xc0cb6e10: aoe_init+0x0/0xb0()
PM: Adding info for No Bus:err
PM: Adding info for No Bus:discover
PM: Adding info for No Bus:interfaces
PM: Adding info for No Bus:revalidate
PM: Adding info for No Bus:flush
aoe: AoE v47 initialised.
initcall 0xc0cb6e10: aoe_init+0x0/0xb0() returned 0.
initcall 0xc0cb6e10 ran for 17 msecs: aoe_init+0x0/0xb0()
Calling initcall 0xc0cb7130: mon_init+0x0/0x100()
PM: Adding info for No Bus:usbmon0
initcall 0xc0cb7130: mon_init+0x0/0x100() returned 0.
initcall 0xc0cb7130 ran for 3 msecs: mon_init+0x0/0x100()
Calling initcall 0xc0cb7320: ehci_hcd_init+0x0/0x90()
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
PM: Adding info for No Bus:usb_host1
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
PM: Adding info for No Bus:usbmon1
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:02.1: park 0
ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: supports USB remote wakeup
ehci_hcd 0000:00:02.1: irq 9, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc4-sched-devel.git-x86-latest.git ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
initcall 0xc0cb7320: ehci_hcd_init+0x0/0x90() returned 0.
initcall 0xc0cb7320 ran for 333 msecs: ehci_hcd_init+0x0/0x90()
Calling initcall 0xc0cb73b0: ohci_hcd_mod_init+0x0/0xc0()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
PM: Adding info for No Bus:usb_host2
drivers/usb/core/inode.c: creating file '002'
PM: Adding info for No Bus:usbmon2
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: irq 11, io mem 0xda102000
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0020
ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
usb usb2: default language 0x0409
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc4-sched-devel.git-x86-latest.git ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
initcall 0xc0cb73b0: ohci_hcd_mod_init+0x0/0xc0() returned 0.
initcall 0xc0cb73b0 ran for 407 msecs: ohci_hcd_mod_init+0x0/0xc0()
Calling initcall 0xc0cb7470: uhci_hcd_init+0x0/0xf0()
USB Universal Host Controller Interface driver v3.0
initcall 0xc0cb7470: uhci_hcd_init+0x0/0xf0() returned 0.
initcall 0xc0cb7470 ran for 4 msecs: uhci_hcd_init+0x0/0xf0()
Calling initcall 0xc0cb7560: sl811h_init+0x0/0x40()
sl811: driver sl811-hcd, 19 May 2005
initcall 0xc0cb7560: sl811h_init+0x0/0x40() returned 0.
initcall 0xc0cb7560 ran for 3 msecs: sl811h_init+0x0/0x40()
Calling initcall 0xc0cb75a0: r8a66597_init+0x0/0x40()
drivers/usb/host/r8a66597-hcd.c: driver r8a66597_hcd, 29 May 2007
initcall 0xc0cb75a0: r8a66597_init+0x0/0x40() returned 0.
initcall 0xc0cb75a0 ran for 5 msecs: r8a66597_init+0x0/0x40()
Calling initcall 0xc0cb7820: usblp_init+0x0/0x20()
usbcore: registered new interface driver usblp
initcall 0xc0cb7820: usblp_init+0x0/0x20() returned 0.
initcall 0xc0cb7820 ran for 4 msecs: usblp_init+0x0/0x20()
Calling initcall 0xc0cb7840: usb_usual_init+0x0/0x50()
usbcore: registered new interface driver libusual
initcall 0xc0cb7840: usb_usual_init+0x0/0x50() returned 0.
initcall 0xc0cb7840 ran for 4 msecs: usb_usual_init+0x0/0x50()
Calling initcall 0xc0cb7890: usb_mdc800_init+0x0/0x200()
usbcore: registered new interface driver mdc800
drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall 0xc0cb7890: usb_mdc800_init+0x0/0x200() returned 0.
initcall 0xc0cb7890 ran for 11 msecs: usb_mdc800_init+0x0/0x200()
Calling initcall 0xc0cb7a90: microtek_drv_init+0x0/0x20()
usbcore: registered new interface driver microtekX6
initcall 0xc0cb7a90: microtek_drv_init+0x0/0x20() returned 0.
initcall 0xc0cb7a90 ran for 4 msecs: microtek_drv_init+0x0/0x20()
Calling initcall 0xc0cb7ab0: usb_serial_init+0x0/0x1f0()
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
initcall 0xc0cb7ab0: usb_serial_init+0x0/0x1f0() returned 0.
initcall 0xc0cb7ab0 ran for 20 msecs: usb_serial_init+0x0/0x1f0()
Calling initcall 0xc0cb7ca0: aircable_init+0x0/0x40()
drivers/usb/serial/usb-serial.c: USB Serial support registered for aircable
usbcore: registered new interface driver aircable
initcall 0xc0cb7ca0: aircable_init+0x0/0x40() returned 0.
initcall 0xc0cb7ca0 ran for 10 msecs: aircable_init+0x0/0x40()
Calling initcall 0xc0cb7ce0: belkin_sa_init+0x0/0x70()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver belkin
drivers/usb/serial/belkin_sa.c: USB Belkin Serial converter driver v1.2
initcall 0xc0cb7ce0: belkin_sa_init+0x0/0x70() returned 0.
initcall 0xc0cb7ce0 ran for 19 msecs: belkin_sa_init+0x0/0x70()
Calling initcall 0xc0cb7d50: cp2101_init+0x0/0x70()
drivers/usb/serial/usb-serial.c: USB Serial support registered for cp2101
usbcore: registered new interface driver cp2101
drivers/usb/serial/cp2101.c: Silicon Labs CP2101/CP2102 RS232 serial adaptor driver v0.07
initcall 0xc0cb7d50: cp2101_init+0x0/0x70() returned 0.
initcall 0xc0cb7d50 ran for 17 msecs: cp2101_init+0x0/0x70()
Calling initcall 0xc0cb7dc0: cypress_init+0x0/0xc0()
drivers/usb/serial/usb-serial.c: USB Serial support registered for DeLorme Earthmate USB
drivers/usb/serial/usb-serial.c: USB Serial support registered for HID->COM RS232 Adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for Nokia CA-42 V2 Adapter
usbcore: registered new interface driver cypress
drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver v1.09
initcall 0xc0cb7dc0: cypress_init+0x0/0xc0() returned 0.
initcall 0xc0cb7dc0 ran for 32 msecs: cypress_init+0x0/0xc0()
Calling initcall 0xc0cb7e80: edgeport_init+0x0/0xc0()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 2 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 4 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 8 port adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_edgeport
drivers/usb/serial/io_edgeport.c: Edgeport USB Serial Driver v2.7
initcall 0xc0cb7e80: edgeport_init+0x0/0xc0() returned 0.
initcall 0xc0cb7e80 ran for 39 msecs: edgeport_init+0x0/0xc0()
Calling initcall 0xc0cb7f40: ftdi_init+0x0/0x100()
drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
initcall 0xc0cb7f40: ftdi_init+0x0/0x100() returned 0.
initcall 0xc0cb7f40 ran for 17 msecs: ftdi_init+0x0/0x100()
Calling initcall 0xc0cb8040: ipaq_init+0x0/0x80()
drivers/usb/serial/usb-serial.c: USB Serial support registered for PocketPC PDA
drivers/usb/serial/ipaq.c: USB PocketPC PDA driver v0.5
usbcore: registered new interface driver ipaq
initcall 0xc0cb8040: ipaq_init+0x0/0x80() returned 0.
initcall 0xc0cb8040 ran for 15 msecs: ipaq_init+0x0/0x80()
Calling initcall 0xc0cb80c0: keyspan_pda_init+0x0/0x80()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA
drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA - (prerenumeration)
usbcore: registered new interface driver keyspan_pda
drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter driver v1.1
initcall 0xc0cb80c0: keyspan_pda_init+0x0/0x80() returned 0.
initcall 0xc0cb80c0 ran for 25 msecs: keyspan_pda_init+0x0/0x80()
Calling initcall 0xc0cb8140: kobil_init+0x0/0x80()
drivers/usb/serial/usb-serial.c: USB Serial support registered for KOBIL USB smart card terminal
usbcore: registered new interface driver kobil
drivers/usb/serial/kobil_sct.c: 21/05/2004 KOBIL Systems GmbH - http://www.kobil.com
drivers/usb/serial/kobil_sct.c: KOBIL USB Smart Card Terminal Driver (experimental)
initcall 0xc0cb8140: kobil_init+0x0/0x80() returned 0.
initcall 0xc0cb8140 ran for 26 msecs: kobil_init+0x0/0x80()
Calling initcall 0xc0cb81c0: mct_u232_init+0x0/0x70()
drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.1
initcall 0xc0cb81c0: mct_u232_init+0x0/0x70() returned 0.
initcall 0xc0cb81c0 ran for 18 msecs: mct_u232_init+0x0/0x70()
Calling initcall 0xc0cb8230: moschip7720_init+0x0/0x90()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 2 port adapter
drivers/usb/serial/mos7720.c: Moschip USB Serial Driver 1.0.0.4F
usbcore: registered new interface driver moschip7720
initcall 0xc0cb8230: moschip7720_init+0x0/0x90() returned 0.
initcall 0xc0cb8230 ran for 17 msecs: moschip7720_init+0x0/0x90()
Calling initcall 0xc0cb82c0: moschip7840_init+0x0/0xe0()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
drivers/usb/serial/mos7840.c: Moschip 7840/7820 USB Serial Driver 1.3.1
usbcore: registered new interface driver mos7840
initcall 0xc0cb82c0: moschip7840_init+0x0/0xe0() returned 0.
initcall 0xc0cb82c0 ran for 18 msecs: moschip7840_init+0x0/0xe0()
Calling initcall 0xc0cb83a0: pl2303_init+0x0/0x70()
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
initcall 0xc0cb83a0: pl2303_init+0x0/0x70() returned 0.
initcall 0xc0cb83a0 ran for 16 msecs: pl2303_init+0x0/0x70()
Calling initcall 0xc0cb8410: sierra_init+0x0/0x70()
drivers/usb/serial/usb-serial.c: USB Serial support registered for Sierra USB modem
usbcore: registered new interface driver sierra
drivers/usb/serial/sierra.c: USB Driver for Sierra Wireless USB modems: v.1.2.7
initcall 0xc0cb8410: sierra_init+0x0/0x70() returned 0.
initcall 0xc0cb8410 ran for 17 msecs: sierra_init+0x0/0x70()
Calling initcall 0xc0cb8480: adu_init+0x0/0xa0()
drivers/usb/misc/adutux.c :  adu_init : enter 
usbcore: registered new interface driver adutux
drivers/usb/misc/adutux.c: adutux adutux (see www.ontrak.net) v0.0.13
drivers/usb/misc/adutux.c: adutux is an experimental driver. Use at your own risk
drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
initcall 0xc0cb8480: adu_init+0x0/0xa0() returned 0.
initcall 0xc0cb8480 ran for 26 msecs: adu_init+0x0/0xa0()
Calling initcall 0xc0cb8520: appledisplay_init+0x0/0x50()
usbcore: registered new interface driver appledisplay
initcall 0xc0cb8520: appledisplay_init+0x0/0x50() returned 0.
initcall 0xc0cb8520 ran for 4 msecs: appledisplay_init+0x0/0x50()
Calling initcall 0xc0cb8570: auerswald_init+0x0/0x40()
drivers/usb/misc/auerswald.c: init
usbcore: registered new interface driver auerswald
initcall 0xc0cb8570: auerswald_init+0x0/0x40() returned 0.
initcall 0xc0cb8570 ran for 7 msecs: auerswald_init+0x0/0x40()
Calling initcall 0xc0cb85b0: berry_init+0x0/0x20()
usbcore: registered new interface driver berry_charge
initcall 0xc0cb85b0: berry_init+0x0/0x20() returned 0.
initcall 0xc0cb85b0 ran for 4 msecs: berry_init+0x0/0x20()
Calling initcall 0xc0cb85d0: usb_cytherm_init+0x0/0x50()
usbcore: registered new interface driver cytherm
drivers/usb/misc/cytherm.c: v1.0:Cypress USB Thermometer driver
initcall 0xc0cb85d0: usb_cytherm_init+0x0/0x50() returned 0.
initcall 0xc0cb85d0 ran for 9 msecs: usb_cytherm_init+0x0/0x50()
Calling initcall 0xc0cb8620: usb_idmouse_init+0x0/0x40()
drivers/usb/misc/idmouse.c: Siemens ID Mouse FingerTIP Sensor Driver 0.6
usbcore: registered new interface driver idmouse
initcall 0xc0cb8620: usb_idmouse_init+0x0/0x40() returned 0.
initcall 0xc0cb8620 ran for 10 msecs: usb_idmouse_init+0x0/0x40()
Calling initcall 0xc0cb8660: iowarrior_init+0x0/0x20()
usbcore: registered new interface driver iowarrior
initcall 0xc0cb8660: iowarrior_init+0x0/0x20() returned 0.
initcall 0xc0cb8660 ran for 4 msecs: iowarrior_init+0x0/0x20()
Calling initcall 0xc0cb8680: usb_led_init+0x0/0x30()
usbcore: registered new interface driver usbled
initcall 0xc0cb8680: usb_led_init+0x0/0x30() returned 0.
initcall 0xc0cb8680 ran for 4 msecs: usb_led_init+0x0/0x30()
Calling initcall 0xc0cb86b0: usbtest_init+0x0/0x50()
usbcore: registered new interface driver usbtest
initcall 0xc0cb86b0: usbtest_init+0x0/0x50() returned 0.
initcall 0xc0cb86b0 ran for 4 msecs: usbtest_init+0x0/0x50()
Calling initcall 0xc0cb8700: uss720_init+0x0/0x60()
usbcore: registered new interface driver uss720
drivers/usb/misc/uss720.c: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
drivers/usb/misc/uss720.c: NOTE: this is a special purpose driver to allow nonstandard
drivers/usb/misc/uss720.c: protocols (eg. bitbang) over USS720 usb to parallel cables
drivers/usb/misc/uss720.c: If you just want to connect to a printer, use usblp instead
initcall 0xc0cb8700: uss720_init+0x0/0x60() returned 0.
initcall 0xc0cb8700 ran for 35 msecs: uss720_init+0x0/0x60()
Calling initcall 0xc0cb8760: usb_sisusb_init+0x0/0x20()
usbcore: registered new interface driver sisusb
initcall 0xc0cb8760: usb_sisusb_init+0x0/0x20() returned 0.
initcall 0xc0cb8760 ran for 4 msecs: usb_sisusb_init+0x0/0x20()
Calling initcall 0xc0cb87b0: cxacru_init+0x0/0x20()
usbcore: registered new interface driver cxacru
initcall 0xc0cb87b0: cxacru_init+0x0/0x20() returned 0.
initcall 0xc0cb87b0 ran for 4 msecs: cxacru_init+0x0/0x20()
Calling initcall 0xc0cb87d0: speedtch_usb_init+0x0/0x30()
drivers/usb/atm/speedtch.c: speedtch_usb_init: driver version 1.10
usbcore: registered new interface driver speedtch
initcall 0xc0cb87d0: speedtch_usb_init+0x0/0x30() returned 0.
initcall 0xc0cb87d0 ran for 9 msecs: speedtch_usb_init+0x0/0x30()
Calling initcall 0xc0cb8800: uea_init+0x0/0x20()
[ueagle-atm] driver ueagle 1.4 loaded
usbcore: registered new interface driver ueagle-atm
initcall 0xc0cb8800: uea_init+0x0/0x20() returned 0.
initcall 0xc0cb8800 ran for 7 msecs: <7>ohci_hcd 0000:00:02.0: auto-stop root hub
uea_init+0x0/0x20()
Calling initcall 0xc0cb8820: usbatm_usb_init+0x0/0x60()
drivers/usb/atm/usbatm.c: usbatm_usb_init: driver version 1.10
initcall 0xc0cb8820: usbatm_usb_init+0x0/0x60() returned 0.
initcall 0xc0cb8820 ran for 5 msecs: usbatm_usb_init+0x0/0x60()
Calling initcall 0xc0cb8880: init+0x0/0x30()
initcall 0xc0cb8880: init+0x0/0x30() returned 0.
initcall 0xc0cb8880 ran for 0 msecs: init+0x0/0x30()
Calling initcall 0xc0cb88b0: init+0x0/0x30()
gadgetfs: USB Gadget filesystem, version 24 Aug 2004
initcall 0xc0cb88b0: init+0x0/0x30() returned 0.
initcall 0xc0cb88b0 ran for 4 msecs: init+0x0/0x30()
Calling initcall 0xc0cb8970: i8042_init+0x0/0x3c0()
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:0b: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:0a: driver attached
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc0cb8970<7>PM: Adding info for serio:serio1
: i8042_init+0x0/0x3c0() returned 0.
initcall 0xc0cb8970 ran for 35 msecs: i8042_init+0x0/0x3c0()
Calling initcall 0xc0cb8d30: parkbd_init+0x0/0x180()
parkbd: no such parport
initcall 0xc0cb8d30: parkbd_init+0x0/0x180() returned -19.
initcall 0xc0cb8d30 ran for 2 msecs: parkbd_init+0x0/0x180()
Calling initcall 0xc0cb8eb0: serport_init+0x0/0x30()
initcall 0xc0cb8eb0: serport_init+0x0/0x30() returned 0.
initcall 0xc0cb8eb0 ran for 0 msecs: serport_init+0x0/0x30()
Calling initcall 0xc0cb8ee0: pcips2_init+0x0/0x20()
initcall 0xc0cb8ee0: pcips2_init+0x0/0x20() returned 0.
initcall 0xc0cb8ee0 ran for 0 msecs: pcips2_init+0x0/0x20()
Calling initcall 0xc0cb8f90: ns558_init+0x0/0x3b0()
pnp: the driver 'ns558' has been registered
gameport: NS558 PnP Gameport is pnp00:0d/gameport0, io 0x201, speed 890kHz
PM: Adding info for gameport:gameport0
ns558 00:0d: driver attached
initcall 0xc0cb8f90: ns558_init+0x0/0x3b0() returned 0.
initcall 0xc0cb8f90 ran for 38 msecs: ns558_init+0x0/0x3b0()
Calling initcall 0xc0cb9430: mousedev_init+0x0/0x50()
PM: Adding info for No Bus:mice
mice: PS/2 mouse device common for all mice
initcall 0xc0cb9430: mousedev_init+0x0/0x50() returned 0.
initcall 0xc0cb9430 ran for 6 msecs: mousedev_init+0x0/0x50()
Calling initcall 0xc0cb9490: atkbd_init+0x0/0x20()
initcall 0xc0cb9490: atkbd_init+0x0/0x20() returned 0.
initcall 0xc0cb9490 ran for 0 msecs: atkbd_init+0x0/0x20()
Calling initcall 0xc0cb94b0: nkbd_init+0x0/0x20()
PM: Adding info for No Bus:input0
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc0cb94b0: nkbd_init+0x0/0x20() returned 0.
initcall 0xc0cb94b0 ran for 26 msecs: nkbd_init+0x0/0x20()
Calling initcall 0xc0cb94d0: adi_init+0x0/0x10()
initcall 0xc0cb94d0: adi_init+0x0/0x10() returned 0.
initcall 0xc0cb94d0 ran for 0 msecs: adi_init+0x0/0x10()
Calling initcall 0xc0cb94e0: cobra_init+0x0/0x10()
initcall 0xc0cb94e0: cobra_init+0x0/0x10() returned 0.
initcall 0xc0cb94e0 ran for 0 msecs: cobra_init+0x0/0x10()
Calling initcall 0xc0cb94f0: gc_init+0x0/0x630()
initcall 0xc0cb94f0: gc_init+0x0/0x630() returned -19.
initcall 0xc0cb94f0 ran for 0 msecs: gc_init+0x0/0x630()
Calling initcall 0xc0cb9b20: grip_init+0x0/0x10()
initcall 0xc0cb9b20: grip_init+0x0/0x10() returned 0.
initcall 0xc0cb9b20 ran for 0 msecs: grip_init+0x0/0x10()
Calling initcall 0xc0cb9b30: magellan_init+0x0/0x20()
initcall 0xc0cb9b30: magellan_init+0x0/0x20() returned 0.
initcall 0xc0cb9b30 ran for 9 msecs: magellan_init+0x0/0x20()
Calling initcall 0xc0cb9b50: sw_init+0x0/0x10()
initcall 0xc0cb9b50: sw_init+0x0/0x10() returned 0.
initcall 0xc0cb9b50 ran for 0 msecs: sw_init+0x0/0x10()
Calling initcall 0xc0cb9b60: spaceball_init+0x0/0x20()
initcall 0xc0cb9b60: spaceball_init+0x0/0x20() returned 0.
initcall 0xc0cb9b60 ran for 0 msecs: spaceball_init+0x0/0x20()
Calling initcall 0xc0cb9b80: stinger_init+0x0/0x20()
initcall 0xc0cb9b80: stinger_init+0x0/0x20() returned 0.
initcall 0xc0cb9b80 ran for 0 msecs: stinger_init+0x0/0x20()
Calling initcall 0xc0cb9ba0: tgfx_init+0x0/0x3e0()
initcall 0xc0cb9ba0: tgfx_init+0x0/0x3e0() returned -19.
initcall 0xc0cb9ba0 ran for 0 msecs: tgfx_init+0x0/0x3e0()
Calling initcall 0xc0cb9f80: warrior_init+0x0/0x20()
initcall 0xc0cb9f80: warrior_init+0x0/0x20() returned 0.
initcall 0xc0cb9f80 ran for 9 msecs: warrior_init+0x0/0x20()
Calling initcall 0xc0cb9fa0: usb_xpad_init+0x0/0x30()
usbcore: registered new interface driver xpad
drivers/input/joystick/xpad.c: X-Box pad driver:v0.0.6
initcall 0xc0cb9fa0: usb_xpad_init+0x0/0x30() returned 0.
initcall 0xc0cb9fa0 ran for 50 msecs: usb_xpad_init+0x0/0x30()
Calling initcall 0xc0cb9fd0: iforce_init+0x0/0x20()
usbcore: registered new interface driver iforce
initcall 0xc0cb9fd0: iforce_init+0x0/0x20() returned 0.
initcall 0xc0cb9fd0 ran for 32 msecs: iforce_init+0x0/0x20()
Calling initcall 0xc0cb9ff0: elo_init+0x0/0x20()
initcall 0xc0cb9ff0: elo_init+0x0/0x20() returned 0.
initcall 0xc0cb9ff0 ran for 11 msecs: elo_init+0x0/0x20()
Calling initcall 0xc0cba010: mtouch_init+0x0/0x20()
initcall 0xc0cba010: mtouch_init+0x0/0x20() returned 0.
initcall 0xc0cba010 ran for 28 msecs: <7>hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:02.1: suspend root hub
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ohci_hcd 0000:00:02.0: suspend root hub
mtouch_init+0x0/0x20()
Calling initcall 0xc0cba030: mk712_init+0x0/0x1d0()
mk712: device not present
initcall 0xc0cba030: mk712_init+0x0/0x1d0() returned -19.
initcall 0xc0cba030 ran for 36 msecs: mk712_init+0x0/0x1d0()
Calling initcall 0xc0cba200: usbtouch_init+0x0/0x20()
usbcore: registered new interface driver usbtouchscreen
initcall 0xc0cba200: usbtouch_init+0x0/0x20() returned 0.
initcall 0xc0cba200 ran for 31 msecs: usbtouch_init+0x0/0x20()
Calling initcall 0xc0cba220: tr_init+0x0/0x20()
initcall 0xc0cba220: tr_init+0x0/0x20() returned 0.
initcall 0xc0cba220 ran for 24 msecs: tr_init+0x0/0x20()
Calling initcall 0xc0cba240: ucb1400_ts_init+0x0/0x10()
initcall 0xc0cba240: ucb1400_ts_init+0x0/0x10() returned 0.
initcall 0xc0cba240 ran for 28 msecs: ucb1400_ts_init+0x0/0x10()
Calling initcall 0xc0cba3f0: cmos_init+0x0/0x10()
pnp: the driver 'rtc_cmos' has been registered
PM: Adding info for No Bus:rtc0
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
rtc_cmos 00:04: driver attached
initcall 0xc0cba3f0: cmos_init+0x0/0x10() returned 0.
initcall 0xc0cba3f0 ran for 284 msecs: cmos_init+0x0/0x10()
Calling initcall 0xc0cba400: ds1374_init+0x0/0x10()
i2c-core: driver [rtc-ds1374] registered
initcall 0xc0cba400: ds1374_init+0x0/0x10() returned 0.
initcall 0xc0cba400 ran for 4 msecs: ds1374_init+0x0/0x10()
Calling initcall 0xc0cba410: ds1742_init+0x0/0x10()
initcall 0xc0cba410: ds1742_init+0x0/0x10() returned 0.
initcall 0xc0cba410 ran for 0 msecs: ds1742_init+0x0/0x10()
Calling initcall 0xc0cba420: m41t80_rtc_init+0x0/0x10()
i2c-core: driver [rtc-m41t80] registered
initcall 0xc0cba420: m41t80_rtc_init+0x0/0x10() returned 0.
initcall 0xc0cba420 ran for 3 msecs: m41t80_rtc_init+0x0/0x10()
Calling initcall 0xc0cba430: m48t86_rtc_init+0x0/0x10()
initcall 0xc0cba430: m48t86_rtc_init+0x0/0x10() returned 0.
initcall 0xc0cba430 ran for 0 msecs: m48t86_rtc_init+0x0/0x10()
Calling initcall 0xc0cba440: s35390a_rtc_init+0x0/0x10()
i2c-core: driver [rtc-s35390a] registered
initcall 0xc0cba440: s35390a_rtc_init+0x0/0x10() returned 0.
initcall 0xc0cba440 ran for 3 msecs: s35390a_rtc_init+0x0/0x10()
Calling initcall 0xc0cba450: stk17ta8_init+0x0/0x10()
initcall 0xc0cba450: stk17ta8_init+0x0/0x10() returned 0.
initcall 0xc0cba450 ran for 0 msecs: stk17ta8_init+0x0/0x10()
Calling initcall 0xc0cba680: x1205_init+0x0/0x10()
i2c-core: driver [x1205] registered
initcall 0xc0cba680: x1205_init+0x0/0x10() returned 0.
initcall 0xc0cba680 ran for 3 msecs: x1205_init+0x0/0x10()
Calling initcall 0xc0cba7a0: i2c_dev_init+0x0/0x90()
i2c /dev entries driver
i2c-core: driver [dev_driver] registered
initcall 0xc0cba7a0: i2c_dev_init+0x0/0x90() returned 0.
initcall 0xc0cba7a0 ran for 5 msecs: i2c_dev_init+0x0/0x90()
Calling initcall 0xc0cba830: i2c_ali15x3_init+0x0/0x20()
initcall 0xc0cba830: i2c_ali15x3_init+0x0/0x20() returned 0.
initcall 0xc0cba830 ran for 0 msecs: i2c_ali15x3_init+0x0/0x20()
Calling initcall 0xc0cba850: amd756_init+0x0/0x20()
initcall 0xc0cba850: amd756_init+0x0/0x20() returned 0.
initcall 0xc0cba850 ran for 0 msecs: amd756_init+0x0/0x20()
Calling initcall 0xc0cba870: amd756_s4882_init+0x0/0x2e0()
i2c-core: attempting to delete unregistered adapter []
initcall 0xc0cba870: amd756_s4882_init+0x0/0x2e0() returned -19.
initcall 0xc0cba870 ran for 4 msecs: amd756_s4882_init+0x0/0x2e0()
Calling initcall 0xc0cbab50: i2c_amd8111_init+0x0/0x20()
initcall 0xc0cbab50: i2c_amd8111_init+0x0/0x20() returned 0.
initcall 0xc0cbab50 ran for 0 msecs: i2c_amd8111_init+0x0/0x20()
Calling initcall 0xc0cbab70: i2c_pcfisa_init+0x0/0x10()
PM: Adding info for isa:i2c-elektor.0
initcall 0xc0cbab70: i2c_pcfisa_init+0x0/0x10() returned 0.
initcall 0xc0cbab70 ran for 3 msecs: i2c_pcfisa_init+0x0/0x10()
Calling initcall 0xc0cbab80: i2c_i810_init+0x0/0x20()
initcall 0xc0cbab80: i2c_i810_init+0x0/0x20() returned 0.
initcall 0xc0cbab80 ran for 0 msecs: i2c_i810_init+0x0/0x20()
Calling initcall 0xc0cbaba0: ocores_i2c_init+0x0/0x10()
initcall 0xc0cbaba0: ocores_i2c_init+0x0/0x10() returned 0.
initcall 0xc0cbaba0 ran for 0 msecs: ocores_i2c_init+0x0/0x10()
Calling initcall 0xc0cbabb0: i2c_parport_init+0x0/0x40()
i2c-parport: adapter type unspecified
initcall 0xc0cbabb0: i2c_parport_init+0x0/0x40() returned -19.
initcall 0xc0cbabb0 ran for 3 msecs: i2c_parport_init+0x0/0x40()
Calling initcall 0xc0cbabf0: i2c_parport_init+0x0/0x1b0()
i2c-parport-light: adapter type unspecified
initcall 0xc0cbabf0: i2c_parport_init+0x0/0x1b0() returned -19.
initcall 0xc0cbabf0 ran for 3 msecs: i2c_parport_init+0x0/0x1b0()
Calling initcall 0xc0cbada0: pca_isa_init+0x0/0x10()
PM: Adding info for isa:i2c-pca-isa.0
i2c-pca-isa i2c-pca-isa.0: i/o base 0x000330. irq 10
I2C adapter driver [PCA9564 ISA Adapter] forgot to specify physical device
PM: Adding info for No Bus:i2c-0
i2c-adapter i2c-0: adapter [PCA9564 ISA Adapter] registered
PM: Adding info for No Bus:i2c-0
i2c-dev: adapter [PCA9564 ISA Adapter] registered as minor 0
initcall 0xc0cbada0: pca_isa_init+0x0/0x10() returned 0.
initcall 0xc0cbada0 ran for 30 msecs: pca_isa_init+0x0/0x10()
Calling initcall 0xc0cbadb0: i2c_prosavage_init+0x0/0x20()
initcall 0xc0cbadb0: i2c_prosavage_init+0x0/0x20() returned 0.
initcall 0xc0cbadb0 ran for 0 msecs: i2c_prosavage_init+0x0/0x20()
Calling initcall 0xc0cbadd0: i2c_savage4_init+0x0/0x20()
initcall 0xc0cbadd0: i2c_savage4_init+0x0/0x20() returned 0.
initcall 0xc0cbadd0 ran for 0 msecs: i2c_savage4_init+0x0/0x20()
Calling initcall 0xc0cbadf0: i2c_adap_simtec_init+0x0/0x10()
initcall 0xc0cbadf0: i2c_adap_simtec_init+0x0/0x10() returned 0.
initcall 0xc0cbadf0 ran for 0 msecs: i2c_adap_simtec_init+0x0/0x10()
Calling initcall 0xc0cbae00: i2c_sis5595_init+0x0/0x20()
initcall 0xc0cbae00: i2c_sis5595_init+0x0/0x20() returned 0.
initcall 0xc0cbae00 ran for 0 msecs: i2c_sis5595_init+0x0/0x20()
Calling initcall 0xc0cbae20: i2c_sis96x_init+0x0/0x20()
initcall 0xc0cbae20: i2c_sis96x_init+0x0/0x20() returned 0.
initcall 0xc0cbae20 ran for 0 msecs: i2c_sis96x_init+0x0/0x20()
Calling initcall 0xc0cbae40: taos_init+0x0/0x20()
initcall 0xc0cbae40: taos_init+0x0/0x20() returned 0.
initcall 0xc0cbae40 ran for 0 msecs: taos_init+0x0/0x20()
Calling initcall 0xc0cbae60: usb_i2c_tiny_usb_init+0x0/0x20()
usbcore: registered new interface driver i2c-tiny-usb
initcall 0xc0cbae60: usb_i2c_tiny_usb_init+0x0/0x20() returned 0.
initcall 0xc0cbae60 ran for 4 msecs: usb_i2c_tiny_usb_init+0x0/0x20()
Calling initcall 0xc0cbae80: i2c_vt586b_init+0x0/0x20()
initcall 0xc0cbae80: i2c_vt586b_init+0x0/0x20() returned 0.
initcall 0xc0cbae80 ran for 0 msecs: i2c_vt586b_init+0x0/0x20()
Calling initcall 0xc0cbaea0: i2c_vt596_init+0x0/0x20()
initcall 0xc0cbaea0: i2c_vt596_init+0x0/0x20() returned 0.
initcall 0xc0cbaea0 ran for 0 msecs: i2c_vt596_init+0x0/0x20()
Calling initcall 0xc0cbaec0: eeprom_init+0x0/0x10()
i2c-core: driver [eeprom] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
i2c-adapter i2c-0: master_xfer[0] W, addr=0x51, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
i2c-adapter i2c-0: master_xfer[0] W, addr=0x52, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
i2c-adapter i2c-0: master_xfer[0] W, addr=0x53, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
i2c-adapter i2c-0: master_xfer[0] W, addr=0x54, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
i2c-adapter i2c-0: master_xfer[0] W, addr=0x55, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
i2c-adapter i2c-0: master_xfer[0] W, addr=0x56, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
i2c-adapter i2c-0: master_xfer[0] W, addr=0x57, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
initcall 0xc0cbaec0: eeprom_init+0x0/0x10() returned 0.
initcall 0xc0cbaec0 ran for 12302 msecs: eeprom_init+0x0/0x10()
Calling initcall 0xc0cbaed0: pcf8574_init+0x0/0x10()
i2c-core: driver [pcf8574] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x20
i2c-adapter i2c-0: master_xfer[0] W, addr=0x20, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x21
i2c-adapter i2c-0: master_xfer[0] W, addr=0x21, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x22
i2c-adapter i2c-0: master_xfer[0] W, addr=0x22, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x23
i2c-adapter i2c-0: master_xfer[0] W, addr=0x23, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x24
i2c-adapter i2c-0: master_xfer[0] W, addr=0x24, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x25
i2c-adapter i2c-0: master_xfer[0] W, addr=0x25, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x26
i2c-adapter i2c-0: master_xfer[0] W, addr=0x26, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x27
i2c-adapter i2c-0: master_xfer[0] W, addr=0x27, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x38
i2c-adapter i2c-0: master_xfer[0] W, addr=0x38, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x39
i2c-adapter i2c-0: master_xfer[0] W, addr=0x39, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3a
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3a, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3b
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3b, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3c
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3c, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3d
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3d, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3e
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3e, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x3f
i2c-adapter i2c-0: master_xfer[0] W, addr=0x3f, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
initcall 0xc0cbaed0: pcf8574_init+0x0/0x10() returned 0.
initcall 0xc0cbaed0 ran for 24600 msecs: pcf8574_init+0x0/0x10()
Calling initcall 0xc0cbaee0: pcf8575_init+0x0/0x10()
i2c-core: driver [pcf8575] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x20
i2c-adapter i2c-0: master_xfer[0] W, addr=0x20, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x21
i2c-adapter i2c-0: master_xfer[0] W, addr=0x21, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x22
i2c-adapter i2c-0: master_xfer[0] W, addr=0x22, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x23
i2c-adapter i2c-0: master_xfer[0] W, addr=0x23, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x24
i2c-adapter i2c-0: master_xfer[0] W, addr=0x24, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x25
i2c-adapter i2c-0: master_xfer[0] W, addr=0x25, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x26
i2c-adapter i2c-0: master_xfer[0] W, addr=0x26, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x27
i2c-adapter i2c-0: master_xfer[0] W, addr=0x27, len=0
i2c-adapter i2c-0: bus is not idle. status is 0xfe
initcall 0xc0cbaee0: pcf8575_init+0x0/0x10() returned 0.
initcall 0xc0cbaee0 ran for 12302 msecs: pcf8575_init+0x0/0x10()
Calling initcall 0xc0cbaf80: tsl2550_init+0x0/0x10()
i2c-core: driver [tsl2550] registered
initcall 0xc0cbaf80: tsl2550_init+0x0/0x10() returned 0.
initcall 0xc0cbaf80 ran for 3 msecs: tsl2550_init+0x0/0x10()
Calling initcall 0xc07a2fa0: w1_init+0x0/0xf0()
Driver for 1-wire Dallas network protocol.
initcall 0xc07a2fa0: w1_init+0x0/0xf0() returned 0.
initcall 0xc07a2fa0 ran for 3 msecs: w1_init+0x0/0xf0()
Calling initcall 0xc0cbaf90: matrox_w1_init+0x0/0x20()
initcall 0xc0cbaf90: matrox_w1_init+0x0/0x20() returned 0.
initcall 0xc0cbaf90 ran for 0 msecs: matrox_w1_init+0x0/0x20()
Calling initcall 0xc0cbafb0: sensors_ds2482_init+0x0/0x10()
i2c-core: driver [ds2482] registered
initcall 0xc0cbafb0: sensors_ds2482_init+0x0/0x10() returned 0.
initcall 0xc0cbafb0 ran for 3 msecs: sensors_ds2482_init+0x0/0x10()
Calling initcall 0xc0cbafc0: w1_smem_init+0x0/0x40()
initcall 0xc0cbafc0: w1_smem_init+0x0/0x40() returned 0.
initcall 0xc0cbafc0 ran for 0 msecs: w1_smem_init+0x0/0x40()
Calling initcall 0xc0cbb000: w1_ds2760_init+0x0/0x20()
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall 0xc0cbb000: w1_ds2760_init+0x0/0x20() returned 0.
initcall 0xc0cbb000 ran for 7 msecs: w1_ds2760_init+0x0/0x20()
Calling initcall 0xc0cbb050: ds2760_battery_init+0x0/0x10()
initcall 0xc0cbb050: ds2760_battery_init+0x0/0x10() returned 0.
initcall 0xc0cbb050 ran for 0 msecs: ds2760_battery_init+0x0/0x10()
Calling initcall 0xc0cbb750: virtual_eisa_root_init+0x0/0x60()
PM: Adding info for platform:eisa.0
EISA: Probing bus 0 at eisa.0
PM: Removing info for platform:eisa.0
initcall 0xc0cbb750: virtual_eisa_root_init+0x0/0x60() returned -1.
initcall 0xc0cbb750 ran for 9 msecs: virtual_eisa_root_init+0x0/0x60()
initcall at 0xc0cbb750: virtual_eisa_root_init+0x0/0x60(): returned with error code -1
Calling initcall 0xc0cbb7f0: cpufreq_stats_init+0x0/0x60()
initcall 0xc0cbb7f0: cpufreq_stats_init+0x0/0x60() returned 0.
initcall 0xc0cbb7f0 ran for 0 msecs: cpufreq_stats_init+0x0/0x60()
Calling initcall 0xc0cbb860: cpufreq_gov_powersave_init+0x0/0x10()
initcall 0xc0cbb860: cpufreq_gov_powersave_init+0x0/0x10() returned 0.
initcall 0xc0cbb860 ran for 0 msecs: cpufreq_gov_powersave_init+0x0/0x10()
Calling initcall 0xc0cbb8f0: memstick_init+0x0/0x80()
initcall 0xc0cbb8f0: memstick_init+0x0/0x80() returned 0.
initcall 0xc0cbb8f0 ran for 0 msecs: memstick_init+0x0/0x80()
Calling initcall 0xc0cbb970: heartbeat_trig_init+0x0/0x10()
initcall 0xc0cbb970: heartbeat_trig_init+0x0/0x10() returned 0.
initcall 0xc0cbb970 ran for 0 msecs: heartbeat_trig_init+0x0/0x10()
Calling initcall 0xc0cbb980: ib_core_init+0x0/0x40()
initcall 0xc0cbb980: ib_core_init+0x0/0x40() returned 0.
initcall 0xc0cbb980 ran for 0 msecs: ib_core_init+0x0/0x40()
Calling initcall 0xc0cbb9d0: ib_mad_init_module+0x0/0x90()
initcall 0xc0cbb9d0: ib_mad_init_module+0x0/0x90() returned 0.
initcall 0xc0cbb9d0 ran for 0 msecs: ib_mad_init_module+0x0/0x90()
Calling initcall 0xc0cbba60: ib_sa_init+0x0/0x60()
initcall 0xc0cbba60: ib_sa_init+0x0/0x60() returned 0.
initcall 0xc0cbba60 ran for 0 msecs: ib_sa_init+0x0/0x60()
Calling initcall 0xc0cbbac0: ib_cm_init+0x0/0x110()
initcall 0xc0cbbac0: ib_cm_init+0x0/0x110() returned 0.
initcall 0xc0cbbac0 ran for 0 msecs: ib_cm_init+0x0/0x110()
Calling initcall 0xc0cbbbd0: iw_cm_init+0x0/0x30()
initcall 0xc0cbbbd0: iw_cm_init+0x0/0x30() returned 0.
initcall 0xc0cbbbd0 ran for 0 msecs: iw_cm_init+0x0/0x30()
Calling initcall 0xc07c43a0: addr_init+0x0/0x40()
initcall 0xc07c43a0: addr_init+0x0/0x40() returned 0.
initcall 0xc07c43a0 ran for 0 msecs: addr_init+0x0/0x40()
Calling initcall 0xc07c4e10: cma_init+0x0/0xd0()
initcall 0xc07c4e10: cma_init+0x0/0xd0() returned 0.
initcall 0xc07c4e10 ran for 0 msecs: cma_init+0x0/0xd0()
Calling initcall 0xc0cbbc00: ib_umad_init+0x0/0xc0()
initcall 0xc0cbbc00: ib_umad_init+0x0/0xc0() returned 0.
initcall 0xc0cbbc00 ran for 0 msecs: ib_umad_init+0x0/0xc0()
Calling initcall 0xc0cbbcc0: ib_uverbs_init+0x0/0x130()
initcall 0xc0cbbcc0: ib_uverbs_init+0x0/0x130() returned 0.
initcall 0xc0cbbcc0 ran for 0 msecs: ib_uverbs_init+0x0/0x130()
Calling initcall 0xc0cbbdf0: ib_ucm_init+0x0/0xa0()
initcall 0xc0cbbdf0: ib_ucm_init+0x0/0xa0() returned 0.
initcall 0xc0cbbdf0 ran for 0 msecs: ib_ucm_init+0x0/0xa0()
Calling initcall 0xc0cbbe90: ucma_init+0x0/0x50()
PM: Adding info for No Bus:rdma_cm
initcall 0xc0cbbe90: ucma_init+0x0/0x50() returned 0.
initcall 0xc0cbbe90 ran for 3 msecs: ucma_init+0x0/0x50()
Calling initcall 0xc0cbbf30: mthca_init+0x0/0x120()
initcall 0xc0cbbf30: mthca_init+0x0/0x120() returned 0.
initcall 0xc0cbbf30 ran for 0 msecs: mthca_init+0x0/0x120()
Calling initcall 0xc0cbc0a0: nes_init_module+0x0/0x120()
initcall 0xc0cbc0a0: nes_init_module+0x0/0x120() returned 0.
initcall 0xc0cbc0a0 ran for 0 msecs: nes_init_module+0x0/0x120()
Calling initcall 0xc0cbc1c0: ipoib_init_module+0x0/0x110()
initcall 0xc0cbc1c0: ipoib_init_module+0x0/0x110() returned 0.
initcall 0xc0cbc1c0 ran for 0 msecs: ipoib_init_module+0x0/0x110()
Calling initcall 0xc0cbc2d0: iser_init+0x0/0x110()
iscsi: registered transport (iser)
initcall 0xc0cbc2d0: iser_init+0x0/0x110() returned 0.
initcall 0xc0cbc2d0 ran for 3 msecs: iser_init+0x0/0x110()
Calling initcall 0xc0cbcba0: dcdrbu_init+0x0/0x110()
PM: Adding info for platform:dell_rbu
initcall 0xc0cbcba0: dcdrbu_init+0x0/0x110() returned 0.
initcall 0xc0cbcba0 ran for 3 msecs: dcdrbu_init+0x0/0x110()
Calling initcall 0xc0cbccb0: dcdbas_init+0x0/0x70()
PM: Adding info for platform:dcdbas
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
initcall 0xc0cbccb0: dcdbas_init+0x0/0x70() returned 0.
initcall 0xc0cbccb0 ran for 9 msecs: dcdbas_init+0x0/0x70()
Calling initcall 0xc0cbcfb0: geode_aes_init+0x0/0x20()
initcall 0xc0cbcfb0: geode_aes_init+0x0/0x20() returned 0.
initcall 0xc0cbcfb0 ran for 0 msecs: geode_aes_init+0x0/0x20()
Calling initcall 0xc0cbd1c0: ioat_init_module+0x0/0x20()
initcall 0xc0cbd1c0: ioat_init_module+0x0/0x20() returned 0.
initcall 0xc0cbd1c0 ran for 0 msecs: ioat_init_module+0x0/0x20()
Calling initcall 0xc0cbd1e0: dca_init+0x0/0x10()
initcall 0xc0cbd1e0: dca_init+0x0/0x10() returned 0.
initcall 0xc0cbd1e0 ran for 0 msecs: dca_init+0x0/0x10()
Calling initcall 0xc0cbd230: hid_init+0x0/0x10()
initcall 0xc0cbd230: hid_init+0x0/0x10() returned 0.
initcall 0xc0cbd230 ran for 0 msecs: hid_init+0x0/0x10()
Calling initcall 0xc0cbd2e0: hid_init+0x0/0x60()
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
initcall 0xc0cbd2e0: hid_init+0x0/0x60() returned 0.
initcall 0xc0cbd2e0 ran for 8 msecs: hid_init+0x0/0x60()
Calling initcall 0xc0cbd340: usb_mouse_init+0x0/0x30()
usbcore: registered new interface driver usbmouse
drivers/hid/usbhid/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
initcall 0xc0cbd340: usb_mouse_init+0x0/0x30() returned 0.
initcall 0xc0cbd340 ran for 10 msecs: usb_mouse_init+0x0/0x30()
Calling initcall 0xc0cbd3c0: init_soundcore+0x0/0x50()
initcall 0xc0cbd3c0: init_soundcore+0x0/0x50() returned 0.
initcall 0xc0cbd3c0 ran for 0 msecs: init_soundcore+0x0/0x50()
Calling initcall 0xc0cbeb00: sysctl_core_init+0x0/0x10()
initcall 0xc0cbeb00: sysctl_core_init+0x0/0x10() returned 0.
initcall 0xc0cbeb00 ran for 0 msecs: sysctl_core_init+0x0/0x10()
Calling initcall 0xc0cbf090: flow_cache_init+0x0/0x100()
initcall 0xc0cbf090: flow_cache_init+0x0/0x100() returned 0.
initcall 0xc0cbf090 ran for 0 msecs: flow_cache_init+0x0/0x100()
Calling initcall 0xc0cbf190: pg_init+0x0/0x260()
pktgen v2.69: Packet Generator for packet performance testing.
initcall 0xc0cbf190: pg_init+0x0/0x260() returned 0.
initcall 0xc0cbf190 ran for 5 msecs: pg_init+0x0/0x260()
Calling initcall 0xc0cbf4d0: llc_init+0x0/0x80()
initcall 0xc0cbf4d0: llc_init+0x0/0x80() returned 0.
initcall 0xc0cbf4d0 ran for 0 msecs: llc_init+0x0/0x80()
Calling initcall 0xc0cbf5d0: llc2_init+0x0/0xd0()
NET: Registered protocol family 26
initcall 0xc0cbf5d0: llc2_init+0x0/0xd0() returned 0.
initcall 0xc0cbf5d0 ran for 3 msecs: llc2_init+0x0/0xd0()
Calling initcall 0xc0cbf840: snap_init+0x0/0x30()
initcall 0xc0cbf840: snap_init+0x0/0x30() returned 0.
initcall 0xc0cbf840 ran for 0 msecs: snap_init+0x0/0x30()
Calling initcall 0xc0cbf870: rif_init+0x0/0x80()
initcall 0xc0cbf870: rif_init+0x0/0x80() returned 0.
initcall 0xc0cbf870 ran for 0 msecs: rif_init+0x0/0x80()
Calling initcall 0xc0cc09f0: sysctl_ipv4_init+0x0/0x20()
initcall 0xc0cc09f0: sysctl_ipv4_init+0x0/0x20() returned 0.
initcall 0xc0cc09f0 ran for 0 msecs: sysctl_ipv4_init+0x0/0x20()
Calling initcall 0xc0cc0b10: ipgre_init+0x0/0xa0()
GRE over IPv4 tunneling driver
PM: Adding info for No Bus:gre0
initcall 0xc0cc0b10: ipgre_init+0x0/0xa0() returned 0.
initcall 0xc0cc0b10 ran for 5 msecs: ipgre_init+0x0/0xa0()
Calling initcall 0xc0cc0bf0: init_syncookies+0x0/0x20()
initcall 0xc0cc0bf0: init_syncookies+0x0/0x20() returned 0.
initcall 0xc0cc0bf0 ran for 0 msecs: init_syncookies+0x0/0x20()
Calling initcall 0xc0cc0c10: xfrm4_transport_init+0x0/0x10()
initcall 0xc0cc0c10: xfrm4_transport_init+0x0/0x10() returned 0.
initcall 0xc0cc0c10 ran for 0 msecs: xfrm4_transport_init+0x0/0x10()
Calling initcall 0xc0cc0c20: inet_diag_init+0x0/0x70()
initcall 0xc0cc0c20: inet_diag_init+0x0/0x70() returned 0.
initcall 0xc0cc0c20 ran for 0 msecs: inet_diag_init+0x0/0x70()
Calling initcall 0xc0cc0c90: tcp_diag_init+0x0/0x10()
initcall 0xc0cc0c90: tcp_diag_init+0x0/0x10() returned 0.
initcall 0xc0cc0c90 ran for 0 msecs: tcp_diag_init+0x0/0x10()
Calling initcall 0xc0cc0ca0: cubictcp_register+0x0/0xb0()
TCP cubic registered
initcall 0xc0cc0ca0: cubictcp_register+0x0/0xb0() returned 0.
initcall 0xc0cc0ca0 ran for 1 msecs: cubictcp_register+0x0/0xb0()
Calling initcall 0xc0cc0ef0: af_unix_init+0x0/0x50()
NET: Registered protocol family 1
initcall 0xc0cc0ef0: af_unix_init+0x0/0x50() returned 0.
initcall 0xc0cc0ef0 ran for 2 msecs: af_unix_init+0x0/0x50()
Calling initcall 0xc0cc0f40: packet_init+0x0/0x40()
NET: Registered protocol family 17
initcall 0xc0cc0f40: packet_init+0x0/0x40() returned 0.
initcall 0xc0cc0f40 ran for 3 msecs: packet_init+0x0/0x40()
Calling initcall 0xc0cc1060: lapb_init+0x0/0x10()
initcall 0xc0cc1060: lapb_init+0x0/0x10() returned 0.
initcall 0xc0cc1060 ran for 0 msecs: lapb_init+0x0/0x10()
Calling initcall 0xc0cc1070: can_init+0x0/0x100()
can: controller area network core (rev 20071116 abi 8)
NET: Registered protocol family 29
initcall 0xc0cc1070: can_init+0x0/0x100() returned 0.
initcall 0xc0cc1070 ran for 7 msecs: can_init+0x0/0x100()
Calling initcall 0xc0cc1170: bcm_module_init+0x0/0x60()
can: broadcast manager protocol (rev 20071116)
initcall 0xc0cc1170: bcm_module_init+0x0/0x60() returned 0.
initcall 0xc0cc1170 ran for 4 msecs: bcm_module_init+0x0/0x60()
Calling initcall 0xc0cc16d0: irlan_init+0x0/0x290()
PM: Adding info for No Bus:irlan0
initcall 0xc0cc16d0: irlan_init+0x0/0x290() returned 0.
initcall 0xc0cc16d0 ran for 3 msecs: irlan_init+0x0/0x290()
Calling initcall 0xc0cc1960: ircomm_init+0x0/0x90()
IrCOMM protocol (Dag Brattli)
initcall 0xc0cc1960: ircomm_init+0x0/0x90() returned 0.
initcall 0xc0cc1960 ran for 2 msecs: ircomm_init+0x0/0x90()
Calling initcall 0xc0cc19f0: ircomm_tty_init+0x0/0x100()
PM: Adding info for No Bus:ircomm0
PM: Adding info for No Bus:ircomm1
PM: Adding info for No Bus:ircomm2
PM: Adding info for No Bus:ircomm3
PM: Adding info for No Bus:ircomm4
PM: Adding info for No Bus:ircomm5
PM: Adding info for No Bus:ircomm6
PM: Adding info for No Bus:ircomm7
PM: Adding info for No Bus:ircomm8
PM: Adding info for No Bus:ircomm9
PM: Adding info for No Bus:ircomm10
PM: Adding info for No Bus:ircomm11
PM: Adding info for No Bus:ircomm12
PM: Adding info for No Bus:ircomm13
PM: Adding info for No Bus:ircomm14
PM: Adding info for No Bus:ircomm15
PM: Adding info for No Bus:ircomm16
PM: Adding info for No Bus:ircomm17
PM: Adding info for No Bus:ircomm18
PM: Adding info for No Bus:ircomm19
PM: Adding info for No Bus:ircomm20
PM: Adding info for No Bus:ircomm21
PM: Adding info for No Bus:ircomm22
PM: Adding info for No Bus:ircomm23
PM: Adding info for No Bus:ircomm24
PM: Adding info for No Bus:ircomm25
PM: Adding info for No Bus:ircomm26
PM: Adding info for No Bus:ircomm27
PM: Adding info for No Bus:ircomm28
PM: Adding info for No Bus:ircomm29
PM: Adding info for No Bus:ircomm30
PM: Adding info for No Bus:ircomm31
initcall 0xc0cc19f0: ircomm_tty_init+0x0/0x100() returned 0.
initcall 0xc0cc19f0 ran for 100 msecs: ircomm_tty_init+0x0/0x100()
Calling initcall 0xc0cc1b10: init_sunrpc+0x0/0x70()
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall 0xc0cc1b10: init_sunrpc+0x0/0x70() returned 0.
initcall 0xc0cc1b10 ran for 6 msecs: init_sunrpc+0x0/0x70()
Calling initcall 0xc0cc1b80: init_rpcsec_gss+0x0/0x40()
initcall 0xc0cc1b80: init_rpcsec_gss+0x0/0x40() returned 0.
initcall 0xc0cc1b80 ran for 0 msecs: init_rpcsec_gss+0x0/0x40()
Calling initcall 0xc0cc1bc0: init_kerberos_module+0x0/0x20()
initcall 0xc0cc1bc0: init_kerberos_module+0x0/0x20() returned 0.
initcall 0xc0cc1bc0 ran for 0 msecs: init_kerberos_module+0x0/0x20()
Calling initcall 0xc0cc1be0: xprt_rdma_init+0x0/0xc0()
RPC: Registered rdma transport module.
initcall 0xc0cc1be0: xprt_rdma_init+0x0/0xc0() returned 0.
initcall 0xc0cc1be0 ran for 3 msecs: xprt_rdma_init+0x0/0xc0()
Calling initcall 0xc08e4280: svc_rdma_init+0x0/0xc0()
initcall 0xc08e4280: svc_rdma_init+0x0/0xc0() returned 0.
initcall 0xc08e4280 ran for 0 msecs: svc_rdma_init+0x0/0xc0()
Calling initcall 0xc0cc1e10: decnet_init+0x0/0x80()
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 1024 buckets, 4Kbytes
NET: Registered protocol family 12
initcall 0xc0cc1e10: decnet_init+0x0/0x80() returned 0.
initcall 0xc0cc1e10 ran for 14 msecs: decnet_init+0x0/0x80()
Calling initcall 0xc0cc2210: econet_proto_init+0x0/0x160()
NET: Registered protocol family 19
initcall 0xc0cc2210: econet_proto_init+0x0/0x160() returned 0.
initcall 0xc0cc2210 ran for 3 msecs: econet_proto_init+0x0/0x160()
Calling initcall 0xc0cc2370: vlan_proto_init+0x0/0x90()
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall 0xc0cc2370: vlan_proto_init+0x0/0x90() returned 0.
initcall 0xc0cc2370 ran for 9 msecs: vlan_proto_init+0x0/0x90()
Calling initcall 0xc0cc2470: sctp_init+0x0/0x690()
SCTP: Hash tables configured (established 65536 bind 65536)
sctp_init_sock(sk: f762dc40)
initcall 0xc0cc2470: sctp_init+0x0/0x690() returned 0.
initcall 0xc0cc2470 ran for 8 msecs: sctp_init+0x0/0x690()
Calling initcall 0xc0cc2bc0: ieee80211_init+0x0/0x20()
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
initcall 0xc0cc2bc0: ieee80211_init+0x0/0x20() returned 0.
initcall 0xc0cc2bc0 ran for 12 msecs: ieee80211_init+0x0/0x20()
Calling initcall 0xc0cc2be0: ieee80211_crypto_init+0x0/0x10()
ieee80211_crypt: registered algorithm 'NULL'
initcall 0xc0cc2be0: ieee80211_crypto_init+0x0/0x10() returned 0.
initcall 0xc0cc2be0 ran for 3 msecs: ieee80211_crypto_init+0x0/0x10()
Calling initcall 0xc0cc2bf0: ieee80211_crypto_wep_init+0x0/0x10()
ieee80211_crypt: registered algorithm 'WEP'
initcall 0xc0cc2bf0: ieee80211_crypto_wep_init+0x0/0x10() returned 0.
initcall 0xc0cc2bf0 ran for 3 msecs: ieee80211_crypto_wep_init+0x0/0x10()
Calling initcall 0xc0cc2c00: ieee80211_crypto_ccmp_init+0x0/0x10()
ieee80211_crypt: registered algorithm 'CCMP'
initcall 0xc0cc2c00: ieee80211_crypto_ccmp_init+0x0/0x10() returned 0.
initcall 0xc0cc2c00 ran for 3 msecs: ieee80211_crypto_ccmp_init+0x0/0x10()
Calling initcall 0xc0cc2c10: tipc_init+0x0/0xb0()
TIPC: Activated (version 1.6.2 compiled Mar  5 2008 21:55:29)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall 0xc0cc2c10: tipc_init+0x0/0xb0() returned 0.
initcall 0xc0cc2c10 ran for 11 msecs: tipc_init+0x0/0xb0()
Calling initcall 0xc0c88a70: powernow_init+0x0/0xd0()
initcall 0xc0c88a70: powernow_init+0x0/0xd0() returned -19.
initcall 0xc0c88a70 ran for 0 msecs: powernow_init+0x0/0xd0()
Calling initcall 0xc0cc5d80: powernowk8_init+0x0/0x40()
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (1 cpu cores) (version 2.20.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects
initcall 0xc0cc5d80: powernowk8_init+0x0/0x40() returned -19.
initcall 0xc0cc5d80 ran for 18 msecs: powernowk8_init+0x0/0x40()
Calling initcall 0xc0c89590: centrino_init+0x0/0x20()
initcall 0xc0c89590: centrino_init+0x0/0x20() returned -19.
initcall 0xc0c89590 ran for 0 msecs: centrino_init+0x0/0x20()
Calling initcall 0xc0c895e0: hpet_insert_resource+0x0/0x30()
initcall 0xc0c895e0: hpet_insert_resource+0x0/0x30() returned 1.
initcall 0xc0c895e0 ran for 0 msecs: hpet_insert_resource+0x0/0x30()
initcall at 0xc0c895e0: hpet_insert_resource+0x0/0x30(): returned with error code 1
Calling initcall 0xc0c8b050: check_early_ioremap_leak+0x0/0x40()
initcall 0xc0c8b050: check_early_ioremap_leak+0x0/0x40() returned 0.
initcall 0xc0c8b050 ran for 0 msecs: check_early_ioremap_leak+0x0/0x40()
Calling initcall 0xc0c8b4f0: print_ipi_mode+0x0/0x40()
Using IPI Shortcut mode
initcall 0xc0c8b4f0: print_ipi_mode+0x0/0x40() returned 0.
initcall 0xc0c8b4f0 ran for 2 msecs: print_ipi_mode+0x0/0x40()
Calling initcall 0xc012e9e0: init_oops_id+0x0/0x20()
initcall 0xc012e9e0: init_oops_id+0x0/0x20() returned 0.
initcall 0xc012e9e0 ran for 0 msecs: init_oops_id+0x0/0x20()
Calling initcall 0xc0c8beb0: disable_boot_consoles+0x0/0x40()
initcall 0xc0c8beb0: disable_boot_consoles+0x0/0x40() returned 0.
initcall 0xc0c8beb0 ran for 0 msecs: disable_boot_consoles+0x0/0x40()
Calling initcall 0xc0c8cbe0: pm_qos_power_init+0x0/0x70()
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
initcall 0xc0c8cbe0: pm_qos_power_init+0x0/0x70() returned 0.
initcall 0xc0c8cbe0 ran for 11 msecs: pm_qos_power_init+0x0/0x70()
Calling initcall 0xc0c8d4f0: taskstats_init+0x0/0x90()
registered taskstats version 1
initcall 0xc0c8d4f0: taskstats_init+0x0/0x90() returned 0.
initcall 0xc0c8d4f0 ran for 2 msecs: taskstats_init+0x0/0x90()
Calling initcall 0xc0c93900: random32_reseed+0x0/0x20()
initcall 0xc0c93900: random32_reseed+0x0/0x20() returned 0.
initcall 0xc0c93900 ran for 0 msecs: random32_reseed+0x0/0x20()
Calling initcall 0xc0c93fd0: pci_sysfs_init+0x0/0x50()
initcall 0xc0c93fd0: pci_sysfs_init+0x0/0x50() returned 0.
initcall 0xc0c93fd0 ran for 0 msecs: pci_sysfs_init+0x0/0x50()
Calling initcall 0xc0c96857: acpi_wakeup_device_init+0x0/0xa8()
initcall 0xc0c96857: acpi_wakeup_device_init+0x0/0xa8() returned 0.
initcall 0xc0c96857 ran for 0 msecs: acpi_wakeup_device_init+0x0/0xa8()
Calling initcall 0xc0c969e1: acpi_sleep_proc_init+0x0/0x4c()
initcall 0xc0c969e1: acpi_sleep_proc_init+0x0/0x4c() returned 0.
initcall 0xc0c969e1 ran for 0 msecs: acpi_sleep_proc_init+0x0/0x4c()
Calling initcall 0xc0c98310: seqgen_init+0x0/0x10()
initcall 0xc0c98310: seqgen_init+0x0/0x10() returned 0.
initcall 0xc0c98310 ran for 0 msecs: seqgen_init+0x0/0x10()
Calling initcall 0xc05c8840: scsi_complete_async_scans+0x0/0x110()
initcall 0xc05c8840: scsi_complete_async_scans+0x0/0x110() returned 0.
initcall 0xc05c8840 ran for 0 msecs: scsi_complete_async_scans+0x0/0x110()
Calling initcall 0xc0cba250: rtc_hctosys+0x0/0x150()
rtc_cmos 00:04: setting system clock to 2008-03-06 07:48:50 UTC (1204789730)
initcall 0xc0cba250: rtc_hctosys+0x0/0x150() returned 0.
initcall 0xc0cba250 ran for 6 msecs: rtc_hctosys+0x0/0x150()
Calling initcall 0xc0cc0100: tcp_congestion_default+0x0/0x10()
initcall 0xc0cc0100: tcp_congestion_default+0x0/0x10() returned 0.
initcall 0xc0cc0100 ran for 0 msecs: tcp_congestion_default+0x0/0x10()
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 516k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
INIT: version 2.86 booting
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
		Welcome to Fedora Core
		Press 'I' to enter interactive startup.
SysRq : Show State
  task                PC stack   pid father
init          S c0137e4c     0     1      0
       f7c3f7b0 00000086 c0e0f300 c0137e4c ed0b6fc2 00000014 f7c40000 f7c3f914 
       f7c3f914 00000286 00000286 00000000 ffff3369 00000000 00000000 c097c07f 
       c0e0fca0 c0c7407c ffff3369 c01383b0 f7c3f7b0 c0e0f300 00000000 00000000 
Call Trace:
 [<c0137e4c>] lock_timer_base+0x2c/0x70
 [<c097c07f>] schedule_timeout+0x3f/0xb0
 [<c01383b0>] process_timeout+0x0/0x10
 [<c018f367>] do_select+0x397/0x4a0
 [<c018fa00>] __pollwait+0x0/0xc0
 [<c012b580>] default_wake_function+0x0/0x10
 [<c012b571>] try_to_wake_up+0xb1/0xc0
 [<c014231f>] autoremove_wake_function+0xf/0x30
 [<c0119c17>] native_sched_clock+0x77/0xb0
 [<c0129d54>] update_curr+0x74/0x100
 [<c012aa5d>] finish_task_switch+0x1d/0xa0
 [<c097b941>] schedule+0x1b1/0x410
 [<c013f1a6>] __queue_work+0x36/0x70
 [<c03d4b84>] as_add_request+0xc4/0xd0
 [<c0145769>] ktime_get_ts+0x19/0x50
 [<c03a0026>] avc_has_perm+0x46/0x50
 [<c03a0026>] avc_has_perm+0x46/0x50
 [<c03a0026>] avc_has_perm+0x46/0x50
 [<c018f648>] core_sys_select+0x1d8/0x310
 [<c018bfcd>] link_path_walk+0x7d/0xa0
 [<c03a5eac>] selinux_inode_getattr+0x4c/0x60
 [<c0185b2e>] cp_new_stat64+0xfe/0x110
 [<c01936fc>] dput+0x1c/0x130
 [<c018fb9b>] sys_select+0xdb/0x1b0
 [<c0115a5f>] sysenter_past_esp+0x5f/0x90
 =======================
kthreadd      S 00000000     0     2      0
       f7c3f1d0 00000046 c01297b9 00000000 194b282f 00000015 f7c42000 f7c3f334 
       f7c3f334 f771dce4 00000246 c0bef450 f771dcc8 00000781 f7c42000 c0142164 
       00000000 c0142030 00000000 00000000 00000000 c0115ea7 00000000 00000000 
Call Trace:
 [<c01297b9>] __wake_up_common+0x49/0x80
 [<c0142164>] kthreadd+0x134/0x150
 [<c0142030>] kthreadd+0x0/0x150
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ksoftirqd/0   S c0e11ac0     0     3      2
       f7c3ebf0 00000046 00000006 c0e11ac0 c015a6e8 00000001 f7c44000 f7c3ed54 
       f7c3ed54 c0133cd6 00000246 f7c44000 00000000 00000000 00000000 c013445a 
       00000000 c01343c0 c0142014 c0141fc0 00000000 c0115ea7 f7c41f4c 00000000 
Call Trace:
 [<c015a6e8>] __rcu_process_callbacks+0x88/0x1d0
 [<c0133cd6>] __do_softirq+0x76/0xb0
 [<c013445a>] ksoftirqd+0x9a/0xf0
 [<c01343c0>] ksoftirqd+0x0/0xf0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
events/0      S c013f621     0     4      2
       f7c3e610 00000046 ffffffff c013f621 0059f31f 00000015 f7c46000 f7c3e774 
       f7c3e774 f7c02808 00000246 f7c02808 f7c02800 00000000 00000000 c013f775 
       00000000 f7c3e610 c0142310 f7c02808 f7c02808 f7c02800 c013f6c0 00000000 
Call Trace:
 [<c013f621>] queue_delayed_work_on+0x71/0xc0
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
khelper       S f7c3e030     0     5      2
       f7c3e030 00000046 ffffffff f7c3e030 f7c48000 c013eaa0 f7c48000 f7c3e194 
       f7c3e194 f7c027a8 00000246 f7c027a8 f7c027a0 00000000 00000000 c013f775 
       00000000 f7c3e030 c0142310 f7c027a8 f7c027a8 f7c027a0 c013f6c0 00000000 
Call Trace:
 [<c013eaa0>] __call_usermodehelper+0x0/0x70
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kblockd/0     S 00000247     0   249      2
       f7e807d0 00000046 f74e77dc 00000247 f74e77dc 00000247 f7e6a000 f7e80934 
       f7e80934 f7dcd268 00000246 f7dcd268 f7dcd260 00000000 00000000 c013f775 
       00000000 f7e807d0 c0142310 f7dcd268 f7dcd268 f7dcd260 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kacpid        S c0be6180     0   251      2
       f7e81390 00000046 c0be6180 c0be6180 3b9f2033 00000000 f7e52000 f7e814f4 
       f7e814f4 f7dcd668 00000246 f7dcd668 f7dcd660 00000000 00000000 c013f775 
       00000000 f7e81390 c0142310 f7dcd668 f7dcd668 f7dcd660 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kacpi_notify  S c0be6180     0   252      2
       f7e81970 00000046 c0be6180 c0be6180 3bd8d132 00000000 f7dc4000 f7e81ad4 
       f7e81ad4 f7dcd788 00000246 f7dcd788 f7dcd780 00000000 00000000 c013f775 
       00000000 f7e81970 c0142310 f7dcd788 f7dcd788 f7dcd780 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
cqueue/0      S c0be6180     0   361      2
       f7e75350 00000046 c0be6180 c0be6180 7a549191 00000000 f7c74000 f7e754b4 
       f7e754b4 f7c90de8 00000246 f7c90de8 f7c90de0 00000000 00000000 c013f775 
       00000000 f7e75350 c0142310 f7c90de8 f7c90de8 f7c90de0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ata/0         S f75b8074     0   367      2
       f7e74d70 00000046 f75b8000 f75b8074 20637bb4 00000006 f7e46000 f7e74ed4 
       f7e74ed4 f7c90b28 00000246 f7c90b28 f7c90b20 00000000 00000000 c013f775 
       00000000 f7e74d70 c0142310 f7c90b28 f7c90b28 f7c90b20 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ata_aux       S c0be6180     0   368      2
       f7e741b0 00000046 c0be6180 c0be6180 7d6a8659 00000000 f7e48000 f7e74314 
       f7e74314 f7e44948 00000246 f7e44948 f7e44940 00000000 00000000 c013f775 
       00000000 f7e741b0 c0142310 f7e44948 f7e44948 f7e44940 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ksuspend_usbd S 00000000     0   369      2
       f7e74790 00000046 f75d0ecc 00000000 05dd695f 00000007 f7c88000 f7e748f4 
       f7e748f4 f7e448e8 00000246 f7e448e8 f7e448e0 00000000 00000000 c013f775 
       00000000 f7e74790 c0142310 f7e448e8 f7e448e8 f7e448e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
khubd         S 00000002     0   375      2
       f7e69310 00000046 00000000 00000002 74daeff2 00000006 f7e94000 f7e69474 
       f7e69474 c0c4d304 00000246 c0c4d2fc 00000000 00000000 f75cff00 c07079f4 
       f7e94000 f7e69310 f75e1ca8 f75e1c00 f75e1c1c f75d0c00 0000000a f7e69310 
Call Trace:
 [<c07079f4>] hub_thread+0xe4/0xfc0
 [<c012aa5d>] finish_task_switch+0x1d/0xa0
 [<c097b941>] schedule+0x1b1/0x410
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c0707910>] hub_thread+0x0/0xfc0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kseriod       S c04de4e0     0   378      2
       f7e68d30 00000046 c0c668a8 c04de4e0 4972e07b 00000007 f7c8a000 f7e68e94 
       f7e68e94 c0c62858 00000246 c0c62850 f75eb5c0 f7c8bfb4 f75f1ee0 c077b7c5 
       00000246 00000000 f7e68d30 c0142310 c0c62858 c0c62858 00000000 c077b6d0 
Call Trace:
 [<c04de4e0>] __driver_attach+0x0/0x80
 [<c077b7c5>] serio_thread+0xf5/0x3d0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c077b6d0>] serio_thread+0x0/0x3d0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kgameportd    S f75ef940     0   380      2
       f7e68750 00000046 c04de07a f75ef940 2efb21b9 00000007 f7e90000 f7e688b4 
       f7e688b4 c0c62d4c 00000246 f7e91fc0 f75ebda0 00000246 fffff185 c077e4b5 
       f75ebda0 00000043 00000ebe 000001f4 00000000 f7e68750 c0142310 c0c62d4c 
Call Trace:
 [<c04de07a>] bus_add_driver+0x1aa/0x210
 [<c077e4b5>] gameport_thread+0xe5/0x4d0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c077e3d0>] gameport_thread+0x0/0x4d0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kmmcd         S c0be6180     0   394      2
       f7e698f0 00000046 c0be6180 c0be6180 8ac810cc 00000000 f7e96000 f7e69a54 
       f7e69a54 f7e44208 00000246 f7e44208 f7e44200 00000000 00000000 c013f775 
       00000000 f7e698f0 c0142310 f7e44208 f7e44208 f7e44200 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
pdflush       S f7e5ccf0     0   431      2
       f7e5ccf0 00000046 ffffffff f7e5ccf0 e44736cd 00000000 f7e92000 f7e5ce54 
       f7e5ce54 c0d0e280 c012b39b f7e93fc8 c016a070 00000000 00000000 c016a12a 
       f7e5ccf0 00000000 00000296 c0bf1214 f7cedfc8 fffedeca 00000000 c0142014 
Call Trace:
 [<c012b39b>] set_user_nice+0x9b/0x130
 [<c016a070>] pdflush+0x0/0x210
 [<c016a12a>] pdflush+0xba/0x210
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
pdflush       S f7cedfa8     0   432      2
       f7e80db0 00000046 00000000 f7cedfa8 661f080d 00000014 f7cec000 f7e80f14 
       f7e80f14 00000000 00000025 f7cedfc8 c016a070 00000000 00000000 c016a12a 
       f7e80db0 00000000 00000000 f7e93fc8 c0bf1214 ffff2c5c 00000000 c0142014 
Call Trace:
 [<c016a070>] pdflush+0x0/0x210
 [<c016a12a>] pdflush+0xba/0x210
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kswapd0       S f7ceff6b     0   433      2
       f7e5c710 00000046 00000003 f7ceff6b e54e8190 00000000 f7cee000 f7e5c874 
       f7e5c874 c0bf11a8 00000246 c0bf06e0 c016d690 00000000 00000000 c016dad2 
       f7ceff74 c0bf11a8 00000000 c0d0e2b8 f7e5c738 e54e75e4 00000000 f7e5c710 
Call Trace:
 [<c016d690>] kswapd+0x0/0x470
 [<c016dad2>] kswapd+0x442/0x470
 [<c012aa5d>] finish_task_switch+0x1d/0xa0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c016d690>] kswapd+0x0/0x470
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
aio/0         S c0be6180     0   434      2
       f7e5c130 00000046 c0be6180 c0be6180 ebfa3b1f 00000000 f7d6e000 f7e5c294 
       f7e5c294 f7ce95e8 00000246 f7ce95e8 f7ce95e0 00000000 00000000 c013f775 
       00000000 f7e5c130 c0142310 f7ce95e8 f7ce95e8 f7ce95e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
jfsIO         S f7e500f0     0   443      2
       f7e500f0 00000046 00000000 f7e500f0 19ffb339 00000001 f7410000 f7e50254 
       f7e50254 f7410000 f7e50254 00000000 f7410000 00000000 00000000 c029f10b 
       00000000 c029f050 c0142014 c0141fc0 00000000 c0115ea7 f7c41f54 00000000 
Call Trace:
 [<c029f10b>] jfsIOWait+0xbb/0xe0
 [<c029f050>] jfsIOWait+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
jfsCommit     S c0be6180     0   444      2
       f7e75930 00000046 c0d0e2b8 c0be6180 19ffd62d 00000001 f7412000 f7e75a94 
       f7e75a94 c0bf5cfc 00000046 00000000 c02a2950 00000000 00000286 c02a2c3e 
       00000000 f7e75930 c012b580 c0bf5cfc c0bf5cfc 00000000 c02a2950 00000000 
Call Trace:
 [<c02a2950>] jfs_lazycommit+0x0/0x390
 [<c02a2c3e>] jfs_lazycommit+0x2ee/0x390
 [<c012b580>] default_wake_function+0x0/0x10
 [<c02a2950>] jfs_lazycommit+0x0/0x390
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
jfsSync       S c0be6180     0   445      2
       f7e5d8b0 00000046 c012aa5d c0be6180 1a80d67a 00000001 f7414000 f7e5da14 
       f7e5da14 00000000 19ffee97 00000000 c02a2ec0 00000000 f7415fc4 c02a30bc 
       00000286 00000000 c02a2ec0 00000000 00000000 c0142014 c0141fc0 00000000 
Call Trace:
 [<c012aa5d>] finish_task_switch+0x1d/0xa0
 [<c02a2ec0>] jfs_sync+0x0/0x230
 [<c02a30bc>] jfs_sync+0x1fc/0x230
 [<c02a2ec0>] jfs_sync+0x0/0x230
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
xfslogd/0     S c0be6180     0   446      2
       f7e506d0 00000046 c0be6180 c0be6180 1b4ca116 00000001 f740e000 f7e50834 
       f7e50834 f7ce9c48 00000246 f7ce9c48 f7ce9c40 00000000 00000000 c013f775 
       00000000 f7e506d0 c0142310 f7ce9c48 f7ce9c48 f7ce9c40 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
xfsdatad/0    S c0be6180     0   447      2
       f7e5d2d0 00000046 c0be6180 c0be6180 1b4d5be9 00000001 f7416000 f7e5d434 
       f7e5d434 f7ce9be8 00000246 f7ce9be8 f7ce9be0 00000000 00000000 c013f775 
       00000000 f7e5d2d0 c0142310 f7ce9be8 f7ce9be8 f7ce9be0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
xfs_mru_cache S c0be6180     0   448      2
       f7e68170 00000046 c0be6180 c0be6180 1bc62794 00000001 f7418000 f7e682d4 
       f7e682d4 f7ce9b88 00000246 f7ce9b88 f7ce9b80 00000000 00000000 c013f775 
       00000000 f7e68170 c0142310 f7ce9b88 f7ce9b88 f7ce9b80 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ocfs2_wq      S c0be6180     0   449      2
       f7e50cb0 00000046 c0be6180 c0be6180 1dc949b2 00000001 f741a000 f7e50e14 
       f7e50e14 f7ce9b08 00000246 f7ce9b08 f7ce9b00 00000000 00000000 c013f775 
       00000000 f7e50cb0 c0142310 f7ce9b08 f7ce9b08 f7ce9b00 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
user_dlm      S c0be6180     0   451      2
       f7c6e710 00000046 c0be6180 c0be6180 2105f526 00000001 f741e000 f7c6e874 
       f7c6e874 f7ce9968 00000246 f7ce9968 f7ce9960 00000000 00000000 c013f775 
       00000000 f7c6e710 c0142310 f7ce9968 f7ce9968 f7ce9960 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
gfs2_scand    S c0137e4c     0   452      2
       f7e51290 00000046 c0e0f300 c0137e4c 661ef3f3 00000014 f741c000 f7e513f4 
       f7e513f4 00000286 00000286 00008000 ffff313e 00000000 00000000 c097c07f 
       c0bf11e0 c0e0fc90 ffff313e c01383b0 f7e51290 c0e0f300 00008000 c037ea60 
Call Trace:
 [<c0137e4c>] lock_timer_base+0x2c/0x70
 [<c097c07f>] schedule_timeout+0x3f/0xb0
 [<c01383b0>] process_timeout+0x0/0x10
 [<c037ea60>] gfs2_scand+0x0/0x80
 [<c037eab5>] gfs2_scand+0x55/0x80
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
glock_workque S c0be6180     0   453      2
       f7c6ecf0 00000046 c0be6180 c0be6180 228fd517 00000001 f7420000 f7c6ee54 
       f7c6ee54 f74018c8 00000246 f74018c8 f74018c0 00000000 00000000 c013f775 
       00000000 f7c6ecf0 c0142310 f74018c8 f74018c8 f74018c0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
fakephp       S c0be6180     0   456      2
       f7c6f2d0 00000046 c0be6180 c0be6180 5ad4db96 00000001 f7422000 f7c6f434 
       f7c6f434 f74015e8 00000246 f74015e8 f74015e0 00000000 00000000 c013f775 
       00000000 f7c6f2d0 c0142310 f74015e8 f74015e8 f74015e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
bond0         S c0be6180     0  1482      2
       f7c4a650 00000046 c0be6180 c0be6180 8efd0239 00000002 f757c000 f7c4a7b4 
       f7c4a7b4 f7560e68 00000246 f7560e68 f7560e60 00000000 00000000 c013f775 
       00000000 f7c4a650 c0142310 f7560e68 f7560e68 f7560e60 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
irda_sir_wq   S c0be6180     0  1545      2
       f7c4a070 00000046 c0be6180 c0be6180 05fb22ca 00000003 f7580000 f7c4a1d4 
       f7c4a1d4 f7568b88 00000246 f7568b88 f7568b80 00000000 00000000 c013f775 
       00000000 f7c4a070 c0142310 f7568b88 f7568b88 f7568b80 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
netxen        S c0be6180     0  1547      2
       f7c57250 00000046 c0be6180 c0be6180 a66b10a6 00000005 f7582000 f7c573b4 
       f7c573b4 f7568b08 00000246 f7568b08 f7568b00 00000000 00000000 c013f775 
       00000000 f7c57250 c0142310 f7568b08 f7568b08 f7568b00 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
scsi_tgtd/0   S c0be6180     0  1551      2
       f7c57830 00000046 c0be6180 c0be6180 aa371508 00000005 f7584000 f7c57994 
       f7c57994 f75689c8 00000246 f75689c8 f75689c0 00000000 00000000 c013f775 
       00000000 f7c57830 c0142310 f75689c8 f75689c8 f75689c0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
iscsi_eh      S c0be6180     0  1563      2
       f7c560b0 00000046 c0be6180 c0be6180 ae21e0c4 00000005 f75b6000 f7c56214 
       f7c56214 f75a45a8 00000246 f75a45a8 f75a45a0 00000000 00000000 c013f775 
       00000000 f7c560b0 c0142310 f75a45a8 f75a45a8 f75a45a0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
scsi_eh_0     S f75bcc08     0  1609      2
       f7c63870 00000046 f75bcc08 f75bcc08 1fb1c406 00000006 f75d8000 f7c639d4 
       f7c639d4 00000000 00000000 00000246 f756f000 00000000 00000000 c05c5828 
       f756f044 00000005 f75d8000 f7c639d4 f7c639d4 f7c41e00 00000286 f756f000 
Call Trace:
 [<c05c5828>] scsi_error_handler+0x48/0x330
 [<c05c57e0>] scsi_error_handler+0x0/0x330
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
scsi_eh_1     S f75bc808     0  1611      2
       f7c63290 00000046 f75bc808 f75bc808 21b24aff 00000006 f75dc000 f7c633f4 
       f7c633f4 00000000 00000000 00000246 f756f400 00000000 00000000 c05c5828 
       f756f444 00000005 f75dc000 f7c633f4 f7c633f4 f7c41e00 00000286 f756f400 
Call Trace:
 [<c05c5828>] scsi_error_handler+0x48/0x330
 [<c05c57e0>] scsi_error_handler+0x0/0x330
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
appledisplay  S c0be6180     0  1731      2
       f7c9ad30 00000046 c0be6180 c0be6180 a81b2a25 00000006 f7602000 f7c9ae94 
       f7c9ae94 f75e4d68 00000246 f75e4d68 f75e4d60 00000000 00000000 c013f775 
       00000000 f7c9ad30 c0142310 f75e4d68 f75e4d68 f75e4d60 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
w1_control    S c0137e4c     0  1812      2
       f7c626d0 00000046 c0e0f300 c0137e4c f7605f90 f7605f90 f7604000 f7c62834 
       f7c62834 00000286 00000286 00000000 ffff2fa7 00000000 00000000 c097c07f 
       c0e0f840 c0e0f840 ffff2fa7 c01383b0 f7c626d0 c0e0f300 00000000 c0c67794 
Call Trace:
 [<c0137e4c>] lock_timer_base+0x2c/0x70
 [<c097c07f>] schedule_timeout+0x3f/0xb0
 [<c01383b0>] process_timeout+0x0/0x10
 [<c0138395>] msleep_interruptible+0x25/0x40
 [<c07a30c6>] w1_control+0x36/0x1d0
 [<c07a3090>] w1_control+0x0/0x1d0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kmemstick     S c0be6180     0  1818      2
       f7c620f0 00000046 c0be6180 c0be6180 042c5add 00000014 f7600000 f7c62254 
       f7c62254 f75f1d88 00000246 f75f1d88 f75f1d80 00000000 00000000 c013f775 
       00000000 f7c620f0 c0142310 f75f1d88 f75f1d88 f75f1d80 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ib_mcast      S c0be6180     0  1822      2
       f7c56c70 00000046 c0be6180 c0be6180 08b09b42 00000014 f75b4000 f7c56dd4 
       f7c56dd4 f75f1b88 00000246 f75f1b88 f75f1b80 00000000 00000000 c013f775 
       00000000 f7c56c70 c0142310 f75f1b88 f75f1b88 f75f1b80 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ib_cm/0       S c0be6180     0  1824      2
       f7c4ac30 00000046 c0be6180 c0be6180 09b4d5e3 00000014 f75da000 f7c4ad94 
       f7c4ad94 f7c5f8e8 00000246 f7c5f8e8 f7c5f8e0 00000000 00000000 c013f775 
       00000000 f7c4ac30 c0142310 f7c5f8e8 f7c5f8e8 f7c5f8e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
iw_cm_wq      S c0be6180     0  1825      2
       f7c56690 00000046 c0be6180 c0be6180 0ab83644 00000014 f75de000 f7c567f4 
       f7c567f4 f7c5f8a8 00000246 f7c5f8a8 f7c5f8a0 00000000 00000000 c013f775 
       00000000 f7c56690 c0142310 f7c5f8a8 f7c5f8a8 f7c5f8a0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ib_addr       S c0be6180     0  1826      2
       f7c62cb0 00000046 c0be6180 c0be6180 0b9ba1da 00000014 f7606000 f7c62e14 
       f7c62e14 f7c5f848 00000246 f7c5f848 f7c5f840 00000000 00000000 c013f775 
       00000000 f7c62cb0 c0142310 f7c5f848 f7c5f848 f7c5f840 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
rdma_cm       S c0be6180     0  1827      2
       f7c6f8b0 00000046 c0be6180 c0be6180 0c93b730 00000014 f7608000 f7c6fa14 
       f7c6fa14 f7c5f7e8 00000246 f7c5f7e8 f7c5f7e0 00000000 00000000 c013f775 
       00000000 f7c6f8b0 c0142310 f7c5f7e8 f7c5f7e8 f7c5f7e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
mthca_catas   S c0be6180     0  1831      2
       f7c9a170 00000046 c0be6180 c0be6180 11cbe792 00000014 f760c000 f7c9a2d4 
       f7c9a2d4 f7c5f668 00000246 f7c5f668 f7c5f660 00000000 00000000 c013f775 
       00000000 f7c9a170 c0142310 f7c5f668 f7c5f668 f7c5f660 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
nesewq        S c0be6180     0  1833      2
       f7c9a750 00000046 c0be6180 c0be6180 12d7a8d8 00000014 f760e000 f7c9a8b4 
       f7c9a8b4 f7c5f648 00000246 f7c5f648 f7c5f640 00000000 00000000 c013f775 
       00000000 f7c9a750 c0142310 f7c5f648 f7c5f648 f7c5f640 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
nesdwq        S c0be6180     0  1834      2
       f7c6e130 00000046 c0be6180 c0be6180 12d8213b 00000014 f760a000 f7c6e294 
       f7c6e294 f7c5f568 00000246 f7c5f568 f7c5f560 00000000 00000000 c013f775 
       00000000 f7c6e130 c0142310 f7c5f568 f7c5f568 f7c5f560 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
ipoib         S c0be6180     0  1836      2
       f7c9b310 00000046 c0be6180 c0be6180 13ecf911 00000014 f7610000 f7c9b474 
       f7c9b474 f7c5f4e8 00000246 f7c5f4e8 f7c5f4e0 00000000 00000000 c013f775 
       00000000 f7c9b310 c0142310 f7c5f4e8 f7c5f4e8 f7c5f4e0 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kpktgend_0    S c0137e4c     0  1848      2
       f7e801f0 00000046 c0e0f300 c0137e4c 16c3889c 00000015 f7616000 f7e80354 
       f7e80354 00000286 00000286 f75d0400 ffff2f4d 00000000 00000000 c097c07f 
       c0e0f570 c0e0f570 ffff2f4d c01383b0 f7e801f0 c0e0f300 f75d0400 c0843570 
Call Trace:
 [<c0137e4c>] lock_timer_base+0x2c/0x70
 [<c097c07f>] schedule_timeout+0x3f/0xb0
 [<c01383b0>] process_timeout+0x0/0x10
 [<c0843570>] pktgen_thread_worker+0x0/0x1060
 [<c08442e3>] pktgen_thread_worker+0xd73/0x1060
 [<c012aa5d>] finish_task_switch+0x1d/0xa0
 [<c097b941>] schedule+0x1b1/0x410
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c0843570>] pktgen_thread_worker+0x0/0x1060
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
rpciod/0      S c0be6180     0  1883      2
       f7c4b7f0 00000046 c0be6180 c0be6180 422529b7 00000014 f7618000 f7c4b954 
       f7c4b954 f7621708 00000246 f7621708 f7621700 00000000 00000000 c013f775 
       00000000 f7c4b7f0 c0142310 f7621708 f7621708 f7621700 c013f6c0 00000000 
Call Trace:
 [<c013f775>] worker_thread+0xb5/0xe0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c013f6c0>] worker_thread+0x0/0xe0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
kjournald     S 00000001     0  1887      2
       f7c4b210 00000046 00000000 00000001 98990d45 00000014 f7718000 f7c4b374 
       f7c4b374 f76271d0 00000246 f7627180 f7627244 f76271c0 f76271d0 c021d4c4 
       00000000 f7c4b210 c0142310 f76271d0 f76271d0 f7627180 c021d150 00000000 
Call Trace:
 [<c021d4c4>] kjournald+0x374/0x3b0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c021d150>] kjournald+0x0/0x3b0
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
init          S f7e51870     0  1892      1
       f761d9b0 00000082 00000000 f7e51870 00000000 00000000 f761e000 f761db14 
       f761db14 00000000 c039b8ec f761d9a8 00000000 00000001 00000004 c0131768 
       f7c5a284 00000000 00000000 f761daa8 f7c5a280 00000000 f761d9b0 f761d9b0 
Call Trace:
 [<c039b8ec>] security_task_wait+0xc/0x10
 [<c0131768>] do_wait+0x4e8/0xb60
 [<c0139196>] do_sigaction+0x96/0x160
 [<c012b580>] default_wake_function+0x0/0x10
 [<c0131e36>] sys_wait4+0x56/0xc0
 [<c0131eb6>] sys_waitpid+0x16/0x20
 [<c0115a5f>] sysenter_past_esp+0x5f/0x90
 =======================
rc.sysinit    S 00000000     0  1893   1892
       f7e51870 00000082 00000002 00000000 000284d2 c0bf1164 f771a000 f7e519d4 
       f7e519d4 f770ba00 00000246 f770ba00 00000001 f771bf68 00000080 c0188d4d 
       00000000 f7e51870 c0142310 f770ba00 f770ba00 f7720c40 00000001 c01892eb 
Call Trace:
 [<c0188d4d>] pipe_wait+0x4d/0x70
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c01892eb>] pipe_read+0xdb/0x420
 [<c014009c>] alloc_pid+0x2ec/0x370
 [<c0182a10>] do_sync_read+0xd0/0x110
 [<c0119c17>] native_sched_clock+0x77/0xb0
 [<c0142310>] autoremove_wake_function+0x0/0x30
 [<c0182940>] do_sync_read+0x0/0x110
 [<c0183163>] vfs_read+0x73/0xe0
 [<c0183567>] sys_read+0x37/0x80
 [<c0115a5f>] sysenter_past_esp+0x5f/0x90
 =======================
kauditd       S 00000001     0  1921      2
       f761c230 00000046 00000000 00000001 194b2ff0 00000015 f7744000 f761c394 
       f761c394 c0befaa0 00000246 00000000 c01516a0 00000000 00000000 c01517e7 
       00000000 f761c230 c012b580 c0befaa0 c0befaa0 00000000 c01516a0 c0142014 
Call Trace:
 [<c01516a0>] kauditd_thread+0x0/0x170
 [<c01517e7>] kauditd_thread+0x147/0x170
 [<c012b580>] default_wake_function+0x0/0x10
 [<c01516a0>] kauditd_thread+0x0/0x170
 [<c0142014>] kthread+0x54/0x70
 [<c0141fc0>] kthread+0x0/0x70
 [<c0115ea7>] kernel_thread_helper+0x7/0x10
 =======================
rc.sysinit    D f75bcc24     0  1922   1893
       f761c810 00000086 f75bcd38 f75bcc24 1954bff5 00000015 f7746000 f761c974 
       f761c974 f7c17698 c180e7a8 f7747cc4 00000000 f7747ccc c180e7a8 c097bff7 
       c01a3acb c097c27d c01a3aa0 f7872a90 00000002 c01a3aa0 f7747e48 c097c2fc 
Call Trace:
 [<c097bff7>] io_schedule+0x37/0x70
 [<c01a3acb>] sync_buffer+0x2b/0x30
 [<c097c27d>] __wait_on_bit+0x4d/0x80
 [<c01a3aa0>] sync_buffer+0x0/0x30
 [<c01a3aa0>] sync_buffer+0x0/0x30
 [<c097c2fc>] out_of_line_wait_on_bit+0x4c/0x60
 [<c0142340>] wake_bit_function+0x0/0x40
 [<c01a3a51>] __wait_on_buffer+0x21/0x30
 [<c0209915>] ext3_bread+0x55/0x70
 [<c020cff8>] ext3_find_entry+0x258/0x660
 [<c03a0026>] avc_has_perm+0x46/0x50
 [<c03a0d14>] inode_has_perm+0x44/0x80
 [<c020de69>] ext3_lookup+0x29/0xa0
 [<c0189f90>] do_lookup+0x130/0x180
 [<c018b540>] __link_path_walk+0x340/0xd50
 [<c03a0d14>] inode_has_perm+0x44/0x80
 [<c018bf8a>] link_path_walk+0x3a/0xa0
 [<c016feb4>] __do_fault+0x1a4/0x3d0
 [<c018c1b7>] do_path_lookup+0x77/0x210
 [<c018cb57>] __user_walk_fd+0x27/0x40
 [<c01860d5>] vfs_stat_fd+0x15/0x40
 [<c016feb4>] __do_fault+0x1a4/0x3d0
 [<c01861ef>] sys_stat64+0xf/0x30
 [<c0125a5d>] do_page_fault+0x2ad/0x670
 [<c03db6cc>] trace_hardirqs_on_thunk+0xc/0x10
 [<c0115a5f>] sysenter_past_esp+0x5f/0x90
 =======================

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config.hang"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc4
# Thu Mar  6 08:53:27 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
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
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_VMI is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
CONFIG_MWINCHIP2=y
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_OOSTORE=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=y
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

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
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
# CONFIG_NET_SCHED is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
# CONFIG_ACTISYS_DONGLE is not set
CONFIG_TEKRAM_DONGLE=y
# CONFIG_TOIM3232_DONGLE is not set
# CONFIG_LITELINK_DONGLE is not set
# CONFIG_MA600_DONGLE is not set
# CONFIG_GIRBIL_DONGLE is not set
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=y
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
# CONFIG_IEEE80211_CRYPT_TKIP is not set
CONFIG_IEEE80211_SOFTMAC=y
# CONFIG_IEEE80211_SOFTMAC_DEBUG is not set
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
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_IN2000=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_SRP=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
CONFIG_SATA_SIL24=y
CONFIG_SATA_SIS=y
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_LEGACY=y
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_QDI=y
CONFIG_PATA_RADISYS=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
CONFIG_ELPLUS=y
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
CONFIG_3C515=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
CONFIG_DEPCA=y
CONFIG_HP100=y
CONFIG_NET_ISA=y
CONFIG_E2100=y
# CONFIG_EWRK3 is not set
CONFIG_EEXPRESS=y
CONFIG_EEXPRESS_PRO=y
CONFIG_HPLAN_PLUS=y
CONFIG_HPLAN=y
CONFIG_LP486E=y
# CONFIG_ETH16I is not set
# CONFIG_NE2000 is not set
# CONFIG_ZNET is not set
# CONFIG_SEEQ8005 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_PCNET32_NAPI is not set
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_ADAPTEC_STARFIRE_NAPI=y
# CONFIG_AC3200 is not set
CONFIG_APRICOT=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
CONFIG_LNE390=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_NE3210 is not set
CONFIG_ES3210=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_VIA_RHINE_NAPI is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
CONFIG_E1000_DISABLE_PACKET_SPLIT=y
# CONFIG_E1000E_ENABLED is not set
CONFIG_IP1000=y
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_R8169_NAPI=y
CONFIG_R8169_VLAN=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
CONFIG_NETXEN_NIC=y
CONFIG_NIU=y
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=y
CONFIG_TR=y
CONFIG_IBMTR=y
CONFIG_IBMOL=y
CONFIG_IBMLS=y
# CONFIG_3C359 is not set
CONFIG_TMS380TR=y
# CONFIG_TMSPCI is not set
# CONFIG_SKISA is not set
CONFIG_PROTEON=y
CONFIG_ABYSS=y
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
CONFIG_ESPSERIAL=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_ISI=y
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=y
CONFIG_SPECIALIX=y
# CONFIG_SPECIALIX_RTSCTS is not set
CONFIG_SX=y
CONFIG_RIO=y
# CONFIG_RIO_OLDPCI is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

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
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y

#
# You are using the RTC framework, not the legacy CMOS RTC driver
#
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_I810=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_PROSAVAGE=y
CONFIG_I2C_SAVAGE4=y
CONFIG_I2C_SIMTEC=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y
# CONFIG_I2C_VOODOO3 is not set
CONFIG_I2C_PCA_ISA=y

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=y
CONFIG_SENSORS_PCF8574=y
CONFIG_PCF8575=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_TPS65010=y
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_I2C_DEBUG_CHIP=y

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=y

#
# Multimedia devices
#
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I830=y
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_UVESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_HECUBA is not set
CONFIG_FB_HGA=y
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
# CONFIG_FB_I810_I2C is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SM501 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y

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
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
# CONFIG_SND is not set

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_TRIDENT is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_R8A66597_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
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
CONFIG_USB_ADUTUX=y
CONFIG_USB_AUERSWALD=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=y
# CONFIG_USB_GADGET_PXA2XX is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_GADGETFS=y
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set

#
# MMC/SD Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_CXGB3 is not set
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_SECURITY=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_NOLOCK is not set
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
# CONFIG_NFSD_V4 is not set
# CONFIG_NFSD_TCP is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_CODA_FS_OLD_API=y
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_LATENCYTOP is not set
CONFIG_HAVE_FTRACE=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
CONFIG_SAMPLE_KOBJECT=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DOUBLEFAULT=y
# CONFIG_SYSPROF is not set
# CONFIG_MMIOTRACE_HOOKS is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--AqsLC8rIMeq19msA--
