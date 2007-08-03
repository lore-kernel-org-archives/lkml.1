Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbXHCSjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbXHCSjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXHCSjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:39:07 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26779 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbXHCSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:39:01 -0400
Date: Fri, 03 Aug 2007 12:38:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Asus A8N-SLI Deluxe latest BIOS wants acpi_use_timer_override
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>
Message-id: <46B37619.2030205@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)"
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

It appears that the latest BIOS version 1805 for the ASUS A8N-SLI Deluxe
board fixes the broken ACPI timer override that was in earlier versions,
and which the kernel ignores on nForce4 chipsets. Now the same override:

ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)

seems to be needed, since without acpi_use_timer_override we end up
getting this (with apic=verbose):

..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... works.

and the timer IRQ ends up routed as XT-PIC instead of IO-APIC-edge. With 
acpi_use_timer_override we just get:

..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1

and it works through the IO-APIC.

I should think there must be a better way to handle this automatically.. 
Is there some way we can tell, given we have a chipset with a 
potentially broken BIOS, from the configuration of the IOAPIC whether 
the timer override is needed or not? Unfortunately I don't have output 
from apic=verbose with the old BIOS with the broken override, but maybe 
somebody else can provide that..

Attached are boot logs from 2.6.22-rc6-mm1 with and without 
acpi_use_timer_override along with the diff between them. Oddly enough, 
2.6.23-rc1-mm2 without acpi_use_timer_override spewed a warning about 
check_irq_resend and then paniced on boot since all attempts to set up 
the timer failed, but only when apic=verbose was set. Some kind of 
timing thing perhaps?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



--Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)
Content-type: text/plain; name=dmesg-a8nsd1805-useoverride.txt
Content-transfer-encoding: 8BIT
Content-disposition: inline; filename=dmesg-a8nsd1805-useoverride.txt

Initializing container subsys cpuset
Linux version 2.6.22-rc6-mm1 (rob@newcastle.ss.shawcable.net) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #2 SMP Thu Jun 28 18:35:46 CST 2007
Command line: ro root=/dev/VolGroup00/LogVol00 acpi_use_timer_override apic=verbose
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F7C80, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FFF3180, 69D6 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FFF0000, 0040
ACPI: SSDT 7FFF9C80, 01CA (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG 7FFF9EC0, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FFF9BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000007fff0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007fff0000
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524272
On node 0 totalpages: 524175
  DMA zone: 56 pages used for memmap
  DMA zone: 1482 pages reserved
  DMA zone: 2461 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 513065 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 41928 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515526
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 acpi_use_timer_override apic=verbose
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2211.333 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 620000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 2058044k/2097088k available (2405k kernel code, 38656k reserved, 2067k data, 340k init)
Calibrating delay using timer specific routine.. 4423.96 BogoMIPS (lpj=2211984)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0<7>IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
... lapic delta = 1256244
... PM timer delta = 357899
... PM timer result ok
..... delta 1256244
..... mult: 53963471
..... calibration result: 200999
..... CPU clock speed is 2210.0989 MHz.
..... host bus clock speed is 200.0999 MHz.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4421.89 BogoMIPS (lpj=2210948)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 *4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 003 0    0    0   0   0    1    1    31
 02 003 0    0    0   0   0    1    1    30
 03 003 1    0    0   0   0    1    1    33
 04 003 1    0    0   0   0    1    1    34
 05 003 1    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   0   0    1    1    39
 0a 003 1    0    0   0   0    1    1    3A
 0b 003 1    0    0   0   0    1    1    3B
 0c 003 1    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:01: iomem range 0x0-0x0 could not be reserved
pnp: 00:08: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:09: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:09: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:09: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:09: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:09.0
  IO window: a000-afff
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
  MEM window: d4000000-d40fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
Switched to high resolution mode on CPU 1
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
  IO window: 9000-9fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: c0000000-cfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3769k freed
audit: initializing netlink socket (disabled)
audit(1186143541.307:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Fan [FAN] (on)
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
cpuidle: driver acpi_idle failed to attach to cpu 1
cpuidle: driver acpi_idle failed to attach to cpu 0
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (2 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 340k freed
Write protecting the kernel read-only data: 1708k
USB Universal Host Controller Interface driver v3.0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
IOAPIC[0]: Set routing entry (2-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xd4103000
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6-mm1 ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
IOAPIC[0]: Set routing entry (2-22 -> 0x71 -> IRQ 22 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6-mm1 ehci_hcd
usb usb2: SerialNumber: 0000:00:02.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
IOAPIC[0]: Set routing entry (2-21 -> 0x79 -> IRQ 21 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xffffc2000032c480 ctl 0xffffc2000032c4a0 bmdma 0x000000000001d800 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc2000032c580 ctl 0xffffc2000032c5a0 bmdma 0x000000000001d808 irq 0
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
IOAPIC[0]: Set routing entry (2-20 -> 0x81 -> IRQ 20 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc2000032e480 ctl 0xffffc2000032e4a0 bmdma 0x000000000001c400 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc2000032e580 ctl 0xffffc2000032e5a0 bmdma 0x000000000001c408 irq 0
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb 2-2: new device found, idVendor=0409, idProduct=0059
usb 2-2: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
usb 2-9: new high speed USB device using ehci_hcd and address 6
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-6: ST3160827AS, 3.42, max UDMA/133
ata4.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>usb 2-9: new device found, idVendor=07cc, idProduct=0301
usb 2-9: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-9: Product: Winter Ver1.3   
usb 2-9: Manufacturer:         Ltd
usb 2-9: SerialNumber: 972394281841
usb 2-9: configuration #1 chosen from 1 choice
libusual: modprobe for usb-storage succeeded, but module is not present
 sda1
sd 2:0:0:0: [sda] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      ST3160827AS      3.42 PQ: 0 ANSI: 5
ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
sd 3:0:0:0: [sdb] Attached SCSI disk
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: new device found, idVendor=045e, idProduct=008c
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: Microsoft Wireless Optical Mouse® 1.0A
usb 1-1: Manufacturer: Microsoft
usb 1-1: configuration #1 chosen from 1 choice
input: Microsoft Microsoft Wireless Optical Mouse® 1.0A as /class/input/input0
input,hidraw0: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse® 1.0A] on usb-0000:00:02.0-1
usb 1-3: new full speed USB device using ohci_hcd and address 3
usb 1-3: new device found, idVendor=0451, idProduct=1446
usb 1-3: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 1-4: new low speed USB device using ohci_hcd and address 4
usb 1-4: new device found, idVendor=051d, idProduct=0002
usb 1-4: new device strings: Mfr=3, Product=1, SerialNumber=2
usb 1-4: Product: Back-UPS BR  800 FW:9.o2 .D USB FW:o2 
usb 1-4: Manufacturer: American Power Conversion
usb 1-4: SerialNumber: QB0419230426  
usb 1-4: configuration #1 chosen from 1 choice
hiddev96hidraw1: USB HID v1.10 Device [American Power Conversion Back-UPS BR  800 FW:9.o2 .D USB FW:o2 ] on usb-0000:00:02.0-4
usb 2-2.1: new full speed USB device using ehci_hcd and address 7
usb 2-2.1: new device found, idVendor=046d, idProduct=092c
usb 2-2.1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2.1: Product: Camera
usb 2-2.1: Manufacturer:         
usb 2-2.1: configuration #1 chosen from 1 choice
usb 1-3.1: new low speed USB device using ohci_hcd and address 5
usb 1-3.1: new device found, idVendor=045e, idProduct=002b
usb 1-3.1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-3.1: Product: Microsoft Internet Keyboard Pro
usb 1-3.1: configuration #1 chosen from 1 choice
input: Microsoft Internet Keyboard Pro as /class/input/input1
input,hidraw2: USB HID v1.10 Keyboard [Microsoft Internet Keyboard Pro] on usb-0000:00:02.0-3.1
input: Microsoft Internet Keyboard Pro as /class/input/input2
input,hidraw3: USB HID v1.10 Device [Microsoft Internet Keyboard Pro] on usb-0000:00:02.0-3.1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: netlink: version 1.0.0 loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1186143547.307:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1829 types, 81 bools, 1 sens, 1024 cats
security:  61 classes, 68575 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev revokefs, type revokefs), not configured for labeling
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1186143547.807:3): policy loaded auid=4294967295
audit(1186165152.271:4): avc:  denied  { sys_nice } for  pid=639 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
audit(1186165152.271:5): avc:  denied  { sys_nice } for  pid=596 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165152.271:6): avc:  denied  { sys_nice } for  pid=649 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
audit(1186165152.771:7): avc:  denied  { sys_nice } for  pid=896 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi4 : pata_amd
scsi5 : pata_amd
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001f000 irq 14
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001f008 irq 15
audit(1186165152.771:8): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165152.771:9): avc:  denied  { sys_nice } for  pid=910 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
audit(1186165152.771:10): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata5.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS0E, max UDMA/66
ata5.00: limited to UDMA/33 due to 40-wire cable
audit(1186165152.771:11): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165152.771:12): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165152.771:13): avc:  denied  { sys_nice } for  pid=914 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.271:14): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.271:15): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata5.00: configured for UDMA/33
audit(1186165153.271:16): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.271:17): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.271:18): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata6.00: ATAPI: LITE-ON CD-RW SOHR-5238S, 4S09, max UDMA/33
audit(1186165153.271:19): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.771:20): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata6.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS0E PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg2 type 5
scsi 5:0:0:0: CD-ROM            LITE-ON  CD-RW SOHR-5238S 4S09 PQ: 0 ANSI: 5
scsi 5:0:0:0: Attached scsi generic sg3 type 5
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
audit(1186165153.771:21): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
nvidia: module license 'NVIDIA' taints kernel.
audit(1186165153.771:22): avc:  denied  { sys_nice } for  pid=1089 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165153.771:23): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
IOAPIC[0]: Set routing entry (2-16 -> 0x89 -> IRQ 16 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:05:0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
firewire_ohci: Added fw-ohci device 0000:05:0b.0, OHCI version 1.10
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
IOAPIC[0]: Set routing entry (2-18 -> 0x91 -> IRQ 18 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 16:33:22 PDT 2007
audit(1186165154.270:24): avc:  denied  { sys_nice } for  pid=910 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:25): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:26): avc:  denied  { sys_nice } for  pid=896 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:27): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:28): avc:  denied  { sys_nice } for  pid=914 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:29): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:30): avc:  denied  { sys_nice } for  pid=1089 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:31): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:32): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:33): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:34): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.270:35): avc:  denied  { sys_nice } for  pid=1148 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:36): avc:  denied  { sys_nice } for  pid=1149 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
sr 5:0:0:0: Attached scsi CD-ROM sr1
audit(1186165154.770:37): avc:  denied  { sys_nice } for  pid=1174 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:38): avc:  denied  { sys_nice } for  pid=1185 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:39): avc:  denied  { sys_nice } for  pid=1185 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
firewire_core: created new fw device fw0 (0 config rom retries, S400)
firewire_core: created new fw device fw1 (0 config rom retries, S400)
firewire_core: phy config: card 0, new root=ffc1, gap_count=5
audit(1186165154.770:40): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:41): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:42): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165154.770:43): avc:  denied  { sys_nice } for  pid=1252 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165154.770:44): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165154.770:45): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165154.770:46): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165154.770:47): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165154.770:48): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
IOAPIC[0]: Set routing entry (2-17 -> 0x99 -> IRQ 17 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
ice1724: No matching model found for ID 0x581404a6
ice1724: Invalid EEPROM version 1
audit(1186165154.770:49): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186165155.270:50): avc:  denied  { sys_nice } for  pid=1302 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
loop: module loaded
audit(1186165155.770:51): avc:  denied  { sys_nice } for  pid=1324 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:52): avc:  denied  { sys_nice } for  pid=1328 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:53): avc:  denied  { sys_nice } for  pid=1333 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
lp: driver loaded but no devices found
audit(1186165155.770:54): avc:  denied  { sys_nice } for  pid=1328 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:55): avc:  denied  { sys_nice } for  pid=1353 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:56): avc:  denied  { sys_nice } for  pid=1357 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:57): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
No dock devices found.
audit(1186165155.770:58): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:59): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165155.770:60): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:61): avc:  denied  { sys_nice } for  pid=1375 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
audit(1186165156.270:62): avc:  denied  { sys_nice } for  pid=1382 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:63): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:64): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:65): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:66): avc:  denied  { sys_nice } for  pid=1405 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165156.270:67): avc:  denied  { sys_nice } for  pid=1405 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb3, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
audit(1186165157.270:68): avc:  denied  { sys_nice } for  pid=1444 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NTFS driver 2.1.28 [Flags: R/W MODULE].
audit(1186165157.270:69): avc:  denied  { sys_nice } for  pid=1449 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NTFS volume version 3.1.
SELinux: initialized (dev sda1, type ntfs), uses genfs_contexts
NTFS volume version 3.1.
SELinux: initialized (dev sdb1, type ntfs), uses genfs_contexts
audit(1186165157.770:70): avc:  denied  { sys_nice } for  pid=1454 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165157.770:71): avc:  denied  { sys_nice } for  pid=1454 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
SELinux: initialized (dev sdb2, type vfat), uses genfs_contexts
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
audit(1186165161.269:72): avc:  denied  { sys_nice } for  pid=1595 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186165162.769:73): avc:  denied  { sys_nice } for  pid=1662 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
audit(1186165171.768:74): audit_pid=2068 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
eth0: no IPv6 routers present
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts

--Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)
Content-type: text/plain; name=dmesg-a8nsd1805-diff.txt
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=dmesg-a8nsd1805-diff.txt

--- dmesg-a8nsd1805-nooverride.txt	2007-08-03 12:17:52.000000000 -0600
+++ dmesg-a8nsd1805-useoverride.txt	2007-08-03 12:20:37.000000000 -0600
@@ -1,6 +1,6 @@
 Initializing container subsys cpuset
 Linux version 2.6.22-rc6-mm1 (rob@newcastle.ss.shawcable.net) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #2 SMP Thu Jun 28 18:35:46 CST 2007
-Command line: ro root=/dev/VolGroup00/LogVol00 apic=verbose
+Command line: ro root=/dev/VolGroup00/LogVol00 acpi_use_timer_override apic=verbose
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
@@ -45,8 +45,6 @@
   DMA32 zone: 513065 pages, LIFO batch:31
   Normal zone: 0 pages used for memmap
   Movable zone: 0 pages used for memmap
-Nvidia board detected. Ignoring ACPI timer override.
-If you got timer trouble try acpi_use_timer_override
 ACPI: PM-Timer IO Port: 0x4008
 ACPI: Local APIC address 0xfee00000
 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
@@ -58,10 +56,11 @@
 ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
 IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
-ACPI: BIOS IRQ0 pin2 override ignored.
 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
 ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
+ACPI: IRQ0 used by override.
+ACPI: IRQ2 used by override.
 ACPI: IRQ9 used by override.
 ACPI: IRQ14 used by override.
 ACPI: IRQ15 used by override.
@@ -77,12 +76,12 @@
 PERCPU: Allocating 41928 bytes of per cpu data
 Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515526
 Policy zone: DMA32
-Kernel command line: ro root=/dev/VolGroup00/LogVol00 apic=verbose
+Kernel command line: ro root=/dev/VolGroup00/LogVol00 acpi_use_timer_override apic=verbose
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 32768 bytes)
 TSC calibrated against PM_TIMER
 Marking TSC unstable due to TSCs unsynchronized
-time.c: Detected 2211.330 MHz processor.
+time.c: Detected 2211.333 MHz processor.
 Console: colour VGA+ 80x25
 console [tty0] enabled
 Checking aperture...
@@ -90,7 +89,7 @@
 Aperture too small (32 MB)
 No AGP bridge found
 Memory: 2058044k/2097088k available (2405k kernel code, 38656k reserved, 2067k data, 340k init)
-Calibrating delay using timer specific routine.. 4423.99 BogoMIPS (lpj=2211995)
+Calibrating delay using timer specific routine.. 4423.96 BogoMIPS (lpj=2211984)
 Security Framework v1.0.0 initialized
 SELinux:  Initializing.
 SELinux:  Starting in permissive mode
@@ -109,9 +108,8 @@
 enabled ExtINT on CPU#0
 ENABLING IO-APIC IRQs
 init IO_APIC IRQs
-IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
-IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
-IOAPIC[0]: Set routing entry (2-2 -> 0x32 -> IRQ 2 Mode:0 Active:0)
+ IO-APIC (apicid-pin) 2-0<7>IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
+IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
@@ -125,26 +123,22 @@
 IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
 IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
- IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
-..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
-..MP-BIOS bug: 8254 timer not connected to IO-APIC
-...trying to set up timer (IRQ0) through the 8259A ...  failed.
-...trying to set up timer as Virtual Wire IRQ... failed.
-...trying to set up timer as ExtINT IRQ... works.
+, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
+..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 Using local APIC timer interrupts.
-... lapic delta = 1256247
-... PM timer delta = 357900
+... lapic delta = 1256244
+... PM timer delta = 357899
 ... PM timer result ok
-..... delta 1256247
-..... mult: 53963600
+..... delta 1256244
+..... mult: 53963471
 ..... calibration result: 200999
-..... CPU clock speed is 2210.0994 MHz.
+..... CPU clock speed is 2210.0989 MHz.
 ..... host bus clock speed is 200.0999 MHz.
 SMP alternatives: switching to SMP code
 Booting processor 1/2 APIC 0x1
 Initializing CPU#1
 masked ExtINT on CPU#1
-Calibrating delay using timer specific routine.. 4421.89 BogoMIPS (lpj=2210946)
+Calibrating delay using timer specific routine.. 4421.89 BogoMIPS (lpj=2210948)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 512K (64 bytes/line)
 CPU 1/1 -> Node 0
@@ -212,7 +206,7 @@
 usbcore: registered new device driver usb
 PCI: Using ACPI for IRQ routing
 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
-number of MP IRQ sources: 16.
+number of MP IRQ sources: 15.
 number of IO-APIC #2 registers: 24.
 testing the IO APIC.......................
 
@@ -227,9 +221,9 @@
 .......     : arbitration: 00
 .... IRQ redirection table:
  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
- 00 003 1    0    0   0   0    0    0    30
+ 00 000 1    0    0   0   0    0    0    00
  01 003 0    0    0   0   0    1    1    31
- 02 003 1    0    0   0   0    1    1    32
+ 02 003 0    0    0   0   0    1    1    30
  03 003 1    0    0   0   0    1    1    33
  04 003 1    0    0   0   0    1    1    34
  05 003 1    0    0   0   0    1    1    35
@@ -252,9 +246,8 @@
  16 000 1    0    0   0   0    0    0    00
  17 000 1    0    0   0   0    0    0    00
 IRQ to pin mappings:
-IRQ0 -> 0:0
+IRQ0 -> 0:2
 IRQ1 -> 0:1
-IRQ2 -> 0:2
 IRQ3 -> 0:3
 IRQ4 -> 0:4
 IRQ5 -> 0:5
@@ -287,13 +280,13 @@
 pnp: 00:09: iomem range 0xfc000-0xfffff could not be reserved
 PCI: Bridge: 0000:00:09.0
   IO window: a000-afff
-  MEM window: d4000000-d40fffff
 Time: acpi_pm clocksource has been installed.
 Switched to high resolution mode on CPU 0
-Switched to high resolution mode on CPU 1
+  MEM window: d4000000-d40fffff
   PREFETCH window: disabled.
 PCI: Bridge: 0000:00:0b.0
   IO window: disabled.
+Switched to high resolution mode on CPU 1
   MEM window: disabled.
   PREFETCH window: disabled.
 PCI: Bridge: 0000:00:0c.0
@@ -322,7 +315,7 @@
 checking if image is initramfs... it is
 Freeing initrd memory: 3769k freed
 audit: initializing netlink socket (disabled)
-audit(1186143314.411:1): initialized
+audit(1186143541.307:1): initialized
 Total HugeTLB memory allocated, 0
 VFS: Disk quotas dquot_6.5.1
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
@@ -481,7 +474,14 @@
 sd 2:0:0:0: [sda] Write Protect is off
 sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
 sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sda: sda1
+ sda:<6>usb 2-9: new device found, idVendor=07cc, idProduct=0301
+usb 2-9: new device strings: Mfr=1, Product=2, SerialNumber=3
+usb 2-9: Product: Winter Ver1.3   
+usb 2-9: Manufacturer:         Ltd
+usb 2-9: SerialNumber: 972394281841
+usb 2-9: configuration #1 chosen from 1 choice
+libusual: modprobe for usb-storage succeeded, but module is not present
+ sda1
 sd 2:0:0:0: [sda] Attached SCSI disk
 scsi 3:0:0:0: Direct-Access     ATA      ST3160827AS      3.42 PQ: 0 ANSI: 5
 ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
@@ -493,14 +493,7 @@
 sd 3:0:0:0: [sdb] Write Protect is off
 sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
 sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sdb: sdb1 sdb2 sdb3 sdb4 <<6>usb 2-9: new device found, idVendor=07cc, idProduct=0301
-usb 2-9: new device strings: Mfr=1, Product=2, SerialNumber=3
-usb 2-9: Product: Winter Ver1.3   
-usb 2-9: Manufacturer:         Ltd
-usb 2-9: SerialNumber: 972394281841
-usb 2-9: configuration #1 chosen from 1 choice
-libusual: modprobe for usb-storage succeeded, but module is not present
- sdb5 >
+ sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
 sd 3:0:0:0: [sdb] Attached SCSI disk
 usb 1-1: new low speed USB device using ohci_hcd and address 2
 usb 1-1: new device found, idVendor=045e, idProduct=008c
@@ -543,7 +536,7 @@
 device-mapper: netlink: version 1.0.0 loaded
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
-audit(1186143320.411:2): enforcing=1 old_enforcing=0 auid=4294967295
+audit(1186143547.307:2): enforcing=1 old_enforcing=0 auid=4294967295
 security:  3 users, 6 roles, 1829 types, 81 bools, 1 sens, 1024 cats
 security:  61 classes, 68575 rules
 SELinux:  Completing initialization.
@@ -567,42 +560,39 @@
 SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
 SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
 SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
-audit(1186143320.411:3): policy loaded auid=4294967295
-audit(1186164925.218:4): avc:  denied  { sys_nice } for  pid=638 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186143547.807:3): policy loaded auid=4294967295
+audit(1186165152.271:4): avc:  denied  { sys_nice } for  pid=639 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 sd 2:0:0:0: Attached scsi generic sg0 type 0
 sd 3:0:0:0: Attached scsi generic sg1 type 0
-audit(1186164925.718:5): avc:  denied  { sys_nice } for  pid=596 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164925.718:6): avc:  denied  { sys_nice } for  pid=874 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164925.718:7): avc:  denied  { sys_nice } for  pid=653 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.271:5): avc:  denied  { sys_nice } for  pid=596 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.271:6): avc:  denied  { sys_nice } for  pid=649 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 Floppy drive(s): fd0 is 1.44M
 FDC 0 is a post-1991 82077
-audit(1186164925.718:8): avc:  denied  { sys_nice } for  pid=874 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
-i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
-audit(1186164925.718:9): avc:  denied  { sys_nice } for  pid=895 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:7): avc:  denied  { sys_nice } for  pid=896 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 pata_amd 0000:00:06.0: version 0.3.8
 PCI: Setting latency timer of device 0000:00:06.0 to 64
 scsi4 : pata_amd
 scsi5 : pata_amd
 ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001f000 irq 14
 ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001f008 irq 15
-audit(1186164925.718:10): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164925.718:11): avc:  denied  { sys_nice } for  pid=905 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:8): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:9): avc:  denied  { sys_nice } for  pid=910 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
-audit(1186164926.218:12): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.218:13): avc:  denied  { sys_nice } for  pid=908 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.218:14): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.218:15): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.218:16): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:10): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 ata5.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS0E, max UDMA/66
 ata5.00: limited to UDMA/33 due to 40-wire cable
-audit(1186164926.218:17): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:11): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:12): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165152.771:13): avc:  denied  { sys_nice } for  pid=914 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:14): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:15): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 ata5.00: configured for UDMA/33
-audit(1186164926.218:18): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.718:19): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164926.718:20): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:16): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:17): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:18): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 ata6.00: ATAPI: LITE-ON CD-RW SOHR-5238S, 4S09, max UDMA/33
-audit(1186164926.718:21): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.271:19): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.771:20): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 ata6.00: configured for UDMA/33
 scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS0E PQ: 0 ANSI: 5
 scsi 4:0:0:0: Attached scsi generic sg2 type 5
@@ -612,110 +602,114 @@
 ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
 PCI: Setting latency timer of device 0000:00:0a.0 to 64
 forcedeth: using HIGHDMA
+audit(1186165153.771:21): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 nvidia: module license 'NVIDIA' taints kernel.
-audit(1186164927.218:22): avc:  denied  { sys_nice } for  pid=1092 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:23): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:24): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:25): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:26): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:27): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.771:22): avc:  denied  { sys_nice } for  pid=1089 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165153.771:23): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
-audit(1186164927.218:28): avc:  denied  { sys_nice } for  pid=905 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
 IOAPIC[0]: Set routing entry (2-16 -> 0x89 -> IRQ 16 Mode:1 Active:1)
 ACPI: PCI Interrupt 0000:05:0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
-audit(1186164927.218:29): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:30): avc:  denied  { sys_nice } for  pid=1142 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 firewire_ohci: Added fw-ohci device 0000:05:0b.0, OHCI version 1.10
 shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
-audit(1186164927.218:31): avc:  denied  { sys_nice } for  pid=908 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
+i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
 ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
 IOAPIC[0]: Set routing entry (2-18 -> 0x91 -> IRQ 18 Mode:1 Active:1)
 ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
 PCI: Setting latency timer of device 0000:01:00.0 to 64
 NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 16:33:22 PDT 2007
-audit(1186164927.218:32): avc:  denied  { sys_nice } for  pid=895 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:33): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:34): avc:  denied  { sys_nice } for  pid=1092 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.218:35): avc:  denied  { sys_nice } for  pid=1150 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:36): avc:  denied  { sys_nice } for  pid=1150 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:37): avc:  denied  { sys_nice } for  pid=1169 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:38): avc:  denied  { sys_nice } for  pid=1168 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:24): avc:  denied  { sys_nice } for  pid=910 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:25): avc:  denied  { sys_nice } for  pid=936 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:26): avc:  denied  { sys_nice } for  pid=896 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:27): avc:  denied  { sys_nice } for  pid=1048 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:28): avc:  denied  { sys_nice } for  pid=914 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:29): avc:  denied  { sys_nice } for  pid=922 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:30): avc:  denied  { sys_nice } for  pid=1089 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:31): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:32): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:33): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:34): avc:  denied  { sys_nice } for  pid=1044 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.270:35): avc:  denied  { sys_nice } for  pid=1148 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:36): avc:  denied  { sys_nice } for  pid=1149 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 4:0:0:0: Attached scsi CD-ROM sr0
 sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
 sr 5:0:0:0: Attached scsi CD-ROM sr1
-audit(1186164927.718:39): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:40): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:41): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164927.718:42): avc:  denied  { sys_nice } for  pid=1203 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164927.718:43): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164927.718:44): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164927.718:45): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164927.718:46): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:37): avc:  denied  { sys_nice } for  pid=1174 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:38): avc:  denied  { sys_nice } for  pid=1185 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:39): avc:  denied  { sys_nice } for  pid=1185 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
 firewire_core: created new fw device fw0 (0 config rom retries, S400)
-audit(1186164927.718:47): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+firewire_core: created new fw device fw1 (0 config rom retries, S400)
+firewire_core: phy config: card 0, new root=ffc1, gap_count=5
+audit(1186165154.770:40): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:41): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:42): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165154.770:43): avc:  denied  { sys_nice } for  pid=1252 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:44): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:45): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:46): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:47): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:48): avc:  denied  { sys_nice } for  pid=1259 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
 IOAPIC[0]: Set routing entry (2-17 -> 0x99 -> IRQ 17 Mode:1 Active:1)
 ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
 ice1724: No matching model found for ID 0x581404a6
 ice1724: Invalid EEPROM version 1
-firewire_core: created new fw device fw1 (0 config rom retries, S400)
-firewire_core: phy config: card 0, new root=ffc1, gap_count=5
-audit(1186164928.218:48): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
-audit(1186164928.218:49): avc:  denied  { sys_nice } for  pid=1300 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165154.770:49): avc:  denied  { sys_nice } for  pid=1221 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
+audit(1186165155.270:50): avc:  denied  { sys_nice } for  pid=1302 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 loop: module loaded
-audit(1186164928.717:50): avc:  denied  { sys_nice } for  pid=1322 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164928.717:51): avc:  denied  { sys_nice } for  pid=1326 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164928.717:52): avc:  denied  { sys_nice } for  pid=1331 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:51): avc:  denied  { sys_nice } for  pid=1324 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:52): avc:  denied  { sys_nice } for  pid=1328 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:53): avc:  denied  { sys_nice } for  pid=1333 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 lp: driver loaded but no devices found
-audit(1186164928.717:53): avc:  denied  { sys_nice } for  pid=1326 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164928.717:54): avc:  denied  { sys_nice } for  pid=1352 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:55): avc:  denied  { sys_nice } for  pid=1356 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:56): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:54): avc:  denied  { sys_nice } for  pid=1328 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:55): avc:  denied  { sys_nice } for  pid=1353 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:56): avc:  denied  { sys_nice } for  pid=1357 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:57): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 No dock devices found.
-audit(1186164929.217:57): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:58): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:59): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:60): avc:  denied  { sys_nice } for  pid=1374 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:58): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:59): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165155.770:60): avc:  denied  { sys_nice } for  pid=1362 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:61): avc:  denied  { sys_nice } for  pid=1375 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 input: Power Button (FF) as /class/input/input3
 ACPI: Power Button (FF) [PWRF]
 input: Power Button (CM) as /class/input/input4
 ACPI: Power Button (CM) [PWRB]
-audit(1186164929.217:61): avc:  denied  { sys_nice } for  pid=1381 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:62): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:63): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:64): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:65): avc:  denied  { sys_nice } for  pid=1404 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164929.217:66): avc:  denied  { sys_nice } for  pid=1404 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:62): avc:  denied  { sys_nice } for  pid=1382 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:63): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:64): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:65): avc:  denied  { sys_nice } for  pid=1395 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:66): avc:  denied  { sys_nice } for  pid=1405 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165156.270:67): avc:  denied  { sys_nice } for  pid=1405 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 EXT3 FS on dm-0, internal journal
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on sdb3, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
 SELinux: initialized (dev sdb3, type ext3), uses xattr
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
-audit(1186164930.717:67): avc:  denied  { sys_nice } for  pid=1443 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165157.270:68): avc:  denied  { sys_nice } for  pid=1444 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 NTFS driver 2.1.28 [Flags: R/W MODULE].
-audit(1186164930.717:68): avc:  denied  { sys_nice } for  pid=1448 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165157.270:69): avc:  denied  { sys_nice } for  pid=1449 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 NTFS volume version 3.1.
 SELinux: initialized (dev sda1, type ntfs), uses genfs_contexts
 NTFS volume version 3.1.
 SELinux: initialized (dev sdb1, type ntfs), uses genfs_contexts
-audit(1186164930.717:69): avc:  denied  { sys_nice } for  pid=1453 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164930.717:70): avc:  denied  { sys_nice } for  pid=1453 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165157.770:70): avc:  denied  { sys_nice } for  pid=1454 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165157.770:71): avc:  denied  { sys_nice } for  pid=1454 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 SELinux: initialized (dev sdb2, type vfat), uses genfs_contexts
 Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
 SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
-audit(1186164934.217:71): avc:  denied  { sys_nice } for  pid=1594 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
-audit(1186164935.716:72): avc:  denied  { sys_nice } for  pid=1661 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165161.269:72): avc:  denied  { sys_nice } for  pid=1595 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
+audit(1186165162.769:73): avc:  denied  { sys_nice } for  pid=1662 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
 NET: Registered protocol family 10
 lo: Disabled Privacy Extensions
-audit(1186164944.715:73): audit_pid=2067 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
-eth0: no IPv6 routers present
+audit(1186165171.768:74): audit_pid=2068 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
 it87: Found IT8712F chip at 0x290, revision 7
 it87: in3 is VCC (+5V)
 it87: in7 is VCCH (+5V Stand-By)
+eth0: no IPv6 routers present
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts

--Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)
Content-type: text/plain; name=dmesg-a8nsd1805-nooverride.txt
Content-transfer-encoding: 8BIT
Content-disposition: inline; filename=dmesg-a8nsd1805-nooverride.txt

Initializing container subsys cpuset
Linux version 2.6.22-rc6-mm1 (rob@newcastle.ss.shawcable.net) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #2 SMP Thu Jun 28 18:35:46 CST 2007
Command line: ro root=/dev/VolGroup00/LogVol00 apic=verbose
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F7C80, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FFF3180, 69D6 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FFF0000, 0040
ACPI: SSDT 7FFF9C80, 01CA (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG 7FFF9EC0, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FFF9BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000007fff0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007fff0000
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524272
On node 0 totalpages: 524175
  DMA zone: 56 pages used for memmap
  DMA zone: 1482 pages reserved
  DMA zone: 2461 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 513065 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 41928 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515526
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 apic=verbose
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2211.330 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 620000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 2058044k/2097088k available (2405k kernel code, 38656k reserved, 2067k data, 340k init)
Calibrating delay using timer specific routine.. 4423.99 BogoMIPS (lpj=2211995)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x32 -> IRQ 2 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... works.
Using local APIC timer interrupts.
... lapic delta = 1256247
... PM timer delta = 357900
... PM timer result ok
..... delta 1256247
..... mult: 53963600
..... calibration result: 200999
..... CPU clock speed is 2210.0994 MHz.
..... host bus clock speed is 200.0999 MHz.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4421.89 BogoMIPS (lpj=2210946)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 *4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 003 1    0    0   0   0    0    0    30
 01 003 0    0    0   0   0    1    1    31
 02 003 1    0    0   0   0    1    1    32
 03 003 1    0    0   0   0    1    1    33
 04 003 1    0    0   0   0    1    1    34
 05 003 1    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   0   0    1    1    39
 0a 003 1    0    0   0   0    1    1    3A
 0b 003 1    0    0   0   0    1    1    3B
 0c 003 1    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:01: iomem range 0x0-0x0 could not be reserved
pnp: 00:08: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:09: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:09: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:09: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:09: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:09.0
  IO window: a000-afff
  MEM window: d4000000-d40fffff
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
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
  IO window: 9000-9fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: c0000000-cfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3769k freed
audit: initializing netlink socket (disabled)
audit(1186143314.411:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Fan [FAN] (on)
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
cpuidle: driver acpi_idle failed to attach to cpu 1
cpuidle: driver acpi_idle failed to attach to cpu 0
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (2 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 340k freed
Write protecting the kernel read-only data: 1708k
USB Universal Host Controller Interface driver v3.0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
IOAPIC[0]: Set routing entry (2-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xd4103000
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6-mm1 ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
IOAPIC[0]: Set routing entry (2-22 -> 0x71 -> IRQ 22 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6-mm1 ehci_hcd
usb usb2: SerialNumber: 0000:00:02.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
IOAPIC[0]: Set routing entry (2-21 -> 0x79 -> IRQ 21 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xffffc2000032c480 ctl 0xffffc2000032c4a0 bmdma 0x000000000001d800 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc2000032c580 ctl 0xffffc2000032c5a0 bmdma 0x000000000001d808 irq 0
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
IOAPIC[0]: Set routing entry (2-20 -> 0x81 -> IRQ 20 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc2000032e480 ctl 0xffffc2000032e4a0 bmdma 0x000000000001c400 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc2000032e580 ctl 0xffffc2000032e5a0 bmdma 0x000000000001c408 irq 0
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb 2-2: new device found, idVendor=0409, idProduct=0059
usb 2-2: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
usb 2-9: new high speed USB device using ehci_hcd and address 6
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-6: ST3160827AS, 3.42, max UDMA/133
ata4.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 2:0:0:0: [sda] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      ST3160827AS      3.42 PQ: 0 ANSI: 5
ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 <<6>usb 2-9: new device found, idVendor=07cc, idProduct=0301
usb 2-9: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-9: Product: Winter Ver1.3   
usb 2-9: Manufacturer:         Ltd
usb 2-9: SerialNumber: 972394281841
usb 2-9: configuration #1 chosen from 1 choice
libusual: modprobe for usb-storage succeeded, but module is not present
 sdb5 >
sd 3:0:0:0: [sdb] Attached SCSI disk
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: new device found, idVendor=045e, idProduct=008c
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: Microsoft Wireless Optical Mouse® 1.0A
usb 1-1: Manufacturer: Microsoft
usb 1-1: configuration #1 chosen from 1 choice
input: Microsoft Microsoft Wireless Optical Mouse® 1.0A as /class/input/input0
input,hidraw0: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse® 1.0A] on usb-0000:00:02.0-1
usb 1-3: new full speed USB device using ohci_hcd and address 3
usb 1-3: new device found, idVendor=0451, idProduct=1446
usb 1-3: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 1-4: new low speed USB device using ohci_hcd and address 4
usb 1-4: new device found, idVendor=051d, idProduct=0002
usb 1-4: new device strings: Mfr=3, Product=1, SerialNumber=2
usb 1-4: Product: Back-UPS BR  800 FW:9.o2 .D USB FW:o2 
usb 1-4: Manufacturer: American Power Conversion
usb 1-4: SerialNumber: QB0419230426  
usb 1-4: configuration #1 chosen from 1 choice
hiddev96hidraw1: USB HID v1.10 Device [American Power Conversion Back-UPS BR  800 FW:9.o2 .D USB FW:o2 ] on usb-0000:00:02.0-4
usb 2-2.1: new full speed USB device using ehci_hcd and address 7
usb 2-2.1: new device found, idVendor=046d, idProduct=092c
usb 2-2.1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2.1: Product: Camera
usb 2-2.1: Manufacturer:         
usb 2-2.1: configuration #1 chosen from 1 choice
usb 1-3.1: new low speed USB device using ohci_hcd and address 5
usb 1-3.1: new device found, idVendor=045e, idProduct=002b
usb 1-3.1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-3.1: Product: Microsoft Internet Keyboard Pro
usb 1-3.1: configuration #1 chosen from 1 choice
input: Microsoft Internet Keyboard Pro as /class/input/input1
input,hidraw2: USB HID v1.10 Keyboard [Microsoft Internet Keyboard Pro] on usb-0000:00:02.0-3.1
input: Microsoft Internet Keyboard Pro as /class/input/input2
input,hidraw3: USB HID v1.10 Device [Microsoft Internet Keyboard Pro] on usb-0000:00:02.0-3.1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: netlink: version 1.0.0 loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1186143320.411:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1829 types, 81 bools, 1 sens, 1024 cats
security:  61 classes, 68575 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev revokefs, type revokefs), not configured for labeling
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1186143320.411:3): policy loaded auid=4294967295
audit(1186164925.218:4): avc:  denied  { sys_nice } for  pid=638 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
audit(1186164925.718:5): avc:  denied  { sys_nice } for  pid=596 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164925.718:6): avc:  denied  { sys_nice } for  pid=874 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164925.718:7): avc:  denied  { sys_nice } for  pid=653 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
audit(1186164925.718:8): avc:  denied  { sys_nice } for  pid=874 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
audit(1186164925.718:9): avc:  denied  { sys_nice } for  pid=895 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi4 : pata_amd
scsi5 : pata_amd
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001f000 irq 14
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001f008 irq 15
audit(1186164925.718:10): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164925.718:11): avc:  denied  { sys_nice } for  pid=905 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
audit(1186164926.218:12): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.218:13): avc:  denied  { sys_nice } for  pid=908 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.218:14): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.218:15): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.218:16): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata5.00: ATAPI: LITE-ON DVDRW SHM-165H6S, HS0E, max UDMA/66
ata5.00: limited to UDMA/33 due to 40-wire cable
audit(1186164926.218:17): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata5.00: configured for UDMA/33
audit(1186164926.218:18): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.718:19): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164926.718:20): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata6.00: ATAPI: LITE-ON CD-RW SOHR-5238S, 4S09, max UDMA/33
audit(1186164926.718:21): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ata6.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165H6S HS0E PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg2 type 5
scsi 5:0:0:0: CD-ROM            LITE-ON  CD-RW SOHR-5238S 4S09 PQ: 0 ANSI: 5
scsi 5:0:0:0: Attached scsi generic sg3 type 5
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
nvidia: module license 'NVIDIA' taints kernel.
audit(1186164927.218:22): avc:  denied  { sys_nice } for  pid=1092 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:23): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:24): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:25): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:26): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:27): avc:  denied  { sys_nice } for  pid=969 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
audit(1186164927.218:28): avc:  denied  { sys_nice } for  pid=905 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
IOAPIC[0]: Set routing entry (2-16 -> 0x89 -> IRQ 16 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:05:0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
audit(1186164927.218:29): avc:  denied  { sys_nice } for  pid=929 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:30): avc:  denied  { sys_nice } for  pid=1142 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
firewire_ohci: Added fw-ohci device 0000:05:0b.0, OHCI version 1.10
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
audit(1186164927.218:31): avc:  denied  { sys_nice } for  pid=908 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
IOAPIC[0]: Set routing entry (2-18 -> 0x91 -> IRQ 18 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 16:33:22 PDT 2007
audit(1186164927.218:32): avc:  denied  { sys_nice } for  pid=895 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:33): avc:  denied  { sys_nice } for  pid=972 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:34): avc:  denied  { sys_nice } for  pid=1092 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.218:35): avc:  denied  { sys_nice } for  pid=1150 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:36): avc:  denied  { sys_nice } for  pid=1150 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:37): avc:  denied  { sys_nice } for  pid=1169 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:38): avc:  denied  { sys_nice } for  pid=1168 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
sr 5:0:0:0: Attached scsi CD-ROM sr1
audit(1186164927.718:39): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:40): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:41): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164927.718:42): avc:  denied  { sys_nice } for  pid=1203 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164927.718:43): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164927.718:44): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164927.718:45): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164927.718:46): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
firewire_core: created new fw device fw0 (0 config rom retries, S400)
audit(1186164927.718:47): avc:  denied  { sys_nice } for  pid=1229 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
IOAPIC[0]: Set routing entry (2-17 -> 0x99 -> IRQ 17 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
ice1724: No matching model found for ID 0x581404a6
ice1724: Invalid EEPROM version 1
firewire_core: created new fw device fw1 (0 config rom retries, S400)
firewire_core: phy config: card 0, new root=ffc1, gap_count=5
audit(1186164928.218:48): avc:  denied  { sys_nice } for  pid=1184 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tcontext=system_u:system_r:insmod_t:s0-s0:c0.c1023 tclass=capability
audit(1186164928.218:49): avc:  denied  { sys_nice } for  pid=1300 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
loop: module loaded
audit(1186164928.717:50): avc:  denied  { sys_nice } for  pid=1322 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164928.717:51): avc:  denied  { sys_nice } for  pid=1326 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164928.717:52): avc:  denied  { sys_nice } for  pid=1331 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
lp: driver loaded but no devices found
audit(1186164928.717:53): avc:  denied  { sys_nice } for  pid=1326 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164928.717:54): avc:  denied  { sys_nice } for  pid=1352 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:55): avc:  denied  { sys_nice } for  pid=1356 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:56): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
No dock devices found.
audit(1186164929.217:57): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:58): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:59): avc:  denied  { sys_nice } for  pid=1361 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:60): avc:  denied  { sys_nice } for  pid=1374 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
audit(1186164929.217:61): avc:  denied  { sys_nice } for  pid=1381 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:62): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:63): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:64): avc:  denied  { sys_nice } for  pid=1394 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:65): avc:  denied  { sys_nice } for  pid=1404 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164929.217:66): avc:  denied  { sys_nice } for  pid=1404 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb3, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
audit(1186164930.717:67): avc:  denied  { sys_nice } for  pid=1443 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NTFS driver 2.1.28 [Flags: R/W MODULE].
audit(1186164930.717:68): avc:  denied  { sys_nice } for  pid=1448 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NTFS volume version 3.1.
SELinux: initialized (dev sda1, type ntfs), uses genfs_contexts
NTFS volume version 3.1.
SELinux: initialized (dev sdb1, type ntfs), uses genfs_contexts
audit(1186164930.717:69): avc:  denied  { sys_nice } for  pid=1453 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164930.717:70): avc:  denied  { sys_nice } for  pid=1453 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
SELinux: initialized (dev sdb2, type vfat), uses genfs_contexts
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
audit(1186164934.217:71): avc:  denied  { sys_nice } for  pid=1594 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
audit(1186164935.716:72): avc:  denied  { sys_nice } for  pid=1661 comm="modprobe" capability=23 scontext=system_u:system_r:insmod_t:s0 tcontext=system_u:system_r:insmod_t:s0 tclass=capability
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
audit(1186164944.715:73): audit_pid=2067 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
eth0: no IPv6 routers present
it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts

--Boundary_(ID_5icMzdbmSq6UTVy0NVuXqA)--
