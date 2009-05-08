Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZEIHLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZEIHLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZEIHLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:11:23 -0400
Received: from a2s31.a2hosting.com ([69.39.67.40]:42978 "EHLO
	a2s31.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZEIHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:11:21 -0400
X-Greylist: delayed 59489 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2009 03:11:20 EDT
From: Vassilis Virvilis <v.virvilis@biovista.com>
Reply-To: v.virvilis@biovista.com
Organization: Biovista
To: linux-kernel@vger.kernel.org
Subject: SATA disks resets in a md setup
Date: Fri, 8 May 2009 17:39:45 +0300
User-Agent: KMail/1.11.2 (Linux/2.6.29-1-686; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yQEBKBxwrNF9gWp"
Message-Id: <200905081739.46206.v.virvilis@biovista.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s31.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - biovista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yQEBKBxwrNF9gWp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have spent the better part of the day looking for this and I didn't came up with anything so I thought to ask here in case this is a bug.

Setup:
------
The system is amd64bit running debian unstable stock with kernel 2.6.29 (debian package). full dmesg is attached
I have 2 250GB disks (/dev/sda, /dev/sdb) that I used to assemble a md array (/dev/md0)

Homework:
---------
Please note that the two disk are tested via smart long selftest and via $dd bs=256M if=/dev/sd? of=/dev/null without any problem.
I researched in web and followed advices:
	I have checked / exchanged cables
	I disabled smartd.

The actual Problem:
-------------------
Then I start the following stress test. From the other disks of the machine /dev/hda, /dev/hdb, /dev/sdc I start copying (via rsync) to /dev/md0 to a newly formated ext3 filesystem.

Everything goes fine for a while and then the system freezes and I am getting the first

[ 9351.377903] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x1b0000 action 0xe frozen
[ 9351.377941] ata2.00: irq_stat 0x04400000, PHY RDY changed
[ 9351.377961] ata2: SError: { PHYRdyChg PHYInt 10B8B Dispar }
[ 9351.377983] ata2.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[ 9351.377985]          res 50/00:00:b6:46:6a/00:00:13:00:00/e0 Emask 0x10 (ATA bus error)
[ 9351.378006] ata2.00: status: { DRDY }
[ 9351.378026] ata2: hard resetting link
[ 9357.659634] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9389.345002] ata2.00: qc timeout (cmd 0xec)
[ 9389.345013] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[ 9389.345017] ata2.00: revalidation failed (errno=-5)
[ 9389.345037] ata2: failed to recover some devices, retrying in 5 secs
[ 9395.548107] ata2: hard resetting link
[ 9396.033100] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9396.034245] ata2.00: configured for UDMA/133
[ 9396.034275] ata2: EH complete
[ 9396.098216] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[ 9396.114211] sd 1:0:0:0: [sdb] Write Protect is off
[ 9396.114217] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 9396.130212] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

This happens 2 or 3 times more (sometimes even sda gives the same message)

At the end what happens is the following. Please note the
 **** [10671.430120] ata2.00: n_sectors mismatch 488397168 != 268435455 *****


[10665.354196] ata2: limiting SATA link speed to 1.5 Gbps
[10665.354196] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x6 frozen
[10665.354196] ata2.00: irq_stat 0x08000000, interface fatal error
[10665.354196] ata2: SError: { UnrecovData Handshk }
[10665.354196] ata2.00: cmd 35/00:00:27:ae:7a/00:04:01:00:00/e0 tag 0 dma 524288 out
[10665.354196]          res 50/00:00:26:ae:7a/00:00:01:00:00/e0 Emask 0x10 (ATA bus error)
[10665.354196] ata2.00: status: { DRDY }
[10665.354196] ata2: hard resetting link
[10665.846071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10665.846071] ata2.00: n_sectors mismatch 488397168 != 268435455
[10665.846071] ata2.00: revalidation failed (errno=-19)
[10665.846071] ata2: failed to recover some devices, retrying in 5 secs
[10670.878898] ata2: hard resetting link
[10671.429184] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10671.430120] ata2.00: n_sectors mismatch 488397168 != 268435455
[10671.430124] ata2.00: revalidation failed (errno=-19)
[10671.430145] ata2.00: disabled
[10671.934174] ata2: hard resetting link
[10672.462213] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10672.463130] ata2.00: ATA-0: WDC WD2500JS-00MVB1, 10.02E01, max MWDMA2
[10672.463134] ata2.00: 268435455 sectors, multi 0: LBA
[10672.463137] ata2.00: applying bridge limits
[10672.463683] ata2.00: failed to set xfermode (err_mask=0x1)
[10672.463706] ata2: failed to recover some devices, retrying in 5 secs
[10677.749459] ata2: hard resetting link
[10678.272486] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10678.273961] ata2.00: failed to set xfermode (err_mask=0x1)
[10678.273987] ata2: limiting SATA link speed to 1.5 Gbps
[10678.273989] ata2.00: limiting speed to PIO3
[10678.273992] ata2: failed to recover some devices, retrying in 5 secs
[10683.430922] ata2: hard resetting link
[10683.920364] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10683.921839] ata2.00: failed to set xfermode (err_mask=0x1)
[10683.921863] ata2.00: disabled
[10684.424389] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[10684.424397] sd 1:0:0:0: [sdb] Sense Key : Aborted Command [current] [descriptor]
[10684.424402] Descriptor sense data with sense descriptors (in hex):
[10684.424404]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[10684.424410]         01 7a ae 26
[10684.424413] sd 1:0:0:0: [sdb] Add. Sense: No additional sense information
[10684.424417] end_request: I/O error, dev sdb, sector 24817191
[10684.424440] Buffer I/O error on device md0, logical block 64151117
[10684.424459] lost page write due to I/O error on md0
[10684.424465] Buffer I/O error on device md0, logical block 64151118

and my filesystem is dead. /dev/sdb is deleted from /dev. I have to reboot and even then linux can't find the ata2 /dev/sdb.
I have to remove power for 1-2 min for the disk to become accessible again.

Do you think the disk is bad or something?

Please make sure you cc me as I am not subscribed in this list.

  .bill

--Boundary-00=_yQEBKBxwrNF9gWp
Content-Type: text/x-log;
  charset="ISO-8859-7";
  name="sd2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sd2.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-amd64 (Debian 2.6.26-15) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Fri Mar 27 04:02:59 UTC 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.26-2-amd64 root=UUID=afe3f145-af1d-48ae-ab90-b684352daa54 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007bfb0000 (usable)
[    0.000000]  BIOS-e820: 000000007bfb0000 - 000000007bfbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bfbe000 - 000000007bfe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bfe0000 - 000000007c000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 507824) 1 entries of 3200 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA850, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 7BFB0000, 0034 (r1 A M I  OEMRSDT   1000705 MSFT       97)
[    0.000000] ACPI: FACP 7BFB0200, 0084 (r2 A M I  OEMFACP   1000705 MSFT       97)
[    0.000000] ACPI: DSDT 7BFB0440, 498E (r1  A0339 A0339000        0 INTL  2002026)
[    0.000000] ACPI: FACS 7BFBE000, 0040
[    0.000000] ACPI: APIC 7BFB0390, 0068 (r1 A M I  OEMAPIC   1000705 MSFT       97)
[    0.000000] ACPI: MCFG 7BFB0400, 003C (r1 A M I  OEMMCFG   1000705 MSFT       97)
[    0.000000] ACPI: OEMB 7BFBE040, 0046 (r1 A M I  AMI_OEM   1000705 MSFT       97)
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007bfb0000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 507824) 1 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007bfb0000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000010fff]
[    0.000000]   bootmap [0000000000011000 -  00000000000207f7] pages 10
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-673397] TEXT DATA BSS
[    0.000000]   early res: 3 [377c1000-37fef74a] RAMDISK
[    0.000000]   early res: 4 [9d400-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-bfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff810001200000-ffff810002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   507824
[    0.000000] On node 0 totalpages: 507727
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1246 pages reserved
[    0.000000]   DMA zone: 2697 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6887 pages used for memmap
[    0.000000]   DMA32 zone: 496841 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfecc0000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7c000000:82c00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37168 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 499538
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.26-2-amd64 root=UUID=afe3f145-af1d-48ae-ab90-b684352daa54 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000000] time.c: Detected 2200.083 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Node 0: aperture @ f0000000 size 128 MB
[    0.004000] Memory: 1989008k/2031296k available (2224k kernel code, 41900k reserved, 1081k data, 392k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084097] Calibrating delay using timer specific routine.. 4403.13 BogoMIPS (lpj=8806261)
[    0.084148] Security Framework initialized
[    0.084154] SELinux:  Disabled at boot.
[    0.084158] Capability LSM initialized
[    0.084340] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.085643] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.086303] Mount-cache hash table entries: 256
[    0.086470] Initializing cgroup subsys ns
[    0.086473] Initializing cgroup subsys cpuacct
[    0.086476] Initializing cgroup subsys devices
[    0.086496] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.086498] CPU: L2 Cache: 512K (64 bytes/line)
[    0.086501] CPU 0/0 -> Node 0
[    0.086512] CPU: Physical Processor ID: 0
[    0.086514] CPU: Processor Core ID: 0
[    0.087227] ACPI: Core revision 20080321
[    0.140008] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
[    0.140008] Using local APIC timer interrupts.
[    0.144009] APIC timer calibration result 12500473
[    0.144009] Detected 12.500 MHz APIC timer.
[    0.144009] Booting processor 1/1 ip 6000
[    0.152009] Initializing CPU#1
[    0.152009] Calibrating delay using timer specific routine.. 4400.17 BogoMIPS (lpj=8800344)
[    0.152009] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.152009] CPU: L2 Cache: 512K (64 bytes/line)
[    0.152009] CPU 1/1 -> Node 0
[    0.152009] CPU: Physical Processor ID: 0
[    0.152009] CPU: Processor Core ID: 1
[    0.231940] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
[    0.231954] Brought up 2 CPUs
[    0.231956] Total of 2 processors activated (8803.30 BogoMIPS).
[    0.232014] CPU0 attaching sched-domain:
[    0.232014]  domain 0: span 0-1
[    0.232014]   groups: 0 1
[    0.232014]   domain 1: span 0-1
[    0.232014]    groups: 0-1
[    0.232014] CPU1 attaching sched-domain:
[    0.232014]  domain 0: span 0-1
[    0.232014]   groups: 1 0
[    0.232014]   domain 1: span 0-1
[    0.232014]    groups: 0-1
[    0.232014] net_namespace: 1224 bytes
[    0.232014] Booting paravirtualized kernel on bare hardware
[    0.232014] NET: Registered protocol family 16
[    0.232014] node 0 link 0: io port [1000, ffffff]
[    0.232014] TOM: 0000000080000000 aka 2048M
[    0.232014] node 0 link 0: mmio [a0000, bffff]
[    0.232014] node 0 link 0: mmio [80000000, ffffffff]
[    0.232014] bus: [00,ff] on node 0 link 0
[    0.232014] bus: 00 index 0 io port: [0, ffff]
[    0.232014] bus: 00 index 1 mmio: [a0000, bffff]
[    0.232014] bus: 00 index 2 mmio: [80000000, fcffffffff]
[    0.232014] ACPI: bus type pci registered
[    0.232014] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.232014] PCI: Not using MMCONFIG.
[    0.232014] PCI: Using configuration type 1 for base access
[    0.232014] ACPI: EC: Look up EC in DSDT
[    0.239314] ACPI: Interpreter enabled
[    0.239317] ACPI: (supports S0 S1 S3 S4 S5)
[    0.239334] ACPI: Using IOAPIC for interrupt routing
[    0.239389] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.243653] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.258697] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.268016] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.268016] PCI: Transparent bridge - 0000:00:13.1
[    0.268016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.268016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.268016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.268016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
[    0.290254] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.290384] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.290513] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.290640] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.290769] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.290897] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.291026] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.291155] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.291540] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - C1, should be B3 [20080321]
[    0.291548] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.291695] pnp: PnP ACPI init
[    0.291703] ACPI: bus type pnp registered
[    0.291722] pnp 00:00: parse allocated resources
[    0.291839] pnp 00:00:   add io  0xcf8-0xcff flags 0x1
[    0.292005] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.292039] pnp 00:01: parse allocated resources
[    0.292046] pnp 00:01:   add dma 4 flags 0x4
[    0.292048] pnp 00:01:   add io  0x0-0xf flags 0x1
[    0.292050] pnp 00:01:   add io  0x81-0x83 flags 0x1
[    0.292052] pnp 00:01:   add io  0x87-0x87 flags 0x1
[    0.292054] pnp 00:01:   add io  0x89-0x8b flags 0x1
[    0.292056] pnp 00:01:   add io  0x8f-0x8f flags 0x1
[    0.292058] pnp 00:01:   add io  0xc0-0xdf flags 0x1
[    0.292211] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.292226] pnp 00:02: parse allocated resources
[    0.292231] pnp 00:02:   add io  0x70-0x71 flags 0x1
[    0.292240] pnp 00:02:   add irq 8 flags 0x1
[    0.292269] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.292269] pnp 00:03: parse allocated resources
[    0.292269] pnp 00:03:   add io  0x61-0x61 flags 0x1
[    0.292269] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.292269] pnp 00:04: parse allocated resources
[    0.292269] pnp 00:04:   add io  0xf0-0xff flags 0x1
[    0.292269] pnp 00:04:   add irq 13 flags 0x1
[    0.292269] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.292269] pnp 00:05: parse allocated resources
[    0.292269] pnp 00:05:   add irq 6 flags 0x1
[    0.292269] pnp 00:05:   add dma 2 flags 0x0
[    0.292269] pnp 00:05:   add io  0x3f0-0x3f5 flags 0x1
[    0.292269] pnp 00:05:   add io  0x3f7-0x3f7 flags 0x1
[    0.292269] pnp 00:05: parse resource options
[    0.292269] pnp 00:05: new independent option
[    0.292269] pnp 00:05: new dependent option (priority 0x0)
[    0.292269] pnp 00:05:   io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
[    0.292269] pnp 00:05:   io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
[    0.292269] pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000040 flags 0x1
[    0.292269] pnp 00:05:   dma bitmask 0x4 flags 0x0
[    0.292269] pnp 00:05: new dependent option (priority 0x1)
[    0.292269] pnp 00:05:   io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
[    0.292269] pnp 00:05:   io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
[    0.292269] pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.292269] pnp 00:05:   dma bitmask 0xf flags 0x0
[    0.292269] pnp 00:05: new dependent option (priority 0x1)
[    0.292269] pnp 00:05:   io  min 0x370 max 0x370 align 1 size 6 flags 0x1
[    0.292269] pnp 00:05:   io  min 0x377 max 0x377 align 1 size 1 flags 0x1
[    0.292269] pnp 00:05:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.292269] pnp 00:05:   dma bitmask 0xf flags 0x0
[    0.292269] pnp 00:05: end dependent options
[    0.292269] pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.292269] pnp 00:06: parse allocated resources
[    0.292269] pnp 00:06:   add io  0x378-0x37f flags 0x1
[    0.292269] pnp 00:06:   add io  0x778-0x77b flags 0x1
[    0.292269] pnp 00:06:   add irq 7 flags 0x1
[    0.292269] pnp 00:06:   add dma 3 flags 0x0
[    0.292269] pnp 00:06: parse resource options
[    0.292269] pnp 00:06: new independent option
[    0.292514] pnp 00:06: new dependent option (priority 0x0)
[    0.292517] pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1
[    0.292519] pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1
[    0.292523] pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000080 flags 0x1
[    0.292526] pnp 00:06:   dma bitmask 0x8 flags 0x0
[    0.292529] pnp 00:06: new dependent option (priority 0x1)
[    0.292531] pnp 00:06:   io  min 0x378 max 0x378 align 1 size 8 flags 0x1
[    0.292534] pnp 00:06:   io  min 0x778 max 0x778 align 1 size 4 flags 0x1
[    0.292538] pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.292541] pnp 00:06:   dma bitmask 0xb flags 0x0
[    0.292543] pnp 00:06: new dependent option (priority 0x1)
[    0.292545] pnp 00:06:   io  min 0x278 max 0x278 align 1 size 8 flags 0x1
[    0.292548] pnp 00:06:   io  min 0x678 max 0x678 align 1 size 4 flags 0x1
[    0.292552] pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.292555] pnp 00:06:   dma bitmask 0xb flags 0x0
[    0.292557] pnp 00:06: new dependent option (priority 0x1)
[    0.292560] pnp 00:06:   io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1
[    0.292563] pnp 00:06:   io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1
[    0.292567] pnp 00:06:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.292569] pnp 00:06:   dma bitmask 0xb flags 0x0
[    0.292571] pnp 00:06: end dependent options
[    0.294698] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.294712] pnp 00:07: parse allocated resources
[    0.294770] pnp 00:07:   add io  0x0-0xffffffffffffffff flags 0x10000001
[    0.294773] pnp 00:07:   add io  0x0-0xffffffffffffffff flags 0x10000001
[    0.294775] pnp 00:07:   add io  0x290-0x297 flags 0x1
[    0.294778] pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.294962] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.294978] pnp 00:08: parse allocated resources
[    0.295128] pnp 00:08:   add io  0x10-0x1f flags 0x1
[    0.295130] pnp 00:08:   add io  0x22-0x3f flags 0x1
[    0.295132] pnp 00:08:   add io  0x44-0x5f flags 0x1
[    0.295134] pnp 00:08:   add io  0x62-0x63 flags 0x1
[    0.295136] pnp 00:08:   add io  0x65-0x6f flags 0x1
[    0.295138] pnp 00:08:   add io  0x72-0x7f flags 0x1
[    0.295140] pnp 00:08:   add io  0x80-0x80 flags 0x1
[    0.295142] pnp 00:08:   add io  0x84-0x86 flags 0x1
[    0.295144] pnp 00:08:   add io  0x88-0x88 flags 0x1
[    0.295146] pnp 00:08:   add io  0x8c-0x8e flags 0x1
[    0.295148] pnp 00:08:   add io  0x90-0x9f flags 0x1
[    0.295150] pnp 00:08:   add io  0xa2-0xbf flags 0x1
[    0.295153] pnp 00:08:   add io  0xe0-0xef flags 0x1
[    0.295155] pnp 00:08:   add io  0x3e0-0x3e7 flags 0x1
[    0.295157] pnp 00:08:   add io  0x4d0-0x4d1 flags 0x1
[    0.295159] pnp 00:08:   add io  0x800-0x87f flags 0x1
[    0.295161] pnp 00:08:   add io  0x400-0x41f flags 0x1
[    0.295164] pnp 00:08:   add io  0x0-0xffffffffffffffff flags 0x10000001
[    0.295166] pnp 00:08:   add mem 0xffb00000-0xffbfffff flags 0x0
[    0.295169] pnp 00:08: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.295342] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295480] pnp 00:09: parse allocated resources
[    0.295568] pnp 00:09:   add mem 0xfec00000-0xfec00fff flags 0x0
[    0.295571] pnp 00:09:   add mem 0xfee00000-0xfee00fff flags 0x0
[    0.295573] pnp 00:09: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.295747] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.296032] pnp 00:0a: parse allocated resources
[    0.296347] pnp 00:0a:   add irq 3 flags 0x1
[    0.296349] pnp 00:0a:   add io  0x2f8-0x2ff flags 0x1
[    0.296351] pnp 00:0a: parse resource options
[    0.296353] pnp 00:0a: new independent option
[    0.296395] pnp 00:0a: new dependent option (priority 0x0)
[    0.296398] pnp 00:0a:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.296402] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008 flags 0x1
[    0.296405] pnp 00:0a: new dependent option (priority 0x1)
[    0.296408] pnp 00:0a:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    0.296412] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296415] pnp 00:0a: new dependent option (priority 0x1)
[    0.296417] pnp 00:0a:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.296421] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296424] pnp 00:0a: new dependent option (priority 0x1)
[    0.296426] pnp 00:0a:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    0.296430] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296433] pnp 00:0a: new dependent option (priority 0x1)
[    0.296436] pnp 00:0a:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    0.296440] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296443] pnp 00:0a: new dependent option (priority 0x1)
[    0.296445] pnp 00:0a:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    0.296449] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296452] pnp 00:0a:   dma bitmask 0xf flags 0x0
[    0.296454] pnp 00:0a: new dependent option (priority 0x1)
[    0.296457] pnp 00:0a:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.296461] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296464] pnp 00:0a:   dma bitmask 0xf flags 0x0
[    0.296466] pnp 00:0a: new dependent option (priority 0x1)
[    0.296468] pnp 00:0a:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    0.296472] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296475] pnp 00:0a:   dma bitmask 0xf flags 0x0
[    0.296477] pnp 00:0a: new dependent option (priority 0x1)
[    0.296479] pnp 00:0a:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    0.296483] pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001cf8 flags 0x1
[    0.296486] pnp 00:0a:   dma bitmask 0xf flags 0x0
[    0.296488] pnp 00:0a: end dependent options
[    0.296643] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.296657] pnp 00:0b: parse allocated resources
[    0.296723] pnp 00:0b:   add mem 0xe0000000-0xefffffff flags 0x0
[    0.296725] pnp 00:0b: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.296906] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.297394] pnp 00:0c: parse allocated resources
[    0.297612] pnp 00:0c:   add mem 0x0-0x9ffff flags 0x1
[    0.297614] pnp 00:0c:   add mem 0xc0000-0xcffff flags 0x0
[    0.297616] pnp 00:0c:   add mem 0xe0000-0xfffff flags 0x0
[    0.297619] pnp 00:0c:   add mem 0x100000-0x7fffffff flags 0x1
[    0.297621] pnp 00:0c:   add mem 0xfff80000-0xffffffff flags 0x0
[    0.297624] pnp 00:0c: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.297803] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.298173] pnp: PnP ACPI: found 13 devices
[    0.298174] ACPI: ACPI bus type pnp unregistered
[    0.298242] usbcore: registered new interface driver usbfs
[    0.298242] usbcore: registered new interface driver hub
[    0.298242] usbcore: registered new device driver usb
[    0.298242] PCI: Using ACPI for IRQ routing
[    0.298242] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
[    0.314502] agpgart: Detected AGP bridge 0
[    0.319510] agpgart: AGP aperture is 128M @ 0xf0000000
[    0.319730] ACPI: RTC can wake from S4
[    0.330611] pnp: the driver 'system' has been registered
[    0.330629] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.330632] system 00:07: driver attached
[    0.330638] system 00:08: ioport range 0x3e0-0x3e7 has been reserved
[    0.330642] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.330645] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.330647] system 00:08: ioport range 0x400-0x41f has been reserved
[    0.330653] system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.330655] system 00:08: driver attached
[    0.330662] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.330665] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.330668] system 00:09: driver attached
[    0.330677] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.330680] system 00:0b: driver attached
[    0.330687] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.330689] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.330692] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.330695] system 00:0c: iomem range 0x100000-0x7fffffff could not be reserved
[    0.330698] system 00:0c: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.330701] system 00:0c: driver attached
[    0.334245] PCI: Bridge: 0000:00:01.0
[    0.334245]   IO window: disabled.
[    0.334245]   MEM window: 0xfa000000-0xfbefffff
[    0.334245]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.334245] PCI: Bridge: 0000:00:13.0
[    0.334245]   IO window: disabled.
[    0.334245]   MEM window: 0xfbf00000-0xfbffffff
[    0.334245]   PREFETCH window: disabled.
[    0.334245] PCI: Bridge: 0000:00:13.1
[    0.334245]   IO window: disabled.
[    0.334245]   MEM window: disabled.
[    0.334245]   PREFETCH window: disabled.
[    0.334245] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.334245] PCI: Setting latency timer of device 0000:00:13.0 to 64
[    0.334245] PCI: Setting latency timer of device 0000:00:13.1 to 64
[    0.334245] NET: Registered protocol family 2
[    0.337492] Switched to high resolution mode on CPU 0
[    0.337488] Switched to high resolution mode on CPU 1
[    0.373550] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.374297] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.374297] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.374962] TCP: Hash tables configured (established 262144 bind 65536)
[    0.374966] TCP reno registered
[    0.386784] NET: Registered protocol family 1
[    0.386891] checking if image is initramfs... it is
[    0.943254] Freeing initrd memory: 8377k freed
[    0.951597] audit: initializing netlink socket (disabled)
[    0.951597] type=2000 audit(1241699352.944:1): initialized
[    0.951597] Total HugeTLB memory allocated, 0
[    0.951597] VFS: Disk quotas dquot_6.5.1
[    0.951597] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.951597] msgmni has been set to 3901
[    0.951597] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.951597] io scheduler noop registered
[    0.951597] io scheduler anticipatory registered
[    0.951597] io scheduler deadline registered
[    0.951617] io scheduler cfq registered (default)
[    0.951617] agpgart-amd64 0000:00:00.0: MSI quirk detected; MSI disabled
[    0.951617] PCI: VIA PCI bridge detected.Disabling DAC.
[    0.951617] pci 0000:01:00.0: Boot video device
[    0.955600] Linux agpgart interface v0.103
[    0.955600] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.955600] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.955600] pnp: the driver 'serial' has been registered
[    0.955687] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.955687] serial 00:0a: driver attached
[    0.959601] brd: module loaded
[    0.959601] input: Macintosh mouse button emulation as /class/input/input0
[    0.959601] pnp: the driver 'i8042 kbd' has been registered
[    0.959601] pnp: the driver 'i8042 aux' has been registered
[    0.959601] pnp: the driver 'i8042 kbd' has been unregistered
[    0.959601] pnp: the driver 'i8042 aux' has been unregistered
[    0.959601] PNP: No PS/2 controller found. Probing ports directly.
[    0.959601] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.959601] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.979597] mice: PS/2 mouse device common for all mice
[    0.979597] pnp: the driver 'rtc_cmos' has been registered
[    0.979597] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.979597] rtc0: alarms up to one year, y3k
[    0.979597] rtc_cmos 00:02: driver attached
[    0.979597] cpuidle: using governor ladder
[    0.979597] cpuidle: using governor menu
[    0.979597] No iBFT detected.
[    0.979597] TCP cubic registered
[    0.979597] NET: Registered protocol family 17
[    0.979597] registered taskstats version 1
[    0.979597] rtc_cmos 00:02: setting system clock to 2009-05-07 12:29:13 UTC (1241699353)
[    0.979597] Freeing unused kernel memory: 392k freed
[    1.083921] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.083921] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.083921] ACPI: Processor [CPU1] (supports 16 throttling states)
[    1.083921] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.239924] No dock devices found.
[    1.250281] SCSI subsystem initialized
[    1.251401] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 22 (level, low) -> IRQ 22
[    1.251421] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    1.252590] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    1.252590] ehci_hcd 0000:00:10.4: debug port 1
[    1.252590] ehci_hcd 0000:00:10.4: irq 22, io mem 0xf9fff800
[    1.257948] Uniform Multi-Platform E-IDE driver
[    1.257955] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.264591] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.264591] usb usb1: configuration #1 chosen from 1 choice
[    1.264591] hub 1-0:1.0: USB hub found
[    1.264591] hub 1-0:1.0: 8 ports detected
[    1.264591] libata version 3.00 loaded.
[    1.267047] USB Universal Host Controller Interface driver v3.0
[    1.272589] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[    1.364737] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.364742] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.364744] usb usb1: Product: EHCI Host Controller
[    1.364746] usb usb1: Manufacturer: Linux 2.6.26-2-amd64 ehci_hcd
[    1.364748] usb usb1: SerialNumber: 0000:00:10.4
[    1.368582] ahci 0000:00:0f.0: version 3.0
[    1.368582] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21
[    1.368582] ahci 0000:00:0f.0: controller can't do NCQ, turning off CAP_NCQ
[    1.368582] ahci 0000:00:0f.0: controller can't do PMP, turning off CAP_PMP
[    1.368582] PCI: Disallowing DAC for device 0000:00:0f.0
[    2.438233] ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.438238] ahci 0000:00:0f.0: flags: 64bit pm led clo pio slum part 
[    2.442198] scsi0 : ahci
[    2.442198] scsi1 : ahci
[    2.442198] scsi2 : ahci
[    2.442198] scsi3 : ahci
[    2.442198] ata1: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffd00 irq 21
[    2.442198] ata2: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffd80 irq 21
[    2.442198] ata3: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffe00 irq 21
[    2.442198] ata4: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffe80 irq 21
[    2.985209] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.985719] ata1.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
[    2.985722] ata1.00: 488397168 sectors, multi 16: LBA48 
[    2.986307] ata1.00: configured for UDMA/133
[    3.539703] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.540236] ata2.00: ATA-7: WDC WD2500JS-00MVB1, 10.02E01, max UDMA/133
[    3.540239] ata2.00: 488397168 sectors, multi 16: LBA48 
[    3.540833] ata2.00: configured for UDMA/133
[    4.142699] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.143518] ata3.00: ATA-7: ST3300831AS, 3.01, max UDMA/133
[    4.143521] ata3.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.144392] ata3.00: configured for UDMA/133
[    4.695724] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.696412] ata4.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    4.696414] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.697175] ata4.00: configured for UDMA/133
[    4.711728] isa bounce pool size: 16 pages
[    4.711728] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500KS-00M 02.0 PQ: 0 ANSI: 5
[    4.711728] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500JS-00M 10.0 PQ: 0 ANSI: 5
[    4.711728] scsi 2:0:0:0: Direct-Access     ATA      ST3300831AS      3.01 PQ: 0 ANSI: 5
[    4.711728] scsi 3:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
[    4.711728] VP_IDE: IDE controller (0x1106:0x0571 rev 0x07) at  PCI slot 0000:00:0f.1
[    4.711728] VP_IDE: not 100% native mode: will probe irqs later
[    4.711728] VP_IDE: VIA vt8251 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
[    4.711728]     ide0: BM-DMA at 0xfc00-0xfc07
[    4.711728]     ide1: BM-DMA at 0xfc08-0xfc0f
[    4.711728] Probing IDE interface ide0...
[    5.185480] hda: WDC WD800JB-00JJC0, ATA DISK drive
[    5.465478] hdb: WDC WD800JB-00FMA0, ATA DISK drive
[    5.525405] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    5.525477] hda: UDMA/100 mode selected
[    5.525555] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    5.525645] hdb: UDMA/100 mode selected
[    5.525750] Probing IDE interface ide1...
[    6.494221] hdc: HL-DT-ST DVDRAM GSA-H10A, ATAPI CD/DVD-ROM drive
[    6.830145] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.830880] hdc: UDMA/33 mode selected
[    6.831360] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.842036] ide1 at 0x170-0x177,0x376 on irq 15
[    6.845871] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 20 (level, low) -> IRQ 20
[    6.845871] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    6.847876] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    6.847903] uhci_hcd 0000:00:10.0: irq 20, io base 0x0000d000
[    6.847992] usb usb2: configuration #1 chosen from 1 choice
[    6.848020] hub 2-0:1.0: USB hub found
[    6.848028] hub 2-0:1.0: 2 ports detected
[    6.949963] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.949966] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.949969] usb usb2: Product: UHCI Host Controller
[    6.949970] usb usb2: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    6.949972] usb usb2: SerialNumber: 0000:00:10.0
[    6.952874] ACPI: PCI Interrupt 0000:00:10.1[C] -> GSI 22 (level, low) -> IRQ 22
[    6.952874] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    6.952874] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[    6.952874] uhci_hcd 0000:00:10.1: irq 22, io base 0x0000c800
[    6.952874] usb usb3: configuration #1 chosen from 1 choice
[    6.952874] hub 3-0:1.0: USB hub found
[    6.952874] hub 3-0:1.0: 2 ports detected
[    7.053919] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.053921] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.053924] usb usb3: Product: UHCI Host Controller
[    7.053926] usb usb3: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    7.053928] usb usb3: SerialNumber: 0000:00:10.1
[    7.056879] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
[    7.056879] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    7.056879] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[    7.056879] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000c400
[    7.056879] usb usb4: configuration #1 chosen from 1 choice
[    7.056879] hub 4-0:1.0: USB hub found
[    7.056879] hub 4-0:1.0: 2 ports detected
[    7.160019] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.160024] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.160026] usb usb4: Product: UHCI Host Controller
[    7.160028] usb usb4: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    7.160030] usb usb4: SerialNumber: 0000:00:10.2
[    7.162945] ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 23 (level, low) -> IRQ 23
[    7.162945] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    7.162945] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[    7.162945] uhci_hcd 0000:00:10.3: irq 23, io base 0x0000c000
[    7.162945] usb usb5: configuration #1 chosen from 1 choice
[    7.162945] hub 5-0:1.0: USB hub found
[    7.162945] hub 5-0:1.0: 2 ports detected
[    7.285989] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.285993] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.285996] usb usb5: Product: UHCI Host Controller
[    7.285998] usb usb5: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    7.285999] usb usb5: SerialNumber: 0000:00:10.3
[    7.285989] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 23
[    7.285989] eth0: VIA Rhine II at 0x1b800, 00:15:f2:ee:2b:c0, IRQ 23.
[    7.285989] eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link c5e1.
[    7.317988] Driver 'sd' needs updating - please use bus_type methods
[    7.318083] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    7.318103] sd 0:0:0:0: [sda] Write Protect is off
[    7.318105] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.318137] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.318200] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    7.318216] sd 0:0:0:0: [sda] Write Protect is off
[    7.318219] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.318248] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.318253]  sda:<6>hda: max request size: 128KiB
[    7.326047] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
[    7.326047] hda: cache flushes supported
[    7.326047]  hda: sda1
[    7.330732] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.330732] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[    7.330732] sd 1:0:0:0: [sdb] Write Protect is off
[    7.330732] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.330732] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.330732] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[    7.330732] sd 1:0:0:0: [sdb] Write Protect is off
[    7.330732] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.330732] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.330732]  sdb: hda1 hda2 < sdb1
[    7.342051] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.342051] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    7.342051] sd 2:0:0:0: [sdc] Write Protect is off
[    7.342051] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.342051] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.342051] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    7.342051] sd 2:0:0:0: [sdc] Write Protect is off
[    7.342051] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.342051] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.342051]  sdc: hda5 >
[    7.357354] hdb: max request size: 128KiB
[    7.357448] hdb: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
[    7.358044] hdb: cache flushes supported
[    7.358044]  hdb: sdc1
[    7.359499] sd 2:0:0:0: [sdc] Attached SCSI disk
[    7.359593] sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
[    7.359612] sd 3:0:0:0: [sdd] Write Protect is off
[    7.359615] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.359645] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.359699] sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
[    7.359716] sd 3:0:0:0: [sdd] Write Protect is off
[    7.359718] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.359747] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.359750]  sdd: hdb1
[    7.367352]  sdd1
[    7.367438] sd 3:0:0:0: [sdd] Attached SCSI disk
[    7.374043] hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    7.374043] Uniform CD-ROM driver Revision: 3.20
[    7.632007] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    7.735938] md: linear personality registered for level -1
[    7.740025] md: multipath personality registered for level -4
[    7.743938] md: raid0 personality registered for level 0
[    7.744398] md: raid1 personality registered for level 1
[    7.748143] xor: automatically using best checksumming function: generic_sse
[    7.770396]    generic_sse:  7049.000 MB/sec
[    7.770396] xor: using function: generic_sse (7049.000 MB/sec)
[    7.770396] async_tx: api initialized (async)
[    7.815222] usb 3-2: configuration #1 chosen from 1 choice
[    7.818308] usb 3-2: New USB device found, idVendor=046d, idProduct=c30a
[    7.818311] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.818313] usb 3-2: Product: Logitech USB Keyboard
[    7.818315] usb 3-2: Manufacturer: Logitech
[    7.842396] raid6: int64x1   2007 MB/s
[    7.910396] raid6: int64x2   2730 MB/s
[    7.978396] raid6: int64x4   2616 MB/s
[    8.046396] raid6: int64x8   1717 MB/s
[    8.114396] raid6: sse2x1    2672 MB/s
[    8.182396] raid6: sse2x2    3498 MB/s
[    8.250396] raid6: sse2x4    3844 MB/s
[    8.250396] raid6: using algorithm sse2x4 (3844 MB/s)
[    8.250396] md: raid6 personality registered for level 6
[    8.250396] md: raid5 personality registered for level 5
[    8.250396] md: raid4 personality registered for level 4
[    8.258401] md: raid10 personality registered for level 10
[    8.290402] md: md0 stopped.
[    8.298997] md: bind<sdb1>
[    8.299129] md: bind<sda1>
[    8.505229] usbcore: registered new interface driver hiddev
[    8.521820] input: Logitech Logitech USB Keyboard as /class/input/input1
[    8.533185] input,hidraw0: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:10.1-2
[    8.563476] input: Logitech Logitech USB Keyboard as /class/input/input2
[    8.605211] input,hidraw1: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:10.1-2
[    8.605233] usbcore: registered new interface driver usbhid
[    8.605236] usbhid: v2.6:USB HID core driver
[    8.674734] PM: Starting manual resume from disk
[    8.750253] kjournald starting.  Commit interval 5 seconds
[    8.750253] EXT3-fs: mounted filesystem with ordered data mode.
[   10.127658] udev: starting version 141
[   10.127677] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   10.723312] input: Power Button (FF) as /class/input/input3
[   10.750056] ACPI: Power Button (FF) [PWRF]
[   10.752186] input: Sleep Button (CM) as /class/input/input4
[   10.779230] ACPI: Sleep Button (CM) [SLPB]
[   10.779330] input: Power Button (CM) as /class/input/input5
[   10.803329] ACPI: Power Button (CM) [PWRB]
[   10.898441] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.057820] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.137026] input: PC Speaker as /class/input/input6
[   11.287832] pnp: the driver 'parport_pc' has been registered
[   11.287832] parport_pc 00:06: reported by Plug and Play ACPI
[   11.287832] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
[   11.312524] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 17 (level, low) -> IRQ 17
[   11.312560] PCI: Setting latency timer of device 0000:04:01.0 to 64
[   11.316260] Error: Driver 'pcspkr' is already registered, aborting...
[   11.386677] parport_pc 00:06: driver attached
[   12.868103] Adding 3229024k swap on /dev/hda5.  Priority:-1 extents:1 across:3229024k
[   13.292099] EXT3 FS on hda1, internal journal
[   13.921730] loop: module loaded
[   13.962421] w83627ehf: Found W83627EHG chip at 0x290
[  109.606554] kjournald starting.  Commit interval 5 seconds
[  109.606960] EXT3 FS on sdd1, internal journal
[  109.606965] EXT3-fs: mounted filesystem with ordered data mode.
[  109.675717] NTFS driver 2.1.29 [Flags: R/W MODULE].
[  109.689307] NTFS volume version 3.1.
[  109.868236] NTFS volume version 3.1.
[  111.625871] eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[  112.418107] NET: Registered protocol family 10
[  112.418573] lo: Disabled Privacy Extensions
[  114.575918] RPC: Registered udp transport module.
[  114.575918] RPC: Registered tcp transport module.
[  114.610990] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  114.691922] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  114.718588] NFSD: starting 90-second grace period
[  123.184223] eth0: no IPv6 routers present
[ 9034.095071] kjournald starting.  Commit interval 5 seconds
[ 9034.095071] EXT3 FS on md0, internal journal
[ 9034.095071] EXT3-fs: mounted filesystem with ordered data mode.
[ 9351.377903] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x1b0000 action 0xe frozen
[ 9351.377941] ata2.00: irq_stat 0x04400000, PHY RDY changed
[ 9351.377961] ata2: SError: { PHYRdyChg PHYInt 10B8B Dispar }
[ 9351.377983] ata2.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[ 9351.377985]          res 50/00:00:b6:46:6a/00:00:13:00:00/e0 Emask 0x10 (ATA bus error)
[ 9351.378006] ata2.00: status: { DRDY }
[ 9351.378026] ata2: hard resetting link
[ 9357.659634] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9389.345002] ata2.00: qc timeout (cmd 0xec)
[ 9389.345013] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[ 9389.345017] ata2.00: revalidation failed (errno=-5)
[ 9389.345037] ata2: failed to recover some devices, retrying in 5 secs
[ 9395.548107] ata2: hard resetting link
[ 9396.033100] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9396.034245] ata2.00: configured for UDMA/133
[ 9396.034275] ata2: EH complete
[ 9396.098216] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[ 9396.114211] sd 1:0:0:0: [sdb] Write Protect is off
[ 9396.114217] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 9396.130212] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 9406.877614] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x800500 action 0x6 frozen
[ 9406.877654] ata2.00: irq_stat 0x08000000, interface fatal error
[ 9406.877676] ata2: SError: { UnrecovData Proto LinkSeq }
[ 9406.877698] ata2.00: cmd 35/00:00:b7:53:7b/00:04:16:00:00/e0 tag 0 dma 524288 out
[ 9406.877700]          res 50/00:00:b6:53:7b/00:00:16:00:00/e0 Emask 0x12 (ATA bus error)
[ 9406.877731] ata2.00: status: { DRDY }
[ 9406.877751] ata2: hard resetting link
[ 9407.599936] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9407.601159] ata2.00: configured for UDMA/133
[ 9407.601170] ata2: EH complete
[ 9407.623810] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[ 9407.643416] sd 1:0:0:0: [sdb] Write Protect is off
[ 9407.643416] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 9407.643416] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[10401.869812] ata2.00: exception Emask 0x12 SAct 0x0 SErr 0x800500 action 0x6 frozen
[10401.869851] ata2.00: irq_stat 0x08000000, interface fatal error
[10401.869872] ata2: SError: { UnrecovData Proto LinkSeq }
[10401.869895] ata2.00: cmd 35/00:00:27:8f:48/00:04:18:00:00/e0 tag 0 dma 524288 out
[10401.869897]          res 50/00:00:26:8f:48/00:00:18:00:00/e0 Emask 0x12 (ATA bus error)
[10401.869927] ata2.00: status: { DRDY }
[10401.869948] ata2: hard resetting link
[10402.589276] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10402.590443] ata2.00: configured for UDMA/133
[10402.590454] ata2: EH complete
[10402.631692] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[10402.644930] sd 1:0:0:0: [sdb] Write Protect is off
[10402.644930] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[10402.668930] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[10541.357079] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x6 frozen
[10541.357079] ata2.00: irq_stat 0x08000000, interface fatal error
[10541.357079] ata2: SError: { UnrecovData Handshk }
[10541.357079] ata2.00: cmd 35/00:00:3f:1e:50/00:04:01:00:00/e0 tag 0 dma 524288 out
[10541.357079]          res 50/00:00:3e:1e:50/00:00:01:00:00/e0 Emask 0x10 (ATA bus error)
[10541.357079] ata2.00: status: { DRDY }
[10541.357079] ata2: hard resetting link
[10542.149389] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10542.150583] ata2.00: configured for UDMA/133
[10542.150600] ata2: EH complete
[10542.188169] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[10542.188169] sd 1:0:0:0: [sdb] Write Protect is off
[10542.188169] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[10542.221068] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[10568.861257] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0xb0000 action 0xe frozen
[10568.861294] ata2.00: irq_stat 0x04400000, PHY RDY changed
[10568.861313] ata2: SError: { PHYRdyChg PHYInt 10B8B }
[10568.861335] ata2.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[10568.861337]          res 50/00:00:fe:08:5e/00:00:01:00:00/e1 Emask 0x10 (ATA bus error)
[10568.861358] ata2.00: status: { DRDY }
[10568.861378] ata2: hard resetting link
[10574.341643] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10604.771392] ata2.00: qc timeout (cmd 0xec)
[10604.771402] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[10604.771406] ata2.00: revalidation failed (errno=-5)
[10604.771427] ata2: failed to recover some devices, retrying in 5 secs
[10609.801831] ata2: hard resetting link
[10610.293800] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10610.294949] ata2.00: configured for UDMA/133
[10610.294974] ata2: EH complete
[10610.296513] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[10610.296782] sd 1:0:0:0: [sdb] Write Protect is off
[10610.296782] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[10610.313617] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[10665.354196] ata2: limiting SATA link speed to 1.5 Gbps
[10665.354196] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x6 frozen
[10665.354196] ata2.00: irq_stat 0x08000000, interface fatal error
[10665.354196] ata2: SError: { UnrecovData Handshk }
[10665.354196] ata2.00: cmd 35/00:00:27:ae:7a/00:04:01:00:00/e0 tag 0 dma 524288 out
[10665.354196]          res 50/00:00:26:ae:7a/00:00:01:00:00/e0 Emask 0x10 (ATA bus error)
[10665.354196] ata2.00: status: { DRDY }
[10665.354196] ata2: hard resetting link
[10665.846071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10665.846071] ata2.00: n_sectors mismatch 488397168 != 268435455
[10665.846071] ata2.00: revalidation failed (errno=-19)
[10665.846071] ata2: failed to recover some devices, retrying in 5 secs
[10670.878898] ata2: hard resetting link
[10671.429184] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10671.430120] ata2.00: n_sectors mismatch 488397168 != 268435455
[10671.430124] ata2.00: revalidation failed (errno=-19)
[10671.430145] ata2.00: disabled
[10671.934174] ata2: hard resetting link
[10672.462213] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10672.463130] ata2.00: ATA-0: WDC WD2500JS-00MVB1, 10.02E01, max MWDMA2
[10672.463134] ata2.00: 268435455 sectors, multi 0: LBA 
[10672.463137] ata2.00: applying bridge limits
[10672.463683] ata2.00: failed to set xfermode (err_mask=0x1)
[10672.463706] ata2: failed to recover some devices, retrying in 5 secs
[10677.749459] ata2: hard resetting link
[10678.272486] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10678.273961] ata2.00: failed to set xfermode (err_mask=0x1)
[10678.273987] ata2: limiting SATA link speed to 1.5 Gbps
[10678.273989] ata2.00: limiting speed to PIO3
[10678.273992] ata2: failed to recover some devices, retrying in 5 secs
[10683.430922] ata2: hard resetting link
[10683.920364] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10683.921839] ata2.00: failed to set xfermode (err_mask=0x1)
[10683.921863] ata2.00: disabled
[10684.424389] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[10684.424397] sd 1:0:0:0: [sdb] Sense Key : Aborted Command [current] [descriptor]
[10684.424402] Descriptor sense data with sense descriptors (in hex):
[10684.424404]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[10684.424410]         01 7a ae 26 
[10684.424413] sd 1:0:0:0: [sdb] Add. Sense: No additional sense information
[10684.424417] end_request: I/O error, dev sdb, sector 24817191
[10684.424440] Buffer I/O error on device md0, logical block 64151117
[10684.424459] lost page write due to I/O error on md0
[10684.424465] Buffer I/O error on device md0, logical block 64151118
[10684.424485] lost page write due to I/O error on md0
[10684.424488] Buffer I/O error on device md0, logical block 64151119
[10684.424507] lost page write due to I/O error on md0
[10684.424510] Buffer I/O error on device md0, logical block 64151120
[10684.424529] lost page write due to I/O error on md0
[10684.424533] Buffer I/O error on device md0, logical block 64151121
[10684.424552] lost page write due to I/O error on md0
[10684.424555] Buffer I/O error on device md0, logical block 64151122
[10684.424574] lost page write due to I/O error on md0
[10684.424577] Buffer I/O error on device md0, logical block 64151123
[10684.424596] lost page write due to I/O error on md0
[10684.424600] Buffer I/O error on device md0, logical block 64151124
[10684.424619] lost page write due to I/O error on md0
[10684.424622] Buffer I/O error on device md0, logical block 64151125
[10684.424641] lost page write due to I/O error on md0
[10684.424645] Buffer I/O error on device md0, logical block 64151126
[10684.424664] lost page write due to I/O error on md0
[10684.424812] sd 1:0:0:0: rejecting I/O to offline device
[10684.424833] sd 1:0:0:0: rejecting I/O to offline device
[10684.425009] sd 1:0:0:0: rejecting I/O to offline device
[10684.425180] sd 1:0:0:0: rejecting I/O to offline device
[10684.425364] sd 1:0:0:0: rejecting I/O to offline device
[10684.425540] sd 1:0:0:0: rejecting I/O to offline device
[10684.425718] sd 1:0:0:0: rejecting I/O to offline device
[10684.425897] sd 1:0:0:0: rejecting I/O to offline device
[10684.426076] sd 1:0:0:0: rejecting I/O to offline device
[10684.426258] sd 1:0:0:0: rejecting I/O to offline device
[10684.426435] sd 1:0:0:0: rejecting I/O to offline device
[10684.426620] sd 1:0:0:0: rejecting I/O to offline device
[10684.426676] sd 1:0:0:0: rejecting I/O to offline device
[10684.426790] sd 1:0:0:0: rejecting I/O to offline device
[10684.426822] sd 1:0:0:0: rejecting I/O to offline device
[10684.427009] sd 1:0:0:0: rejecting I/O to offline device
[10684.427191] sd 1:0:0:0: rejecting I/O to offline device
[10684.427354] sd 1:0:0:0: rejecting I/O to offline device
[10684.427464] sd 1:0:0:0: rejecting I/O to offline device
[10684.427647] sd 1:0:0:0: rejecting I/O to offline device
[10684.427831] sd 1:0:0:0: rejecting I/O to offline device
[10684.428010] sd 1:0:0:0: rejecting I/O to offline device
[10684.428196] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.433314] sd 1:0:0:0: rejecting I/O to offline device
[10684.442321] sd 1:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[10684.442325] end_request: I/O error, dev sdb, sector 24818215
[10684.442541] ata2: EH complete
[10684.442549] sd 1:0:0:0: rejecting I/O to offline device
[10684.442651] ata2.00: detaching (SCSI 1:0:0:0)
[10684.442912] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[10684.445215] EXT3-fs error (device md0): read_block_bitmap: Cannot read block bitmap - block_group = 1958, block_bitmap = 64159744
[10684.445703] EXT3-fs error (device md0): read_block_bitmap: Cannot read block bitmap - block_group = 1958, block_bitmap = 64159744
[10684.447930] Aborting journal on device md0.
[10684.449220] ext3_abort called.
[10684.449220] EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
[10684.449220] Remounting filesystem read-only
[10684.448023] EXT3-fs error (device md0): read_block_bitmap: Cannot read block bitmap - block_group = 3528, block_bitmap = 115605504
[10684.449220] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[10684.449225] sd 1:0:0:0: [sdb] Stopping disk
[10684.449261] sd 1:0:0:0: [sdb] START_STOP FAILED
[10684.449263] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[10684.467269] EXT3-fs error (device md0) in ext3_write_begin: IO failure
[10684.469554] EXT3-fs error (device md0) in ext3_write_begin: IO failure
[10684.567159] __journal_remove_journal_head: freeing b_frozen_data
[10684.567159] __journal_remove_journal_head: freeing b_frozen_data
[10684.567159] __journal_remove_journal_head: freeing b_committed_data
[10684.567159] __journal_remove_journal_head: freeing b_frozen_data
[14732.703127] Clocksource tsc unstable (delta = 62500252 ns)

--Boundary-00=_yQEBKBxwrNF9gWp--
