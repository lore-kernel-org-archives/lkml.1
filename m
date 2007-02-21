Return-Path: <linux-kernel-owner+w=401wt.eu-S1750756AbXBUXDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756AbXBUXDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXBUXDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:03:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:23815 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXBUXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:03:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CDyRDs0wvAoNFEW8VJXLy/0rBGsirjM87e9Kwb7lFjHu4XOUadtb5FCLwLe79fnO8ApK3h2mdjBO2GsDeSKMXxn8YZVK4MbmzLDk+I7VikEfVJsmZKvSx147dmOwssAwuY0RQXA/YPdknc00icDwvlHFrz0hqGlrnlSxx+RE4y4=
Date: Thu, 22 Feb 2007 00:04:09 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
Message-ID: <20070221230409.GA1158@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> ha scritto:
> Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.
> 
> There's a lot of changes, as is usual for an -rc1 thing, but at least so 
> far it would seem that 2.6.20 has been a good base, and I don't think we 
> have anything *really* scary here.
> 
> The most interesting core change may be the dyntick/nohz one, where timer 
> ticks will only happen when needed. It's been brewing for a _loong_ time, 
> but it's in the standard kernel now as an option. 

Hi Thomas,
I'm testing NO_HZ on my machines. On the laptop I see that the timer
interrupt counter is incremented (though slower than HZ). This machine
is running UP kernel.

On my desktop I see this:

           CPU0       CPU1       
  0:        114          0   IO-APIC-edge      timer
  1:       1624      10771   IO-APIC-edge      i8042
  6:          3          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:      40111     184047   IO-APIC-edge      i8042
 16:      75624     998858   IO-APIC-fasteoi   radeon@pci:0000:01:00.0, uhci_hcd:usb1
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 18:        711       5487   IO-APIC-fasteoi   ide1, libata, ehci_hcd:usb7, uhci_hcd:usb3
 19:        617       2254   IO-APIC-fasteoi   libata, uhci_hcd:usb2
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb6, uhci_hcd:usb5
 21:    2483869          0   IO-APIC-fasteoi   eth0
 22:          2          0   IO-APIC-fasteoi   ohci1394
218:      28872     360643   PCI-MSI-edge      HDA Intel
219:      32932     138196   PCI-MSI-edge      libata
NMI:          0          0 
LOC:    2761191    2827539 
ERR:          0
MIS:          0

Interrupt 0 is stuck at 114 (the number is consistent across reboots). I
don't experience any problem, time is running fine. Still it's strange
that the timer is doing nothing; maybe something other than the PIT is
used for time keeping?

This is the dmesg of the "abnormal" machine (dual core, SMP kernel):

Linux version 2.6.20-ge696268a-dirty (kronos@dreamland.darkstar.lan) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #33 SMP PREEMPT Tue Feb 20 23:24:24 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009c800 end: 000000000009c800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009c800 size: 0000000000003800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe90000 end: 000000003ff90000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff90000 size: 000000000000e000 end: 000000003ff9e000 type: 3
copy_e820_map() start: 000000003ff9e000 size: 0000000000042000 end: 000000003ffe0000 type: 4
copy_e820_map() start: 000000003ffe0000 size: 0000000000020000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
 BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff90000 (usable)
 BIOS-e820: 000000003ff90000 - 000000003ff9e000 (ACPI data)
 BIOS-e820: 000000003ff9e000 - 000000003ffe0000 (ACPI NVS)
 BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1023MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 262032) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   262032
early_node_map[1] active PFN ranges
    0:        0 ->   262032
On node 0 totalpages: 262032
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 2015 pages used for memmap
  Normal zone: 255921 pages, LIFO batch:31
DMI 2.4 present.
ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
ACPI: XSDT 3FF90100, 0054 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: FACP 3FF90290, 00F4 (r3 MSTEST OEMFACP  12000611 MSFT       97)
ACPI: DSDT 3FF905C0, 8F8C (r1  A0637 A0637000        0 INTL 20060113)
ACPI: FACS 3FF9E000, 0040
ACPI: APIC 3FF90390, 006C (r1 MSTEST OEMAPIC  12000611 MSFT       97)
ACPI: MCFG 3FF90400, 003C (r1 MSTEST OEMMCFG  12000611 MSFT       97)
ACPI: SLIC 3FF90440, 0176 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: OEMB 3FF9E040, 007B (r1 MSTEST AMI_OEM  12000611 MSFT       97)
ACPI: HPET 3FF99550, 0038 (r1 MSTEST OEMHPET  12000611 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
Detected 2135.184 MHz processor.
Built 1 zonelists.  Total pages: 259985
Kernel command line: BOOT_IMAGE=linux-2.6.20g ro video=radeonfb:1024x768-8@60 lapic apic=verbose root=/dev/mapper/main_vol-root
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=b042f000 soft=b042d000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1096 kB
 per task-struct memory footprint: 1200 bytes
------------------------
| Locking API testsuite:
[cut, everything is ok]
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029640k/1048128k available (2028k kernel code, 17904k reserved, 985k data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xf0800000 - 0xfffb5000   ( 247 MB)
    lowmem  : 0xb0000000 - 0xeff90000   (1023 MB)
      .init : 0xb03f6000 - 0xb0428000   ( 200 kB)
      .data : 0xb02fb094 - 0xb03f1814   ( 985 kB)
      .text : 0xb0100000 - 0xb02fb094   (2028 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 4273.73 BogoMIPS (lpj=8547462)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1008 Objects with 75 Devices 286 Methods 36 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
enabled ExtINT on CPU#0
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=b0430000 soft=b042e000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4270.09 BogoMIPS (lpj=8540188)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
Total of 2 processors activated (8543.82 BogoMIPS).
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1667977
... PM timer delta = 357949
... PM timer result ok
..... delta 1667977
..... mult: 71634589
..... calibration result: 1067505
..... CPU clock speed is 2135.0043 MHz.
..... host bus clock speed is 266.3505 MHz.
... verify APIC timer
... jiffies delta = 25
... PM timer delta = 357949
... PM timer result ok
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=21
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 11 Wake, Enabled 2 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................................................................................................................................................................................................
Initialized 35/36 Regions 44/44 Fields 51/51 Buffers 99/100 Packages (1017 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 1 _STA executions (examined 81 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:05:01.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 17 devices
SCSI subsystem initialized
libata version 2.10 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    31
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  1    0    0   0   0    1    1    49
 05 003 03  0    0    0   0   0    1    1    51
 06 003 03  1    0    0   0   0    1    1    59
 07 003 03  1    0    0   0   0    1    1    61
 08 003 03  1    0    0   0   0    1    1    69
 09 003 03  0    1    0   0   0    1    1    71
 0a 003 03  0    0    0   0   0    1    1    79
 0b 003 03  0    0    0   0   0    1    1    81
 0c 003 03  1    0    0   0   0    1    1    89
 0d 003 03  1    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  0    0    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
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
PCI: Cannot allocate resource region 2 of device 0000:02:00.0
PCI: Cannot allocate resource region 3 of device 0000:02:00.0
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: 00:08: ioport range 0x290-0x297 has been reserved
pnp: 00:09: iomem range 0xffafe000-0xffb0cbff has been reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:10: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:10: iomem range 0xc0000-0xcffff could not be reserved
pnp: 00:10: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:10: iomem range 0x100000-0x3fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 7000-9fff
  MEM window: ff200000-ff2fffff
  PREFETCH window: bfd00000-dfcfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfd00000-dfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: ff400000-ff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: a000-afff
  MEM window: ff300000-ff3fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-cfff
  MEM window: ff500000-ff9fffff
  PREFETCH window: dfe00000-dfefffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2718k freed
Machine check exception polling timer started.
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
radeonfb_pci_register BEGIN
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
radeonfb (0000:01:00.0): Found 131072k of DDR 256 bits wide videoram
radeonfb (0000:01:00.0): mapped 16384k videoram
radeonfb: Found Intel x86 BIOS ROM Image
Retrieved PLL infos from ATOM BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=540.00 Mhz, System=520.00 MHz
PLL min 20000 max 50000
TMDS PLL from BIOS: 16500 b011c
index 3 port 2 conn 2 dac -1 ddc 0 tmds 0
index 4 port 2 conn 2 dac 1 ddc 0 tmds -1
index 7 port 1 conn 2 dac -1 ddc 1 tmds 1
Starting monitor auto detection...
i2c_adapter i2c-1: unable to read EDID block.
i2c_adapter i2c-1: unable to read EDID block.
i2c_adapter i2c-1: unable to read EDID block.
radeonfb: I2C (port 1) ... not found
radeonfb: I2C (port 0) ... found CRT display
 * Connector 1 is DVI-I. Head -1, Monitor: None 
   ddc port: 1, dac: -1, tmds: 1
 * Connector 2 is DVI-I. Head 0, Monitor: CRT (EDID probed)
   ddc port: 0, dac: 1, tmds: 0
hStart = 1048, hEnd = 1184, hTotal = 1344
vStart = 771, vEnd = 777, vTotal = 806
h_total_disp = 0x7f00a7	   hsync_strt_wid = 0x910422
v_total_disp = 0x2ff0325	   vsync_strt_wid = 0x860302
pixclock = 15384
freq = 6500
freq = 6500, PLL min = 20000, PLL max = 50000
ref_div = 12, ref_clk = 2700, output_freq = 26000
ref_div = 12, ref_clk = 2700, output_freq = 26000
post div = 0x2
fb_div = 0x74
ppll_div_3 = 0x20074
Console: switching to colour frame buffer device 128x48
radeonfb: Backlight initialized (radeonbl0)
radeonfb (0000:01:00.0): ATI Radeon ]R 
radeonfb_pci_register END
hpet_resources: 0xfed00000 is busy
ACPI Error (utglobal-0128): Unknown exception code: 0xFFFFFFF0 [20070126]
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller at PCI slot 0000:05:02.1
ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 18
ALI15X3: chipset revision 198
ALI15X3: 100% native mode on irq 18
    ide0: BM-DMA at 0xc080-0xc087, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xc088-0xc08f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: Maxtor 6Y120L0, ATA DISK drive
hdd: QUANTUM FIREBALLlct10 10, ATA DISK drive
ide1 at 0xc480-0xc487,0xc402 on irq 18
hdc: max request size: 128KiB
hdc: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(133)
hdc: cache flushes supported
 hdc: hdc1 hdc2 < hdc5 > hdc3
hdd: max request size: 128KiB
hdd: 20044080 sectors (10262 MB) w/418KiB Cache, CHS=19885/16/63, UDMA(33)
hdd: cache flushes not supported
 hdd: hdd1 hdd2
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
ata1: SATA max UDMA/133 cmd 0xf080c900 ctl 0x00000000 bmdma 0x00000000 irq 219
ata2: SATA max UDMA/133 cmd 0xf080c980 ctl 0x00000000 bmdma 0x00000000 irq 219
ata3: SATA max UDMA/133 cmd 0xf080ca00 ctl 0x00000000 bmdma 0x00000000 irq 219
ata4: SATA max UDMA/133 cmd 0xf080ca80 ctl 0x00000000 bmdma 0x00000000 irq 219
ata5: SATA max UDMA/133 cmd 0xf080cb00 ctl 0x00000000 bmdma 0x00000000 irq 219
ata6: SATA max UDMA/133 cmd 0xf080cb80 ctl 0x00000000 bmdma 0x00000000 irq 219
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3250820AS, 3.AAE, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link down (SStatus 0 SControl 300)
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3250820AS      3.AA PQ: 0 ANSI: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [LDM] sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
PCI: Device 0000:02:00.0 not available because of resource collisions
ahci: probe of 0000:02:00.0 failed with error -22
sata_uli 0000:05:02.0: version 1.0
ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 23 (level, low) -> IRQ 18
ata7: SATA max UDMA/133 cmd 0x0001c000 ctl 0x0001bc02 bmdma 0x0001b480 irq 18
ata8: SATA max UDMA/133 cmd 0x0001b880 ctl 0x0001b802 bmdma 0x0001b488 irq 18
scsi6 : sata_uli
ata7: SATA link down (SStatus 0 SControl 310)
scsi7 : sata_uli
ata8: SATA link down (SStatus 0 SControl 310)
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.1 to 64
ata9: PATA max UDMA/100 cmd 0x0001ac00 ctl 0x0001a882 bmdma 0x0001a400 irq 19
ata10: PATA max UDMA/100 cmd 0x0001a800 ctl 0x0001a482 bmdma 0x0001a408 irq 19
scsi8 : pata_jmicron
ata9.00: ATAPI, max UDMA/33
ata9.01: ATAPI, max UDMA/33
ata9.00: configured for UDMA/33
ata9.01: configured for UDMA/33
scsi9 : pata_jmicron
ATA: abnormal status 0x7F on port 0x0001a807
scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr 8:0:0:0: Attached scsi generic sg1 type 5
scsi 8:0:1:0: CD-ROM            WAITEC   ALADAR/1         B1.5 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 16x/40x writer cd/rw xa/form2 cdda tray
sr 8:0:1:0: Attached scsi CD-ROM sr1
sr 8:0:1:0: Attached scsi generic sg2 type 5
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 200k freed
Write protecting the kernel read-only data: 767k
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
SGI XFS with ACLs, large block numbers, no debug enabled
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  1F, should be 12 [20070126]
ACPI: SSDT 3FF9E0C0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00EC) - 9 Objects with 0 Devices 3 Methods 0 Regions
ACPI: SSDT 3FF9E290, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00EF) - 7 Objects with 0 Devices 4 Methods 0 Regions
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with journal data mode.
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: AGP aperture is 256M @ 0x0
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 20
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Attansic L1 Ethernet Network Driver - version 2.0.7
Copyright(c) 2005-2006 Attansic Corporation.
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> <6>ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 21
GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
e100: eth1: e100_probe: addr 0xdfeff000, irq 21, MAC addr 00:50:8B:5C:21:8B
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 19, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 18, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000d880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000dc00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 20, io mem 0xffaff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 18, io mem 0xffaff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:05:03.0[A] -> GSI 21 (level, low) -> IRQ 22
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[22]  MMIO=[ff7ef800-ff7effff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Adding 787176k swap on /dev/hdd2.  Priority:9 extents:1 across:787176k
EXT3 FS on dm-0, internal journal
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000e56e6e]
NET: Registered protocol family 10
processor_perflib-0563 [00] processor_get_psd     : Invalid _PSD data
processor_perflib-0563 [00] processor_get_psd     : Invalid _PSD data
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
CBQ: class 00010001 has bad quantum==0, repaired.
u32 classifier
    input device check on 
    Actions configured 
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
fuse init (API version 7.8)
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.25.0 20060524 on minor 0
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs


Luca
-- 
"La vita potrebbe non avere alcun significato. Oppure, ancora peggio,
 potrebbe averne uno che disapprovo". -- Ashleigh Brilliant
