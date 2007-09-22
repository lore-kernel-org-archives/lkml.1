Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbXIVOqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbXIVOqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXIVOq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:46:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:60797 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbXIVOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:message-id;
        b=V6cZD/gpEPqfwjd1Xo0pvsGAqHnItfUl2kFJF5nysPzKfm+nzPfgDrgMi6kUZtSnVNXQnjGT1dj2D4rCJ2KsMTTgCgNZ32QVrqUcp1anCy4RTpynABOjz2srX+kO5YFB08YprgA+1QlwbSxOI2vcSNzlIoPXpPgY2vSUTYBMQoI=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sat, 22 Sep 2007 17:46:14 +0300
User-Agent: KMail/1.9.7
References: <200709220828.00078.mihai.dontu@gmail.com>
In-Reply-To: <200709220828.00078.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2qS9GBVmZvdHPiE"
Message-Id: <200709221746.14429.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2qS9GBVmZvdHPiE
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Saturday 22 September 2007, Mihai Donțu wrote:
> Hi,
> 
> Today, out of curiosity, I pulled 2.6.23-rc7 (leave on the edge in a quiet weekend).
> Anyway, it seems that radeonfb and my:
> "01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M 5955 (PCIE)"
> don't get along anymore, by:
> a) X somehow fails to initialize the card and everything moves really slow (I can
>    see how surfaces are drawn pixel-by-pixel); furthermore, garbage stuff appears
>    on the screen;
> b) after powering up from a s2ram, the system freezes;
> 
> b) is not that bad, s2ram never worked on my machine (kjournald and some other kernel
> processes, enter disk-sleep and in a matter of seconds, everything just... freezes.
> I can type a few commands at the normal console but that is all);
> 
> Following the advices in 'Documentation/power/s2ram.txt' helped. Using the regular
> VGA console got X on the right track (no more slowness);
> 
> Now that I got my hands "dirty", I'm in the mood to make my s2ram work (I've
> been using Linux (exclusively) for three years now, it's about time I do a small
> contribution). What kernel option must I enable to determine why some processes
> enter (and stay in) disk-sleep? I'm on a laptop and I don't think it will withstand
> too many reboots :)
> 
> I've also attached the output of lspci and dmesg. Maybe someone spots something.
> 
> Thanks,
> 

  Since there was no reply, I assume people *do* take the weekend off :)
  
  Anyway, I took matters into my own hands and enabled whatever debugging
  feature seamed reasonable enough (ACPI, SysRq, etc).

  Reboot, play, echo "mem" >/sys/power/state. I waited 5s and powered up
  and found this in dmesg

  "
  hda:task_out_intr:status = 0x51 { DriveReady SeekComplete Error }
  hda:task_out_intr:error = 0x04 { DriveStatusError }
  ide:failed opcode was: unknown
  "

  I figured my IDE woke up in a bad mood so I alt-sysrq-s, alt-sysrq-u and
  alt-sysrq-b (blessed be he who invented alt-sysrq-<command>). After
  boot I went back to my "make menuconfig" and stared for ... 15s, when I
  found this: "IDE ACPI support" (boy do I feel silly).
  
  Reboot, play, echo "mem" >/sys/power/state ... [5s] ... power up. Ta-da!
  Everything works. Well, maybe the audio needed a little "jolt" (turn sound
  off, back on, move the volume a bit and voila!).

  I've attached the dmesg, again, maybe someone spots something bad.

  Thanks,

-- 
Mihai Donțu

--Boundary-00=_2qS9GBVmZvdHPiE
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-dbg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-dbg.txt"

[    0.000000] Linux version 2.6.23-rc7 (root@mdontu-l) (gcc version 4.1.2 (Gentoo 4.1.2)) #5 PREEMPT Sat Sep 22 17:20:57 EEST 2007
[    0.000000] Command line: vga=791 nohz=on
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000037fd0000 - 0000000037fefc00 (reserved)
[    0.000000]  BIOS-e820: 0000000037fefc00 - 0000000037ffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000037ffb000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FE270, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     22110520 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 7489 (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF71D9, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1974 pages reserved
[    0.000000]   DMA zone: 1969 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfec01000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 224122
[    0.000000] Kernel command line: vga=791 nohz=on
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   13.869845] time.c: Detected 2194.582 MHz processor.
[   13.869898] Console: colour dummy device 80x25
[   13.869901] console [tty0] enabled
[   13.871357] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   13.872299] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   13.886472] Memory: 894616k/917312k available (4284k kernel code, 22048k reserved, 1900k data, 236k init)
[   13.945722] Calibrating delay using timer specific routine.. 4391.74 BogoMIPS (lpj=2195874)
[   13.945778] Mount-cache hash table entries: 256
[   13.945924] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   13.945929] CPU: L2 Cache: 1024K (64 bytes/line)
[   13.945945] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   13.945964] ACPI: Core revision 20070126
[   13.948938] Parsing all Control Methods:
[   13.949065] Table [DSDT](id 0001) - 941 Objects with 106 Devices 293 Methods 26 Regions
[   13.949110] Parsing all Control Methods:
[   13.949231] Table [SSDT](id 0002) - 8 Objects with 0 Devices 6 Methods 0 Regions
[   13.949241]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[   13.982391] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[   13.992836] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   14.002838] Using local APIC timer interrupts.
[   14.048350] result 12469217
[   14.048355] Detected 12.469 MHz APIC timer.
[   14.048757] NET: Registered protocol family 16
[   14.048953] No dock devices found.
[   14.049019] ACPI: bus type pci registered
[   14.053848] PCI: Using MMCONFIG at e0000000 - efffffff
[   14.053898] PCI: No mmconfig possible on device 00:18
[   14.056999] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
[   14.057227] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 9 Runtime GPEs in this block
[   14.057245] ACPI: EC: Look up EC in DSDT
[   14.057345] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   14.066501] Completing Region/Field/Buffer/Package initialization:......................................................................................................
[   14.067944] Initialized 22/26 Regions 0/0 Fields 29/30 Buffers 51/59 Packages (958 nodes)
[   14.067954] Initializing Device/Processor/Thermal objects by executing _INI methods:......
[   14.076151] Executed 6 _INI methods requiring 2 _STA executions (examined 112 objects)
[   14.076170] ACPI: Interpreter enabled
[   14.076174] ACPI: (supports S0 S3)
[   14.076187] ACPI: Using IOAPIC for interrupt routing
[   14.084438] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   14.084487] ACPI: PCI Root Bridge [C047] (0000:00)
[   14.085907] PCI: Transparent bridge - 0000:00:14.4
[   14.085991] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   14.086200] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   14.086284] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   14.099721] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   14.099855] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   14.099985] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   14.100115] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   14.100247] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   14.100378] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   14.100514] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   14.100654] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   14.100767] ACPI: Power Resource [C1CF] (off)
[   14.100917] ACPI: Power Resource [C1B7] (on)
[   14.100957] ACPI: Power Resource [C1C7] (on)
[   14.101035] ACPI: Power Resource [C26C] (off)
[   14.101109] ACPI: Power Resource [C26D] (off)
[   14.101183] ACPI: Power Resource [C26E] (off)
[   14.101257] ACPI: Power Resource [C26F] (off)
[   14.101294] Linux Plug and Play Support v0.97 (c) Adam Belay
[   14.101318] pnp: PnP ACPI init
[   14.101326] ACPI: bus type pnp registered
[   14.108560] pnp: PnP ACPI: found 12 devices
[   14.108565] ACPI: ACPI bus type pnp unregistered
[   14.108751] SCSI subsystem initialized
[   14.108773] libata version 2.21 loaded.
[   14.108862] usbcore: registered new interface driver usbfs
[   14.108908] usbcore: registered new interface driver hub
[   14.108940] usbcore: registered new device driver usb
[   14.109093] PCI: Using ACPI for IRQ routing
[   14.109099] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   14.109110] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   14.109114] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   14.109119] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   14.109124] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   14.109128] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   14.109133] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   14.112486] Bluetooth: Core ver 2.11
[   14.112533] NET: Registered protocol family 31
[   14.112538] Bluetooth: HCI device and connection manager initialized
[   14.112543] Bluetooth: HCI socket layer initialized
[   14.112547] NET: Registered protocol family 8
[   14.112551] NET: Registered protocol family 20
[   14.113468] Time: tsc clocksource has been installed.
[   14.115489] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   14.115495] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   14.115500] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   14.115510] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   14.115515] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   14.115519] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   14.115525] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   14.115532] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   14.115541] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   14.115546] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   14.115552] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   14.115559] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   14.115566] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   14.115571] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   14.115578] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   14.115810] PCI: Bridge: 0000:00:01.0
[   14.115816]   IO window: 2000-2fff
[   14.115820]   MEM window: d0400000-d07fffff
[   14.115824]   PREFETCH window: c0000000-cfffffff
[   14.115828] PCI: Bridge: 0000:00:04.0
[   14.115831]   IO window: disabled.
[   14.115835]   MEM window: disabled.
[   14.115838]   PREFETCH window: disabled.
[   14.115842] PCI: Bridge: 0000:00:05.0
[   14.115845]   IO window: disabled.
[   14.115849]   MEM window: disabled.
[   14.115853]   PREFETCH window: disabled.
[   14.115859] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   14.115863]   IO window: 00001000-000010ff
[   14.115867]   IO window: 00001400-000014ff
[   14.115870]   PREFETCH window: 50000000-53ffffff
[   14.115874]   MEM window: 54000000-57ffffff
[   14.115878] PCI: Bridge: 0000:00:14.4
[   14.115883]   IO window: 1000-1fff
[   14.115887]   MEM window: d0000000-d03fffff
[   14.115891]   PREFETCH window: 50000000-53ffffff
[   14.115907] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   14.115913] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   14.115938] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   14.115968] NET: Registered protocol family 2
[   14.124482] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   14.124885] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   14.127023] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   14.127563] TCP: Hash tables configured (established 131072 bind 65536)
[   14.127569] TCP reno registered
[   14.131334] VFS: Disk quotas dquot_6.5.1
[   14.131352] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   14.131473] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   14.131739] NTFS driver 2.1.28 [Flags: R/O].
[   14.131772] fuse init (API version 7.8)
[   14.131929] io scheduler noop registered
[   14.131934] io scheduler anticipatory registered
[   14.131938] io scheduler deadline registered
[   14.131950] io scheduler cfq registered (default)
[   14.131958] PCI: MSI quirk detected. MSI deactivated.
[   14.133140] Boot video device is 0000:01:05.0
[   14.133289] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   14.133304] assign_interrupt_mode Found MSI capability
[   14.133315] Allocate Port Service[0000:00:04.0:pcie00]
[   14.133345] Allocate Port Service[0000:00:04.0:pcie01]
[   14.133372] Allocate Port Service[0000:00:04.0:pcie02]
[   14.133414] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   14.133428] assign_interrupt_mode Found MSI capability
[   14.133434] Allocate Port Service[0000:00:05.0:pcie00]
[   14.133510] Allocate Port Service[0000:00:05.0:pcie01]
[   14.133533] Allocate Port Service[0000:00:05.0:pcie02]
[   14.133631] AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
[   14.133649] AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
[   14.133719] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 3072k, total 131072k
[   14.133727] vesafb: mode is 1024x768x16, linelength=2048, pages=84
[   14.133732] vesafb: scrolling: redraw
[   14.133736] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   14.142735] Console: switching to colour frame buffer device 128x48
[   14.150839] fb0: VESA VGA frame buffer device
[   14.152787] ACPI: AC Adapter [C177] (on-line)
[   14.153058] ACPI: Battery Slot [C179] (battery present)
[   14.153313] ACPI: Battery Slot [C178] (battery absent)
[   14.153503] input: Power Button (FF) as /class/input/input0
[   14.153599] ACPI: Power Button (FF) [PWRF]
[   14.153732] input: Sleep Button (CM) as /class/input/input1
[   14.153827] ACPI: Sleep Button (CM) [C1F0]
[   14.153952] input: Lid Switch as /class/input/input2
[   14.154036] ACPI: Lid Switch [C1F1]
[   14.154262] ACPI: Transitioning device [C270] to D3
[   14.154345] ACPI: Transitioning device [C270] to D3
[   14.154434] ACPI: Fan [C270] (off)
[   14.154625] ACPI: Transitioning device [C271] to D3
[   14.154709] ACPI: Transitioning device [C271] to D3
[   14.154793] ACPI: Fan [C271] (off)
[   14.154983] ACPI: Transitioning device [C272] to D3
[   14.155067] ACPI: Transitioning device [C272] to D3
[   14.156277] ACPI: Fan [C272] (off)
[   14.157645] ACPI: Transitioning device [C273] to D3
[   14.158951] ACPI: Transitioning device [C273] to D3
[   14.160264] ACPI: Fan [C273] (off)
[   14.161930] input: Video Bus as /class/input/input3
[   14.163356] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   14.165144] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   14.166739] ACPI: Processor [C000] (supports 8 throttling states)
[   14.175722] ACPI: Thermal Zone [TZ1] (63 C)
[   14.180851] ACPI: Thermal Zone [TZ2] (51 C)
[   14.190121] ACPI: Thermal Zone [TZ3] (27 C)
[   14.208885] Real Time Clock Driver v1.12ac
[   14.210828] Non-volatile memory driver v1.2
[   14.212671] Linux agpgart interface v0.102
[   14.214601] ipmi message handler version 39.1
[   14.216530] ipmi device interface
[   14.218530] IPMI System Interface driver.
[   14.229331] ipmi_si: Unable to find any System Interface(s)
[   14.231430] IPMI Watchdog: driver initialized
[   14.233571] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   14.235873] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   14.238319] Hangcheck: Using get_cycles().
[   14.240790] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   14.243799] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   14.246456] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   14.249452] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   14.252332] loop: module loaded
[   14.255116] nbd: registered device at major 43
[   14.258347] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   14.261191] tg3.c:v3.81 (September 5, 2007)
[   14.263964] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   14.297066] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   14.302969] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   14.306027] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   14.309165] PPP generic driver version 2.4.2
[   14.312322] PPP Deflate Compression module registered
[   14.315456] PPP BSD Compression module registered
[   14.318644] PPP MPPE Compression module registered
[   14.321834] NET: Registered protocol family 24
[   14.325099] tun: Universal TUN/TAP device driver, 1.6
[   14.328321] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   14.331656] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   14.335000] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   14.338468] ATIIXP: IDE controller at PCI slot 0000:00:14.1
[   14.341982] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   14.345569] ATIIXP: chipset revision 0
[   14.349104] ATIIXP: not 100% native mode: will probe irqs later
[   14.352664]     ide0: BM-DMA at 0x3010-0x3017, BIOS settings: hda:DMA, hdb:pio
[   14.356276]     ide1: BM-DMA at 0x3018-0x301f, BIOS settings: hdc:DMA, hdd:pio
[   14.359824] Probing IDE interface ide0...
[   14.402042] Marking TSC unstable due to TSC halts in C3
[   14.405578] Time: acpi_pm clocksource has been installed.
[   14.629144] hda: FUJITSU MHV2080AH, ATA DISK drive
[   15.248425] hda: selected mode 0x45
[   15.252953] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   15.268966] Probing IDE interface ide1...
[   15.940215] hdc: MATSHITAUJ-840D, ATAPI CD/DVD-ROM drive
[   16.249596] hdc: selected mode 0x22
[   16.249993] ide1 at 0x170-0x177,0x376 on irq 15
[   16.256242] hda: max request size: 128KiB
[   16.259932] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
[   16.268287] hda: cache flushes supported
[   16.272133]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
[   16.329385] hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, (U)DMA
[   16.333299] Uniform CD-ROM driver Revision: 3.20
[   16.341129] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   16.395134] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   16.403032] ieee1394: raw1394: /dev/raw1394 device initialized
[   16.406974] usbmon: debugfs is not available
[   16.410907] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   16.415250] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   16.419290] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   16.423307] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   16.427227] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   16.431290] usb usb1: configuration #1 chosen from 1 choice
[   16.435211] hub 1-0:1.0: USB hub found
[   16.438982] hub 1-0:1.0: 8 ports detected
[   16.542988] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   16.543025] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   16.546875] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   16.550622] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   16.554304] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   16.612896] usb usb2: configuration #1 chosen from 1 choice
[   16.616589] hub 2-0:1.0: USB hub found
[   16.620242] hub 2-0:1.0: 4 ports detected
[   16.724686] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   16.728528] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   16.732346] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   16.736069] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   16.794655] usb usb3: configuration #1 chosen from 1 choice
[   16.798284] hub 3-0:1.0: USB hub found
[   16.801827] hub 3-0:1.0: 4 ports detected
[   16.990202] usb 1-5: new high speed USB device using ehci_hcd and address 3
[   17.110264] usb 1-5: configuration #1 chosen from 1 choice
[   17.725224] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   17.795007] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   17.933078] usb 3-1: configuration #1 chosen from 1 choice
[   18.153475] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   18.298590] usb 3-3: configuration #1 chosen from 1 choice
[   18.303648] usbcore: registered new interface driver usblp
[   18.307251] Initializing USB Mass Storage driver...
[   18.310888] scsi0 : SCSI emulation for USB Mass Storage devices
[   18.314528] usb-storage: device found at 3
[   18.314529] usb-storage: waiting for device to settle before scanning
[   18.314542] usbcore: registered new interface driver usb-storage
[   18.318166] USB Mass Storage support registered.
[   18.321790] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   18.327193] i8042.c: Detected active multiplexing controller, rev 1.1.
[   18.331597] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.335242] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   18.338837] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   18.342352] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   18.345718] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   18.348977] mice: PS/2 mouse device common for all mice
[   18.374096] input: AT Translated Set 2 keyboard as /class/input/input4
[   18.387702] input: PC Speaker as /class/input/input5
[   18.999188] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   19.041573] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   19.047672] I2O subsystem v1.325
[   19.050877] i2o: max drivers = 8
[   19.054136] I2O Configuration OSM v1.323
[   19.057291] I2O Bus Adapter OSM v1.317
[   19.060419] I2O Block Device OSM v1.325
[   19.063595] I2O SCSI Peripheral OSM v1.316
[   19.066679] I2O ProcFS OSM v1.316
[   19.069707] i2c /dev entries driver
[   19.072993] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   19.076092] sc1200wdt: build 20020303
[   19.079150] sc1200wdt: io parameter must be specified
[   19.082212] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   19.085370] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   19.088563] Bluetooth: HCI USB driver ver 2.9
[   19.091720] usbcore: registered new interface driver hci_usb
[   19.094878] Bluetooth: Virtual HCI driver ver 1.2
[   19.098042] Bluetooth: HCI UART driver ver 2.2
[   19.101148] Bluetooth: HCI H4 protocol initialized
[   19.104239] Bluetooth: HCI BCSP protocol initialized
[   19.107336] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   19.110447] usbcore: registered new interface driver bcm203x
[   19.113527] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   19.116613] usbcore: registered new interface driver bpa10x
[   19.119674] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   19.122741] usbcore: registered new interface driver bfusb
[   19.125788] EDAC MC: Ver: 2.1.0 Sep 22 2007
[   19.128997] sdhci: Secure Digital Host Controller Interface driver
[   19.132059] sdhci: Copyright(c) Pierre Ossman
[   19.135103] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   19.138203] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   19.141859] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   19.145197] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   19.148399] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   19.151321] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   19.154249] wbsd: Copyright(c) Pierre Ossman
[   19.157285] usbcore: registered new interface driver hiddev
[   19.167571] input: Logitech USB Receiver as /class/input/input7
[   19.170750] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   19.173933] usbcore: registered new interface driver usbhid
[   19.177092] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   19.180297] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   19.183732] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   19.196826] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   19.302815] MC'97 0 converters and GPIO not ready (0x1)
[   19.306618] ALSA device list:
[   19.309758]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   19.313000]   #1: ATI IXP Modem rev 2 at 0xd0805000, irq 17
[   19.316284] oprofile: using NMI interrupt.
[   19.319567] Netfilter messages via NETLINK v0.30.
[   19.322877] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.326215] arp_tables: (C) 2002 David S. Miller
[   19.329486] TCP cubic registered
[   19.332694] NET: Registered protocol family 1
[   19.335955] NET: Registered protocol family 10
[   19.339167] lo: Disabled Privacy Extensions
[   19.342305] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   19.345379] IPv6 over IPv4 tunneling driver
[   19.348484] sit0: Disabled Privacy Extensions
[   19.351575] NET: Registered protocol family 17
[   19.354621] Bluetooth: L2CAP ver 2.8
[   19.357657] Bluetooth: L2CAP socket layer initialized
[   19.360719] Bluetooth: SCO (Voice Link) ver 0.5
[   19.363764] Bluetooth: SCO socket layer initialized
[   19.366785] Bluetooth: RFCOMM socket layer initialized
[   19.369783] Bluetooth: RFCOMM TTY layer initialized
[   19.372732] Bluetooth: RFCOMM ver 1.8
[   19.375622] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   19.378516] Bluetooth: BNEP filters: protocol multicast
[   19.381395] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   19.384301] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   19.387199] All bugs added by David S. Miller <davem@redhat.com>
[   19.390121] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   19.393016] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   19.395947] ieee80211_crypt: registered algorithm 'NULL'
[   19.395949] ieee80211_crypt: registered algorithm 'WEP'
[   19.395951] ieee80211_crypt: registered algorithm 'CCMP'
[   19.395953] ieee80211_crypt: registered algorithm 'TKIP'
[   19.395977] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (1 cpu cores) (version 2.00.00)
[   19.402041] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   19.405181] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   19.408256] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   19.411277] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   19.414246] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   19.417202] powernow-k8: ph2 null fid transition 0xe
[   19.420217] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   19.440678] kjournald starting.  Commit interval 5 seconds
[   19.443541] EXT3-fs: mounted filesystem with ordered data mode.
[   19.446368] VFS: Mounted root (ext3 filesystem) readonly.
[   19.449138] Freeing unused kernel memory: 236k freed
[   23.974665] EXT3 FS on hda7, internal journal
[   24.007738] scsi 0:0:0:0: Direct-Access     ST350064 1A               3.AA PQ: 0 ANSI: 0
[   24.009211] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   24.010218] sd 0:0:0:0: [sda] Write Protect is off
[   24.010220] sd 0:0:0:0: [sda] Mode Sense: 10 00 00 00
[   24.010222] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   24.011082] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   24.012089] sd 0:0:0:0: [sda] Write Protect is off
[   24.012091] sd 0:0:0:0: [sda] Mode Sense: 10 00 00 00
[   24.012093] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   24.012096]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   24.122740] sd 0:0:0:0: [sda] Attached SCSI disk
[   24.122779] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   24.122961] usb-storage: device scan complete
[   24.443466] kjournald starting.  Commit interval 5 seconds
[   24.443748] EXT3 FS on hda8, internal journal
[   24.443753] EXT3-fs: mounted filesystem with ordered data mode.
[   24.493197] NTFS volume version 3.1.
[   24.592783] Adding 1791208k swap on /dev/hda6.  Priority:-1 extents:1 across:1791208k
[   38.321872] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.889359] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   39.889365] tg3: eth0: Flow control is on for TX and on for RX.
[   39.890841] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   50.778146] eth0: no IPv6 routers present
[   53.201550] APIC error on CPU0: 00(40)
[   75.697327] Stopping tasks ... done.
[   75.709893] Suspending console(s)
[   77.173744] ACPI handle has no context!
[   77.173932] ACPI handle has no context!
[   77.173956] ACPI: PCI interrupt for device 0000:02:04.4 disabled
[   77.173964] ACPI handle has no context!
[   77.185014] ACPI handle has no context!
[   77.185028] ACPI: PCI interrupt for device 0000:02:04.3 disabled
[   77.185035] ACPI handle has no context!
[   77.196028] ACPI handle has no context!
[   77.486859] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   77.487784] ACPI: PCI interrupt for device 0000:00:14.5 disabled
[   77.488010] ACPI: PCI interrupt for device 0000:00:13.2 disabled
[   77.498560] ACPI: PCI interrupt for device 0000:00:13.1 disabled
[   77.498608] ACPI: PCI interrupt for device 0000:00:13.0 disabled
[   77.499013] ACPI: Transitioning device [C272] to D0
[   77.499015] ACPI: Transitioning device [C272] to D0
[   77.499365] ACPI: Transitioning device [C271] to D0
[   77.499367] ACPI: Transitioning device [C271] to D0
[   77.499725] ACPI: Transitioning device [C270] to D0
[   77.499726] ACPI: Transitioning device [C270] to D0
[   77.500815]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
[    0.172399] Back to C!
[    0.207043] ACPI: Transitioning device [C270] to D3
[    0.207045] ACPI: Transitioning device [C270] to D3
[    0.207177] ACPI: Transitioning device [C271] to D3
[    0.207179] ACPI: Transitioning device [C271] to D3
[    0.207312] ACPI: Transitioning device [C272] to D3
[    0.207313] ACPI: Transitioning device [C272] to D3
[    0.207445] ACPI: Transitioning device [C273] to D3
[    0.207447] ACPI: Transitioning device [C273] to D3
[    0.213703] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 22202121, writing 2202121)
[    0.213717] PM: Writing back config space on device 0000:00:04.0 at offset 9 (was 0, writing fff0)
[    0.213720] PM: Writing back config space on device 0000:00:04.0 at offset 8 (was 0, writing fff0)
[    0.213723] PM: Writing back config space on device 0000:00:04.0 at offset 7 (was 101, writing 1f1)
[    0.213726] PM: Writing back config space on device 0000:00:04.0 at offset 3 (was 10000, writing 10010)
[    0.213729] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was 100000, writing 100004)
[    0.213736] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.213744] PM: Writing back config space on device 0000:00:05.0 at offset 9 (was 0, writing fff0)
[    0.213746] PM: Writing back config space on device 0000:00:05.0 at offset 8 (was 0, writing fff0)
[    0.213749] PM: Writing back config space on device 0000:00:05.0 at offset 7 (was 101, writing 1f1)
[    0.213752] PM: Writing back config space on device 0000:00:05.0 at offset 3 (was 10000, writing 10010)
[    0.213755] PM: Writing back config space on device 0000:00:05.0 at offset 1 (was 100000, writing 100004)
[    0.213762] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.213774] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.213825] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[    0.224519] PCI: Enabling device 0000:00:13.2 (0000 -> 0002)
[    0.224521] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[    0.224559] PM: Writing back config space on device 0000:00:13.2 at offset 1 (was 2b00006, writing 2b00017)
[    0.224620] PM: Writing back config space on device 0000:00:14.1 at offset f (was 100, writing 10a)
[    0.224634] PM: Writing back config space on device 0000:00:14.1 at offset 8 (was 1, writing 3011)
[    0.224644] PM: Writing back config space on device 0000:00:14.1 at offset 3 (was 0, writing 4010)
[    0.224650] PM: Writing back config space on device 0000:00:14.1 at offset 1 (was 2300000, writing 2300005)
[    0.224668] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[    0.224719] PM: Writing back config space on device 0000:00:14.4 at offset 3 (was 816000, writing 814000)
[    0.224748] PM: Writing back config space on device 0000:00:14.5 at offset f (was 20200, writing 20205)
[    0.224768] PM: Writing back config space on device 0000:00:14.5 at offset 4 (was 0, writing d0804000)
[    0.224772] PM: Writing back config space on device 0000:00:14.5 at offset 3 (was 800000, writing 804010)
[    0.224779] PM: Writing back config space on device 0000:00:14.5 at offset 1 (was 4300000, writing 4300002)
[    0.224797] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[    0.225825] atiixp: codec reset timeout
[    0.227598] PM: Writing back config space on device 0000:00:14.6 at offset f (was 20200, writing 20205)
[    0.227618] PM: Writing back config space on device 0000:00:14.6 at offset 4 (was 0, writing d0805000)
[    0.227622] PM: Writing back config space on device 0000:00:14.6 at offset 3 (was 800000, writing 804010)
[    0.227628] PM: Writing back config space on device 0000:00:14.6 at offset 1 (was 4300000, writing 4300003)
[    0.227647] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[    0.228215] PM: Writing back config space on device 0000:02:01.0 at offset c (was 0, writing fff70000)
[    0.228241] PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
[    0.230185] tg3: eth0: Link is down.
[    0.527454] PM: Writing back config space on device 0000:02:02.0 at offset f (was 100, writing 105)
[    0.527478] PM: Writing back config space on device 0000:02:02.0 at offset 4 (was 0, writing d0010000)
[    0.527483] PM: Writing back config space on device 0000:02:02.0 at offset 3 (was 0, writing 4000)
[    0.527490] PM: Writing back config space on device 0000:02:02.0 at offset 1 (was 0, writing 6)
[    0.527508] PM: Writing back config space on device 0000:02:04.0 at offset f (was 34001ff, writing 344010b)
[    0.527513] PM: Writing back config space on device 0000:02:04.0 at offset e (was 0, writing 14fc)
[    0.527519] PM: Writing back config space on device 0000:02:04.0 at offset d (was 0, writing 1400)
[    0.527524] PM: Writing back config space on device 0000:02:04.0 at offset c (was 0, writing 10fc)
[    0.527530] PM: Writing back config space on device 0000:02:04.0 at offset b (was 0, writing 1000)
[    0.527535] PM: Writing back config space on device 0000:02:04.0 at offset a (was 0, writing 57fff000)
[    0.527541] PM: Writing back config space on device 0000:02:04.0 at offset 9 (was 0, writing 54000000)
[    0.527546] PM: Writing back config space on device 0000:02:04.0 at offset 8 (was 0, writing 53fff000)
[    0.527552] PM: Writing back config space on device 0000:02:04.0 at offset 7 (was 0, writing 50000000)
[    0.527557] PM: Writing back config space on device 0000:02:04.0 at offset 6 (was 0, writing b0060302)
[    0.527565] PM: Writing back config space on device 0000:02:04.0 at offset 4 (was 0, writing d0012000)
[    0.527570] PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 820000, writing 824010)
[    0.527578] PM: Writing back config space on device 0000:02:04.0 at offset 1 (was 2100000, writing 2100007)
[    0.527606] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.538060] PM: Writing back config space on device 0000:02:04.2 at offset f (was 4020300, writing 4020309)
[    0.538084] PM: Writing back config space on device 0000:02:04.2 at offset 5 (was 0, writing d0014000)
[    0.538089] PM: Writing back config space on device 0000:02:04.2 at offset 4 (was 0, writing d0013000)
[    0.538095] PM: Writing back config space on device 0000:02:04.2 at offset 3 (was 800000, writing 804010)
[    0.538103] PM: Writing back config space on device 0000:02:04.2 at offset 1 (was 2100000, writing 2100006)
[    0.588114] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    0.598969] PM: Writing back config space on device 0000:02:04.3 at offset f (was 40702ff, writing 4070209)
[    0.598994] PM: Writing back config space on device 0000:02:04.3 at offset 4 (was 0, writing d0018000)
[    0.598999] PM: Writing back config space on device 0000:02:04.3 at offset 3 (was 800000, writing 804010)
[    0.599006] PM: Writing back config space on device 0000:02:04.3 at offset 1 (was 2100000, writing 2100006)
[    0.599028] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[    0.609952] PM: Writing back config space on device 0000:02:04.4 at offset f (was 40703ff, writing 4070309)
[    0.609973] PM: Writing back config space on device 0000:02:04.4 at offset 6 (was 0, writing d001c000)
[    0.609978] PM: Writing back config space on device 0000:02:04.4 at offset 5 (was 0, writing d001b000)
[    0.609984] PM: Writing back config space on device 0000:02:04.4 at offset 4 (was 0, writing d001a000)
[    0.609990] PM: Writing back config space on device 0000:02:04.4 at offset 3 (was 800000, writing 804010)
[    0.609997] PM: Writing back config space on device 0000:02:04.4 at offset 1 (was 2100000, writing 2100006)
[    0.610018] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[    1.584596] hda: selected mode 0x45
[    1.593379] hdc: selected mode 0x22
[    2.181344] tg3: eth0: Link is up at 100 Mbps, full duplex.
[    2.181346] tg3: eth0: Flow control is on for TX and on for RX.
[    2.368411] Restarting tasks ... done.
[  157.369871] Stopping tasks ... done.
[  157.413812] Suspending console(s)
[  158.508505] ACPI handle has no context!
[  158.508613] ACPI handle has no context!
[  158.508625] ACPI: PCI interrupt for device 0000:02:04.4 disabled
[  158.508629] ACPI handle has no context!
[  158.512347] ACPI handle has no context!
[  158.512354] ACPI: PCI interrupt for device 0000:02:04.3 disabled
[  158.512358] ACPI handle has no context!
[  158.516351] ACPI handle has no context!
[  158.622118] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[  158.622938] ACPI: PCI interrupt for device 0000:00:14.5 disabled
[  158.623029] ACPI: PCI interrupt for device 0000:00:13.2 disabled
[  158.626730] ACPI: PCI interrupt for device 0000:00:13.1 disabled
[  158.626750] ACPI: PCI interrupt for device 0000:00:13.0 disabled
[  158.627134] ACPI: Transitioning device [C273] to D0
[  158.627136] ACPI: Transitioning device [C273] to D0
[  158.627489] ACPI: Transitioning device [C272] to D0
[  158.627491] ACPI: Transitioning device [C272] to D0
[  158.627842] ACPI: Transitioning device [C271] to D0
[  158.627844] ACPI: Transitioning device [C271] to D0
[  158.628195] ACPI: Transitioning device [C270] to D0
[  158.628197] ACPI: Transitioning device [C270] to D0
[  158.628726]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
[    0.172376] Back to C!
[    0.189338] ACPI: Transitioning device [C270] to D3
[    0.189340] ACPI: Transitioning device [C270] to D3
[    0.189476] ACPI: Transitioning device [C271] to D3
[    0.189478] ACPI: Transitioning device [C271] to D3
[    0.189611] ACPI: Transitioning device [C272] to D3
[    0.189612] ACPI: Transitioning device [C272] to D3
[    0.189745] ACPI: Transitioning device [C273] to D3
[    0.189747] ACPI: Transitioning device [C273] to D3
[    0.192628] PM: Writing back config space on device 0000:00:04.0 at offset 9 (was 0, writing fff0)
[    0.192631] PM: Writing back config space on device 0000:00:04.0 at offset 8 (was 0, writing fff0)
[    0.192634] PM: Writing back config space on device 0000:00:04.0 at offset 7 (was 101, writing 1f1)
[    0.192637] PM: Writing back config space on device 0000:00:04.0 at offset 3 (was 10000, writing 10010)
[    0.192639] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was 100000, writing 100004)
[    0.192644] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.192649] PM: Writing back config space on device 0000:00:05.0 at offset 9 (was 0, writing fff0)
[    0.192652] PM: Writing back config space on device 0000:00:05.0 at offset 8 (was 0, writing fff0)
[    0.192654] PM: Writing back config space on device 0000:00:05.0 at offset 7 (was 101, writing 1f1)
[    0.192657] PM: Writing back config space on device 0000:00:05.0 at offset 3 (was 10000, writing 10010)
[    0.192660] PM: Writing back config space on device 0000:00:05.0 at offset 1 (was 100000, writing 100004)
[    0.192664] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.192670] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.192692] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[    0.196376] PCI: Enabling device 0000:00:13.2 (0000 -> 0002)
[    0.196378] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[    0.196395] PM: Writing back config space on device 0000:00:13.2 at offset 1 (was 2b00006, writing 2b00017)
[    0.196421] PM: Writing back config space on device 0000:00:14.1 at offset f (was 100, writing 10a)
[    0.196427] PM: Writing back config space on device 0000:00:14.1 at offset 8 (was 1, writing 3011)
[    0.196433] PM: Writing back config space on device 0000:00:14.1 at offset 3 (was 0, writing 4010)
[    0.196437] PM: Writing back config space on device 0000:00:14.1 at offset 1 (was 2300000, writing 2300005)
[    0.196445] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[    0.196467] PM: Writing back config space on device 0000:00:14.4 at offset 3 (was 816000, writing 814000)
[    0.196480] PM: Writing back config space on device 0000:00:14.5 at offset f (was 20200, writing 20205)
[    0.196489] PM: Writing back config space on device 0000:00:14.5 at offset 4 (was 0, writing d0804000)
[    0.196492] PM: Writing back config space on device 0000:00:14.5 at offset 3 (was 800000, writing 804010)
[    0.196496] PM: Writing back config space on device 0000:00:14.5 at offset 1 (was 4300000, writing 4300002)
[    0.196505] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[    0.196880] atiixp: codec reset timeout
[    0.197559] PM: Writing back config space on device 0000:00:14.6 at offset f (was 20200, writing 20205)
[    0.197568] PM: Writing back config space on device 0000:00:14.6 at offset 4 (was 0, writing d0805000)
[    0.197571] PM: Writing back config space on device 0000:00:14.6 at offset 3 (was 800000, writing 804010)
[    0.197575] PM: Writing back config space on device 0000:00:14.6 at offset 1 (was 4300000, writing 4300003)
[    0.197584] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[    0.197808] PM: Writing back config space on device 0000:02:01.0 at offset c (was 0, writing fff70000)
[    0.197819] PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
[    0.198535] tg3: eth0: Link is down.
[    0.306831] PM: Writing back config space on device 0000:02:02.0 at offset f (was 100, writing 105)
[    0.306842] PM: Writing back config space on device 0000:02:02.0 at offset 4 (was 0, writing d0010000)
[    0.306845] PM: Writing back config space on device 0000:02:02.0 at offset 3 (was 0, writing 4000)
[    0.306849] PM: Writing back config space on device 0000:02:02.0 at offset 1 (was 0, writing 6)
[    0.306858] PM: Writing back config space on device 0000:02:04.0 at offset f (was 34001ff, writing 344010b)
[    0.306861] PM: Writing back config space on device 0000:02:04.0 at offset e (was 0, writing 14fc)
[    0.306865] PM: Writing back config space on device 0000:02:04.0 at offset d (was 0, writing 1400)
[    0.306868] PM: Writing back config space on device 0000:02:04.0 at offset c (was 0, writing 10fc)
[    0.306872] PM: Writing back config space on device 0000:02:04.0 at offset b (was 0, writing 1000)
[    0.306875] PM: Writing back config space on device 0000:02:04.0 at offset a (was 0, writing 57fff000)
[    0.306879] PM: Writing back config space on device 0000:02:04.0 at offset 9 (was 0, writing 54000000)
[    0.306882] PM: Writing back config space on device 0000:02:04.0 at offset 8 (was 0, writing 53fff000)
[    0.306886] PM: Writing back config space on device 0000:02:04.0 at offset 7 (was 0, writing 50000000)
[    0.306889] PM: Writing back config space on device 0000:02:04.0 at offset 6 (was 0, writing b0060302)
[    0.306893] PM: Writing back config space on device 0000:02:04.0 at offset 4 (was 0, writing d0012000)
[    0.306897] PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 820000, writing 824010)
[    0.306901] PM: Writing back config space on device 0000:02:04.0 at offset 1 (was 2100000, writing 2100007)
[    0.306915] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.310754] PM: Writing back config space on device 0000:02:04.2 at offset f (was 4020300, writing 4020309)
[    0.310765] PM: Writing back config space on device 0000:02:04.2 at offset 5 (was 0, writing d0014000)
[    0.310768] PM: Writing back config space on device 0000:02:04.2 at offset 4 (was 0, writing d0013000)
[    0.310772] PM: Writing back config space on device 0000:02:04.2 at offset 3 (was 800000, writing 804010)
[    0.310776] PM: Writing back config space on device 0000:02:04.2 at offset 1 (was 2100000, writing 2100006)
[    0.328966] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    0.332902] PM: Writing back config space on device 0000:02:04.3 at offset f (was 40702ff, writing 4070209)
[    0.332913] PM: Writing back config space on device 0000:02:04.3 at offset 4 (was 0, writing d0018000)
[    0.332917] PM: Writing back config space on device 0000:02:04.3 at offset 3 (was 800000, writing 804010)
[    0.332921] PM: Writing back config space on device 0000:02:04.3 at offset 1 (was 2100000, writing 2100006)
[    0.332931] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[    0.336896] PM: Writing back config space on device 0000:02:04.4 at offset f (was 40703ff, writing 4070309)
[    0.336906] PM: Writing back config space on device 0000:02:04.4 at offset 6 (was 0, writing d001c000)
[    0.336909] PM: Writing back config space on device 0000:02:04.4 at offset 5 (was 0, writing d001b000)
[    0.336913] PM: Writing back config space on device 0000:02:04.4 at offset 4 (was 0, writing d001a000)
[    0.336916] PM: Writing back config space on device 0000:02:04.4 at offset 3 (was 800000, writing 804010)
[    0.336920] PM: Writing back config space on device 0000:02:04.4 at offset 1 (was 2100000, writing 2100006)
[    0.336930] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[    0.696248] hda: selected mode 0x45
[    0.701022] hdc: selected mode 0x22
[    0.877622] tg3: eth0: Link is up at 100 Mbps, full duplex.
[    0.877623] tg3: eth0: Flow control is on for TX and on for RX.
[    0.981908] Restarting tasks ... done.
[    7.368758] Hangcheck: hangcheck value past margin!

--Boundary-00=_2qS9GBVmZvdHPiE--
