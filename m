Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbYBPWuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbYBPWuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 17:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYBPWtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 17:49:52 -0500
Received: from www.tglx.de ([62.245.132.106]:41626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYBPWto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:49:44 -0500
X-Return-Path: <kelk1@comcast.net>
X-Authority-Analysis: v=1.0 c=1 a=ZlWJWtZrzcEafByRBEdDrg==:17
 a=_hag0Dem3T9uMMPOHY4A:9 a=n_FH0glXucMeL4Wh_wIA:7
 a=EZUPZ8WHMOyC2TFMKZQPWBaIm4IA:4 a=jEp0ucaQiEUA:10 a=8t_6ZPhla3UA:10
From: kelk1@comcast.net (Quel Qun)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Sat, 16 Feb 2008 21:37:56 +0000
Message-Id: <021620082137.23325.47B757B400051FE100005B1D2209224627CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -------------- Original message ----------------------
From: Thomas Gleixner <tglx@linutronix.de>
> On Sat, 16 Feb 2008, Jiri Kosina wrote:
> > [ Ingo and Thomas added to CC, as this is apparently nohz stuff ]
> 
> Well, it explodes there :) I can not exactly decode the source line,
> but it's either list corruption or something is fiddling with an
> enqueued timer.
> 
> > Quel, does the problem go away when you boot with nohz=off?
> 
> Quel, can you please compile the kernel with CONFIG_DEBUG_INFO=y ?
> 
> Then after a crash, pick the address:
>  
> > > IP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210
> ----------^^^^^^^^
> and run it through:
> 
> # addr2line -e vmlinux c0131f3e
> 
> Please also enable CONFIG_DEBUG_LIST=y, which should catch the place
> where a list corruption happens.
>  

Hi,

Thank you for the hand holding. I must admit I do not anything about kernel debugging.

With or without nohz=off, the crashes are very similar. It looks like it fails to execute list_add_tail(&timer->entry, vec), line 294 of kernel/timer.c.

I hope this helps, let me know if you need more info or want me to try anything else.
--
Eric

nohz=off

list_add corruption. prev->next should be next (c047e704), but was 00000000. (prev=ddcca118).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] SMP
Modules linked in: hidp rfcomm l2cap nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat dm_mod piix ide_core fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm thermal snd_timer processor hci_usb button snd dcdbas i2c_i801 pcspkr soundcore evdev parport_pc i2c_core rtc_cmos sr_mod snd_page_alloc tg3 parport sg bluetooth iTCO_wdt iTCO_vendor_support ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ssb pcmcia pcmcia_core ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc1 #1)
EIP: 0060:[<c020bc4a>] EFLAGS: 00010086 CPU: 1
EIP is at __list_add+0x5a/0x60
EAX: 00000061 EBX: c047f380 ECX: 00000001 EDX: 00000092
ESI: c047f380 EDI: c047dea0 EBP: f7847e14 ESP: f7847e00
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=f7846000 task=f783ec20 task.ti=f7846000)
Stack: c03990d8 c047e704 00000000 ddcca118 000e09c1 f7847e24 c0131776 00000286
       c047f380 f7847e38 c01323a4 c03ca0c0 03ba7837 c03ccf88 f7847ea4 c01434ca
       00000286 f7847e64 c01320cc 000e0aba 114e8f6a 00000000 00140d5e 00000000
Call Trace:
 [<c0131776>] ? internal_add_timer+0x36/0xb0
 [<c01323a4>] ? add_timer_on+0x54/0x70
 [<c01434ca>] ? clocksource_watchdog+0x22a/0x240
 [<c01320cc>] ? __mod_timer+0x9c/0xb0
 [<c01319fd>] ? run_timer_softirq+0x15d/0x1d0
 [<c01432a0>] ? clocksource_watchdog+0x0/0x240
 [<c01432a0>] ? clocksource_watchdog+0x0/0x240
 [<c012d912>] ? __do_softirq+0x82/0x100
 [<c012d9e8>] ? do_softirq+0x58/0x60
 [<c012dd8c>] ? irq_exit+0x5c/0x70
 [<c0115b38>] ? smp_apic_timer_interrupt+0x58/0x90
 [<c0105a3c>] ? apic_timer_interrupt+0x28/0x30
 [<c013007b>] ? sysctl_perm+0x3b/0x80
 [<c011ae25>] ? native_safe_halt+0x5/0x10
 [<c0103a7f>] ? default_idle+0x5f/0xa0
 [<c0103a20>] ? default_idle+0x0/0xa0
 [<c010388f>] ? cpu_idle+0x6f/0x110
 [<c032a7e5>] ? start_secondary+0x195/0x1a0
 =======================
Code: 44 24 08 c7 04 24 88 90 39 c0 e8 b2 d7 f1 ff 0f 0b eb fe 89 54 24 08 89 4c 24 04 89 44 24 0c c7 04 24 d8 90 39 c0 e8 96 d7 f1 ff <0f> 0b eb fe 66 90 8b 0a 55 89 e5 e8 96 ff ff ff 5d c3 90 90 90
EIP: [<c020bc4a>] __list_add+0x5a/0x60 SS:ESP 0068:f7847e00
Kernel panic - not syncing: Fatal exception in interrupt

Parameter not specified:

list_add corruption. prev->next should be next (c047e77c), but was 00000001. (prev=f644bd98).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] SMP
Modules linked in: hidp rfcomm l2cap nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat dm_mod piix ide_core fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 hci_usb snd_ac97_codec ac97_bus parport_pc snd_pcm snd_timer thermal parport button snd processor i2c_i801 sr_mod i2c_core pcspkr rtc_cmos soundcore snd_page_alloc evdev tg3 dcdbas bluetooth iTCO_wdt iTCO_vendor_support sg ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ssb pcmcia pcmcia_core ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc1 #1)
EIP: 0060:[<c020bc4a>] EFLAGS: 00010086 CPU: 0
EIP is at __list_add+0x5a/0x60
EAX: 00000061 EBX: c03e133c ECX: 00000001 EDX: 00000086
ESI: c03e133c EDI: c047dea0 EBP: c03f5e6c ESP: c03f5e58
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03f4000 task=c03c8300 task.ti=c03f4000)
Stack: c03990d8 c047e77c 00000001 f644bd98 00019259 c03f5e7c c0131776 c03e133c
       c047dea0 c03f5e9c c01320c2 00019a28 00000000 00000286 c03e133c 00019a28
       c03e12a0 c03f5eac c0132296 00000000 f7133ba4 c03f5ec4 c02beb6c 00019258
Call Trace:
 [<c0131776>] ? internal_add_timer+0x36/0xb0
 [<c01320c2>] ? __mod_timer+0x92/0xb0
 [<c0132296>] ? mod_timer+0x26/0x40
 [<c02beb6c>] ? neigh_periodic_timer+0x12c/0x160
 [<c01319fd>] ? run_timer_softirq+0x15d/0x1d0
 [<c02bea40>] ? neigh_periodic_timer+0x0/0x160
 [<c02bea40>] ? neigh_periodic_timer+0x0/0x160
 [<c012d912>] ? __do_softirq+0x82/0x100
 [<c012d9e8>] ? do_softirq+0x58/0x60
 [<c012dd8c>] ? irq_exit+0x5c/0x70
 [<c0115b38>] ? smp_apic_timer_interrupt+0x58/0x90
 [<c0105a3c>] ? apic_timer_interrupt+0x28/0x30
 [<c013007b>] ? sysctl_perm+0x3b/0x80
 [<c011ae25>] ? native_safe_halt+0x5/0x10
 [<c0103a7f>] ? default_idle+0x5f/0xa0
 [<c0103a20>] ? default_idle+0x0/0xa0
 [<c010388f>] ? cpu_idle+0x6f/0x110
 [<c0320809>] ? rest_init+0x49/0x50
 =======================
Code: 44 24 08 c7 04 24 88 90 39 c0 e8 b2 d7 f1 ff 0f 0b eb fe 89 54 24 08 89 4c 24 04 89 44 24 0c c7 04 24 d8 90 39 c0 e8 96 d7 f1 ff <0f> 0b eb fe 66 90 8b 0a 55 89 e5 e8 96 ff ff ff 5d c3 90 90 90
EIP: [<c020bc4a>] __list_add+0x5a/0x60 SS:ESP 0068:c03f5e58
Kernel panic - not syncing: Fatal exception in interrupt

Here are all the addresses from the backtrace:

c0131776: kernel/timer.c:295
c01323a4: kernel/timer.c:454
c01434ca: kernel/time/clocksource.c:150
c01320cc: kernel/timer.c:433
c01319fd: kernel/timer.c:657
c01432a0: kernel/time/clocksource.c:98
c01432a0: kernel/time/clocksource.c:98
c012d912: include/linux/rcuclassic.h:112
c012d9e8: kernel/softirq.c:271
c012dd8c: kernel/softirq.c:314
c0115b38: include/asm/irq_regs_32.h:24
c0105a3c: include/asm-x86/mach-default/entry_arch.h:26
c013007b: kernel/sysctl.c:1520
c011ae25: include/asm/irqflags.h:49
c0103a7f: include/asm/paravirt.h:638
c0103a20: arch/x86/kernel/process_32.c:106
c010388f: arch/x86/kernel/process_32.c:190

c032a7e5: arch/x86/kernel/smpboot_32.c:426
c0320809: init/main.c:460

dmesg in case that is useful:

Linux version 2.6.25-rc1 (root@eral2.eng.trimble.com) (gcc version 4.2.2 20071122
8 (prerelease) (4.2.2-2mdv2008.1)) #1 SMP Sat Feb 16 10:31:49 PST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fe8cc00 (usable)
 BIOS-e820: 000000003fe8cc00 - 000000003fe8ec00 (ACPI NVS)
 BIOS-e820: 000000003fe8ec00 - 000000003fe90c00 (ACPI data)
 BIOS-e820: 000000003fe90c00 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
126MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00fe710] 000fe710
Entering add_active_range(0, 0, 261772) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261772
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261772
On node 0 totalpages: 261772
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 253 pages used for memmap
  HighMem zone: 32143 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FEBF0, 0014 (r0 DELL  )
ACPI: RSDT 000FCC96, 003C (r1 DELL    8400           7 ASL        61)
ACPI: FACP 000FCCD2, 0074 (r1 DELL    8400           7 ASL        61)
ACPI: DSDT FFFC76A0, 2B21 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 3FE8CC00, 0040
ACPI: SSDT FFFCA1C1, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FCD46, 0092 (r1 DELL    8400           7 ASL        61)
ACPI: BOOT 000FCDD8, 0028 (r1 DELL    8400           7 ASL        61)
ACPI: MCFG 000FCE00, 003E (r1 DELL    8400           7 ASL        61)
ACPI: HPET 000FCE3E, 0038 (r1 DELL    8400           7 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x05] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259727
Kernel command line: BOOT_IMAGE=2.6.25-rc1 root=/dev/sda6 resume=/dev/sda7 vga=77
94 console=ttyS0,115200 console=tty0
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3192.109 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1030584k/1047088k available (2237k kernel code, 15876k reserved, 779k daa
ta, 304k init, 129584k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03fb000 - 0xc0447000   ( 304 kB)
      .data : 0xc032f5d9 - 0xc03f2440   ( 779 kB)
      .text : 0xc0100000 - 0xc032f5d9   (2237 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 16 of 16 pages preallocated
SLUB: Genslabs=11, HWalign=128, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 6388.88 BogoMIPS (lpj=3194441)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.20GHz stepping 04
Booting processor 1/1 ip 4000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6384.03 BogoMIPS (lpj=3192016)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.20GHz stepping 04
Total of 2 processors activated (12772.91 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 552 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: Dell Inc.
ACPI: DMI Product Name: Dimension 8400
ACPI: DMI Product Version:
ACPI: DMI Board Name: 0U7077
ACPI: DMI BIOS Vendor: Dell Inc.
ACPI: DMI BIOS Date: 07/07/2006
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
system 00:01: ioport range 0x800-0x85f has been reserved
system 00:01: ioport range 0xc00-0xc7f has been reserved
system 00:01: ioport range 0x860-0x8ff could not be reserved
system 00:0a: iomem range 0x0-0x9ffff could not be reserved
system 00:0a: iomem range 0x100000-0xffffff could not be reserved
system 00:0a: iomem range 0x1000000-0x3fe8cbff could not be reserved
system 00:0a: iomem range 0xc0000-0xfffff could not be reserved
system 00:0a: iomem range 0xfec00000-0xfecfffff could not be reserved
system 00:0a: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:0a: iomem range 0xfed20000-0xfed9ffff could not be reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0xfeda0000-0xfedacfff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: 0xdfd00000-0xdfefffff
  PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xdfc00000-0xdfcfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 0xdfb00000-0xdfbfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xdf400000-0xdfafffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2977k freed
Simple Boot Flag at 0x7a set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1203166128.274:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 5120k, total 16388
4k
vesafb: mode is 1280x1024x16, linelength=2560, pages=5
vesafb: protected mode interface info at c000:5890
vesafb: pmi: set display start = c00c5924, set palette = c00c5970
vesafb: pmi: ports = dc10 dc16 dc54 dc38 dc3c dc5c dc00 dc04 dcb0 dcb2 dcb4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 304k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI subsystem initialized
usb 2-1: new low speed USB device using uhci_hcd and address 2
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 20
usb 2-1: configuration #1 chosen from 1 choice
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5 Gbps 0xf impl IDE mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xdffffc00 port 0xdffffd00 irq 20
ata2: SATA max UDMA/133 abar m1024@0xdffffc00 port 0xdffffd80 irq 20
ata3: SATA max UDMA/133 abar m1024@0xdffffc00 port 0xdffffe00 irq 20
ata4: SATA max UDMA/133 abar m1024@0xdffffc00 port 0xdffffe80 irq 20
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HDS724040KLSA80, KFAOA20N, max UDMA/133
ata1.00: 781422768 sectors, multi 8: LBA48
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      HDS724040KLSA80  KFAO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPOO
 or FUA
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPOO
 or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata5.00: ATAPI: GCR-8483B, 1.09, max UDMA/33
ata5.01: ATAPI: PHILIPS DVD+/-RW DVD8631, GD30, max UDMA/33
ata5.00: configured for UDMA/33
ata5.01: configured for UDMA/33
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8483B 1.09 PQ: 0 ANSI: 5
scsi 4:0:1:0: CD-ROM            PHILIPS  DVD+-RW DVD8631  GD30 PQ: 0 ANSI: 5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Attached scsi generic sg1 type 5
scsi 4:0:1:0: Attached scsi generic sg2 type 5
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
tg3.c:v3.87 (December 20, 2007)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: Tigon3 [partno(BCM95751) rev 4001 PHY(5750)] (PCI Express) 10/100/1000Basee
-T Ethernet 00:11:11:bd:d8:5d
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH6 or ICH6R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=1)
input: PC Speaker as /class/input/input2
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [VBTN]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1e.2 to 64
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 4:0:1:0: Attached scsi CD-ROM sr1
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECC
P]
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50243 usecs
intel8x0: clocking to 48000
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
fuse init (API version 7.9)
floppy0: no floppy controllers found
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EXT3 FS on sda6, internal journal
Adding 1124508k swap on /dev/sda7.  Priority:-1 extents:1 across:1124508k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded

