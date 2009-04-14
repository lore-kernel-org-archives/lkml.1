Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZDNVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZDNVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZDNVG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:06:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49472 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZDNVGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:06:25 -0400
Message-ID: <49E4FAC6.1030400@garzik.org>
Date: Tue, 14 Apr 2009 17:06:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: USB storage no-boot regression (bisected)
Content-Type: multipart/mixed;
 boundary="------------020003030909000501080907"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020003030909000501080907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Once of the x86-64 machines I use for testing runs off of two 2GB USB 
flash drives, one for Fedora 10 userland, and one for kernel repository 
+ builds.

It boots correctly in 2.6.27, but fails with the same symptoms in 
2.6.28, 2.6.29 and 2.6.30-rc1:

	1) The kernel boots
	2) After time passes, kernel begins executing initramfs
	   userland
	3) the kernel prints out probe messages for the USB keyboard,
	   SCSI probe messages for the two USB flash drives

Or IOW, the keyboard and two SCSI drives appear after initramfs begins 
booting.  And this is for drivers built into the kernel (though same 
behavior with modules).

This no-boot regression is 100% reproducible, and neatly bisects down to

> commit 8520f38099ccfdac2147a0852f84ee7a8ee5e197
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Mon Sep 22 14:44:26 2008 -0400
> 
>     USB: change hub initialization sleeps to delayed_work
>     
>     This patch (as1137) changes the hub_activate() routine, replacing the
>     power-power-up and debounce delays with delayed_work calls.  The idea
>     is that on systems where the USB stack is compiled into the kernel
>     rather than built as modules, these delays will no longer block the
>     boot thread.  At least 100 ms is saved for each root hub, which can
>     add up to a significant savings in total boot time.
>     
>     Arjan van de Ven was very pleased to see that this shaved 700 ms off
>     his computer's boot time.  Since his total boot time is on the order
>     of two seconds, the improvement is considerable.
>     
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     Tested-by: Arjan van de Ven <arjan@infradead.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


My preliminary guess is that this made things --too-- asynchronous, and 
for some reason userland begins executing before the SCSI core 
initializes the USB storage as Linux block devices.

In any case, I cannot boot because of the above commit :)

	Jeff





--------------020003030909000501080907
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express Integrated Graphics Controller
00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit Network Connection (rev 01)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 01)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 01)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 01)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 91)
00:1f.0 ISA bridge: Intel Corporation Device 2910 (rev 01)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 01)
00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem
02:00.0 SATA controller: Marvell Technology Group Ltd. 88SE6145 SATA II PCI-E controller (rev a1)
04:00.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev 20)

--------------020003030909000501080907
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.27-bisect-05355-g3c4bb71 (jgarzik@localhost.localdomain) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #14 SMP Tue Apr 14 16:55:03 EDT 2009
Command line: ro root=UUID=622e4b9b-68fd-4683-8a02-269fbce2263e nogui
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f5b0000 (usable)
 BIOS-e820: 000000003f5b0000 - 000000003f5be000 (ACPI data)
 BIOS-e820: 000000003f5be000 - 000000003f5f0000 (ACPI NVS)
 BIOS-e820: 000000003f5f0000 - 000000003f600000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x3f5b0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 003f400000 page 2M
 003f400000 - 003f5b0000 page 4k
kernel direct mapping tables up to 3f5b0000 @ 8000-b000
last_map_addr: 3f5b0000 end: 3f5b0000
RAMDISK: 37c94000 - 37fef67b
ACPI: RSDP 000F94A0, 0024 (r2 ACPIAM)
ACPI: XSDT 3F5B0100, 0054 (r1 A M I  OEMXSDT  11000628 MSFT       97)
ACPI: FACP 3F5B0290, 00F4 (r3 A M I  OEMFACP  11000628 MSFT       97)
ACPI: DSDT 3F5B0440, 5B7A (r1 VVBLI9 VVBLI926       26 INTL 20051117)
ACPI: FACS 3F5BE000, 0040
ACPI: APIC 3F5B0390, 006C (r1 A M I  OEMAPIC  11000628 MSFT       97)
ACPI: MCFG 3F5B0400, 003C (r1 A M I  OEMMCFG  11000628 MSFT       97)
ACPI: OEMB 3F5BE040, 0065 (r1 A M I  AMI_OEM  11000628 MSFT       97)
ACPI: GSCI 3F5BE0B0, 2024 (r1 A M I  GMCHSCI  11000628 MSFT       97)
ACPI: DMAR 3F5B6060, 00D0 (r1 A M I  OEMDMAR         1 MSFT       97)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 003f5b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000694f54]    TEXT DATA BSS ==> [0000200000 - 0000694f54]
  #3 [0037c94000 - 0037fef67b]          RAMDISK ==> [0037c94000 - 0037fef67b]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff8800000ff780] 000ff780
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff880001200000-ffff880001ffffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003f5b0
On node 0 totalpages: 259407
  DMA zone: 2669 pages, LIFO batch:0
  DMA32 zone: 251916 pages, LIFO batch:31
BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 2 hotplug CPUs
Allocating PCI resources starting at 40000000 (gap: 3f600000:bf800000)
PERCPU: Allocating 43168 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 254585
Kernel command line: ro root=UUID=622e4b9b-68fd-4683-8a02-269fbce2263e nogui
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2660.399 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Memory: 1012740k/1038016k available (2686k kernel code, 24304k reserved, 1177k data, 344k init)
Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.79 BogoMIPS (lpj=10641596)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU            @ 2.66GHz stepping 09
APIC timer calibration result 20784438
Detected 20.784 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5320.82 BogoMIPS (lpj=10641651)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU            @ 2.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (10641.62 BogoMIPS).
net_namespace: 888 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [ffa80000, ffafffff]
PCI: 0000:00:02.0 reg 14 io port: [ec00, ec07]
PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [ff900000, ff9fffff]
PCI: 0000:00:19.0 reg 10 32bit mmio: [ffa40000, ffa5ffff]
PCI: 0000:00:19.0 reg 14 32bit mmio: [ffa7a000, ffa7afff]
PCI: 0000:00:19.0 reg 18 io port: [e000, e01f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
PCI: 0000:00:1a.1 reg 20 io port: [d880, d89f]
PCI: 0000:00:1a.2 reg 20 io port: [d800, d81f]
PCI: 0000:00:1a.7 reg 10 32bit mmio: [ffa7b400, ffa7b7ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [d480, d49f]
PCI: 0000:00:1d.1 reg 20 io port: [d400, d41f]
PCI: 0000:00:1d.2 reg 20 io port: [d080, d09f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [ffa7b000, ffa7b3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [e880, e887]
PCI: 0000:00:1f.2 reg 14 io port: [e800, e803]
PCI: 0000:00:1f.2 reg 18 io port: [e480, e487]
PCI: 0000:00:1f.2 reg 1c io port: [e400, e403]
PCI: 0000:00:1f.2 reg 20 io port: [e080, e09f]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [ffa7b800, ffa7bfff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 10 64bit mmio: [ffa79c00, ffa79cff]
PCI: 0000:00:1f.3 reg 20 io port: [400, 41f]
PCI: 0000:00:1f.6 reg 10 64bit mmio: [ffa78000, ffa78fff]
PCI: 0000:02:00.0 reg 10 io port: [bc00, bc07]
PCI: 0000:02:00.0 reg 14 io port: [b880, b883]
PCI: 0000:02:00.0 reg 18 io port: [b800, b807]
PCI: 0000:02:00.0 reg 1c io port: [b480, b483]
PCI: 0000:02:00.0 reg 20 io port: [b400, b40f]
PCI: 0000:02:00.0 reg 24 32bit mmio: [ff5ffc00, ff5fffff]
PCI: 0000:02:00.0 reg 30 32bit mmio: [ff580000, ff5bffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: PME# supported from D0 D1 D3hot
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:1c.3 io port: [b000, bfff]
PCI: bridge 0000:00:1c.3 32bit mmio: [ff500000, ff5fffff]
PCI: 0000:04:00.0 reg 10 io port: [c800, c8ff]
PCI: 0000:04:00.0 reg 14 32bit mmio: [ff6ffc00, ff6ffcff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [ff680000, ff6bffff]
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [c000, cfff]
PCI: bridge 0000:00:1e.0 32bit mmio: [ff600000, ff6fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 12 14 *15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 12 *14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 12 14 15)
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
DMAR:Host address width 40
DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
DMAR:RMRR base: 0x000000003f600000 end: 0x000000003fffffff
PCI-GART: No AMD northbridge found.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:07: ioport range 0xa20-0xa3f has been reserved
system 00:07: ioport range 0xa00-0xa0f has been reserved
system 00:07: ioport range 0xa10-0xa1f has been reserved
system 00:07: ioport range 0xa40-0xa5f has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x800-0x87f has been reserved
system 00:08: ioport range 0x480-0x4bf has been reserved
system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0a: iomem range 0xffc00000-0xffefffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x3f5fffff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.3:   IO window: 0xb000-0xbfff
pci 0000:00:1c.3:   MEM window: 0xff500000-0xff5fffff
pci 0000:00:1c.3:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.5:   IO window: disabled
pci 0000:00:1c.5:   MEM window: disabled
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xff600000-0xff6fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000040000000-0x000000400fffff
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [0, 0]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [b000, bfff]
bus: 02 index 1 mmio: [ff500000, ff5fffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [0, 0]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [c000, cfff]
bus: 04 index 1 mmio: [ff600000, ff6fffff]
bus: 04 index 2 mmio: [40000000, 400fffff]
bus: 04 index 3 io port: [0, ffff]
bus: 04 index 4 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3437k freed
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
audit: initializing netlink socket (disabled)
type=2000 audit(1239742653.463:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 1985
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
pci_express 0000:00:1c.5:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT 3F5B6130, 097D (r1    AMI   CPU1PM        1 INTL 20051117)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Warning (tbutils-0217): Incorrect checksum in table [SSDT] - E4, should be 0B [20080609]
ACPI: SSDT 3F5B6AB0, 097D (r1    AMI   CPU2PM        1 INTL 20051117)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU2] (supports 8 throttling states)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel G33 Chipset
agpgart-intel 0000:00:00.0: detected 6140K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
Driver 'sd' needs updating - please use bus_type methods
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 19, io mem 0xffa7b400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffa7b000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000dc00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 3
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=090c, idProduct=1000
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: DISK 2.0
usb 1-3: Manufacturer: USB
usb 1-3: SerialNumber: 0Z0AYREUHJUQN3GH
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: configuration #1 chosen from 1 choice
usb 1-4: New USB device found, idVendor=0930, idProduct=6545
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB Flash Memory
usb 1-4: Manufacturer:         
usb 1-4: SerialNumber: 5B861C0001B7
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000d800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d400
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: New USB device found, idVendor=045e, idProduct=000b
usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Microsoft Natural Keyboard Elite
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000d080
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.27-bisect-05355-g3c4bb71 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Clocksource tsc unstable (delta = 9371902387 ns)
i8042.c: Can't read CTR while initializing i8042.
i8042: probe of i8042 failed with error -5
mice: PS/2 mouse device common for all mice
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     USB      DISK 2.0         0403 PQ: 0 ANSI: 0 CCS
scsi 1:0:0:0: Direct-Access              USB Flash Memory PMAP PQ: 0 ANSI: 0 CCS
sd 0:0:0:0: [sda] 3981312 512-byte hardware sectors: (2.03GB/1.89GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 1:0:0:0: [sdb] 3921920 512-byte hardware sectors: (2.00GB/1.87GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 23 00 00 00
sd 1:0:0:0: [sdb] Assuming drive cache: write through
sd 0:0:0:0: [sda] 3981312 512-byte hardware sectors: (2.03GB/1.89GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI removable disk
usb-storage: device scan complete
sd 1:0:0:0: [sdb] 3921920 512-byte hardware sectors: (2.00GB/1.87GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 23 00 00 00
sd 1:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI removable disk
usb-storage: device scan complete
input: PC Speaker as /devices/platform/pcspkr/input/input2
cpuidle: using governor ladder
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
input: Microsoft Natural Keyboard Elite as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
generic-usb 0003:045E:000B.0001: input,hidraw0: USB HID v1.10 Keyboard [Microsoft Natural Keyboard Elite] on usb-0000:00:1a.0-1/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Freeing unused kernel memory: 344k freed
Write protecting the kernel read-only data: 3564k
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 127 started
libata version 3.00 loaded.
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pata_marvell 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pata_marvell 0000:02:00.0: setting latency timer to 64
scsi2 : pata_marvell
scsi3 : pata_marvell
ata1: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
ata2: PATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
BAR5:00:04 01:7F 02:22 03:C8 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:1F 0D:00 0E:00 0F:00 
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports ? Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit stag pm led clo pmp pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
scsi9 : ahci
ata3: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7b900 irq 508
ata4: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7b980 irq 508
ata5: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7ba00 irq 508
ata6: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7ba80 irq 508
ata7: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7bb00 irq 508
ata8: SATA max UDMA/133 abar m2048@0xffa7b800 port 0xffa7bb80 irq 508
Linux Tulip driver version 1.1.15 (Feb 27, 2007)
tulip 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
tulip0:  MII transceiver #1 config 3000 status 7829 advertising 01e1.
eth0: Lite-On 82c168 PNIC rev 32 at MMIO 0xff6ffc00, 00:a0:cc:60:b5:f4, IRQ 21.
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
platform microcode: firmware: requesting intel-ucode/06-0f-09
platform microcode: firmware: requesting intel-ucode/06-0f-09
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
eth0: Setting full-duplex based on MII#1 link partner capability of cde1.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.

--------------020003030909000501080907
Content-Type: application/x-gzip;
 name="config.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.txt.gz"

H4sICEL55EkCA2NvbmZpZy50eHQAlDxtc9s2k9/7KzjpzVw700ssWVbszvgDBIISKoJAAFAv
+YJxbaX1xbZ8ltwm//4WoESBJEDn6UxjC7sAFsC+78o///Rzgl7328eb/f3tzcPD9+SvzdPm
5Wa/uUseb75uktvt05f7v35P7rZP/71PNnf3e5iR3z+9fku+bl6eNg/JP5uX3f326fdk+H78
fvgRwPp1k6Dnl2QwSgbj3y9Gv58Pk+HZ2dVPP/+EeZHRqRmPJlRffwfcw8DqcmwA636XPG33
yW6z/8kDjEeAevp8+oAknpmUZNXH63c3L7d/f/h2Of5QUb2zv8Nsc7f5Uo28O86ckoJIio2m
jJzWO45ixpUpRYq0B8Q5x3PFS4mJWSKNZymfBqZaLLIghVa9QDORHKUYKX1Cs9CUCKNKIbj0
AEojPNcSwc4d2AwtiMmB0gKvNQ9MzmAPOJFY4ZnbAuUnGGPl6cNnXhCTMtSlmyoUAXCGRHd4
UgZuZrYkdDrTrddjaF0dQWCTpfgElUtFWD1ZCVrY6/F5psKwx0JpalA+5ZLqGQswkdtphpTB
ojQ0ze0DUh14H5TTiYS7BKbK0bqLYNnFLNRaAWbeOslxfQlTVyEYwjN4KQqXrOhn0npBRXQp
jCDSrYEkQS0EGGZIzQ3PHEbj3qs96ITIAmnKCyO4UnSSkxaKKpUgRRoAH9/+fNiaIrgoLXcp
U/CUtLYtU6odWmcfx4PKcAE3BodNDTwfLWgR4gskUyo/BcQFRo2QfBKQUHsMWM2iNHSDUUw0
B0D8O2M+F9rPEwryLsmE8xYAZI4Jbt/MZ7y5YwPLA0gGuK1WSPDYIN7vPjzc//nhcXv3+rDZ
ffivskAwGZiEIEU+vD/qJdCNPydTp3sf7GKvzydtSVbAF7BloX3ZteJg5vDkxBuEO9aGFAt4
B7s9Ay4/H3ozUL4gUgGLXL97FxqGN9XcUzxL/72B7xdU4M6A/Ym1RwXwF10Z9qkkpfd2E5Xa
58REKYMwbuj/Nswszv2brfE0iABoQ61CUm7ZscWdXVF1PKslabwonVe/BFbNOVBXZkbNaKav
Bx9Pk/BU8lKEKHECWxZAKAgZMMoMBAAf1NeRke3cCuSraipbkJO20z4ksGmpQHl0puHIpBoB
bihTwLNCEgxynprFMIhn1do6sK1lZyXANCl/2xKEv1DBhSzDREDuCBGYoGkLdGSdfA7kLxzr
y7QpCiC+cLjKaFuOP10LrnWTybh0Gjmwds3Y9UTCJiRNww9A08G4IRww13Q4cA6f1Jo1rus4
BlYsD56+RiArOJQRSAX5jmuR+7ZXSFpoj+sahpnkYEq49CRUYCXm0ghQ+HAprMFHnAmkwWuZ
h54AVJnJSv+UWamJbwUL0C3UmhBPzxNQrd4URacFyjPvCa2elf6A8538ATVjhHnbUE95LViF
D7SXhQb95k3L0cQ/ncrLSVg6ch4GgLLKKBiGaRDKkATNHFUNvJrdNCrO0kWnkCyjmNrTgAHJ
4aZAUkFRgr5s+QkUXhSstCWw7SUetmiPSqKDAGfKndc549xjIpDSk1/GhJmRXFS3Wx/GzT/i
gFsBTzAjEqgPyRi8BS0y7+FA1THLPk2Vommxrt47xoGKWUE7q51bnpZ5c41qyEo8uNI5OOCB
pQ44ZWHh0ckVOPz4PD1YUxWD23WUxLXRbUr9kSMA0Y8BwLln4ENWzkit/FpOca0NefV0PQpz
oqb+QkctqskU/Oh1a4+DAoBR56lQnqjbvzfWp3nZnTwV8KOcsSs49/yG4yhS3bGUoDRvHOkI
wZnn2oFPhcpcV0vUhz2OHhcJXvcRCdbrhVuaw96cAx/IgiDzCULl++eb/fbl+7tTcAgaGXhd
4vJ4ReJle7vZ7bYvyf778ya5ebpLvmxu9q8vG+/CNIWrBd9bzXjDHyq4mX0O6QIIocAUq0o1
vhViljT3OajtBmcUYgErwYf4uQFkQiCpSHPQOX+NoB28giJ4rRa44Gs0JTIKPxBtFU18DSAw
rIGRRAtq3aKSKB2WNMJ0FHZ+OQ4DRjHARQ9AKxyFMbYKw8axBSG80bRklL4B7oezXugoDJ1H
SJp/jIxfhsexLBUnkWexxozwMOOwJS1Aywk87gWfR5TvlICTMV0NeqAmj7wHXku6it7qgiJ8
boZxYOSGRJM16s3AUA99capFWJSRRBhAmvKYDw5phckaGP16PPKBVpVLF7XHcQ55ociqVcwz
9mFLYZZcziG0nzcn2d1y58FjLtZNmPUYBPgYBhbFc1WyllYZg75r6SaQp+bAgdJWLtCm6hYt
xQWOPyuZy5JkiNF83TpzSsANBtecKell9wBbQaDkjtEdRiztDmIbkZeyyk82lFYa9OME0ZXe
9uwao54OR9LamSopd/K8UQ6AdQUIchgQ14XWETzlOp/45hUQDz7babRweSd1fVnPczZYMT8L
6YYY9sMLQpiwprOZIDmOL3gOnjcQH3GhHVaE111WwiBBW3wAjk13kGHSGaifsvEyFgD3FY5M
L0PBDaNYcgxidP3YGerucQK1dunAeZ5WIpqhDvU+Zx4En6btzNxsDfFimkqju/n0omQolghV
zrCDbTz6Nu3sXQ0nBQokEUlOsLa2lQNXgo/qy0sYWJOVQWRpF2aoKFE40k2pgt80nYbxjvvU
NFYoHgVHSCuaOZAETKdAbAP4LrQmfjngBFrAPzaoal9IB6PBCtWOh6A8cAgBzhHcyNRF9aRI
/VSQEjnVRujK97aiWeswOIFLaKj62Y/rBTiild+1LzC9HtSuPUTGPvM5f0pz8BxVW3Cc6q4y
pWC5ZClsojnqtdlblrYwwZdASlCstPSY3H4yChVU088kOn64/5pvzyJo9llsjtXptSPyoGFy
UENcSEZDTEawjXoage1nMzg7Cyn3z2Z4cdZCPW+itlYJL3MNyzQ17kzaKKGRK4DYOOxuYonU
zKQlC4Uylj+o1aoKdDLc3rfhmf2vkeMDreuyln3TXf7hNL2ZfDo4Ke3E0SJVPEwxc6EbsCLP
Yxrr8OxNgarjrO2/m5fk8ebp5q/N4+Zpn2yf9/fbJy/IEo1MlmCVBxA6ITMqJ7YC54dKx1FP
OKs6SmfAZGDSKv49vfWpLBM6HhaeA2A/1XudzLsdtcnxLJxP8OBG8CWRkX0OqV6H0trTzq6S
ZS0Awh1KJkiD0VrHNpmUWvOitUyG2iNpK29xWDq67KE4wNuUN7nOh+gZkQzlnU2WjMavEcFL
xqGag0c8QXEEXCrNgb9UqqP3kyM8t4UhsyZIXp+1VoixpgOS7msIbDmGR7cLvTbwgSZtH5y1
XdPqQGCKEYin7GysJo2LcqJoI5fsZfN/r5un2+/J7vbm4f7pr5McOo9ckk9NT9qOGH2wqye1
cITELqRGsOWg4EwLgOlAfx5+U2+PKscz5QtbgrW5b1Rg8h9MsreswM348Sk2UnJ1k76z+RM4
OAhAVhq5pRMiwKzxBZWz6F28ddrguv/B4X74UG8epu8QRz6zbJY81ym2u5f7fxqZSMvTFQcD
ruW5x6aD4g5VgHcSyV+4WrIgJAVRqSI9SQseRRWjKvMGHm+H2t3fNy+bO88sNWb6RFZ6GIKC
7Adoyukkcsu2w6EpY67nwV5rDu6hE2ZHxuR1dyQr+QU0SbLZ377/1TOcmPrFIdBOVBKsm2OM
tdOHDpMz0BvKj3SRbH4y02xllqg1mOVciHU1forM4PqNq2uErDamxLYbtJzWo2Ww1FiUyEzU
1G1uSIloF0nd2sBU626qAX8hk5MpwpHgF8d1/Uw3+xoO7Tc27vXKiJemmDQ3xEim8arg4TWD
95OheVi6fSTLqW8iYctGbyGpmcAdMSHfNrev+5s/HzbJl3v7z/bl8Wa/Sz4k5PH14abl09mS
EdO2hulx+qFG6YOaJSnEy5ClPMxg1E86UXQ+NITZ7hfqHJoTN1pIZKm6TNKkydaYy/Gocp1Z
MwA9NFG0ZxakrrYUm/2/25evYEwDzi24E4D52PxsWKNTpyzoqpEeAIw5CTlbtNq2rtUbuAAI
P6o+Na+GD3HmwlqN1Ei4iKDPCUgZndjep1lrrihCcmyJooIKX1VXY1NJIq0Ehrntwx6ZFLGW
hwJum88piXQo2F3RLA4jSsSB8Jac9cBXmQRfqywKkkfu/wD17+E00+ZUbGmvUFYPvbFNhdzZ
K4Y5IUTHaMol93srYCSlaNoa0lgch091W+wKTNOaYwI71Di4nPi5vaNbc4Rfv7t9/fP+9l1z
dZZeqGDvDhWL8Uky7CfbEbEAndxkSBivuNimh7IIqwFS1TKitC1qR4q/9hrGfcwz7uWecS/7
WBoYFeOe6W9z1zjCXuP/iL/GP85g4x4OiyK69zi06MSCZ3cfiurWExc2hejaFfVa+IVlCwyc
3d2q1XICnCQXiKie64/rGziBLY3YtJHt/4jhZDTXkZoo6LMU49jjG4V1GAakh9NBSIdrgBNJ
02n0FBC/hmPcRY4Kc3k2HMQq6biIPG+e42HkWKsI5SgPX+FqeBHeAolwqw6BnxGylnCerv1q
3EWnc863yMl+s9tXMW5jkpjrKQlnR2eISZTSSDIsUkynMg2/yCR8LpQZuZIRphCz+H1Q25iq
wvwvszmNtKfZM1+Jzi2lm3/ubzdJWgdnpy7X+9vDcMLbHk1ZdW1VJSqbqZ1dv/uw+/P+6cPf
2/3zw+upix8i/CJFebf65BbIqGRLmwh2fRAB/ZEtXQ9QMwCoZ9Hi0F0bmFl14R1RG52Fzqk3
KZiZCFMdEMhCRvQMOIRmBppLLqji4TXgRwGBWATKdBrrmGjr9COkaGQc4WM3ODk2tey3t9sH
3wEtRDOLeWglCnUlZWHCLBiLTybG5Acwpkr14dgdUoSvxme9KGWrhayDgPnSeuMsaHSOSLlt
cXoMTJZroXneaibqoBWTtBeuVpf9h5j00CYR63Z2wWDVCXk9GIdg7ksJg/H55ai724qGT4NT
yZnVdjhdpDE9bvjClm70rPdAs3C1FCw5QGmrvZhOmEGKRdQbKjQPBfCECEvu1Tlejf2nU1Nq
KMejiG3NmGuTDcsqL9bW8ujIc+sZLeYCpfHgueqbgJAw58uw+SpwzlUp7XdEpLuJMCVwiFWY
iJkwNOfRWVNZxrpOadpsk0+7uTiFFU3uKkW/e31+3r7sfWsoEYXDax1shrVz/f4CRQ9fMzrR
Z8f0NGytHBBMTw53HFm9yqhl6hhJO2oPZFZ9eb/c3e++/pbsb543vyU4/R/gEC8DVotjM1M5
k9VomK4jmCule6RUyZPjehozYLtSv8xRbzb1ebYebbbOVYfcPm78d9klv2ze//UeTpf87+vX
zZ/bb7/Wd/D4+rC/f37YJHlZNHKT7vacW2wAFLtem6YFI+x/2c2N53w6rb7t01xQgYcDkrsu
cGxF+80shwanPT2Zfrl52lmCuzQqW7ZpM1gTJcNvYVD37xtICqkfQcnpBH704EjRKxG2aJ6D
C9MoXVUEatxvVc6XZgX/OamLEwBYV4AVR0DtTGILjHD/Bojij/0bVAi2B6Yf6eqNVa5GfQip
0IYOec8KNiUB/lYPhsRMRdwsMkVOvRVkGfP2a5yeVHCN08s1M9twIeLwSalA6CjuuQ22Oh9c
DXpunIC17pGiUlsrVGX242jTNGLpK0ETfVJoGzh4LxwNIj0Vlb5a9EueJj3cotbs4hxfAlsO
++iXceAn9wJmMLw860OCyAH3w520x1Fy0bdAis+vLr71w896LGrH8++or565s1DhRCPfdFmX
sKjsRhquWFiMZkyh7JDwuzLcCJph2vDk7KCi+XAUWVVljaJAhb9YRrAFpavO8mwRPr47Vhgm
UjBAKUPxiZ9ULJirTg5eCVUkjqBWox4gzfuAKg4scxoHLijqA2qi+igGWcaD8XAViVQPHNAD
zfuALO0Bypi3XoE1vHoPHLN0PDozsTrXCafnaFhdXAzP+uHnffC17WNUcQSSIRmNxw6N5vHZ
YGvOx+N++MdVP3w1LN5AOI/Dqb4cDlZvwHvm/+HabHsI0JJmedMY+GCGJPhfjTRxNW41QnxV
cGf6ESBYwSSSQ6sQaPEHOh/2IKjLj6PB2VsIFz1EgiPRD41pKodgdVnMbXMINrsZc6kqhM/t
5scmXOHBsBduO0ul+xZCL5nDs2Efk4JWHF/2bUN7lo/pPgdc0mLCi7TvhGEPKaK1slK1CiDV
d/AIIcng/GqU/JLdv2yW8P+vXgheFdWfXEF9+/TwHf6BX74k+783yf7fbbLb39x+3f2WvD49
bHa75Pv2Nfn6tP03+ffvm737dPOySe62rex2RiWxWeJwLgMocgQFgRFHnCFMC9tZd0iaqnBp
OJAFSkvGwi61vf74d3PxIvalNfKpBLvyOZK51WV41iKW23L1g0mU2yG2iCXixWwd7u9x5Wfb
2ljV6b3vHUTaLpAQa0YizfaqLKaRZCi2X2gsaPRcVZrCnONgqq2qYudUNL+uORycjUJKt0J9
bHy03/TyvgpeDTH3BW/vRexogSKOQkpGq4tIocOJqLkchZ8mZVeDs7Aahi0vhuNVJNMWC09s
xhLiREOA/czn2Gs1sOT0h9B0rNjsI9l/Rm+jFdz2Xy0N1jJ/G5uh3OBcGmoF2HZb/uAUl1o3
RMoI47QalYSVkohNBEfvcjAYRLPLKEVCE+w63rOY2pqMwlfjvumdxpZ22eTYc5MYIANRLMLM
UyCtCItJ3HAedTkvQedGEkMWpHlY8crxWYT7wfRdxQ4mwG2PheAlBHSxvlkd07lgSo2cxb69
rfDV8Ox8EPFl82FMP9lsWFTxevAwgpYda2vNqzOUcA7fIC5tTRy8cVsWD5O5PFbNw2C6zJc0
s82CabejulSTutaM7m6e91Ud1fuLKRPQ1BpH/pzKxMzRMsbAFizINNrybuFS55eDi7MoHP7v
qa2HJSBNI6aKiljAJyIphzxSl7JaJJIisS44LxTPo+0P9q+SRFe1QNcVL+GXWBuHSot45b3r
xz09v+67JZS6PiRKvyPPfjRZZr8Mkzf++kcFsfTZ4usheV7uNi8P9k8P3D8B63y5ufX/+EA1
g/FSkVa9tgkxQqFyFWwnaqApLAkpzOoaTOeoH2d9/XF82d7vD74GlOg+ZBGkkixCherqUjsN
CI2Zc7KecOT/zaDjCKiW+SRtfuXqAAElN4/UbmucfP4mykq/iQJGU0di2BM1mi/REq37H8f7
Ph1338VWw8CQQblQoXGb1YSfQoSAag3ul6Y4PJNm9q+qzUMw++dJ5oLTounHnuC8xLM5jfz1
BocGkSCNeLYVAji/OXEL9SBNMLu4+jjqwVio1WqFUKR+e2Dd/2/sypoUx5HwXyH2ZXcjdqKx
jcHsxjzIB+AGH23JFNUvBF3FbBFTV1DVMdv/fpWSDZKtlHmYqUb5WbdSUioPUAtcWyBCs4zZ
AFBPuT7w4dRVlOWSF16b+guDb4+E7kOG+eFqQCko1heITlsX5FpQfFLSEhSqhrITthcZsWLu
+Tmp86zbQUSZM55b6LX402MMq8P58S+42qZfilH7ongx+KxUB1Li5z4NxhO3m8j/33jZvG5G
ghCxwI1miIBGQvgxjs9vo70pkPm9T67PzmcVMesHLEmWdNV65BHh6XA+PHC23z4DXxu61TTU
xW4odT6lsruylresBSj21HdK2vUcxxQCqNSjN3DOxteYDo5c0tj7gOIf53uhH5XlW/HxfDo8
962BmlwDaaLbT+y3cZHu9gmpNvf8916zJlc/0wxkNEJemgl5ta9JxRRzbpVa1bnwLWmBKKbi
3U4T9Izk93thooLMsBZIV0LLTRiaGHPiNx+w5ecI20jJeusKo1JF8u31NyDyFDEoQt2gd7xp
ctH90CmJppnWkL9Sk+QBTB3mwb5k95qsSL6/imREDzVL9ys+47BDHZ/bfIHEhXna5tuKmCmV
N5+a9xbYnNIIyTC7wwzuyiiYedP/7Zcl8lTKGYVB/1BxQqKs5PJqKqKIjPKltPYXFqHmC1LE
/yvNVWfJRtjCGZ1pbXXnxKkbKdrbbrQXxxrdHRwkR+AlVhxrlcRGQ7RxWSqPfW505fBg3taR
h5bRiGaQ/vT28QnOrT/Pb8/PR9WAUBFYRvDK5Piejwg0G/rUs9N3FnoWz/ypjQziDdNxgFP5
zuRomuyQhsmWgQiPExOUmgt5h4vSaUp9f+7b6FPk0aohzxGxGZAxiXpDK6uif8bng/3x6+Pz
+DL6wYe0GcLRP1742D7/Gh1ffhwfH4+Poy8N6jfOkR6eTu//7I5yAZyGWmqescRksMb31lfO
2Tjmi5xVB3lFx2ZTo4DLt/jliqHFMVJQfqvJcAB4QgTJQLdGy/Ph/en0cK0H1CyOo9HD0+EV
fLUj9doWRVwUXi+/4vOpyUQ2T+nlXtMicvEbinckq/uVzk4fD8dnfkk9vvHsYUwjPkYmXcKY
OtMAkQMyF3kAT/j2UdFG99MKKaNF4CP3AEnzB74nc9+bD5cxd6yYjOymwUBZjG5c38cXm1Qy
R9VWrxBwmz4ACWs6VM4KkcPQMsUMae9IzsRrY5HzvRw2M37w1dyhySSzbMnEEsW1QhjobjT7
LjXdotxSxqTvPuMqI5ZeL/gcdGdTo+eWu0x1eyF+csYVa/ojzeiRMGX1sq5q6xhfUJ4dFs8m
zmQYEgxA+HXKdW7A+Ddgpjdg5sMYb7A+cxcTYV8wbDaZ3YKx9/I6YAlilnfJRjz12SFsV9rb
BDxuYBhSf80PBqEVs5g5wdhfDGICd7EcAPnezKd2DNhIVUOQshjOBXkAbyHLje8ENBvCuGPj
zaBFAFeEwTStzJQFM2v2m2zqDQAGWDcHDBUxCwYAwXgI4Fk6gJN9U+N5+lDN5kMFz90hgDe0
+TlTZz64QU798cBGC7ekYczEtTfZdui9rNkscWbeQD4ZjSazzLkJNNCJEhZ689kAW6OzwLVP
JbbKooGe5IfvaTAldgxzsOetKyRwB/j5XeDNAicexMxvwbg3YLwhyGYW+IzegJrmyyHU1J2t
FjeAkgHUKialvUpC6k2zCJFjwMHEfG67GC21nrP0hMsZR3njk3GQDCYor3APoafnE79kj8LD
w5/vcMRXBD/w+niNQ3NthOFek4GRyh8/Xx/AUrR9KTNcRLJFjJ95gUgzf2yegysG1zOaRuY5
UUehMxmP7bmzDJHIAPEuCybI6aAhe/4YztTm1r8cH08HRZDbpTy8nY32V/wEmhT7zrPa9Ua1
DfEmyU+zJE6JtU79cYiJ5W7aEwGSpRpTaCmc7apufiGp52cVEjENPaBh4oQYuZ5ulwQ0WGw9
UdRMvDvIx1/z23aIXB7A5Ru/8+83Udy6EOpbS58++Br5ZTGmi1PK79j3aA7R2+vH2zNfGm1O
0sK61+O8sUYJ/pKAtJsWC7DAggduqLhJjAeKd0bJbFHnRhdEaWyIXJbGuqPEGPeIlMYVuWuF
fCD6UN93VdtxzlVWqqtcyLVUExqEfEqWvOr9+AACap7afzmA77ueeSCNTFiixr0SacB39aQw
2azTvJNW6XHQRBGcw1b33bSU/+omSs1vPTFO1DgqkJJ8XyedL5f3VevJSEmFt129JW3KXjeV
gOSqzji3LknsciIyzELzGqaQXg7fOPj9uVunkuSwt2yKSpsKSjJeUJkwsrnPd3qOlGSg1NhJ
7HUjx5SbmqpbXFVTlnEmkFSdln9PqgLA5qrAfOpNbUi8BH5bRTFCKVbq+5FGSrokLboSR2JL
ReSS58Kxr9C7uyrOGsRtsJR6LqVk9vDVgvaLhXQZ7wLVCorvc8LnAbhiL4z6vLLTWieq2rcF
W6L5ZgYtaGjBCoT50VWYH/e3JKEoNZ3t+B7OxwOpEnR6f7hEalUUbL+qwz1j3RoLOmPQ2XiY
LQBy7u040123Aj3MbDq2Yoqmmkgr6msrtM/oJnAca8ZVQPjFaj7rgi4d3ejTRM+HD6MkWEy+
KMPVzSrh8Ryl38X4tyzrH43ygiX/HonGsaIiy2R0FArvH8Jq+F8i6MrfpSX06ePPdiP8e3t+
euF75OH542304zh6PR4fj4//4XkftQxXx+d38EU3eoET1ulVuqXjC0ZfLw281+cy2bpaLxjC
yIKE+uRrieBZmO9DZmJKY3c8NtPiMkK+4v8mzEyicVyN5zjN9820r3VWNqFsDFSyIXVMzDRw
SQP6L2bqmlQZ8mGzIYJhU9Tpu00a1lQ6h7+eG14O/wU/eteTtM5h4igY4+qOYnNjydq4OMQD
N7Io+ppKl890hox8n2Tp1EWrxamIyFUsyLhm9Q4l02RLE5znVmnhW3pkkywLhkrNBcLCcEI4
9YjHXcQblSwCz6Ad/eh+FiGCOQkTV1icL63AHxbDuXIsFMFQ+oLFKR4KSQwCnA2b8zs+FCnf
FEN+DMf7Au8K0N+J+O4MAWwLfDjS4o5UfFBxBBoySe5PcHhd3KGAJUF7MkNEElmS4cpzcITp
qkYrnqjBKXgappuU3SO6YIs0T0OCmGMlMTF5oqhYBNzjqm4ACeLM0yrWVqBzbdCpBSA48JXO
1tWYdk06OCQxJHdUW9X0fZ0mwhGpWduDI+Nq2xu1yws51NTAVdrvYup445k1a4Ag76IKZDpz
rRCQ2mJWBS2mon7kDeST0o3jjgMrZscRvhUhHmIRjqFhAjsmmzgssDeKer43HxMrZpF5jq47
Ia+mZdoZP6nF8nz4hHPI0NhCHPOhYXORGGQKxEdEuyrE94Ygs4l9XClbOzNGgoHuDthAhQHi
+YMQf26FhN8mwdhe4a03dvtD9vb6G7jB10fm6uC6cxsDU9u4fxSRTqHSgjDMFrfG/GQwsuzo
XYqMF6fzi1CK6unCJ7H2Rs1/7gvjTffiGa8f6gYEEPsqNL9nx1EcEtMtMM5SXQQkndyk4YKJ
2ISGRjwfG10etQE75u5VXtsk7HfgZaefLKNTk2jTJ9Ekqpvgl9cOaXMzyso51YPCXzoJhsI9
vHDPUvhkvzB13tcwvhbKv85CEbNN20SSlJ87F3SPBA752iNdszPUEyLWiqjjHcdOO7yE5YK6
GA3ilbjm8mN+r0sX96qiuzlBBBxQ6/KtLhAXNqAliFdUUicYeQFWAMaqtkH7ZE/JNSyciH0B
j3gwYa/zVZnnxXzKL/lIaXW86JAkryjolwVhX3KG5ZtRjsFy3S7AD7mZxk8a1FRk+XH8+fgm
/LH3lt3Vs5qasO5ElIa0Xnh4SITgVyDQSZnq7KxzamJZ2ftpmpqrmp85N6GKbZJEOXo8Ivhj
bq5+FfvD3MkktkyjBU5bWUlSwGgmhwn+aYiTLF9FIjC6eZpYljOEVtyh6zmzNLDEad/y3QSn
VrZswXU+uogw5ta6aQZ2JiPhKLMmF19dGSv83nqa63yRAtPPlDcQJx24SU4HbFTh3+Kn/FLJ
SRpKq1Gm8qpU9KXl7/1S3EpUK1xIrZJlKoTZW5MvJI7g2w18ul9XoaYNopBouc6QN/IsROdW
ijGZqES/KWKCrykzazqcP0/iPZj9etdPTyWpGDgSy20u5yWvvECVnt9Q7cclgNzffn7+EfxN
pUAcR8HHJt5MG3SVhmmG6CBEaUgDBYimRgfk3gK6qbgbKh5Mb6nT1LkFdEvFkStbBzS5BXRL
FyBekDqg+TBo7t2Q0/yWAZ57N/TTfHJDnYIZ3k/8iBIE/nwfDGfjuLdUm6NMSruAITRKU33N
tcU73WXVEtzBmnuDiOHW+4OI6SBiNoiYDyKc4cY4w61x8OasizTYV3ZyjQxfzRaBdhncZD1u
vT6ewf7g6fDwpxYSDoyAhRGajIN6fUhVvLnzy7A0RTJdv2RkSH4tBZ2mskoiwtQwqm3kyJoy
GcFUuc7wM5D88nd3PLkEPs4IuHDkBwPdMK7OwYAdfESGBRJOTupUYSegBBzNU1kJo2UUfCwd
zus3a0inq44V3oUqTPTguR2OELV2KQ+LgvH9DVx7X+jwtJ6aJJ44eL8lmzpRAxXKsKQ2N5Er
iFFGEM05YVW2x+myyUX4lTfNhqAbElrIFePDzpJdgonAJFkITq2u+mmZ5l17tg7EVpBEiDi+
ZMP/ILGwi+3lcm0ObwEZoE529JrKGKIDtUkhJA8Eckw2C+gDW+3XcjTQecv/2yZVWNCkP3fB
mM+SNWLn1BDTiqGBogXirgJlFXBrj1auCRsLzmX7tYNInLYeNQ+G5B3CeQFmLwL6Ag3vihPs
0aeK6j2//wq/uuizC4BEyHnG50+z5IsKVTSTLBVGFc+yGTUxV5IdRMncmoEy/FKaw+hj8Z43
nOXm0X3Hqeb1isbv/uIP1L7Dg4WT+YWocSexVSG5EK9VEilImJRvnHst5K5SYVdGvtbsEMHe
LADQAIReo3cpi1Y2JCzrFGK9r6IUHOOJMH4wEc2j0rT5Mm1QBkuyshOlSItyB0pE62Ws6QzB
b0RiXKWRmAIdm3wl6mSzuMWsrhVtTWEh39RXE1sq6fs4XNp4EZ/W0RpCRCywCAgKbl9TgjwV
SxScNXE222D49gMLKsMUqUVET4ZE0W52lwLUNZRIZSIy5n4ZQgVon89I/NCKzHc4Ii2yrLZM
CvCN11sal28lE9pDRKz9eBeMr7HTuzR+fHLMtFr8+3fXTM0hDI/Xo4nCVBn/lYC8618QNc44
L5i841GpEzhOq6J6holKYunLJvAYBAHa8OVqeE+hx4ef59PnL1NYV3CEgijoSwm/Oda8IOka
d22qlL1HpCTiqTs1rn0ZeeYihT7/ev98k3rhb+fR0/H5/XhWaynhPOcSzwzMQ7Woo20yP832
EsPNOkrLlRpDuqE0ISD1xErV0mzSMpLz5aNJ9BvKcuG4AfYG3mDyemOliz+xDUFqtkryyAYx
vrOTn59Px9fP08Ph8/g4Sl4foPNBNvXX6fNpRD4+3h5OghQfPg+GQYgQnbm28XYyTb6l216d
wue3hz9HL2+PqnpCW14YGfo4YpW1+5hloiRRaMhxU93Zcix5PWz0HaMG/z0fT0irVhmJelNq
J9vaaNj/9/jxaer/KvLcyD53ACEfZm24LJ7gnZTFvqGT+Ja/IhADKLXWoMpiB7HmUhCIOO6K
cBF3E1eE547xJtAVcQxt4MkDGXOE77jWlbWsMMu3BnFXdrKQQ3l6f9JetC9MihoYFxW7+3Ri
aATJ6zClVv5QIV5ULyywuFukdGWdSfzqsNkg5ikXDGX+EGCKj1KsH0FaVi/+2rJdr8h3YuWQ
lGwoccc3QJp+tjOuxF5YUpVJzuzs2NqR7K4YGo8GYqhuY1Pz8n4+fnxoGr+Xbl7A5cfE+L73
3ZVUh9fHt5dR/vPlx/EsoyC2isT9mQixlcoKkQW0/O4OuwGst5lm2COv0YZIqqLszenH+XD+
NTq//fw8vR61KNsMgilWqgvB9sUbNDRAJ4RCxG2G0HO4J4X6xZuzUr7hpcwYPruKnKm6aqM9
c8ZxutDTUsbvzVqS53aKMItdN2nY5/WtnQcngrSiGVI19TrQ7cUO5AbqlZXC+Vx1EyaTOhZP
hDYBzv4P3OFd1HijAAA=
--------------020003030909000501080907--
