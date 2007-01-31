Return-Path: <linux-kernel-owner+w=401wt.eu-S1030179AbXAaPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030179AbXAaPW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXAaPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:22:27 -0500
Received: from mout2.freenet.de ([194.97.50.155]:59499 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030179AbXAaPWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:22:21 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.20-rc6-mm3
Date: Wed, 31 Jan 2007 15:25:49 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070129204528.eb8d695e.akpm@osdl.org> <200701310155.05474.fzu@wemgehoertderstaat.de> <20070131132245.GA26066@elte.hu>
In-Reply-To: <20070131132245.GA26066@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200701311525.50160.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 14:22 schrieb Ingo Molnar:
> 
> * Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:
> 
> > Similar weirdness here on rc6-mm2 and rc6-rt*: resume from disk waits 
> > unduly long.
> 
> i'm wondering whether the jiffies update fix from Thomas fixes this bug 
> for you.
> 
> If not then do you have a serial console enabled?
> 
> > Some waiting times from rc6-rt6 from memory:
> > 
> > Config		| HZ			| NO_HZ + HRESTIMERS
> > cmos clock unchanged	| 2s			| 6s
> > cmos clock += 10min	| 			| 2 minutes
> > cmos clock += 2 month	| 20s			| > 4minutes, test interrupted
> 
> i've seen something like this on -rt (and incorrectly attributed it to 
> -rt) when running on a system which has a serial port and which has a 
> kernel console on that serial port. What happens is that after resume 
> (and straight after console suspend) every serial character printed 
> takes /alot/ of time - and resume does print a number of kernel messages 
> to the console. I didnt get any further in debugging this though, but 
> disabling the serial console made the problem go away.
> 
> a possibly related thing: the serial code is sensitive to jiffies 
> updates and timers, i saw that during early revisions of the dynticks 
> code - but the specifics escape me.
> 
> the slowdown could also be something like the kernel somehow wrapping 
> around jiffies and thus doing /alot/ of jiffy ticks? Or it could be a 
> miscalculation in the amount of jiffies that need updating, resulting in 
> a similar number of loops in the jiffy update code.
> 
> (i'll try to figure out this regression - but wanted to describe to you 
> the known things so far, maybe you'll figure it out faster than me.)

Serial port console is off here and the jiffies update fix doesn't make
a noticeable difference.
I've just captured a dmesglog of 3 suspend/resume cycles with printk
timestamps. Config has NO_HZ and HRESTIMERS.
In the 1st 2 cycles, while in bios, I advanced the cmos clock by ~4minutes,
In the last cycle by ~2minutes.
After the 
	lapic resume on CPU#0
entries there are roughly proportional timestamp differences of ~60s, ~60s
and ~35s. Those equal the unexpected wait times.
Will look into what happens between "lapic resume on CPU#0" and
"pci 0000:00:00.0: EARLY resume" next.

      Karsten

[    0.000000] Linux version 2.6.20-rc6-rt6.dbg (ka@a64.localdomain) (gcc-Version 4.1.1 20070105 (Red Hat 4.1.1-51)) #3 PREEMPT Wed Jan 31 14:25:07 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000003fef0000 end: 000000003fff0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fff0000 size: 0000000000008000 end: 000000003fff8000 type: 3
[    0.000000] copy_e820_map() start: 000000003fff8000 size: 0000000000008000 end: 0000000040000000 type: 4
[    0.000000] copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
[    0.000000] copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fff8000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fbfc0
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32497 pages, LIFO batch:7
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP (v000 AMI                                   ) @ 0x000fa3c0
[    0.000000] ACPI: RSDT (v001 AMIINT VIA_K8   0x00000010 MSFT 0x00000097) @ 0x3fff0000
[    0.000000] ACPI: FADT (v001 AMIINT VIA_K8   0x00000011 MSFT 0x00000097) @ 0x3fff0030
[    0.000000] ACPI: MADT (v001 AMIINT VIA_K8   0x00000009 MSFT 0x00000097) @ 0x3fff00c0
[    0.000000] ACPI: DSDT (v001    VIA   VIA_K8 0x00001000 MSFT 0x0100000d) @ 0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:15 APIC version 16
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] Detected 2000.346 MHz processor.
[   22.477053] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[   22.477060] Built 1 zonelists.  Total pages: 260081
[   22.477146] Kernel command line: ro root=LABEL=/ agp=off selinux=off 1
[   22.477412] mapped APIC to ffffd000 (fee00000)
[   22.477416] mapped IOAPIC to ffffc000 (fec00000)
[   22.477421] Enabling fast FPU save and restore... done.
[   22.477425] Enabling unmasked SIMD FPU exception support... done.
[   22.477434] Initializing CPU#0
[   22.477439] WARNING: experimental RCU implementation.
[   22.477502] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   22.479554] Console: colour VGA+ 80x25
[   22.485288] num_possible_cpus(): 1
[   22.486711] CPU#0: allocated 2097152 bytes trace buffer.
[   22.488149] CPU#0: allocated 2097152 bytes max-trace buffer.
[   22.489599] allocated 2097152 bytes out-trace buffer.
[   22.489712] tracer: a total of 6291456 bytes allocated.
[   22.489823] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   22.489989] ... MAX_LOCKDEP_SUBCLASSES:      8
[   22.490099] ... MAX_LOCK_DEPTH:             30
[   22.490210] ... MAX_LOCKDEP_KEYS:         2048
[   22.490320] ... CLASSHASH_SIZE:           1024
[   22.490429] ... MAX_LOCKDEP_ENTRIES:      8192
[   22.490539] ... MAX_LOCKDEP_CHAINS:      16384
[   22.490648] ... CHAINHASH_SIZE:           8192
[   22.490757]  memory used by lock dependency info: 1096 kB
[   22.490868]  per task-struct memory footprint: 1200 bytes
[   22.491291] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   22.491835] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   22.521443] Memory: 1024840k/1048512k available (2187k kernel code, 22908k reserved, 1039k data, 200k init, 131008k highmem)
[   22.521627] virtual kernel memory layout:
[   22.521629]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[   22.521632]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   22.521634]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   22.521637]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   22.521639]       .init : 0xc042a000 - 0xc045c000   ( 200 kB)
[   22.521642]       .data : 0xc0322f25 - 0xc0426d34   (1039 kB)
[   22.521644]       .text : 0xc0100000 - 0xc0322f25   (2187 kB)
[   22.522511] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   22.602851] Calibrating delay using timer specific routine.. 4005.80 BogoMIPS (lpj=8011611)
[   22.603165] Security Framework v1.0.0 initialized
[   22.603279] Capability LSM initialized
[   22.603386] Failure registering Root Plug module with the kernel
[   22.603501] Failure registering Root Plug  module with primary security module.
[   22.603700] Mount-cache hash table entries: 512
[   22.604173] CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000000 00000000 00000000
[   22.604191] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   22.604308] CPU: L2 Cache: 512K (64 bytes/line)
[   22.604419] CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000000 00000000 00000000
[   22.604435] Intel machine check architecture supported.
[   22.604547] Intel machine check reporting enabled on CPU#0.
[   22.604667] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
[   22.604880] Checking 'hlt' instruction... OK.
[   22.618969] ACPI: Core revision 20060707
[   22.625743] ENABLING IO-APIC IRQs
[   22.626171] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[   22.879023] NET: Registered protocol family 16
[   22.879415] ACPI: bus type pci registered
[   22.880276] PCI: PCI BIOS revision 2.10 entry at 0xfdae1, last bus=1
[   22.880389] PCI: Using configuration type 1
[   22.880498] Setting up standard PCI resources
[   22.900250] ACPI: Interpreter enabled
[   22.900362] ACPI: Using IOAPIC for interrupt routing
[   22.901486] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   22.901607] PCI: Probing PCI hardware (bus 00)
[   22.903444] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   22.903560] PCI: MSI-K8T-Neo2Fir, soundcard on
[   22.904032] Boot video device is 0000:01:00.0
[   22.904104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   22.966889] ACPI: Power Resource [URP1] (off)
[   22.967146] ACPI: Power Resource [URP2] (off)
[   22.967402] ACPI: Power Resource [FDDP] (off)
[   22.967659] ACPI: Power Resource [LPTP] (off)
[   22.972136] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   22.973387] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   22.974680] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   22.975916] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   22.977195] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   22.978646] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   22.980038] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   22.981427] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   22.982719] Linux Plug and Play Support v0.97 (c) Adam Belay
[   22.982852] pnp: PnP ACPI init
[   22.989499] pnp: PnP ACPI: found 10 devices
[   22.989854] usbcore: registered new interface driver usbfs
[   22.990050] usbcore: registered new interface driver hub
[   22.990291] usbcore: registered new device driver usb
[   22.990502] PCI: Using ACPI for IRQ routing
[   22.990613] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   22.994622] NetLabel: Initializing
[   22.994728] NetLabel:  domain hash size = 128
[   22.994837] NetLabel:  protocols = UNLABELED CIPSOv4
[   22.994981] NetLabel:  unlabeled traffic allowed by default
[   22.996525] PCI: Bridge: 0000:00:01.0
[   22.996633]   IO window: disabled.
[   22.996744]   MEM window: cde00000-cfefffff
[   22.996856]   PREFETCH window: bdd00000-cdcfffff
[   22.996985] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   22.997039] NET: Registered protocol family 2
[   23.018195] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   23.018625] TCP established hash table entries: 32768 (order: 9, 2752512 bytes)
[   23.030734] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[   23.036900] TCP: Hash tables configured (established 32768 bind 16384)
[   23.037035] TCP reno registered
[   23.042355] checking if image is initramfs... it is
[   23.136643] Freeing initrd memory: 1256k freed
[   23.137406] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   23.137520] apm: overridden by ACPI.
[   23.138340] audit: initializing netlink socket (disabled)
[   23.138495] audit(1170253668.500:1): initialized
[   23.138842] highmem bounce pool size: 64 pages
[   23.138954] Total HugeTLB memory allocated, 0
[   23.139322] VFS: Disk quotas dquot_6.5.1
[   23.139459] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   23.139913] io scheduler noop registered
[   23.140071] io scheduler anticipatory registered
[   23.140229] io scheduler deadline registered
[   23.140407] io scheduler cfq registered (default)
[   23.140706] PCI: Bypassing VIA 8237 APIC De-Assert Message
[   23.140994] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   23.152923] Real Time Clock Driver v1.12ac
[   23.153244] Non-volatile memory driver v1.2
[   23.153357] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   23.409586] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.410579] 00:01: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.412600] RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
[   23.413058] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   23.413176] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   23.413449] VP_IDE: IDE controller at PCI slot 0000:00:0f.0
[   23.413584] ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 20 (level, low) -> IRQ 16
[   23.413811] VP_IDE: chipset revision 6
[   23.413918] VP_IDE: not 100% native mode: will probe irqs later
[   23.415129] VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.0
[   23.415302]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
[   23.415575]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:pio
[   23.415843] Probing IDE interface ide0...
[   23.828683] hda: SAMSUNG SP2014N, ATA DISK drive
[   24.499610] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   24.499885] Probing IDE interface ide1...
[   25.361806] hdc: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
[   26.032779] ide1 at 0x170-0x177,0x376 on irq 15
[   26.033380] hda: max request size: 512KiB
[   26.039066] hda: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, UDMA(133)
[   26.039633] hda: cache flushes supported
[   26.039833]  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
[   26.094517] usbcore: registered new interface driver libusual
[   26.094687] usbcore: registered new interface driver hiddev
[   26.094873] usbcore: registered new interface driver usbhid
[   26.094987] /home/ka/q/kernel/linux-2.6./20/rc6-rt6-kw/drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   26.095337] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   26.096013] serio: i8042 KBD port at 0x60,0x64 irq 1
[   26.096253] serio: i8042 AUX port at 0x60,0x64 irq 12
[   26.096546] mice: PS/2 mouse device common for all mice
[   26.117810] input: AT Translated Set 2 keyboard as /class/input/input0
[   26.152373] TCP bic registered
[   26.152479] Initializing XFRM netlink socket
[   26.152616] NET: Registered protocol family 1
[   26.152731] NET: Registered protocol family 17
[   26.152856] Using IPI Shortcut mode
[   26.153070] ACPI: (supports S0 S1 S3 S4 S5)
[   26.153551] *****************************************************************************
[   26.153720] *                                                                           *
[   26.153889] *  REMINDER, the following debugging options are turned on in your .config: *
[   26.154056] *                                                                           *
[   26.154222] *        CONFIG_CRITICAL_PREEMPT_TIMING                                     *
[   26.154389] *        CONFIG_CRITICAL_IRQSOFF_TIMING                                     *
[   26.154556] *        CONFIG_FUNCTION_TRACE                                               *
[   26.154750] *        CONFIG_LOCKDEP                                                     *
[   26.154917] *                                                                           *
[   26.155084] *  they may increase runtime overhead and latencies.                        *
[   26.155253] *                                                                           *
[   26.155423] *****************************************************************************
[   26.155736] Freeing unused kernel memory: 200k freed
[   26.155912] Write protecting the kernel read-only data: 766k
[   26.156215] Time: tsc clocksource has been installed.
[   26.302780] logips2pp: Detected unknown logitech mouse model 62
[   26.430080] USB Universal Host Controller Interface driver v3.0
[   26.430306] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 17
[   26.430531] uhci_hcd 0000:00:10.0: UHCI Host Controller
[   26.430870] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
[   26.431231] uhci_hcd 0000:00:10.0: irq 17, io base 0x0000dc00
[   26.431686] usb usb1: configuration #1 chosen from 1 choice
[   26.431965] hub 1-0:1.0: USB hub found
[   26.432100] hub 1-0:1.0: 2 ports detected
[   26.535831] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 17
[   26.536050] uhci_hcd 0000:00:10.1: UHCI Host Controller
[   26.536243] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
[   26.536429] uhci_hcd 0000:00:10.1: irq 17, io base 0x0000e000
[   26.536755] usb usb2: configuration #1 chosen from 1 choice
[   26.536928] hub 2-0:1.0: USB hub found
[   26.537047] hub 2-0:1.0: 2 ports detected
[   26.639490] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 17
[   26.639711] uhci_hcd 0000:00:10.2: UHCI Host Controller
[   26.639900] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
[   26.640086] uhci_hcd 0000:00:10.2: irq 17, io base 0x0000e400
[   26.640432] usb usb3: configuration #1 chosen from 1 choice
[   26.640626] hub 3-0:1.0: USB hub found
[   26.640743] hub 3-0:1.0: 2 ports detected
[   26.655296] Switched to high resolution mode on CPU 0
[   26.743156] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 17
[   26.743379] uhci_hcd 0000:00:10.3: UHCI Host Controller
[   26.743547] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
[   26.743735] uhci_hcd 0000:00:10.3: irq 17, io base 0x0000e800
[   26.744088] usb usb4: configuration #1 chosen from 1 choice
[   26.744283] hub 4-0:1.0: USB hub found
[   26.744400] hub 4-0:1.0: 2 ports detected
[   26.813898] input: ImExPS/2 Logitech Explorer Mouse as /class/input/input1
[   26.848563] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 17
[   26.848791] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   26.848981] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
[   26.849197] ehci_hcd 0000:00:10.4: irq 17, io mem 0xcffffd00
[   26.849314] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   26.849665] usb usb5: configuration #1 chosen from 1 choice
[   26.849827] hub 5-0:1.0: USB hub found
[   26.849997] hub 5-0:1.0: 8 ports detected
[   27.158838] kjournald starting.  Commit interval 5 seconds
[   27.158996] EXT3-fs: mounted filesystem with ordered data mode.
[   35.835033] hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
[   35.835051] Uniform CD-ROM driver Revision: 3.20
[   35.861074] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[   35.861104] ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 16 (level, low) -> IRQ 18
[   35.861291] eth0: RTL8169s/8110s at 0xf8806f00, 00:11:09:d9:97:b2, IRQ 18
[   35.890001] parport: PnPBIOS parport detected.
[   35.890219] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
[   36.157882] nvidia: module license 'NVIDIA' taints kernel.
[   36.409188] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 18
[   36.409420] NVRM: loading NVIDIA Linux x86 Kernel Module  1.0-9631  Thu Nov  9 17:38:10 PST 2006
[   36.467844] input: PC Speaker as /class/input/input2
[   36.985986] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 19
[   36.986172] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   41.535760] floppy0: no floppy controllers found
[   41.562057] lp0: using parport0 (interrupt-driven).
[   41.828480] input: Power Button (FF) as /class/input/input3
[   41.841452] ACPI: Power Button (FF) [PWRF]
[   41.852224] input: Power Button (CM) as /class/input/input4
[   41.865199] ACPI: Power Button (CM) [PWRB]
[   41.875937] input: Sleep Button (CM) as /class/input/input5
[   41.888682] ACPI: Sleep Button (CM) [SLPB]
[   41.901162] No dock devices found.
[   41.912664] ibm_acpi: ec object not found
[   42.520611] EXT3 FS on hda3, internal journal
[   42.644071] kjournald starting.  Commit interval 5 seconds
[   42.644272] EXT3 FS on hda5, internal journal
[   42.644280] EXT3-fs: mounted filesystem with ordered data mode.
[   42.647271] kjournald starting.  Commit interval 5 seconds
[   42.647418] EXT3 FS on hda2, internal journal
[   42.647425] EXT3-fs: mounted filesystem with ordered data mode.
[   43.274376] Adding 1464836k swap on /dev/hda6.  Priority:-1 extents:1 across:1464836k
[   43.686588] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (version 2.00.00)
[   43.690186] powernow-k8:    0 : fid 0x2 (1000 MHz), vid 0x12
[   43.690190] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[   43.690195] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x6
[   89.323447] Time: acpi_pm clocksource has been installed.
[   89.822999] Clocksource tsc unstable (delta = -250051675 ns)
[  107.147024] Stopping tasks ... done.
[  107.217374] Shrinking memory...  -done (0 pages freed)
[  107.240775] Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
[  107.240783] Suspending console(s)
[  108.145319] pnp: Device 00:02 disabled.
[  108.145818] pnp: Device 00:01 disabled.
[  108.146724] ACPI: PCI interrupt for device 0000:00:11.5 disabled
[  108.160786] ACPI: PCI interrupt for device 0000:00:10.4 disabled
[  108.176729] ACPI: PCI interrupt for device 0000:00:10.3 disabled
[  108.192712] ACPI: PCI interrupt for device 0000:00:10.2 disabled
[  108.208696] ACPI: PCI interrupt for device 0000:00:10.1 disabled
[  108.224680] ACPI: PCI interrupt for device 0000:00:10.0 disabled
[  108.241268] lapic suspend on CPU#0
[  108.241274]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[  108.241289]  [<c010477c>] show_trace+0x2c/0x2e
[  108.241299]  [<c0104843>] dump_stack+0x29/0x2b
[  108.241309]  [<c011015b>] lapic_suspend+0xcf/0xf8
[  108.241319]  [<c026cf0d>] sysdev_suspend+0xad/0x216
[  108.241331]  [<c0271563>] device_power_down+0xb5/0xe2
[  108.241340]  [<c0142e5a>] swsusp_suspend+0x1e/0x6e
[  108.241351]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[  108.241361]  [<c01422c8>] enter_state+0x58/0x161
[  108.241371]  [<c0142461>] state_store+0x90/0xa5
[  108.241380]  [<c01b3891>] subsys_attr_store+0x33/0x35
[  108.241392]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[  108.241402]  [<c01761b4>] vfs_write+0xce/0x1a6
[  108.241412]  [<c0176815>] sys_write+0x4c/0x70
[  108.241421]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[  108.241430]  =======================
[  108.241446] swsusp: critical section: 
[  108.264597] swsusp: Need to copy 16708 pages
[   57.589976] Intel machine check architecture supported.
[   57.589989] Intel machine check reporting enabled on CPU#0.
[   28.767086] lapic resume on CPU#0
[   28.767089]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[   28.767097]  [<c010477c>] show_trace+0x2c/0x2e
[   28.767102]  [<c0104843>] dump_stack+0x29/0x2b
[   28.767107]  [<c01101b8>] lapic_resume+0x34/0x1af
[   28.767113]  [<c026ca46>] __sysdev_resume+0x20/0x66
[   28.767119]  [<c026d098>] sysdev_resume+0x22/0x5e
[   28.767124]  [<c027187b>] device_power_up+0xd/0x14
[   28.767129]  [<c0142e9d>] swsusp_suspend+0x61/0x6e
[   28.767134]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[   28.767140]  [<c01422c8>] enter_state+0x58/0x161
[   28.767144]  [<c0142461>] state_store+0x90/0xa5
[   28.767149]  [<c01b3891>] subsys_attr_store+0x33/0x35
[   28.767155]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[   28.767161]  [<c01761b4>] vfs_write+0xce/0x1a6
[   28.767166]  [<c0176815>] sys_write+0x4c/0x70
[   28.767170]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[   28.767175]  =======================
[   96.970169] pci 0000:00:00.0: EARLY resume
[   96.970173] pci 0000:00:00.1: EARLY resume
[   96.970176] pci 0000:00:00.2: EARLY resume
[   96.970180] pci 0000:00:00.3: EARLY resume
[   96.970183] pci 0000:00:00.4: EARLY resume
[   96.970186] pci 0000:00:00.7: EARLY resume
[   96.970189] pci 0000:00:01.0: EARLY resume
[   96.970192] r8169 0000:00:0b.0: EARLY resume
[   96.970196] VIA_IDE 0000:00:0f.0: EARLY resume
[   96.970199] uhci_hcd 0000:00:10.0: EARLY resume
[   96.970203] uhci_hcd 0000:00:10.1: EARLY resume
[   96.970206] uhci_hcd 0000:00:10.2: EARLY resume
[   96.970209] uhci_hcd 0000:00:10.3: EARLY resume
[   96.970213] ehci_hcd 0000:00:10.4: EARLY resume
[   96.970216] pci 0000:00:11.0: EARLY resume
[   96.970222] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   96.970228] PCI: MSI-K8T-Neo2Fir, soundcard on
[   96.970233] VIA 82xx Audio 0000:00:11.5: EARLY resume
[   96.970236] pci 0000:00:18.0: EARLY resume
[   96.970240] pci 0000:00:18.1: EARLY resume
[   96.970243] pci 0000:00:18.2: EARLY resume
[   96.970246] k8temp 0000:00:18.3: EARLY resume
[   96.970250] nvidia 0000:01:00.0: EARLY resume
[   96.970254] pcspkr pcspkr: EARLY resume
[   96.970257] platform vesafb.0: EARLY resume
[   96.970264] serial8250 serial8250: EARLY resume
[   96.970268] i8042 i8042: EARLY resume
[   96.978026] acpi acpi: resuming
[   96.978035] pci 0000:00:00.0: resuming
[   96.978081] pci 0000:00:00.1: resuming
[   96.978104] pci 0000:00:00.2: resuming
[   96.978126] pci 0000:00:00.3: resuming
[   96.978149] pci 0000:00:00.4: resuming
[   96.978171] pci 0000:00:00.7: resuming
[   96.978194] pci 0000:00:01.0: resuming
[   96.978237] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   96.978242] r8169 0000:00:0b.0: resuming
[   96.978246] VIA_IDE 0000:00:0f.0: resuming
[   96.978293] ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 20 (level, low) -> IRQ 16
[   96.978300] uhci_hcd 0000:00:10.0: resuming
[   96.989807] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 17
[   96.989862] usb usb1: root hub lost power or was reset
[   96.989875] uhci_hcd 0000:00:10.1: resuming
[   97.005774] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 17
[   97.005827] usb usb2: root hub lost power or was reset
[   97.005839] uhci_hcd 0000:00:10.2: resuming
[   97.021742] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 17
[   97.021795] usb usb3: root hub lost power or was reset
[   97.021807] uhci_hcd 0000:00:10.3: resuming
[   97.037710] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 17
[   97.037763] usb usb4: root hub lost power or was reset
[   97.037776] ehci_hcd 0000:00:10.4: resuming
[   97.053679] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 17
[   97.053719] usb usb5: root hub lost power or was reset
[   97.053735] pci 0000:00:11.0: resuming
[   97.053770] VIA 82xx Audio 0000:00:11.5: resuming
[   97.069678] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 19
[   97.069687] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   97.072809] pci 0000:00:18.0: resuming
[   97.072825] pci 0000:00:18.1: resuming
[   97.072837] pci 0000:00:18.2: resuming
[   97.072850] k8temp 0000:00:18.3: resuming
[   97.072863] nvidia 0000:01:00.0: resuming
[   97.073007] pnp 00:00: resuming
[   97.073014] serial 00:01: resuming
[   97.074378] pnp: Device 00:01 activated.
[   97.074384] parport_pc 00:02: resuming
[   97.076025] pnp: Device 00:02 activated.
[   97.076029] system 00:03: resuming
[   97.076032] pnp 00:04: resuming
[   97.076034] pnp 00:05: resuming
[   97.076037] pnp 00:06: resuming
[   97.076040] pnp 00:07: resuming
[   97.076043] i8042 aux 00:08: resuming
[   97.076181] pnp: Failed to activate device 00:08.
[   97.076185] i8042 kbd 00:09: resuming
[   97.076199] pnp: Failed to activate device 00:09.
[   97.076208] pcspkr pcspkr: resuming
[   97.076212] platform vesafb.0: resuming
[   97.076250] serial8250 serial8250: resuming
[   97.076257] ide-disk 0.0: resuming
[   97.129427] ide-cdrom 1.0: resuming
[   97.131585] i8042 i8042: resuming
[   97.131618] atkbd serio0: resuming
[   97.164790] psmouse serio1: resuming
[   97.345198] logips2pp: Detected unknown logitech mouse model 62
[   97.848637] usb usb1: resuming
[   97.888028] hub 1-0:1.0: resuming
[   97.888032] usb usb2: resuming
[  196.047736] hub 2-0:1.0: resuming
[  196.047743] usb usb3: resuming
[  196.087517] hub 3-0:1.0: resuming
[  196.087524] usb usb4: resuming
[  196.127477] hub 4-0:1.0: resuming
[  196.127484] usb usb5: resuming
[  196.159445] hub 5-0:1.0: resuming
[  196.159464] ac97 0-0:ALC850: resuming
[  196.159515] Restarting tasks ... done.
[  286.477196] dbs_check_cpu: t310 < i311
[  368.901522] uhci_hcd 0000:00:10.3: remove, state 1
[  368.901534] usb usb4: USB disconnect, address 1
[  368.905100] uhci_hcd 0000:00:10.3: USB bus 4 deregistered
[  368.906081] ACPI: PCI interrupt for device 0000:00:10.3 disabled
[  368.906109] uhci_hcd 0000:00:10.2: remove, state 1
[  368.906119] usb usb3: USB disconnect, address 1
[  368.909638] uhci_hcd 0000:00:10.2: USB bus 3 deregistered
[  368.910592] ACPI: PCI interrupt for device 0000:00:10.2 disabled
[  368.910620] uhci_hcd 0000:00:10.1: remove, state 1
[  368.910629] usb usb2: USB disconnect, address 1
[  368.914235] uhci_hcd 0000:00:10.1: USB bus 2 deregistered
[  368.914334] ACPI: PCI interrupt for device 0000:00:10.1 disabled
[  368.914361] uhci_hcd 0000:00:10.0: remove, state 1
[  368.914369] usb usb1: USB disconnect, address 1
[  368.915250] uhci_hcd 0000:00:10.0: USB bus 1 deregistered
[  368.915333] ACPI: PCI interrupt for device 0000:00:10.0 disabled
[  416.880815] r8169: eth0: link up
[  227.932433] Stopping tasks ... done.
[  227.933330] Shrinking memory...  -done (0 pages freed)
[  227.949058] Freed 0 kbytes in 0.01 seconds (0.00 MB/s)
[  227.949063] Suspending console(s)
[  228.840372] pnp: Device 00:02 disabled.
[  228.840626] pnp: Device 00:01 disabled.
[  228.841385] ACPI: PCI interrupt for device 0000:00:11.5 disabled
[  228.854045] ACPI: PCI interrupt for device 0000:00:10.4 disabled
[  228.886441] lapic suspend on CPU#0
[  228.886445]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[  228.886453]  [<c010477c>] show_trace+0x2c/0x2e
[  228.886458]  [<c0104843>] dump_stack+0x29/0x2b
[  228.886463]  [<c011015b>] lapic_suspend+0xcf/0xf8
[  228.886469]  [<c026cf0d>] sysdev_suspend+0xad/0x216
[  228.886474]  [<c0271563>] device_power_down+0xb5/0xe2
[  228.886480]  [<c0142e5a>] swsusp_suspend+0x1e/0x6e
[  228.886485]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[  228.886490]  [<c01422c8>] enter_state+0x58/0x161
[  228.886495]  [<c0142461>] state_store+0x90/0xa5
[  228.886499]  [<c01b3891>] subsys_attr_store+0x33/0x35
[  228.886505]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[  228.886511]  [<c01761b4>] vfs_write+0xce/0x1a6
[  228.886516]  [<c0176815>] sys_write+0x4c/0x70
[  228.886520]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[  228.886525]  =======================
[  228.886536] swsusp: critical section: 
[  228.902253] swsusp: Need to copy 19089 pages
[   28.574318] Intel machine check architecture supported.
[   28.574325] Intel machine check reporting enabled on CPU#0.
[   28.574561] lapic resume on CPU#0
[   28.574565]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[   28.574573]  [<c010477c>] show_trace+0x2c/0x2e
[   28.574578]  [<c0104843>] dump_stack+0x29/0x2b
[   28.574583]  [<c01101b8>] lapic_resume+0x34/0x1af
[   28.574589]  [<c026ca46>] __sysdev_resume+0x20/0x66
[   28.574595]  [<c026d098>] sysdev_resume+0x22/0x5e
[   28.574600]  [<c027187b>] device_power_up+0xd/0x14
[   28.574605]  [<c0142e9d>] swsusp_suspend+0x61/0x6e
[   28.574610]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[   28.574615]  [<c01422c8>] enter_state+0x58/0x161
[   28.574620]  [<c0142461>] state_store+0x90/0xa5
[   28.574625]  [<c01b3891>] subsys_attr_store+0x33/0x35
[   28.574631]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[   28.574637]  [<c01761b4>] vfs_write+0xce/0x1a6
[   28.574642]  [<c0176815>] sys_write+0x4c/0x70
[   28.574647]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[   28.574651]  =======================
[   90.251248] pci 0000:00:00.0: EARLY resume
[   90.251252] pci 0000:00:00.1: EARLY resume
[   90.251255] pci 0000:00:00.2: EARLY resume
[   90.251258] pci 0000:00:00.3: EARLY resume
[   90.251261] pci 0000:00:00.4: EARLY resume
[   90.251265] pci 0000:00:00.7: EARLY resume
[   90.251268] pci 0000:00:01.0: EARLY resume
[   90.251271] r8169 0000:00:0b.0: EARLY resume
[   90.251274] VIA_IDE 0000:00:0f.0: EARLY resume
[   90.251278] pci 0000:00:10.0: EARLY resume
[   90.251281] pci 0000:00:10.1: EARLY resume
[   90.251284] pci 0000:00:10.2: EARLY resume
[   90.251287] pci 0000:00:10.3: EARLY resume
[   90.251291] ehci_hcd 0000:00:10.4: EARLY resume
[   90.251294] pci 0000:00:11.0: EARLY resume
[   90.251300] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   90.251306] PCI: MSI-K8T-Neo2Fir, soundcard on
[   90.251311] VIA 82xx Audio 0000:00:11.5: EARLY resume
[   90.251315] pci 0000:00:18.0: EARLY resume
[   90.251318] pci 0000:00:18.1: EARLY resume
[   90.251321] pci 0000:00:18.2: EARLY resume
[   90.251324] k8temp 0000:00:18.3: EARLY resume
[   90.251328] nvidia 0000:01:00.0: EARLY resume
[   90.251332] pcspkr pcspkr: EARLY resume
[   90.251335] platform vesafb.0: EARLY resume
[   90.251342] serial8250 serial8250: EARLY resume
[   90.251346] i8042 i8042: EARLY resume
[   90.259839] acpi acpi: resuming
[   90.259848] pci 0000:00:00.0: resuming
[   90.259899] pci 0000:00:00.1: resuming
[   90.259922] pci 0000:00:00.2: resuming
[   90.259944] pci 0000:00:00.3: resuming
[   90.259967] pci 0000:00:00.4: resuming
[   90.259989] pci 0000:00:00.7: resuming
[   90.260012] pci 0000:00:01.0: resuming
[   90.260054] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   90.260060] r8169 0000:00:0b.0: resuming
[   90.271012] VIA_IDE 0000:00:0f.0: resuming
[   90.271061] ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 20 (level, low) -> IRQ 16
[   90.271067] pci 0000:00:10.0: resuming
[   90.271094] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2100017, writing 2100013)
[   90.271107] pci 0000:00:10.1: resuming
[   90.271134] PM: Writing back config space on device 0000:00:10.1 at offset 1 (was 2100017, writing 2100013)
[   90.271147] pci 0000:00:10.2: resuming
[   90.271173] PM: Writing back config space on device 0000:00:10.2 at offset 1 (was 2100017, writing 2100013)
[   90.271186] pci 0000:00:10.3: resuming
[   90.271212] PM: Writing back config space on device 0000:00:10.3 at offset 1 (was 2100017, writing 2100013)
[   90.271225] ehci_hcd 0000:00:10.4: resuming
[   90.286985] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 17
[   90.287026] usb usb5: root hub lost power or was reset
[   90.287043] pci 0000:00:11.0: resuming
[   90.287078] VIA 82xx Audio 0000:00:11.5: resuming
[   90.302943] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 19
[   90.302953] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   90.306052] pci 0000:00:18.0: resuming
[   90.306068] pci 0000:00:18.1: resuming
[   90.306080] pci 0000:00:18.2: resuming
[   90.306093] k8temp 0000:00:18.3: resuming
[   90.306106] nvidia 0000:01:00.0: resuming
[   90.306245] pnp 00:00: resuming
[   90.306251] serial 00:01: resuming
[   90.307641] pnp: Device 00:01 activated.
[   90.307647] parport_pc 00:02: resuming
[   90.309271] pnp: Device 00:02 activated.
[   90.309275] system 00:03: resuming
[   90.309278] pnp 00:04: resuming
[   90.309281] pnp 00:05: resuming
[   90.309284] pnp 00:06: resuming
[   90.309287] pnp 00:07: resuming
[   90.309290] i8042 aux 00:08: resuming
[   90.309426] pnp: Failed to activate device 00:08.
[   90.309430] i8042 kbd 00:09: resuming
[   90.309445] pnp: Failed to activate device 00:09.
[   90.309454] pcspkr pcspkr: resuming
[   90.309457] platform vesafb.0: resuming
[   90.309496] serial8250 serial8250: resuming
[   90.309503] ide-disk 0.0: resuming
[   90.356307] ide-cdrom 1.0: resuming
[   90.358458] i8042 i8042: resuming
[   90.358491] atkbd serio0: resuming
[   90.391693] psmouse serio1: resuming
[   90.573192] logips2pp: Detected unknown logitech mouse model 62
[   91.075384] usb usb5: resuming
[   91.105324] hub 5-0:1.0: resuming
[   91.105334] ac97 0-0:ALC850: resuming
[   91.764195] Restarting tasks ... done.
[  184.374518] input: Power Button (FF) as /class/input/input6
[  184.380803] ACPI: Power Button (FF) [PWRF]
[  184.401383] input: Power Button (CM) as /class/input/input7
[  184.426364] ACPI: Power Button (CM) [PWRB]
[  184.427403] input: Sleep Button (CM) as /class/input/input8
[  184.447937] ACPI: Sleep Button (CM) [SLPB]
[  405.243424] Stopping tasks ... done.
[  405.244559] Shrinking memory...  -done (0 pages freed)
[  405.267891] Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
[  405.267899] Suspending console(s)
[  406.076633] pnp: Device 00:02 disabled.
[  406.077139] pnp: Device 00:01 disabled.
[  406.078087] ACPI: PCI interrupt for device 0000:00:11.5 disabled
[  406.089520] ACPI: PCI interrupt for device 0000:00:10.4 disabled
[  406.121988] lapic suspend on CPU#0
[  406.121995]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[  406.122009]  [<c010477c>] show_trace+0x2c/0x2e
[  406.122019]  [<c0104843>] dump_stack+0x29/0x2b
[  406.122029]  [<c011015b>] lapic_suspend+0xcf/0xf8
[  406.122040]  [<c026cf0d>] sysdev_suspend+0xad/0x216
[  406.122051]  [<c0271563>] device_power_down+0xb5/0xe2
[  406.122060]  [<c0142e5a>] swsusp_suspend+0x1e/0x6e
[  406.122071]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[  406.122081]  [<c01422c8>] enter_state+0x58/0x161
[  406.122090]  [<c0142461>] state_store+0x90/0xa5
[  406.122099]  [<c01b3891>] subsys_attr_store+0x33/0x35
[  406.122111]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[  406.122121]  [<c01761b4>] vfs_write+0xce/0x1a6
[  406.122131]  [<c0176815>] sys_write+0x4c/0x70
[  406.122140]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[  406.122149]  =======================
[  406.122164] swsusp: critical section: 
[  406.145294] swsusp: Need to copy 19231 pages
[   58.244141] Intel machine check architecture supported.
[   58.244155] Intel machine check reporting enabled on CPU#0.
[   29.093849] lapic resume on CPU#0
[   29.093853]  [<c01040fa>] show_trace_log_lvl+0x35/0x54
[   29.093861]  [<c010477c>] show_trace+0x2c/0x2e
[   29.093865]  [<c0104843>] dump_stack+0x29/0x2b
[   29.093870]  [<c01101b8>] lapic_resume+0x34/0x1af
[   29.093876]  [<c026ca46>] __sysdev_resume+0x20/0x66
[   29.093882]  [<c026d098>] sysdev_resume+0x22/0x5e
[   29.093887]  [<c027187b>] device_power_up+0xd/0x14
[   29.093892]  [<c0142e9d>] swsusp_suspend+0x61/0x6e
[   29.093897]  [<c014354a>] pm_suspend_disk+0x97/0x14d
[   29.093902]  [<c01422c8>] enter_state+0x58/0x161
[   29.093907]  [<c0142461>] state_store+0x90/0xa5
[   29.093912]  [<c01b3891>] subsys_attr_store+0x33/0x35
[   29.093918]  [<c01b3b74>] sysfs_write_file+0xba/0xdb
[   29.093923]  [<c01761b4>] vfs_write+0xce/0x1a6
[   29.093928]  [<c0176815>] sys_write+0x4c/0x70
[   29.093933]  [<c01030d7>] sysenter_past_esp+0x6c/0xad
[   29.093937]  =======================
[   65.934039] pci 0000:00:00.0: EARLY resume
[   65.934044] pci 0000:00:00.1: EARLY resume
[   65.934047] pci 0000:00:00.2: EARLY resume
[   65.934050] pci 0000:00:00.3: EARLY resume
[   65.934053] pci 0000:00:00.4: EARLY resume
[   65.934056] pci 0000:00:00.7: EARLY resume
[   65.934059] pci 0000:00:01.0: EARLY resume
[   65.934063] r8169 0000:00:0b.0: EARLY resume
[   65.934066] VIA_IDE 0000:00:0f.0: EARLY resume
[   65.934069] pci 0000:00:10.0: EARLY resume
[   65.934073] pci 0000:00:10.1: EARLY resume
[   65.934076] pci 0000:00:10.2: EARLY resume
[   65.934079] pci 0000:00:10.3: EARLY resume
[   65.934082] ehci_hcd 0000:00:10.4: EARLY resume
[   65.934086] pci 0000:00:11.0: EARLY resume
[   65.934091] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   65.934097] PCI: MSI-K8T-Neo2Fir, soundcard on
[   65.934102] VIA 82xx Audio 0000:00:11.5: EARLY resume
[   65.934106] pci 0000:00:18.0: EARLY resume
[   65.934109] pci 0000:00:18.1: EARLY resume
[   65.934112] pci 0000:00:18.2: EARLY resume
[   65.934115] k8temp 0000:00:18.3: EARLY resume
[   65.934119] nvidia 0000:01:00.0: EARLY resume
[   65.934124] pcspkr pcspkr: EARLY resume
[   65.934127] platform vesafb.0: EARLY resume
[   65.934134] serial8250 serial8250: EARLY resume
[   65.934137] i8042 i8042: EARLY resume
[   65.942628] acpi acpi: resuming
[   65.942638] pci 0000:00:00.0: resuming
[   65.942685] pci 0000:00:00.1: resuming
[   65.942708] pci 0000:00:00.2: resuming
[   65.942731] pci 0000:00:00.3: resuming
[   65.942753] pci 0000:00:00.4: resuming
[   65.942776] pci 0000:00:00.7: resuming
[   65.942798] pci 0000:00:01.0: resuming
[   65.942841] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   65.942846] r8169 0000:00:0b.0: resuming
[   65.952005] VIA_IDE 0000:00:0f.0: resuming
[   65.952054] ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 20 (level, low) -> IRQ 16
[   65.952060] pci 0000:00:10.0: resuming
[   65.952087] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2100017, writing 2100013)
[   65.952101] pci 0000:00:10.1: resuming
[   65.952127] PM: Writing back config space on device 0000:00:10.1 at offset 1 (was 2100017, writing 2100013)
[   65.952140] pci 0000:00:10.2: resuming
[   65.952166] PM: Writing back config space on device 0000:00:10.2 at offset 1 (was 2100017, writing 2100013)
[   65.952179] pci 0000:00:10.3: resuming
[   65.952206] PM: Writing back config space on device 0000:00:10.3 at offset 1 (was 2100017, writing 2100013)
[   65.952219] ehci_hcd 0000:00:10.4: resuming
[   65.967977] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 17
[   65.968017] usb usb5: root hub lost power or was reset
[   65.968034] pci 0000:00:11.0: resuming
[   65.968068] VIA 82xx Audio 0000:00:11.5: resuming
[   65.983936] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 19
[   65.983945] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   65.987043] pci 0000:00:18.0: resuming
[   65.987058] pci 0000:00:18.1: resuming
[   65.987071] pci 0000:00:18.2: resuming
[   65.987084] k8temp 0000:00:18.3: resuming
[   65.987097] nvidia 0000:01:00.0: resuming
[   65.987237] pnp 00:00: resuming
[   65.987244] serial 00:01: resuming
[   65.988604] pnp: Device 00:01 activated.
[   65.988610] parport_pc 00:02: resuming
[   65.990224] pnp: Device 00:02 activated.
[   65.990227] system 00:03: resuming
[   65.990230] pnp 00:04: resuming
[   65.990233] pnp 00:05: resuming
[   65.990236] pnp 00:06: resuming
[   65.990239] pnp 00:07: resuming
[   65.990242] i8042 aux 00:08: resuming
[   65.990379] pnp: Failed to activate device 00:08.
[   65.990383] i8042 kbd 00:09: resuming
[   65.990398] pnp: Failed to activate device 00:09.
[   65.990407] pcspkr pcspkr: resuming
[   65.990410] platform vesafb.0: resuming
[   65.990449] serial8250 serial8250: resuming
[   65.990456] ide-disk 0.0: resuming
[   66.040883] ide-cdrom 1.0: resuming
[   66.043032] i8042 i8042: resuming
[   66.043065] atkbd serio0: resuming
[   66.075682] psmouse serio1: resuming
[   66.253841] logips2pp: Detected unknown logitech mouse model 62
[  133.359431] usb usb5: resuming
[  133.391673] hub 5-0:1.0: resuming
[  133.391692] ac97 0-0:ALC850: resuming
[  133.391739] Restarting tasks ... done.
