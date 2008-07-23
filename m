Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYGWRg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYGWRg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYGWRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:36:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:49959 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cDFhjQONUOaeVktaSgc7I/vK0m5BUTX/zqwS/THZLn/Rr63ELbYkrUbeltQw8Mcdgh
         Dr5QCFMGwtYYI4IVr+6K3liHTMgpRs6SF52JVNyoCfbRMKvIkmWATuMHAAwGdfHebrxg
         9t+N1qCVbdFeAYZchBhLRw3xv0ul5jKeuLMCU=
Message-ID: <e6ea6c000807231036n3f5eb5c6udb0f650e959f3dd5@mail.gmail.com>
Date: Wed, 23 Jul 2008 20:36:42 +0300
From: "Yitzhak Sapir" <yitzhaksapir@gmail.com>
To: ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Using DQ35JO motherboard with Q9300 CPU does not boot SMP unless "idle=poll" specified
In-Reply-To: <e6ea6c000807230649g4981f06cmabb1d78ba0e5016b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <e6ea6c000807230649g4981f06cmabb1d78ba0e5016b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6NHb7fq006843

1 - Using DQ35JO motherboard with Q9300 CPU does not boot SMP unless"idle=poll" specified
2 - The motherboard/cpu configuration does not boot linux unless"idle=poll" is specified.  This took quite a while to figure out.  Sohopefully, atthe very least, this report will allow others to work around theproblem.  I hearthe same board with an earlier cpu (Q6600, maybe) has no problems.  Inretrospect, it seems that seeing oops messages in mwait_idle should havesuggested that the appropriate fix would be to not use mwait_idle,that is idle=poll.  But this did not seem so obvious to me when I started,and all kinds of other options were tested.a) acpi=off, nolapic, would allow the system to boot but only one corewould be recognizedb) noapic, intel_iommu=off, irqpoll, pci=routeirq, acpi_serialize,acpi_irq_nobalance,pic=noacpi, framebuffer=false, pci=nommconf, acpi=noirq, acpi=ht,would generally causean oops.  Perhaps some of these also allow the system to boot, butwith one core.A simple program such as:#include <iostream>
static inline void cpuid_count(unsigned int op, unsigned int count,unsigned int *eax, unsigned int *ebx, unsigned int *ecx,               unsigned int *edx){       __asm__("cpuid"               : "=a" (*eax),                 "=b" (*ebx),                 "=c" (*ecx),                 "=d" (*edx)               : "0" (op), "c" (count));}
int main(){       unsigned int eax, t, ncores;
       cpuid_count(4, 0, &eax, &t, &t, &t);       if (eax & 0x1f)               ncores = ((eax >> 26) + 1);       else               ncores = 1;
       std::cout << ncores << std::endl;}--end--would output 4 even if only one core is recognized.
Compiling a kernel with http://lkml.org/lkml/2007/8/25/154 patched in did nothelp.
I am still concerned about the effects of using idle=poll.
3 - KeywordsDQ35JO Q9300 SMP acpi=off noapic nolapic Q35 chipset multiple coresmwait monitor UP panic ubuntu
4 - Kernel information4.1 - Kernel version (/proc/version)Linux version 2.6.22-14-generic (buildd@crested) (gcc version 4.1.320070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun Oct 1421:45:15 GMT 2007
4.2 - Kernel .config fileIt does not contain anything about: CONFIG_PCI_MULTITHREAD_PROBEI will provide the entire file if it is deemed necessary, but this isa clean install.
5 - Most recent kernel version which did not have the bugNot sure.
6 - Trace output from serial portCommand line - root=UUID=606698ae-31bc-46d2-9ef1-24388019d94c ro k
stack=100 loglevel=7 initcall_debug apic=debug debug console=tty0 console=ttyS0,
9600n8ï»¿[    0.000000] Linux version 2.6.22-14-generic (buildd@crested) (gccversion 4.1
.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun Oct 14 21:45:15 GM
T 2007 (Ubuntu 2.6.22-14.46-generic)
[    0.000000] Command line: root=UUID=606698ae-31bc-46d2-9ef1-24388019d94c ro k
stack=100 loglevel=7 initcall_debug apic=debug debug console=tty0 console=ttyS0,
9600n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ce08000 (usable)
[    0.000000]  BIOS-e820: 000000007ce08000 - 000000007ceac000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ceac000 - 000000007e0a3000 (usable)
[    0.000000]  BIOS-e820: 000000007e0a3000 - 000000007e0a5000 (reserved)
[    0.000000]  BIOS-e820: 000000007e0a5000 - 000000007e179000 (usable)
[    0.000000]  BIOS-e820: 000000007e179000 - 000000007e1e5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e1e5000 - 000000007e1e6000 (usable)
[    0.000000]  BIOS-e820: 000000007e1e6000 - 000000007e1f2000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e1f2000 - 000000007e1f3000 (usable)
[    0.000000]  BIOS-e820: 000000007e1f3000 - 000000007e1ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007e1ff000 - 000000007e200000 (usable)
[    0.000000]  BIOS-e820: 000000007e200000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 157) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 511496) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 511660, 516259) 2 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516261, 516473) 3 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516581, 516582) 4 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516594, 516595) 5 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516607, 516608) 6 entries of 3200 us
ed
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xFFFF8100000FE020 checksum 0
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 7E1FD038, 0070 (r1 INTEL  DQ3510J       372       1000
013)
[    0.000000] ACPI: FACP 7E1FC000, 0074 (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: DSDT 7E1F8000, 3D3A (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: FACS 7E186000, 0040
[    0.000000] ACPI: APIC 7E1F7000, 0078 (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: WDDT 7E1F6000, 0040 (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: MCFG 7E1F5000, 003C (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: ASF! 7E1F4000, 00A6 (r32 INTEL  DQ3510J       372 MSFT  100
0013)
[    0.000000] ACPI: HPET 7E1F3000, 0038 (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: DMAR 7E1F1000, 0120 (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: ASPT 7E1F0000, 002C (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: WDTT 7E1EF000, 02CC (r1 INTEL  DQ3510J       372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1EE000, 0204 (r1 INTEL     CpuPm      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1ED000, 0175 (r1 INTEL   Cpu0Ist      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1EC000, 0175 (r1 INTEL   Cpu1Ist      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1EB000, 0175 (r1 INTEL   Cpu2Ist      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1EA000, 0175 (r1 INTEL   Cpu3Ist      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1E9000, 00DD (r1 INTEL   Cpu0Cst      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1E8000, 00DD (r1 INTEL   Cpu1Cst      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1E7000, 00DD (r1 INTEL   Cpu2Cst      372 MSFT  1000
013)
[    0.000000] ACPI: SSDT 7E1E6000, 00DD (r1 INTEL   Cpu3Cst      372 MSFT  1000
013)
[    0.000000] ACPI: TCPA 7E17A000, 0032 (r2 INTEL  TIANO           2 MSFT  1000
013)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007e200000
[    0.000000] Entering add_active_range(0, 0, 157) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 511496) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 511660, 516259) 2 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516261, 516473) 3 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516581, 516582) 4 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516594, 516595) 5 entries of 3200 us
ed
[    0.000000] Entering add_active_range(0, 516607, 516608) 6 entries of 3200 us
ed
[    0.000000] Bootmem setup node 0 0000000000000000-000000007e200000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0:        0 ->      157
[    0.000000]     0:      256 ->   511496
[    0.000000]     0:   511660 ->   516259
[    0.000000]     0:   516261 ->   516473
[    0.000000]     0:   516581 ->   516582
[    0.000000]     0:   516594 ->   516595
[    0.000000]     0:   516607 ->   516608
[    0.000000] On node 0 totalpages: 516211
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1127 pages reserved
[    0.000000]   DMA zone: 2814 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7007 pages used for memmap
[    0.000000]   DMA32 zone: 505207 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffffffff5fd000 (        fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fc000 (00000000fec00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009d000 - 00000
0000009e000
[    0.000000] swsusp: Registered nosave memory region: 000000000009e000 - 00000
000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000
000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - 00000
00000100000
[    0.000000] swsusp: Registered nosave memory region: 000000007ce08000 - 00000
0007ceac000
[    0.000000] swsusp: Registered nosave memory region: 000000007e0a3000 - 00000
0007e0a5000
[    0.000000] swsusp: Registered nosave memory region: 000000007e179000 - 00000
0007e1e5000
[    0.000000] swsusp: Registered nosave memory region: 000000007e1e6000 - 00000
0007e1f2000
[    0.000000] swsusp: Registered nosave memory region: 000000007e1f3000 - 00000
0007e1ff000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000:7100
0000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34696 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 508021
[    0.000000] Kernel command line: root=UUID=606698ae-31bc-46d2-9ef1-24388019d9
4c ro kstack=100 loglevel=7 initcall_debug apic=debug debug console=tty0 console
=ttyS0,9600n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   46.345143] time.c: Detected 2491.242 MHz processor.
[   46.346165] Console: colour VGA+ 80x25
[   55.536733] Checking aperture...
[   55.575356] Calgary: detecting Calgary via BIOS EBDA area
[   55.641701] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[   55.750576] Memory: 2024076k/2066432k available (2274k kernel code, 40768k re
served, 1181k data, 296k init)
[   55.867067] SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, N
odes=1
[   56.036103] Calibrating delay using timer specific routine.. 4985.73 BogoMIPS
 (lpj=9971479)
[   56.136145] Security Framework v1.0.0 initialized
[   56.194052] SELinux:  Disabled at boot.
[   56.240075] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   56.326952] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   56.412019] Mount-cache hash table entries: 256
[   56.466284] CPU: L1 I cache: 32K, L1 D cache: 32K
[   56.522740] CPU: L2 cache: 3072K
[   56.561368] CPU 0/0 -> Node 0
[   56.596875] CPU: Physical Processor ID: 0
[   56.644841] CPU: Processor Core ID: 0
[   56.690423] CPU0: Thermal monitoring enabled (TM2)
[   56.747739] SMP alternatives: switching to UP code
[   56.805301] Early unpacking initramfs... done
[   57.137706] ACPI: Core revision 20070126
[   57.185921] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not
found.
[   57.280568] enabled ExtINT on CPU#0
[   57.322322] ESR value after enabling vector: 00000000, after 00000040
[   57.399488] ENABLING IO-APIC IRQs
[   57.439120] init IO_APIC IRQs
[   57.474629]  IO-APIC (apicid-pin) 2-0<7>IOAPIC[0]: Set routing entry (2-1 ->
0x31 -> IRQ 1 Mode:0 Active:0)
[   57.591346] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:
0)
[   57.678764] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:
0)
[   57.767321] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:
0)
[   57.854740] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:
0)
[   57.942159] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:
0)
[   58.030091] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:
0)
[   58.117516] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:
0)
[   58.206596] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:
0)
[   58.294014] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Activ
e:0)
[   58.383511] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Activ
e:0)
[   58.473007] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Activ
e:0)
[   58.562500] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Activ
e:0)
[   58.651995] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Activ
e:0)
[   58.743460] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Activ
e:0)
[   58.832952] , 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   58.917155] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[   59.029001] Using local APIC timer interrupts.
[   59.122240] result 20760334
[   59.155603] Detected 20.760 MHz APIC timer.
[   59.207851] SMP alternatives: switching to SMP code
[   59.267920] Booting processor 1/4 APIC 0x2
[   59.327184] Initializing CPU#1
[   59.327853] masked ExtINT on CPU#1
[   59.407786] Calibrating delay using timer specific routine.. 4982.61 BogoMIPS
 (lpj=9965228)
[   59.407791] CPU: L1 I cache: 32K, L1 D cache: 32K
[   59.407793] CPU: L2 cache: 3072K
[   59.407794] CPU 1/2 -> Node 0
[   59.407795] using mwait in idle threads.
[   59.407797] CPU: Physical Processor ID: 0
[   59.407797] CPU: Processor Core ID: 2
[   59.407802] CPU1: Thermal monitoring enabled (TM2)
[   59.408222] Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[   59.408231] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   60.087766] SMP alternatives: switching to SMP code
[   60.146101] Booting processor 2/4 APIC 0x1
[   60.205441] Initializing CPU#2
[   60.206095] masked ExtINT on CPU#2
[   60.283705] Calibrating delay using timer specific routine.. 4841.38 BogoMIPS
 (lpj=9682771)
[   60.283710] CPU: L1 I cache: 32K, L1 D cache: 32K
[   60.283712] CPU: L2 cache: 3072K
[   60.283718] CPU 2/1 -> Node 0
[   60.283719] CPU: Physical Processor ID: 0
[   60.283720] CPU: Processor Core ID: 1
[   60.283730] CPU2: Thermal monitoring enabled (TM2)
[   60.284147] Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[   60.284181] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[   60.915656] invalid opcode: 0000 [1] <6>SMP alternatives: switching to SMP co
de
[   60.915794] Booting processor 3/4 APIC 0x3
[   60.926141] Initializing CPU#3
[   60.926811] masked ExtINT on CPU#3
[   61.003638] Calibrating delay using timer specific routine.. 4982.47 BogoMIPS
 (lpj=9964943)
[   61.003644] CPU: L1 I cache: 32K, L1 D cache: 32K
[   61.003645] CPU: L2 cache: 3072K
[   61.003647] CPU 3/3 -> Node 0
[   61.003648] CPU: Physical Processor ID: 0
[   61.003649] CPU: Processor Core ID: 3
[   61.003654] CPU3: Thermal monitoring enabled (TM2)
[   61.004075] Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[   61.004084] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[   61.027642] Brought up 4 CPUs
[   61.699335] SMP
[   61.721444] CPU 2
[   61.745634] Modules linked in:
[   61.784047] Pid: 0, comm: swapper Not tainted 2.6.22-14-generic #1
[   61.857975] RIP: 0010:[<ffffffff80209182>]  [<ffffffff80209182>] mwait_idle+0
x22/0x50
[   61.951835] RSP: 0018:ffff81007c593f30  EFLAGS: 00010046
[   62.015366] RAX: ffff81007c592010 RBX: ffffffff80209160 RCX: 0000000000000000
[   62.100710] RDX: 0000000000000000 RSI: ffff81007c592010 RDI: ffffffff8052ed98
[   62.186048] RBP: ffffffff805cd100 R08: 0000000000000000 R09: 0000000000000002
[   62.271387] R10: ffffffff805cd120 R11: ffffffff805cd120 R12: 0000000000000000
[   62.358185] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   62.443539] FS:  0000000000000000(0000) GS:ffff81007e1f2400(0000) knlGS:00000
00000000000
[   62.540304] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   62.609016] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   62.694364] Process swapper (pid: 0, threadinfo ffff81007c592000, task ffff81
007c590000)
[   62.791137] Stack:  ffffffff802090c0 0000000000000000 0000000000000000 000000
0000000000
[   62.888397]  0000000000000000 0000000000000000 0000000000000000 0000000000000
000
[   62.977380]  0000000000000000 0000000000000000 0000000000000000 0000000000000
000
[   63.066353]  0000000000000000 0000000000000000 0000000000000000 0000000000000
000
[   63.155330]  0000000000000000 0000000000000000 0000000000000000 0000000000000
000
[   63.244308]  0000000000000000 0000000000000000 0000000000000000 0000000000000
000
[   63.334531]  0000000000000000 0000000000000000 3636fe0000000036 1818f818f8000
036
[   63.423513]  3636f606f6363618 3636363636363636 3636f606fe000036 0000fe06f6363
636
[   63.512503]  0000fe3636363600 0000f818f8181800 1818f80000000000 00001f1818181
818
[   63.601589]  0000ff1818181800 1818ff0000000000 18181f1818181818 0000ff0000000
018
[   63.690560]  1818ff1818181800 18181f181f181818 3636373636363618 00003f3037363
636
[   63.779533]  363637303f000000 0000ff00f7363636 3636f700ff000000 3636373037363
636
[   63.869654]  0000ff00ff000036 3636f700f7363600 0000ff00ff181836 0000ff3636363
600
[   63.958629]  1818ff00ff000000 3636ff0000000018 00003f3636363636 00001f181f181
800
[   64.047602]  18181f181f000000 36363f0000000018 3636ff3636363636 1818ff18ff181
836
[   64.136578]  0000f81818181818 18181f0000000000 ffffffffffffff18 ffffff0000000
0ff
[   64.225653]  f0f0f0f0f0f0f0ff 0f0f0f0f0f0f0ff0 000000ffffffff0f 76dcc8cc74000
000
[   64.314627]  dcc6c6ccd8cc7800 f06060606062fe40 486c6cec7e020000 fe6230183062f
e00
[   64.405472]  70c8c8d07e000000 f8cccccccc000000 101818d87e000080 107cd6d67c103
800
[   64.494447]  7cc6c6fec6c67c38 ee286cc6c6c67c00 78cccc7c18223c00 0066999966000
000
[   64.583424]  c07cf29e7c060000 7cc0f8c07c000000 c6c6c6c6c67c0000 00fe00fe00fe0
000
[   64.672400]  7e0018187e181800 7c0030180c183000 7c00183060301800 181818181b1b0
e00
[   64.761480]  d8d8181818181818 0018007e00180070 00dc7600dc760000 00000000386c3
800
[   64.852342]  0000181800000000 0000180000000000 3c6cec0c0c0c0f00 0000006c6c6cd
800
[   64.941296]  000000f0c030f000 003c3c3c3c000000 0000000000000000 0000000000000
000
[   65.027987] Call Trace:
[   65.059551]  [<ffffffff802090c0>] cpu_idle+0x70/0xc0
[   65.118938]
[   65.136789]
[   65.136789] Code: 0f 01 c8 0f ae f0 65 48 8b 04 25 10 00 00 00 8b 80 38 e0 ff


[   65.243407] RIP  [<ffffffff80209182>] mwait_idle+0x22/0x50
[   65.309133]  RSP <ffff81007c593f30>
[   65.350872] invalid opcode: 0000 [2] <0>Kernel panic - not syncing: Attempted
 to kill the idle task!
[   65.461047] SMP
[   65.483131] CPU 0
[   65.507321] Modules linked in:
[   65.543971] Pid: 0, comm: swapper Not tainted 2.6.22-14-generic #1
[   65.617899] RIP: 0010:[<ffffffff80209182>]  [<ffffffff80209182>] mwait_idle+0
x22/0x50
[   65.711762] RSP: 0000:ffffffff8057ff80  EFLAGS: 00010046
[   65.775293] RAX: ffffffff8057e010 RBX: ffffffff80209160 RCX: 0000000000000000
[   65.860635] RDX: 0000000000000000 RSI: ffffffff8057e010 RDI: ffffffff8052ed98
[   65.947119] RBP: ffffffff805cd100 R08: 0000000000000000 R09: 0000000000000000
[   66.032459] R10: ffffffff805ce880 R11: ffff810081c39000 R12: ffffffff805acfe0
[   66.117798] R13: 000000000000001f R14: 0000000000074000 R15: fffffffff000b1c8
[   66.203142] FS:  0000000000000000(0000) GS:ffffffff80560000(0000) knlGS:00000
00000000000
[   66.299912] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   66.368624] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   66.455941] Process swapper (pid: 0, threadinfo ffffffff8057e000, task ffffff
ff8052d3c0)
[   66.552719] Stack:  ffffffff802090c0 0000000000000000 0000000001000000 000000
0000000000
[   66.649038]  ffffffff80588815 0000000000000000 0000000000000000 ffffffff805ac
fe0
[   66.738010]  ffff810000090000 000000007df90dcc ffffffff8058811e 80208e0000100
1b0
[   66.826987]  00000000ffffffff 0000000000000000 0000000000000000 0000000000000
000
[   66.914930] Call Trace:
[   66.946495]  [<ffffffff802090c0>] cpu_idle+0x70/0xc0
[   67.005888]  [<ffffffff80588815>] start_kernel+0x285/0x310
[   67.071505]  [<ffffffff8058811e>] _sinittext+0x11e/0x160
[   67.135044]
[   67.152894]
[   67.152895] Code: 0f 01 c8 0f ae f0 65 48 8b 04 25 10 00 00 00 8b 80 38 e0 ff


[   67.259941] RIP  [<ffffffff80209182>] mwait_idle+0x22/0x50
[   67.325660]  RSP <ffffffff8057ff80>
[   67.367395] WARNING: at /build/buildd/linux-source-2.6.22-2.6.22/drivers/char
/vt.c:3565 do_unblank_screen()
[   67.485046]
[   67.485046] Call Trace:
[   67.532157]  [<ffffffff8037bb8a>] do_unblank_screen+0x13a/0x140
[   67.602969]  [<ffffffff8032a08c>] bust_spinlocks+0x1c/0x30
[   67.668582]  [<ffffffff80432eb5>] oops_end+0x15/0x60
[   67.727968]  [<ffffffff8020b778>] die+0x48/0x60
[   67.782157]  [<ffffffff8020bc34>] do_invalid_op+0x84/0xa0
[   67.846734]  [<ffffffff80209182>] mwait_idle+0x22/0x50
[   67.908195]  [<ffffffff80234a00>] do_fork+0x1b0/0x290
[   67.969972]  [<ffffffff80355b7a>] acpi_ns_get_next_node+0x16/0x3c
[   68.042854]  [<ffffffff80432b1d>] error_exit+0x0/0x84
[   68.103272]  [<ffffffff80209160>] mwait_idle+0x0/0x50
[   68.163696]  [<ffffffff80209182>] mwait_idle+0x22/0x50
[   68.225158]  [<ffffffff802090c0>] cpu_idle+0x70/0xc0
[   68.284549]  [<ffffffff80588815>] start_kernel+0x285/0x310
[   68.350162]  [<ffffffff8058811e>] _sinittext+0x11e/0x160
[   68.413697]
[   68.431550] Kernel panic - not syncing: Attempted to kill the idle task!
7 - Small script to trigger the problemBoot Ubuntu 7.10 64-bit from live cd on said motherboard/cpu without anyspecial boot options.
8 - Environment
8.1 - SoftwareLinux yitzhak-desktop 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT2007 x86_64 GNU/Linux
Gnu C                  4.1.3Gnu make               3.81binutils               Binutilsutil-linux             2.13mount                  2.13module-init-tools      3.3-pre2e2fsprogs              1.40.2reiserfsprogs          3.6.19pcmciautils            014PPP                    2.4.4Linux C Library        2.6.1Dynamic linker (ldd)   2.6.1Procps                 3.2.7Net-tools              1.60Console-tools          0.2.3Sh-utils               5.97udev                   113wireless-tools         29Modules Loaded         af_packet i915 drm ipv6 rfcomm l2cap bluetoothppdev acpi_cpufreq cpufreq_powersave cpufreq_conservativecpufreq_stats cpufreq_ondemand cpufreq_userspace freq_table containervideo dock button ac sbs battery sbp2 parport_pc lp parportsnd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummysnd_seq_oss snd_seq_midi snd_rawmidi xpad snd_seq_midi_event snd_seqsnd_timer snd_seq_device snd soundcore serio_raw e1000_ich9 shpchppci_hotplug snd_page_alloc intel_agp heci psmouse pcspkr joydev evdevext3 jbd mbcache ata_generic sg sd_mod usbhid hid pata_marvell ahcilibata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermalprocessor fan fuse apparmor commoncap
8.2 - Processor information (/proc/cpuinfo)processor       : 0vendor_id       : GenuineIntelcpu family      : 6model           : 23model name      : Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHzstepping        : 7cpu MHz         : 1998.000cache size      : 3072 KBphysical id     : 0siblings        : 4core id         : 0cpu cores       : 4fpu             : yesfpu_exception   : yescpuid level     : 10wp              : yesflags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pgemca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscallnx lm constant_tsc pni ds_cpl vmx smx est tm2 ssse3 cx16 xtpr lahf_lmbogomips        : 4985.75clflush size    : 64cache_alignment : 64address sizes   : 36 bits physical, 48 bits virtualpower management:
processor       : 1vendor_id       : GenuineIntelcpu family      : 6model           : 23model name      : Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHzstepping        : 7cpu MHz         : 1998.000cache size      : 3072 KBphysical id     : 0siblings        : 4core id         : 2cpu cores       : 4fpu             : yesfpu_exception   : yescpuid level     : 10wp              : yesflags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pgemca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscallnx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtprlahf_lmbogomips        : 4982.53clflush size    : 64cache_alignment : 64address sizes   : 36 bits physical, 48 bits virtualpower management:
processor       : 2vendor_id       : GenuineIntelcpu family      : 6model           : 23model name      : Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHzstepping        : 7cpu MHz         : 1998.000cache size      : 3072 KBphysical id     : 0siblings        : 4core id         : 1cpu cores       : 4fpu             : yesfpu_exception   : yescpuid level     : 10wp              : yesflags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pgemca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscallnx lm constant_tsc pni ds_cpl vmx smx est tm2 ssse3 cx16 xtpr lahf_lmbogomips        : 4982.64clflush size    : 64cache_alignment : 64address sizes   : 36 bits physical, 48 bits virtualpower management:
processor       : 3vendor_id       : GenuineIntelcpu family      : 6model           : 23model name      : Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHzstepping        : 7cpu MHz         : 1998.000cache size      : 3072 KBphysical id     : 0siblings        : 4core id         : 3cpu cores       : 4fpu             : yesfpu_exception   : yescpuid level     : 10wp              : yesflags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pgemca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscallnx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtprlahf_lmbogomips        : 4982.52clflush size    : 64cache_alignment : 64address sizes   : 36 bits physical, 48 bits virtualpower management:
8.3 - Module information (/proc/modules)af_packet 28172 2 - Live 0xffffffff883bc000i915 30976 2 - Live 0xffffffff883b3000drm 106408 3 i915, Live 0xffffffff88398000ipv6 317192 31 - Live 0xffffffff88349000rfcomm 47656 2 - Live 0xffffffff8833c000l2cap 28672 11 rfcomm, Live 0xffffffff88334000bluetooth 63876 4 rfcomm,l2cap, Live 0xffffffff88323000ppdev 11272 0 - Live 0xffffffff8831f000acpi_cpufreq 10632 0 - Live 0xffffffff8831b000cpufreq_powersave 3072 0 - Live 0xffffffff88066000cpufreq_conservative 9608 0 - Live 0xffffffff88317000cpufreq_stats 8160 0 - Live 0xffffffff88314000cpufreq_ondemand 10896 4 - Live 0xffffffff88310000cpufreq_userspace 6048 0 - Live 0xffffffff8830d000freq_table 6464 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live0xffffffff8830a000container 6400 0 - Live 0xffffffff88307000video 21140 0 - Live 0xffffffff88300000dock 12264 0 - Live 0xffffffff882fc000button 10400 0 - Live 0xffffffff882f8000ac 7304 0 - Live 0xffffffff882f5000sbs 21520 0 - Live 0xffffffff882ee000battery 12424 0 - Live 0xffffffff882e9000sbp2 27144 0 - Live 0xffffffff882e1000parport_pc 41896 0 - Live 0xffffffff882d5000lp 15048 0 - Live 0xffffffff882d0000parport 44172 3 ppdev,parport_pc,lp, Live 0xffffffff882c4000snd_hda_intel 337192 1 - Live 0xffffffff88270000snd_pcm_oss 50048 0 - Live 0xffffffff88262000snd_mixer_oss 20096 1 snd_pcm_oss, Live 0xffffffff8825c000snd_pcm 94344 2 snd_hda_intel,snd_pcm_oss, Live 0xffffffff88243000snd_seq_dummy 5380 0 - Live 0xffffffff88240000snd_seq_oss 36864 0 - Live 0xffffffff88236000snd_seq_midi 11008 0 - Live 0xffffffff88232000snd_rawmidi 29824 1 snd_seq_midi, Live 0xffffffff88229000xpad 11400 0 - Live 0xffffffff88225000snd_seq_midi_event 9984 2 snd_seq_oss,snd_seq_midi, Live 0xffffffff88221000snd_seq 62496 6snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live0xffffffff88210000snd_timer 27272 2 snd_pcm,snd_seq, Live 0xffffffff88208000snd_seq_device 10260 5snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live0xffffffff88204000snd 69288 11 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,Live 0xffffffff881f2000soundcore 10272 1 snd, Live 0xffffffff881ee000serio_raw 9092 0 - Live 0xffffffff881e8000e1000_ich9 211008 0 - Live 0xffffffff881b1000shpchp 38300 0 - Live 0xffffffff881a6000pci_hotplug 36612 1 shpchp, Live 0xffffffff8819c000snd_page_alloc 12560 2 snd_hda_intel,snd_pcm, Live 0xffffffff88197000intel_agp 30624 1 - Live 0xffffffff8818e000heci 66064 0 - Live 0xffffffff8817c000psmouse 45596 0 - Live 0xffffffff8816f000pcspkr 4608 0 - Live 0xffffffff880bf000joydev 13440 0 - Live 0xffffffff8816a000evdev 13056 4 - Live 0xffffffff88165000ext3 146576 1 - Live 0xffffffff88140000jbd 69360 1 ext3, Live 0xffffffff8812e000mbcache 11272 1 ext3, Live 0xffffffff8812a000ata_generic 9988 0 - Live 0xffffffff88126000sg 41384 0 - Live 0xffffffff8811a000sd_mod 32512 3 - Live 0xffffffff88111000usbhid 32576 0 - Live 0xffffffff88108000hid 33408 1 usbhid, Live 0xffffffff880fe000pata_marvell 9472 0 - Live 0xffffffff880f8000ahci 27012 2 - Live 0xffffffff880f0000libata 138928 3 ata_generic,pata_marvell,ahci, Live 0xffffffff880cd000ohci1394 38984 0 - Live 0xffffffff880c2000scsi_mod 172856 4 sbp2,sg,sd_mod,libata, Live 0xffffffff88093000ieee1394 109528 2 sbp2,ohci1394, Live 0xffffffff88075000ehci_hcd 40076 0 - Live 0xffffffff88068000uhci_hcd 29600 0 - Live 0xffffffff8805d000usbcore 161584 5 xpad,usbhid,ehci_hcd,uhci_hcd, Live 0xffffffff88034000thermal 16528 0 - Live 0xffffffff8802e000processor 36232 2 acpi_cpufreq,thermal, Live 0xffffffff88024000fan 6920 0 - Live 0xffffffff88021000fuse 52528 1 - Live 0xffffffff88013000apparmor 47008 0 - Live 0xffffffff88006000commoncap 9472 1 apparmor, Live 0xffffffff88002000
8.4 - Loaded driver and hardware information8.4.1 - /proc/ioports0000-001f : dma10020-0021 : pic10040-0043 : timer00050-0053 : timer10060-006f : keyboard0070-0077 : rtc0080-008f : dma page reg00a0-00a1 : pic200c0-00df : dma200f0-00ff : fpu03c0-03df : vga+03f8-03ff : serial0400-047f : pnp 00:06 0400-0403 : ACPI PM1a_EVT_BLK 0404-0405 : ACPI PM1a_CNT_BLK 0408-040b : ACPI PM_TMR 0410-0415 : ACPI CPU throttle 0420-042f : ACPI GPE0_BLK 0450-0450 : ACPI PM2_CNT_BLK0500-053f : pnp 00:060680-06ff : pnp 00:060cf8-0cff : PCI conf11000-1fff : PCI Bus #03 1000-100f : 0000:03:00.0   1000-100f : libata 1010-1017 : 0000:03:00.0 1018-101f : 0000:03:00.0   1018-101f : libata 1020-1023 : 0000:03:00.0 1024-1027 : 0000:03:00.0   1024-1027 : libata2000-201f : 0000:00:1f.32020-203f : 0000:00:1f.22040-205f : 0000:00:1d.2 2040-205f : uhci_hcd2060-207f : 0000:00:1d.1 2060-207f : uhci_hcd2080-209f : 0000:00:1d.0 2080-209f : uhci_hcd20a0-20bf : 0000:00:1a.2 20a0-20bf : uhci_hcd20c0-20df : 0000:00:1a.1 20c0-20df : uhci_hcd20e0-20ff : 0000:00:1a.0 20e0-20ff : uhci_hcd2400-241f : 0000:00:19.0 2400-241f : e1000-ich92420-2427 : 0000:00:1f.22428-242f : 0000:00:1f.22430-2437 : 0000:00:02.02438-243b : 0000:00:1f.2243c-243f : 0000:00:1f.2
8.4.2 - /proc/iomem00000000-0009dbff : System RAM 00000000-00000000 : Crash kernel0009dc00-0009ffff : reserved000e0000-000fffff : reserved00100000-7ce07fff : System RAM 00200000-0043882b : Kernel code 0043882c-0055fe9f : Kernel data7ce08000-7ceabfff : ACPI Non-volatile Storage7ceac000-7e0a2fff : System RAM7e0a3000-7e0a4fff : reserved7e0a5000-7e178fff : System RAM7e179000-7e1e4fff : ACPI Non-volatile Storage7e1e5000-7e1e5fff : System RAM7e1e6000-7e1f1fff : ACPI Tables7e1f2000-7e1f2fff : System RAM7e1f3000-7e1fefff : ACPI Tables7e1ff000-7e1fffff : System RAM7e200000-7effffff : reserved80000000-8fffffff : 0000:00:02.090000000-900fffff : PCI Bus #06 90000000-90000fff : 0000:06:03.0   90000000-900007ff : ohci139490100000-901fffff : PCI Bus #03 90100000-901001ff : 0000:03:00.090200000-902fffff : 0000:00:02.090300000-9037ffff : 0000:00:02.190380000-903fffff : 0000:00:02.090400000-9041ffff : 0000:00:19.0 90400000-9041ffff : e1000-ich990420000-90423fff : 0000:00:1b.0 90420000-90423fff : ICH HD audio90424000-90424fff : 0000:00:19.0 90424000-90424fff : e1000-ich990425000-904257ff : 0000:00:1f.2 90425000-904257ff : ahci90425800-90425bff : 0000:00:1d.7 90425800-90425bff : ehci_hcd90425c00-90425fff : 0000:00:1a.7 90425c00-90425fff : ehci_hcd90426000-904260ff : 0000:00:1f.390426100-9042610f : 0000:00:03.0 90426100-9042610f : hecif0000000-f7ffffff : reservedfeb00000-feb03fff : pnp 00:01fec00000-fec00fff : IOAPIC 0fed13000-fed13fff : pnp 00:01fed14000-fed17fff : pnp 00:01fee00000-fee00fff : Local APICffc00000-ffffffff : reserved
8.5 - PCI Information (sudo lspci -vvv)00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller (rev 02)       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort+ >SERR- <PERR-       Latency: 0       Capabilities: [e0] Vendor Specific Information
00:02.0 VGA compatible controller: Intel Corporation 82Q35 ExpressIntegrated Graphics Controller (rev 02) (prog-if 00 [VGA])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 16       Region 0: Memory at 90380000 (32-bit, non-prefetchable) [size=512K]       Region 1: I/O ports at 2430 [size=8]       Region 2: Memory at 80000000 (32-bit, prefetchable) [size=256M]       Region 3: Memory at 90200000 (32-bit, non-prefetchable) [size=1M]       Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [d0] Power Management version 2               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mAPME(D0-,D1-,D2-,D3hot-,D3cold-)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:02.1 Display controller: Intel Corporation 82Q35 Express IntegratedGraphics Controller (rev 02)       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Region 0: Memory at 90300000 (32-bit, non-prefetchable) [size=512K]       Capabilities: [d0] Power Management version 2               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mAPME(D0-,D1-,D2-,D3hot-,D3cold-)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:03.0 Communication controller: Intel Corporation 82Q35 Express MEIController (rev 02)       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 16       Region 0: Memory at 90426100 (64-bit, non-prefetchable) [size=16]       Capabilities: [50] Power Management version 3               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-       Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+Queue=0/0 Enable-               Address: 0000000000000000  Data: 0000
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 GigabitNetwork Connection (rev 02)       Subsystem: Intel Corporation Unknown device 0001       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 20       Region 0: Memory at 90400000 (32-bit, non-prefetchable) [size=128K]       Region 1: Memory at 90424000 (32-bit, non-prefetchable) [size=4K]       Region 2: I/O ports at 2400 [size=32]       Capabilities: [c8] Power Management version 2               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=1 PME-       Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+Queue=0/0 Enable-               Address: 0000000000000000  Data: 0000       Capabilities: [e0] Vendor Specific Information
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #4 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 18       Region 4: I/O ports at 20e0 [size=32]       Capabilities: [50] Vendor Specific Information
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #5 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin B routed to IRQ 21       Region 4: I/O ports at 20c0 [size=32]       Capabilities: [50] Vendor Specific Information
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #6 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin C routed to IRQ 17       Region 4: I/O ports at 20a0 [size=32]       Capabilities: [50] Vendor Specific Information
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin C routed to IRQ 17       Region 0: Memory at 90425c00 (32-bit, non-prefetchable) [size=1K]       Capabilities: [50] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-       Capabilities: [58] Debug port       Capabilities: [98] Vendor Specific Information
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD AudioController (rev 02)       Subsystem: Intel Corporation Unknown device 0012       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Interrupt: pin A routed to IRQ 22       Region 0: Memory at 90420000 (64-bit, non-prefetchable) [size=16K]       Capabilities: [50] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-       Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+Queue=0/0 Enable-               Address: 0000000000000000  Data: 0000       Capabilities: [70] Express Unknown type IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0               Link: Latency L0s <64ns, L1 <1us               Link: ASPM Disabled CommClk- ExtSynch-               Link: Speed unknown, Width x0
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI ExpressPort 1 (rev 02) (prog-if 00 [Normal decode])       Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Bus: primary=00, secondary=01, subordinate=01, sec-latency=0       I/O behind bridge: 0000f000-00000fff       Memory behind bridge: fff00000-000fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort+ <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [40] Express Root Port (Slot+) IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1               Link: Latency L0s <1us, L1 <4us               Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-               Link: Speed 2.5Gb/s, Width x0               Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+               Slot: Number 1, PowerLimit 10.000000               Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-               Slot: AttnInd Unknown, PwrInd Unknown, Power-               Root: Correctable- Non-Fatal- Fatal- PME-       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9Family) PCI Express Port 1       Capabilities: [a0] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI ExpressPort 2 (rev 02) (prog-if 00 [Normal decode])       Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Bus: primary=00, secondary=02, subordinate=02, sec-latency=0       I/O behind bridge: 0000f000-00000fff       Memory behind bridge: fff00000-000fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort+ <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [40] Express Root Port (Slot+) IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2               Link: Latency L0s <1us, L1 <4us               Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-               Link: Speed 2.5Gb/s, Width x0               Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+               Slot: Number 2, PowerLimit 10.000000               Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-               Slot: AttnInd Unknown, PwrInd Unknown, Power-               Root: Correctable- Non-Fatal- Fatal- PME-       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9Family) PCI Express Port 2       Capabilities: [a0] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI ExpressPort 3 (rev 02) (prog-if 00 [Normal decode])       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Bus: primary=00, secondary=03, subordinate=03, sec-latency=0       I/O behind bridge: 00001000-00001fff       Memory behind bridge: 90100000-901fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [40] Express Root Port (Slot+) IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3               Link: Latency L0s <256ns, L1 <4us               Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-               Link: Speed 2.5Gb/s, Width x1               Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+               Slot: Number 3, PowerLimit 10.000000               Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-               Slot: AttnInd Unknown, PwrInd Unknown, Power-               Root: Correctable- Non-Fatal- Fatal- PME-       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9Family) PCI Express Port 3       Capabilities: [a0] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI ExpressPort 4 (rev 02) (prog-if 00 [Normal decode])       Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Bus: primary=00, secondary=04, subordinate=04, sec-latency=0       I/O behind bridge: 0000f000-00000fff       Memory behind bridge: fff00000-000fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort+ <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [40] Express Root Port (Slot+) IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4               Link: Latency L0s <1us, L1 <4us               Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-               Link: Speed 2.5Gb/s, Width x0               Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+               Slot: Number 4, PowerLimit 10.000000               Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-               Slot: AttnInd Unknown, PwrInd Unknown, Power-               Root: Correctable- Non-Fatal- Fatal- PME-       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9Family) PCI Express Port 4       Capabilities: [a0] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI ExpressPort 5 (rev 02) (prog-if 00 [Normal decode])       Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Bus: primary=00, secondary=05, subordinate=05, sec-latency=0       I/O behind bridge: 0000f000-00000fff       Memory behind bridge: fff00000-000fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort+ <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [40] Express Root Port (Slot+) IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s <64ns, L1 <1us               Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5               Link: Latency L0s <1us, L1 <4us               Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-               Link: Speed 2.5Gb/s, Width x0               Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+               Slot: Number 5, PowerLimit 10.000000               Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-               Slot: AttnInd Unknown, PwrInd Unknown, Power-               Root: Correctable- Non-Fatal- Fatal- PME-       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9Family) PCI Express Port 5       Capabilities: [a0] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #1 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 23       Region 4: I/O ports at 2080 [size=32]       Capabilities: [50] Vendor Specific Information
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #2 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin B routed to IRQ 19       Region 4: I/O ports at 2060 [size=32]       Capabilities: [50] Vendor Specific Information
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USBUHCI Controller #3 (rev 02) (prog-if 00 [UHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin C routed to IRQ 18       Region 4: I/O ports at 2040 [size=32]       Capabilities: [50] Vendor Specific Information
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 23       Region 0: Memory at 90425800 (32-bit, non-prefetchable) [size=1K]       Capabilities: [50] Power Management version 2               Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mAPME(D0+,D1-,D2-,D3hot+,D3cold+)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-       Capabilities: [58] Debug port       Capabilities: [98] Vendor Specific Information
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)(prog-if 01 [Subtractive decode])       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR+ FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Bus: primary=00, secondary=06, subordinate=06, sec-latency=32       I/O behind bridge: 0000f000-00000fff       Memory behind bridge: 90000000-900fffff       Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff       Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort+ <SERR- <PERR-       BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-       Capabilities: [50] Subsystem: Intel Corporation Unknown device 4f4a
00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR+ FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Capabilities: [e0] Vendor Specific Information
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)6 port SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 0       Interrupt: pin A routed to IRQ 21       Region 0: I/O ports at 2428 [size=8]       Region 1: I/O ports at 243c [size=4]       Region 2: I/O ports at 2420 [size=8]       Region 3: I/O ports at 2438 [size=4]       Region 4: I/O ports at 2020 [size=32]       Region 5: Memory at 90425000 (32-bit, non-prefetchable) [size=2K]       Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-Queue=0/4 Enable-               Address: 00000000  Data: 0000       Capabilities: [70] Power Management version 3               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mAPME(D0-,D1-,D2-,D3hot+,D3cold-)               Status: D0 PME-Enable- DSel=0 DScale=0 PME-       Capabilities: [a8] #12 [0010]       Capabilities: [b0] Vendor Specific Information
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)       Subsystem: Intel Corporation Unknown device 4f4a       Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Interrupt: pin B routed to IRQ 10       Region 0: Memory at 90426000 (64-bit, non-prefetchable) [size=256]       Region 4: I/O ports at 2000 [size=32]
03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101single-port PATA133 interface (rev b2) (prog-if 8f [Master SecP SecOPriP PriO])       Subsystem: Marvell Technology Group Ltd. 88SE6101 single-portPATA133 interface       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-ParErr- Stepping- SERR- FastB2B-       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-<TAbort- <MAbort- >SERR- <PERR-       Latency: 0, Cache Line Size: 64 bytes       Interrupt: pin A routed to IRQ 18       Region 0: I/O ports at 1018 [size=8]       Region 1: I/O ports at 1024 [size=4]       Region 2: I/O ports at 1010 [size=8]       Region 3: I/O ports at 1020 [size=4]       Region 4: I/O ports at 1000 [size=16]       Region 5: Memory at 90100000 (32-bit, non-prefetchable) [size=512]       Capabilities: [48] Power Management version 2               Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mAPME(D0+,D1+,D2-,D3hot+,D3cold-)               Status: D0 PME-Enable- DSel=0 DScale=1 PME-       Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-Queue=0/0 Enable-               Address: 00000000  Data: 0000       Capabilities: [e0] Express Legacy Endpoint IRQ 0               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-               Device: Latency L0s unlimited, L1 unlimited               Device: AtnBtn- AtnInd- PwrInd-               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-               Device: MaxPayload 128 bytes, MaxReadReq 512 bytes               Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0               Link: Latency L0s <256ns, L1 unlimited               Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-               Link: Speed 2.5Gb/s, Width x1
06:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10 [OHCI])       Subsystem: Agere Systems FW323       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-ParErr- Stepping- SERR- FastB2B+       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort- >SERR- <PERR-       Latency: 32 (3000ns min, 6000ns max), Cache Line Size: 64 bytes       Interrupt: pin A routed to IRQ 19       Region 0: Memory at 90000000 (32-bit, non-prefetchable) [size=4K]       Capabilities: [44] Power Management version 2               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mAPME(D0+,D1+,D2+,D3hot+,D3cold-)               Status: D0 PME-Enable- DSel=0 DScale=0 PME+
8.6 - SCSI Information (/proc/scsi/scsi)Attached devices:Host: scsi0 Channel: 00 Id: 00 Lun: 00 Vendor: ATA      Model: WDC WD2500AAKS-0 Rev: 01.0 Type:   Direct-Access                    ANSI  SCSI revision: 05ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
