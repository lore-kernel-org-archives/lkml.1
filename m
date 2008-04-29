Return-Path: <linux-kernel-owner+w=401wt.eu-S936991AbYD2AFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936991AbYD2AFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYD2AFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:05:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:9147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbYD2AF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,719,1199692800"; 
   d="scan'208";a="322354583"
Date: Mon, 28 Apr 2008 17:11:54 -0700
From: mark gross <mgross@linux.intel.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-ID: <20080429001154.GB31157@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <48133A64.7020702@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48133A64.7020702@googlemail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:21:24PM +0200, Gabriel C wrote:
> Hi all,
> 
> On an kernel ( tested 2.6.25 , linux-next and latest -git ) with DMAR enabled my box won't boot unless I disable it with intel_iommu=off.
> 
> It hangs very early on boot and not even the reset button works anymore , all I get is an black screen , no message or alike and the box hangs.
> Also it does not make any difference when enabling / disabling  DMAR_GFX_WA.
> 
> I would like to debug the problem but I have no idea on how to do it.

The quickest way is to replace the time_after call in the macro with a
counter to 3_000_000_000 (3-billion) and don't forget to increment it
each time through the IOMMU_WAIT_OP loop to see where its hanging.

You need an ITP and some insight into the workings of BIOS.  (I wouldn't
bother digging any deeper than seeing which DMAR setup step failed in the
early startup of the intel-iommu code.  See IOMMU_WAIT_OP.  It should
use TSC instead of Jiffies.  Your system is stuck in that macro.  Most
likely because your BIOS is buggering up its side of the IOMMU DMAR
equation.

Basically what is happening is that the register set and poll protocol
for talking to the iommu is failing on the poll part of the protocol.
As this is happening in early boot before timers are running you get
stuck there.

I've had this happen on a number of systems so far, and so far its
always a bios thing.  I've put some effort in adding code to detect such
things Like using the TSC instead of jiffies to detect the failure case,
and then trying to un-wrap the DMAR setup code.  I got the TSC thing to
work, which would replace the black screen startup hang with a call to
panic, but unwrapping the DMAR setup safely has been harder for me to
get working.

--mgross

> 
> Also this box has an ASUS P5E-VM DO motherboard , latest BIOS , Q9300 Quad CPU and 4G RAM.
> 
> lspci :
> 
> 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
> 00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
> 00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
> 00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
> 00:1f.6 Signal processing controller: Intel Corporation Thermal Subsystem (rev 02)
> 
> 
> dmesg:
> 
> [    0.000000] Linux version 2.6.25-05096-gb1721d0-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #783 SMP PREEMPT Sat Apr 26 14:00:11 CEST 2008
> [    0.000000] Command line: root=/dev/sdb1 ro debug vga=792 apic=verbose intel_iommu=off
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
> [    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
> [    0.000000] max_pfn_mapped = 1228800
> [    0.000000] x86: PAT support disabled.
> [    0.000000] init_memory_mapping
> [    0.000000] DMI 2.4 present.
> [    0.000000] ACPI: RSDP 000F9A80, 0024 (r2 ACPIAM)
> [    0.000000] ACPI: XSDT CF550100, 0064 (r1 A_M_I_ OEMXSDT   3000820 MSFT       97)
> [    0.000000] ACPI: FACP CF550290, 00F4 (r3 A_M_I_ OEMFACP   3000820 MSFT       97)
> [    0.000000] ACPI: DSDT CF5505C0, 843B (r1  A0869 A0869001        1 INTL 20060113)
> [    0.000000] ACPI: FACS CF55E000, 0040
> [    0.000000] ACPI: APIC CF550390, 006C (r1 A_M_I_ OEMAPIC   3000820 MSFT       97)
> [    0.000000] ACPI: MCFG CF550400, 003C (r1 A_M_I_ OEMMCFG   3000820 MSFT       97)
> [    0.000000] ACPI: OEMB CF55E040, 0081 (r1 A_M_I_ AMI_OEM   3000820 MSFT       97)
> [    0.000000] ACPI: HPET CF558A00, 0038 (r1 A_M_I_ OEMHPET   3000820 MSFT       97)
> [    0.000000] ACPI: GSCI CF55E0D0, 2024 (r1 A_M_I_ GMCHSCI   3000820 MSFT       97)
> [    0.000000] ACPI: iEIT CF560100, 00B0 (r1 A_M_I_ EITTABLE  3000820 MSFT       97)
> [    0.000000] ACPI: DMAR CF5601B0, 0158 (r1    AMI  OEMDMAR        1 MSFT       97)
> [    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
> [    0.000000] early res: 0 [0-fff] BIOS data page
> [    0.000000] early res: 1 [6000-7fff] TRAMPOLINE
> [    0.000000] early res: 2 [200000-ae5233] TEXT DATA BSS
> [    0.000000] early res: 3 [9ec00-fffff] BIOS reserved
> [    0.000000] early res: 4 [8000-dfff] PGTABLE
> [    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
> [    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
> [    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
> [    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
> [    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
> [    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
> [    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
> [    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
> [    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
> [    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
> [    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
> [    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
> [    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff81000c200000 on node 0
> [    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff81000c600000 on node 0
> [    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff81000ca00000 on node 0
> [    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff81000ce00000 on node 0
> [    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff81000d200000 on node 0
> [    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff81000d600000 on node 0
> [    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff81000da00000 on node 0
> [    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff81000de00000 on node 0
> [    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff81000e200000 on node 0
> [    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff81000e600000 on node 0
> [    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff81000ea00000 on node 0
> [    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff81000ee00000 on node 0
> [    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff81000f200000 on node 0
> [    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff81000f600000 on node 0
> [    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff81000fa00000 on node 0
> [    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff81000fe00000 on node 0
> [    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810010200000 on node 0
> [    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810010600000 on node 0
> [    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810010a00000 on node 0
> [    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810010e00000 on node 0
> [    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810011200000 on node 0
> [    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810011600000 on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1228800
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0:        0 ->      158
> [    0.000000]     0:      256 ->   849232
> [    0.000000]     0:  1048576 ->  1228800
> [    0.000000] On node 0 totalpages: 1029358
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 2385 pages reserved
> [    0.000000]   DMA zone: 1557 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 830856 pages, LIFO batch:31
> [    0.000000]   Normal zone: 2464 pages used for memmap
> [    0.000000]   Normal zone: 177760 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
> [    0.000000] mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000cf550000 - 00000000cf55e000
> [    0.000000] PM: Registered nosave memory: 00000000cf55e000 - 00000000cf5e0000
> [    0.000000] PM: Registered nosave memory: 00000000cf5e0000 - 00000000cf600000
> [    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
> [    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 43908 bytes of per cpu data
> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010173
> [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=792 apic=verbose intel_iommu=off
> [    0.000000] Intel-IOMMU: disabled
> [    0.000000] Initializing CPU#0
> [    0.000000] Preemptible RCU implementation.
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] TSC calibrated against PM_TIMER
> [    0.000016] time.c: Detected 2499.955 MHz processor.
> [    0.000030] Console: colour dummy device 80x25
> [    0.000032] console [tty0] enabled
> [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000999] Checking aperture...
> [    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.000999] Placing software IO TLB between 0x4000000 - 0x8000000
> [    0.000999] Memory: 3965308k/4915200k available (3646k kernel code, 151404k reserved, 1709k data, 324k init)
> [    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
> [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
> [    0.000999] hpet clockevent registered
> [    0.059992] Calibrating delay using timer specific routine.. 5002.55 BogoMIPS (lpj=2501279)
> [    0.060020] Security Framework initialized
> [    0.060031] Capability LSM initialized
> [    0.060040] Mount-cache hash table entries: 256
> [    0.060148] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.060155] CPU: L2 cache: 3072K
> [    0.060160] CPU: Physical Processor ID: 0
> [    0.060164] CPU: Processor Core ID: 0
> [    0.060173] CPU0: Thermal monitoring enabled (TM2)
> [    0.060178] using mwait in idle threads.
> [    0.060846] ACPI: Core revision 20070126
> [    0.070021] enabled ExtINT on CPU#0
> [    0.071092] ENABLING IO-APIC IRQs
> [    0.071095] init IO_APIC IRQs
> [    0.071099]  IO-APIC (apicid-pin) 4-0 not connected.
> [    0.071107] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
> [    0.071117] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
> [    0.071126] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
> [    0.071135] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
> [    0.071144] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
> [    0.071153] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
> [    0.071162] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
> [    0.071171] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
> [    0.071180] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
> [    0.071189] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
> [    0.071198] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
> [    0.071207] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
> [    0.071216] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
> [    0.071225] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
> [    0.071234] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
> [    0.071242]  IO-APIC (apicid-pin) 4-16, 4-17, 4-18, 4-19, 4-20, 4-21, 4-22, 4-23 not connected.
> [    0.071405] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.081423] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.081431] Using local APIC timer interrupts.
> [    0.081988] APIC timer calibration result 12657227
> [    0.081993] Detected 12.657 MHz APIC timer.
> [    0.082069] Booting processor 1/1 ip 6000
> [    0.082069] Initializing CPU#1
> [    0.082069] masked ExtINT on CPU#1
> [    0.082069] Calibrating delay using timer specific routine.. 3037.71 BogoMIPS (lpj=1518859)
> [    0.082069] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.082069] CPU: L2 cache: 3072K
> [    0.082069] CPU: Physical Processor ID: 0
> [    0.082069] CPU: Processor Core ID: 1
> [    0.082069] CPU1: Thermal monitoring enabled (TM2)
> [    0.082069] x86: PAT support disabled.
> [    0.161305] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.161363] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.162043] Booting processor 2/2 ip 6000
> [    0.162043] Initializing CPU#2
> [    0.162043] masked ExtINT on CPU#2
> [    0.162043] Calibrating delay using timer specific routine.. 3037.74 BogoMIPS (lpj=1518871)
> [    0.162043] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.162043] CPU: L2 cache: 3072K
> [    0.162043] CPU: Physical Processor ID: 0
> [    0.162043] CPU: Processor Core ID: 2
> [    0.162043] CPU2: Thermal monitoring enabled (TM2)
> [    0.162043] x86: PAT support disabled.
> [    0.241240] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.241299] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> [    0.242012] Booting processor 3/3 ip 6000
> [    0.242012] Initializing CPU#3
> [    0.242012] masked ExtINT on CPU#3
> [    0.242012] Calibrating delay using timer specific routine.. 3037.74 BogoMIPS (lpj=1518870)
> [    0.242012] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.242012] CPU: L2 cache: 3072K
> [    0.242012] CPU: Physical Processor ID: 0
> [    0.242012] CPU: Processor Core ID: 3
> [    0.242012] CPU3: Thermal monitoring enabled (TM2)
> [    0.242012] x86: PAT support disabled.
> [    0.321257] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.321316] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> [    0.321958] Brought up 4 CPUs
> [    0.321963] Total of 4 processors activated (14115.75 BogoMIPS).
> [    0.323016] net_namespace: 960 bytes
> [    0.323023] Booting paravirtualized kernel on bare hardware
> [    0.323194] xor: automatically using best checksumming function: generic_sse
> [    0.327951]    generic_sse:  5620.000 MB/sec
> [    0.327955] xor: using function: generic_sse (5620.000 MB/sec)
> [    0.327978] NET: Registered protocol family 16
> [    0.328206] No dock devices found.
> [    0.328331] ACPI: bus type pci registered
> [    0.328422] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> [    0.328430] PCI: Not using MMCONFIG.
> [    0.328435] PCI: Using configuration type 1
> [    0.335991] ACPI: EC: Look up EC in DSDT
> [    0.346074] ACPI: Interpreter enabled
> [    0.346084] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.346102] ACPI: Using IOAPIC for interrupt routing
> [    0.360431] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.361963] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    0.361973] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
> [    0.362157] PCI: Transparent bridge - 0000:00:1e.0
> [    0.362175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.362320] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.391015] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.391146] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.391266] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [    0.391392] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.391509] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.392022] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.392139] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.392256] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
> [    0.392463] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  D2, should be CD [20070126]
> [    0.393981] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    0.394029] pnp: PnP ACPI init
> [    0.394038] ACPI: bus type pnp registered
> [    0.394404] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
> [    0.394517] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
> [    0.396280] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
> [    0.398429] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
> [    0.399115] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
> [    0.399276] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
> [    0.400950] pnp: PnP ACPI: found 16 devices
> [    0.400956] ACPI: ACPI bus type pnp unregistered
> [    0.401196] SCSI subsystem initialized
> [    0.401295] libata version 3.00 loaded.
> [    0.401481] usbcore: registered new interface driver usbfs
> [    0.401520] usbcore: registered new interface driver hub
> [    0.401983] usbcore: registered new device driver usb
> [    0.402292] PCI: Using ACPI for IRQ routing
> [    0.402299] number of MP IRQ sources: 15.
> [    0.402305] number of IO-APIC #4 registers: 24.
> [    0.402310] testing the IO APIC.......................
> [    0.402320] 
> [    0.402323] IO APIC #4......
> [    0.402327] .... register #00: 04000000
> [    0.402332] .......    : physical APIC id: 04
> [    0.402338] .... register #01: 00170020
> [    0.402343] .......     : max redirection entries: 0017
> [    0.402349] .......     : PRQ implemented: 0
> [    0.402354] .......     : IO APIC version: 0020
> [    0.402360] .... register #02: 00170020
> [    0.402365] .......     : arbitration: 00
> [    0.402370] .... IRQ redirection table:
> [    0.402375]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
> [    0.402385]  00 000 1    0    0   0   0    0    0    00
> [    0.402395]  01 00F 0    0    0   0   0    1    1    31
> [    0.402405]  02 00F 0    0    0   0   0    1    1    30
> [    0.402418]  03 00F 0    0    0   0   0    1    1    33
> [    0.402426]  04 00F 0    0    0   0   0    1    1    34
> [    0.402434]  05 00F 0    0    0   0   0    1    1    35
> [    0.402442]  06 00F 0    0    0   0   0    1    1    36
> [    0.402449]  07 00F 0    0    0   0   0    1    1    37
> [    0.402457]  08 00F 0    0    0   0   0    1    1    38
> [    0.402465]  09 00F 0    1    0   0   0    1    1    39
> [    0.402473]  0a 00F 0    0    0   0   0    1    1    3A
> [    0.402480]  0b 00F 0    0    0   0   0    1    1    3B
> [    0.402488]  0c 00F 0    0    0   0   0    1    1    3C
> [    0.402496]  0d 00F 0    0    0   0   0    1    1    3D
> [    0.402503]  0e 00F 0    0    0   0   0    1    1    3E
> [    0.402511]  0f 00F 0    0    0   0   0    1    1    3F
> [    0.402519]  10 000 1    0    0   0   0    0    0    00
> [    0.402527]  11 000 1    0    0   0   0    0    0    00
> [    0.402535]  12 000 1    0    0   0   0    0    0    00
> [    0.402542]  13 000 1    0    0   0   0    0    0    00
> [    0.402945]  14 000 1    0    0   0   0    0    0    00
> [    0.402953]  15 000 1    0    0   0   0    0    0    00
> [    0.402961]  16 000 1    0    0   0   0    0    0    00
> [    0.402969]  17 010 1    0    0   0   0    0    2    75
> [    0.402974] IRQ to pin mappings:
> [    0.402978] IRQ0 -> 0:2
> [    0.402982] IRQ1 -> 0:1
> [    0.402985] IRQ3 -> 0:3
> [    0.402989] IRQ4 -> 0:4
> [    0.402992] IRQ5 -> 0:5
> [    0.402996] IRQ6 -> 0:6
> [    0.402999] IRQ7 -> 0:7
> [    0.403003] IRQ8 -> 0:8
> [    0.403006] IRQ9 -> 0:9
> [    0.403010] IRQ10 -> 0:10
> [    0.403014] IRQ11 -> 0:11
> [    0.403017] IRQ12 -> 0:12
> [    0.403021] IRQ13 -> 0:13
> [    0.403025] IRQ14 -> 0:14
> [    0.403028] IRQ15 -> 0:15
> [    0.403033] .................................... done.
> [    0.410952] PCI-GART: No AMD northbridge found.
> [    0.410961] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.410971] hpet0: 4 64-bit timers, 14318180 Hz
> [    0.411954] ACPI: RTC can wake from S4
> [    0.423951] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [    0.423965] system 00:07: ioport range 0x290-0x297 has been reserved
> [    0.423976] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    0.423984] system 00:08: ioport range 0x800-0x87f has been reserved
> [    0.423992] system 00:08: ioport range 0x480-0x4bf has been reserved
> [    0.424000] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.424009] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.424017] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
> [    0.424025] system 00:08: iomem range 0xfed08000-0xfed08fff has been reserved
> [    0.424039] system 00:08: iomem range 0xff800000-0xffbfffff has been reserved
> [    0.424046] system 00:08: iomem range 0xffe80000-0xffefffff could not be reserved
> [    0.424054] system 00:08: iomem range 0xffc00000-0xffffffff could not be reserved
> [    0.424064] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
> [    0.424071] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
> [    0.424081] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.424090] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
> [    0.424096] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
> [    0.424102] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
> [    0.424109] system 00:0f: iomem range 0x100000-0xcf5fffff could not be reserved
> [    0.424116] system 00:0f: iomem range 0x0-0x0 could not be reserved
> [    0.425060] PCI: Bridge: 0000:00:1e.0
> [    0.425066]   IO window: disabled.
> [    0.425073]   MEM window: disabled.
> [    0.425079]   PREFETCH window: disabled.
> [    0.425095] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [    0.425124] NET: Registered protocol family 2
> [    0.457968] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.458237] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    0.460391] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.461206] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.461213] TCP reno registered
> [    0.473021] NET: Registered protocol family 1
> [    0.473021] audit: initializing netlink socket (disabled)
> [    0.473039] type=2000 audit(1209218717.450:1): initialized
> [    0.478960] async_tx: api initialized (async)
> [    0.479002] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.479013] io scheduler noop registered
> [    0.479018] io scheduler anticipatory registered
> [    0.479024] io scheduler deadline registered
> [    0.479094] io scheduler cfq registered (default)
> [    0.479112] pci 0000:00:02.0: Boot video device
> [    0.480124] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 6144k, total 8128k
> [    0.480134] vesafb: mode is 1024x768x32, linelength=4096, pages=1
> [    0.480140] vesafb: scrolling: redraw
> [    0.480145] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.480145] Switched to high resolution mode on CPU 2
> [    0.483012] Switched to high resolution mode on CPU 1
> [    0.497852] Switched to high resolution mode on CPU 3
> [    0.500926] Switched to high resolution mode on CPU 0
> [    0.500926] Console: switching to colour frame buffer device 128x48
> [    0.500926] fb0: VESA VGA frame buffer device
> [    0.522669] hpet_resources: 0xfed00000 is busy
> [    0.522972] Linux agpgart interface v0.103
> [    0.523133] agpgart: Detected an Intel Q35 Chipset.
> [    0.524253] agpgart: Detected 6140K stolen memory.
> [    0.536746] agpgart: AGP aperture is 256M @ 0xd0000000
> [    0.537017] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
> [    0.537407] intelfb: Version 0.9.4
> [    0.537583] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> [    0.537975] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.539001] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.540175] brd: module loaded
> [    0.540396] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
> [    0.540626] e1000e: Copyright (c) 1999-2008 Intel Corporation.
> [    0.540877] IOAPIC[0]: Set routing entry (4-20 -> 0x49 -> IRQ 20 Mode:1 Active:1)
> [    0.541164] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
> [    0.541631] PCI: Setting latency timer of device 0000:00:19.0 to 64
> [    0.716280] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:8c:7b:c8:bc
> [    0.716508] eth0: Intel(R) PRO/1000 Network Connection
> [    0.720673] eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
> [    0.725022] Fixed MDIO Bus: probed
> [    0.729744] Driver 'sd' needs updating - please use bus_type methods
> [    0.734446] ahci 0000:00:1f.2: version 3.0
> [    0.739181] IOAPIC[0]: Set routing entry (4-22 -> 0x51 -> IRQ 22 Mode:1 Active:1)
> [    0.744227] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 22
> [    1.749065] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> [    1.754458] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
> [    1.760149] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    1.766173] scsi0 : ahci
> [    1.772142] scsi1 : ahci
> [    1.778194] scsi2 : ahci
> [    1.784250] scsi3 : ahci
> [    1.790327] scsi4 : ahci
> [    1.796418] scsi5 : ahci
> [    1.802586] ata1: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79900 irq 511
> [    1.808999] ata2: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79980 irq 511
> [    1.815436] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 511
> [    1.822094] ata4: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79a80 irq 511
> [    1.828894] ata5: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79b00 irq 511
> [    1.835704] ata6: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79b80 irq 511
> [    2.283675] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.295775] ata1.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    2.302705] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.315006] ata1.00: configured for UDMA/133
> [    2.778939] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.791414] ata2.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    2.798815] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.811499] ata2.00: configured for UDMA/133
> [    3.692582] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.700915] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100, ATAPI AN
> [    3.709706] ata3.00: configured for UDMA/100
> [    4.021092] ata4: SATA link down (SStatus 0 SControl 300)
> [    4.485402] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.498458] ata5.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    4.506017] ata5.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.519852] ata5.00: configured for UDMA/133
> [    4.830888] ata6: SATA link down (SStatus 0 SControl 300)
> [    4.852884] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    4.860616] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [    4.868287] sd 0:0:0:0: [sda] Write Protect is off
> [    4.875868] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.883434] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.891147] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [    4.898765] sd 0:0:0:0: [sda] Write Protect is off
> [    4.906229] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.913623] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.921196]  sda: sda1 sda2 sda3 sda4
> [    4.936233] sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.943831] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    4.951443] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    4.959194] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
> [    4.966829] sd 1:0:0:0: [sdb] Write Protect is off
> [    4.974287] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    4.981604] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.989103] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
> [    4.996499] sd 1:0:0:0: [sdb] Write Protect is off
> [    5.003780] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    5.011166] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.018885]  sdb: sdb1 sdb2 sdb3 sdb4
> [    5.040209] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    5.048288] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    5.057072] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  SB00 PQ: 0 ANSI: 5
> [    5.065408] scsi 2:0:0:0: Attached scsi generic sg2 type 5
> [    5.073786] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    5.082274] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [    5.090649] sd 4:0:0:0: [sdc] Write Protect is off
> [    5.099081] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    5.107585] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.116286] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [    5.124928] sd 4:0:0:0: [sdc] Write Protect is off
> [    5.133481] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    5.141897] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.150476]  sdc: sdc1 sdc2 sdc3 sdc4
> [    5.179004] sd 4:0:0:0: [sdc] Attached SCSI disk
> [    5.187672] sd 4:0:0:0: Attached scsi generic sg3 type 0
> [    5.197420] IOAPIC[0]: Set routing entry (4-18 -> 0x61 -> IRQ 18 Mode:1 Active:1)
> [    5.206078] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
> [    5.215549] PCI: Setting latency timer of device 0000:00:1a.7 to 64
> [    5.224190] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    5.232902] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    5.246238] ehci_hcd 0000:00:1a.7: debug port 1
> [    5.254826] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
> [    5.263572] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfeb7b800
> [    5.281838] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    5.290536] usb usb1: configuration #1 chosen from 1 choice
> [    5.299321] hub 1-0:1.0: USB hub found
> [    5.307908] hub 1-0:1.0: 6 ports detected
> [    5.416701] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.425312] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.433889] usb usb1: Product: EHCI Host Controller
> [    5.442318] usb usb1: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
> [    5.450889] usb usb1: SerialNumber: 0000:00:1a.7
> [    5.459455] IOAPIC[0]: Set routing entry (4-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
> [    5.468112] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [    5.476751] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    5.485426] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    5.494198] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    5.506971] ehci_hcd 0000:00:1d.7: debug port 1
> [    5.515520] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> [    5.524220] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfeb7b400
> [    5.606010] usb 1-4: new high speed USB device using ehci_hcd and address 2
> [    5.631722] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    5.640508] usb usb2: configuration #1 chosen from 1 choice
> [    5.649378] hub 2-0:1.0: USB hub found
> [    5.658209] hub 2-0:1.0: 6 ports detected
> [    5.733115] usb 1-4: configuration #1 chosen from 1 choice
> [    5.735694] usb 1-4: New USB device found, idVendor=1307, idProduct=0163
> [    5.744526] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    5.767345] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.767347] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.767348] usb usb2: Product: EHCI Host Controller
> [    5.767349] usb usb2: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
> [    5.767350] usb usb2: SerialNumber: 0000:00:1d.7
> [    5.767388] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.767436] USB Universal Host Controller Interface driver v3.0
> [    5.767459] IOAPIC[0]: Set routing entry (4-16 -> 0x71 -> IRQ 16 Mode:1 Active:1)
> [    5.767461] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    5.767466] PCI: Setting latency timer of device 0000:00:1a.0 to 64
> [    5.767468] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    5.767510] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    5.767531] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e400
> [    5.767649] usb usb3: configuration #1 chosen from 1 choice
> [    5.768329] hub 3-0:1.0: USB hub found
> [    5.768333] hub 3-0:1.0: 2 ports detected
> [    5.868821] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.868822] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.868824] usb usb3: Product: UHCI Host Controller
> [    5.868825] usb usb3: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    5.868826] usb usb3: SerialNumber: 0000:00:1a.0
> [    5.868843] IOAPIC[0]: Set routing entry (4-21 -> 0x79 -> IRQ 21 Mode:1 Active:1)
> [    5.868844] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
> [    5.868848] PCI: Setting latency timer of device 0000:00:1a.1 to 64
> [    5.868850] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    5.868892] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    5.868921] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e480
> [    5.869034] usb usb4: configuration #1 chosen from 1 choice
> [    5.869073] hub 4-0:1.0: USB hub found
> [    5.869077] hub 4-0:1.0: 2 ports detected
> [    5.969670] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.969672] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.969673] usb usb4: Product: UHCI Host Controller
> [    5.969674] usb usb4: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    5.969675] usb usb4: SerialNumber: 0000:00:1a.1
> [    5.969692] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    5.969696] PCI: Setting latency timer of device 0000:00:1a.2 to 64
> [    5.969698] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    5.969737] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    5.969758] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e800
> [    5.969886] usb usb5: configuration #1 chosen from 1 choice
> [    5.969925] hub 5-0:1.0: USB hub found
> [    5.969929] hub 5-0:1.0: 2 ports detected
> [    6.070519] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.070521] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.070522] usb usb5: Product: UHCI Host Controller
> [    6.070523] usb usb5: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.070524] usb usb5: SerialNumber: 0000:00:1a.2
> [    6.070541] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [    6.070545] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    6.070547] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    6.070589] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    6.070608] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
> [    6.070728] usb usb6: configuration #1 chosen from 1 choice
> [    6.070767] hub 6-0:1.0: USB hub found
> [    6.070771] hub 6-0:1.0: 2 ports detected
> [    6.171372] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.171374] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.171375] usb usb6: Product: UHCI Host Controller
> [    6.171376] usb usb6: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.171377] usb usb6: SerialNumber: 0000:00:1d.0
> [    6.171394] IOAPIC[0]: Set routing entry (4-19 -> 0x81 -> IRQ 19 Mode:1 Active:1)
> [    6.171395] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [    6.171399] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    6.171401] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    6.171443] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    6.171471] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e000
> [    6.171586] usb usb7: configuration #1 chosen from 1 choice
> [    6.171624] hub 7-0:1.0: USB hub found
> [    6.171628] hub 7-0:1.0: 2 ports detected
> [    6.272221] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.272222] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.272223] usb usb7: Product: UHCI Host Controller
> [    6.272224] usb usb7: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.272225] usb usb7: SerialNumber: 0000:00:1d.1
> [    6.272241] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    6.272245] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    6.272247] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    6.272287] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    6.272308] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e080
> [    6.272434] usb usb8: configuration #1 chosen from 1 choice
> [    6.272473] hub 8-0:1.0: USB hub found
> [    6.272477] hub 8-0:1.0: 2 ports detected
> [    6.373073] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.373074] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.373076] usb usb8: Product: UHCI Host Controller
> [    6.373077] usb usb8: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.373078] usb usb8: SerialNumber: 0000:00:1d.2
> [    6.373120] Initializing USB Mass Storage driver...
> [    6.492410] usb 1-4: Product: USB Mass Storage Device
> [    6.500328] usb 1-4: Manufacturer: USBest Technology
> [    6.508172] usb 1-4: SerialNumber: 08021600009235
> [    6.538622] scsi6 : SCSI emulation for USB Mass Storage devices
> [    6.538622] usb-storage: device found at 2
> [    6.546180] usb-storage: waiting for device to settle before scanning
> [    6.669962] hub 2-0:1.0: unable to enumerate USB device on port 5
> [    6.986483] usb 8-1: new low speed USB device using uhci_hcd and address 2
> [    7.174035] usb 8-1: configuration #1 chosen from 1 choice
> [    7.199052] usb 8-1: New USB device found, idVendor=099a, idProduct=7202
> [    7.206910] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.214775] usb 8-1: Product: WirelessUSB
> [    7.222546] usb 8-1: Manufacturer: Cypress
> [    7.230318] usbcore: registered new interface driver usb-storage
> [    7.238233] USB Mass Storage support registered.
> [    7.246149] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    7.256548] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    7.264509] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    7.272440] mice: PS/2 mouse device common for all mice
> [    7.333311] I2O subsystem v1.325
> [    7.340923] i2o: max drivers = 8
> [    7.348627] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    7.356167] rtc0: alarms up to one month, y3k
> [    7.363629] i2c /dev entries driver
> [    7.371091] md: linear personality registered for level -1
> [    7.378571] md: raid0 personality registered for level 0
> [    7.386014] md: raid1 personality registered for level 1
> [    7.393335] md: raid10 personality registered for level 10
> [    7.417647] raid6: int64x1   2347 MB/s
> [    7.441676] raid6: int64x2   3046 MB/s
> [    7.466612] raid6: int64x4   2867 MB/s
> [    7.490407] raid6: int64x8   2125 MB/s
> [    7.515105] raid6: sse2x1    4226 MB/s
> [    7.538635] raid6: sse2x2    4988 MB/s
> [    7.561998] raid6: sse2x4    7089 MB/s
> [    7.568314] raid6: using algorithm sse2x4 (7089 MB/s)
> [    7.574619] md: raid6 personality registered for level 6
> [    7.580950] md: raid5 personality registered for level 5
> [    7.587168] md: raid4 personality registered for level 4
> [    7.593255] md: multipath personality registered for level -4
> [    7.599528] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> [    7.606116] cpuidle: using governor ladder
> [    7.612573] cpuidle: using governor menu
> [    7.619003] Advanced Linux Sound Architecture Driver Version 1.0.16.
> [    7.625517] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    7.632052] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    7.648100] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> [    7.679592] ALSA device list:
> [    7.686231]   #0: HDA Intel at 0xfeb70000 irq 22
> [    7.693119] IPv4 over IPv4 tunneling driver
> [    7.699999] GRE over IPv4 tunneling driver
> [    7.706836] TCP cubic registered
> [    7.713381] TCP hybla registered
> [    7.719821] NET: Registered protocol family 17
> [    7.726339] registered taskstats version 1
> [    7.732728] rtc_cmos 00:03: setting system clock to 2008-04-26 14:05:24 UTC (1209218724)
> [    7.739238] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
> [    7.746084] md: Autodetecting RAID arrays.
> [    7.894964] md: Scanned 11 and added 11 devices.
> [    7.901175] md: autorun ...
> [    7.907471] md: considering sdc4 ...
> [    7.913706] md:  adding sdc4 ...
> [    7.919826] md: sdc3 has different UUID to sdc4
> [    7.925884] md: sdc2 has different UUID to sdc4
> [    7.931724] md: sdc1 has different UUID to sdc4
> [    7.937554] md:  adding sdb4 ...
> [    7.943299] md: sdb3 has different UUID to sdc4
> [    7.949056] md: sdb2 has different UUID to sdc4
> [    7.954759] md:  adding sda4 ...
> [    7.960338] md: sda3 has different UUID to sdc4
> [    7.965918] md: sda2 has different UUID to sdc4
> [    7.971379] md: sda1 has different UUID to sdc4
> [    7.976796] md: created md3
> [    7.982095] md: bind<sda4>
> [    7.987407] md: bind<sdb4>
> [    7.992617] md: bind<sdc4>
> [    7.997678] md: running: <sdc4><sdb4><sda4>
> [    8.002963] md3: setting max_sectors to 128, segment boundary to 32767
> [    8.008373] raid0: looking at sdc4
> [    8.013834] raid0:   comparing sdc4(1028096) with sdc4(1028096)
> [    8.019494] raid0:   END
> [    8.025124] raid0:   ==> UNIQUE
> [    8.030788] raid0: 1 zones
> [    8.036317] raid0: looking at sdb4
> [    8.041798] raid0:   comparing sdb4(1028096) with sdc4(1028096)
> [    8.047489] raid0:   EQUAL
> [    8.053169] raid0: looking at sda4
> [    8.058791] raid0:   comparing sda4(1028096) with sdc4(1028096)
> [    8.064385] raid0:   EQUAL
> [    8.069762] raid0: FINAL 1 zones
> [    8.075154] raid0: done.
> [    8.080424] raid0 : md_size is 3084288 blocks.
> [    8.085646] raid0 : conf->hash_spacing is 3084288 blocks.
> [    8.090798] raid0 : nb_zone is 1.
> [    8.095784] raid0 : Allocating 8 bytes for hash.
> [    8.100738] md: considering sdc3 ...
> [    8.105691] md:  adding sdc3 ...
> [    8.110570] md: sdc2 has different UUID to sdc3
> [    8.115482] md: sdc1 has different UUID to sdc3
> [    8.120301] md:  adding sdb3 ...
> [    8.125157] md: sdb2 has different UUID to sdc3
> [    8.130009] md:  adding sda3 ...
> [    8.134795] md: sda2 has different UUID to sdc3
> [    8.139482] md: sda1 has different UUID to sdc3
> [    8.144015] md: created md2
> [    8.148434] md: bind<sda3>
> [    8.152777] md: bind<sdb3>
> [    8.157017] md: bind<sdc3>
> [    8.161199] md: running: <sdc3><sdb3><sda3>
> [    8.165550] md2: setting max_sectors to 128, segment boundary to 32767
> [    8.169992] raid0: looking at sdc3
> [    8.174464] raid0:   comparing sdc3(111330368) with sdc3(111330368)
> [    8.179201] raid0:   END
> [    8.183857] raid0:   ==> UNIQUE
> [    8.188470] raid0: 1 zones
> [    8.193044] raid0: looking at sdb3
> [    8.197613] raid0:   comparing sdb3(111330368) with sdc3(111330368)
> [    8.202337] raid0:   EQUAL
> [    8.207070] raid0: looking at sda3
> [    8.211869] raid0:   comparing sda3(111330368) with sdc3(111330368)
> [    8.216839] raid0:   EQUAL
> [    8.221768] raid0: FINAL 1 zones
> [    8.226753] raid0: done.
> [    8.231742] raid0 : md_size is 333991104 blocks.
> [    8.236816] raid0 : conf->hash_spacing is 333991104 blocks.
> [    8.241873] raid0 : nb_zone is 1.
> [    8.246802] raid0 : Allocating 8 bytes for hash.
> [    8.251755] md: considering sdc2 ...
> [    8.256704] md:  adding sdc2 ...
> [    8.261637] md: sdc1 has different UUID to sdc2
> [    8.266669] md:  adding sdb2 ...
> [    8.271692] md:  adding sda2 ...
> [    8.276587] md: sda1 has different UUID to sdc2
> [    8.281504] md: created md1
> [    8.286402] md: bind<sda2>
> [    8.291175] md: bind<sdb2>
> [    8.295830] md: bind<sdc2>
> [    8.300453] md: running: <sdc2><sdb2><sda2>
> [    8.305244] md1: setting max_sectors to 128, segment boundary to 32767
> [    8.310148] raid0: looking at sdc2
> [    8.314969] raid0:   comparing sdc2(97659008) with sdc2(97659008)
> [    8.319931] raid0:   END
> [    8.324807] raid0:   ==> UNIQUE
> [    8.329587] raid0: 1 zones
> [    8.334310] raid0: looking at sdb2
> [    8.339005] raid0:   comparing sdb2(97659008) with sdc2(97659008)
> [    8.343937] raid0:   EQUAL
> [    8.348793] raid0: looking at sda2
> [    8.353633] raid0:   comparing sda2(97659008) with sdc2(97659008)
> [    8.359469] raid0:   EQUAL
> [    8.364378] raid0: FINAL 1 zones
> [    8.369340] raid0: done.
> [    8.374220] raid0 : md_size is 292977024 blocks.
> [    8.379234] raid0 : conf->hash_spacing is 292977024 blocks.
> [    8.384390] raid0 : nb_zone is 1.
> [    8.389579] raid0 : Allocating 8 bytes for hash.
> [    8.394856] md: considering sdc1 ...
> [    8.400078] md:  adding sdc1 ...
> [    8.405161] md:  adding sda1 ...
> [    8.410102] md: created md0
> [    8.414928] md: bind<sda1>
> [    8.419762] md: bind<sdc1>
> [    8.424511] md: running: <sdc1><sda1>
> [    8.429420] raid1: raid set md0 active with 2 out of 2 mirrors
> [    8.434407] md: ... autorun DONE.
> [    8.464802] kjournald starting.  Commit interval 5 seconds
> [    8.464802] EXT3-fs: mounted filesystem with ordered data mode.
> [    8.464816] VFS: Mounted root (ext3 filesystem) readonly.
> [    8.464829] Freeing unused kernel memory: 324k freed
> [    9.220219] EXT3 FS on sdb1, internal journal
> [    9.657772] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
> [    9.691809] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    9.695838] ACPI: Power Button (FF) [PWRF]
> [    9.695912] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    9.701916] ACPI: Power Button (CM) [PWRB]
> [    9.709034] Driver 'sr' needs updating - please use bus_type methods
> [    9.741273] parport_pc 00:06: reported by Plug and Play ACPI
> [    9.741381] parport0: PC-style at 0x378 (0x778), irq 7sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    9.741381] Uniform CD-ROM driver Revision: 3.20
> [    9.741438] sr 2:0:0:0: Attached scsi CD-ROM sr0
> [    9.741800] , dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> [    9.786795] usbcore: registered new interface driver hiddev
> [    9.799191] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input2
> [    9.805029] input,hidraw0: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1d.2-1
> [    9.838543] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input3
> [    9.850076] input,hiddev0,hidraw1: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1d.2-1
> [    9.850093] usbcore: registered new interface driver usbhid
> [    9.850096] usbhid: v2.6:USB HID core driver
> [    9.931519] ppdev: user-space parallel port driver
> [   11.257191] EXT3 FS on sdb1, internal journal
> [   11.564421] usb-storage: device scan complete
> [   11.564421] scsi 6:0:0:0: Direct-Access     Ut163    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
> [   11.572932] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors (1011 MB)
> [   11.580614] sd 6:0:0:0: [sdd] Write Protect is off
> [   11.587640] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
> [   11.587645] sd 6:0:0:0: [sdd] Assuming drive cache: write through
> [   11.598270] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors (1011 MB)
> [   11.606383] sd 6:0:0:0: [sdd] Write Protect is off
> [   11.613424] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
> [   11.613426] sd 6:0:0:0: [sdd] Assuming drive cache: write through
> [   11.620547]  sdd: sdd1
> [   11.721531] sd 6:0:0:0: [sdd] Attached SCSI removable disk
> [   11.728267] sd 6:0:0:0: Attached scsi generic sg4 type 0
> [   11.967797] lp0: using parport0 (interrupt-driven).
> [   11.967800] lp0: console ready
> [   11.980677] loop: module loaded
> [   12.722321] kjournald starting.  Commit interval 5 seconds
> [   12.722321] EXT3 FS on md1, internal journal
> [   12.722330] EXT3-fs: mounted filesystem with ordered data mode.
> [   12.756835] kjournald starting.  Commit interval 5 seconds
> [   12.756974] EXT3 FS on md2, internal journal
> [   12.756980] EXT3-fs: mounted filesystem with ordered data mode.
> [   12.891495] Adding 3084280k swap on /dev/md3.  Priority:-1 extents:1 across:3084280k
> [   16.212658] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> [   16.212660] eth0: 10/100 speed: disabling TSO
> [   19.580143] eth0: changing MTU from 1500 to 1492
> [   21.006209] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> [   21.006214] eth0: 10/100 speed: disabling TSO
> [   24.002041] [drm] Initialized drm 1.1.0 20060810
> [   24.011746] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   24.011754] PCI: Setting latency timer of device 0000:00:02.0 to 64
> [   24.012694] [drm] Initialized i915 1.6.0 20060119 on minor 0
> [   24.175500] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [   24.423740] set status page addr 0x00033000
> 
> 
> dsdt.dsl can be found there :
> 
> http://frugalware.org/~crazy/ASUS_P5E-VM_DO/dsdt.dsl
> 
> Please let me know if you need more infos.
> 
> 
> Best Regards,
> 
> Gabriel C
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
