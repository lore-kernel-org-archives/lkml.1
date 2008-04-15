Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbYDOVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbYDOVM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYDOVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:12:49 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:47739 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYDOVMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:12:46 -0400
Message-ID: <48051A4A.5090200@free.fr>
Date: Tue, 15 Apr 2008 23:12:42 +0200
From: Bernard Pidoux <bpidoux@free.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] sleeping function called from invalid context in kernel 2.6.24.4
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a BUG report captured using netconsole.
The kernel is 2.6.24.4 with patched AX25 and ROSE modules.
CPU is an Intel Core2 duo.
The only thing I noticed at boot (see in dmesg output included next)
is :

mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.


-------

[bernard@bernard ~]$ nc -u -l -p 5555
<3>BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 2766994
hardirqs last  enabled at (2766993): [<c0313a6d>] mutex_trylock+0xbd/0x170
hardirqs last disabled at (2766994): [<c03156f0>] _spin_lock_irq+0x10/0x60
softirqs last  enabled at (2766912): [<c02c4784>] 
rt_check_expire+0x104/0x190
softirqs last disabled at (2766910): [<c03153af>] _spin_lock_bh+0xf/0x60
Pid: 9, comm: events/0 Tainted: G      D 2.6.24.4-1mnbcustom #1
  [<c01053ba>] show_trace_log_lvl+0x1a/0x30
  [<c0105df2>] show_trace+0x12/0x20
  [<c01067ac>] dump_stack+0x6c/0x80
  [<c0121a98>] __might_sleep+0xc8/0xf0
  [<c03143a9>] down_read+0x19/0x80
  [<c0218689>] pci_get_subsys+0x39/0x100
  [<c021876b>] pci_get_device+0x1b/0x20
  [<c011b190>] mach_reboot_fixups+0x40/0x60
  [<c01155d3>] native_machine_emergency_restart+0x23/0x170
  [<c01154b9>] machine_emergency_restart+0x9/0x10
  [<c0137068>] emergency_restart+0x8/0x10
  [<c01285ad>] panic+0xcd/0x110
  [<c0105828>] die+0x1c8/0x230
  [<c0105921>] do_trap+0x91/0xc0
  [<c0105c38>] do_invalid_op+0x88/0xa0
  [<c0315b8a>] error_code+0x72/0x78
  [<c01863a4>] free_block+0xe4/0x200
  [<c018652c>] drain_array+0x6c/0xb0
  [<c0187bee>] cache_reap+0x9e/0x140
  [<c0139636>] run_workqueue+0x156/0x1d0
  [<c013a2cc>] worker_thread+0x8c/0xf0
  [<c013d4f2>] kthread+0x42/0x70
  [<c0104f9f>] kernel_thread_helper+0x7/0x18
  =======================
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
(...)

I am not sure if the three NOHZ: lines were not sent after the system 
rebooted.

Here is the boot information :


Linux version 2.6.24.4-1mnbcustom (root@f6bvp-7) (gcc version 4.2.3 
(4.2.3-6mnb1)) #1 SMP Sun Apr 13 19:27:44 CEST 2008
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
  BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
  BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
found SMP MP-table at 000f39c0
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   229376
On node 0 totalpages: 229376
   DMA zone: 56 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4040 pages, LIFO batch:0
   Normal zone: 3080 pages used for memmap
   Normal zone: 222200 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F7910, 0014 (r0 P4M890)
ACPI: RSDT 3FEE3040, 0038 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FEE30C0, 0074 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FEE3180, 6A65 (r1 P4M890 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FEE0000, 0040
ACPI: MCFG 3FEE9D40, 003C (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FEE9C40, 0090 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: SSDT 3FEE9DC0, 019E (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
ACPI: SSDT 3FEEA250, 02F1 (r1  PmRef    CpuPm     3000 INTL 20041203)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 3fef0000:a0110000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 226240
Kernel command line: BOOT_IMAGE=2.6.24.4-1mnbcustom 
root=UUID=d01726ab-a7e6-4115-9f08-06c32978ffe5 resume=/dev/hda5 
splash=silent vga=788
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fecc0000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2194.505 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
  memory used by lock dependency info: 1024 kB
  per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 893748k/917504k available (2138k kernel code, 22736k reserved, 
955k data, 536k init, 0k highmem, 0k BadRAM)
virtual kernel memory layout:
     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
     vmalloc : 0xf8800000 - 0xfffb3000   ( 119 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc040b000 - 0xc0491000   ( 536 kB)
       .data : 0xc031690e - 0xc0405624   ( 955 kB)
       .text : 0xc0100000 - 0xc031690e   (2138 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4396.06 BogoMIPS 
(lpj=8792129)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
Hook version: 2.6.24 2008/01/25
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 
0000e39d 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00003940 0000e39d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
Early unpacking initramfs... done
Freeing initrd memory: 2592k freed
ACPI: Core revision 20070126
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
CPU0: Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4389.30 BogoMIPS 
(lpj=8778610)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 
0000e39d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20000000 00000000 00003940 0000e39d 
00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
Total of 2 processors activated (8785.36 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
khelper used greatest stack depth: 6968 bytes left
net_namespace: 80 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *5
ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x400-0x47f has been reserved
system 00:01: ioport range 0x500-0x50f has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:02: ioport range 0x880-0x88f has been reserved
system 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0e: iomem range 0xcec00-0xcffff has been reserved
system 00:0e: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0e: iomem range 0xfc000-0xfffff could not be reserved
system 00:0e: iomem range 0x3fee0000-0x3fefffff could not be reserved
system 00:0e: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0x100000-0x3fedffff could not be reserved
system 00:0e: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0e: iomem range 0xfff80000-0xfffeffff could not be reserved
PCI: Bridge: 0000:00:01.0
   IO window: 9000-9fff
   MEM window: dfc00000-dfcfffff
   PREFETCH window: dfb00000-dfbfffff
PCI: Bridge: 0000:00:02.0
   IO window: b000-bfff
   MEM window: dc000000-deffffff
   PREFETCH window: c0000000-cfffffff
PCI: Bridge: 0000:00:03.0
   IO window: a000-afff
   MEM window: dfe00000-dfefffff
   PREFETCH window: dfd00000-dfdfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:03.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1208245696.616:1): initialized
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
0000:00:10.4 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
PCI: Bypassing VIA 8237 APIC De-Assert Message
Boot video device is 0000:02:00.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
Allocate Port Service[0000:00:02.0:pcie02]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie01]
Allocate Port Service[0000:00:03.0:pcie02]
Allocate Port Service[0000:00:03.0:pcie03]
Evaluate _OSC returns wrong type
AER service couldn't init device 0000:00:02.0:pcie01 - Run ACPI _OSC fails
Evaluate _OSC returns wrong type
AER service couldn't init device 0000:00:03.0:pcie01 - Run ACPI _OSC fails
vesafb: framebuffer at 0xc0000000, mapped to 0xf8880000, using 1875k, 
total 262144k
vesafb: mode is 800x600x16, linelength=1600, pages=2
vesafb: protected mode interface info at c000:d220
vesafb: pmi: set display start = c00cd256, set palette = c00cd2c0
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 
3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
khelper used greatest stack depth: 6756 bytes left
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 536k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, 
low) -> IRQ 18
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 18, io mem 0xdfffe000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
input: PS/2 Logitech Mouse as /class/input/input1
modprobe used greatest stack depth: 5680 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, 
low) -> IRQ 18
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 18, io base 0x0000dc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, 
low) -> IRQ 18
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 18, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, 
low) -> IRQ 18
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 18, io base 0x0000d400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [ALKB] -> GSI 21 (level, 
low) -> IRQ 18
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 18, io base 0x0000d000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
modprobe used greatest stack depth: 5668 bytes left
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:0f.1
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, 
low) -> IRQ 19
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
     ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hdb: IRQ probe failed (0xfffbedfc)
hdb: IRQ probe failed (0xfffbedfc)
hda: ST340016A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes not supported
  hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
Probing IDE interface ide1...
hdd: Maxtor 6L080P0, ATA DISK drive
hdc: PIONEER DVD-RW DVR-112D, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdd: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdd: max request size: 128KiB
hdd: 160086528 sectors (81964 MB) w/8192KiB Cache, CHS=65535/16/63
hdd: cache flushes supported
  hdd: hdd1 hdd2 < hdd5 >
modprobe used greatest stack depth: 5084 bytes left
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Not activating Mandatory Access Control now since /sbin/ccs-init doesn't 
exist.
awk used greatest stack depth: 5028 bytes left
ACPI: SSDT 3FEEA1C0, 0087 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is 
not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is 
not present [20070126]
input: Power Button (FF) as /class/input/input2
Linux agpgart interface v0.102
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
agpgart: Detected VIA P4M890 chipset
agpgart: AGP aperture is 128M @ 0xd0000000
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SLPB]
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
Uniform CD-ROM driver Revision: 3.20
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 21 (level, low) -> IRQ 18
eth0: RealTek RTL8139 at 0xf8ae2000, 00:16:17:b3:e9:69, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, 
low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.5 to 64
FDC 0 is a post-1991 82077
SCSI subsystem initialized
libata version 3.00 loaded.
sata_via 0000:00:0f.0: version 2.3
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, 
low) -> IRQ 19
sata_via 0000:00:0f.0: routed to hard irq line 11
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xf800 ctl 0xf400 bmdma 0xe800 irq 19
ata2: SATA max UDMA/133 cmd 0xf000 ctl 0xec00 bmdma 0xe808 irq 19
ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
EXT3 FS on hda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdd1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdd5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded
Adding 2747072k swap on /dev/hda5.  Priority:-1 extents:1 across:2747072k
rc.sysinit used greatest stack depth: 4832 bytes left
nf_conntrack version 0.5.0 (14336 buckets, 57344 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
fuse init (API version 7.9)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
netconsole: local port 4444
netconsole: local IP 192.168.0.103
netconsole: interface eth0
netconsole: remote port 5555
netconsole: remote IP 192.168.0.66
netconsole: remote ethernet address 00:00:1c:08:d9:76
console [netcon0] enabled
netconsole: network logging started
eth0: no IPv6 routers present
NET: Registered protocol family 3
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
mkiss: ax0: crc mode is auto.
ADDRCONF(NETDEV_CHANGE): ax0: link becomes ready
NET: Registered protocol family 11
ROSE: socket is bound
fpacstat uses obsolete (PF_INET,SOCK_PACKET)
mkiss: ax0: Trying crc-smack
mkiss: ax0: Trying crc-flexnet



Regards,

Bernard Pidoux
