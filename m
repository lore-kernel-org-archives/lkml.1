Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXC1Dfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXC1Dfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXC1Dfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:35:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXC1Dfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:35:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: tglx@linutronix.de
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi quirk
Date: Tue, 27 Mar 2007 23:28:34 -0400
User-Agent: KMail/1.9.5
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>, Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com> <1174486483.10840.89.camel@localhost.localdomain>
In-Reply-To: <1174486483.10840.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iDeCGSAXFHXIZFa"
Message-Id: <200703272328.34685.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_iDeCGSAXFHXIZFa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thomas,

Is this failure specific to NO_HZ, and that is why the "nolapic_timer" fix is i386 only?
I'm running 2.6.21-rc5 an nx6325 here in 64-bit mode and I don't see the dramatic
boot failure described earlier in this thread.

However, I have observed that when running on battery,
the LOC falls behind the irq0 timer to the tune of about
2 interrupt/minute.  eg. when i booted my machine, LOC was
behind irq0 by 50, and now about a 20 minutes later it is behind
irq0 by 99.  However, the LOC for each processor remain at
a constant offset with respect to each other.

I do not see these this drift when running on AC.
Yes, the system exports just C1 in both cases.

Other oddities is the IRQ name on irq0 is garbled:

lenb@nx6325:~> uname -a; cat /proc/interrupts; sleep 100; cat /proc/interrupts
Linux nx6325 2.6.21-rc5 #37 SMP Tue Mar 27 22:26:00 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
           CPU0       CPU1
  0:     723812          0    <NULL>-edge      timer
  1:        716          0   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:      30719          0   IO-APIC-edge      i8042
 14:      24318          0   IO-APIC-edge      ide0
 16:      18316          0   IO-APIC-fasteoi   libata
 19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:          1          0   IO-APIC-fasteoi   ohci1394
 21:       6736          0   IO-APIC-fasteoi   acpi
 23:      30358          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:     723675     723651
ERR:          0
           CPU0       CPU1
  0:     748812          0    <NULL>-edge      timer
  1:        716          0   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:      30719          0   IO-APIC-edge      i8042
 14:      25164          0   IO-APIC-edge      ide0
 16:      18361          0   IO-APIC-fasteoi   libata
 19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:          1          0   IO-APIC-fasteoi   ohci1394
 21:       6960          0   IO-APIC-fasteoi   acpi
 23:      31385          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:     748673     748649
ERR:          0
lenb@nx6325:~> bc -l
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
748812-723812
25000
748673-723675
24998
723812-723675
137
748812-748673
139
lenb@nx6325:~> 

Further, in dmesg:
ATI board detected. Disabling timer routing over 8254.

..MP-BIOS bug: 8254 timer not connected to IO-APIC

-Len



--Boundary-00=_iDeCGSAXFHXIZFa
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.21-rc5 (lenb@d975xbx2) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #37 SMP Tue Mar 27 22:26:00 EDT 2007
Command line: root=/dev/sda2 debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bfd0000 (usable)
 BIOS-e820: 000000001bfd0000 - 000000001bfe5600 (reserved)
 BIOS-e820: 000000001bfe5600 - 000000001bff8000 (ACPI NVS)
 BIOS-e820: 000000001bff8000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 114640) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7D30, 0024 (r2 HP    )
ACPI: XSDT 1BFE57B4, 0054 (r1 HP     0944      6070620 HP          1)
ACPI: FACP 1BFE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 1BFE58DC, EE7A (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 1BFF7E80, 0040
ACPI: APIC 1BFE5808, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 1BFE586C, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 1BFE58A8, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 1BFF4756, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 1BFF47AF, 0182 (r1 HP     PSSTBLID        1 HP          1)
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 000000001bfd0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 114640) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-000000001bfd0000
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   114640
On node 0 totalpages: 114543
  DMA zone: 56 pages used for memmap
  DMA zone: 1593 pages reserved
  DMA zone: 2350 pages, LIFO batch:0
  DMA32 zone: 1511 pages used for memmap
  DMA32 zone: 109033 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36992 bytes of per cpu data
Built 1 zonelists.  Total pages: 111383
Kernel command line: root=/dev/sda2 debug
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
Extended CMOS year: 2000
time.c: Detected 1596.295 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Checking aperture...
CPU 0: aperture @ 14b4000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 444360k/458560k available (3299k kernel code, 13812k reserved, 1848k data, 320k init)
Calibrating delay using timer specific routine.. 3197.82 BogoMIPS (lpj=6395653)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1153 Objects with 113 Devices 337 Methods 33 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 2 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Using local APIC timer interrupts.
result 12471066
Detected 12.471 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3192.24 BogoMIPS (lpj=6384480)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
migration_cost=141
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 11 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:..................................................................................................................................................................
Initialized 30/33 Regions 0/0 Fields 64/64 Buffers 68/78 Packages (1172 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.......
Executed 7 _INI methods requiring 2 _STA executions (examined 120 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [C074] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:14.1: trying to change BAR0 from 0000 to 01F0
0000:00:14.1: trying to change BAR1 from 0000 to 03F4
0000:00:14.1: trying to change BAR2 from 0000 to 0170
0000:00:14.1: trying to change BAR3 from 0000 to 0374
Boot video device is 0000:01:05.0
PCI: Transparent bridge - 0000:00:14.4
PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: Power Resource [C223] (off)
ACPI: Power Resource [C1FE] (off)
ACPI: Power Resource [C217] (on)
ACPI: Power Resource [C34B] (off)
ACPI: Power Resource [C34C] (off)
ACPI: Power Resource [C34D] (off)
ACPI: Power Resource [C34E] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x100000-0x1bffffff could not be reserved
pnp: 00:0a: ioport range 0x40b-0x40b has been reserved
pnp: 00:0a: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0a: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
pnp: 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
pnp: 00:0b: ioport range 0x8000-0x802f has been reserved
pnp: 00:0b: ioport range 0x8100-0x811f has been reserved
pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xcf000-0xcffff has been reserved
pnp: 00:0c: iomem range 0x1c000000-0x1fffffff could not be reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 20 (level, low) -> IRQ 20
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d0011000-d00117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: d0300000-d03fffff
  PREFETCH window: c0000000-c3ffffff
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: cc000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: c8000000-cbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c4000000-c40fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
Time: acpi_pm clocksource has been installed.
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 38000000-3bffffff
PCI: Bridge: 0000:00:14.4
  IO window: 1000-1fff
  MEM window: d0000000-d02fffff
  PREFETCH window: 30000000-33ffffff
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 393216 bytes)
TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
Allocate Port Service[0000:00:04.0:pcie03]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
Allocate Port Service[0000:00:05.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Allocate Port Service[0000:00:06.0:pcie03]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:04.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:05.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:06.0:pcie01 failed with error 2
ACPI: AC Adapter [C1BD] (off-line)
ACPI: Battery Slot [C1BF] (battery present)
ACPI: Battery Slot [C1BE] (battery absent)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [C25A]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [C25B]
ACPI: Processor [C000] (supports 8 throttling states)
ACPI: Processor [C001] (supports 8 throttling states)
ACPI: Thermal Zone [TZ1] (66 C)
ACPI: Thermal Zone [TZ2] (53 C)
ACPI: Thermal Zone [TZ3] (26 C)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.74 (February 20, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:30:e4:ee
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[0] TSOcap[1] 
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller at PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: chipset revision 128
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047, BIOS settings: hda:DMA, hdb:pio
ATIIXP: simplex device: DMA disabled
ide1: ATIIXP Bus-Master DMA disabled (BIOS)
Probing IDE interface ide0...
hda: TSSTcorpCDW/DVD TS-L462C, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 1536kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
sata_sil 0000:00:12.0: version 2.1
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
ata1: SATA max UDMA/100 cmd 0xffffc20000036080 ctl 0xffffc2000003608a bmdma 0xffffc20000036000 irq 16
ata2: SATA max UDMA/100 cmd 0xffffc200000360c0 ctl 0xffffc200000360ca bmdma 0xffffc20000036008 irq 16
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHT2040BH, 0000104A, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2040B 0000 PQ: 0 ANSI: 5
SCSI device sda: 78140160 512-byte hdwr sectors (40008 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 78140160 512-byte hdwr sectors (40008 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0403000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0401000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0402000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
usb 3-1: new full speed USB device using ohci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Intel 810 + AC97 Audio, version 1.01, 22:52:57 Mar 25 2007
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Turion(tm) 64 X2 Mobile Technology TL-50 processors (version 2.00.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0x8
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
synaptics reset failed
synaptics reset failed
synaptics reset failed
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 320k freed
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:07 failed with error -16
Adding 674688k swap on /dev/sda1.  Priority:-1 extents:1 across:674688k
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

--Boundary-00=_iDeCGSAXFHXIZFa--
