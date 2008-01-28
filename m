Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYA1LUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYA1LUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYA1LUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:20:08 -0500
Received: from qult.net ([82.238.217.46]:46263 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYA1LUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:20:02 -0500
Date: Mon, 28 Jan 2008 12:19:53 +0100
From: Ignacy Gawedzki <lkml@qult.net>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hot (un)plugging of a SATA drive with sata_nv (CK8S)?
Message-ID: <20080128111953.GA833@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	Robert Hancock <hancockr@shaw.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fa.PdKzY9gi8w+fleyC/mVql2UDhtc@ifi.uio.no> <479AA2E6.8070307@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <479AA2E6.8070307@shaw.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2008 at 09:03:02PM -0600, thus spake Robert Hancock:
> Ignacy Gawedzki wrote:
>> Hi everyone,
>> I'm having trouble to determine the cause of the following behavior.  I'm 
>> not
>> even sure that I'm supposed to hot plug and unplug a SATA drive from a 
>> nForce3
>> Ultra (apparently CK8S, on a Gigabyte K8NS Ultra 939 mobo) SATA interface, 
>> to
>> begin with.  The information is hard to find given that the sata_nv driver
>> supports a range of different hardware.
>> I've recently acquired an external drive with (among others) an eSATA
>> interface, so I also bought a eSATA->SATA bracket and intend to use that 
>> drive
>> (Lacie d2 quadra 500G) through eSATA.
>
> BTW, eSATA cannot technically be converted properly to SATA with a simple 
> connector adapter. eSATA is supposed to use higher signalling voltages and 
> so using such an adapter is not guaranteed to work.

Yeah, apparently this shortens the max cable length to 1 meter.  In this case
I've got a 1 meter external cable and approx. 30 cm internal (heavily shielded
though) cable from the bracket to the SATA port.  Anyway, the drive works
perfectly if plugged at boot time.

>
>> The thing is that if I boot the machine with the drive plugged and turned 
>> on,
>> it is properly detected and usable.  If, at some point, I want to remove 
>> the
>> drive, I unmount any partitions on it and issue the proper scsiadd -r 
>> command
>> (usually scsiadd -r 1 0 0 0, since this is the second SATA drive) and
>> everything is fine (I turn the drive off and unplug it), so far.  Next, 
>> when
>> I want to use the drive again, it's still detected alright (although 
>> appears
>> as sdc and not sdb anymore), but the SCSI layer issues "scsi 1:0:0:0:
>> rejecting I/O to dead device" from time to time.  Then any scsiadd -r 1 0 
>> 0 0
>> command fails with "No such device or address", although it appears in the
>> output of scsiadd -p or even scsiadd -s (always as 1 0 0 0).  If I ignore 
>> that
>> detail and switch the drive off, then the kernel eventually notices that 
>> the
>> drive is gone and the SCSI layer attempts to stop the device and fails 
>> ([sdc]
>> START_STOP FAILED).  From that moment on, any attempt to plug the drive 
>> again
>> fails.  The kernel issues "ata2: hard resetting port" and "ata2: port is 
>> slow
>> to respond, please be patient (Status 0x80)" periodically, until I switch 
>> the
>> drive off.
>> If the drive is not present at boot, then hot plugging it fails.  The 
>> kernel
>> first soft resets the port, then issues the "please be patient (Status 
>> 0x80)"
>> message, complains that SRST failed (errno=-16) and goes on hard resetting 
>> the
>> port, issuing "please be patient (Status 0x80)" and complaining that 
>> COMRESET
>> failed (errno=-16), periodically, until the drive is switched off.
>
> Full dmesg output would be useful..

I repeated the experiments and dumped as much dmesg as I could.

The dmesg outputs of both experiments are attached and commented.  It seems
that in the case the drive is pluggin at boot time, it remains hot pluggable
later (be it with some strange error messages) after all (or is there another
factor that I did not reproduce?).

Thank you for any help. =)

-- 
NO CARRIER

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sata-hotplug.log"

### First experiment, the drive is plugged and turned on at boot time.
### The initial full dmesg dump follows.

Linux version 2.6.23.14 (root@zenon) (gcc version 4.1.3 20070929 (prerelease) (U
buntu 4.1.2-16ubuntu2)) #1 PREEMPT Thu Jan 24 22:07:54 CET 2008
Command line: root=UUID=84d4c1b4-5602-4364-a583-7913d518b4ab ro quiet splash
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524272) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F6C90, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 7FFF0000, 0040
ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524272) 1 entries of 256 used
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
  DMA zone: 1312 pages reserved
  DMA zone: 2631 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 513065 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
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
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 515696
Kernel command line: root=UUID=84d4c1b4-5602-4364-a583-7913d518b4ab ro quiet spl
ash
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2009.788 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ e0000000 size 128 MB
Memory: 2055416k/2097088k available (2879k kernel code, 40836k reserved, 1503k d
ata, 208k init)
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 4020.73 BogoMIPS (lpj=2010367)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12561193
Detected 12.561 MHz APIC timer.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: AGP aperture is 128M @ 0xe0000000
Time: tsc clocksource has been installed.
pnp: 00:00: ioport range 0x1000-0x107f has been reserved
pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
pnp: 00:00: ioport range 0x1400-0x147f has been reserved
pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
pnp: 00:00: ioport range 0x1800-0x187f has been reserved
pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
pnp: 00:01: iomem range 0xd4600-0xd7fff has been reserved
pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f0000000-f1ffffff
  PREFETCH window: e8000000-efffffff
PCI: Bridge: 0000:00:0e.0
  IO window: 9000-afff
  MEM window: f2000000-f3ffffff
  PREFETCH window: f4000000-f4ffffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 3761k freed
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
floppy0: no floppy controllers found
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
skge 1.11 addr 0xf3000000 irq 19 chip Yukon-Lite rev 9
skge eth0: addr 00:0f:ea:81:c5:48
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:05.0 to 64
eth1: forcedeth.c: subsystem: 01458:e000 bound to 0000:00:05.0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: PIONEER DVD-RW DVR-111, ATAPI CD/DVD-ROM drive
hda: selected mode 0x44
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: ST3200822A, ATA DISK drive
hdc: selected mode 0x45
ide1 at 0x170-0x177,0x376 on irq 15
SiI680: IDE controller at PCI slot 0000:02:06.0
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
SiI680: chipset revision 2
SiI680: BASE CLOCK == 133
SiI680: 100% native mode on irq 18
    ide2: MMIO-DMA , BIOS settings: hde:pio, hdf:pio
    ide3: MMIO-DMA , BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: ST3120026A, ATA DISK drive
hde: selected mode 0x45
ide2 at 0xffffc20000028080-0xffffc20000028087,0xffffc2000002808a on irq 18
Probing IDE interface ide3...
hdg: ST3300831A, ATA DISK drive
hdg: selected mode 0x45
ide3 at 0xffffc200000280c0-0xffffc200000280c7,0xffffc200000280ca on irq 18
hdc: max request size: 512KiB
hdc: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, UDMA(100)
hdc: cache flushes supported
 hdc: hdc1
hde: max request size: 64KiB
hde: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=16383/255/63, UDMA(100)
hde: cache flushes supported
 hde: hde1
hdg: max request size: 64KiB
hdg: 586072368 sectors (300069 MB) w/8192KiB Cache, CHS=36481/255/63, UDMA(100)
hdg: cache flushes supported
 hdg: hdg1
hda: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2000kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APSJ] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x00000000000109f0 ctl 0x0000000000010bf2 bmdma 0x000000000001dc00 irq 21
ata2: SATA max UDMA/133 cmd 0x0000000000010970 ctl 0x0000000000010b72 bmdma 0x000000000001dc08 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 < sdb5 sdb6 >
sd 1:0:0:0: [sdb] Attached SCSI disk
ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[f3008000-f30087ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
usbmon: debugfs is not available
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 20, io mem 0xf5004000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf5002000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [APCG] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 21, io mem 0xf5003000
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
usb 1-5: configuration #1 chosen from 1 choice
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
usb 1-5.2: new high speed USB device using ehci_hcd and address 3
usb 1-5.2: configuration #1 chosen from 1 choice
hub 1-5.2:1.0: USB hub found
hub 1-5.2:1.0: 4 ports detected
usb 1-5.2.2: new low speed USB device using ehci_hcd and address 4
usb 1-5.2.2: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.2-5.2.2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (1 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Freeing unused kernel memory: 208k freed
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000fea5600727443]
fuse init (API version 7.8)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
skge eth0: enabling interface
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
input: PC Speaker as /class/input/input4
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
bttv0: Bt878 (rev 17) at 0000:02:08.0, irq: 16, latency: 32, mmio: 0xf4000000
bttv0: detected: Pinnacle PCTV [card=39], PCI subsystem ID is 11bd:0012
bttv0: using: Pinnacle PCTV Studio/Rave [card=39,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffbff [init]
bttv0: i2c: checking for MSP34xx @ 0x80... found
bttv0: pinnacle/mt: id=2 info="PAL+SECAM / stereo" radio=yes
bttv0: tuner type=33
bttv0: i2c: checking for MSP34xx @ 0x80... found
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
nvidia: module license 'NVIDIA' taints kernel.
msp3400 2-0040: MSP3410G-B11 found @ 0x80 (bt878 #0 [sw])
msp3400 2-0040: MSP3410G-B11 supports nicam and radio, mode is autodetect and autoselect
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tuner 2-004b: chip found @ 0x96 (bt878 #0 [sw])
tda9887 2-004b: tda988[5/6/7] found @ 0x4b (tuner)
tuner 2-0060: Chip ID is not zero. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (bt878 #0 [sw])
tuner 2-0060: microtune: companycode=3cbf part=42 rev=22
tuner 2-0060: microtune MT2050 found, OK
tuner 2-0060: microtune: companycode=3cbf part=42 rev=22
tuner 2-0060: microtune MT2050 found, OK
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC5] -> GSI 16 (level, low) -> IRQ 16
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.07  Thu Dec 13 18:34:01 PST 2007
it87: Found IT8712F chip at 0x290, revision 5
Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: Using r5 hash to sort names
ReiserFS: dm-1: found reiserfs format "3.6" with standard journal
ReiserFS: dm-1: using ordered data mode
ReiserFS: dm-1: journal params: device dm-1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-1: checking transaction log (dm-1)
ReiserFS: dm-1: Using r5 hash to sort names
loop: module loaded
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Marking TSC unstable due to cpufreq changes
Time: acpi_pm clocksource has been installed.
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
lp0: using parport0 (interrupt-driven).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present

### Then suppose I want to unplug the drive, si I issue scsiadd -r 1 0 0 0
### first.

sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
ata2.00: disabled

### Then I switch the drive off.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### And everything is well, I can unplug the drive.  Now I plug the drive in
### again and switch it on.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x1d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 < sdc5 sdc6 >
sd 1:0:0:0: [sdc] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### Apart from the last four lines, the drive is accessible.  Then suppose I
### want to unplug the drive again.  So I issue a scsiadd -r 1 0 0 0, but this
### time, it spits a "No such device or address", so I simply switch the drive
### off.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: limiting SATA link speed to 1.5 Gbps
ata2.00: limiting speed to UDMA/133:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 310)
ata2.00: disabled
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
ata2.00: detaching (SCSI 1:0:0:0)
sd 1:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
sd 1:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdc] START_STOP FAILED
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### Which produces some errors, quite expectedly.  Then I plug the drive in
### again and switch it on.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x1d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 < sdc5 sdc6 >
sd 1:0:0:0: [sdc] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### And then off again.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: limiting SATA link speed to 1.5 Gbps
ata2.00: limiting speed to UDMA/133:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 310)
ata2.00: disabled
ata2: EH complete
ata2.00: detaching (SCSI 1:0:0:0)
sd 1:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
sd 1:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdc] START_STOP FAILED
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### And on

ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x1d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 < sdc5 sdc6 >
sd 1:0:0:0: [sdc] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### And off.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: limiting SATA link speed to 1.5 Gbps
ata2.00: limiting speed to UDMA/133:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 310)
ata2.00: disabled
ata2: EH complete
ata2.00: detaching (SCSI 1:0:0:0)
sd 1:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
sd 1:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdc] START_STOP FAILED
sd 1:0:0:0: [sdc] Result: hostbyte=0x04 driverbyte=0x00
scsi 1:0:0:0: rejecting I/O to dead device
scsi 1:0:0:0: rejecting I/O to dead device

### Then the last two steps are repeated and the dmesg are the same.

### Now the second experiment, I boot with the drive unplugged.
### The initial full dmesg dump follows.

Linux version 2.6.23.14 (root@zenon) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 PREEMPT Thu Jan 24 22:07:54 CET 2008
Command line: root=UUID=84d4c1b4-5602-4364-a583-7913d518b4ab ro quiet splash
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524272) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F6C90, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 7FFF0000, 0040
ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524272) 1 entries of 256 used
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
  DMA zone: 1312 pages reserved
  DMA zone: 2631 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 513065 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
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
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 515696
Kernel command line: root=UUID=84d4c1b4-5602-4364-a583-7913d518b4ab ro quiet splash
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2009.814 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ e0000000 size 128 MB
Memory: 2055416k/2097088k available (2879k kernel code, 40836k reserved, 1503k data, 208k init)
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 4020.73 BogoMIPS (lpj=2010365)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12561356
Detected 12.561 MHz APIC timer.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: AGP aperture is 128M @ 0xe0000000
Time: tsc clocksource has been installed.
pnp: 00:00: ioport range 0x1000-0x107f has been reserved
pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
pnp: 00:00: ioport range 0x1400-0x147f has been reserved
pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
pnp: 00:00: ioport range 0x1800-0x187f has been reserved
pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
pnp: 00:01: iomem range 0xd4600-0xd7fff has been reserved
pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f0000000-f1ffffff
  PREFETCH window: e8000000-efffffff
PCI: Bridge: 0000:00:0e.0
  IO window: 9000-afff
  MEM window: f2000000-f3ffffff
  PREFETCH window: f4000000-f4ffffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 3761k freed
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
floppy0: no floppy controllers found
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
skge 1.11 addr 0xf3000000 irq 19 chip Yukon-Lite rev 9
skge eth0: addr 00:0f:ea:81:c5:48
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:05.0 to 64
eth1: forcedeth.c: subsystem: 01458:e000 bound to 0000:00:05.0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: PIONEER DVD-RW DVR-111, ATAPI CD/DVD-ROM drive
hda: selected mode 0x44
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: ST3200822A, ATA DISK drive
hdc: selected mode 0x45
ide1 at 0x170-0x177,0x376 on irq 15
SiI680: IDE controller at PCI slot 0000:02:06.0
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
SiI680: chipset revision 2
SiI680: BASE CLOCK == 133
SiI680: 100% native mode on irq 18
    ide2: MMIO-DMA , BIOS settings: hde:pio, hdf:pio
    ide3: MMIO-DMA , BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: ST3120026A, ATA DISK drive
hde: selected mode 0x45
ide2 at 0xffffc20000028080-0xffffc20000028087,0xffffc2000002808a on irq 18
Probing IDE interface ide3...
hdg: ST3300831A, ATA DISK drive
hdg: selected mode 0x45
ide3 at 0xffffc200000280c0-0xffffc200000280c7,0xffffc200000280ca on irq 18
hdc: max request size: 512KiB
hdc: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, UDMA(100)
hdc: cache flushes supported
 hdc: hdc1
hde: max request size: 64KiB
hde: 234375000 sectors (120000 MB) w/8192KiB Cache, CHS=16383/255/63, UDMA(100)
hde: cache flushes supported
 hde: hde1
hdg: max request size: 64KiB
hdg: 586072368 sectors (300069 MB) w/8192KiB Cache, CHS=36481/255/63, UDMA(100)
hdg: cache flushes supported
 hdg: hdg1
hda: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2000kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APSJ] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x00000000000109f0 ctl 0x0000000000010bf2 bmdma 0x000000000001dc00 irq 21
ata2: SATA max UDMA/133 cmd 0x0000000000010970 ctl 0x0000000000010b72 bmdma 0x000000000001dc08 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[f3008000-f30087ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
usbmon: debugfs is not available
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 20, io mem 0xf5004000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf5002000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [APCG] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 21, io mem 0xf5003000
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
usb 1-5: configuration #1 chosen from 1 choice
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
usb 1-5.2: new high speed USB device using ehci_hcd and address 3
usb 1-5.2: configuration #1 chosen from 1 choice
hub 1-5.2:1.0: USB hub found
hub 1-5.2:1.0: 4 ports detected
usb 1-5.2.2: new low speed USB device using ehci_hcd and address 4
usb 1-5.2.2: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.2-5.2.2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (1 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Freeing unused kernel memory: 208k freed
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000fea5600727443]
fuse init (API version 7.8)
sd 0:0:0:0: Attached scsi generic sg0 type 0
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
skge eth0: enabling interface
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
bttv0: Bt878 (rev 17) at 0000:02:08.0, irq: 16, latency: 32, mmio: 0xf4000000
bttv0: detected: Pinnacle PCTV [card=39], PCI subsystem ID is 11bd:0012
bttv0: using: Pinnacle PCTV Studio/Rave [card=39,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffbff [init]
bttv0: i2c: checking for MSP34xx @ 0x80... found
bttv0: pinnacle/mt: id=2 info="PAL+SECAM / stereo" radio=yes
bttv0: tuner type=33
bttv0: i2c: checking for MSP34xx @ 0x80... found
input: PC Speaker as /class/input/input4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
msp3400 2-0040: MSP3410G-B11 found @ 0x80 (bt878 #0 [sw])
msp3400 2-0040: MSP3410G-B11 supports nicam and radio, mode is autodetect and autoselect
nvidia: module license 'NVIDIA' taints kernel.
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tuner 2-004b: chip found @ 0x96 (bt878 #0 [sw])
tda9887 2-004b: tda988[5/6/7] found @ 0x4b (tuner)
tuner 2-0060: Chip ID is not zero. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (bt878 #0 [sw])
tuner 2-0060: microtune: companycode=3cbf part=42 rev=22
tuner 2-0060: microtune MT2050 found, OK
tuner 2-0060: microtune: companycode=3cbf part=42 rev=22
tuner 2-0060: microtune MT2050 found, OK
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC5] -> GSI 16 (level, low) -> IRQ 16
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.07  Thu Dec 13 18:34:01 PST 2007
it87: Found IT8712F chip at 0x290, revision 5
Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: Using r5 hash to sort names
ReiserFS: dm-1: found reiserfs format "3.6" with standard journal
ReiserFS: dm-1: using ordered data mode
ReiserFS: dm-1: journal params: device dm-1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-1: checking transaction log (dm-1)
ReiserFS: dm-1: Using r5 hash to sort names
loop: module loaded
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
Marking TSC unstable due to cpufreq changes
Time: acpi_pm clocksource has been installed.
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
lp0: using parport0 (interrupt-driven).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present

### Then I plug the drive and switch it on.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x1d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: SRST failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=3)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=2)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=1)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after 5 tries, giving up
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH pending after completion, repeating EH (cnt=3)
ata2: EH complete

### ... and so on.
--GvXjxJ+pjyke8COw--
