Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab0BRRLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:11:45 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:55513 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0BRRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:11:38 -0500
Date: Thu, 18 Feb 2010 12:11:26 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in	process
In-reply-to: <20100218023934.GC8897@atrey.karlin.mff.cuni.cz>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B7D74BE.6030906@majjas.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_tZIpJEH582SSiufVw9ywfw)"
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com>
 <20100218023934.GC8897@atrey.karlin.mff.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7)
 Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_tZIpJEH582SSiufVw9ywfw)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

On 02/17/2010 09:39 PM, Jan Kara wrote:
>> On 2/13/2010 11:51 AM, Michael Breuer wrote:
>>      
>>> Scenario:
>>>
>>> 1. raid6 (software - 6 1Tb sata drives) doing a resync (multi core
>>> enabled)
>>> 2. rebuilding kernel (rc8)
>>> 3. system became sluggish - top&  vmstat showed all 12Gb ram used -
>>> albeit 10g of fs cache. It seemed as though relcaim of fs cache became
>>> really slow once there were no more "free" pages.
>>> vmstat<after hung task reported - don't have from before>
>>> procs -----------memory---------- ---swap-- -----io---- --system--
>>> -----cpu-----
>>>     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us
>>> sy id wa st
>>>     0  1    808 112476 347592 9556952    0    0    39   388  158  189
>>> 1 18 77  4  0
>>> 4. Worrying a bit about the looming instability, I typed, "sync."
>>> 5. sync took a long time, and was reported by the kernel as a hung
>>> task (repeatedly) - see below.
>>> 6. entering additional sync commands also hang (unsuprising, but
>>> figured I'd try as non-root).
>>> 7. The running sync (pid 11975) cannot be killed.
>>> 8. echo 1>  drop_caches does clear the fs cache. System behaves better
>>> after this (but sync is still hung).
>>>
>>> config attached.
>>>
>>> Running with sky2 dma patches (in rc8) and increased the audit name
>>> space to avoid the flood of name space maxed warnings.
>>>
>>> My current plan is to let the raid rebuild complete and then reboot
>>> (to rc8 if the bits made it to disk)... maybe with a backup of
>>> recently changed files to an external system.
>>>
>>> Feb 13 10:54:13 mail kernel: INFO: task sync:11975 blocked for more
>>> than 120 seconds.
>>> Feb 13 10:54:13 mail kernel: "echo 0>
>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> Feb 13 10:54:13 mail kernel: sync          D 0000000000000002     0
>>> 11975   6433 0x00000000
>>> Feb 13 10:54:13 mail kernel: ffff8801c45f3da8 0000000000000082
>>> ffff8800282f5948 ffff8800282f5920
>>> Feb 13 10:54:13 mail kernel: ffff88032f785d78 ffff88032f785d40
>>> 000000030c37a771 0000000000000282
>>> Feb 13 10:54:13 mail kernel: ffff8801c45f3fd8 000000000000f888
>>> ffff88032ca00000 ffff8801c61c9750
>>> Feb 13 10:54:13 mail kernel: Call Trace:
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?
>>> bdi_sched_wait+0x0/0x20
>>> Feb 13 10:54:13 mail kernel: [<ffffffff8115473e>] bdi_sched_wait+0xe/0x20
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81537b4f>] __wait_on_bit+0x5f/0x90
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81154730>] ?
>>> bdi_sched_wait+0x0/0x20
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81537bf8>]
>>> out_of_line_wait_on_bit+0x78/0x90
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81078650>] ?
>>> wake_bit_function+0x0/0x50
>>> Feb 13 10:54:13 mail kernel: [<ffffffff8104ac55>] ?
>>> wake_up_process+0x15/0x20
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81155daf>]
>>> bdi_sync_writeback+0x6f/0x80
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81155de2>]
>>> sync_inodes_sb+0x22/0x100
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159902>]
>>> __sync_filesystem+0x82/0x90
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a04>]
>>> sync_filesystems+0xf4/0x120
>>> Feb 13 10:54:13 mail kernel: [<ffffffff81159a91>] sys_sync+0x21/0x40
>>> Feb 13 10:54:13 mail kernel: [<ffffffff8100b0f2>]
>>> system_call_fastpath+0x16/0x1b
>>>
>>> <this repeats every 120 seconds - all the same traceback>
>>>
>>>
>>>
>>>
>>>        
>> Note: this cleared after about 90 minutes - sync eventually completed.
>> I'm thinking that with multicore enabled the resync is able to starve
>> out normal system activities that weren't starved w/o multicore.
>>      
>    Hmm, it is a bug in writeback code. But as Linus pointed out, it's not really
> clear why it's *so* slow. So when it happens again, could you please sample for
> a while (like every second for 30 seconds) stacks of blocked tasks via
> Alt-Sysrq-W? I'd like to see where flusher threads are hanging... Thanks.
>
> 								Honza
>    
Ok - got it. Sync is still spinning, btw... attaching log extract as 
well as dmesg output.


--Boundary_(ID_tZIpJEH582SSiufVw9ywfw)
Content-type: text/plain; name=dmesg
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=dmesg

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d (mbreuer@mail.majjas.com) (gcc version 4.4.2 20091222 (Red Hat 4.4.2-20) (GCC) ) #21 SMP Sat Feb 13 10:50:16 EST 2010
Command line: ro root=/dev/mapper/vg_00-LogVol02_root usbcore.autosuspend=1 crashkernel=128M SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us pcie_aspm=force debug single
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
 BIOS-e820: 00000000bf780000 - 00000000bf798000 (ACPI data)
 BIOS-e820: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
No AGP bridge found
last_pfn = 0x340000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E3FFF write-protect
  E4000-EBFFF write-through
  EC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask F00000000 write-back
  2 base 300000000 mask FC0000000 write-back
  3 base 0C0000000 mask FC0000000 uncachable
  4 base 0BF800000 mask FFF800000 uncachable
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 8GB, type WB
reg 1, base: 8GB, range: 4GB, type WB
reg 2, base: 12GB, range: 1GB, type WB
reg 3, base: 3GB, range: 1GB, type UC
reg 4, base: 3064MB, range: 8MB, type UC
total RAM covered: 12280M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3064MB, range: 8MB, type UC
reg 3, base: 4GB, range: 4GB, type WB
reg 4, base: 8GB, range: 4GB, type WB
reg 5, base: 12GB, range: 1GB, type WB
e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf780 max_arch_pfn = 0x400000000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009cc00 (usable)
 modified: 000000000009cc00 - 00000000000a0000 (reserved)
 modified: 00000000000e4c00 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000bf780000 (usable)
 modified: 00000000bf780000 - 00000000bf798000 (ACPI data)
 modified: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 modified: 00000000bf7dc000 - 00000000c0000000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000ffe00000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000000340000000 (usable)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bf780000
 0000000000 - 00bf600000 page 2M
 00bf600000 - 00bf780000 page 4k
kernel direct mapping tables up to bf780000 @ 16000-1b000
init_memory_mapping: 0000000100000000-0000000340000000
 0100000000 - 0340000000 page 2M
kernel direct mapping tables up to 340000000 @ 19000-27000
RAMDISK: 37a81000 - 37fefdfd
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 13312MB)
ACPI: RSDP 00000000000fb1a0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000bf780100 00064 (v01 111209 XSDT1642 20091112 MSFT 00000097)
ACPI: FACP 00000000bf780290 000F4 (v03 111209 FACP1642 20091112 MSFT 00000097)
ACPI: DSDT 00000000bf7804b0 0B66D (v01  A1265 A1265001 00000001 INTL 20060113)
ACPI: FACS 00000000bf798000 00040
ACPI: APIC 00000000bf780390 000D8 (v01 111209 APIC1642 20091112 MSFT 00000097)
ACPI: MCFG 00000000bf780470 0003C (v01 111209 OEMMCFG  20091112 MSFT 00000097)
ACPI: OEMB 00000000bf798040 00072 (v01 111209 OEMB1642 20091112 MSFT 00000097)
ACPI: HPET 00000000bf78f4b0 00038 (v01 111209 OEMHPET  20091112 MSFT 00000097)
ACPI: DMAR 00000000bf7980c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
ACPI: OSFR 00000000bf78f4f0 000B0 (v01 111209 OEMOSFR  20091112 MSFT 00000097)
ACPI: SSDT 00000000bf79a470 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000340000000
Bootmem setup node 0 0000000000000000-0000000340000000
  NODE_DATA [0000000000022000 - 0000000000024fff]
  bootmap [0000000000025000 -  000000000008cfff] pages 68
(10 early reservations) ==> bootmem [0000000000 - 0340000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001d478b0]    TEXT DATA BSS ==> [0001000000 - 0001d478b0]
  #2 [0037a81000 - 0037fefdfd]          RAMDISK ==> [0037a81000 - 0037fefdfd]
  #3 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
  #4 [0001d48000 - 0001d48294]              BRK ==> [0001d48000 - 0001d48294]
  #5 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
  #6 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
  #7 [0000016000 - 0000019000]          PGTABLE ==> [0000016000 - 0000019000]
  #8 [0000019000 - 0000022000]          PGTABLE ==> [0000019000 - 0000022000]
  #9 [0002000000 - 000a000000]     CRASH KERNEL ==> [0002000000 - 000a000000]
 [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00340000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009c
    0: 0x00000100 -> 0x000bf780
    0: 0x00100000 -> 0x00340000
On node 0 totalpages: 3143436
  DMA zone: 56 pages used for memmap
  DMA zone: 118 pages reserved
  DMA zone: 3806 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765880 pages, LIFO batch:31
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 48
Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90776 r8192 d23912 u131072
pcpu-alloc: s90776 r8192 d23912 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096726
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_00-LogVol02_root usbcore.autosuspend=1 crashkernel=128M SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us pcie_aspm=force debug single
PCIe ASPM is forcedly enabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 12183248k/13631488k available (5362k kernel code, 1057744k absent, 390496k reserved, 5977k data, 728k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:768
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 125829120 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2672.865 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5345.73 BogoMIPS (lpj=2672865)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20091214
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20791 entries in 82 pages
DMAR: Host address width 39
DMAR: DRHD base: 0x000000fbfff000 flags: 0x0
IOMMU fbfff000: ver 1:0 cap c9008010e60262 ecap f0207a
DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
IOMMU fbffe000: ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
DMAR: RMRR base: 0x000000bf7dc000 end: 0x000000bf7dbfff
DMAR: ATSR flags: 0x0
IOAPIC id 8 under DRHD base 0xfbffe000
IOAPIC id 9 under DRHD base 0xfbffe000
DRHD: handling fault status reg 2
Enabled Interrupt-remapping
Setting APIC routing to physical flat
DRHD: handling fault status reg 2
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Booting Node   0, Processors  #1
CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #2
CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #3
CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #4
CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #5
CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #6
CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #7
CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Brought up 8 CPUs
Total of 8 processors activated (42972.25 BogoMIPS).
regulator: core version 0.5
Time: 15:52:51  Date: 02/18/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff] (ignored)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x9800-0x981f]
pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
pci 0000:00:1a.2: reg 20: [io  0x9c00-0x9c1f]
pci 0000:00:1a.7: reg 10: [mem 0xf7fff000-0xf7fff3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf7ff8000-0xf7ffbfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x9080-0x909f]
pci 0000:00:1d.1: reg 20: [io  0x9400-0x941f]
pci 0000:00:1d.2: reg 20: [io  0x9480-0x949f]
pci 0000:00:1d.7: reg 10: [mem 0xf7ffe000-0xf7ffe3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
pci 0000:00:1f.2: reg 10: [io  0x8c00-0x8c07]
pci 0000:00:1f.2: reg 14: [io  0x8880-0x8883]
pci 0000:00:1f.2: reg 18: [io  0x8800-0x8807]
pci 0000:00:1f.2: reg 1c: [io  0x8480-0x8483]
pci 0000:00:1f.2: reg 20: [io  0x8400-0x841f]
pci 0000:00:1f.2: reg 24: [mem 0xf7ffc000-0xf7ffc7ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xf7ffd000-0xf7ffd0ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:02:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
pci 0000:02:00.0: reg 24: [io  0xac00-0xac7f]
pci 0000:02:00.0: reg 30: [mem 0xfbae0000-0xfbafffff pref]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbafffff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci 0000:06:00.0: reg 10: [mem 0xfbdfc000-0xfbdfffff 64bit]
pci 0000:06:00.0: reg 18: [io  0xd800-0xd8ff]
pci 0000:06:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pref]
pci 0000:06:00.0: supports D1 D2
pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:05:00.0: reg 10: [io  0xcc00-0xcc07]
pci 0000:05:00.0: reg 14: [io  0xc880-0xc883]
pci 0000:05:00.0: reg 18: [io  0xc800-0xc807]
pci 0000:05:00.0: reg 1c: [io  0xc480-0xc483]
pci 0000:05:00.0: reg 20: [io  0xc400-0xc40f]
pci 0000:05:00.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:05:00.0: supports D1
pci 0000:05:00.0: PME# supported from D0 D1 D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:04:00.0: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
pci 0000:04:00.0: reg 18: [io  0xb800-0xb8ff]
pci 0000:04:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:08:01.0: reg 10: [io  0xec00-0xec3f]
pci 0000:08:01.0: supports D2
pci 0000:08:02.0: reg 10: [mem 0xfbeff000-0xfbeff7ff]
pci 0000:08:02.0: reg 14: [io  0xe880-0xe8ff]
pci 0000:08:02.0: supports D2
pci 0000:08:02.0: PME# supported from D2 D3hot D3cold
pci 0000:08:02.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
system 00:06: [io  0x0290-0x029f] has been reserved
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x0800-0x087f] has been reserved
system 00:07: [io  0x0500-0x057f] could not be reserved
system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:0e: [mem 0xfed90000-0xffffffff] could not be reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.2: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbafffff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 08-08]
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0106 -> 0107)
alloc irq_2_iommu on node 0
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
alloc irq_2_iommu on node 0
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
alloc irq_2_iommu on node 0
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbafffff]
pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0xc0000000-0xc03fffff]
pci_bus 0000:07: resource 2 [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:06: resource 1 [mem 0xfbd00000-0xfbdfffff]
pci_bus 0000:06: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
pci_bus 0000:05: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:04: resource 1 [mem 0xfbb00000-0xfbbfffff]
pci_bus 0000:04: resource 2 [mem 0xc0800000-0xc09fffff 64bit pref]
pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
pci_bus 0000:08: resource 3 [io  0x0000-0xffff]
pci_bus 0000:08: resource 4 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
pci 0000:02:00.0: Boot video device
PCI: CLS 256 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5563k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
IOMMU 0xfbfff000: using Queued invalidation
IOMMU 0xfbffe000: using Queued invalidation
------------[ cut here ]------------
WARNING: at drivers/pci/intel-iommu.c:3784 init_dmars+0x40f/0x7db()
Hardware name: System Product Name
Your BIOS is broken; DMA routed to ISOCH DMAR unit but no TLB space.
BIOS vendor: American Megatrends Inc.; Ver: 0704   ; Product Version: System Version
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d #21
Call Trace:
 [<ffffffff81057f1b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff81057fc1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81b53955>] init_dmars+0x40f/0x7db
 [<ffffffff81b53f7f>] intel_iommu_init+0x25e/0x333
 [<ffffffff81b33c95>] ? pci_iommu_init+0x0/0x47
 [<ffffffff81b33cb5>] pci_iommu_init+0x20/0x47
 [<ffffffff8100204c>] do_one_initcall+0x3c/0x1d0
 [<ffffffff81b2c736>] kernel_init+0x16b/0x1c1
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81b2c5cb>] ? kernel_init+0x0/0x1c1
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
---[ end trace 57f7151f6a5def05 ]---
IOMMU: hardware identity mapping for device 0000:00:1b.0
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7dc000 - 0xbf7dc000]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xf0000]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1266508370.802:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Btrfs loaded
msgmni has been set to 23935
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pcieport 0000:00:01.0: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:01.0: irq 50 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:03.0: irq 51 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:07.0: irq 52 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:1c.0: irq 53 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:1c.2: irq 54 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:1c.4: irq 55 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
alloc irq_2_iommu on node 0
pcieport 0000:00:1c.5: irq 56 for MSI/MSI-X
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: SSDT 00000000bf798200 01C0C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
ACPI: SSDT 00000000bf799e10 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
alloc irq_2_iommu on node 0
ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
alloc irq_2_iommu on node 0
ahci 0000:00:1f.2: irq 57 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc100 irq 57
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 57
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 57
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 57
ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 57
ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 57
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fff000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
alloc irq_2_iommu on node 0
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7ffe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
alloc irq_2_iommu on node 0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
alloc irq_2_iommu on node 0
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009c00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 14:257:892
bdi default: hash matches
rtc_cmos 00:03: setting system clock to 2010-02-18 15:52:51 UTC (1266508371)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: New USB device found, idVendor=0409, idProduct=005a
usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
usb 7-1: new full speed USB device using uhci_hcd and address 2
usb 7-1: New USB device found, idVendor=0733, idProduct=0430
usb 7-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 7-2: new low speed USB device using uhci_hcd and address 3
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
usb 7-2: New USB device found, idVendor=051d, idProduct=0002
usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 7-2: Product: Back-UPS ES 550 FW:843.K1d.D USB FW:K1d
usb 7-2: Manufacturer: APC
usb 7-2: SerialNumber: 3B1806X13792  
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [APC Back-UPS ES 550 FW:843.K1d.D USB FW:K1d] on usb-0000:00:1d.1-2/input0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: WDC WD10EADS-65L5B1, 01.01A01, max UDMA/133
ata5.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata5.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD10EADS-65L 01.0 PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: WDC WD10EADS-65L5B1, 01.01A01, max UDMA/133
ata6.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EADS-65L 01.0 PQ: 0 ANSI: 5
sd 5:0:0:0: Attached scsi generic sg5 type 0
sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
sd 5:0:0:0: [sdf] Attached SCSI disk
Freeing unused kernel memory: 728k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 764k freed
Freeing unused kernel memory: 1840k freed
dracut: dracut-004-4.fc12
udev: starting version 147
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
alloc irq_2_iommu on node 0
nouveau 0000:02:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
nouveau 0000:02:00.0: setting latency timer to 64
[drm] nouveau 0000:02:00.0: Detected an NV50 generation card (0x450300a2)
[drm] nouveau 0000:02:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:02:00.0: ... appears to be valid
[drm] nouveau 0000:02:00.0: BIT BIOS found
[drm] nouveau 0000:02:00.0: Bios version 60.80.18.00
[drm] nouveau 0000:02:00.0: TMDS table revision 2.0 not currently supported
[drm] nouveau 0000:02:00.0: BIT table 'd' not found
[drm] nouveau 0000:02:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:02:00.0: DCB connector table: VHER 0x40 5 14 2
[drm] nouveau 0000:02:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[drm] nouveau 0000:02:00.0:   1: 0x00002130: type 0x30 idx 1 tag 0x08
[drm] nouveau 0000:02:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0:   3: 0x00000211: type 0x11 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0:   4: 0x00000213: type 0x13 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0: Raw DCB entry 0: 04000320 00000028
[drm] nouveau 0000:02:00.0: Raw DCB entry 1: 01000322 00000030
[drm] nouveau 0000:02:00.0: Raw DCB entry 2: 02011310 00000028
[drm] nouveau 0000:02:00.0: Raw DCB entry 3: 02011312 00000030
[drm] nouveau 0000:02:00.0: Raw DCB entry 4: 010223f1 00c1c020
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 0 at offset 0xBFB4
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 1 at offset 0xC1BF
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 2 at offset 0xD37B
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 3 at offset 0xD46A
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 4 at offset 0xD621
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table at offset 0xD686
[drm] nouveau 0000:02:00.0: 0xD686: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:02:00.0: 0xB284: parsing output script 0
[drm] nouveau 0000:02:00.0: 0xB284: parsing output script 0
[drm] nouveau 0000:02:00.0: 0xA8FA: parsing output script 0
[TTM] Zone  kernel: Available graphics memory: 6129048 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] nouveau 0000:02:00.0: 320 MiB VRAM
[drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
nouveau 0000:02:00.0: firmware: requesting nouveau/nv50.ctxprog
dracut: 
dracut: udevadm settle - timeout of 30 seconds reached, the event queue contains:
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0 (939)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/controlD64 (1027)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0 (1028)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-0 (1029)
dracut: Starting plymouth daemon
pata_marvell 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_marvell 0000:05:00.0: setting latency timer to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
ata8: PATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
ata7.01: NODEV after polling detection
ata7.00: ATAPI: HP  DVD Writer 400, KH27, max UDMA/33
ata7.00: configured for UDMA/33
scsi 6:0:0:0: CD-ROM            HP       DVD Writer 400c  KH27 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 94x/62x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg6 type 5
firewire_ohci 0000:08:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
firewire_ohci: Added fw-ohci device 0000:08:02.0, OHCI version 1.10
firewire_core: created device fw0: GUID 001e8c0001e5e584, S400
[drm] nouveau 0000:02:00.0: No ctxprog for NV50
[drm] nouveau 0000:02:00.0: Detected a DAC output
[drm] nouveau 0000:02:00.0: Detected a TMDS output
[drm] nouveau 0000:02:00.0: Detected a DAC output
[drm] nouveau 0000:02:00.0: Detected a TMDS output
[drm] nouveau 0000:02:00.0: DCB encoder 1 unknown
[drm] nouveau 0000:02:00.0: Detected a DVI-I connector
[drm] nouveau 0000:02:00.0: Detected a DVI-I connector
[drm] nouveau 0000:02:00.0: allocated 1680x1050 fb: 0x401c0000, bo ffff88032f2c5a00
fb0: nouveaufb frame buffer device
registered panic notifier
[drm] Initialized nouveau 0.0.15 20090420 for 0000:02:00.0 on minor 0
dracut: Autoassembling MD Raid
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 209649664
dracut: mdadm: /dev/md0 has been started with 2 drives.
 md0: unknown partition table
md: md1 stopped.
md: bind<sdb2>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sdf1>
md: bind<sde1>
md: bind<sda2>
async_tx: api initialized (async)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  9972.000 MB/sec
xor: using function: generic_sse (9972.000 MB/sec)
raid6: int64x1   2421 MB/s
raid6: int64x2   2945 MB/s
raid6: int64x4   2140 MB/s
raid6: int64x8   2195 MB/s
raid6: sse2x1    6605 MB/s
raid6: sse2x2    7757 MB/s
raid6: sse2x4    8472 MB/s
raid6: using algorithm sse2x4 (8472 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: md1 is not clean -- starting background reconstruction
raid5: device sda2 operational as raid disk 0
raid5: device sde1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 6394kB for md1
0: w=1 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
5: w=2 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
4: w=3 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
3: w=4 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
2: w=5 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
1: w=6 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
raid5: raid level 6 set md1 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
 --- rd:6 wd:6
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sdf1
 disk 5, o:1, dev:sde1
md1: detected capacity change from 0 to 3999969837056
dracut: mdadm: /dev/md1 has been started with 6 drives.
 md1:
md: resync of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
 unknown partition table
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 976555136 blocks.
dracut: Scanning devices md1  for LVM volume groups 
dracut: Reading all physical volumes. This may take a while...
dracut: Found volume group "vg_00" using metadata type lvm2
dracut: 13 logical volume(s) in volume group "vg_00" now active
dracut: Autoassembling MD Raid
EXT4-fs (dm-3): INFO: recovery required on readonly filesystem
EXT4-fs (dm-3): write access will be enabled during recovery
EXT4-fs (dm-3): recovery complete
EXT4-fs (dm-3): mounted filesystem with ordered data mode
dracut: Remounting /dev/mapper/vg_00-LogVol02_root with -o ro,relatime
EXT4-fs (dm-3): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/mapper/vg_00-LogVol02_root
dracut: Loading SELinux policy
type=1404 audit(1266508439.512:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 131556 rules.
SELinux: 8192 avtab hash slots, 131556 rules.
SELinux:  8 users, 12 roles, 2787 types, 129 bools, 1 sens, 1024 cats
SELinux:  74 classes, 131556 rules
SELinux:  Permission module_request in class system not defined in policy.
SELinux:  Class tun_socket not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-3, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1266508439.682:3): policy loaded auid=4294967295 ses=4294967295
dracut: Switching root
Console: switching to colour frame buffer device 210x65
[drm] nouveau 0000:02:00.0: 0x0FA9: parsing clock script 0
type=1400 audit(1266508440.531:4): avc:  denied  { associate } for  pid=802 comm="restorecon" name="ptmx" dev=devpts ino=2 scontext=system_u:object_r:ptmx_t:s0 tcontext=system_u:object_r:devpts_t:s0 tclass=filesystem
type=1400 audit(1266508440.809:5): avc:  denied  { associate } for  pid=846 comm="restorecon" name="ptmx" dev=devpts ino=2 scontext=system_u:object_r:ptmx_t:s0 tcontext=system_u:object_r:devpts_t:s0 tclass=filesystem
udev: starting version 147
iTCO_vendor_support: vendor-support=0
ACPI: WMI: Mapper loaded
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=1)
input: PC Speaker as /devices/platform/pcspkr/input/input3
sky2 driver version 1.26
sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:06:00.0: setting latency timer to 64
sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
alloc irq_2_iommu on node 0
sky2 0000:06:00.0: irq 58 for MSI/MSI-X
sky2 eth0: addr 00:26:18:00:1c:3b
sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
alloc irq_2_iommu on node 0
sky2 0000:04:00.0: irq 59 for MSI/MSI-X
sky2 eth1: addr 00:26:18:00:1c:3a
Linux video capture interface: v2.00
gspca: main v2.8.0 registered
gspca: probing 0733:0430
gspca: video0 created
usbcore: registered new interface driver spca505
spca505: registered
ENS1371 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
alloc irq_2_iommu on node 0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
alloc irq_2_iommu on node 0
HDA Intel 0000:00:1b.0: irq 60 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: AD1989B: BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=4 (0x12/0x16/0x24/0x25/0x0)
ALSA sound/pci/hda/hda_codec.c:4288:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4292:    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4293:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4296:    dig-out=0x1b/0x1d
ALSA sound/pci/hda/hda_codec.c:4304:    inputs: mic=0x17, fmic=0x14, line=0x15, fline=0x0, cd=0x18, aux=0x0
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 6:0:0:0: [sr0] Sense Key : Illegal Request [current] 
sr 6:0:0:0: [sr0] Add. Sense: Read of scrambled sector without authentication
sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 3e 5d 1e 00 00 02 00
end_request: I/O error, dev sr0, sector 16348280
Buffer I/O error on device sr0, logical block 4087070
Buffer I/O error on device sr0, logical block 4087071
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 6:0:0:0: [sr0] Sense Key : Illegal Request [current] 
sr 6:0:0:0: [sr0] Add. Sense: Read of scrambled sector without authentication
sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 3e 5d 1e 00 00 02 00
end_request: I/O error, dev sr0, sector 16348280
Buffer I/O error on device sr0, logical block 4087070
Buffer I/O error on device sr0, logical block 4087071
gameport: ES137x is pci0000:08:01.0/gameport0, io 0x200, speed 644kHz
device-mapper: multipath: version 1.1.1 loaded
EXT4-fs (dm-6): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-6, type ext4), uses xattr
EXT4-fs (dm-1): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-1, type ext4), uses xattr
EXT4-fs (dm-5): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-5, type ext4), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md0): using internal journal
EXT3-fs (md0): mounted filesystem with ordered data mode
SELinux: initialized (dev md0, type ext3), uses xattr
EXT4-fs (dm-7): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-7, type ext4), uses xattr
EXT4-fs (dm-8): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-8, type ext4), uses xattr
EXT4-fs (dm-4): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-4, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-2, type ext4), uses xattr
device fsid 834fc529ea4ea2c5-f9308b94bfd9cac devid 1 transid 24915 /dev/mapper/vg_00-kvm_guest_btrfs_test
SELinux: initialized (dev dm-9, type btrfs), uses xattr
EXT4-fs (dm-10): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-10, type ext4), uses xattr
Adding 17432568k swap on /dev/mapper/vg_00-LogVol00_swap.  Priority:-1 extents:1 across:17432568k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
sky2 eth1: enabling interface
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth1: Link is up at 100 Mbps, full duplex, flow control rx
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 6:0:0:0: [sr0] Sense Key : Illegal Request [current] 
sr 6:0:0:0: [sr0] Add. Sense: Read of scrambled sector without authentication
sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 3e 5d 1e 00 00 02 00
end_request: I/O error, dev sr0, sector 16348280
Buffer I/O error on device sr0, logical block 4087070
Buffer I/O error on device sr0, logical block 4087071
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 6:0:0:0: [sr0] Sense Key : Illegal Request [current] 
sr 6:0:0:0: [sr0] Add. Sense: Read of scrambled sector without authentication
sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 3e 5d 1e 00 00 02 00
end_request: I/O error, dev sr0, sector 16348280
Buffer I/O error on device sr0, logical block 4087070
Buffer I/O error on device sr0, logical block 4087071
coretemp coretemp.0: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.1: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.2: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.3: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.4: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.5: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.6: Unable to access MSR 0xEE, for Tjmax, left at default
coretemp coretemp.7: Unable to access MSR 0xEE, for Tjmax, left at default
w83627ehf: Found W83667HG chip at 0x290
ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
device eth0 entered promiscuous mode
type=1400 audit(1266508513.301:6): avc:  denied  { create } for  pid=3616 comm="dovecot" name="dovecot.conf" scontext=system_u:system_r:dovecot_t:s0 tcontext=system_u:object_r:dovecot_var_run_t:s0 tclass=lnk_file
NET: Registered protocol family 5
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
lo: Disabled Privacy Extensions
sit0: Disabled Privacy Extensions
SELinux: initialized (dev proc, type proc), uses genfs_contexts
sit1: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
microcode: CPU0 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
[drm] nouveau 0000:02:00.0: unknown parameter -2401039834048102397
microcode: CPU1 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
python[5430]: segfault at 8 ip 00000032f42078cf sp 00007fff791cb330 error 4 in libQtGui.so.4.6.0[32f4000000+a5a000]
Process 5430(python) has RLIMIT_CORE set to 0
Aborting core
type=1400 audit(1266508644.200:7): avc:  denied  { unlink } for  pid=6089 comm="dovecot" name="dovecot.conf" dev=dm-1 ino=6782 scontext=unconfined_u:system_r:dovecot_t:s0 tcontext=system_u:object_r:dovecot_var_run_t:s0 tclass=lnk_file
type=1400 audit(1266508644.200:8): avc:  denied  { create } for  pid=6089 comm="dovecot" name="dovecot.conf" scontext=unconfined_u:system_r:dovecot_t:s0 tcontext=unconfined_u:object_r:dovecot_var_run_t:s0 tclass=lnk_file
microcode: CPU2 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU3 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU4 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU5 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU6 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: CPU7 sig=0x106a5, pf=0x2, revision=0xf
platform microcode: firmware: requesting intel-ucode/06-1a-05
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
type=1400 audit(1266509029.933:9): avc:  denied  { append } for  pid=12539 comm="microcode_ctl" path="/tmp/nohup.out" dev=dm-6 ino=20 scontext=system_u:system_r:cpucontrol_t:s0 tcontext=system_u:object_r:initrc_tmp_t:s0 tclass=file
type=1400 audit(1266509029.933:10): avc:  denied  { append } for  pid=12539 comm="microcode_ctl" path="/tmp/nohup.out" dev=dm-6 ino=20 scontext=system_u:system_r:cpucontrol_t:s0 tcontext=system_u:object_r:initrc_tmp_t:s0 tclass=file
microcode: CPU0 updated to revision 0x11, date = 2009-04-14 
microcode: CPU1 updated to revision 0x11, date = 2009-04-14 
microcode: CPU2 updated to revision 0x11, date = 2009-04-14 
microcode: CPU3 updated to revision 0x11, date = 2009-04-14 
microcode: CPU4 updated to revision 0x11, date = 2009-04-14 
microcode: CPU5 updated to revision 0x11, date = 2009-04-14 
microcode: CPU6 updated to revision 0x11, date = 2009-04-14 
microcode: CPU7 updated to revision 0x11, date = 2009-04-14 
microcode: Microcode Update Driver: v2.00 removed.
INFO: task sync:8857 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000002     0  8857   7695 0x00000000
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
INFO: task sync:8857 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000002     0  8857   7695 0x00000004
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
INFO: task sync:8857 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000002     0  8857   7695 0x00000004
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
INFO: task sync:8857 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000002     0  8857   7695 0x00000004
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
SysRq : Show Blocked State
  task                        PC stack   pid father
md1_resync    D ffff88002822f888     0   561      2 0x00000000
 ffff88032d615b60 0000000000000046 0000000000000000 0000000000000005
 ffff88032d615b20 ffffffffa0160447 ffff88032ccd3250 00000001002841d8
 ffff88032d615fd8 000000000000f888 ffff88033251c5f0 ffff88032ccd2ea0
Call Trace:
 [<ffffffffa0160447>] ? unplug_slaves+0x97/0xe0 [raid456]
 [<ffffffffa0162b31>] get_active_stripe+0x2f1/0x8c0 [raid456]
 [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
 [<ffffffffa016671c>] sync_request+0x36c/0x380 [raid456]
 [<ffffffffa0161902>] ? raid5_unplug_device+0x82/0x110 [raid456]
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81426b04>] md_do_sync+0x6a4/0xc30
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff814258ac>] md_thread+0x5c/0x130
 [<ffffffff81425850>] ? md_thread+0x0/0x130
 [<ffffffff81078106>] kthread+0x96/0xa0
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81078070>] ? kthread+0x0/0xa0
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
kdmflush      D ffff8800282ef888     0   634      2 0x00000000
 ffff88032c9e5a40 0000000000000046 ffff88032c9e5a08 ffff88032c9e5a04
 ffff8800282b58c0 ffff8800282ef888 ffff88032cb0c9a0 0000000100284222
 ffff88032c9e5fd8 000000000000f888 ffff8803325c2ea0 ffff88032cb0c5f0
Call Trace:
 [<ffffffff81426395>] md_barrier_request+0xb5/0x180
 [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
 [<ffffffffa0167b71>] make_request+0x5f1/0x610 [raid456]
 [<ffffffff81042aa4>] ? __enqueue_entity+0x84/0x90
 [<ffffffff8104c005>] ? enqueue_entity+0xd5/0x360
 [<ffffffff81052070>] ? tg_shares_up+0x2b0/0x2c0
 [<ffffffff81424e54>] md_make_request+0xc4/0x150
 [<ffffffff812b59ff>] generic_make_request+0x1af/0x500
 [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff810e7b23>] ? mempool_alloc+0x63/0x140
 [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff81434fab>] __map_bio+0xab/0x130
 [<ffffffff814356ed>] __split_and_process_bio+0x5ed/0x660
 [<ffffffff810789ab>] ? remove_wait_queue+0x5b/0x70
 [<ffffffff81432fb0>] ? dm_wait_for_completion+0x100/0x140
 [<ffffffff814357b6>] dm_flush+0x56/0x70
 [<ffffffff8143581a>] dm_wq_work+0x4a/0x1d0
 [<ffffffff814357d0>] ? dm_wq_work+0x0/0x1d0
 [<ffffffff810744ad>] worker_thread+0x17d/0x2d0
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81074330>] ? worker_thread+0x0/0x2d0
 [<ffffffff81078106>] kthread+0x96/0xa0
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81078070>] ? kthread+0x0/0xa0
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
kdmflush      D ffff88032bd35d80     0   652      2 0x00000000
 ffff88032bd35d40 0000000000000046 ffff88032bd35cc0 ffffffff812af4d4
 ffff88032d64b540 ffff88032c9eeaf8 ffff88032bd35d30 ffffffff8143615c
 ffff88032bd35fd8 000000000000f888 ffff88032cc6c5f0 ffff88032f092ea0
Call Trace:
 [<ffffffff812af4d4>] ? blk_unplug+0x34/0x70
 [<ffffffff8143615c>] ? dm_table_unplug_all+0x5c/0xd0
 [<ffffffff81082d69>] ? ktime_get_ts+0xa9/0xe0
 [<ffffffff815374c3>] io_schedule+0x73/0xc0
 [<ffffffff81432f5b>] dm_wait_for_completion+0xab/0x140
 [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
 [<ffffffff814357c3>] dm_flush+0x63/0x70
 [<ffffffff8143581a>] dm_wq_work+0x4a/0x1d0
 [<ffffffff814357d0>] ? dm_wq_work+0x0/0x1d0
 [<ffffffff810744ad>] worker_thread+0x17d/0x2d0
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81074330>] ? worker_thread+0x0/0x2d0
 [<ffffffff81078106>] kthread+0x96/0xa0
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81078070>] ? kthread+0x0/0xa0
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
jbd2/dm-7-8   D 0000000000000002     0  1463      2 0x00000000
 ffff88032bc99c30 0000000000000046 ffff88032bc99cd0 0000000000000002
 ffff88032bc99bc0 0000000000000282 ffff88032f2dc438 ffff88032f2dc438
 ffff88032bc99fd8 000000000000f888 ffff8803325ac5f0 ffff8803303b0000
Call Trace:
 [<ffffffff81082d69>] ? ktime_get_ts+0xa9/0xe0
 [<ffffffff8115b640>] ? sync_buffer+0x0/0x50
 [<ffffffff815374c3>] io_schedule+0x73/0xc0
 [<ffffffff8115b680>] sync_buffer+0x40/0x50
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff8115b640>] ? sync_buffer+0x0/0x50
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8115b636>] __wait_on_buffer+0x26/0x30
 [<ffffffff811fbfe3>] jbd2_journal_commit_transaction+0x1173/0x1370
 [<ffffffff810696db>] ? try_to_del_timer_sync+0x7b/0xe0
 [<ffffffff81201b23>] kjournald2+0xb3/0x200
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81201a70>] ? kjournald2+0x0/0x200
 [<ffffffff81078106>] kthread+0x96/0xa0
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81078070>] ? kthread+0x0/0xa0
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
flush-253:7   D ffff880330be7024     0  1603      2 0x00000000
 ffff88033005fb10 0000000000000046 ffff88033005fad0 ffffffff8104aac6
 00000000000158c0 0000000000000286 ffff88033005fb40 0000000000000002
 ffff88033005ffd8 000000000000f888 ffff8802ca3cdd40 ffff880330549750
Call Trace:
 [<ffffffff8104aac6>] ? try_to_wake_up+0x2d6/0x410
 [<ffffffff81078920>] ? prepare_to_wait+0x60/0x90
 [<ffffffff81200fbd>] jbd2_log_wait_commit+0xbd/0x130
 [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff811fa7bb>] jbd2_journal_stop+0x24b/0x2b0
 [<ffffffff811f9915>] ? jbd2_journal_start+0xb5/0x100
 [<ffffffff811fa847>] jbd2_journal_force_commit+0x27/0x30
 [<ffffffff811d0587>] ext4_force_commit+0x27/0x40
 [<ffffffff811c3a55>] ext4_write_inode+0x75/0x100
 [<ffffffff81155104>] writeback_single_inode+0x294/0x3b0
 [<ffffffff8115567a>] writeback_inodes_wb+0x31a/0x4c0
 [<ffffffff8115593a>] wb_writeback+0x11a/0x1e0
 [<ffffffff815379f6>] ? schedule_timeout+0x196/0x2f0
 [<ffffffff81155c1f>] wb_do_writeback+0x12f/0x1a0
 [<ffffffff81155ce3>] bdi_writeback_task+0x53/0xe0
 [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff810fea11>] bdi_start_fn+0x71/0xe0
 [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff81078106>] kthread+0x96/0xa0
 [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81539f3d>] ? restore_args+0x0/0x30
 [<ffffffff81078070>] ? kthread+0x0/0xa0
 [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
sync          D 0000000000000002     0  8857   7695 0x00000004
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
postmaster    D ffff8802cb3a45f0     0 18639   3579 0x00000000
 ffff8801503bdcd8 0000000000000082 ffff880182219d40 0000000000000001
 0000000000000000 ffff88032eaf6000 ffff8801503bdc78 0000000000000282
 ffff8801503bdfd8 000000000000f888 ffff8803303b0000 ffff8802cb3a45f0
Call Trace:
 [<ffffffff81537a7d>] schedule_timeout+0x21d/0x2f0
 [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff812b59ff>] ? generic_make_request+0x1af/0x500
 [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff81537687>] wait_for_common+0xd7/0x180
 [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
 [<ffffffff812b5dca>] ? submit_bio+0x7a/0x100
 [<ffffffff815377ed>] wait_for_completion+0x1d/0x20
 [<ffffffff812b8d9e>] blkdev_issue_flush+0xae/0xf0
 [<ffffffff810ee5b1>] ? do_writepages+0x21/0x40
 [<ffffffff811b8d63>] ext4_sync_file+0x183/0x260
 [<ffffffff811596e1>] vfs_fsync_range+0xa1/0xe0
 [<ffffffff8115979d>] vfs_fsync+0x1d/0x20
 [<ffffffff811597de>] do_fsync+0x3e/0x60
 [<ffffffff81159813>] sys_fdatasync+0x13/0x20
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Sched Debug Version: v0.09, 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d #21
now at 2938448.414048 msecs
  .jiffies                                 : 4297605744
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 4.000000
  .sysctl_sched_wakeup_granularity         : 4.000000
  .sysctl_sched_child_runs_first           : 0.000000
  .sysctl_sched_features                   : 7917179
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 134686824
  .nr_load_updates               : 1281122
  .nr_uninterruptible            : 0
  .next_balance                  : 4297.605699
  .curr->pid                     : 0
  .clock                         : 2937721.835342
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 577
  .cpu_load[2]                   : 537
  .cpu_load[3]                   : 474
  .cpu_load[4]                   : 687
  .yld_count                     : 2179
  .sched_switch                  : 0
  .sched_count                   : 134863996
  .sched_goidle                  : 48141106
  .avg_idle                      : 458995
  .ttwu_count                    : 78680280
  .ttwu_local                    : 4496020
  .bkl_count                     : 351

cfs_rq[0]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[0]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[0]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[0]:/
  .exec_clock                    : 831063.731410
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 910569.170957
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 82
  .shares                        : 0

rt_rq[0]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[0]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 128338781
  .nr_load_updates               : 1584758
  .nr_uninterruptible            : 1
  .next_balance                  : 4297.605592
  .curr->pid                     : 0
  .clock                         : 2937722.634663
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 104
  .cpu_load[2]                   : 324
  .cpu_load[3]                   : 630
  .cpu_load[4]                   : 1218
  .yld_count                     : 1286
  .sched_switch                  : 0
  .sched_count                   : 128493519
  .sched_goidle                  : 21906138
  .avg_idle                      : 768015
  .ttwu_count                    : 88178065
  .ttwu_local                    : 39103643
  .bkl_count                     : 170

cfs_rq[1]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[1]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[1]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[1]:/
  .exec_clock                    : 1321765.698195
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1333183.012215
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 422613.841258
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 92
  .shares                        : 0

rt_rq[1]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[1]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.034164
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#2, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 157844766
  .nr_load_updates               : 1182336
  .nr_uninterruptible            : 1
  .next_balance                  : 4297.605699
  .curr->pid                     : 0
  .clock                         : 2937721.848727
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 116
  .cpu_load[2]                   : 357
  .cpu_load[3]                   : 675
  .cpu_load[4]                   : 991
  .yld_count                     : 793
  .sched_switch                  : 0
  .sched_count                   : 157976044
  .sched_goidle                  : 55984920
  .avg_idle                      : 94669
  .ttwu_count                    : 92705306
  .ttwu_local                    : 2983561
  .bkl_count                     : 150

cfs_rq[2]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[2]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[2]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[2]:/
  .exec_clock                    : 837719.325564
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 861710.950534
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -48858.220423
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 8
  .shares                        : 0

rt_rq[2]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[2]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#3, 2672.865 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 153216813
  .nr_load_updates               : 1168964
  .nr_uninterruptible            : 0
  .next_balance                  : 4297.605700
  .curr->pid                     : 0
  .clock                         : 2937748.246172
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 1048
  .cpu_load[2]                   : 1504
  .cpu_load[3]                   : 1433
  .cpu_load[4]                   : 1063
  .yld_count                     : 1028
  .sched_switch                  : 0
  .sched_count                   : 153323615
  .sched_goidle                  : 54830578
  .avg_idle                      : 1000000
  .ttwu_count                    : 89232671
  .ttwu_local                    : 2800728
  .bkl_count                     : 195

cfs_rq[3]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[3]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[3]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[3]:/
  .exec_clock                    : 824572.846668
  .MIN_vruntime                  : 861481.339829
  .min_vruntime                  : 861491.336952
  .max_vruntime                  : 861481.350774
  .spread                        : 0.010945
  .spread0                       : -49077.834005
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 39
  .shares                        : 0

rt_rq[3]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[3]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        events/3    30    861481.339829      6488   120    861481.339829        60.647940   2936630.992574 /
 hald-addon-inpu  3026    861481.350774       142   120    861481.350774         5.011627   2807647.638216 /

cpu#4, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 121473656
  .nr_load_updates               : 1221883
  .nr_uninterruptible            : 0
  .next_balance                  : 4297.605699
  .curr->pid                     : 0
  .clock                         : 2937721.807370
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 1115
  .cpu_load[2]                   : 1473
  .cpu_load[3]                   : 1389
  .cpu_load[4]                   : 1075
  .yld_count                     : 856
  .sched_switch                  : 0
  .sched_count                   : 121582377
  .sched_goidle                  : 42407638
  .avg_idle                      : 773584
  .ttwu_count                    : 69900030
  .ttwu_local                    : 2923984
  .bkl_count                     : 195

cfs_rq[4]:/4278
  .exec_clock                    : 0.513963
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 9.460509
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910559.710448
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 166875.092535
  .se->vruntime                  : 154674.298465
  .se->sum_exec_runtime          : 0.513963
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.391672
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.016821
  .se->wait_sum                  : 0.022134
  .se->wait_count                : 2
  .se->load.weight               : 128

cfs_rq[4]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[4]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[4]:/
  .exec_clock                    : 808415.284243
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1108129.509824
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 197560.338867
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 181
  .shares                        : 0

rt_rq[4]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[4]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[4]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[4]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#5, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 99631583
  .nr_load_updates               : 1491913
  .nr_uninterruptible            : 1
  .next_balance                  : 4297.605825
  .curr->pid                     : 0
  .clock                         : 2937739.602864
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 216
  .cpu_load[2]                   : 1098
  .cpu_load[3]                   : 2424
  .cpu_load[4]                   : 3702
  .yld_count                     : 439
  .sched_switch                  : 0
  .sched_count                   : 99763445
  .sched_goidle                  : 22256354
  .avg_idle                      : 1000000
  .ttwu_count                    : 68707534
  .ttwu_local                    : 30750066
  .bkl_count                     : 218

cfs_rq[5]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[5]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[5]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[5]:/
  .exec_clock                    : 1196982.861270
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1294340.356752
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 383771.185795
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 13
  .shares                        : 0

rt_rq[5]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[5]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[5]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[5]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.002488
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#6, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 122344929
  .nr_load_updates               : 1152991
  .nr_uninterruptible            : 3
  .next_balance                  : 4297.605719
  .curr->pid                     : 0
  .clock                         : 2937721.848735
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 81
  .cpu_load[2]                   : 319
  .cpu_load[3]                   : 428
  .cpu_load[4]                   : 506
  .yld_count                     : 1767
  .sched_switch                  : 0
  .sched_count                   : 122466252
  .sched_goidle                  : 42563935
  .avg_idle                      : 348190
  .ttwu_count                    : 70413787
  .ttwu_local                    : 2434050
  .bkl_count                     : 137

cfs_rq[6]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[6]:/4276
  .exec_clock                    : 0.393489
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 9.340035
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910559.830922
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 166853.172288
  .se->vruntime                  : 12759.624907
  .se->sum_exec_runtime          : 0.393489
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.337543
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.068387
  .se->wait_sum                  : 0.072025
  .se->wait_count                : 3
  .se->load.weight               : 128

cfs_rq[6]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 128

cfs_rq[6]:/
  .exec_clock                    : 819163.486321
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 997853.813981
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 87284.643024
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 34
  .shares                        : 0

rt_rq[6]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[6]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[6]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[6]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#7, 2672.865 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 112094254
  .nr_load_updates               : 1143968
  .nr_uninterruptible            : 1
  .next_balance                  : 4297.605699
  .curr->pid                     : 0
  .clock                         : 2937721.770646
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 648
  .cpu_load[2]                   : 816
  .cpu_load[3]                   : 687
  .cpu_load[4]                   : 484
  .yld_count                     : 938
  .sched_switch                  : 0
  .sched_count                   : 112195739
  .sched_goidle                  : 38534900
  .avg_idle                      : 680714
  .ttwu_count                    : 64269366
  .ttwu_local                    : 2194002
  .bkl_count                     : 128

cfs_rq[7]:/4278
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[7]:/4276
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[7]:/libvirt
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : -1.048576
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -910570.219533
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0
  .se->exec_start                : 0.000000
  .se->vruntime                  : 0.000000
  .se->sum_exec_runtime          : 0.000000
  .se->wait_start                : 0.000000
  .se->sleep_start               : 0.000000
  .se->block_start               : 0.000000
  .se->sleep_max                 : 0.000000
  .se->block_max                 : 0.000000
  .se->exec_max                  : 0.000000
  .se->slice_max                 : 0.000000
  .se->wait_max                  : 0.000000
  .se->wait_sum                  : 0.000000
  .se->wait_count                : 0
  .se->load.weight               : 512

cfs_rq[7]:/
  .exec_clock                    : 817623.826026
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1001651.264498
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 91082.093541
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 239
  .shares                        : 0

rt_rq[7]:/4278
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[7]:/4276
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[7]:/libvirt
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000000

rt_rq[7]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

INFO: task sync:8857 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000002     0  8857   7695 0x00000004
 ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
 ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
 ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Call Trace:
 [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
 [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
 [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
 [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
 [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
 [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
 [<ffffffff81159932>] __sync_filesystem+0x82/0x90
 [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
 [<ffffffff81159ac1>] sys_sync+0x21/0x40
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

--Boundary_(ID_tZIpJEH582SSiufVw9ywfw)
Content-type: text/plain; name=messages
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=messages

Feb 18 11:34:51 mail kernel: INFO: task sync:8857 blocked for more than 120 seconds.
Feb 18 11:34:51 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 18 11:34:51 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000000
Feb 18 11:34:51 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:34:51 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:34:51 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:34:51 mail kernel: Call Trace:
Feb 18 11:34:51 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:34:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:34:51 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:34:51 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:34:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:34:51 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:34:51 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:34:51 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:34:51 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:34:51 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:34:51 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:34:51 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:34:51 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:34:51 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:36:51 mail kernel: INFO: task sync:8857 blocked for more than 120 seconds.
Feb 18 11:36:51 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 18 11:36:51 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000004
Feb 18 11:36:51 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:36:51 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:36:51 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:36:51 mail kernel: Call Trace:
Feb 18 11:36:51 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:36:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:36:51 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:36:51 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:36:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:36:51 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:36:51 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:36:51 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:36:51 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:36:51 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:36:51 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:36:51 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:36:51 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:36:51 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:38:51 mail kernel: INFO: task sync:8857 blocked for more than 120 seconds.
Feb 18 11:38:51 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 18 11:38:51 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000004
Feb 18 11:38:51 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:38:51 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:38:51 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:38:51 mail kernel: Call Trace:
Feb 18 11:38:51 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:38:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:38:51 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:38:51 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:38:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:38:51 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:38:51 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:38:51 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:38:51 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:38:51 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:38:51 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:38:51 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:38:51 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:38:51 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:40:51 mail kernel: INFO: task sync:8857 blocked for more than 120 seconds.
Feb 18 11:40:51 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 18 11:40:51 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000004
Feb 18 11:40:51 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:40:51 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:40:51 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:40:51 mail kernel: Call Trace:
Feb 18 11:40:51 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:40:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:40:51 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:40:51 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:40:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:40:51 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:40:51 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:40:51 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:40:51 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:40:51 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:40:51 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:40:51 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:40:51 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:40:51 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:41:49 mail kernel: SysRq : Show Blocked State
Feb 18 11:41:49 mail kernel:  task                        PC stack   pid father
Feb 18 11:41:49 mail kernel: md1_resync    D ffff88002822f888     0   561      2 0x00000000
Feb 18 11:41:49 mail kernel: ffff88032d615b60 0000000000000046 0000000000000000 0000000000000005
Feb 18 11:41:49 mail kernel: ffff88032d615b20 ffffffffa0160447 ffff88032ccd3250 00000001002841d8
Feb 18 11:41:49 mail kernel: ffff88032d615fd8 000000000000f888 ffff88033251c5f0 ffff88032ccd2ea0
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffffa0160447>] ? unplug_slaves+0x97/0xe0 [raid456]
Feb 18 11:41:49 mail kernel: [<ffffffffa0162b31>] get_active_stripe+0x2f1/0x8c0 [raid456]
Feb 18 11:41:49 mail kernel: [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffffa016671c>] sync_request+0x36c/0x380 [raid456]
Feb 18 11:41:49 mail kernel: [<ffffffffa0161902>] ? raid5_unplug_device+0x82/0x110 [raid456]
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff81426b04>] md_do_sync+0x6a4/0xc30
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff814258ac>] md_thread+0x5c/0x130
Feb 18 11:41:49 mail kernel: [<ffffffff81425850>] ? md_thread+0x0/0x130
Feb 18 11:41:49 mail kernel: [<ffffffff81078106>] kthread+0x96/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
Feb 18 11:41:49 mail kernel: [<ffffffff81539f3d>] ? restore_args+0x0/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff81078070>] ? kthread+0x0/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
Feb 18 11:41:49 mail kernel: kdmflush      D ffff8800282ef888     0   634      2 0x00000000
Feb 18 11:41:49 mail kernel: ffff88032c9e5a40 0000000000000046 ffff88032c9e5a08 ffff88032c9e5a04
Feb 18 11:41:49 mail kernel: ffff8800282b58c0 ffff8800282ef888 ffff88032cb0c9a0 0000000100284222
Feb 18 11:41:49 mail kernel: ffff88032c9e5fd8 000000000000f888 ffff8803325c2ea0 ffff88032cb0c5f0
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff81426395>] md_barrier_request+0xb5/0x180
Feb 18 11:41:49 mail kernel: [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffffa0167b71>] make_request+0x5f1/0x610 [raid456]
Feb 18 11:41:49 mail kernel: [<ffffffff81042aa4>] ? __enqueue_entity+0x84/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff8104c005>] ? enqueue_entity+0xd5/0x360
Feb 18 11:41:49 mail kernel: [<ffffffff81052070>] ? tg_shares_up+0x2b0/0x2c0
Feb 18 11:41:49 mail kernel: [<ffffffff81424e54>] md_make_request+0xc4/0x150
Feb 18 11:41:49 mail kernel: [<ffffffff812b59ff>] generic_make_request+0x1af/0x500
Feb 18 11:41:49 mail kernel: [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff810e7b23>] ? mempool_alloc+0x63/0x140
Feb 18 11:41:49 mail kernel: [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff81434fab>] __map_bio+0xab/0x130
Feb 18 11:41:49 mail kernel: [<ffffffff814356ed>] __split_and_process_bio+0x5ed/0x660
Feb 18 11:41:49 mail kernel: [<ffffffff810789ab>] ? remove_wait_queue+0x5b/0x70
Feb 18 11:41:49 mail kernel: [<ffffffff81432fb0>] ? dm_wait_for_completion+0x100/0x140
Feb 18 11:41:49 mail kernel: [<ffffffff814357b6>] dm_flush+0x56/0x70
Feb 18 11:41:49 mail kernel: [<ffffffff8143581a>] dm_wq_work+0x4a/0x1d0
Feb 18 11:41:49 mail kernel: [<ffffffff814357d0>] ? dm_wq_work+0x0/0x1d0
Feb 18 11:41:49 mail kernel: [<ffffffff810744ad>] worker_thread+0x17d/0x2d0
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff81074330>] ? worker_thread+0x0/0x2d0
Feb 18 11:41:49 mail kernel: [<ffffffff81078106>] kthread+0x96/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
Feb 18 11:41:49 mail kernel: [<ffffffff81539f3d>] ? restore_args+0x0/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff81078070>] ? kthread+0x0/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
Feb 18 11:41:49 mail kernel: kdmflush      D ffff88032bd35d80     0   652      2 0x00000000
Feb 18 11:41:49 mail kernel: ffff88032bd35d40 0000000000000046 ffff88032bd35cc0 ffffffff812af4d4
Feb 18 11:41:49 mail kernel: ffff88032d64b540 ffff88032c9eeaf8 ffff88032bd35d30 ffffffff8143615c
Feb 18 11:41:49 mail kernel: ffff88032bd35fd8 000000000000f888 ffff88032cc6c5f0 ffff88032f092ea0
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff812af4d4>] ? blk_unplug+0x34/0x70
Feb 18 11:41:49 mail kernel: [<ffffffff8143615c>] ? dm_table_unplug_all+0x5c/0xd0
Feb 18 11:41:49 mail kernel: [<ffffffff81082d69>] ? ktime_get_ts+0xa9/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff815374c3>] io_schedule+0x73/0xc0
Feb 18 11:41:49 mail kernel: [<ffffffff81432f5b>] dm_wait_for_completion+0xab/0x140
Feb 18 11:41:49 mail kernel: [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff814357c3>] dm_flush+0x63/0x70
Feb 18 11:41:49 mail kernel: [<ffffffff8143581a>] dm_wq_work+0x4a/0x1d0
Feb 18 11:41:49 mail kernel: [<ffffffff814357d0>] ? dm_wq_work+0x0/0x1d0
Feb 18 11:41:49 mail kernel: [<ffffffff810744ad>] worker_thread+0x17d/0x2d0
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff81074330>] ? worker_thread+0x0/0x2d0
Feb 18 11:41:49 mail kernel: [<ffffffff81078106>] kthread+0x96/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
Feb 18 11:41:49 mail kernel: [<ffffffff81539f3d>] ? restore_args+0x0/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff81078070>] ? kthread+0x0/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
Feb 18 11:41:49 mail kernel: jbd2/dm-7-8   D 0000000000000002     0  1463      2 0x00000000
Feb 18 11:41:49 mail kernel: ffff88032bc99c30 0000000000000046 ffff88032bc99cd0 0000000000000002
Feb 18 11:41:49 mail kernel: ffff88032bc99bc0 0000000000000282 ffff88032f2dc438 ffff88032f2dc438
Feb 18 11:41:49 mail kernel: ffff88032bc99fd8 000000000000f888 ffff8803325ac5f0 ffff8803303b0000
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff81082d69>] ? ktime_get_ts+0xa9/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff8115b640>] ? sync_buffer+0x0/0x50
Feb 18 11:41:49 mail kernel: [<ffffffff815374c3>] io_schedule+0x73/0xc0
Feb 18 11:41:49 mail kernel: [<ffffffff8115b680>] sync_buffer+0x40/0x50
Feb 18 11:41:49 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff8115b640>] ? sync_buffer+0x0/0x50
Feb 18 11:41:49 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:41:49 mail kernel: [<ffffffff8115b636>] __wait_on_buffer+0x26/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff811fbfe3>] jbd2_journal_commit_transaction+0x1173/0x1370
Feb 18 11:41:49 mail kernel: [<ffffffff810696db>] ? try_to_del_timer_sync+0x7b/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff81201b23>] kjournald2+0xb3/0x200
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff81201a70>] ? kjournald2+0x0/0x200
Feb 18 11:41:49 mail kernel: [<ffffffff81078106>] kthread+0x96/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
Feb 18 11:41:49 mail kernel: [<ffffffff81539f3d>] ? restore_args+0x0/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff81078070>] ? kthread+0x0/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
Feb 18 11:41:49 mail kernel: flush-253:7   D ffff880330be7024     0  1603      2 0x00000000
Feb 18 11:41:49 mail kernel: ffff88033005fb10 0000000000000046 ffff88033005fad0 ffffffff8104aac6
Feb 18 11:41:49 mail kernel: 00000000000158c0 0000000000000286 ffff88033005fb40 0000000000000002
Feb 18 11:41:49 mail kernel: ffff88033005ffd8 000000000000f888 ffff8802ca3cdd40 ffff880330549750
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff8104aac6>] ? try_to_wake_up+0x2d6/0x410
Feb 18 11:41:49 mail kernel: [<ffffffff81078920>] ? prepare_to_wait+0x60/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff81200fbd>] jbd2_log_wait_commit+0xbd/0x130
Feb 18 11:41:49 mail kernel: [<ffffffff81078610>] ? autoremove_wake_function+0x0/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff811fa7bb>] jbd2_journal_stop+0x24b/0x2b0
Feb 18 11:41:49 mail kernel: [<ffffffff811f9915>] ? jbd2_journal_start+0xb5/0x100
Feb 18 11:41:49 mail kernel: [<ffffffff811fa847>] jbd2_journal_force_commit+0x27/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff811d0587>] ext4_force_commit+0x27/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff811c3a55>] ext4_write_inode+0x75/0x100
Feb 18 11:41:49 mail kernel: [<ffffffff81155104>] writeback_single_inode+0x294/0x3b0
Feb 18 11:41:49 mail kernel: [<ffffffff8115567a>] writeback_inodes_wb+0x31a/0x4c0
Feb 18 11:41:49 mail kernel: [<ffffffff8115593a>] wb_writeback+0x11a/0x1e0
Feb 18 11:41:49 mail kernel: [<ffffffff815379f6>] ? schedule_timeout+0x196/0x2f0
Feb 18 11:41:49 mail kernel: [<ffffffff81155c1f>] wb_do_writeback+0x12f/0x1a0
Feb 18 11:41:49 mail kernel: [<ffffffff81155ce3>] bdi_writeback_task+0x53/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff810fea11>] bdi_start_fn+0x71/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff810fe9a0>] ? bdi_start_fn+0x0/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff81078106>] kthread+0x96/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
Feb 18 11:41:49 mail kernel: [<ffffffff81539f3d>] ? restore_args+0x0/0x30
Feb 18 11:41:49 mail kernel: [<ffffffff81078070>] ? kthread+0x0/0xa0
Feb 18 11:41:49 mail kernel: [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
Feb 18 11:41:49 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000004
Feb 18 11:41:49 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:41:49 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:41:49 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:41:49 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:41:49 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:41:49 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:41:49 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:41:49 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:41:49 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:41:49 mail kernel: postmaster    D ffff8802cb3a45f0     0 18639   3579 0x00000000
Feb 18 11:41:49 mail kernel: ffff8801503bdcd8 0000000000000082 ffff880182219d40 0000000000000001
Feb 18 11:41:49 mail kernel: 0000000000000000 ffff88032eaf6000 ffff8801503bdc78 0000000000000282
Feb 18 11:41:49 mail kernel: ffff8801503bdfd8 000000000000f888 ffff8803303b0000 ffff8802cb3a45f0
Feb 18 11:41:49 mail kernel: Call Trace:
Feb 18 11:41:49 mail kernel: [<ffffffff81537a7d>] schedule_timeout+0x21d/0x2f0
Feb 18 11:41:49 mail kernel: [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff812b59ff>] ? generic_make_request+0x1af/0x500
Feb 18 11:41:49 mail kernel: [<ffffffff810e7aa5>] ? mempool_alloc_slab+0x15/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff81537687>] wait_for_common+0xd7/0x180
Feb 18 11:41:49 mail kernel: [<ffffffff8104ac00>] ? default_wake_function+0x0/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff812b5dca>] ? submit_bio+0x7a/0x100
Feb 18 11:41:49 mail kernel: [<ffffffff815377ed>] wait_for_completion+0x1d/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff812b8d9e>] blkdev_issue_flush+0xae/0xf0
Feb 18 11:41:49 mail kernel: [<ffffffff810ee5b1>] ? do_writepages+0x21/0x40
Feb 18 11:41:49 mail kernel: [<ffffffff811b8d63>] ext4_sync_file+0x183/0x260
Feb 18 11:41:49 mail kernel: [<ffffffff811596e1>] vfs_fsync_range+0xa1/0xe0
Feb 18 11:41:49 mail kernel: [<ffffffff8115979d>] vfs_fsync+0x1d/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff811597de>] do_fsync+0x3e/0x60
Feb 18 11:41:49 mail kernel: [<ffffffff81159813>] sys_fdatasync+0x13/0x20
Feb 18 11:41:49 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
Feb 18 11:41:49 mail kernel: Sched Debug Version: v0.09, 2.6.33-rc8AUDIT_NC_80-00014-gdfd7e2d #21
Feb 18 11:41:49 mail kernel: now at 2938448.414048 msecs
Feb 18 11:41:49 mail kernel:  .jiffies                                 : 4297605744
Feb 18 11:41:49 mail kernel:  .sysctl_sched_latency                    : 20.000000
Feb 18 11:41:49 mail kernel:  .sysctl_sched_min_granularity            : 4.000000
Feb 18 11:41:49 mail kernel:  .sysctl_sched_wakeup_granularity         : 4.000000
Feb 18 11:41:49 mail kernel:  .sysctl_sched_child_runs_first           : 0.000000
Feb 18 11:41:49 mail kernel:  .sysctl_sched_features                   : 7917179
Feb 18 11:41:49 mail kernel:  .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#0, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 134686824
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1281122
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 0
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605699
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937721.835342
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 577
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 537
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 474
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 687
Feb 18 11:41:49 mail kernel:  .yld_count                     : 2179
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 134863996
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 48141106
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 458995
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 78680280
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 4496020
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 351
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[0]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[0]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[0]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[0]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 831063.731410
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 910569.170957
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 0.000000
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 82
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[0]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[0]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[0]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[0]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#1, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 128338781
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1584758
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 1
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605592
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937722.634663
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 104
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 324
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 630
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 1218
Feb 18 11:41:49 mail kernel:  .yld_count                     : 1286
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 128493519
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 21906138
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 768015
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 88178065
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 39103643
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 170
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[1]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[1]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[1]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[1]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 1321765.698195
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 1333183.012215
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 422613.841258
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 92
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[1]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[1]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[1]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[1]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.034164
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#2, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 157844766
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1182336
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 1
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605699
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937721.848727
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 116
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 357
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 675
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 991
Feb 18 11:41:49 mail kernel:  .yld_count                     : 793
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 157976044
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 55984920
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 94669
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 92705306
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 2983561
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 150
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[2]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[2]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[2]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[2]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 837719.325564
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 861710.950534
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -48858.220423
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 8
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[2]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[2]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[2]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[2]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#3, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 2
Feb 18 11:41:49 mail kernel:  .load                          : 2048
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 153216813
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1168964
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 0
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605700
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937748.246172
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 1048
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 1504
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 1433
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 1063
Feb 18 11:41:49 mail kernel:  .yld_count                     : 1028
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 153323615
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 54830578
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 1000000
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 89232671
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 2800728
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 195
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[3]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[3]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[3]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[3]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 824572.846668
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 861481.339829
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 861491.336952
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 861481.350774
Feb 18 11:41:49 mail kernel:  .spread                        : 0.010945
Feb 18 11:41:49 mail kernel:  .spread0                       : -49077.834005
Feb 18 11:41:49 mail kernel:  .nr_running                    : 2
Feb 18 11:41:49 mail kernel:  .load                          : 2048
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 39
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[3]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[3]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[3]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[3]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:        events/3    30    861481.339829      6488   120    861481.339829        60.647940   2936630.992574 /
Feb 18 11:41:49 mail kernel: hald-addon-inpu  3026    861481.350774       142   120    861481.350774         5.011627   2807647.638216 /
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#4, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 121473656
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1221883
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 0
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605699
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937721.807370
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 1024
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 1115
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 1473
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 1389
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 1075
Feb 18 11:41:49 mail kernel:  .yld_count                     : 856
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 121582377
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 42407638
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 773584
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 69900030
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 2923984
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 195
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[4]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.513963
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 9.460509
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910559.710448
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 166875.092535
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 154674.298465
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.513963
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.391672
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.016821
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.022134
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 2
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[4]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[4]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[4]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 808415.284243
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 1108129.509824
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 197560.338867
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 181
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[4]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[4]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[4]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[4]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#5, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 99631583
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1491913
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 1
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605825
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937739.602864
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 216
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 1098
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 2424
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 3702
Feb 18 11:41:49 mail kernel:  .yld_count                     : 439
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 99763445
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 22256354
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 1000000
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 68707534
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 30750066
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 218
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[5]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[5]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[5]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[5]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 1196982.861270
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 1294340.356752
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 383771.185795
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 13
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[5]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[5]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[5]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[5]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.002488
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#6, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 122344929
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1152991
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 3
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605719
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937721.848735
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 81
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 319
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 428
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 506
Feb 18 11:41:49 mail kernel:  .yld_count                     : 1767
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 122466252
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 42563935
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 348190
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 70413787
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 2434050
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 137
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[6]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[6]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.393489
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 9.340035
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910559.830922
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 166853.172288
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 12759.624907
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.393489
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.337543
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.068387
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.072025
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 3
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[6]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[6]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 819163.486321
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 997853.813981
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 87284.643024
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 34
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[6]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[6]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[6]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[6]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cpu#7, 2672.865 MHz
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_switches                   : 112094254
Feb 18 11:41:49 mail kernel:  .nr_load_updates               : 1143968
Feb 18 11:41:49 mail kernel:  .nr_uninterruptible            : 1
Feb 18 11:41:49 mail kernel:  .next_balance                  : 4297.605699
Feb 18 11:41:49 mail kernel:  .curr->pid                     : 0
Feb 18 11:41:49 mail kernel:  .clock                         : 2937721.770646
Feb 18 11:41:49 mail kernel:  .cpu_load[0]                   : 0
Feb 18 11:41:49 mail kernel:  .cpu_load[1]                   : 648
Feb 18 11:41:49 mail kernel:  .cpu_load[2]                   : 816
Feb 18 11:41:49 mail kernel:  .cpu_load[3]                   : 687
Feb 18 11:41:49 mail kernel:  .cpu_load[4]                   : 484
Feb 18 11:41:49 mail kernel:  .yld_count                     : 938
Feb 18 11:41:49 mail kernel:  .sched_switch                  : 0
Feb 18 11:41:49 mail kernel:  .sched_count                   : 112195739
Feb 18 11:41:49 mail kernel:  .sched_goidle                  : 38534900
Feb 18 11:41:49 mail kernel:  .avg_idle                      : 680714
Feb 18 11:41:49 mail kernel:  .ttwu_count                    : 64269366
Feb 18 11:41:49 mail kernel:  .ttwu_local                    : 2194002
Feb 18 11:41:49 mail kernel:  .bkl_count                     : 128
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[7]:/4278
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[7]:/4276
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[7]:/libvirt
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 0.000000
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : -1.048576
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : -910570.219533
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 0
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:  .se->exec_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->vruntime                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sum_exec_runtime          : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_start                : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_start               : 0.000000
Feb 18 11:41:49 mail kernel:  .se->sleep_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->block_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->exec_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->slice_max                 : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_max                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_sum                  : 0.000000
Feb 18 11:41:49 mail kernel:  .se->wait_count                : 0
Feb 18 11:41:49 mail kernel:  .se->load.weight               : 512
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: cfs_rq[7]:/
Feb 18 11:41:49 mail kernel:  .exec_clock                    : 817623.826026
Feb 18 11:41:49 mail kernel:  .MIN_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .min_vruntime                  : 1001651.264498
Feb 18 11:41:49 mail kernel:  .max_vruntime                  : 0.000001
Feb 18 11:41:49 mail kernel:  .spread                        : 0.000000
Feb 18 11:41:49 mail kernel:  .spread0                       : 91082.093541
Feb 18 11:41:49 mail kernel:  .nr_running                    : 0
Feb 18 11:41:49 mail kernel:  .load                          : 0
Feb 18 11:41:49 mail kernel:  .nr_spread_over                : 239
Feb 18 11:41:49 mail kernel:  .shares                        : 0
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[7]:/4278
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[7]:/4276
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[7]:/libvirt
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 0.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: rt_rq[7]:/
Feb 18 11:41:49 mail kernel:  .rt_nr_running                 : 0
Feb 18 11:41:49 mail kernel:  .rt_throttled                  : 0
Feb 18 11:41:49 mail kernel:  .rt_time                       : 0.000000
Feb 18 11:41:49 mail kernel:  .rt_runtime                    : 950.000000
Feb 18 11:41:49 mail kernel:
Feb 18 11:41:49 mail kernel: runnable tasks:
Feb 18 11:41:49 mail kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Feb 18 11:41:49 mail kernel: ----------------------------------------------------------------------------------------------------------
Feb 18 11:41:49 mail kernel:
Feb 18 11:42:51 mail kernel: INFO: task sync:8857 blocked for more than 120 seconds.
Feb 18 11:42:51 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 18 11:42:51 mail kernel: sync          D 0000000000000002     0  8857   7695 0x00000004
Feb 18 11:42:51 mail kernel: ffff880259703da8 0000000000000086 ffff880259703d58 ffffffff81027590
Feb 18 11:42:51 mail kernel: ffff880330549788 ffff880330549750 000000035f24b2b3 0000000000000282
Feb 18 11:42:51 mail kernel: ffff880259703fd8 000000000000f888 ffff880332532ea0 ffff880150191750
Feb 18 11:42:51 mail kernel: Call Trace:
Feb 18 11:42:51 mail kernel: [<ffffffff81027590>] ? default_send_IPI_mask_sequence_phys+0xe0/0x110
Feb 18 11:42:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:42:51 mail kernel: [<ffffffff8115476e>] bdi_sched_wait+0xe/0x20
Feb 18 11:42:51 mail kernel: [<ffffffff81537d5f>] __wait_on_bit+0x5f/0x90
Feb 18 11:42:51 mail kernel: [<ffffffff81154760>] ? bdi_sched_wait+0x0/0x20
Feb 18 11:42:51 mail kernel: [<ffffffff81537e08>] out_of_line_wait_on_bit+0x78/0x90
Feb 18 11:42:51 mail kernel: [<ffffffff81078650>] ? wake_bit_function+0x0/0x50
Feb 18 11:42:51 mail kernel: [<ffffffff8104ac55>] ? wake_up_process+0x15/0x20
Feb 18 11:42:51 mail kernel: [<ffffffff81155ddf>] bdi_sync_writeback+0x6f/0x80
Feb 18 11:42:51 mail kernel: [<ffffffff81155e12>] sync_inodes_sb+0x22/0x100
Feb 18 11:42:51 mail kernel: [<ffffffff81159932>] __sync_filesystem+0x82/0x90
Feb 18 11:42:51 mail kernel: [<ffffffff81159a34>] sync_filesystems+0xf4/0x120
Feb 18 11:42:51 mail kernel: [<ffffffff81159ac1>] sys_sync+0x21/0x40
Feb 18 11:42:51 mail kernel: [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

--Boundary_(ID_tZIpJEH582SSiufVw9ywfw)--
