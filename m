Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYDNWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYDNWEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYDNWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:04:36 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:39428 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYDNWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:04:34 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 18:04:34 EDT
From: Paul Collins <paul@burly.ondioline.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: ata2: SATA link down (SStatus 611 SControl 300)
Date: Tue, 15 Apr 2008 09:48:26 +1200
Message-ID: <87od8cxg45.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that my optical drive no longer works with 2.6.25-rc9.
It works with 2.6.24.3.  git bisect claims the culprit is
c729072459446885c5c200137de1db32da5db4dc ("ata_piix: implement SIDPR SCR
access").

  $ diff -u cd.{ok,no} | grep '^.ata'
   ata_piix 0000:00:1f.2: version 2.12
  -ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
  +ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
   ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x20e0 irq 14
   ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x20e8 irq 15
  +ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ata1.00: ATA-7: SAMSUNG HD080HJ/P, ZH100-51, max UDMA/100
   ata1.00: 156301488 sectors, multi 16: LBA48 
   ata1.00: configured for UDMA/100
  -ata2.00: ATAPI: HL-DT-ST RW/DVD GCC-H10N, 1.03, max UDMA/100
  -ata2.00: configured for UDMA/100
  +ata2: SATA link down (SStatus 611 SControl 300)

lspci and full dmesg on the failing kernel follow.


00:00.0 Host bridge [0600]: Intel Corporation 82Q963/Q965 Memory Controller Hub [8086:2990] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 82Q963/Q965 PCI Express Root Port [8086:2991] (rev 02)
00:03.0 Communication controller [0780]: Intel Corporation 82Q963/Q965 HECI Controller [8086:2994] (rev 02)
00:19.0 Ethernet controller [0200]: Intel Corporation 82566DM Gigabit Network Connection [8086:104a] (rev 02)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 [8086:2834] (rev 02)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 [8086:2835] (rev 02)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 [8086:283a] (rev 02)
00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audio Controller [8086:284b] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 [8086:283f] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 [8086:2830] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 [8086:2831] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 [8086:2836] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev f2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801HO (ICH8DO) LPC Interface Controller [8086:2814] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801H (ICH8 Family) 4 port SATA IDE Controller [8086:2820] (rev 02)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV505 [Radeon X1550 Series] [1002:7143]
01:00.1 Display controller [0380]: ATI Technologies Inc RV505 [Radeon X1550 Series] (Secondary) [1002:7163]


Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.25-rc9 (paul@bandy) (gcc version 4.2.3 (Debian 4.2.3-3)) #32 SMP Mon Apr 14 13:53:07 NZST 2008
Command line: root=/dev/sda1 ro quiet pci=conf1 rootflags=barrier=1 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7b1d00 (usable)
 BIOS-e820: 000000007f7b1d00 - 000000007f800000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed40000 (reserved)
 BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522161) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000E7610, 0014 (r0 COMPAQ)
ACPI: RSDT 7F7C3D40, 0040 (r1 HPQOEM SLIC-BPC 20070105             0)
ACPI: FACP 7F7C3DE8, 0074 (r1 COMPAQ BROADH2O        1             0)
ACPI: DSDT 7F7C4143, 94FD (r1 COMPAQ DSDT_PRJ        1 MSFT  100000E)
ACPI: FACS 7F7C3D00, 0040
ACPI: APIC 7F7C3E5C, 0068 (r1 COMPAQ BROADH2O        1             0)
ACPI: ASF! 7F7C3EC4, 0063 (r32 COMPAQ BROADH2O        1             0)
ACPI: MCFG 7F7C3F27, 003C (r1 COMPAQ BROADH2O        1             0)
ACPI: TCPA 7F7C3F63, 0032 (r1 COMPAQ BROADH2O        1             0)
ACPI: SLIC 7F7C3F95, 0176 (r1 HPQOEM SLIC-BPC        1             0)
ACPI: HPET 7F7C410B, 0038 (r1 COMPAQ BROADH2O        1             0)
ACPI: DMI detected: Hewlett-Packard
No NUMA configuration found
Faking a node at 0000000000000000-000000007f7b1000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522161) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007f7b1000
  NODE_DATA [000000000000c000 - 0000000000012fff]
  bootmap [0000000000013000 -  0000000000022ef7] pages 10
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-701687] TEXT DATA BSS
early res: 3 [9fc00-a0bff] EBDA
early res: 4 [8000-bfff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   522161
On node 0 totalpages: 522064
  DMA zone: 56 pages used for memmap
  DMA zone: 1291 pages reserved
  DMA zone: 2652 pages, LIFO batch:0
  DMA32 zone: 7082 pages used for memmap
  DMA32 zone: 510983 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7f800000:74800000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 35568 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513635
Policy zone: DMA32
Kernel command line: root=/dev/sda1 ro quiet pci=conf1 rootflags=barrier=1 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2128.000 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2054152k/2088644k available (2525k kernel code, 34104k reserved, 1477k data, 368k init)
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4259.33 BogoMIPS (lpj=8518660)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 16625034
Detected 16.625 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4256.08 BogoMIPS (lpj=8512164)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
  domain 1: span 00000003
   groups: 00000003
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
  domain 1: span 00000003
   groups: 00000003
net_namespace: 304 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
 00:0c: calling quirk 0xffffffff8035aef7: quirk_system_pci_resources+0x0/0x179()
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0d: calling quirk 0xffffffff8035aef7: quirk_system_pci_resources+0x0/0x179()
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0e: calling quirk 0xffffffff8035aef7: quirk_system_pci_resources+0x0/0x179()
pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0f: calling quirk 0xffffffff8035aef7: quirk_system_pci_resources+0x0/0x179()
pnp 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
system 00:0c: driver attached
system 00:0d: ioport range 0x400-0x41f has been reserved
system 00:0d: ioport range 0x420-0x43f has been reserved
system 00:0d: ioport range 0x440-0x45f has been reserved
system 00:0d: ioport range 0x460-0x47f has been reserved
system 00:0d: ioport range 0x480-0x48f has been reserved
system 00:0d: ioport range 0xf800-0xf81f has been reserved
system 00:0d: ioport range 0xf820-0xf83f has been reserved
system 00:0d: ioport range 0xf840-0xf85f has been reserved
system 00:0d: ioport range 0xf860-0xf87f has been reserved
system 00:0d: ioport range 0xfa00-0xfa3f has been reserved
system 00:0d: ioport range 0xfc00-0xfc7f has been reserved
system 00:0d: ioport range 0xfc80-0xfcff has been reserved
system 00:0d: ioport range 0xfe00-0xfe7f has been reserved
system 00:0d: ioport range 0xfe80-0xfeff has been reserved
system 00:0d: driver attached
system 00:0e: ioport range 0x4d0-0x4d1 has been reserved
system 00:0e: ioport range 0xcb0-0xcbf has been reserved
system 00:0e: driver attached
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0x100000-0x7f7fffff could not be reserved
system 00:0f: iomem range 0xe4000-0xfffff could not be reserved
system 00:0f: iomem range 0xfec01000-0xfecfffff could not be reserved
system 00:0f: iomem range 0xfed00400-0xfed3ffff could not be reserved
system 00:0f: iomem range 0xfed40000-0xffffffff could not be reserved
system 00:0f: iomem range 0xf4000000-0xf7ffffff could not be reserved
system 00:0f: iomem range 0xd1400-0xe3fff has been reserved
system 00:0f: driver attached
PCI: Bridge: 0000:00:01.0
  IO window: 1000-1fff
  MEM window: 0xf0500000-0xf07fffff
  PREFETCH window: 0x00000000e0000000-0x00000000f01fffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
type=2000 audit(1208149227.356:1): initialized
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:08: driver attached
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:1a:4b:42:a9:da
e1000: 0000:00:19.0: e1000_probe: This device (id 8086:104a) will no longer be supported by this driver in the future.
e1000: 0000:00:19.0: e1000_probe: please use the "e1000e" driver instead.
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x20e0 irq 14
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x20e8 irq 15
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD080HJ/P, ZH100-51, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 611 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD080HJ/ ZH10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf0425000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf0425400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00002020
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002060
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 2-3: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00002080
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 2-3: configuration #1 chosen from 1 choice
hub 2-3:1.0: USB hub found
hub 2-3:1.0: 4 ports detected
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:06: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:05: driver attached
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
applesmc: supported laptop not found!
applesmc: driver init failed (ret=-19)!
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8DO TCO device (Version=2, TCOBASE=0xf860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
iTCO_vendor_support: vendor-support=0
usb 2-3.2: new low speed USB device using ehci_hcd and address 3
usb 2-3.2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.2/2-3.2:1.0/input/input1
input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.7-3.2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 368k freed
ACPI: SSDT 7F7CE637, 0320 (r1 COMPAQ  CPU_TM2        1 MSFT  100000E)
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ACPI: Power Button (CM) [PBTN]
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
EXT3 FS on sda1, internal journal
loop: module loaded
fuse init (API version 7.9)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth0 entered promiscuous mode
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
device tap0 entered promiscuous mode
br0: port 2(tap0) entering learning state
apic write: bad size=1 fee00030
Ignoring de-assert INIT to vcpu 0
Ignoring de-assert INIT to vcpu 0
kvm: emulating exchange as write
br0: topology change detected, propagating
br0: port 2(tap0) entering forwarding state
usb 2-3: USB disconnect, address 2
usb 2-3.2: USB disconnect, address 3
usb 2-3: new high speed USB device using ehci_hcd and address 4
usb 2-3: configuration #1 chosen from 1 choice
hub 2-3:1.0: USB hub found
hub 2-3:1.0: 4 ports detected
usb 2-3.2: new low speed USB device using ehci_hcd and address 5
usb 2-3.2: configuration #1 chosen from 1 choice
input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.2/2-3.2:1.0/input/input4
input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.7-3.2


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
