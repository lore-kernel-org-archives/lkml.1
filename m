Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZGFQZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZGFQZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZGFQYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:24:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:59570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751225AbZGFQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:24:48 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+PfooDb0mPvj3BpukXos2ouI0NPXbk1/M0bdTPf0
	d1wHITV5vCd2M0
Message-ID: <4A52254F.8080103@fisher-privat.net>
Date: Mon, 06 Jul 2009 18:24:47 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
References: <4A5210A2.2080301@fisher-privat.net>
In-Reply-To: <4A5210A2.2080301@fisher-privat.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Ingo, Richard.

I'm getting "Corrupted low memory" trace with my Intel DG45ID board 
after resume. This board  has different dmi-bios-vendor... so probably 
it will be nice to have it in your patch.

Here is trace after resume:
===============================================

[  600.816088] Corrupted low memory at ffff880000004200 (4200 phys) = 
00420301
[  600.816093] ------------[ cut here ]------------
[  600.816100] WARNING: at arch/x86/kernel/check.c:134 
check_for_bios_corruption+0xe4/0xf0()
[  600.816102] Hardware name:
[  600.816103] Memory corruption detected in low memory
[  600.816105] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat 
binfmt_misc kvm_intel kvm snd_hda_codec_intelhdmi snd_hda_codec_idt 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd psmouse soundcore e1000e serio_raw 
iTCO_wdt iTCO_vendor_support snd_page_alloc
[  600.816129] Pid: 9, comm: events/0 Tainted: G        W 
2.6.31-rc1-25446-g1ae8c0a #1
[  600.816131] Call Trace:
[  600.816136]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  600.816139]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  600.816142]  [<ffffffff8102aff4>] check_for_bios_corruption+0xe4/0xf0
[  600.816145]  [<ffffffff8102b000>] ? check_corruption+0x0/0x30
[  600.816148]  [<ffffffff8102b009>] check_corruption+0x9/0x30
[  600.816152]  [<ffffffff8105e4d4>] worker_thread+0x144/0x260
[  600.816155]  [<ffffffff810635c0>] ? autoremove_wake_function+0x0/0x40
[  600.816158]  [<ffffffff8105e390>] ? worker_thread+0x0/0x260
[  600.816161]  [<ffffffff810631e6>] kthread+0x96/0xa0
[  600.816165]  [<ffffffff8100c69a>] child_rip+0xa/0x20
[  600.816168]  [<ffffffff81063150>] ? kthread+0x0/0xa0
[  600.816171]  [<ffffffff8100c690>] ? child_rip+0x0/0x20
[  600.816173] ---[ end trace 03ff161c20a96dae ]---

=====================================================================

result of "dmidecode -s bios-vendor" is "Intel Corp."


here is patch against latest git. It's working fine with my board.

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..89d00e2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -672,6 +672,13 @@ static struct dmi_system_id __initdata 
bad_bios_dmi_table[] = {
                         DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
                 },
         },
+        {
+                .callback = dmi_low_memory_corruption,
+                .ident = "Intel BIOS",
+                .matches = {
+                        DMI_MATCH(DMI_BIOS_VENDOR, "Intel Corp."),
+                },
+        },
  #endif
         {}
  };


In attachment you can see dmesg before bios patch and after.



[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc1-25446-g1ae8c0a-dirty (lex@zwerg) 
(gcc version 4.4.0 (Ubuntu 4.4.0-8ubuntu2) ) #2 SMP Mon Jul 6 06:30:36 
CEST 2009
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz 
root=UUID=0db19d83-143f-4a8d-8f62-0775623b62b1 ro quiet splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd90e000 (usable)
[    0.000000]  BIOS-e820: 00000000bd90e000 - 00000000bd930000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd930000 - 00000000bda48000 (reserved)
[    0.000000]  BIOS-e820: 00000000bda48000 - 00000000bda5c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bda5c000 - 00000000bdb5b000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb5b000 - 00000000bdb5c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb5c000 - 00000000bdb64000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdb64000 - 00000000bdb6e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb6e000 - 00000000bdb8c000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb8c000 - 00000000bdb92000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb92000 - 00000000bdd00000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0BDD00000 mask FFFF00000 write-through
[    0.000000]   2 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   3 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 13C000000 mask FFC000000 uncachable
[    0.000000] last_pfn = 0xbdd00 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009e800 (usable)
[    0.000000]  modified: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bd90e000 (usable)
[    0.000000]  modified: 00000000bd90e000 - 00000000bd930000 (ACPI NVS)
[    0.000000]  modified: 00000000bd930000 - 00000000bda48000 (reserved)
[    0.000000]  modified: 00000000bda48000 - 00000000bda5c000 (ACPI NVS)
[    0.000000]  modified: 00000000bda5c000 - 00000000bdb5b000 (reserved)
[    0.000000]  modified: 00000000bdb5b000 - 00000000bdb5c000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb5c000 - 00000000bdb64000 (ACPI data)
[    0.000000]  modified: 00000000bdb64000 - 00000000bdb6e000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb6e000 - 00000000bdb8c000 (reserved)
[    0.000000]  modified: 00000000bdb8c000 - 00000000bdb92000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb92000 - 00000000bdd00000 (usable)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdd00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000]  00bdc00000 - 00bdd00000 page 4k
[    0.000000] kernel direct mapping tables up to bdd00000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
[    0.000000] RAMDISK: 37858000 - 37fefbe0
[    0.000000] ACPI: RSDP 00000000000f03c0 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000bdb62e18 0004C (v01 INTEL  DG45ID 
0000006B MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bdb61d98 000F4 (v04  INTEL    A M I 
06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two 
FACS tables! 20090521 tbfadt-370
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 
BDB65F40/00000000BDB6BE40, using 32 20090521 tbfadt-487
[    0.000000] ACPI: DSDT 00000000bdb5c018 0492F (v01 INTEL  DG45ID 
0000006B INTL 20051117)
[    0.000000] ACPI: FACS 00000000bdb65f40 00040
[    0.000000] ACPI: APIC 00000000bdb61f18 0006C (v02 INTEL  DG45ID 
0000006B MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000bdb6cd98 0003C (v01 INTEL  DG45ID 
0000006B MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000bdb6bc18 000A0 (v32 INTEL  DG45ID 
0000006B TFSM 000F4240)
[    0.000000] ACPI: HPET 00000000bdb6cd18 00038 (v01 INTEL  DG45ID 
0000006B AMI. 00000003)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> 
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000184ec48]    TEXT DATA BSS ==> 
[0001000000 - 000184ec48]
[    0.000000]   #3 [0037858000 - 0037fefbe0]          RAMDISK ==> 
[0037858000 - 0037fefbe0]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> 
[000009e800 - 0000100000]
[    0.000000]   #5 [000184f000 - 000184f1ec]              BRK ==> 
[000184f000 - 000184f1ec]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> 
[0000008000 - 000000b000]
[    0.000000]   #7 [000000b000 - 000000c000]          PGTABLE ==> 
[000000b000 - 000000c000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> 
[ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd90e
[    0.000000]     0: 0x000bdb92 -> 0x000bdd00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1022485
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3833 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 758452 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd90e000 - 
00000000bd930000
[    0.000000] PM: Registered nosave memory: 00000000bd930000 - 
00000000bda48000
[    0.000000] PM: Registered nosave memory: 00000000bda48000 - 
00000000bda5c000
[    0.000000] PM: Registered nosave memory: 00000000bda5c000 - 
00000000bdb5b000
[    0.000000] PM: Registered nosave memory: 00000000bdb5b000 - 
00000000bdb5c000
[    0.000000] PM: Registered nosave memory: 00000000bdb5c000 - 
00000000bdb64000
[    0.000000] PM: Registered nosave memory: 00000000bdb64000 - 
00000000bdb6e000
[    0.000000] PM: Registered nosave memory: 00000000bdb6e000 - 
00000000bdb8c000
[    0.000000] PM: Registered nosave memory: 00000000bdb8c000 - 
00000000bdb92000
[    0.000000] PM: Registered nosave memory: 00000000bdd00000 - 
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 
00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at bdd00000 (gap: 
bdd00000:4101c000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff880028022000, static 
data 82464 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1004685
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz 
root=UUID=0db19d83-143f-4a8d-8f62-0775623b62b1 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 3942820k/5177344k available (4825k kernel code, 
1087404k absent, 146184k reserved, 2464k data, 428k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2999.684 MHz processor.
[    0.001002] Console: colour VGA+ 80x25
[    0.001004] console [tty0] enabled
[    0.004000] allocated 41943040 bytes of page_cgroup
[    0.004000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for 
per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5999.36 BogoMIPS (lpj=11998736)
[    0.004000] Security Framework initialized
[    0.004000] Smack:  Initializing.
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: Core2 events, Intel PMU driver.
[    0.004000] ... version:                 2
[    0.004000] ... bit width:               40
[    0.004000] ... generic counters:        2
[    0.004000] ... value mask:              000000ffffffffff
[    0.004000] ... max period:              000000007fffffff
[    0.004000] ... fixed-purpose counters:  3
[    0.004000] ... counter mask:            0000000700000003
[    0.004000] ACPI: Core revision 20090521
[    0.005853] Setting APIC routing to flat
[    0.006172] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045868] CPU0: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[    0.048001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5999.22 
BogoMIPS (lpj=11998448)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.132656] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[    0.132663] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.136018] Brought up 2 CPUs
[    0.136020] Total of 2 processors activated (11998.59 BogoMIPS).
[    0.136062] CPU0 attaching sched-domain:
[    0.136064]  domain 0: span 0-1 level MC
[    0.136066]   groups: 0 1
[    0.136069] CPU1 attaching sched-domain:
[    0.136070]  domain 0: span 0-1 level MC
[    0.136071]   groups: 1 0
[    0.136125] regulator: core version 0.5
[    0.136125] Time:  4:33:17  Date: 07/06/09
[    0.136125] NET: Registered protocol family 16
[    0.136125] ACPI: bus type pci registered
[    0.136125] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.136125] PCI: Not using MMCONFIG.
[    0.136125] PCI: Using configuration type 1 for base access
[    0.136125] bio: create slab <bio-0> at 0
[    0.136401] ACPI: EC: Look up EC in DSDT
[    0.142862] ACPI: BIOS _OSI(Linux) query ignored
[    0.144357] ACPI: Interpreter enabled
[    0.144359] ACPI: (supports S0 S1 S3 S4 S5)
[    0.144374] ACPI: Using IOAPIC for interrupt routing
[    0.144462] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.144513] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.146905] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.149941] ACPI: No dock devices found.
[    0.149941] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.149941] pci 0000:00:02.0: reg 10 64bit mmio: [0xd0000000-0xd03fffff]
[    0.149941] pci 0000:00:02.0: reg 18 64bit mmio: [0xc0000000-0xcfffffff]
[    0.149941] pci 0000:00:02.0: reg 20 io port: [0xf1c0-0xf1c7]
[    0.149941] pci 0000:00:02.1: reg 10 64bit mmio: [0xd0400000-0xd04fffff]
[    0.149941] pci 0000:00:03.0: reg 10 64bit mmio: [0xd0526100-0xd052610f]
[    0.149941] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.149941] pci 0000:00:03.0: PME# disabled
[    0.149941] pci 0000:00:19.0: reg 10 32bit mmio: [0xd0500000-0xd051ffff]
[    0.149941] pci 0000:00:19.0: reg 14 32bit mmio: [0xd0524000-0xd0524fff]
[    0.149941] pci 0000:00:19.0: reg 18 io port: [0xf100-0xf11f]
[    0.149941] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.149941] pci 0000:00:19.0: PME# disabled
[    0.149941] pci 0000:00:1a.0: reg 20 io port: [0xf0e0-0xf0ff]
[    0.149941] pci 0000:00:1a.1: reg 20 io port: [0xf0c0-0xf0df]
[    0.149941] pci 0000:00:1a.2: reg 20 io port: [0xf0a0-0xf0bf]
[    0.149941] pci 0000:00:1a.7: reg 10 32bit mmio: [0xd0525c00-0xd0525fff]
[    0.149941] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.149941] pci 0000:00:1a.7: PME# disabled
[    0.149941] pci 0000:00:1b.0: reg 10 64bit mmio: [0xd0520000-0xd0523fff]
[    0.149941] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.149941] pci 0000:00:1b.0: PME# disabled
[    0.152033] pci 0000:00:1d.0: reg 20 io port: [0xf080-0xf09f]
[    0.152088] pci 0000:00:1d.1: reg 20 io port: [0xf060-0xf07f]
[    0.152142] pci 0000:00:1d.2: reg 20 io port: [0xf040-0xf05f]
[    0.152200] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0525800-0xd0525bff]
[    0.152244] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.152248] pci 0000:00:1d.7: PME# disabled
[    0.152345] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO
[    0.152348] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 
GPIO
[    0.152351] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0a00 (mask 00ff)
[    0.152404] pci 0000:00:1f.2: reg 10 io port: [0xf1b0-0xf1b7]
[    0.152408] pci 0000:00:1f.2: reg 14 io port: [0xf1a0-0xf1a3]
[    0.152412] pci 0000:00:1f.2: reg 18 io port: [0xf190-0xf197]
[    0.152417] pci 0000:00:1f.2: reg 1c io port: [0xf180-0xf183]
[    0.152421] pci 0000:00:1f.2: reg 20 io port: [0xf020-0xf03f]
[    0.152425] pci 0000:00:1f.2: reg 24 32bit mmio: [0xd0525000-0xd05257ff]
[    0.152449] pci 0000:00:1f.2: PME# supported from D3hot
[    0.152451] pci 0000:00:1f.2: PME# disabled
[    0.152473] pci 0000:00:1f.3: reg 10 64bit mmio: [0xd0526000-0xd05260ff]
[    0.152483] pci 0000:00:1f.3: reg 20 io port: [0xf000-0xf01f]
[    0.152518] pci 0000:00:1f.5: reg 10 io port: [0xf170-0xf177]
[    0.152522] pci 0000:00:1f.5: reg 14 io port: [0xf160-0xf163]
[    0.152526] pci 0000:00:1f.5: reg 18 io port: [0xf150-0xf157]
[    0.152531] pci 0000:00:1f.5: reg 1c io port: [0xf140-0xf143]
[    0.152535] pci 0000:00:1f.5: reg 20 io port: [0xf130-0xf13f]
[    0.152539] pci 0000:00:1f.5: reg 24 io port: [0xf120-0xf12f]
[    0.152601] pci 0000:00:1e.0: transparent bridge
[    0.152613] pci_bus 0000:00: on NUMA node 0
[    0.152616] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.152705] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.156178] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.156178] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0
[    0.156191] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 
14 15)
[    0.156260] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 
14 15)
[    0.156330] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.156399] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 
14 15)
[    0.156468] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.156537] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.156570] SCSI subsystem initialized
[    0.156570] libata version 3.00 loaded.
[    0.156570] usbcore: registered new interface driver usbfs
[    0.156570] usbcore: registered new interface driver hub
[    0.156570] usbcore: registered new device driver usb
[    0.156570] ACPI: WMI: Mapper loaded
[    0.156570] PCI: Using ACPI for IRQ routing
[    0.168037] NET: Registered protocol family 8
[    0.168039] NET: Registered protocol family 20
[    0.168052] NetLabel: Initializing
[    0.168052] NetLabel:  domain hash size = 128
[    0.168052] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.168052] NetLabel:  unlabeled traffic allowed by default
[    0.168052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.168056] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.191969] pnp: PnP ACPI init
[    0.191977] ACPI: bus type pnp registered
[    0.193528] pnp: PnP ACPI: found 10 devices
[    0.193529] ACPI: ACPI bus type pnp unregistered
[    0.193537] system 00:01: iomem range 0xfed14000-0xfed19fff has been 
reserved
[    0.193539] system 00:01: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.193541] system 00:01: iomem range 0xfed08000-0xfed08fff has been 
reserved
[    0.193544] system 00:02: ioport range 0xa20-0xa3f has been reserved
[    0.193546] system 00:02: ioport range 0xa00-0xa1f has been reserved
[    0.193548] system 00:02: ioport range 0xb78-0xb7f has been reserved
[    0.193549] system 00:02: ioport range 0xf78-0xf7f has been reserved
[    0.193553] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.193557] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.193558] system 00:08: ioport range 0x1180-0x119f has been reserved
[    0.193560] system 00:08: ioport range 0x500-0x57f could not be reserved
[    0.193562] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.193564] system 00:08: iomem range 0xfec00000-0xfecfffff has been 
reserved
[    0.193566] system 00:08: iomem range 0xfee00000-0xfee0ffff has been 
reserved
[    0.193567] system 00:08: iomem range 0xfed20000-0xfed9ffff has been 
reserved
[    0.193569] system 00:08: iomem range 0xff000000-0xffffffff has been 
reserved
[    0.198319] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    0.198320] pci 0000:00:1e.0:   IO window: disabled
[    0.198324] pci 0000:00:1e.0:   MEM window: disabled
[    0.198326] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.198335] pci 0000:00:1e.0: setting latency timer to 64
[    0.198338] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.198339] pci_bus 0000:00: resource 1 mem: 
[0x000000-0xffffffffffffffff]
[    0.198341] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.198342] pci_bus 0000:01: resource 4 mem: 
[0x000000-0xffffffffffffffff]
[    0.198360] NET: Registered protocol family 2
[    0.198412] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.198717] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.199854] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.200194] TCP: Hash tables configured (established 262144 bind 65536)
[    0.200196] TCP reno registered
[    0.200262] NET: Registered protocol family 1
[    0.200311] Trying to unpack rootfs image as initramfs...
[    0.319188] Freeing initrd memory: 7774k freed
[    0.321742] Machine check injector initialized
[    0.321807] Scanning for low memory corruption every 60 seconds
[    0.321964] audit: initializing netlink socket (disabled)
[    0.321976] type=2000 audit(1246854796.319:1): initialized
[    0.327781] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.329435] VFS: Disk quotas dquot_6.5.2
[    0.329490] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.329958] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.330002] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.330036] fuse init (API version 7.11)
[    0.330134] msgmni has been set to 7717
[    0.330290] alg: No test for stdrng (krng)
[    0.330357] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.330359] io scheduler noop registered
[    0.330360] io scheduler anticipatory registered
[    0.330362] io scheduler deadline registered
[    0.330369] io scheduler cfq registered (default)
[    0.330378] pci 0000:00:02.0: Boot video device
[    0.500221] Switched to high resolution mode on CPU 1
[    0.503534] Switched to high resolution mode on CPU 0
[    1.928005] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 
01010001
[    3.528006] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 
01010001
[    3.528374] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.528376] ACPI: Power Button [PWRF]
[    3.528430] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.528436] ACPI: Power Button [PWRB]
[    3.528769] ACPI: SSDT 00000000bdb65c18 002CC (v01    AMI      IST 
00000001 MSFT 03000001)
[    3.529030] Marking TSC unstable due to TSC halts in idle
[    3.529060] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.529090] processor LNXCPU:00: registered as cooling_device0
[    3.529264] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.529290] processor LNXCPU:01: registered as cooling_device1
[    3.532213] Linux agpgart interface v0.103
[    3.532223] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    3.533481] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    3.536071] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    3.536152] [drm] Initialized drm 1.1.0 20060810
[    3.536166]   alloc irq_desc for 16 on node -1
[    3.536167]   alloc kstat_irqs on node -1
[    3.536173] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.536175] i915 0000:00:02.0: setting latency timer to 64
[    3.539613] mtrr: type mismatch for c0000000,10000000 old: write-back 
new: write-combining
[    3.539615] [drm] MTRR allocation failed.  Graphics performance may 
suffer.
[    3.539626]   alloc irq_desc for 24 on node -1
[    3.539627]   alloc kstat_irqs on node -1
[    3.539632] i915 0000:00:02.0: irq 24 for MSI/MSI-X
[    3.544798] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
[    3.555500] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
[    4.241074] [drm] TMDS-12: set mode 1920x1080 1f
[    4.310987] Console: switching to colour frame buffer device 240x67
[    4.360889] [drm] fb0: inteldrmfb frame buffer device
[    4.360939] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD 20090521 
video-1851
[    4.360991] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:15/input/input2
[    4.360995] ACPI: Video Device [GFX0] (multi-head: no  rom: yes 
post: no)
[    4.361027] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on 
minor 0
[    4.362239] brd: module loaded
[    4.362822] loop: module loaded
[    4.362942] ahci 0000:00:1f.2: version 3.0
[    4.362951]   alloc irq_desc for 19 on node -1
[    4.362953]   alloc kstat_irqs on node -1
[    4.362958] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.362977]   alloc irq_desc for 25 on node -1
[    4.362978]   alloc kstat_irqs on node -1
[    4.362983] ahci 0000:00:1f.2: irq 25 for MSI/MSI-X
[    4.363040] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 
0x3f impl SATA mode
[    4.363042] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum 
part ems
[    4.363046] ahci 0000:00:1f.2: setting latency timer to 64
[    4.400046] scsi0 : ahci
[    4.400179] scsi1 : ahci
[    4.400255] scsi2 : ahci
[    4.400332] scsi3 : ahci
[    4.400406] scsi4 : ahci
[    4.400482] scsi5 : ahci
[    4.400548] ata1: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525100 irq 25
[    4.400551] ata2: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525180 irq 25
[    4.400553] ata3: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525200 irq 25
[    4.400555] ata4: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525280 irq 25
[    4.400557] ata5: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525300 irq 25
[    4.400559] ata6: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525380 irq 25
[    4.400611] ata_piix 0000:00:1f.5: version 2.13
[    4.400617] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.400620] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.400642] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.400681] scsi6 : ata_piix
[    4.400770] scsi7 : ata_piix
[    4.400834] ata7: SATA max UDMA/133 cmd 0xf170 ctl 0xf160 bmdma 
0xf130 irq 19
[    4.400837] ata8: SATA max UDMA/133 cmd 0xf150 ctl 0xf140 bmdma 
0xf138 irq 19
[    4.400919] Fixed MDIO Bus: probed
[    4.401019] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.401030]   alloc irq_desc for 18 on node -1
[    4.401031]   alloc kstat_irqs on node -1
[    4.401034] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.401040] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.401042] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.401079] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
bus number 1
[    4.404971] ehci_hcd 0000:00:1a.7: debug port 1
[    4.404975] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.404984] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd0525c00
[    4.420010] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.420105] usb usb1: configuration #1 chosen from 1 choice
[    4.420156] hub 1-0:1.0: USB hub found
[    4.420167] hub 1-0:1.0: 6 ports detected
[    4.420205]   alloc irq_desc for 23 on node -1
[    4.420206]   alloc kstat_irqs on node -1
[    4.420209] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.420214] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.420217] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.420254] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 2
[    4.424136] ehci_hcd 0000:00:1d.7: debug port 1
[    4.424141] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.424149] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0525800
[    4.440009] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.440085] usb usb2: configuration #1 chosen from 1 choice
[    4.440133] hub 2-0:1.0: USB hub found
[    4.440138] hub 2-0:1.0: 6 ports detected
[    4.440203] uhci_hcd: USB Universal Host Controller Interface driver
[    4.440254] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    4.440258] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.440261] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.440298] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 3
[    4.440323] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0e0
[    4.440388] usb usb3: configuration #1 chosen from 1 choice
[    4.440424] hub 3-0:1.0: USB hub found
[    4.440429] hub 3-0:1.0: 2 ports detected
[    4.440456]   alloc irq_desc for 21 on node -1
[    4.440457]   alloc kstat_irqs on node -1
[    4.440460] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[    4.440464] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.440466] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.440503] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned 
bus number 4
[    4.440528] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f0c0
[    4.440592] usb usb4: configuration #1 chosen from 1 choice
[    4.440629] hub 4-0:1.0: USB hub found
[    4.440633] hub 4-0:1.0: 2 ports detected
[    4.440666] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.440669] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.440672] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.440709] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned 
bus number 5
[    4.440729] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f0a0
[    4.440790] usb usb5: configuration #1 chosen from 1 choice
[    4.440824] hub 5-0:1.0: USB hub found
[    4.440828] hub 5-0:1.0: 2 ports detected
[    4.440856] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.440860] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.440862] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.440898] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 6
[    4.440917] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[    4.440980] usb usb6: configuration #1 chosen from 1 choice
[    4.441019] hub 6-0:1.0: USB hub found
[    4.441023] hub 6-0:1.0: 2 ports detected
[    4.441051] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.441055] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.441058] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.441095] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 7
[    4.441114] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[    4.441180] usb usb7: configuration #1 chosen from 1 choice
[    4.441213] hub 7-0:1.0: USB hub found
[    4.441217] hub 7-0:1.0: 2 ports detected
[    4.441245] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.441249] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.441251] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.441286] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 8
[    4.441305] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[    4.441374] usb usb8: configuration #1 chosen from 1 choice
[    4.441410] hub 8-0:1.0: USB hub found
[    4.441414] hub 8-0:1.0: 2 ports detected
[    4.441522] usbcore: registered new interface driver usbserial
[    4.441551] USB Serial support registered for generic
[    4.441579] usbcore: registered new interface driver usbserial_generic
[    4.441581] usbserial: USB Serial Driver core
[    4.441696] PNP: No PS/2 controller found. Probing ports directly.
[    4.441756] Platform driver 'i8042' needs updating - please use 
dev_pm_ops
[    4.446088] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.446092] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.446172] mice: PS/2 mouse device common for all mice
[    4.446308] rtc_cmos 00:04: RTC can wake from S4
[    4.446347] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    4.446368] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    4.446479] device-mapper: uevent: version 1.0.3
[    4.446566] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) 
initialised: dm-devel@redhat.com
[    4.446648] device-mapper: multipath: version 1.1.0 loaded
[    4.446650] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.446955] cpuidle: using governor ladder
[    4.447323] cpuidle: using governor menu
[    4.448358] usbcore: registered new interface driver hiddev
[    4.448397] usbcore: registered new interface driver usbhid
[    4.448399] usbhid: v2.6:USB HID core driver
[    4.448596] TCP cubic registered
[    4.448797] NET: Registered protocol family 10
[    4.449088] lo: Disabled Privacy Extensions
[    4.449262] NET: Registered protocol family 17
[    4.449703] PM: Resume from disk failed.
[    4.449712] registered taskstats version 1
[    4.449774]   Magic number: 1:905:564
[    4.449835] rtc_cmos 00:04: setting system clock to 2009-07-06 
04:33:21 UTC (1246854801)
[    4.449837] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.449838] EDD information not available.
[    4.720097] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.720113] ata4: SATA link down (SStatus 0 SControl 300)
[    4.720128] ata3: SATA link down (SStatus 0 SControl 300)
[    4.720142] ata6: SATA link down (SStatus 0 SControl 300)
[    4.720156] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.720168] ata5: SATA link down (SStatus 0 SControl 300)
[    4.730878] ata7: SATA link down (SStatus 0 SControl 300)
[    4.741630] ata8: SATA link down (SStatus 0 SControl 300)
[    4.741672] ata2.00: ATAPI: PIONEER DVD-RW  DVR-216D, 1.06, max UDMA/66
[    4.741794] ata1.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    4.741796] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 
31/32)
[    4.742627] ata1.00: configured for UDMA/133
[    4.742697] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 
01.0 PQ: 0 ANSI: 5
[    4.742864] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: 
(1.00 TB/931 GiB)
[    4.742890] sd 0:0:0:0: [sda] Write Protect is off
[    4.742892] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.742905] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.742981]  sda:
[    4.743065] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.744022] ata2.00: configured for UDMA/66
[    4.755221]  sda1 sda2 sda3 < sda5 sda6 sda7
[    4.806584] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-216D 
1.06 PQ: 0 ANSI: 5
[    4.817146]  sda8 sda9 sda10 sda11 >
[    4.867722] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.929948] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    4.929950] Uniform CD-ROM driver Revision: 3.20
[    4.930058] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.930140] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.930207] Freeing unused kernel memory: 428k freed
[    4.930292] Write protecting the kernel read-only data: 6888k
[    5.001004] Clocksource tsc unstable (delta = -134805128 ns)
[    5.014599] usb 3-1: new low speed USB device using uhci_hcd and 
address 2
[    5.174418] usb 3-1: configuration #1 chosen from 1 choice
[    5.191564] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[    5.191617] cherry 0003:046A:0023.0001: input,hidraw0: USB HID v1.11 
Keyboard [HID 046a:0023] on usb-0000:00:1a.0-1/input0
[    5.215426] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input4
[    5.215479] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 
Device [HID 046a:0023] on usb-0000:00:1a.0-1/input1
[    5.452023] usb 3-2: new low speed USB device using uhci_hcd and 
address 3
[    5.628404] usb 3-2: configuration #1 chosen from 1 choice
[    5.643508] input: Logitech USB-PS/2 Optical Mouse as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input5
[    5.643550] generic-usb 0003:046D:C00E.0003: input,hidraw2: USB HID 
v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-2/input0
[    6.318161] PM: Starting manual resume from disk
[    6.318163] PM: Resume from partition 8:10
[    6.318164] PM: Checking hibernation image.
[    6.318264] PM: Resume from disk failed.
[    6.339970] EXT4-fs (dm-0): barriers enabled
[    6.345742] kjournald2 starting: pid 1478, dev dm-0:8, commit 
interval 5 seconds
[    6.345748] EXT4-fs (dm-0): delayed allocation enabled
[    6.345750] EXT4-fs: file extents enabled
[    6.346227] EXT4-fs: mballoc enabled
[    6.346235] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[    7.040082] <6>cp[1526]: segfault at 7ffe3295ae98 ip 00007fb26a7db255 
sp 00007ffe3295aea0 error 6 in libattr.so.1.1.0[7fb26a7d9000+4000]
[    9.517574] udev: starting version 144
[   10.647823] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   10.647825] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.647857]   alloc irq_desc for 20 on node -1
[   10.647858]   alloc kstat_irqs on node -1
[   10.647863] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[   10.647870] e1000e 0000:00:19.0: setting latency timer to 64
[   10.647927]   alloc irq_desc for 26 on node -1
[   10.647928]   alloc kstat_irqs on node -1
[   10.647935] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   10.742376] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 
00:1c:c0:9b:a9:1a
[   10.742379] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.742404] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[   10.929800] iTCO_vendor_support: vendor-support=0
[   11.227001] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   11.227058] iTCO_wdt: Found a ICH10R TCO device (Version=2, 
TCOBASE=0x0460)
[   11.227102] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.984135] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   12.040067] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   12.040434] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.692856]   alloc irq_desc for 22 on node -1
[   12.692859]   alloc kstat_irqs on node -1
[   12.692866] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[   12.692897] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.813471] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[   13.603090] Adding 8787512k swap on /dev/sda10.  Priority:-1 
extents:1 across:8787512k
[   13.617762] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[   13.617764] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   13.618121] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.130826] EXT4-fs (dm-0): internal journal on dm-0:8
[   14.924417] EXT4-fs (sda6): barriers enabled
[   14.928374] kjournald2 starting: pid 2235, dev sda6:8, commit 
interval 5 seconds
[   14.928544] EXT4-fs (sda6): internal journal on sda6:8
[   14.928546] EXT4-fs (sda6): delayed allocation enabled
[   14.928548] EXT4-fs: file extents enabled
[   14.928587] EXT4-fs: mballoc enabled
[   14.928596] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   14.948488] EXT4-fs (sda8): barriers enabled
[   14.967740] kjournald2 starting: pid 2239, dev sda8:8, commit 
interval 5 seconds
[   14.985246] EXT4-fs (sda8): internal journal on sda8:8
[   14.985249] EXT4-fs (sda8): delayed allocation enabled
[   14.985250] EXT4-fs: file extents enabled
[   14.985574] EXT4-fs: mballoc enabled
[   14.985584] EXT4-fs (sda8): mounted filesystem with ordered data mode
[   15.010409] EXT4-fs (sda9): barriers enabled
[   15.024453] kjournald2 starting: pid 2242, dev sda9:8, commit 
interval 5 seconds
[   15.024619] EXT4-fs (sda9): internal journal on sda9:8
[   15.024621] EXT4-fs (sda9): delayed allocation enabled
[   15.024623] EXT4-fs: file extents enabled
[   15.027011] EXT4-fs: mballoc enabled
[   15.027018] EXT4-fs (sda9): mounted filesystem with ordered data mode
[   15.039131] 0000:00:19.0: eth0: changing MTU from 1500 to 1492
[   15.297297] <6>mv[2409]: segfault at 7ffee20417f8 ip 00007ff3603d9255 
sp 00007ffee2041800 error 6 in libattr.so.1.1.0[7ff3603d7000+4000]
[   16.700792] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[   16.700794] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   22.564560] <6>mv[3524]: segfault at 7ffeadbbd758 ip 00007f2b3c2a6255 
sp 00007ffeadbbd760 error 6 in libattr.so.1.1.0[7f2b3c2a4000+4000]
[   24.389015] eth0: no IPv6 routers present
[   91.633074] PM: Syncing filesystems ... done.
[   91.977060] PM: Preparing system for mem sleep
[   92.184416] Freezing user space processes ... (elapsed 0.04 seconds) 
done.
[   92.225017] Freezing remaining freezable tasks ... (elapsed 0.00 
seconds) done.
[   92.225041] PM: Entering mem sleep
[   92.225049] Suspending console(s) (use no_console_suspend to debug)
[   92.260098] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   92.260233] sd 0:0:0:0: [sda] Stopping disk
[   92.746445] ata_piix 0000:00:1f.5: PCI INT B disabled
[   92.872091] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[   92.872097] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   92.872103] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   92.872108] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   92.872120] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   92.872152] ACPI handle has no context!
[   92.888081] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[   92.888086] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[   92.888092] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   92.888097] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   92.946364] e1000e 0000:00:19.0: PCI INT A disabled
[   92.946370] e1000e 0000:00:19.0: PME# enabled
[   92.946376] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   92.985759] [drm:gm45_get_vblank_counter] *ERROR* trying to get 
vblank count for disabled pipe 1
[   92.985764] render error detected, EIR: 0x00000010
[   92.985765] page table error
[   92.985766]   PGTBL_ER: 0x00100000
[   92.985767] [drm:i915_driver_irq_handler] *ERROR* EIR stuck: 
0x00000010, masking
[   93.000097] PM: suspend devices took 0.776 seconds
[   93.000217] ehci_hcd 0000:00:1d.7: PME# disabled
[   93.016118] ehci_hcd 0000:00:1a.7: PME# disabled
[   93.032959] ACPI: Preparing to enter system sleep state S3
[   93.034172] Disabling non-boot CPUs ...
[   93.036298] kvm: disabling virtualization on CPU1
[   93.036320] CPU 1 is now offline
[   93.036322] SMP alternatives: switching to UP code
[   93.042149] CPU0 attaching NULL sched-domain.
[   93.042152] CPU1 attaching NULL sched-domain.
[   93.042157] CPU0 attaching NULL sched-domain.
[   93.042297] CPU1 is down
[   93.042686] Extended CMOS year: 2000
[   93.042686] Back to C!
[   93.042686] CPU0: Thermal LVT vector (0xfa) already installed
[   93.042686] Extended CMOS year: 2000
[   93.042686] Enabling non-boot CPUs ...
[   93.042686] SMP alternatives: switching to SMP code
[   93.046664] Booting processor 1 APIC 0x1 ip 0x6000
[   93.042047] Initializing CPU#1
[   93.042047] Calibrating delay using timer specific routine.. 6002.35 
BogoMIPS (lpj=12004716)
[   93.042047] CPU: L1 I cache: 32K, L1 D cache: 32K
[   93.042047] CPU: L2 cache: 6144K
[   93.042047] CPU: Physical Processor ID: 0
[   93.042047] CPU: Processor Core ID: 1
[   93.042047] mce: CPU supports 6 MCE banks
[   93.042047] CPU1: Thermal monitoring enabled (TM2)
[   93.136738] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[   93.136745] kvm: enabling virtualization on CPU1
[   93.136794] CPU0 attaching NULL sched-domain.
[   93.137011] Switched to high resolution mode on CPU 1
[   93.152011] CPU0 attaching sched-domain:
[   93.152013]  domain 0: span 0-1 level MC
[   93.152014]   groups: 0 1
[   93.152017] CPU1 attaching sched-domain:
[   93.152018]  domain 0: span 0-1 level MC
[   93.152019]   groups: 1 0
[   93.153008] CPU1 is up
[   93.153010] ACPI: Waking up from system sleep state S3
[   93.153671] i915 0000:00:02.0: restoring config space at offset 0xf 
(was 0x100, writing 0x10b)
[   93.153675] i915 0000:00:02.0: restoring config space at offset 0x8 
(was 0x1, writing 0xf1c1)
[   93.153678] i915 0000:00:02.0: restoring config space at offset 0x6 
(was 0xc, writing 0xc000000c)
[   93.153680] i915 0000:00:02.0: restoring config space at offset 0x4 
(was 0x4, writing 0xd0000004)
[   93.153683] i915 0000:00:02.0: restoring config space at offset 0x1 
(was 0x900000, writing 0x900407)
[   93.153697] pci 0000:00:02.1: restoring config space at offset 0x4 
(was 0x4, writing 0xd0400004)
[   93.153700] pci 0000:00:02.1: restoring config space at offset 0x1 
(was 0x900000, writing 0x900007)
[   93.153713] pci 0000:00:03.0: restoring config space at offset 0xf 
(was 0x1f2, writing 0x10b)
[   93.153730] pci 0000:00:03.0: restoring config space at offset 0x5 
(was 0x18f2, writing 0x0)
[   93.153733] pci 0000:00:03.0: restoring config space at offset 0x4 
(was 0xfed10004, writing 0xd0526104)
[   93.153757] e1000e 0000:00:19.0: restoring config space at offset 0xf 
(was 0x100, writing 0x10a)
[   93.153765] e1000e 0000:00:19.0: restoring config space at offset 0x6 
(was 0x1, writing 0xf101)
[   93.153769] e1000e 0000:00:19.0: restoring config space at offset 0x5 
(was 0x0, writing 0xd0524000)
[   93.153772] e1000e 0000:00:19.0: restoring config space at offset 0x4 
(was 0x0, writing 0xd0500000)
[   93.153777] e1000e 0000:00:19.0: restoring config space at offset 0x1 
(was 0x100000, writing 0x100007)
[   93.153791] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0xf (was 0x100, writing 0x10b)
[   93.153799] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0x8 (was 0x1, writing 0xf0e1)
[   93.153807] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.153819] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0xf (was 0x200, writing 0x203)
[   93.153827] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0x8 (was 0x1, writing 0xf0c1)
[   93.153835] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.153846] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[   93.153855] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0x8 (was 0x1, writing 0xf0a1)
[   93.153863] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.153879] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[   93.153892] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0x4 (was 0x0, writing 0xd0525c00)
[   93.153897] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900002)
[   93.153910] ehci_hcd 0000:00:1a.7: PME# disabled
[   93.153920] HDA Intel 0000:00:1b.0: restoring config space at offset 
0xf (was 0x100, writing 0x10b)
[   93.153931] HDA Intel 0000:00:1b.0: restoring config space at offset 
0x3 (was 0x0, writing 0x10)
[   93.153935] HDA Intel 0000:00:1b.0: restoring config space at offset 
0x1 (was 0x100006, writing 0x100002)
[   93.153949] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0xf (was 0x100, writing 0x10a)
[   93.153957] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0x8 (was 0x1, writing 0xf081)
[   93.153965] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.153977] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0xf (was 0x200, writing 0x203)
[   93.153985] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0x8 (was 0x1, writing 0xf061)
[   93.153993] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.154004] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[   93.154012] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0x8 (was 0x1, writing 0xf041)
[   93.154020] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[   93.154036] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0xf (was 0x100, writing 0x10a)
[   93.154049] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0x4 (was 0x0, writing 0xd0525800)
[   93.154054] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900002)
[   93.154067] ehci_hcd 0000:00:1d.7: PME# disabled
[   93.154077] pci 0000:00:1e.0: restoring config space at offset 0x9 
(was 0x10001, writing 0x1fff1)
[   93.154080] pci 0000:00:1e.0: restoring config space at offset 0x8 
(was 0x0, writing 0xfff0)
[   93.154084] pci 0000:00:1e.0: restoring config space at offset 0x6 
(was 0x0, writing 0x20010100)
[   93.154089] pci 0000:00:1e.0: restoring config space at offset 0x1 
(was 0x100005, writing 0x100007)
[   93.154140] ahci 0000:00:1f.2: restoring config space at offset 0x1 
(was 0x2b00007, writing 0x2b00407)
[   93.154159] pci 0000:00:1f.3: restoring config space at offset 0xf 
(was 0x300, writing 0x304)
[   93.154166] pci 0000:00:1f.3: restoring config space at offset 0x8 
(was 0x1181, writing 0xf001)
[   93.154172] pci 0000:00:1f.3: restoring config space at offset 0x4 
(was 0x4, writing 0xd0526004)
[   93.154176] pci 0000:00:1f.3: restoring config space at offset 0x1 
(was 0x2800001, writing 0x2800003)
[   93.156812] i915 0000:00:02.0: setting latency timer to 64
[   93.218092] [drm] TMDS-12: set mode 1920x1080 1f
[   93.218134] pci 0000:00:02.1: PME# disabled
[   93.218138] pci 0000:00:03.0: PME# disabled
[   93.218176] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[   93.218178] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting 
failed 0xfffffffb
[   93.218181] e1000e 0000:00:19.0: setting latency timer to 64
[   93.218185] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   93.218187] e1000e 0000:00:19.0: PME# disabled
[   93.218189] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   93.218191] e1000e 0000:00:19.0: PME# disabled
[   93.218214] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   93.276195] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[   93.276200] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   93.276220] usb usb3: root hub lost power or was reset
[   93.276246] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[   93.276251] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   93.276269] usb usb4: root hub lost power or was reset
[   93.276285] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[   93.276290] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   93.276308] usb usb5: root hub lost power or was reset
[   93.276324] ehci_hcd 0000:00:1a.7: PME# disabled
[   93.276328] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[   93.276333] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   93.276371] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[   93.276375] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   93.276393] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[   93.276397] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   93.276416] usb usb6: root hub lost power or was reset
[   93.276433] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[   93.276439] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   93.276459] usb usb7: root hub lost power or was reset
[   93.276474] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[   93.276479] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   93.276497] usb usb8: root hub lost power or was reset
[   93.276514] ehci_hcd 0000:00:1d.7: PME# disabled
[   93.276517] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[   93.276522] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   93.276531] pci 0000:00:1e.0: setting latency timer to 64
[   93.276577] ahci 0000:00:1f.2: setting latency timer to 64
[   93.276696] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[   93.276700] ata_piix 0000:00:1f.5: setting latency timer to 64
[   93.596029] ata6: SATA link down (SStatus 0 SControl 300)
[   93.606872] ata7: SATA link down (SStatus 0 SControl 300)
[   93.617724] ata8: SATA link down (SStatus 0 SControl 300)
[   93.617745] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   93.617764] ata4: SATA link down (SStatus 0 SControl 300)
[   93.618564] sd 0:0:0:0: [sda] Starting disk
[   93.621862] ata2.00: configured for UDMA/66
[   93.628032] ata5: SATA link down (SStatus 0 SControl 300)
[   93.640029] ata3: SATA link down (SStatus 0 SControl 300)
[   93.652691] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[   93.652693] ata2: irq_stat 0x40000001
[   93.656810] ata2.00: configured for UDMA/66
[   93.656812] ata2: EH complete
[   94.905851] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[   94.905853] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   98.644076] ata1: link is slow to respond, please be patient (ready=0)
[  101.220085] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  101.242949] ata1.00: configured for UDMA/133
[  101.242956] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  101.242958] ata1: irq_stat 0x00400040, connection status changed
[  101.244474] ata1.00: configured for UDMA/133
[  101.244476] ata1: EH complete
[  101.504084] usb 3-1: reset low speed USB device using uhci_hcd and 
address 2
[  102.076087] usb 3-2: reset low speed USB device using uhci_hcd and 
address 3
[  102.382920] PM: resume devices took 9.228 seconds
[  102.382921] ------------[ cut here ]------------
[  102.382927] WARNING: at kernel/power/suspend_test.c:52 
suspend_test_finish+0x7c/0x80()
[  102.382929] Hardware name:
[  102.382930] Component: resume devices
[  102.382931] Modules linked in: binfmt_misc kvm_intel kvm 
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse 
snd serio_raw iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc e1000e
[  102.382949] Pid: 4199, comm: bash Not tainted 
2.6.31-rc1-25446-g1ae8c0a-dirty #2
[  102.382951] Call Trace:
[  102.382956]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  102.382959]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  102.382961]  [<ffffffff8107ce7c>] suspend_test_finish+0x7c/0x80
[  102.382964]  [<ffffffff8107cac1>] suspend_devices_and_enter+0xb1/0x210
[  102.382966]  [<ffffffff8107cd4a>] enter_state+0x12a/0x150
[  102.382968]  [<ffffffff8107c2a1>] state_store+0x91/0x100
[  102.382972]  [<ffffffff8121b177>] kobj_attr_store+0x17/0x20
[  102.382975]  [<ffffffff8115a250>] sysfs_write_file+0xe0/0x160
[  102.382979]  [<ffffffff810f8468>] vfs_write+0xb8/0x1a0
[  102.382982]  [<ffffffff810f63f8>] ? filp_close+0x58/0x90
[  102.382985]  [<ffffffff810f8f1c>] sys_write+0x4c/0x80
[  102.382988]  [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
[  102.382990] ---[ end trace 11e2979285be7425 ]---
[  102.385376] PM: Finishing wakeup.
[  102.385378] Restarting tasks ... done.
[  120.816090] Corrupted low memory at ffff880000004200 (4200 phys) = 
00420301
[  120.816095] ------------[ cut here ]------------
[  120.816102] WARNING: at arch/x86/kernel/check.c:134 
check_for_bios_corruption+0xe4/0xf0()
[  120.816104] Hardware name:
[  120.816106] Memory corruption detected in low memory
[  120.816107] Modules linked in: binfmt_misc kvm_intel kvm 
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse 
snd serio_raw iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc e1000e
[  120.816129] Pid: 9, comm: events/0 Tainted: G        W 
2.6.31-rc1-25446-g1ae8c0a-dirty #2
[  120.816131] Call Trace:
[  120.816136]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  120.816139]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  120.816142]  [<ffffffff8102aff4>] check_for_bios_corruption+0xe4/0xf0
[  120.816146]  [<ffffffff8102b000>] ? check_corruption+0x0/0x30
[  120.816148]  [<ffffffff8102b009>] check_corruption+0x9/0x30
[  120.816152]  [<ffffffff8105e4d4>] worker_thread+0x144/0x260
[  120.816155]  [<ffffffff810635c0>] ? autoremove_wake_function+0x0/0x40
[  120.816158]  [<ffffffff8105e390>] ? worker_thread+0x0/0x260
[  120.816161]  [<ffffffff810631e6>] kthread+0x96/0xa0
[  120.816165]  [<ffffffff8100c69a>] child_rip+0xa/0x20
[  120.816168]  [<ffffffff81063150>] ? kthread+0x0/0xa0
[  120.816171]  [<ffffffff8100c690>] ? child_rip+0x0/0x20
[  120.816173] ---[ end trace 11e2979285be7426 ]---
[  283.297458] [drm] TMDS-12: set mode 1920x1080 1f



[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc1-25446-g1ae8c0a-dirty (lex@zwerg) 
(gcc version 4.4.0 (Ubuntu 4.4.0-8ubuntu2) ) #3 SMP Mon Jul 6 11:44:53 
CEST 2009
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz 
root=UUID=0db19d83-143f-4a8d-8f62-0775623b62b1 ro quiet splash 
memory_corruption_check_size=128k
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd90e000 (usable)
[    0.000000]  BIOS-e820: 00000000bd90e000 - 00000000bd930000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd930000 - 00000000bda48000 (reserved)
[    0.000000]  BIOS-e820: 00000000bda48000 - 00000000bda5c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bda5c000 - 00000000bdb5b000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb5b000 - 00000000bdb5c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb5c000 - 00000000bdb64000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdb64000 - 00000000bdb6e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb6e000 - 00000000bdb8c000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb8c000 - 00000000bdb92000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb92000 - 00000000bdd00000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] Intel BIOS detected: BIOS may corrupt low RAM, working 
around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0BDD00000 mask FFFF00000 write-through
[    0.000000]   2 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   3 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 13C000000 mask FFC000000 uncachable
[    0.000000] last_pfn = 0xbdd00 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000010000 - 0000000000020000 
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000020000 (reserved)
[    0.000000]  modified: 0000000000020000 - 000000000009e800 (usable)
[    0.000000]  modified: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bd90e000 (usable)
[    0.000000]  modified: 00000000bd90e000 - 00000000bd930000 (ACPI NVS)
[    0.000000]  modified: 00000000bd930000 - 00000000bda48000 (reserved)
[    0.000000]  modified: 00000000bda48000 - 00000000bda5c000 (ACPI NVS)
[    0.000000]  modified: 00000000bda5c000 - 00000000bdb5b000 (reserved)
[    0.000000]  modified: 00000000bdb5b000 - 00000000bdb5c000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb5c000 - 00000000bdb64000 (ACPI data)
[    0.000000]  modified: 00000000bdb64000 - 00000000bdb6e000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb6e000 - 00000000bdb8c000 (reserved)
[    0.000000]  modified: 00000000bdb8c000 - 00000000bdb92000 (ACPI NVS)
[    0.000000]  modified: 00000000bdb92000 - 00000000bdd00000 (usable)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdd00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000]  00bdc00000 - 00bdd00000 page 4k
[    0.000000] kernel direct mapping tables up to bdd00000 @ 20000-25000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ 23000-29000
[    0.000000] RAMDISK: 37858000 - 37fefbe0
[    0.000000] ACPI: RSDP 00000000000f03c0 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000bdb62e18 0004C (v01 INTEL  DG45ID 
0000006B MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bdb61d98 000F4 (v04  INTEL    A M I 
06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two 
FACS tables! 20090521 tbfadt-370
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 
BDB65F40/00000000BDB6BE40, using 32 20090521 tbfadt-487
[    0.000000] ACPI: DSDT 00000000bdb5c018 0492F (v01 INTEL  DG45ID 
0000006B INTL 20051117)
[    0.000000] ACPI: FACS 00000000bdb65f40 00040
[    0.000000] ACPI: APIC 00000000bdb61f18 0006C (v02 INTEL  DG45ID 
0000006B MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000bdb6cd98 0003C (v01 INTEL  DG45ID 
0000006B MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000bdb6bc18 000A0 (v32 INTEL  DG45ID 
0000006B TFSM 000F4240)
[    0.000000] ACPI: HPET 00000000bdb6cd18 00038 (v01 INTEL  DG45ID 
0000006B AMI. 00000003)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> 
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000184ec48]    TEXT DATA BSS ==> 
[0001000000 - 000184ec48]
[    0.000000]   #3 [0037858000 - 0037fefbe0]          RAMDISK ==> 
[0037858000 - 0037fefbe0]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> 
[000009e800 - 0000100000]
[    0.000000]   #5 [000184f000 - 000184f1ec]              BRK ==> 
[000184f000 - 000184f1ec]
[    0.000000]   #6 [0000020000 - 0000023000]          PGTABLE ==> 
[0000020000 - 0000023000]
[    0.000000]   #7 [0000023000 - 0000024000]          PGTABLE ==> 
[0000023000 - 0000024000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> 
[ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000020 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000020 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd90e
[    0.000000]     0: 0x000bdb92 -> 0x000bdd00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1022458
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3806 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 758452 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd90e000 - 
00000000bd930000
[    0.000000] PM: Registered nosave memory: 00000000bd930000 - 
00000000bda48000
[    0.000000] PM: Registered nosave memory: 00000000bda48000 - 
00000000bda5c000
[    0.000000] PM: Registered nosave memory: 00000000bda5c000 - 
00000000bdb5b000
[    0.000000] PM: Registered nosave memory: 00000000bdb5b000 - 
00000000bdb5c000
[    0.000000] PM: Registered nosave memory: 00000000bdb5c000 - 
00000000bdb64000
[    0.000000] PM: Registered nosave memory: 00000000bdb64000 - 
00000000bdb6e000
[    0.000000] PM: Registered nosave memory: 00000000bdb6e000 - 
00000000bdb8c000
[    0.000000] PM: Registered nosave memory: 00000000bdb8c000 - 
00000000bdb92000
[    0.000000] PM: Registered nosave memory: 00000000bdd00000 - 
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 
00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at bdd00000 (gap: 
bdd00000:4101c000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff880028022000, static 
data 82464 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1004658
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz 
root=UUID=0db19d83-143f-4a8d-8f62-0775623b62b1 ro quiet splash 
memory_corruption_check_size=128k
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 3942724k/5177344k available (4825k kernel code, 
1087512k absent, 146172k reserved, 2464k data, 428k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3000.334 MHz processor.
[    0.000998] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.004000] allocated 41943040 bytes of page_cgroup
[    0.004000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for 
per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 6000.66 BogoMIPS (lpj=12001336)
[    0.004000] Security Framework initialized
[    0.004000] Smack:  Initializing.
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: Core2 events, Intel PMU driver.
[    0.004000] ... version:                 2
[    0.004000] ... bit width:               40
[    0.004000] ... generic counters:        2
[    0.004000] ... value mask:              000000ffffffffff
[    0.004000] ... max period:              000000007fffffff
[    0.004000] ... fixed-purpose counters:  3
[    0.004000] ... counter mask:            0000000700000003
[    0.004000] ACPI: Core revision 20090521
[    0.005815] Setting APIC routing to flat
[    0.006134] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045839] CPU0: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[    0.048001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5999.23 
BogoMIPS (lpj=11998465)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.132680] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[    0.132687] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.136019] Brought up 2 CPUs
[    0.136021] Total of 2 processors activated (11999.90 BogoMIPS).
[    0.136064] CPU0 attaching sched-domain:
[    0.136066]  domain 0: span 0-1 level MC
[    0.136067]   groups: 0 1
[    0.136071] CPU1 attaching sched-domain:
[    0.136072]  domain 0: span 0-1 level MC
[    0.136073]   groups: 1 0
[    0.136127] regulator: core version 0.5
[    0.136127] Time: 10:10:36  Date: 07/06/09
[    0.136127] NET: Registered protocol family 16
[    0.136127] ACPI: bus type pci registered
[    0.136127] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.136127] PCI: Not using MMCONFIG.
[    0.136127] PCI: Using configuration type 1 for base access
[    0.136127] bio: create slab <bio-0> at 0
[    0.136399] ACPI: EC: Look up EC in DSDT
[    0.142869] ACPI: BIOS _OSI(Linux) query ignored
[    0.144360] ACPI: Interpreter enabled
[    0.144363] ACPI: (supports S0 S1 S3 S4 S5)
[    0.144377] ACPI: Using IOAPIC for interrupt routing
[    0.144465] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.144516] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.146752] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.149884] ACPI: No dock devices found.
[    0.149884] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.149884] pci 0000:00:02.0: reg 10 64bit mmio: [0xd0000000-0xd03fffff]
[    0.149884] pci 0000:00:02.0: reg 18 64bit mmio: [0xc0000000-0xcfffffff]
[    0.149884] pci 0000:00:02.0: reg 20 io port: [0xf1c0-0xf1c7]
[    0.149884] pci 0000:00:02.1: reg 10 64bit mmio: [0xd0400000-0xd04fffff]
[    0.149884] pci 0000:00:03.0: reg 10 64bit mmio: [0xd0526100-0xd052610f]
[    0.149884] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.149884] pci 0000:00:03.0: PME# disabled
[    0.149884] pci 0000:00:19.0: reg 10 32bit mmio: [0xd0500000-0xd051ffff]
[    0.149884] pci 0000:00:19.0: reg 14 32bit mmio: [0xd0524000-0xd0524fff]
[    0.149884] pci 0000:00:19.0: reg 18 io port: [0xf100-0xf11f]
[    0.149884] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.149884] pci 0000:00:19.0: PME# disabled
[    0.149884] pci 0000:00:1a.0: reg 20 io port: [0xf0e0-0xf0ff]
[    0.149884] pci 0000:00:1a.1: reg 20 io port: [0xf0c0-0xf0df]
[    0.149884] pci 0000:00:1a.2: reg 20 io port: [0xf0a0-0xf0bf]
[    0.149884] pci 0000:00:1a.7: reg 10 32bit mmio: [0xd0525c00-0xd0525fff]
[    0.149884] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.149884] pci 0000:00:1a.7: PME# disabled
[    0.149884] pci 0000:00:1b.0: reg 10 64bit mmio: [0xd0520000-0xd0523fff]
[    0.149884] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.149884] pci 0000:00:1b.0: PME# disabled
[    0.149884] pci 0000:00:1d.0: reg 20 io port: [0xf080-0xf09f]
[    0.149884] pci 0000:00:1d.1: reg 20 io port: [0xf060-0xf07f]
[    0.149884] pci 0000:00:1d.2: reg 20 io port: [0xf040-0xf05f]
[    0.149884] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0525800-0xd0525bff]
[    0.152031] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.152035] pci 0000:00:1d.7: PME# disabled
[    0.152131] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO
[    0.152134] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 
GPIO
[    0.152137] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0a00 (mask 00ff)
[    0.152189] pci 0000:00:1f.2: reg 10 io port: [0xf1b0-0xf1b7]
[    0.152194] pci 0000:00:1f.2: reg 14 io port: [0xf1a0-0xf1a3]
[    0.152198] pci 0000:00:1f.2: reg 18 io port: [0xf190-0xf197]
[    0.152202] pci 0000:00:1f.2: reg 1c io port: [0xf180-0xf183]
[    0.152207] pci 0000:00:1f.2: reg 20 io port: [0xf020-0xf03f]
[    0.152211] pci 0000:00:1f.2: reg 24 32bit mmio: [0xd0525000-0xd05257ff]
[    0.152235] pci 0000:00:1f.2: PME# supported from D3hot
[    0.152237] pci 0000:00:1f.2: PME# disabled
[    0.152259] pci 0000:00:1f.3: reg 10 64bit mmio: [0xd0526000-0xd05260ff]
[    0.152270] pci 0000:00:1f.3: reg 20 io port: [0xf000-0xf01f]
[    0.152304] pci 0000:00:1f.5: reg 10 io port: [0xf170-0xf177]
[    0.152308] pci 0000:00:1f.5: reg 14 io port: [0xf160-0xf163]
[    0.152312] pci 0000:00:1f.5: reg 18 io port: [0xf150-0xf157]
[    0.152317] pci 0000:00:1f.5: reg 1c io port: [0xf140-0xf143]
[    0.152321] pci 0000:00:1f.5: reg 20 io port: [0xf130-0xf13f]
[    0.152325] pci 0000:00:1f.5: reg 24 io port: [0xf120-0xf12f]
[    0.152387] pci 0000:00:1e.0: transparent bridge
[    0.152398] pci_bus 0000:00: on NUMA node 0
[    0.152401] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.152490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.156177] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.156177] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0
[    0.156191] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 
14 15)
[    0.156259] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 
14 15)
[    0.156329] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.156398] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 
14 15)
[    0.156466] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.156534] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.156567] SCSI subsystem initialized
[    0.156567] libata version 3.00 loaded.
[    0.156567] usbcore: registered new interface driver usbfs
[    0.156567] usbcore: registered new interface driver hub
[    0.156567] usbcore: registered new device driver usb
[    0.156567] ACPI: WMI: Mapper loaded
[    0.156567] PCI: Using ACPI for IRQ routing
[    0.176007] NET: Registered protocol family 8
[    0.176009] NET: Registered protocol family 20
[    0.176022] NetLabel: Initializing
[    0.176022] NetLabel:  domain hash size = 128
[    0.176022] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.176030] NetLabel:  unlabeled traffic allowed by default
[    0.176052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.176057] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.199966] pnp: PnP ACPI init
[    0.199974] ACPI: bus type pnp registered
[    0.201519] pnp: PnP ACPI: found 10 devices
[    0.201520] ACPI: ACPI bus type pnp unregistered
[    0.201527] system 00:01: iomem range 0xfed14000-0xfed19fff has been 
reserved
[    0.201529] system 00:01: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.201531] system 00:01: iomem range 0xfed08000-0xfed08fff has been 
reserved
[    0.201534] system 00:02: ioport range 0xa20-0xa3f has been reserved
[    0.201536] system 00:02: ioport range 0xa00-0xa1f has been reserved
[    0.201537] system 00:02: ioport range 0xb78-0xb7f has been reserved
[    0.201539] system 00:02: ioport range 0xf78-0xf7f has been reserved
[    0.201543] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.201546] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.201548] system 00:08: ioport range 0x1180-0x119f has been reserved
[    0.201550] system 00:08: ioport range 0x500-0x57f could not be reserved
[    0.201552] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.201554] system 00:08: iomem range 0xfec00000-0xfecfffff has been 
reserved
[    0.201556] system 00:08: iomem range 0xfee00000-0xfee0ffff has been 
reserved
[    0.201557] system 00:08: iomem range 0xfed20000-0xfed9ffff has been 
reserved
[    0.201559] system 00:08: iomem range 0xff000000-0xffffffff has been 
reserved
[    0.206306] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    0.206308] pci 0000:00:1e.0:   IO window: disabled
[    0.206311] pci 0000:00:1e.0:   MEM window: disabled
[    0.206314] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.206322] pci 0000:00:1e.0: setting latency timer to 64
[    0.206325] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.206326] pci_bus 0000:00: resource 1 mem: 
[0x000000-0xffffffffffffffff]
[    0.206328] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.206329] pci_bus 0000:01: resource 4 mem: 
[0x000000-0xffffffffffffffff]
[    0.206347] NET: Registered protocol family 2
[    0.206397] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.206701] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.207830] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.208170] TCP: Hash tables configured (established 262144 bind 65536)
[    0.208172] TCP reno registered
[    0.208236] NET: Registered protocol family 1
[    0.208286] Trying to unpack rootfs image as initramfs...
[    0.327049] Freeing initrd memory: 7774k freed
[    0.329581] Machine check injector initialized
[    0.329646] Scanning for low memory corruption every 60 seconds
[    0.329821] audit: initializing netlink socket (disabled)
[    0.329833] type=2000 audit(1246875036.327:1): initialized
[    0.335640] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.337221] VFS: Disk quotas dquot_6.5.2
[    0.337273] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.337734] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.337777] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.337809] fuse init (API version 7.11)
[    0.337905] msgmni has been set to 7717
[    0.338064] alg: No test for stdrng (krng)
[    0.338129] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.338131] io scheduler noop registered
[    0.338132] io scheduler anticipatory registered
[    0.338134] io scheduler deadline registered
[    0.338141] io scheduler cfq registered (default)
[    0.338150] pci 0000:00:02.0: Boot video device
[    0.500200] Switched to high resolution mode on CPU 1
[    0.503484] Switched to high resolution mode on CPU 0
[    1.936005] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 
01010001
[    3.536005] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 
01010001
[    3.536378] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.536380] ACPI: Power Button [PWRF]
[    3.536432] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.536437] ACPI: Power Button [PWRB]
[    3.536773] ACPI: SSDT 00000000bdb65c18 002CC (v01    AMI      IST 
00000001 MSFT 03000001)
[    3.537034] Marking TSC unstable due to TSC halts in idle
[    3.537065] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.537094] processor LNXCPU:00: registered as cooling_device0
[    3.537267] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.537293] processor LNXCPU:01: registered as cooling_device1
[    3.540242] Linux agpgart interface v0.103
[    3.540252] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    3.541508] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    3.544095] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    3.544172] [drm] Initialized drm 1.1.0 20060810
[    3.544187]   alloc irq_desc for 16 on node -1
[    3.544188]   alloc kstat_irqs on node -1
[    3.544194] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.544196] i915 0000:00:02.0: setting latency timer to 64
[    3.547450] mtrr: type mismatch for c0000000,10000000 old: write-back 
new: write-combining
[    3.547452] [drm] MTRR allocation failed.  Graphics performance may 
suffer.
[    3.547462]   alloc irq_desc for 24 on node -1
[    3.547463]   alloc kstat_irqs on node -1
[    3.547468] i915 0000:00:02.0: irq 24 for MSI/MSI-X
[    3.552612] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
[    3.563314] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
[    4.249192] [drm] TMDS-12: set mode 1920x1080 1f
[    4.319108] Console: switching to colour frame buffer device 240x67
[    4.369011] [drm] fb0: inteldrmfb frame buffer device
[    4.369062] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD 20090521 
video-1851
[    4.369113] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:15/input/input2
[    4.369117] ACPI: Video Device [GFX0] (multi-head: no  rom: yes 
post: no)
[    4.369149] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on 
minor 0
[    4.370359] brd: module loaded
[    4.370938] loop: module loaded
[    4.371057] ahci 0000:00:1f.2: version 3.0
[    4.371066]   alloc irq_desc for 19 on node -1
[    4.371068]   alloc kstat_irqs on node -1
[    4.371073] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.371092]   alloc irq_desc for 25 on node -1
[    4.371093]   alloc kstat_irqs on node -1
[    4.371098] ahci 0000:00:1f.2: irq 25 for MSI/MSI-X
[    4.371156] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 
0x3f impl SATA mode
[    4.371158] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum 
part ems
[    4.371161] ahci 0000:00:1f.2: setting latency timer to 64
[    4.408045] scsi0 : ahci
[    4.408179] scsi1 : ahci
[    4.408254] scsi2 : ahci
[    4.408332] scsi3 : ahci
[    4.408405] scsi4 : ahci
[    4.408477] scsi5 : ahci
[    4.408546] ata1: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525100 irq 25
[    4.408549] ata2: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525180 irq 25
[    4.408551] ata3: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525200 irq 25
[    4.408553] ata4: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525280 irq 25
[    4.408555] ata5: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525300 irq 25
[    4.408557] ata6: SATA max UDMA/133 abar m2048@0xd0525000 port 
0xd0525380 irq 25
[    4.408609] ata_piix 0000:00:1f.5: version 2.13
[    4.408615] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.408619] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.408642] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.408680] scsi6 : ata_piix
[    4.408771] scsi7 : ata_piix
[    4.408834] ata7: SATA max UDMA/133 cmd 0xf170 ctl 0xf160 bmdma 
0xf130 irq 19
[    4.408837] ata8: SATA max UDMA/133 cmd 0xf150 ctl 0xf140 bmdma 
0xf138 irq 19
[    4.408921] Fixed MDIO Bus: probed
[    4.409022] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.409033]   alloc irq_desc for 18 on node -1
[    4.409034]   alloc kstat_irqs on node -1
[    4.409037] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.409043] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.409046] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.409082] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
bus number 1
[    4.412971] ehci_hcd 0000:00:1a.7: debug port 1
[    4.412976] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.412984] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd0525c00
[    4.428009] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.428104] usb usb1: configuration #1 chosen from 1 choice
[    4.428155] hub 1-0:1.0: USB hub found
[    4.428166] hub 1-0:1.0: 6 ports detected
[    4.428204]   alloc irq_desc for 23 on node -1
[    4.428205]   alloc kstat_irqs on node -1
[    4.428208] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.428213] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.428216] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.428254] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 2
[    4.432136] ehci_hcd 0000:00:1d.7: debug port 1
[    4.432140] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.432149] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0525800
[    4.448009] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.448085] usb usb2: configuration #1 chosen from 1 choice
[    4.448134] hub 2-0:1.0: USB hub found
[    4.448140] hub 2-0:1.0: 6 ports detected
[    4.448204] uhci_hcd: USB Universal Host Controller Interface driver
[    4.448255] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    4.448259] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.448262] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.448299] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 3
[    4.448324] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0e0
[    4.448391] usb usb3: configuration #1 chosen from 1 choice
[    4.448427] hub 3-0:1.0: USB hub found
[    4.448431] hub 3-0:1.0: 2 ports detected
[    4.448458]   alloc irq_desc for 21 on node -1
[    4.448459]   alloc kstat_irqs on node -1
[    4.448462] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[    4.448466] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.448468] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.448504] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned 
bus number 4
[    4.448530] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f0c0
[    4.448592] usb usb4: configuration #1 chosen from 1 choice
[    4.448627] hub 4-0:1.0: USB hub found
[    4.448631] hub 4-0:1.0: 2 ports detected
[    4.448664] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.448668] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.448670] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.448710] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned 
bus number 5
[    4.448729] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f0a0
[    4.448791] usb usb5: configuration #1 chosen from 1 choice
[    4.448825] hub 5-0:1.0: USB hub found
[    4.448829] hub 5-0:1.0: 2 ports detected
[    4.448856] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.448860] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.448863] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.448900] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 6
[    4.448919] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[    4.448982] usb usb6: configuration #1 chosen from 1 choice
[    4.449019] hub 6-0:1.0: USB hub found
[    4.449023] hub 6-0:1.0: 2 ports detected
[    4.449052] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.449056] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.449058] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.449095] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 7
[    4.449115] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[    4.449181] usb usb7: configuration #1 chosen from 1 choice
[    4.449214] hub 7-0:1.0: USB hub found
[    4.449218] hub 7-0:1.0: 2 ports detected
[    4.449246] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.449250] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.449252] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.449287] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 8
[    4.449306] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[    4.449375] usb usb8: configuration #1 chosen from 1 choice
[    4.449409] hub 8-0:1.0: USB hub found
[    4.449412] hub 8-0:1.0: 2 ports detected
[    4.449521] usbcore: registered new interface driver usbserial
[    4.449548] USB Serial support registered for generic
[    4.449579] usbcore: registered new interface driver usbserial_generic
[    4.449580] usbserial: USB Serial Driver core
[    4.449694] PNP: No PS/2 controller found. Probing ports directly.
[    4.449755] Platform driver 'i8042' needs updating - please use 
dev_pm_ops
[    4.454008] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.454011] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.454092] mice: PS/2 mouse device common for all mice
[    4.454226] rtc_cmos 00:04: RTC can wake from S4
[    4.454265] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    4.454287] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    4.454394] device-mapper: uevent: version 1.0.3
[    4.454483] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) 
initialised: dm-devel@redhat.com
[    4.454565] device-mapper: multipath: version 1.1.0 loaded
[    4.454567] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.454875] cpuidle: using governor ladder
[    4.455239] cpuidle: using governor menu
[    4.456326] usbcore: registered new interface driver hiddev
[    4.456367] usbcore: registered new interface driver usbhid
[    4.456368] usbhid: v2.6:USB HID core driver
[    4.456565] TCP cubic registered
[    4.456820] NET: Registered protocol family 10
[    4.457112] lo: Disabled Privacy Extensions
[    4.457286] NET: Registered protocol family 17
[    4.457819] PM: Resume from disk failed.
[    4.457828] registered taskstats version 1
[    4.457890]   Magic number: 1:132:173
[    4.457951] rtc_cmos 00:04: setting system clock to 2009-07-06 
10:10:41 UTC (1246875041)
[    4.457953] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.457954] EDD information not available.
[    4.728095] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.728110] ata6: SATA link down (SStatus 0 SControl 300)
[    4.728126] ata4: SATA link down (SStatus 0 SControl 300)
[    4.728140] ata5: SATA link down (SStatus 0 SControl 300)
[    4.728154] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.728166] ata3: SATA link down (SStatus 0 SControl 300)
[    4.738871] ata7: SATA link down (SStatus 0 SControl 300)
[    4.749620] ata8: SATA link down (SStatus 0 SControl 300)
[    4.749663] ata2.00: ATAPI: PIONEER DVD-RW  DVR-216D, 1.06, max UDMA/66
[    4.749796] ata1.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    4.749798] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 
31/32)
[    4.750618] ata1.00: configured for UDMA/133
[    4.750687] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 
01.0 PQ: 0 ANSI: 5
[    4.750854] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: 
(1.00 TB/931 GiB)
[    4.750880] sd 0:0:0:0: [sda] Write Protect is off
[    4.750882] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.750896] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.750972]  sda:
[    4.751056] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.752011] ata2.00: configured for UDMA/66
[    4.766977]  sda1 sda2 sda3 < sda5 sda6 sda7
[    4.814659] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-216D 
1.06 PQ: 0 ANSI: 5
[    4.817792]  sda8 sda9 sda10 sda11 >
[    4.868078] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.938023] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    4.938025] Uniform CD-ROM driver Revision: 3.20
[    4.938132] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.938214] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.938283] Freeing unused kernel memory: 428k freed
[    4.938367] Write protecting the kernel read-only data: 6888k
[    4.989020] usb 3-1: new low speed USB device using uhci_hcd and 
address 2
[    5.001013] Clocksource tsc unstable (delta = -139605202 ns)
[    5.146413] usb 3-1: configuration #1 chosen from 1 choice
[    5.163604] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[    5.163667] cherry 0003:046A:0023.0001: input,hidraw0: USB HID v1.11 
Keyboard [HID 046a:0023] on usb-0000:00:1a.0-1/input0
[    5.187426] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input4
[    5.187474] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 
Device [HID 046a:0023] on usb-0000:00:1a.0-1/input1
[    5.425023] usb 3-2: new low speed USB device using uhci_hcd and 
address 3
[    5.601412] usb 3-2: configuration #1 chosen from 1 choice
[    5.616516] input: Logitech USB-PS/2 Optical Mouse as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input5
[    5.616558] generic-usb 0003:046D:C00E.0003: input,hidraw2: USB HID 
v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-2/input0
[    6.374731] PM: Starting manual resume from disk
[    6.374733] PM: Resume from partition 8:10
[    6.374734] PM: Checking hibernation image.
[    6.374843] PM: Resume from disk failed.
[    6.396170] EXT4-fs (dm-0): barriers enabled
[    6.401940] kjournald2 starting: pid 1483, dev dm-0:8, commit 
interval 5 seconds
[    6.401947] EXT4-fs (dm-0): delayed allocation enabled
[    6.401948] EXT4-fs: file extents enabled
[    6.402417] EXT4-fs: mballoc enabled
[    6.402426] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[    7.096275] <6>cp[1531]: segfault at 7ffea98a1cb8 ip 00007f02d871a255 
sp 00007ffea98a1cc0 error 6 in libattr.so.1.1.0[7f02d8718000+4000]
[    9.640437] udev: starting version 144
[   10.669599] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   10.669601] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.669635]   alloc irq_desc for 20 on node -1
[   10.669636]   alloc kstat_irqs on node -1
[   10.669641] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[   10.669648] e1000e 0000:00:19.0: setting latency timer to 64
[   10.669705]   alloc irq_desc for 26 on node -1
[   10.669706]   alloc kstat_irqs on node -1
[   10.669713] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   10.734693] iTCO_vendor_support: vendor-support=0
[   10.759366] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 
00:1c:c0:9b:a9:1a
[   10.759368] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.759393] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[   10.778764] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   10.778816] iTCO_wdt: Found a ICH10R TCO device (Version=2, 
TCOBASE=0x0460)
[   10.778861] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.848139] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   11.904062] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   11.904414] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.386264]   alloc irq_desc for 22 on node -1
[   12.386266]   alloc kstat_irqs on node -1
[   12.386272] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[   12.386305] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.505521] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[   13.477772] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[   13.477774] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   13.478101] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   13.514777] Adding 8787512k swap on /dev/sda10.  Priority:-1 
extents:1 across:8787512k
[   14.039413] 0000:00:19.0: eth0: changing MTU from 1500 to 1492
[   14.040983] EXT4-fs (dm-0): internal journal on dm-0:8
[   14.947183] EXT4-fs (sda6): barriers enabled
[   14.947330] kjournald2 starting: pid 2279, dev sda6:8, commit 
interval 5 seconds
[   14.947485] EXT4-fs (sda6): internal journal on sda6:8
[   14.947488] EXT4-fs (sda6): delayed allocation enabled
[   14.947489] EXT4-fs: file extents enabled
[   14.947531] EXT4-fs: mballoc enabled
[   14.947542] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   14.971356] EXT4-fs (sda8): barriers enabled
[   14.971526] kjournald2 starting: pid 2280, dev sda8:8, commit 
interval 5 seconds
[   14.971693] EXT4-fs (sda8): internal journal on sda8:8
[   14.971695] EXT4-fs (sda8): delayed allocation enabled
[   14.971696] EXT4-fs: file extents enabled
[   14.972028] EXT4-fs: mballoc enabled
[   14.972036] EXT4-fs (sda8): mounted filesystem with ordered data mode
[   14.988866] EXT4-fs (sda9): barriers enabled
[   14.988998] kjournald2 starting: pid 2281, dev sda9:8, commit 
interval 5 seconds
[   14.989154] EXT4-fs (sda9): internal journal on sda9:8
[   14.989156] EXT4-fs (sda9): delayed allocation enabled
[   14.989157] EXT4-fs: file extents enabled
[   14.991530] EXT4-fs: mballoc enabled
[   14.991536] EXT4-fs (sda9): mounted filesystem with ordered data mode
[   15.249489] <6>mv[2412]: segfault at 7ffe79da6ac8 ip 00007fae1a1b4255 
sp 00007ffe79da6ad0 error 6 in libattr.so.1.1.0[7fae1a1b2000+4000]
[   15.664774] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[   15.664777] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   22.730643] <6>mv[3493]: segfault at 7ffeb758cf28 ip 00007f23349c9255 
sp 00007ffeb758cf30 error 6 in libattr.so.1.1.0[7f23349c7000+4000]
[   23.569007] eth0: no IPv6 routers present
[  166.235008] PM: Syncing filesystems ... done.
[  166.439822] PM: Preparing system for mem sleep
[  166.660026] Freezing user space processes ... (elapsed 0.00 seconds) 
done.
[  166.660595] Freezing remaining freezable tasks ... (elapsed 0.00 
seconds) done.
[  166.660618] PM: Entering mem sleep
[  166.660626] Suspending console(s) (use no_console_suspend to debug)
[  166.696098] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  166.696242] sd 0:0:0:0: [sda] Stopping disk
[  167.175115] ata_piix 0000:00:1f.5: PCI INT B disabled
[  167.300092] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  167.300098] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  167.300104] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  167.300109] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  167.300122] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  167.300155] ACPI handle has no context!
[  167.316093] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  167.316099] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  167.316104] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  167.316109] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  167.374363] e1000e 0000:00:19.0: PCI INT A disabled
[  167.374368] e1000e 0000:00:19.0: PME# enabled
[  167.374377] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  167.416729] [drm:gm45_get_vblank_counter] *ERROR* trying to get 
vblank count for disabled pipe 1
[  167.416733] render error detected, EIR: 0x00000010
[  167.416734] page table error
[  167.416735]   PGTBL_ER: 0x00100000
[  167.416737] [drm:i915_driver_irq_handler] *ERROR* EIR stuck: 
0x00000010, masking
[  167.432106] PM: suspend devices took 0.772 seconds
[  167.432231] ehci_hcd 0000:00:1d.7: PME# disabled
[  167.448119] ehci_hcd 0000:00:1a.7: PME# disabled
[  167.464957] ACPI: Preparing to enter system sleep state S3
[  167.466165] Disabling non-boot CPUs ...
[  167.468291] kvm: disabling virtualization on CPU1
[  167.468318] CPU 1 is now offline
[  167.468320] SMP alternatives: switching to UP code
[  167.474172] CPU0 attaching NULL sched-domain.
[  167.474175] CPU1 attaching NULL sched-domain.
[  167.474180] CPU0 attaching NULL sched-domain.
[  167.474319] CPU1 is down
[  167.474354] Extended CMOS year: 2000
[  167.474354] Back to C!
[  167.474354] CPU0: Thermal LVT vector (0xfa) already installed
[  167.474354] Extended CMOS year: 2000
[  167.474354] Enabling non-boot CPUs ...
[  167.474354] SMP alternatives: switching to SMP code
[  167.478330] Booting processor 1 APIC 0x1 ip 0x6000
[  167.474062] Initializing CPU#1
[  167.474062] Calibrating delay using timer specific routine.. 6002.34 
BogoMIPS (lpj=12004683)
[  167.474062] CPU: L1 I cache: 32K, L1 D cache: 32K
[  167.474062] CPU: L2 cache: 6144K
[  167.474062] CPU: Physical Processor ID: 0
[  167.474062] CPU: Processor Core ID: 1
[  167.474062] mce: CPU supports 6 MCE banks
[  167.474062] CPU1: Thermal monitoring enabled (TM2)
[  167.568725] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz 
stepping 0a
[  167.568732] kvm: enabling virtualization on CPU1
[  167.568779] CPU0 attaching NULL sched-domain.
[  167.569010] Switched to high resolution mode on CPU 1
[  167.584009] CPU0 attaching sched-domain:
[  167.584011]  domain 0: span 0-1 level MC
[  167.584012]   groups: 0 1
[  167.584014] CPU1 attaching sched-domain:
[  167.584015]  domain 0: span 0-1 level MC
[  167.584017]   groups: 1 0
[  167.585008] CPU1 is up
[  167.585010] ACPI: Waking up from system sleep state S3
[  167.585671] i915 0000:00:02.0: restoring config space at offset 0xf 
(was 0x100, writing 0x10b)
[  167.585675] i915 0000:00:02.0: restoring config space at offset 0x8 
(was 0x1, writing 0xf1c1)
[  167.585678] i915 0000:00:02.0: restoring config space at offset 0x6 
(was 0xc, writing 0xc000000c)
[  167.585680] i915 0000:00:02.0: restoring config space at offset 0x4 
(was 0x4, writing 0xd0000004)
[  167.585683] i915 0000:00:02.0: restoring config space at offset 0x1 
(was 0x900000, writing 0x900407)
[  167.585697] pci 0000:00:02.1: restoring config space at offset 0x4 
(was 0x4, writing 0xd0400004)
[  167.585700] pci 0000:00:02.1: restoring config space at offset 0x1 
(was 0x900000, writing 0x900007)
[  167.585711] pci 0000:00:03.0: restoring config space at offset 0xf 
(was 0x1f2, writing 0x10b)
[  167.585724] pci 0000:00:03.0: restoring config space at offset 0x5 
(was 0x18f2, writing 0x0)
[  167.585727] pci 0000:00:03.0: restoring config space at offset 0x4 
(was 0xfed10004, writing 0xd0526104)
[  167.585747] e1000e 0000:00:19.0: restoring config space at offset 0xf 
(was 0x100, writing 0x10a)
[  167.585756] e1000e 0000:00:19.0: restoring config space at offset 0x6 
(was 0x1, writing 0xf101)
[  167.585759] e1000e 0000:00:19.0: restoring config space at offset 0x5 
(was 0x0, writing 0xd0524000)
[  167.585762] e1000e 0000:00:19.0: restoring config space at offset 0x4 
(was 0x0, writing 0xd0500000)
[  167.585767] e1000e 0000:00:19.0: restoring config space at offset 0x1 
(was 0x100000, writing 0x100007)
[  167.585781] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0xf (was 0x100, writing 0x10b)
[  167.585789] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0x8 (was 0x1, writing 0xf0e1)
[  167.585797] uhci_hcd 0000:00:1a.0: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.585809] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0xf (was 0x200, writing 0x203)
[  167.585817] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0x8 (was 0x1, writing 0xf0c1)
[  167.585825] uhci_hcd 0000:00:1a.1: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.585836] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[  167.585844] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0x8 (was 0x1, writing 0xf0a1)
[  167.585852] uhci_hcd 0000:00:1a.2: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.585868] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[  167.585881] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0x4 (was 0x0, writing 0xd0525c00)
[  167.585886] ehci_hcd 0000:00:1a.7: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900002)
[  167.585899] ehci_hcd 0000:00:1a.7: PME# disabled
[  167.585910] HDA Intel 0000:00:1b.0: restoring config space at offset 
0xf (was 0x100, writing 0x10b)
[  167.585921] HDA Intel 0000:00:1b.0: restoring config space at offset 
0x3 (was 0x0, writing 0x10)
[  167.585925] HDA Intel 0000:00:1b.0: restoring config space at offset 
0x1 (was 0x100006, writing 0x100002)
[  167.585939] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0xf (was 0x100, writing 0x10a)
[  167.585947] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0x8 (was 0x1, writing 0xf081)
[  167.585955] uhci_hcd 0000:00:1d.0: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.585966] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0xf (was 0x200, writing 0x203)
[  167.585974] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0x8 (was 0x1, writing 0xf061)
[  167.585982] uhci_hcd 0000:00:1d.1: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.585993] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0xf (was 0x300, writing 0x304)
[  167.586001] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0x8 (was 0x1, writing 0xf041)
[  167.586009] uhci_hcd 0000:00:1d.2: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900001)
[  167.586026] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0xf (was 0x100, writing 0x10a)
[  167.586038] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0x4 (was 0x0, writing 0xd0525800)
[  167.586043] ehci_hcd 0000:00:1d.7: restoring config space at offset 
0x1 (was 0x2900000, writing 0x2900002)
[  167.586056] ehci_hcd 0000:00:1d.7: PME# disabled
[  167.586066] pci 0000:00:1e.0: restoring config space at offset 0x9 
(was 0x10001, writing 0x1fff1)
[  167.586069] pci 0000:00:1e.0: restoring config space at offset 0x8 
(was 0x0, writing 0xfff0)
[  167.586072] pci 0000:00:1e.0: restoring config space at offset 0x6 
(was 0x0, writing 0x20010100)
[  167.586078] pci 0000:00:1e.0: restoring config space at offset 0x1 
(was 0x100005, writing 0x100007)
[  167.586129] ahci 0000:00:1f.2: restoring config space at offset 0x1 
(was 0x2b00007, writing 0x2b00407)
[  167.586147] pci 0000:00:1f.3: restoring config space at offset 0xf 
(was 0x300, writing 0x304)
[  167.586155] pci 0000:00:1f.3: restoring config space at offset 0x8 
(was 0x1181, writing 0xf001)
[  167.586160] pci 0000:00:1f.3: restoring config space at offset 0x4 
(was 0x4, writing 0xd0526004)
[  167.586165] pci 0000:00:1f.3: restoring config space at offset 0x1 
(was 0x2800001, writing 0x2800003)
[  167.588814] i915 0000:00:02.0: setting latency timer to 64
[  167.650109] [drm] TMDS-12: set mode 1920x1080 1f
[  167.650151] pci 0000:00:02.1: PME# disabled
[  167.650154] pci 0000:00:03.0: PME# disabled
[  167.650191] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[  167.650193] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting 
failed 0xfffffffb
[  167.650196] e1000e 0000:00:19.0: setting latency timer to 64
[  167.650200] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  167.650202] e1000e 0000:00:19.0: PME# disabled
[  167.650204] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  167.650206] e1000e 0000:00:19.0: PME# disabled
[  167.650230] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[  167.708191] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[  167.708196] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  167.708216] usb usb3: root hub lost power or was reset
[  167.708242] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) 
-> IRQ 21
[  167.708247] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  167.708265] usb usb4: root hub lost power or was reset
[  167.708281] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[  167.708286] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  167.708305] usb usb5: root hub lost power or was reset
[  167.708321] ehci_hcd 0000:00:1a.7: PME# disabled
[  167.708324] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[  167.708329] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  167.708367] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[  167.708371] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  167.708389] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[  167.708393] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  167.708412] usb usb6: root hub lost power or was reset
[  167.708430] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[  167.708436] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  167.708457] usb usb7: root hub lost power or was reset
[  167.708472] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[  167.708477] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  167.708495] usb usb8: root hub lost power or was reset
[  167.708511] ehci_hcd 0000:00:1d.7: PME# disabled
[  167.708515] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[  167.708520] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  167.708529] pci 0000:00:1e.0: setting latency timer to 64
[  167.708575] ahci 0000:00:1f.2: setting latency timer to 64
[  167.708695] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[  167.708699] ata_piix 0000:00:1f.5: setting latency timer to 64
[  168.028029] ata6: SATA link down (SStatus 0 SControl 300)
[  168.038866] ata8: SATA link down (SStatus 0 SControl 300)
[  168.049718] ata7: SATA link down (SStatus 0 SControl 300)
[  168.049736] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  168.049754] ata5: SATA link down (SStatus 0 SControl 300)
[  168.050554] sd 0:0:0:0: [sda] Starting disk
[  168.053856] ata2.00: configured for UDMA/66
[  168.060030] ata4: SATA link down (SStatus 0 SControl 300)
[  168.072028] ata3: SATA link down (SStatus 0 SControl 300)
[  168.084741] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  168.084743] ata2: irq_stat 0x40000001
[  168.088857] ata2.00: configured for UDMA/66
[  168.088859] ata2: EH complete
[  169.357849] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: RX/TX
[  169.357851] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[  173.076075] ata1: link is slow to respond, please be patient (ready=0)
[  175.596083] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  175.626681] ata1.00: configured for UDMA/133
[  175.626689] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  175.626691] ata1: irq_stat 0x00400040, connection status changed
[  175.628227] ata1.00: configured for UDMA/133
[  175.628229] ata1: EH complete
[  175.888086] usb 3-1: reset low speed USB device using uhci_hcd and 
address 2
[  176.460078] usb 3-2: reset low speed USB device using uhci_hcd and 
address 3
[  176.763922] PM: resume devices took 9.176 seconds
[  176.763924] ------------[ cut here ]------------
[  176.763930] WARNING: at kernel/power/suspend_test.c:52 
suspend_test_finish+0x7c/0x80()
[  176.763932] Hardware name:
[  176.763933] Component: resume devices
[  176.763934] Modules linked in: binfmt_misc kvm_intel kvm 
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd 
psmouse iTCO_wdt iTCO_vendor_support serio_raw e1000e soundcore 
snd_page_alloc
[  176.763952] Pid: 4180, comm: bash Not tainted 
2.6.31-rc1-25446-g1ae8c0a-dirty #3
[  176.763953] Call Trace:
[  176.763958]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  176.763961]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  176.763964]  [<ffffffff8107ce7c>] suspend_test_finish+0x7c/0x80
[  176.763966]  [<ffffffff8107cac1>] suspend_devices_and_enter+0xb1/0x210
[  176.763969]  [<ffffffff8107cd4a>] enter_state+0x12a/0x150
[  176.763971]  [<ffffffff8107c2a1>] state_store+0x91/0x100
[  176.763974]  [<ffffffff8121b177>] kobj_attr_store+0x17/0x20
[  176.763978]  [<ffffffff8115a250>] sysfs_write_file+0xe0/0x160
[  176.763981]  [<ffffffff810f8468>] vfs_write+0xb8/0x1a0
[  176.763984]  [<ffffffff810f63f8>] ? filp_close+0x58/0x90
[  176.763987]  [<ffffffff810f8f1c>] sys_write+0x4c/0x80
[  176.763991]  [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
[  176.763993] ---[ end trace 50ea4941e30c27fd ]---
[  176.766367] PM: Finishing wakeup.
[  176.766369] Restarting tasks ... done.

