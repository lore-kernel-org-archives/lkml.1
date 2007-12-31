Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXLaVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXLaVer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 16:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLaVeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 16:34:37 -0500
Received: from web58415.mail.re3.yahoo.com ([68.142.236.183]:38628 "HELO
	web58415.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752200AbXLaVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 16:34:33 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Dec 2007 16:34:33 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=qMvxdNcOjCfVL3Amq8RW0hKop+oAho/kDwZ155SmExWBdwDilbpqo4LhWt9TFWMOUQxT28jf6tjQImaOcMIO7IjGSpfYAT9YOiX8OaixRBA9NZEXMEO1LwzbJEEO9Fdfuwqr55N3Tq3Fyi2vzh+es1h0jDKSMBaTzoibV8Rdtfg=;
X-YMail-OSG: .Eapw38VM1mdcUf3RWHOPZIPeznsYxN_xaAiqNTRx3SF8lOSQA3ZRb10i2MqhaDbU5VDwp6edgXmWVOCGVpIvb1NRaABKawe79.nyOZc_NKfnRMjpaxDV9iV_96qVK67of2DfRro1.zamU0-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.158.1
Date: Mon, 31 Dec 2007 13:27:50 -0800 (PST)
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: IDE/ACPI related hibernation regression: Second attempt fails
To: linux-kernel@vger.kernel.org
Cc: mmvinni@yahoo.com, shaohua.li@intel.com, len.brown@intel.com,
       bzolnier@gmail.com, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <90645.12978.qm@web58415.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed my ancient laptop (HP nx9005) fails to hibernate (suspend to disk) more than once while running recent 2.6.24-rc kernels. First hibernation succeeds happily, but when I try to do it again after resuming, the machine hangs immediately after the familiar two pops from the speakers."Hanging" in this case means that none of the usual keys work (e.g. Caps Lock led doesn't toggle), but alt-sysrq-b does reboot the laptop.

I tried my skills at bisecting and found that reverting the following patch allows my laptop to hibernate two (and probably more) times in a row successfully, both in X and from console:

commit 5e32132befa5d2cefadf3141fee0bbb40cd11f0e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Oct 11 23:53:58 2007 +0200

    ide: hook ACPI _PSx method to IDE power on/off

    ACPI spec defines the sequence of IDE power on/off:
    Powering down:
        Call _GTM.
        Power down drive (calls _PS3 method and turns off power planes).
    Powering up:
        Power up drive (calls _PS0 method if present and turns on power planes).
        Call _STM passing info from _GTM (possibly modified), with ID data from
        each drive.
        Initialize the channel.
        May modify the results of _GTF.
        For each drive:
                Call _GTF.
                Execute task file (possibly modified).
    This patch adds the missed _PS0/_PS3 methods call.

    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Acked-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


Here is the dmesg of the failing kernel after the first hibernation. I have no output from the second hibernation attempt with that kernel. After reverting the above-mentioned commit, these two lines won't appear in the output anymore:

  ACPI: Cannot set device to a higher-powered state than parent
  ACPI: Cannot set device to a higher-powered state than parent

Dmesg of the failing kernel after first hibernation (version is untouched e697789d64f8748cb219d7f5c413c512953802cc, i.e. current 2.6.24-rc6):

[    0.000000] Linux version 2.6.24-rcx-qaz (mikko@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 Mon Dec 31 19:26:59 EET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001def0000 (usable)
[    0.000000]  BIOS-e820: 000000001def0000 - 000000001deff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001deff000 - 000000001df00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001df00000 - 000000001e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 478MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 122608) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   122608
[    0.000000]   HighMem    122608 ->   122608
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   122608
[    0.000000] On node 0 totalpages: 122608
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 925 pages used for memmap
[    0.000000]   Normal zone: 117587 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F7290, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 1DEF8B70, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP 1DEFEE2B, 0074 (r1 ATI    Raptor    6040000 ATI     F4240)
[    0.000000] ACPI: DSDT 1DEF8BA0, 628B (r1    ATI U1_M1535  6040000 MSFT  100000D)
[    0.000000] ACPI: FACS 1DEFFFC0, 0040
[    0.000000] ACPI: BOOT 1DEFEE9F, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: SSDT 1DEFEEC7, 0139 (r1 PTLTD  POWERNOW  6040000  LTP        1)
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1e000000:e1fc0000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000d0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121651
[    0.000000] Kernel command line: root=UUID=ce8db9f7-6377-48a5-b22e-0a86e05348d6 ro single noresume2
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] mapped APIC to ffffb000 (013c3000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c03c0000 soft=c03bf000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1656.374 MHz processor.
[   12.790717] Console: colour VGA+ 80x25
[   12.790723] console [tty0] enabled
[   12.793297] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   12.793765] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   12.814936] Memory: 476272k/490432k available (1813k kernel code, 13516k reserved, 665k data, 316k init, 0k highmem)
[   12.815009] virtual kernel memory layout:
[   12.815010]     fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
[   12.815012]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   12.815013]     vmalloc : 0xde800000 - 0xff7fe000   ( 527 MB)
[   12.815015]     lowmem  : 0xc0000000 - 0xddef0000   ( 478 MB)
[   12.815016]       .init : 0xc036d000 - 0xc03bc000   ( 316 kB)
[   12.815018]       .data : 0xc02c5770 - 0xc036bce4   ( 665 kB)
[   12.815019]       .text : 0xc0100000 - 0xc02c5770   (1813 kB)
[   12.815383] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   12.898920] Calibrating delay using timer specific routine.. 3315.82 BogoMIPS (lpj=5522913)
[   12.899060] Security Framework initialized
[   12.899119] Capability LSM initialized
[   12.899178] Mount-cache hash table entries: 512
[   12.899420] CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000 00000000
[   12.899432] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   12.899483] CPU: L2 Cache: 256K (64 bytes/line)
[   12.899530] CPU: After all inits, caps: 0383f9ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000 00000000
[   12.899537] Intel machine check architecture supported.
[   12.899585] Intel machine check reporting enabled on CPU#0.
[   12.899637] Compat vDSO mapped to ffffe000.
[   12.899695] CPU: AMD mobile AMD Athlon(tm) XP2000+ stepping 01
[   12.899840] Checking 'hlt' instruction... OK.
[   12.912613] Freeing SMP alternatives: 0k freed
[   12.912660] ACPI: Core revision 20070126
[   12.915264] ACPI: setting ELCR to 0200 (from 0e28)
[   12.917607] net_namespace: 64 bytes
[   12.918235] Time: 20:32:02  Date: 12/31/07
[   12.918340] NET: Registered protocol family 16
[   12.918665] EISA bus registered
[   12.918725] ACPI: bus type pci registered
[   12.931113] PCI: PCI BIOS revision 2.10 entry at 0xfd87b, last bus=3
[   12.931164] PCI: Using configuration type 1
[   12.931209] Setting up standard PCI resources
[   12.933490] ACPI: EC: Look up EC in DSDT
[   12.960844] ACPI: Interpreter enabled
[   12.960899] ACPI: (supports S0 S3 S4 S5)
[   12.961082] ACPI: Using PIC for interrupt routing
[   12.967151] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[   12.967213] ACPI: EC: driver started in poll mode
[   12.967518] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   12.967844] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   12.968323] PCI quirk: region 8000-803f claimed by ali7101 ACPI
[   12.968374] PCI quirk: region 8040-805f claimed by ali7101 SMB
[   12.968672] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   12.968754] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
[   12.971015] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 *10)
[   12.971400] ACPI: PCI Interrupt Link [LNKB] (IRQs 7 *11)
[   12.971713] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 10) *9
[   12.972117] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 10) *0, disabled.
[   12.972566] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 10) *0, disabled.
[   12.973002] ACPI: PCI Interrupt Link [LNKF] (IRQs 7 11) *10
[   12.973344] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 10)
[   12.973716] ACPI: PCI Interrupt Link [LNKH] (IRQs *5 7)
[   12.974027] ACPI: PCI Interrupt Link [LNKU] (IRQs 3 4 6 10) *9
[   12.974444] Linux Plug and Play Support v0.97 (c) Adam Belay
[   12.974537] pnp: PnP ACPI init
[   12.974596] ACPI: bus type pnp registered
[   12.979367] pnp: PnP ACPI: found 11 devices
[   12.979419] ACPI: ACPI bus type pnp unregistered
[   12.979469] PnPBIOS: Disabled by ACPI PNP
[   12.979792] PCI: Using ACPI for IRQ routing
[   12.979842] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   12.992232] NET: Registered protocol family 8
[   12.992280] NET: Registered protocol family 20
[   12.995550] Time: tsc clocksource has been installed.
[   13.002265] system 00:07: ioport range 0x40b-0x40b has been reserved
[   13.002316] system 00:07: ioport range 0x480-0x48f has been reserved
[   13.002367] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[   13.002416] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[   13.002467] system 00:07: ioport range 0x8000-0x807f could not be reserved
[   13.002518] system 00:07: ioport range 0xff00-0xff01 has been reserved
[   13.002570] system 00:07: ioport range 0x8004-0x8005 has been reserved
[   13.002620] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[   13.002671] system 00:07: iomem range 0xd0400000-0xd0400fff has been reserved
[   13.033224] PCI: Bridge: 0000:00:01.0
[   13.033271]   IO window: 9000-9fff
[   13.033317]   MEM window: e0100000-e01fffff
[   13.033364]   PREFETCH window: e8000000-efffffff
[   13.033413] PCI: Bus 2, cardbus bridge: 0000:00:0a.0
[   13.033459]   IO window: 00001000-000010ff
[   13.033507]   IO window: 00001400-000014ff
[   13.033553]   PREFETCH window: 20000000-23ffffff
[   13.033600]   MEM window: 24000000-27ffffff
[   13.033646] PCI: Bus 6, cardbus bridge: 0000:00:0a.1
[   13.033692]   IO window: 00001800-000018ff
[   13.033738]   IO window: 00001c00-00001cff
[   13.033784]   PREFETCH window: 28000000-2bffffff
[   13.033831]   MEM window: 2c000000-2fffffff
[   13.034171] ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
[   13.034222] PCI: setting IRQ 11 as level-triggered
[   13.034226] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKF] -> GSI 11 (level, low) -> IRQ 11
[   13.034357] ACPI: PCI Interrupt 0000:00:0a.1[B] -> Link [LNKF] -> GSI 11 (level, low) -> IRQ 11
[   13.034504] NET: Registered protocol family 2
[   13.065623] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   13.065988] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[   13.066384] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[   13.066602] TCP: Hash tables configured (established 16384 bind 16384)
[   13.066652] TCP reno registered
[   13.075740] checking if image is initramfs... it is
[   13.535380] Switched to high resolution mode on CPU 0
[   13.729911] Freeing initrd memory: 6045k freed
[   13.730218] Simple Boot Flag at 0x36 set to 0x1
[   13.730869] audit: initializing netlink socket (disabled)
[   13.730940] audit(1199133122.896:1): initialized
[   13.731217] VFS: Disk quotas dquot_6.5.1
[   13.731297] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   13.731459] io scheduler noop registered
[   13.731505] io scheduler anticipatory registered
[   13.731551] io scheduler deadline registered
[   13.731605] io scheduler cfq registered (default)
[   13.731665] ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb.
[   13.945282] Activating ISA DMA hang workarounds.
[   13.945345] Boot video device is 0000:01:05.0
[   13.945615] isapnp: Scanning for PnP cards...
[   14.214704] isapnp: No Plug & Play device found
[   14.246069] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   14.246308] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   14.247393] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   14.248002] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 3
[   14.248055] PCI: setting IRQ 3 as level-triggered
[   14.248059] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKG] -> GSI 3 (level, low) -> IRQ 3
[   14.248186] ACPI: PCI interrupt for device 0000:00:08.0 disabled
[   14.249078] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   14.249254] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[   14.252877] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.252933] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.253168] mice: PS/2 mouse device common for all mice
[   14.253394] EISA: Probing bus 0 at eisa.0
[   14.253450] Cannot allocate resource for EISA slot 1
[   14.253523] Cannot allocate resource for EISA slot 8
[   14.253569] EISA: Detected 0 cards.
[   14.254479] cpuidle: using governor ladder
[   14.254525] cpuidle: using governor menu
[   14.254688] TCP cubic registered
[   14.254738] NET: Registered protocol family 1
[   14.254831] Using IPI Shortcut mode
[   14.255027]   Magic number: 3:966:549
[   14.255515]   hash matches device PNP0C0F:00
[   14.256221] Freeing unused kernel memory: 316k freed
[   14.295229] input: AT Translated Set 2 keyboard as /class/input/input0
[   14.607022] fuse init (API version 7.9)
[   14.622151] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   14.625915] Marking TSC unstable due to: TSC halts in idle.
[   14.626851] ACPI: Thermal Zone [THRM] (54 C)
[   14.628417] Time: acpi_pm clocksource has been installed.
[   15.960396] usbcore: registered new interface driver usbfs
[   15.960499] usbcore: registered new interface driver hub
[   15.971352] usbcore: registered new device driver usb
[   15.972831] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.973238] ACPI: PCI Interrupt Link [LNKU] enabled at IRQ 10
[   15.973297] PCI: setting IRQ 10 as level-triggered
[   15.973301] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
[   15.973440] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   15.973841] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   15.973924] ohci_hcd 0000:00:02.0: irq 10, io mem 0xe0004000
[   16.026968] usb usb1: configuration #1 chosen from 1 choice
[   16.027064] hub 1-0:1.0: USB hub found
[   16.027130] hub 1-0:1.0: 4 ports detected
[   16.038956] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   16.039026] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   16.049775] natsemi dp8381x driver, version 2.1, Sept 11, 2006
[   16.049780]   originally by Donald Becker <becker@scyld.com>
[   16.049782]   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
[   16.128366] alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.
[   16.128434] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc4) at  PCI slot 0000:00:10.0
[   16.128527] ACPI: Unable to derive IRQ for device 0000:00:10.0
[   16.128576] ACPI: PCI Interrupt 0000:00:10.0[A]: no GSI
[   16.128665] ALI15X3: not 100% native mode: will probe irqs later
[   16.128733]     ide0: BM-DMA at 0x8080-0x8087, BIOS settings: hda:DMA, hdb:pio
[   16.128873]     ide1: BM-DMA at 0x8088-0x808f, BIOS settings: hdc:DMA, hdd:pio
[   16.129003] Probing IDE interface ide0...
[   16.214901] Floppy drive(s): fd0 is 1.44M
[   16.231524] FDC 0 is a post-1991 82077
[   16.407936] usb 1-1: new low speed USB device using ohci_hcd and address 2
[   16.628610] usb 1-1: configuration #1 chosen from 1 choice
[   16.645156] usbcore: registered new interface driver hiddev
[   16.662871] input: Logitech USB Receiver as /class/input/input1
[   16.671226] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-1
[   16.671373] usbcore: registered new interface driver usbhid
[   16.671425] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   17.044607] hda: ST94813A, ATA DISK drive
[   17.044752] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   17.044940] hda: UDMA/100 mode selected
[   17.045282] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   17.047288] Probing IDE interface ide1...
[   18.067659] hdc: QSI CD-RW/DVD-ROM SBW-241, ATAPI CD/DVD-ROM drive
[   18.067871] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   18.067942] hdc: UDMA/33 mode selected
[   18.068096] ide1 at 0x170-0x177,0x376 on irq 15
[   18.079994] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   18.080059] ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   18.082165] natsemi eth0: NatSemi DP8381[56] at 0xe0008000 (0000:00:12.0), 00:0d:9d:5b:58:5f, IRQ 11, port TP.
[   18.082484] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[   18.082534] ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[   18.134030] SCSI subsystem initialized
[   18.145045] libata version 3.00 loaded.
[   18.150115] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[e0007000-e00077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.165577] hda: max request size: 128KiB
[   18.170967] hda: 78140160 sectors (40007 MB) w/8192KiB Cache, CHS=16383/255/63
[   18.171704] hda: cache flushes supported
[   18.171824]  hda: hda1 hda2 hda3 < hda5 hda6 > hda4
[   18.227469] hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
[   18.227695] Uniform CD-ROM driver Revision: 3.20
[   18.567218] Attempting manual resume
[   18.567270] swsusp: Resume From Partition 3:5
[   18.567273] PM: Checking swsusp image.
[   18.567676] PM: Resume from disk failed.
[   18.605851] kjournald starting.  Commit interval 5 seconds
[   18.605938] EXT3-fs: mounted filesystem with ordered data mode.
[   19.417040] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000d9d719e5a29c3]
[   31.534698] ip_tables: (C) 2000-2006 Netfilter Core Team
[   31.605742] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[   32.440214] eth0: DSPCFG accepted after 0 usec.
[   32.440288] eth0: link up.
[   34.197014] NET: Registered protocol family 17
[   34.947635] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   34.989067] Linux agpgart interface v0.102
[   35.064009] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   35.081289] input: Power Button (FF) as /class/input/input2
[   35.098841] ACPI: Power Button (FF) [PWRF]
[   35.099065] input: Power Button (CM) as /class/input/input3
[   35.107222] agpgart: Detected Ati IGP320/M chipset
[   35.117161] agpgart: AGP aperture is 64M @ 0xe4000000
[   35.128772] ACPI: Power Button (CM) [PWRB]
[   35.128926] input: Lid Switch as /class/input/input4
[   35.140674] ACPI: Lid Switch [LID]
[   35.153860] ACPI: AC Adapter [ACAD] (on-line)
[   35.157323] ACPI: Battery Slot [BAT1] (battery present)
[   35.317781] input: Video Bus as /class/input/input5
[   35.345513] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   36.067032] Yenta: CardBus bridge found at 0000:00:0a.0 [6933:0002]
[   36.067111] Yenta O2: res at 0x94/0xD4: ea/00
[   36.067158] Yenta O2: enabling read prefetch/write burst
[   36.192276] Yenta: ISA IRQ mask 0x00b8, PCI irq 11
[   36.192340] Socket status: 30000006
[   36.202384] Yenta: CardBus bridge found at 0000:00:0a.1 [6933:0002]
[   36.328954] Yenta: ISA IRQ mask 0x00b8, PCI irq 11
[   36.329015] Socket status: 30000006
[   36.362355] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 5
[   36.362419] PCI: setting IRQ 5 as level-triggered
[   36.362423] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 5 (level, low) -> IRQ 5
[   36.419684] input: PC Speaker as /class/input/input6
[   36.512837] Real Time Clock Driver v1.12ac
[   37.234319] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x236eb3, caps: 0x904713/0x10008
[   37.269679] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[   37.294372] parport_pc 00:09: reported by Plug and Play ACPI
[   37.294505] parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   37.720771] cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   37.724018] cs: IO port probe 0xc00-0xcf7: clean.
[   37.725092] cs: IO port probe 0xa00-0xaff: clean.
[   37.728617] cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   37.731882] cs: IO port probe 0xc00-0xcf7: clean.
[   37.732934] cs: IO port probe 0xa00-0xaff: clean.
[   38.794385] AC'97 1 does not respond - RESET
[   38.807709] AC'97 1 access is not valid [0xffffffff], removing mixer.
[   38.807763] ali mixer 1 creating error.
[   38.810948] ali15x3_smbus 0000:00:11.0: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[   38.811063] ali15x3_smbus 0000:00:11.0: ALI15X3 not detected, module not inserted.
[   39.309807] lp0: using parport0 (interrupt-driven).
[   39.566441] Adding 979924k swap on /dev/hda5.  Priority:-1 extents:1 across:979924k
[   39.939091] EXT3 FS on hda2, internal journal
[   41.235791] kjournald starting.  Commit interval 5 seconds
[   41.236209] EXT3 FS on hda4, internal journal
[   41.236216] EXT3-fs: mounted filesystem with ordered data mode.
[   41.335552] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
[   41.345498] SGI XFS Quota Management subsystem
[   41.422488] XFS mounting filesystem hda6
[   41.572821] Ending clean XFS mount for filesystem: hda6
[   42.805014] NET: Registered protocol family 10
[   42.805364] lo: Disabled Privacy Extensions
[   53.579691] eth0: no IPv6 routers present
[   90.958358] swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
[   90.958369] swsusp: Basic memory bitmaps created
[   90.958372] Syncing filesystems ... done.
[   90.990172] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   90.990256] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   90.990305] Shrinking memory...  -done (0 pages freed)
[   91.012095] Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
[   91.012099] Suspending console(s)
[   91.012358] ACPI: Cannot set device to a higher-powered state than parent
[   91.232564] ACPI: Cannot set device to a higher-powered state than parent
[   91.233219] serial 00:0a: disabled
[   91.233582] parport_pc 00:09: disabled
[   91.233840] eth0: remaining active for wake-on-lan
[   91.273011] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[   91.286237] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[   91.304106] swsusp: critical section: 
[   91.325801] swsusp: Need to copy 24476 pages
[   91.325808] swsusp: Normal pages needed: 24476 + 1024 + 14, available pages: 98033
[   20.971916] Intel machine check architecture supported.
[   20.971929] Intel machine check reporting enabled on CPU#0.
[   20.981930] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 22300006, writing 2300006)
[   20.994383] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
[   21.007714] PM: Writing back config space on device 0000:00:06.0 at offset 1 (was c2900007, writing c2900003)
[   21.007728] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 5 (level, low) -> IRQ 5
[   21.287670] PM: Writing back config space on device 0000:00:0a.0 at offset f (was 180010a, writing 580010a)
[   21.287684] PM: Writing back config space on device 0000:00:0a.0 at offset 3 (was 824000, writing 82a800)
[   21.287690] PM: Writing back config space on device 0000:00:0a.0 at offset 1 (was 4100007, writing 4100087)
[   21.287704] Yenta O2: res at 0x94/0xD4: ea/00
[   21.287707] Yenta O2: enabling read prefetch/write burst
[   21.424264] PM: Writing back config space on device 0000:00:0a.1 at offset f (was 180020a, writing 580020a)
[   21.424278] PM: Writing back config space on device 0000:00:0a.1 at offset 3 (was 824000, writing 82a800)
[   21.424284] PM: Writing back config space on device 0000:00:0a.1 at offset 1 (was 4100007, writing 4100087)
[   21.574223] PM: Writing back config space on device 0000:00:0c.0 at offset f (was 4020100, writing 4020109)
[   21.574236] PM: Writing back config space on device 0000:00:0c.0 at offset 5 (was 0, writing e0000000)
[   21.574241] PM: Writing back config space on device 0000:00:0c.0 at offset 4 (was 0, writing e0007000)
[   21.574245] PM: Writing back config space on device 0000:00:0c.0 at offset 3 (was 0, writing 4010)
[   21.574251] PM: Writing back config space on device 0000:00:0c.0 at offset 1 (was 2100000, writing 2100016)
[   21.624275] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[e0007000-e00077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   21.624410] ACPI: Unable to derive IRQ for device 0000:00:10.0
[   21.624413] ACPI: PCI Interrupt 0000:00:10.0[A]: no GSI
[   21.624498] eth0: DSPCFG accepted after 0 usec.
[   21.626171] parport_pc 00:09: activated
[   21.627184] serial 00:0a: activated
[   22.342708] usb usb1: root hub lost power or was reset
[   22.460074] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   22.460431] hda: UDMA/100 mode selected
[   22.463457] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   22.474519] hdc: UDMA/33 mode selected
[   22.474625] PM: Image restored successfully.
[   22.484664] Restarting tasks ... <6>usb 1-1: USB disconnect, address 2
[   22.487883] done.
[   22.487920] swsusp: Basic memory bitmaps freed
[   22.787241] usb 1-1: new low speed USB device using ohci_hcd and address 3
[   23.011521] usb 1-1: configuration #1 chosen from 1 choice
[   23.034839] input: Logitech USB Receiver as /class/input/input8
[   23.060634] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-1


lspci -vvv:
00:00.0 Host bridge: ATI Technologies Inc AGP Bridge [IGP 320M] (rev 13)
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 32
    Region 0: Memory at e4000000 (32-bit, prefetchable) [size=64M]
    Region 1: Memory at e0400000 (32-bit, prefetchable) [size=4K]
    Region 2: I/O ports at 8090 [disabled] [size=4]
    Capabilities: [a0] AGP version 2.0
        Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
        Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4

00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 320M] (rev 01) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 99
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: e0100000-e01fffff
    Prefetchable memory behind bridge: e8000000-efffffff
    Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:02.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin USB
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 64 (20000ns max)
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e0004000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [60] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link Controller Audio Device (rev 02)
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin Audio
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
    Latency: 64 (500ns min, 6000ns max)
    Interrupt: pin A routed to IRQ 5
    Region 0: I/O ports at 8400 [size=256]
    Region 1: Memory at e0005000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+]
    Subsystem: ALi Corporation ALi M1533 Aladdin IV/V ISA Bridge
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Capabilities: [a0] Power Management version 1
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 Modem: ALi Corporation M5457 AC'97 Modem Controller (prog-if 00 [Generic])
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin Modem Device
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Interrupt: pin A routed to IRQ 3
    Region 0: Memory at e0006000 (32-bit, non-prefetchable) [size=4K]
    Region 1: I/O ports at 8800 [size=256]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 CardBus bridge: O2 Micro, Inc. OZ6933/711E1 CardBus/SmartCardBus Controller (rev 01)
    Subsystem: Unknown device 6933:0002
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 168
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at 30010000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
    Memory window 0: 20000000-23fff000 (prefetchable)
    Memory window 1: 24000000-27fff000
    I/O window 0: 00001000-000010ff
    I/O window 1: 00001400-000014ff
    BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
    16-bit legacy interface ports at 0001

00:0a.1 CardBus bridge: O2 Micro, Inc. OZ6933/711E1 CardBus/SmartCardBus Controller (rev 01)
    Subsystem: Unknown device 6933:0002
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 168
    Interrupt: pin B routed to IRQ 11
    Region 0: Memory at 30011000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
    Memory window 0: 28000000-2bfff000 (prefetchable)
    Memory window 1: 2c000000-2ffff000
    I/O window 0: 00001800-000018ff
    I/O window 1: 00001c00-00001cff
    BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
    16-bit legacy interface ports at 0001

00:0c.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
    Subsystem: Hewlett-Packard Company Unknown device 0024
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e0007000 (32-bit, non-prefetchable) [size=2K]
    Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4) (prog-if b0)
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin IDE
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 32 (500ns min, 1000ns max)
    Interrupt: pin A routed to IRQ 0
    Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
    Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
    Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
    Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
    Region 4: I/O ports at 8080 [size=16]
    Capabilities: [60] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
    Subsystem: Hewlett-Packard Company Pavilion ze4400
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:12.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin Network
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 90 (2750ns min, 13000ns max)
    Interrupt: pin A routed to IRQ 11
    Region 0: I/O ports at 8c00 [size=256]
    Region 1: Memory at e0008000 (32-bit, non-prefetchable) [size=4K]
    [virtual] Expansion ROM at 30000000 [disabled] [size=64K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=320mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME+

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility U1 (prog-if 00 [VGA])
    Subsystem: Hewlett-Packard Company Pavilion ze4400 builtin Video
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 66 (2000ns min), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
    Region 1: I/O ports at 9000 [size=256]
    Region 2: Memory at e0100000 (32-bit, non-prefetchable) [size=64K]
    [virtual] Expansion ROM at e0120000 [disabled] [size=128K]
    Capabilities: [58] AGP version 2.0
        Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
        Command: RQ=16 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-



What else?


Thanks!

Mikko
-- 





      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
