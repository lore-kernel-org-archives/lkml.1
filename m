Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484Ab0AaNCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0AaNCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 08:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888Ab0AaNCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 08:02:40 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41670 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0AaNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 08:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=K/MQABi6kYzK+QrEr8dYjUyp5p014AaciBjVChtGgmyaD79HaSE9874kiC+4j0B4WC
         xU+faqTBnWRBcgr0p5IVUCiOmCli/4l71r8Sdf2s8JCEeXRHS/+BM1QOdzrVa1rTtpRL
         QHe1EOXeXkmSsGYlO6lcjiIiQvffyRhtL/53w=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 14:02:33 +0100
Message-ID: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
Subject: do_IRQ: 0.165 No irq handler for vector (irq -1)
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still trying to get the MSI support for sata_sil24, that was added
in 2.6.33-rc1, to work. But even with -rc6 it still shows the same
errors.

The current best guess is, that there is something fishy going on in
the IRQ system, as the only error messages before the libata timeouts
start are:

[   86.463814] do_IRQ: 0.165 No irq handler for vector (irq -1)
[   86.463832] do_IRQ: 3.165 No irq handler for vector (irq -1)
[   86.463848] do_IRQ: 1.165 No irq handler for vector (irq -1)
[   86.463867] do_IRQ: 2.165 No irq handler for vector (irq -1)

(Thats why I added CCs for get_maintainer.pl -f arch/x86/kernel/apic/io_apic.c)

To get these errors I only boot with sata_sil24.msi=1 and then do: dd
if=1GB-file-on-ro-mounted-xfs-fs of=/dev/null bs=1k

Writing with enabled MSI also fails with timeouts, but in this case
there is no error from do_IRQ.

What is really strange: The vector 165 is stable. It never changed
even if I deactivate all other drivers in the kernel config (that
changes the MSI IRQ for sata_sil24 from 29 to 28!) or if I switch off
CONFIG_SPARSE_IRQ. In the kernel with the reduced number of drivers
the maximum vector that gets used in __assign_irq_vector is only 137.

Both Robert Hancock and Tejun Heo provided different patches for
sata_sil24 to access a additional MSI register on the SiI-chip, but
neither change the behavior of my system.

I also do not think that MSI is completely broken, as the drivers
radeon (X300), HDA Intel (onboard sound from NVidia MCP55) and tg3 (2x
BCM5754) work fine with MSIs.

/proc/interrupts with 2.6.33-rc6 and sata_sil.msi=1:
           CPU0       CPU1       CPU2       CPU3
  0:         41          0          0          1   IO-APIC-edge      timer
  1:          0          0          0        183   IO-APIC-edge      i8042
  4:          0          0          1        208   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          1          3   IO-APIC-edge      i8042
 14:          0          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0          3   IO-APIC-fasteoi   ohci1394
 19:          0          0          1          3   IO-APIC-fasteoi
bttv0, Bt87x audio
 20:          0          0          0          2   IO-APIC-fasteoi
ehci_hcd:usb1
 21:          0          0          0          0   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   sata_nv
 23:          1          1          1       6046   IO-APIC-fasteoi
sata_nv, ohci_hcd:usb2
 28:          0          0         18        575   PCI-MSI-edge      radeon
 29:          0          0          0        646   PCI-MSI-edge      sata_sil24
 30:          0          0          0         89   PCI-MSI-edge      HDA Intel
 31:          0          0          0          3   PCI-MSI-edge      eth0
 32:          0          0          0         36   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:       3375       2804       3284       3256   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:       5173       4176       4749       4528   Rescheduling interrupts
CAL:        742         40         36         30   Function call interrupts
TLB:        767        475        757        543   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0

After the test and the do_IRQ-errors the important changes are:
29:          0          0          0       2023   PCI-MSI-edge      sata_sil24
-> Some interrupts where delivered. I am able to mount the xfs
filesystem and dd says it could read the first 180 MB successfull.
ERR:         15
-> I have no clue how 8 do_IRQ errors translate to an increase of 14...

If you need more information or have a patch I should test, just ask.
At the end of the mail is the complete dmesg from the testrun with
-rc6. I also added apic=debug to the commandline, but did not see
anything related to this strange irq vector 165.

Torsten


[    0.000000] Linux version 2.6.33-rc6 (root@treogen) (gcc version
4.4.2 (Gentoo 4.4.2 p1.0) ) #1 SMP Sat Jan 30 10:38:39 CET 2010
[    0.000000] Command line: root=/dev/sdc1 console=ttyS0,115200
console=tty1 sata_sil24.msi=1 radeon.modeset=1 raid=noautodetect
apic=debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000dffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dffde000 - 00000000e0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xdffd0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]   mpc: f16f0-f188c
[    0.000000] init_memory_mapping: 0000000000000000-00000000dffd0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dffd0000 page 4k
[    0.000000] kernel direct mapping tables up to dffd0000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] ACPI: RSDP 00000000000fb080 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dffd0100 00064 (v01 A_M_I_ OEMXSDT
04000713 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dffd0290 000F4 (v03 A_M_I_ OEMFACP
04000713 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000dffd0450 04FC5 (v01  S0027 S0027000
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000dffde000 00040
[    0.000000] ACPI: APIC 00000000dffd0390 00080 (v01 A_M_I_ OEMAPIC
04000713 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dffd0410 0003C (v01 A_M_I_ OEMMCFG
04000713 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dffde040 00060 (v01 A_M_I_ AMI_OEM
04000713 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000dffd5420 00038 (v01 A_M_I_ OEMHPET0
04000713 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dffd5460 0003C (v01 A_M_I_ OEMMCFG
04000713 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000dffd54a0 00110 (v01 AMD    HAMMER
00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000dffd55b0 004F0 (v01 A_M_I_ POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-120000000
[    0.000000] NUMA: Allocated memnodemap from d000 - f440
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [000000000000f440 - 000000000002343f]
[    0.000000]   bootmap [0000000000024000 -  0000000000033fff] pages 10
[    0.000000] (12 early reservations) ==> bootmem [0000000000 - 0080000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00019f66d8]    TEXT DATA BSS ==>
[0001000000 - 00019f66d8]
[    0.000000]   #2 [00019f7000 - 00019f7238]              BRK ==>
[00019f7000 - 00019f7238]
[    0.000000]   #3 [00000ff790 - 0000100000]    BIOS reserved ==>
[00000ff790 - 0000100000]
[    0.000000]   #4 [00000ff780 - 00000ff790]     MP-table mpf ==>
[00000ff780 - 00000ff790]
[    0.000000]   #5 [000009fc00 - 00000f16f0]    BIOS reserved ==>
[000009fc00 - 00000f16f0]
[    0.000000]   #6 [00000f188c - 00000ff780]    BIOS reserved ==>
[00000f188c - 00000ff780]
[    0.000000]   #7 [00000f16f0 - 00000f188c]     MP-table mpc ==>
[00000f16f0 - 00000f188c]
[    0.000000]   #8 [0000001000 - 0000003000]       TRAMPOLINE ==>
[0000001000 - 0000003000]
[    0.000000]   #9 [0000008000 - 000000c000]          PGTABLE ==>
[0000008000 - 000000c000]
[    0.000000]   #10 [000000c000 - 000000d000]          PGTABLE ==>
[000000c000 - 000000d000]
[    0.000000]   #11 [000000d000 - 000000f440]       MEMNODEMAP ==>
[000000d000 - 000000f440]
[    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
[    0.000000]   NODE_DATA [0000000080000000 - 0000000080013fff]
[    0.000000]   bootmap [0000000080014000 -  0000000080027fff] pages 14
[    0.000000] (12 early reservations) ==> bootmem [0080000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0001000000 - 00019f66d8]    TEXT DATA BSS
[    0.000000]   #2 [00019f7000 - 00019f7238]              BRK
[    0.000000]   #3 [00000ff790 - 0000100000]    BIOS reserved
[    0.000000]   #4 [00000ff780 - 00000ff790]     MP-table mpf
[    0.000000]   #5 [000009fc00 - 00000f16f0]    BIOS reserved
[    0.000000]   #6 [00000f188c - 00000ff780]    BIOS reserved
[    0.000000]   #7 [00000f16f0 - 00000f188c]     MP-table mpc
[    0.000000]   #8 [0000001000 - 0000003000]       TRAMPOLINE
[    0.000000]   #9 [0000008000 - 000000c000]          PGTABLE
[    0.000000]   #10 [000000c000 - 000000d000]          PGTABLE
[    0.000000]   #11 [000000d000 - 000000f440]       MEMNODEMAP
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD ->
[ffff880028600000-ffff88002a1fffff] on node 0
[    0.000000]  [ffffea0001c00000-ffffea0003ffffff] PMD ->
[ffff880080200000-ffff880081ffffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000]     1: 0x00080000 -> 0x000dffd0
[    0.000000]     1: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 524191
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7112 pages used for memmap
[    0.000000]   DMA32 zone: 513080 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 524240
[    0.000000]   DMA32 zone: 7168 pages used for memmap
[    0.000000]   DMA32 zone: 386000 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at e0000000 (gap:
e0000000:1ec00000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4
nr_node_ids:2
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880028200000 s77784
r8192 d20520 u1048576
[    0.000000] pcpu-alloc: s77784 r8192 d20520 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 [1] 2 3
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.
Total pages: 1032199
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sdc1
console=ttyS0,115200 console=tty1 sata_sil24.msi=1 radeon.modeset=1
raid=noautodetect apic=debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ a7f2000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] Memory: 3991832k/4718592k available (5301k kernel code,
524868k absent, 201892k reserved, 3069k data, 1208k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2599.982 MHz processor.
[    0.020011] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5199.96 BogoMIPS (lpj=25999820)
[    0.030032] Security Framework initialized
[    0.034372] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.042971] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.051228] Mount-cache hash table entries: 256
[    0.055903] tseg: 0000000000
[    0.055912] CPU: Physical Processor ID: 0
[    0.060003] CPU: Processor Core ID: 0
[    0.063669] mce: CPU supports 5 MCE banks
[    0.070008] using C1E aware idle routine
[    0.073930] Performance Events: AMD PMU driver.
[    0.078489] ... version:                0
[    0.080001] ... bit width:              48
[    0.084102] ... generic registers:      4
[    0.090001] ... value mask:             0000ffffffffffff
[    0.095306] ... max period:             00007fffffffffff
[    0.100001] ... fixed-purpose events:   0
[    0.104016] ... event mask:             000000000000000f
[    0.110010] Freeing SMP alternatives: 34k freed
[    0.114563] ACPI: Core revision 20091214
[    0.128365] Setting APIC routing to flat
[    0.130002] Getting VERSION: 80050010
[    0.133672] Getting VERSION: 80050010
[    0.137338] Getting ID: 0
[    0.140001] Getting ID: ff000000
[    0.143238] Getting LVT0: 700
[    0.146212] Getting LVT1: 400
[    0.150003] enabled ExtINT on CPU#0
[    0.153724] ESR value before enabling vector: 0x00000004  after: 0x00000000
[    0.160002] ENABLING IO-APIC IRQs
[    0.163325] init IO_APIC IRQs
[    0.163327]  4-0 (apicid-pin) not connected
[    0.163331] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1
Mode:0 Active:0)
[    0.163339] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0
Mode:0 Active:0)
[    0.163345] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3
Mode:0 Active:0)
[    0.163351] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4
Mode:0 Active:0)
[    0.163358] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5
Mode:0 Active:0)
[    0.163364] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6
Mode:0 Active:0)
[    0.163370] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7
Mode:0 Active:0)
[    0.163377] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8
Mode:0 Active:0)
[    0.163383] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9
Mode:1 Active:0)
[    0.163389] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10
Mode:0 Active:0)
[    0.163396] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11
Mode:0 Active:0)
[    0.163402] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12
Mode:0 Active:0)
[    0.163409] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13
Mode:0 Active:0)
[    0.163415] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14
Mode:0 Active:0)
[    0.163421] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15
Mode:0 Active:0)
[    0.163427]  4-16 4-17 4-18 4-19 4-20 4-21 4-22 4-23 (apicid-pin)
not connected
[    0.163563] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.271460] CPU0: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
[    0.278051] Using local APIC timer interrupts.
[    0.278052] calibrating APIC timer ...
[    0.290000] ... lapic delta = 1249998
[    0.290000] ... PM-Timer delta = 357954
[    0.290000] ... PM-Timer result ok
[    0.290000] ..... delta 1249998
[    0.290000] ..... mult: 53687005
[    0.290000] ..... calibration result: 1999996
[    0.290000] ..... CPU clock speed is 2599.9959 MHz.
[    0.290000] ..... host bus clock speed is 199.9996 MHz.
[    0.290102] Booting Node   0, Processors  #1masked ExtINT on CPU#1
[    0.450092]  Ok.
[    0.454055] Booting Node   1, Processors  #2masked ExtINT on CPU#2
[    0.610081]  #3 Ok.
[    0.030000] masked ExtINT on CPU#3
[    0.770040] Brought up 4 CPUs
[    0.776425] Total of 4 processors activated (20800.14 BogoMIPS).
[    0.780391] NET: Registered protocol family 16
[    0.784506] node 0 link 0: io port [3000, ffffff]
[    0.784506] node 0 link 0: io port [2000, 2fff]
[    0.784506] TOM: 00000000e0000000 aka 3584M
[    0.790003] node 0 link 0: mmio [f0000000, f3ffffff]
[    0.790005] node 0 link 0: mmio [a0000, bffff]
[    0.790007] node 0 link 0: mmio [e0000000, efffffff]
[    0.790009] TOM2: 0000000120000000 aka 4608M
[    0.794278] bus: [00, ff] on node 0 link 0
[    0.794280] bus: 00 index 0 io port: [0, ffff]
[    0.794281] bus: 00 index 1 mmio: [e0000000, ffffffff]
[    0.794283] bus: 00 index 2 mmio: [a0000, bffff]
[    0.794284] bus: 00 index 3 mmio: [120000000, fcffffffff]
[    0.794289] ACPI: bus type pci registered
[    0.800027] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xf0000000-0xffffffff] (base 0xf0000000)
[    0.810002] PCI: not using MMCONFIG
[    0.813501] PCI: Using configuration type 1 for base access
[    0.830019] bio: create slab <bio-0> at 0
[    0.834050] ACPI: EC: Look up EC in DSDT
[    0.834050] ACPI: Executed 1 blocks of module-level executable AML code
[    0.851281] ACPI: Interpreter enabled
[    0.854948] ACPI: (supports S0 S5)
[    0.858427] ACPI: Using IOAPIC for interrupt routing
[    0.860046] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xf0000000-0xffffffff] (base 0xf0000000)
[    0.900481] [Firmware Bug]: PCI: MMCONFIG at [mem
0xf0000000-0xffffffff] not reserved in ACPI motherboard resources
[    0.910001] PCI: not using MMCONFIG
[    0.920153] ACPI Warning: Incorrect checksum in table [OEMB] - EC,
should be E7 (20091214/tbutils-314)
[    0.932372] ACPI: No dock devices found.
[    0.936563] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.940024] pci_root PNP0A03:00: ignoring host bridge windows from
ACPI; boot with "pci=use_crs" to use them
[    0.950206] pci_root PNP0A03:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.950208] pci_root PNP0A03:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.950210] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.950212] pci_root PNP0A03:00: host bridge window [mem
0x000d0000-0x000dffff] (ignored)
[    0.950214] pci_root PNP0A03:00: host bridge window [mem
0xe0000000-0xfebfffff] (ignored)
[    0.950352] pci 0000:00:01.0: reg 10: [io  0x2f00-0x2f7f]
[    0.950379] pci 0000:00:01.1: reg 10: [io  0xa880-0xa8bf]
[    0.950388] pci 0000:00:01.1: reg 20: [io  0x2a00-0x2a3f]
[    0.950391] pci 0000:00:01.1: reg 24: [io  0x2a80-0x2abf]
[    0.950410] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.950414] pci 0000:00:01.1: PME# disabled
[    0.950433] pci 0000:00:02.0: reg 10: [mem 0xefaf8000-0xefaf8fff]
[    0.950449] pci 0000:00:02.0: supports D1 D2
[    0.950450] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950453] pci 0000:00:02.0: PME# disabled
[    0.950465] pci 0000:00:02.1: reg 10: [mem 0xefaebc00-0xefaebcff]
[    0.950481] pci 0000:00:02.1: supports D1 D2
[    0.950482] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950484] pci 0000:00:02.1: PME# disabled
[    0.950504] pci 0000:00:04.0: reg 20: [io  0xffa0-0xffaf]
[    0.950523] pci 0000:00:05.0: reg 10: [io  0xcc00-0xcc07]
[    0.950525] pci 0000:00:05.0: reg 14: [io  0xc880-0xc883]
[    0.950528] pci 0000:00:05.0: reg 18: [io  0xc800-0xc807]
[    0.950531] pci 0000:00:05.0: reg 1c: [io  0xc480-0xc483]
[    0.950533] pci 0000:00:05.0: reg 20: [io  0xc400-0xc40f]
[    0.950536] pci 0000:00:05.0: reg 24: [mem 0xefafb000-0xefafbfff]
[    0.950558] pci 0000:00:05.1: reg 10: [io  0xc080-0xc087]
[    0.950560] pci 0000:00:05.1: reg 14: [io  0xc000-0xc003]
[    0.950563] pci 0000:00:05.1: reg 18: [io  0xbc00-0xbc07]
[    0.950566] pci 0000:00:05.1: reg 1c: [io  0xb880-0xb883]
[    0.950568] pci 0000:00:05.1: reg 20: [io  0xb800-0xb80f]
[    0.950571] pci 0000:00:05.1: reg 24: [mem 0xefafa000-0xefafafff]
[    0.950593] pci 0000:00:05.2: reg 10: [io  0xb480-0xb487]
[    0.950595] pci 0000:00:05.2: reg 14: [io  0xb400-0xb403]
[    0.950598] pci 0000:00:05.2: reg 18: [io  0xb080-0xb087]
[    0.950601] pci 0000:00:05.2: reg 1c: [io  0xb000-0xb003]
[    0.950603] pci 0000:00:05.2: reg 20: [io  0xac00-0xac0f]
[    0.950606] pci 0000:00:05.2: reg 24: [mem 0xefaf9000-0xefaf9fff]
[    0.950652] pci 0000:00:06.1: reg 10: [mem 0xefafc000-0xefafffff]
[    0.950671] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.950673] pci 0000:00:06.1: PME# disabled
[    0.950702] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950704] pci 0000:00:0b.0: PME# disabled
[    0.950725] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950727] pci 0000:00:0c.0: PME# disabled
[    0.950748] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950750] pci 0000:00:0d.0: PME# disabled
[    0.950772] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.950774] pci 0000:00:0f.0: PME# disabled
[    0.950896] pci 0000:05:06.0: reg 10: [mem 0xeefff000-0xeeffffff pref]
[    0.950937] pci 0000:05:06.1: reg 10: [mem 0xeeffe000-0xeeffefff pref]
[    0.950984] pci 0000:05:08.0: reg 10: [mem 0xeffff800-0xefffffff]
[    0.950988] pci 0000:05:08.0: reg 14: [mem 0xefff8000-0xefffbfff]
[    0.951011] pci 0000:05:08.0: supports D1 D2
[    0.951012] pci 0000:05:08.0: PME# supported from D0 D1 D2 D3hot
[    0.951015] pci 0000:05:08.0: PME# disabled
[    0.951034] pci 0000:00:06.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.960004] pci 0000:00:06.0:   bridge window [mem 0xeff00000-0xefffffff]
[    0.960006] pci 0000:00:06.0:   bridge window [mem
0xeef00000-0xeeffffff pref]
[    0.960042] pci 0000:04:00.0: reg 10: [mem 0xefeffc00-0xefeffc7f 64bit]
[    0.960055] pci 0000:04:00.0: reg 18: [mem 0xefef8000-0xefefbfff 64bit]
[    0.960062] pci 0000:04:00.0: reg 20: [io  0xec00-0xec7f]
[    0.960074] pci 0000:04:00.0: reg 30: [mem 0xefe00000-0xefe7ffff pref]
[    0.960106] pci 0000:04:00.0: supports D1 D2
[    0.960120] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.970027] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    0.975250] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.975252] pci 0000:00:0b.0:   bridge window [mem 0xefe00000-0xefefffff]
[    0.975281] pci 0000:03:00.0: reg 10: [mem 0xefdf0000-0xefdfffff 64bit]
[    0.975325] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.975328] pci 0000:03:00.0: PME# disabled
[    0.990028] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.995377] pci 0000:00:0c.0:   bridge window [mem 0xefd00000-0xefdfffff]
[    0.995406] pci 0000:02:00.0: reg 10: [mem 0xefcf0000-0xefcfffff 64bit]
[    0.995451] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.995454] pci 0000:02:00.0: PME# disabled
[    1.010027] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.015250] pci 0000:00:0d.0:   bridge window [mem 0xefc00000-0xefcfffff]
[    1.015266] pci 0000:01:00.0: reg 10: [mem 0xe0000000-0xe7ffffff pref]
[    1.015270] pci 0000:01:00.0: reg 14: [io  0xd000-0xd0ff]
[    1.015274] pci 0000:01:00.0: reg 18: [mem 0xefbf0000-0xefbfffff]
[    1.015284] pci 0000:01:00.0: reg 30: [mem 0xefbc0000-0xefbdffff pref]
[    1.015296] pci 0000:01:00.0: supports D1 D2
[    1.015312] pci 0000:01:00.1: reg 10: [mem 0xefbe0000-0xefbeffff]
[    1.015335] pci 0000:01:00.1: supports D1 D2
[    1.015344] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    1.020025] pci 0000:00:0f.0: PCI bridge to [bus 01-01]
[    1.030002] pci 0000:00:0f.0:   bridge window [io  0xd000-0xdfff]
[    1.030004] pci 0000:00:0f.0:   bridge window [mem 0xefb00000-0xefbfffff]
[    1.030007] pci 0000:00:0f.0:   bridge window [mem
0xe0000000-0xe7ffffff 64bit pref]
[    1.030016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.030219] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.030275] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    1.030325] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.030367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    1.030408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    1.040295] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    1.046720] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    1.053091] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    1.061751] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    1.069222] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *10
[    1.072055] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    1.082053] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    1.090053] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *5
[    1.096539] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    1.102043] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    1.110377] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
[    1.116948] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.122954] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *11
[    1.131458] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    1.138036] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
[    1.141968] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    1.150793] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *10
[    1.157403] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    1.162936] ACPI: PCI Interrupt Link [LSA2] (IRQs 20 21 22 23) *10
[    1.171624] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.178100] vgaarb: loaded
[    1.180048] SCSI subsystem initialized
[    1.183933] libata version 3.00 loaded.
[    1.183933] usbcore: registered new interface driver usbfs
[    1.190012] usbcore: registered new interface driver hub
[    1.195326] usbcore: registered new device driver usb
[    1.200017] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    1.206355] PCI: Using ACPI for IRQ routing
[    1.210002] PCI: pci_cache_line_size set to 64 bytes
[    1.210082] NetLabel: Initializing
[    1.213423] NetLabel:  domain hash size = 128
[    1.220002] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.224975] NetLabel:  unlabeled traffic allowed by default
[    1.230001]
[    1.230002] printing PIC contents
[    1.230005] ... PIC  IMR: ffff
[    1.230009] ... PIC  IRR: 0000
[    1.230017] ... PIC  ISR: 0000
[    1.230020] ... PIC ELCR: 0e20
[    1.230022] printing local APIC contents on CPU#0/0:
[    1.230023] ... APIC ID:      00000000 (0)
[    1.234125] ... APIC VERSION: 80050010
[    1.237879] ... APIC TASKPRI: 00000000 (00)
[    1.237880] ... APIC ARBPRI: 000000e0 (e0)
[    1.237881] ... APIC PROCPRI: 00000000
[    1.237882] ... APIC LDR: 01000000
[    1.237883] ... APIC DFR: ffffffff
[    1.237884] ... APIC SPIV: 000001ff
[    1.237885] ... APIC ISR field:
[    1.237886] 0000000000000000000000000000000000000000000000000000000000000000
[    1.240000] ... APIC TMR field:
[    1.240000] 0000000000000000000000000000000000000000000000000000000000000000
[    1.240000] ... APIC IRR field:
[    1.240000] 0000000000000000000000000000000000000000000000000000000000008000
[    1.240000] ... APIC ESR: 00000000
[    1.240000] ... APIC ICR: 000008fd
[    1.240000] ... APIC ICR2: 08000000
[    1.240000] ... APIC LVTT: 000200ef
[    1.240000] ... APIC LVTPC: 00000400
[    1.240000] ... APIC LVT0: 00010700
[    1.240000] ... APIC LVT1: 00000400
[    1.240000] ... APIC LVTERR: 000000fe
[    1.240000] ... APIC TMICT: 0001e847
[    1.240000] ... APIC TMCCT: 000174b3
[    1.240000] ... APIC TDCR: 00000003
[    1.240000] ... APIC EFEAT: 00010003
[    1.240000] ... APIC ECTRL: 00000000
[    1.240000] ... APIC EILVT0: 000000f9
[    1.240000]
[    1.240001] number of MP IRQ sources: 15.
[    1.240002] number of IO-APIC #4 registers: 24.
[    1.240003] testing the IO APIC.......................
[    1.245142]
[    1.250001] IO APIC #4......
[    1.250002] .... register #00: 04000000
[    1.250003] .......    : physical APIC id: 04
[    1.250004] .......    : Delivery Type: 0
[    1.250005] .......    : LTS          : 0
[    1.250006] .... register #01: 00170011
[    1.250007] .......     : max redirection entries: 0017
[    1.250008] .......     : PRQ implemented: 0
[    1.250009] .......     : IO APIC version: 0011
[    1.250010] .... register #02: 04000000
[    1.250011] .......     : arbitration: 04
[    1.250012] .... IRQ redirection table:
[    1.250013]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.250018]  00 000 1    0    0   0   0    0    0    00
[    1.250023]  01 00F 0    0    0   0   0    1    1    31
[    1.250028]  02 00F 0    0    0   0   0    1    1    30
[    1.250033]  03 00F 0    0    0   0   0    1    1    33
[    1.250039]  04 00F 0    0    0   0   0    1    1    34
[    1.250044]  05 00F 1    0    0   0   0    1    1    35
[    1.250049]  06 00F 0    0    0   0   0    1    1    36
[    1.250054]  07 00F 0    0    0   0   0    1    1    37
[    1.250059]  08 00F 0    0    0   0   0    1    1    38
[    1.250064]  09 00F 0    1    0   0   0    1    1    39
[    1.250069]  0a 00F 1    0    0   0   0    1    1    3A
[    1.250075]  0b 00F 1    0    0   0   0    1    1    3B
[    1.250080]  0c 00F 0    0    0   0   0    1    1    3C
[    1.250085]  0d 00F 0    0    0   0   0    1    1    3D
[    1.250090]  0e 00F 0    0    0   0   0    1    1    3E
[    1.250095]  0f 00F 0    0    0   0   0    1    1    3F
[    1.250100]  10 000 1    0    0   0   0    0    0    00
[    1.250106]  11 000 1    0    0   0   0    0    0    00
[    1.250111]  12 000 1    0    0   0   0    0    0    00
[    1.250116]  13 000 1    0    0   0   0    0    0    00
[    1.250121]  14 000 1    0    0   0   0    0    0    00
[    1.250126]  15 000 1    0    0   0   0    0    0    00
[    1.250132]  16 000 1    0    0   0   0    0    0    00
[    1.250137]  17 000 1    0    0   0   0    0    0    00
[    1.250139] IRQ to pin mappings:
[    1.250140] IRQ0 -> 0:2
[    1.250141] IRQ1 -> 0:1
[    1.250143] IRQ3 -> 0:3
[    1.250144] IRQ4 -> 0:4
[    1.250146] IRQ5 -> 0:5
[    1.250147] IRQ6 -> 0:6
[    1.250148] IRQ7 -> 0:7
[    1.250150] IRQ8 -> 0:8
[    1.250151] IRQ9 -> 0:9
[    1.250153] IRQ10 -> 0:10
[    1.250154] IRQ11 -> 0:11
[    1.250155] IRQ12 -> 0:12
[    1.250157] IRQ13 -> 0:13
[    1.250158] IRQ14 -> 0:14
[    1.250160] IRQ15 -> 0:15
[    1.250163] .................................... done.
[    1.255305] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.260005] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.265102] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.300006] Switching to clocksource hpet
[    1.304030] Slow work thread pool: Starting up
[    1.304679] Slow work thread pool: Ready
[    1.308661] FS-Cache: Loaded
[    1.311643] CacheFiles: Loaded
[    1.314731] pnp: PnP ACPI init
[    1.317801] ACPI: bus type pnp registered
[    1.322184] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8
Mode:0 Active:0)
[    1.322315] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13
Mode:0 Active:0)
[    1.323185] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7
Mode:0 Active:0)
[    1.324794] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4
Mode:0 Active:0)
[    1.324931] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1
Mode:0 Active:0)
[    1.325029] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12
Mode:0 Active:0)
[    1.326726] pnp: PnP ACPI: found 14 devices
[    1.330913] ACPI: ACPI bus type pnp unregistered
[    1.335582] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    1.341501] system 00:06: [io  0x07b0-0x07df] has been reserved
[    1.347455] system 00:06: [io  0x0800-0x080f] has been reserved
[    1.353513] system 00:06: [io  0x0bb0-0x0bdf] has been reserved
[    1.359432] system 00:06: [io  0x2000-0x207f] has been reserved
[    1.365386] system 00:06: [io  0x2080-0x20ff] has been reserved
[    1.371305] system 00:06: [io  0x2400-0x247f] has been reserved
[    1.377259] system 00:06: [io  0x2480-0x24ff] has been reserved
[    1.383197] system 00:06: [io  0x2800-0x287f] has been reserved
[    1.389115] system 00:06: [io  0x2880-0x28ff] has been reserved
[    1.395070] system 00:06: [io  0x2c00-0x2c7f] has been reserved
[    1.400988] system 00:06: [io  0x2c80-0x2cff] has been reserved
[    1.406945] system 00:06: [mem 0xfee01000-0xfeefffff] has been reserved
[    1.413582] system 00:06: [mem 0xefa80000-0xefabffff] has been reserved
[    1.420356] system 00:06: [mem 0xffb00000-0xffbfffff] has been reserved
[    1.427006] system 00:06: [mem 0xfff00000-0xffffffff] has been reserved
[    1.433640] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.440601] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.447253] system 00:0c: [io  0x0290-0x0297] has been reserved
[    1.453189] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.460144] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    1.466796] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.473781] system 00:0d: [mem 0x00100000-0xdfffffff] could not be reserved
[    1.480885] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
[    1.493409] pci 0000:00:06.0: PCI bridge to [bus 05-05]
[    1.498634] pci 0000:00:06.0:   bridge window [io  disabled]
[    1.504330] pci 0000:00:06.0:   bridge window [mem 0xeff00000-0xefffffff]
[    1.511113] pci 0000:00:06.0:   bridge window [mem
0xeef00000-0xeeffffff pref]
[    1.518372] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.523616] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    1.529713] pci 0000:00:0b.0:   bridge window [mem 0xefe00000-0xefefffff]
[    1.536535] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    1.542647] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.548009] pci 0000:00:0c.0:   bridge window [io  disabled]
[    1.553695] pci 0000:00:0c.0:   bridge window [mem 0xefd00000-0xefdfffff]
[    1.560479] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    1.566610] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.571834] pci 0000:00:0d.0:   bridge window [io  disabled]
[    1.577519] pci 0000:00:0d.0:   bridge window [mem 0xefc00000-0xefcfffff]
[    1.584323] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    1.590415] pci 0000:00:0f.0: PCI bridge to [bus 01-01]
[    1.595676] pci 0000:00:0f.0:   bridge window [io  0xd000-0xdfff]
[    1.601769] pci 0000:00:0f.0:   bridge window [mem 0xefb00000-0xefbfffff]
[    1.608729] pci 0000:00:0f.0:   bridge window [mem
0xe0000000-0xe7ffffff 64bit pref]
[    1.616503] pci 0000:00:06.0: setting latency timer to 64
[    1.616508] pci 0000:00:0b.0: setting latency timer to 64
[    1.616512] pci 0000:00:0c.0: setting latency timer to 64
[    1.616516] pci 0000:00:0d.0: setting latency timer to 64
[    1.616520] pci 0000:00:0f.0: setting latency timer to 64
[    1.616523] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    1.616525] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    1.616527] pci_bus 0000:05: resource 1 [mem 0xeff00000-0xefffffff]
[    1.616529] pci_bus 0000:05: resource 2 [mem 0xeef00000-0xeeffffff pref]
[    1.616531] pci_bus 0000:05: resource 3 [io  0x0000-0xffff]
[    1.616532] pci_bus 0000:05: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    1.616534] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    1.616536] pci_bus 0000:04: resource 1 [mem 0xefe00000-0xefefffff]
[    1.616538] pci_bus 0000:03: resource 1 [mem 0xefd00000-0xefdfffff]
[    1.616540] pci_bus 0000:02: resource 1 [mem 0xefc00000-0xefcfffff]
[    1.616542] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    1.616544] pci_bus 0000:01: resource 1 [mem 0xefb00000-0xefbfffff]
[    1.616545] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xe7ffffff
64bit pref]
[    1.616583] NET: Registered protocol family 2
[    1.621080] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.629798] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    1.642203] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.649506] TCP: Hash tables configured (established 524288 bind 65536)
[    1.656148] TCP reno registered
[    1.659322] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.665402] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.672162] NET: Registered protocol family 1
[    1.676729] RPC: Registered udp transport module.
[    1.681435] RPC: Registered tcp transport module.
[    1.686171] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.714328] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.719859] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.725424] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.730952] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.736509] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.742044] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.747613] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.753171] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.758721] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.764273] pci 0000:01:00.0: Boot video device
[    1.764277] PCI: CLS 64 bytes, default 64
[    1.764371] PCI-DMA: Disabling AGP.
[    1.768101] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.773690] PCI-DMA: using GART IOMMU.
[    1.777450] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.789902] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.799581] VFS: Disk quotas dquot_6.5.2
[    1.803604] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.810211] FS-Cache: Netfs 'nfs' registered for caching
[    1.815814] SGI XFS with ACLs, security attributes, large
block/inode numbers, no debug enabled
[    1.825410] SGI XFS Quota Management subsystem
[    1.829866] msgmni has been set to 7925
[    1.834647] alg: No test for stdrng (krng)
[    1.842889] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.848963] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 254)
[    1.856381] io scheduler noop registered
[    1.860389] io scheduler cfq registered (default)
[    1.865282] pcieport 0000:00:0b.0: setting latency timer to 64
[    1.865296]   alloc irq_desc for 24 on node 0
[    1.865298]   alloc kstat_irqs on node 0
[    1.865305] pcieport 0000:00:0b.0: irq 24 for MSI/MSI-X
[    1.865422] pcieport 0000:00:0c.0: setting latency timer to 64
[    1.865433]   alloc irq_desc for 25 on node 0
[    1.865434]   alloc kstat_irqs on node 0
[    1.865438] pcieport 0000:00:0c.0: irq 25 for MSI/MSI-X
[    1.865542] pcieport 0000:00:0d.0: setting latency timer to 64
[    1.865552]   alloc irq_desc for 26 on node 0
[    1.865553]   alloc kstat_irqs on node 0
[    1.865557] pcieport 0000:00:0d.0: irq 26 for MSI/MSI-X
[    1.865662] pcieport 0000:00:0f.0: setting latency timer to 64
[    1.865673]   alloc irq_desc for 27 on node 0
[    1.865674]   alloc kstat_irqs on node 0
[    1.865677] pcieport 0000:00:0f.0: irq 27 for MSI/MSI-X
[    1.866142] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.874515] ACPI: Power Button [PWRB]
[    1.878276] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.885690] ACPI: Power Button [PWRF]
[    1.893611] Real Time Clock Driver v1.12b
[    1.897888] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    1.906863] Hangcheck: Using get_cycles().
[    1.911030] [drm] Initialized drm 1.1.0 20060810
[    1.916350] [drm] radeon kernel modesetting enabled.
[    1.921665] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    1.927412]   alloc irq_desc for 19 on node 0
[    1.927413]   alloc kstat_irqs on node 0
[    1.927416] IOAPIC[0]: Set routing entry (4-19 -> 0x69 -> IRQ 19
Mode:1 Active:1)
[    1.927422] radeon 0000:01:00.0: PCI INT A -> Link[LNEB] -> GSI 19
(level, low) -> IRQ 19
[    1.935630] radeon 0000:01:00.0: setting latency timer to 64
[    1.937750] [drm] radeon: Initializing kernel modesetting.
[    1.943414] [drm] register mmio base: 0xEFBF0000
[    1.948029] [drm] register mmio size: 65536
[    1.953027] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[    1.958707] [drm] Generation 2 PCI interface, using max accessible memory
[    1.965527] [drm] radeon: VRAM 128M
[    1.969021] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[    1.974703] [drm] radeon: GTT 512M
[    1.978114] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[    1.983730]   alloc irq_desc for 28 on node 0
[    1.983731]   alloc kstat_irqs on node 0
[    1.983739] radeon 0000:01:00.0: irq 28 for MSI/MSI-X
[    1.983743] [drm] radeon: using MSI.
[    1.987348] [drm] radeon: irq initialized.
[    1.992342] [drm] Detected VRAM RAM=128M, BAR=128M
[    1.997142] [drm] RAM width 64bits DDR
[    2.001023] [TTM] Zone  kernel: Available graphics memory: 2028910 kiB.
[    2.007648] [drm] radeon: 128M of VRAM memory ready
[    2.012560] [drm] radeon: 512M of GTT memory ready.
[    2.017454] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.024681] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[    2.030591] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[    2.036770] [drm] radeon: cp idle (0x10000C03)
[    2.041372] [drm] Loading R300 Microcode
[    2.045298] platform radeon_cp.0: firmware: using built-in firmware
radeon/R300_cp.bin
[    2.053395] [drm] radeon: ring at 0x0000000020000000
[    2.058382] [drm] ring test succeeded in 1 usecs
[    2.063107] [drm] radeon: ib pool ready.
[    2.067086] [drm] ib test succeeded in 0 usecs
[    2.071764] [drm] Default TV standard: NTSC
[    2.075950] [drm] 27.000000000 MHz TV ref clk
[    2.080334] [drm] DFP table revision: 4
[    2.084342] [drm] Default TV standard: NTSC
[    2.088526] [drm] 27.000000000 MHz TV ref clk
[    2.093011] [drm] Radeon Display Connectors
[    2.097192] [drm] Connector 0:
[    2.100275] [drm]   VGA
[    2.102736] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    2.108737] [drm]   Encoders:
[    2.111740] [drm]     CRT1: INTERNAL_DAC1
[    2.115757] [drm] Connector 1:
[    2.118819] [drm]   DVI-I
[    2.121473] [drm]   HPD1
[    2.124011] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    2.130034] [drm]   Encoders:
[    2.133006] [drm]     CRT2: INTERNAL_DAC2
[    2.137020] [drm]     DFP1: INTERNAL_TMDS1
[    2.141147] [drm] Connector 2:
[    2.144212] [drm]   S-video
[    2.147014] [drm]   Encoders:
[    2.150012] [drm]     TV1: INTERNAL_DAC2
[    2.378887] [drm] fb mappable at 0xE00C0000
[    2.383114] [drm] vram apper at 0xE0000000
[    2.387213] [drm] size 5242880
[    2.390296] [drm] fb depth is 24
[    2.393534] [drm]    pitch is 5120
[    2.508657] Console: switching to colour frame buffer device 160x64
[    2.519785] fb0: radeondrmfb frame buffer device
[    2.524460] registered panic notifier
[    2.528137] [drm] Initialized radeon 2.0.0 20080528 for
0000:01:00.0 on minor 0
[    2.535619] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    2.542159] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.548527] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.554578] sata_sil24 0000:04:00.0: version 1.1
[    2.554598] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
19 (level, low) -> IRQ 19
[    2.563254]   alloc irq_desc for 29 on node 0
[    2.563255]   alloc kstat_irqs on node 0
[    2.563268] sata_sil24 0000:04:00.0: irq 29 for MSI/MSI-X
[    2.563275] sata_sil24 0000:04:00.0: Using MSI
[    2.567735] sata_sil24 0000:04:00.0: setting latency timer to 64
[    2.567980] scsi0 : sata_sil24
[    2.571235] scsi1 : sata_sil24
[    2.574416] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 29
[    2.581771] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 29
[    2.589225] sata_nv 0000:00:05.0: version 3.5
[    2.589512] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    2.595302]   alloc irq_desc for 23 on node 0
[    2.595303]   alloc kstat_irqs on node 0
[    2.595306] IOAPIC[0]: Set routing entry (4-23 -> 0x81 -> IRQ 23
Mode:1 Active:1)
[    2.595312] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23
(level, low) -> IRQ 23
[    2.603618] sata_nv 0000:00:05.0: Using SWNCQ mode
[    2.608453] sata_nv 0000:00:05.0: setting latency timer to 64
[    2.608584] scsi2 : sata_nv
[    2.611533] scsi3 : sata_nv
[    2.614538] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 23
[    2.621715] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 23
[    2.629195] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    2.634974]   alloc irq_desc for 22 on node 0
[    2.634976]   alloc kstat_irqs on node 0
[    2.634979] IOAPIC[0]: Set routing entry (4-22 -> 0x89 -> IRQ 22
Mode:1 Active:1)
[    2.634984] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22
(level, low) -> IRQ 22
[    2.643293] sata_nv 0000:00:05.1: Using SWNCQ mode
[    2.648123] sata_nv 0000:00:05.1: setting latency timer to 64
[    2.648248] scsi4 : sata_nv
[    2.651205] scsi5 : sata_nv
[    2.654211] ata5: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 22
[    2.661393] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 22
[    2.668898] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    2.674678]   alloc irq_desc for 21 on node 0
[    2.674679]   alloc kstat_irqs on node 0
[    2.674681] IOAPIC[0]: Set routing entry (4-21 -> 0x91 -> IRQ 21
Mode:1 Active:1)
[    2.674687] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21
(level, low) -> IRQ 21
[    2.682995] sata_nv 0000:00:05.2: Using SWNCQ mode
[    2.687825] sata_nv 0000:00:05.2: setting latency timer to 64
[    2.687957] scsi6 : sata_nv
[    2.690906] scsi7 : sata_nv
[    2.693930] ata7: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 21
[    2.701113] ata8: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 21
[    2.708444] pata_amd 0000:00:04.0: version 0.4.1
[    2.708471] pata_amd 0000:00:04.0: setting latency timer to 64
[    2.708539] scsi8 : pata_amd
[    2.711557] scsi9 : pata_amd
[    2.715393] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    2.722401] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    2.729644] tg3.c:v3.106 (January 12, 2010)
[    2.734116] ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 18
[    2.741002]   alloc irq_desc for 18 on node 0
[    2.741003]   alloc kstat_irqs on node 0
[    2.741006] IOAPIC[0]: Set routing entry (4-18 -> 0x99 -> IRQ 18
Mode:1 Active:1)
[    2.741012] tg3 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 18
(level, low) -> IRQ 18
[    2.750106] tg3 0000:03:00.0: setting latency timer to 64
[    2.794270] eth0: Tigon3 [partno(BCM95700A6) rev b002] (PCI
Express) MAC address 00:17:31:f9:cc:c5
[    2.804463] eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet)
(WireSpeed[1])
[    2.813289] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.820934] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.827753] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[    2.834847]   alloc irq_desc for 17 on node 0
[    2.834848]   alloc kstat_irqs on node 0
[    2.834851] IOAPIC[0]: Set routing entry (4-17 -> 0xa1 -> IRQ 17
Mode:1 Active:1)
[    2.834857] tg3 0000:02:00.0: PCI INT A -> Link[LNED] -> GSI 17
(level, low) -> IRQ 17
[    2.844165] tg3 0000:02:00.0: setting latency timer to 64
[    2.894272] eth1: Tigon3 [partno(BCM95700A6) rev b002] (PCI
Express) MAC address 00:18:f3:44:df:ea
[    2.904672] eth1: attached PHY is 5787 (10/100/1000Base-T Ethernet)
(WireSpeed[1])
[    2.913711] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.921564] eth1: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.928650] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[    2.935951]   alloc irq_desc for 16 on node 0
[    2.935953]   alloc kstat_irqs on node 0
[    2.935955] IOAPIC[0]: Set routing entry (4-16 -> 0xa9 -> IRQ 16
Mode:1 Active:1)
[    2.935961] ohci1394 0000:05:08.0: PCI INT A -> Link[LNKA] -> GSI
16 (level, low) -> IRQ 16
[    3.004101] ata5: SATA link down (SStatus 0 SControl 300)
[    3.010053] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
MMIO=[effff800-efffffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.010390] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
[    3.010488] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.010766] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
[    3.010768]   alloc irq_desc for 20 on node 0
[    3.010769]   alloc kstat_irqs on node 0
[    3.010771] IOAPIC[0]: Set routing entry (4-20 -> 0xb1 -> IRQ 20
Mode:1 Active:1)
[    3.010777] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI
20 (level, low) -> IRQ 20
[    3.010786] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    3.010788] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    3.010794] ehci_hcd 0000:00:02.1: new USB bus registered, assigned
bus number 1
[    3.010823] ehci_hcd 0000:00:02.1: debug port 1
[    3.010831] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    3.010848] ehci_hcd 0000:00:02.1: irq 20, io mem 0xefaebc00
[    3.100298] ata7: SATA link down (SStatus 0 SControl 300)
[    3.107516] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.110053] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.123010] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.131574] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.140580] usb usb1: Product: EHCI Host Controller
[    3.147233] usb usb1: Manufacturer: Linux 2.6.33-rc6 ehci_hcd
[    3.154785] usb usb1: SerialNumber: 0000:00:02.1
[    3.161336] hub 1-0:1.0: USB hub found
[    3.166859] hub 1-0:1.0: 10 ports detected
[    3.172812] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.177497] ata3.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    3.177500] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.197737] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    3.205288] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI
23 (level, low) -> IRQ 23
[    3.215496] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    3.215498] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    3.222553] ohci_hcd 0000:00:02.0: new USB bus registered, assigned
bus number 2
[    3.231779] ohci_hcd 0000:00:02.0: irq 23, io mem 0xefaf8000
[    3.252462] ata3.00: configured for UDMA/133
[    3.292021] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.300689] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.309727] usb usb2: Product: OHCI Host Controller
[    3.316479] usb usb2: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
[    3.324070] usb usb2: SerialNumber: 0000:00:02.0
[    3.330625] hub 2-0:1.0: USB hub found
[    3.336171] hub 2-0:1.0: 10 ports detected
[    3.342157] Initializing USB Mass Storage driver...
[    3.348896] usbcore: registered new interface driver usb-storage
[    3.356725] USB Mass Storage support registered.
[    3.363214] usbcore: registered new interface driver libusual
[    3.370827] usbcore: registered new interface driver ums-alauda
[    3.378616] usbcore: registered new interface driver ums-cypress
[    3.386476] usbcore: registered new interface driver ums-datafab
[    3.394311] usbcore: registered new interface driver ums-freecom
[    3.402114] usbcore: registered new interface driver ums-isd200
[    3.409806] usbcore: registered new interface driver ums-jumpshot
[    3.417651] usbcore: registered new interface driver ums-karma
[    3.425195] usbcore: registered new interface driver ums-sddr09
[    3.432787] usbcore: registered new interface driver ums-sddr55
[    3.440369] usbcore: registered new interface driver ums-usbat
[    3.447875] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    3.459304] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.465923] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.472707] mice: PS/2 mouse device common for all mice
[    3.479794] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.487960] I2O subsystem v1.325
[    3.492715] i2o: max drivers = 8
[    3.497713] i2c /dev entries driver
[    3.500024] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    3.513148] i2c i2c-2: nForce2 SMBus adapter at 0x2a00
[    3.519872] i2c i2c-3: nForce2 SMBus adapter at 0x2a80
[    3.526493] Linux video capture interface: v2.00
[    3.532911] bttv: driver version 0.9.18 loaded
[    3.538742] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    3.547049] bttv: Bt8xx card found (0).
[    3.552582] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
[    3.559721] bttv 0000:05:06.0: PCI INT A -> Link[LNKC] -> GSI 19
(level, low) -> IRQ 19
[    3.569178] bttv0: Bt878 (rev 17) at 0000:05:06.0, irq: 19,
latency: 64, mmio: 0xeefff000
[    3.578828] bttv0: detected: Hauppauge WinTV [card=10], PCI
subsystem ID is 0070:13eb
[    3.588134] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[    3.595778] IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[    3.603982] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
[    3.606480] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[    3.643810] tveeprom 4-0050: Hauppauge model 61344, rev D421, serial# 3902813
[    3.652441] tveeprom 4-0050: tuner model is Philips FM1216 (idx 21, type 5)
[    3.660881] tveeprom 4-0050: TV standards PAL(B/G) (eeprom 0x04)
[    3.668349] tveeprom 4-0050: audio processor is MSP3415 (idx 6)
[    3.675762] tveeprom 4-0050: has radio
[    3.680978] bttv0: Hauppauge eeprom indicates model#61344
[    3.687842] bttv0: tuner type=5
[    3.697591] msp3400 4-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
[    3.705439] msp3400 4-0040: msp3400 supports nicam, mode is autodetect
[    3.713763] usb 2-9: new low speed USB device using ohci_hcd and address 2
[    3.716813] tuner 4-0061: chip found @ 0xc2 (bt878 #0 [sw])
[    3.717088] tuner-simple 4-0061: creating new instance
[    3.717091] tuner-simple 4-0061: type set to 5 (Philips PAL_BG
(FI1216 and compatibles))
[    3.717773] bttv0: registered device video0
[    3.717815] bttv0: registered device vbi0
[    3.717858] bttv0: registered device radio0
[    3.726765] bttv0: PLL: 28636363 => 35468950 .. ok
[    3.792612] input: i2c IR (Hauppauge) as /devices/virtual/input/input4
[    3.800646] ir-kbd-i2c: i2c IR (Hauppauge) detected at
i2c-4/4-0018/ir0 [bt878 #0 [sw]]
[    3.978029] usb 2-9: New USB device found, idVendor=062a, idProduct=0000
[    3.986225] usb 2-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.342755] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000c4c261]
[    4.682557] k8temp 0000:00:18.3: Temperature readouts might be
wrong - check erratum #141
[    4.692362] k8temp 0000:00:19.3: Temperature readouts might be
wrong - check erratum #141
[    4.702172] md: raid1 personality registered for level 1
[    4.709190] device-mapper: uevent: version 1.0.3
[    4.715846] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05)
initialised: dm-devel@redhat.com
[    4.725849] EDAC MC: Ver: 2.1.0 Jan 30 2010
[    4.731708] EDAC amd64_edac:  Ver: 3.3.0 Jan 30 2010
[    4.738260] EDAC amd64: ECC is enabled by BIOS.
[    4.744421] EDAC amd64: ECC is enabled by BIOS.
[    4.750582] EDAC MC: Rev F or later detected
[    4.750591] EDAC MC: DCT0 chip selects:
[    4.750593] EDAC MC:  0:  1024MB 1:  1024MB
[    4.750595] EDAC MC:  2:     0MB 3:     0MB
[    4.750596] EDAC MC:  4:     0MB 5:     0MB
[    4.750597] EDAC MC:  6:     0MB 7:     0MB
[    4.750740] EDAC MC0: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:18.2
[    4.759715] EDAC MC: Rev F or later detected
[    4.759721] EDAC MC: DCT0 chip selects:
[    4.759722] EDAC MC:  0:  1024MB 1:  1024MB
[    4.759724] EDAC MC:  2:     0MB 3:     0MB
[    4.759725] EDAC MC:  4:     0MB 5:     0MB
[    4.759726] EDAC MC:  6:     0MB 7:     0MB
[    4.759860] EDAC MC1: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:19.2
[    4.768926] EDAC PCI0: Giving out device to module 'amd64_edac'
controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[    4.781873] cpuidle: using governor ladder
[    4.783805] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    4.790153] ata1.00: ATA-7: SAMSUNG HD642JJ, 1AA01113, max UDMA7
[    4.790155] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.796569] ata1.00: configured for UDMA/100
[    4.796680] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
HD642JJ  1AA0 PQ: 0 ANSI: 5
[    4.796967] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks:
(640 GB/596 GiB)
[    4.797064] sd 0:0:0:0: [sda] Write Protect is off
[    4.797066] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.797083] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.853846] cpuidle: using governor menu
[    4.859583]  sda:
[    4.862758] usbcore: registered new interface driver hiddev
[    4.878285]  sda1 sda2 sda3
[    4.882941] input: HID 062a:0000 as
/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input5
[    4.893886] generic-usb 0003:062A:0000.0001: input,hidraw0: USB HID
v1.10 Mouse [HID 062a:0000] on usb-0000:00:02.0-9/input0
[    4.894100] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.913429] usbcore: registered new interface driver usbhid
[    4.920813] usbhid: USB HID core driver
[    4.926619] Bt87x 0000:05:06.1: PCI INT A -> Link[LNKC] -> GSI 19
(level, low) -> IRQ 19
[    4.936752] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[    4.945334] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
[    4.952919] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI
22 (level, low) -> IRQ 22
[    4.963226]   alloc irq_desc for 30 on node 0
[    4.963227]   alloc kstat_irqs on node 0
[    4.963233] HDA Intel 0000:00:06.1: irq 30 for MSI/MSI-X
[    4.963247] HDA Intel 0000:00:06.1: setting latency timer to 64
[    6.320364] ALSA device list:
[    6.325190]   #0: HDA NVidia at 0xefafc000 irq 30
[    6.331695]   #1: Brooktree Bt878 at 0xeeffe000, irq 19
[    6.339001] Initializing XFRM netlink socket
[    6.345083] NET: Registered protocol family 17
[    6.351311] NET: Registered protocol family 15
[    6.357579] powernow-k8: Found 2 Dual-Core AMD Opteron(tm)
Processor 2218 processors (4 cpu cores) (version 2.20.00)
[    6.369988] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    6.377493] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    6.384971] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    6.392334] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    6.399713] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    6.407149] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    6.415117] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    6.422508] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    6.429862] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    6.437149] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    6.444392] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    6.451702] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    7.010045] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    7.020026] Clocksource tsc unstable (delta = -301544377 ns)
[    7.036659] ata2.00: ATA-7: SAMSUNG HD642JJ, 1AA01113, max UDMA7
[    7.044334] ata2.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.059201] ata2.00: configured for UDMA/100
[    7.065175] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG
HD642JJ  1AA0 PQ: 0 ANSI: 5
[    7.075400] sd 1:0:0:0: [sdb] 1250263728 512-byte logical blocks:
(640 GB/596 GiB)
[    7.075431] scsi 2:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    7.075695] sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks:
(320 GB/298 GiB)
[    7.075763] sd 2:0:0:0: [sdc] Write Protect is off
[    7.075765] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.075784] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.075920]  sdc: sdc1 sdc2
[    7.141220] sd 1:0:0:0: [sdb] Write Protect is off
[    7.141445] sd 2:0:0:0: [sdc] Attached SCSI disk
[    7.159570] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.159618] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.173372]  sdb: sdb1 sdb2 sdb3
[    7.199110] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.410536] ata4: SATA link down (SStatus 0 SControl 300)
[    7.764288] ata6: SATA link down (SStatus 0 SControl 300)
[    8.114282] ata8: SATA link down (SStatus 0 SControl 300)
[    8.123948] ata10: port disabled. ignoring.
[    8.123993] md: Skipping autodetection of RAID arrays.
(raid=autodetect will force)
[    8.157760] XFS mounting filesystem sdc1
[    8.242836] Ending clean XFS mount for filesystem: sdc1
[    8.242919] VFS: Mounted root (xfs filesystem) readonly on device 8:33.
[    8.253886] Freeing unused kernel memory: 1208k freed
[    9.864435] udev: starting version 146
[    9.953137] udev: renamed network interface eth2 to eth4
[   19.404471]   alloc irq_desc for 31 on node 0
[   19.404479]   alloc kstat_irqs on node 0
[   19.404498] tg3 0000:03:00.0: irq 31 for MSI/MSI-X
[   22.217636] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   22.217644] tg3: eth0: Flow control is on for TX and on for RX.
[   23.888028]   alloc irq_desc for 32 on node 0
[   23.888049]   alloc kstat_irqs on node 0
[   23.888082] tg3 0000:02:00.0: irq 32 for MSI/MSI-X
[   26.558399] tg3: eth1: Link is up at 1000 Mbps, full duplex.
[   26.558406] tg3: eth1: Flow control is on for TX and on for RX.
[   59.501508] XFS mounting filesystem sdb2
[   59.613072] Ending clean XFS mount for filesystem: sdb2
[   86.463814] do_IRQ: 0.165 No irq handler for vector (irq -1)
[   86.463832] do_IRQ: 3.165 No irq handler for vector (irq -1)
[   86.463848] do_IRQ: 1.165 No irq handler for vector (irq -1)
[   86.463867] do_IRQ: 2.165 No irq handler for vector (irq -1)
[  116.950064] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[  116.950075] ata2.00: failed command: READ FPDMA QUEUED
[  116.950086] ata2.00: cmd 60/00:00:ad:65:d9/01:00:01:00:00/40 tag 0
ncq 131072 in
[  116.950089]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  116.950095] ata2.00: status: { DRDY }
[  116.950100] ata2.00: failed command: READ FPDMA QUEUED
[  116.950109] ata2.00: cmd 60/00:08:ad:64:d9/01:00:01:00:00/40 tag 1
ncq 131072 in
[  116.950112]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  116.950117] ata2.00: status: { DRDY }
[  116.950128] ata2: hard resetting link
[  119.150063] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  119.155017] do_IRQ: 3.165 No irq handler for vector (irq -1)
[  119.155029] do_IRQ: 2.165 No irq handler for vector (irq -1)
[  119.155040] do_IRQ: 0.165 No irq handler for vector (irq -1)
[  119.155049] do_IRQ: 1.165 No irq handler for vector (irq -1)
[  124.150045] ata2.00: qc timeout (cmd 0xec)
[  124.150054] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  124.150059] ata2.00: revalidation failed (errno=-5)
[  124.150066] ata2: hard resetting link
[  126.350058] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  136.350037] ata2.00: qc timeout (cmd 0xec)
[  136.350045] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  136.350049] ata2.00: revalidation failed (errno=-5)
[  136.350055] ata2: limiting SATA link speed to 1.5 Gbps
[  136.350060] ata2: hard resetting link
[  138.550054] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  138.555124] ata2.00: failed to read native max address (err_mask=0x1)
[  138.555128] ata2.00: HPA support seems broken, skipping HPA handling
[  143.550039] ata2.00: qc timeout (cmd 0xef)
[  143.550047] ata2.00: failed to set xfermode (err_mask=0x4)
[  143.550051] ata2.00: disabled
[  143.550066] ata2.00: device reported invalid CHS sector 0
[  143.550079] ata2: hard resetting link
[  145.750059] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  145.750075] ata2: EH complete
[  145.750097] sd 1:0:0:0: [sdb] Unhandled error code
[  145.750102] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  145.750110] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 64 ad 00 01 00 00
[  145.750125] end_request: I/O error, dev sdb, sector 31024301
[  145.750158] sd 1:0:0:0: [sdb] Unhandled error code
[  145.750162] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  145.750169] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 65 ad 00 01 00 00
[  145.750182] end_request: I/O error, dev sdb, sector 31024557
[  145.750201] sd 1:0:0:0: [sdb] Unhandled error code
[  145.750208] sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
[  145.750215] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  145.750224] sd 1:0:0:0: [sdb] Sense not available.
[  145.750230] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  145.750237] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 64 ad 00 00 08 00
[  145.750251] end_request: I/O error, dev sdb, sector 31024301
[  145.750298] sd 1:0:0:0: [sdb] READ CAPACITY failed
[  145.750302] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  145.750308] sd 1:0:0:0: [sdb] Sense not available.
[  145.750386] sd 1:0:0:0: [sdb] Asking for cache data failed
[  145.750390] sd 1:0:0:0: [sdb] Assuming drive cache: write through
[  145.750402] sdb: detected capacity change from 640135028736 to 0
