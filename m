Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbXA1VGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbXA1VGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXA1VGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:06:03 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:55077 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852AbXA1VGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:06:01 -0500
Date: Sun, 28 Jan 2007 16:05:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug report : reproducible memory allocator bug in 2.6.20-rc6
Message-ID: <20070128210551.GA30605@Krystal>
References: <20070128200917.GA16571@Krystal> <45BD06AC.1080008@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <45BD06AC.1080008@mbligh.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 15:54:51 up 158 days, 18:02,  5 users,  load average: 0.72, 1.36, 1.87
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin J. Bligh (mbligh@mbligh.org) wrote:
> Mathieu Desnoyers wrote:
> >Hi,
> >
> >Trying to build cross-compilers (or kernels) on a 2-way x86_64 (amd64) with
> >make -j3 triggers the following OOPS after about 30 minutes on
> >2.6.19.2. Due to the amount of time and the heavy load it takes before it
> >happens, I suspect a race condition. Memtest86 tests passed ok. The
> >amount of swap used when the condition happens is about 52k and stable
> >(only ~800MB/1GB are used).
> >
> >I am going to give it a look, but I suspect you might help narrowing it
> >down more quickly. Any insight would be appreciated.
> 
> Mmm. that's going to be messy to debug ... but didn't we already know
> that kernel was racy? Or is 2.6.19.2 after that fix already? Does 20-rc6
> still break?
> 

Hi Martin,

I hoped it would go away magically too, but here is a similar list bug
happening on 2.6.20-rc6, this time from "release_pages".

-- SUMMARY ---

list_del corruption. next->prev should be ffff81003b5315d8, but was ffff81003b21e1d0
------------[ cut here ]------------
kernel BUG at /home/compudj/git/linux-2.6-lttng/lib/list_debug.c:72!
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: ipv6 ppdev lp parport_serial dm_snapshot dm_mirror dm_mod sbp2 loop ide_cd cdrom eth1394 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm amd74xx snd_timer snd serio_raw soundcore i2c_nforce2 ohci_hcd psmouse pcspkr ohci1394 ieee1394 i2c_core parport_pc parport ehci_hcd snd_page_alloc forcedeth floppy ext3 jbd mbcache sd_mod generic ide_core ata_generic sata_nv libata scsi_mod evdev
Pid: 11807, comm: ld Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff803298e4>]  [<ffffffff803298e4>] list_del+0x3f/0x5b
RSP: 0018:ffff81001774fc68  EFLAGS: 00010096
RAX: 0000000000000058 RBX: ffff81003b531590 RCX: ffffffff806096b8
RDX: ffff81001c86d100 RSI: 0000000000000001 RDI: 0000000000000096
RBP: ffff81001774fc68 R08: 0000000000000002 R09: 0000000000000080
R10: 0000000000000080 R11: ffff810001020b00 R12: ffff81000000b440
R13: ffff81000101ea28 R14: 0000000000000000 R15: 000000000000000e
FS:  00002acae32b3c80(0000) GS:ffff8100011af138(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002acae3108150 CR3: 0000000000201000 CR4: 00000000000006e0
Process ld (pid: 11807, threadinfo ffff81001774e000, task ffff81001c86d100)
Stack:  ffff81001774fd28 ffffffff8020b142 0000000000000000 0000000000000000
 ffff81003ba5ca80 ffff81003b10e938 ffff81003bd46c40 ffff81003b21e188
 ffff81003bbf4790 ffff81003b165128 ffff81003af43958 ffff81003b8c19e0
Call Trace:
 [<ffffffff8020b142>] release_pages+0xdb/0x18a
 [<ffffffff8020e44d>] free_pages_and_swap_cache+0x7b/0x96
 [<ffffffff80207d6d>] unmap_vmas+0x437/0x6ff
 [<ffffffff802396ed>] exit_mmap+0x7a/0xf1
 [<ffffffff8023b8af>] mmput+0x3d/0x8f
 [<ffffffff8023ffe6>] exit_mm+0xe1/0xea
 [<ffffffff8021490a>] do_exit+0x230/0x83d
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80247481>] debug_mutex_init+0x0/0x45
 [<ffffffff8024accc>] sys_exit_group+0x12/0x14
 [<ffffffff8025b11e>] system_call+0x7e/0x83




--- whole dmesg ----
root  (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel  /vmlinuz root=/dev/sda2 ro console=tty0 console=ttyS0,38400n8 
   [Linux-bzImage, setup=0x1e00, size=0x1a25e1]
initrd  /initrd.img
   [Linux-initrd @ 0x37c66000, 0x389efd bytes]
savedefault

0000:04:08.0: ttyS0 at I/O 0xc880 (irq = 19) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
usbmon: debugfs is not available
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 296k freed
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE482 bmdma 0xE000 irq 23
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE082 bmdma 0xE008 irq 23
scsi0 : sata_nv
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 390721968 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xE407
scsi 0:0:0:0: Direct-Access     ATA      ST3200827AS      3.AA PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LSA1] -> GSI 22 (level, low) -> IRQ 22
ata3: SATA max UDMA/133 cmd 0xDC00 ctl 0xD882 bmdma 0xD400 irq 22
ata4: SATA max UDMA/133 cmd 0xD800 ctl 0xD482 bmdma 0xD408 irq 22
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xDC07
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xD807
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Switching root ...
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 21 (level, low) -> IRQ 21
forcedeth: using HIGHDMA
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP]
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:14.0
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
ehci_hcd 0000:00:0b.1: irq 20, io mem 0xfebdfc00
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
input: PC Speaker as /class/input/input1
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 18
ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [LNKD] -> <6>i2c_adapter i2c-0: nForce2 SMBus adapter at 0x600
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x700
GSI 18 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[18]  MMIO=[faaff800-faafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 23, io mem 0xfebde000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
NFORCE-MCP51: chipset revision 161
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
hda: HL-DT-ST DVDRAM GSA-H10N, ATAPI CD/DVD-ROM drive
eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
hdb: LITE-ON CD-ROM LTN-5291S, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 22 (level, low) -> IRQ 22
hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdb: ATAPI 52X CD-ROM drive, 96kB Cache, UDMA(33)
done.
Activating swap...Adding 2000052k swap on /dev/sda5.  Priority:-1 extents:1 across:2000052k
done.
Checking root file system...fsck 1.40-WIP (14-Nov-2006)
/dev/sda2: clean, 246842/4889248EXT3 FS on sda2,  files, 2723904/internal journal
9765511 blocks
done.
Setting the system clock again..
Cleaning up ifupdown....
Loading modules...loop: loaded (max 8 devices)
done.
Loading device-mapper supportdevice-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
.
Checking file systems...fsck 1.40-WIP (14-Nov-2006)
/dev/sda1: clean, 54/122880 files, 61989/489948 blocks
/dev/sda6: clean, 1190226/12222464 files, 5154123/24414775 blocks
done.
Setting kernel variables...error: "net.ipv4.netfilter.ip_conntrack_tcp_be_liberal" is an unknown key
failed.
Mounting local filesystems...kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
done.
Activating swapfile swap...done.
Detecting hardware...Setting up networking....
Configuring network interfaces...done.
Starting portmap daemon....
Setting console screen modes and fonts.
Setting up ALSA...done.
INIT: Entering runlevel: 2
Starting system log daemon: syslogd.
Starting kernel log daemon: klogd.
Starting portmap daemon...Already running..
Starting BitTorrent tracker: disabled in /etc/default/bittorrent.
Starting Common Unix Printing System: cupsdlp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
.
Starting system message bus: dbus.
Starting Hardware abstraction layer: hald.
Starting Avahi mDNS/DNS-SD Daemon: avahi-daemonNET: Registered protocol family 10
lo: Disabled Privacy Extensions
.
Starting MTA: exim4.
Starting printer spooler: lpd.
Starting internet superserver: inetd.
Starting OpenBSD Secure Shell server: sshd.
Starting GNOME Display Manager: gdm.
Starting NFS common utilities: statd.
Starting deferred execution scheduler: atd.
Starting periodic command scheduler: crond.

Debian GNU/Linux 4.0 amd64 ttyS0

amd64 login: 
list_del corruption. next->prev should be ffff81003b5315d8, but was ffff81003b21e1d0
------------[ cut here ]------------
kernel BUG at /home/compudj/git/linux-2.6-lttng/lib/list_debug.c:72!
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: ipv6 ppdev lp parport_serial dm_snapshot dm_mirror dm_mod sbp2 loop ide_cd cdrom eth1394 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm amd74xx snd_timer snd serio_raw soundcore i2c_nforce2 ohci_hcd psmouse pcspkr ohci1394 ieee1394 i2c_core parport_pc parport ehci_hcd snd_page_alloc forcedeth floppy ext3 jbd mbcache sd_mod generic ide_core ata_generic sata_nv libata scsi_mod evdev
Pid: 11807, comm: ld Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff803298e4>]  [<ffffffff803298e4>] list_del+0x3f/0x5b
RSP: 0018:ffff81001774fc68  EFLAGS: 00010096
RAX: 0000000000000058 RBX: ffff81003b531590 RCX: ffffffff806096b8
RDX: ffff81001c86d100 RSI: 0000000000000001 RDI: 0000000000000096
RBP: ffff81001774fc68 R08: 0000000000000002 R09: 0000000000000080
R10: 0000000000000080 R11: ffff810001020b00 R12: ffff81000000b440
R13: ffff81000101ea28 R14: 0000000000000000 R15: 000000000000000e
FS:  00002acae32b3c80(0000) GS:ffff8100011af138(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002acae3108150 CR3: 0000000000201000 CR4: 00000000000006e0
Process ld (pid: 11807, threadinfo ffff81001774e000, task ffff81001c86d100)
Stack:  ffff81001774fd28 ffffffff8020b142 0000000000000000 0000000000000000
 ffff81003ba5ca80 ffff81003b10e938 ffff81003bd46c40 ffff81003b21e188
 ffff81003bbf4790 ffff81003b165128 ffff81003af43958 ffff81003b8c19e0
Call Trace:
 [<ffffffff8020b142>] release_pages+0xdb/0x18a
 [<ffffffff8020e44d>] free_pages_and_swap_cache+0x7b/0x96
 [<ffffffff80207d6d>] unmap_vmas+0x437/0x6ff
 [<ffffffff802396ed>] exit_mmap+0x7a/0xf1
 [<ffffffff8023b8af>] mmput+0x3d/0x8f
 [<ffffffff8023ffe6>] exit_mm+0xe1/0xea
 [<ffffffff8021490a>] do_exit+0x230/0x83d
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80247481>] debug_mutex_init+0x0/0x45
 [<ffffffff8024accc>] sys_exit_group+0x12/0x14
 [<ffffffff8025b11e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 48 89 48 08 48 89 01 48 c7 47 08 00 02 20 00 48 
RIP  [<ffffffff803298e4>] list_del+0x3f/0x5b
 RSP <ffff81001774fc68>
 <1>Fixing recursive fault but reboot is needed!
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: ipv6 ppdev lp parport_serial dm_snapshot dm_mirror dm_mod sbp2 loop ide_cd cdrom eth1394 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm amd74xx snd_timer snd serio_raw soundcore i2c_nforce2 ohci_hcd psmouse pcspkr ohci1394 ieee1394 i2c_core parport_pc parport ehci_hcd snd_page_alloc forcedeth floppy ext3 jbd mbcache sd_mod generic ide_core ata_generic sata_nv libata scsi_mod evdev
Pid: 11821, comm: sh Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff802078be>]  [<ffffffff802078be>] _raw_spin_lock+0x81/0xf9
RSP: 0000:ffff810002317cb8  EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff81000000b700 RCX: 00000000f6a35d61
RDX: 000000000000033a RSI: ffff8100178608c0 RDI: 0000000000000001
RBP: ffff810002317cd8 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000006ab296d
R13: 0000000000000001 R14: 0000000077c3cc34 R15: ffff81001dcc6bb8
FS:  00002b12d23036d0(0000) GS:ffffffff80548000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000005be064 CR3: 000000002a9e2000 CR4: 00000000000006e0
Process sh (pid: 11821, threadinfo ffff810002316000, task ffff810017860140)
Stack:  ffff81000000b700 ffff81000000b440 ffff810001019480 0000000000000000
 ffff810002317cf8 ffffffff80262975 ffff81003b7347d0 ffff81003b498cf0
 ffff810002317d28 ffffffff8020d436 0000000000000012 ffff81003b542cb0
Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff80228ebd>] do_sigaction+0x17a/0x190
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80262c8d>] error_exit+0x0/0x96


Code: 7f 55 bf 01 00 00 00 49 ff c4 e8 d2 53 00 00 4d 39 f4 75 e6 
 NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Modules linked in: ipv6 ppdev lp parport_serial dm_snapshot dm_mirror dm_mod sbp2 loop ide_cd cdrom eth1394 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm amd74xx snd_timer snd serio_raw soundcore i2c_nforce2 ohci_hcd psmouse pcspkr ohci1394 ieee1394 i2c_core parport_pc parport ehci_hcd snd_page_alloc forcedeth floppy ext3 jbd mbcache sd_mod generic ide_core ata_generic sata_nv libata scsi_mod evdev
Pid: 11815, comm: sh Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff802078b8>]  [<ffffffff802078b8>] _raw_spin_lock+0x7b/0xf9
RSP: 0000:ffff810024e4fcb8  EFLAGS: 00000083
RAX: 000000000000000a RBX: ffff81000000b700 RCX: 00000000f7837878
RDX: 000000000000033d RSI: ffff810024e4fcd8 RDI: 0000000000000001
RBP: ffff810024e4fcd8 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 000000000b7745fb
R13: 0000000000000001 R14: 0000000077c3cc34 R15: ffff81000fc4cc80
FS:  00002b7057d366d0(0000) GS:ffff8100011af138(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b7057899398 CR3: 0000000023ebe000 CR4: 00000000000006e0
Process sh (pid: 11815, threadinfo ffff810024e4e000, task ffff81002cd0d080)
Stack:  ffff81000000b700 ffff81000000b440 ffff810001022480 0000000000000000
 ffff810024e4fcf8 ffffffff80262975 ffff81003bdc0ea0 ffff81003ba5ca80
 ffff810024e4fd28 ffffffff8020d436 0000000000000012 ffff81003be9b508
Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff8025fe30>] thread_return+0x88/0x12d
 [<ffffffff80262c8d>] error_exit+0x0/0x96


Code: 31 c0 87 03 85 c0 7f 55 bf 01 00 00 00 49 ff c4 e8 d2 53 00 
 
--- ksymoops ---


kernel BUG at /home/compudj/git/linux-2.6-lttng/lib/list_debug.c:72!
CPU 1 
Pid: 11807, comm: ld Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff803298e4>]  [<ffffffff803298e4>] list_del+0x3f/0x5b
RSP: 0018:ffff81001774fc68  EFLAGS: 00010096
RAX: 0000000000000058 RBX: ffff81003b531590 RCX: ffffffff806096b8
RDX: ffff81001c86d100 RSI: 0000000000000001 RDI: 0000000000000096
RBP: ffff81001774fc68 R08: 0000000000000002 R09: 0000000000000080
R10: 0000000000000080 R11: ffff810001020b00 R12: ffff81000000b440
R13: ffff81000101ea28 R14: 0000000000000000 R15: 000000000000000e
FS:  00002acae32b3c80(0000) GS:ffff8100011af138(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002acae3108150 CR3: 0000000000201000 CR4: 00000000000006e0
Stack:  ffff81001774fd28 ffffffff8020b142 0000000000000000 0000000000000000
 ffff81003ba5ca80 ffff81003b10e938 ffff81003bd46c40 ffff81003b21e188
 ffff81003bbf4790 ffff81003b165128 ffff81003af43958 ffff81003b8c19e0
Call Trace:
 [<ffffffff8020b142>] release_pages+0xdb/0x18a
 [<ffffffff8020e44d>] free_pages_and_swap_cache+0x7b/0x96
 [<ffffffff80207d6d>] unmap_vmas+0x437/0x6ff
 [<ffffffff802396ed>] exit_mmap+0x7a/0xf1
 [<ffffffff8023b8af>] mmput+0x3d/0x8f
 [<ffffffff8023ffe6>] exit_mm+0xe1/0xea
 [<ffffffff8021490a>] do_exit+0x230/0x83d
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80247481>] debug_mutex_init+0x0/0x45
 [<ffffffff8024accc>] sys_exit_group+0x12/0x14
 [<ffffffff8025b11e>] system_call+0x7e/0x83
Code: 0f 0b eb fe 48 89 48 08 48 89 01 48 c7 47 08 00 02 20 00 48 


>>RIP; ffffffff803298e4 <list_del+3f/5b>   <=====

>>RBX; ffff81003b531590 <phys_startup_64+ffff81003b331490/ffffffff7fffff00>
>>RCX; ffffffff806096b8 <printk_buf.20305+58/400>
>>RDX; ffff81001c86d100 <phys_startup_64+ffff81001c66d000/ffffffff7fffff00>
>>RBP; ffff81001774fc68 <phys_startup_64+ffff81001754fb68/ffffffff7fffff00>
>>R11; ffff810001020b00 <phys_startup_64+ffff810000e20a00/ffffffff7fffff00>
>>R12; ffff81000000b440 <phys_startup_64+ffff80ffffe0b340/ffffffff7fffff00>
>>R13; ffff81000101ea28 <phys_startup_64+ffff810000e1e928/ffffffff7fffff00>

Trace; ffffffff8020b142 <release_pages+db/18a>
Trace; ffffffff8020e44d <free_pages_and_swap_cache+7b/96>
Trace; ffffffff80207d6d <unmap_vmas+437/6ff>
Trace; ffffffff802396ed <exit_mmap+7a/f1>
Trace; ffffffff8023b8af <mmput+3d/8f>
Trace; ffffffff8023ffe6 <exit_mm+e1/ea>
Trace; ffffffff8021490a <do_exit+230/83d>
Trace; ffffffff802621ca <trace_hardirqs_on_thunk+35/37>
Trace; ffffffff80247481 <debug_mutex_init+0/45>
Trace; ffffffff8024accc <sys_exit_group+12/14>
Trace; ffffffff8025b11e <system_call+7e/83>

Code;  ffffffff803298e4 <list_del+3f/5b>
0000000000000000 <_RIP>:
Code;  ffffffff803298e4 <list_del+3f/5b>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  ffffffff803298e6 <list_del+41/5b>
   2:   eb fe                     jmp    2 <_RIP+0x2>
Code;  ffffffff803298e8 <list_del+43/5b>
   4:   48 89 48 08               mov    %rcx,0x8(%rax)
Code;  ffffffff803298ec <list_del+47/5b>
   8:   48 89 01                  mov    %rax,(%rcx)
Code;  ffffffff803298ef <list_del+4a/5b>
   b:   48 c7 47 08 00 02 20      movq   $0x200200,0x8(%rdi)
Code;  ffffffff803298f6 <list_del+51/5b>
  12:   00 
Code;  ffffffff803298f7 <list_del+52/5b>
  13:   48 00 00                  rex64 add    %al,(%rax)

NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Pid: 11821, comm: sh Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff802078be>]  [<ffffffff802078be>] _raw_spin_lock+0x81/0xf9
RSP: 0000:ffff810002317cb8  EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff81000000b700 RCX: 00000000f6a35d61
RDX: 000000000000033a RSI: ffff8100178608c0 RDI: 0000000000000001
RBP: ffff810002317cd8 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000006ab296d
R13: 0000000000000001 R14: 0000000077c3cc34 R15: ffff81001dcc6bb8
FS:  00002b12d23036d0(0000) GS:ffffffff80548000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000005be064 CR3: 000000002a9e2000 CR4: 00000000000006e0
Stack:  ffff81000000b700 ffff81000000b440 ffff810001019480 0000000000000000
 ffff810002317cf8 ffffffff80262975 ffff81003b7347d0 ffff81003b498cf0
 ffff810002317d28 ffffffff8020d436 0000000000000012 ffff81003b542cb0
Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff80228ebd>] do_sigaction+0x17a/0x190
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80262c8d>] error_exit+0x0/0x96
Code: 7f 55 bf 01 00 00 00 49 ff c4 e8 d2 53 00 00 4d 39 f4 75 e6 


>>RIP; ffffffff802078be <_raw_spin_lock+81/f9>   <=====

>>RBX; ffff81000000b700 <phys_startup_64+ffff80ffffe0b600/ffffffff7fffff00>
>>RCX; 00000000f6a35d61 <phys_startup_64+f6835c61/ffffffff7fffff00>
>>RSI; ffff8100178608c0 <phys_startup_64+ffff8100176607c0/ffffffff7fffff00>
>>RBP; ffff810002317cd8 <phys_startup_64+ffff810002117bd8/ffffffff7fffff00>
>>R12; 0000000006ab296d <phys_startup_64+68b286d/ffffffff7fffff00>
>>R14; 0000000077c3cc34 <phys_startup_64+77a3cb34/ffffffff7fffff00>
>>R15; ffff81001dcc6bb8 <phys_startup_64+ffff81001dac6ab8/ffffffff7fffff00>

Trace; ffffffff80262975 <_spin_lock_irq+33/38>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff8020ffa0 <lru_cache_add_active+4f/51>
Trace; ffffffff802106f3 <do_wp_page+401/4aa>
Trace; ffffffff80208ff9 <__handle_mm_fault+96b/9e2>
Trace; ffffffff8020aab5 <do_page_fault+364/817>
Trace; ffffffff8020ab74 <do_page_fault+423/817>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff80228ebd <do_sigaction+17a/190>
Trace; ffffffff802621ca <trace_hardirqs_on_thunk+35/37>
Trace; ffffffff80262c8d <error_exit+0/96>

Code;  ffffffff802078be <_raw_spin_lock+81/f9>
0000000000000000 <_RIP>:
Code;  ffffffff802078be <_raw_spin_lock+81/f9>   <=====
   0:   7f 55                     jg     57 <_RIP+0x57>   <=====
Code;  ffffffff802078c0 <_raw_spin_lock+83/f9>
   2:   bf 01 00 00 00            mov    $0x1,%edi
Code;  ffffffff802078c5 <_raw_spin_lock+88/f9>
   7:   49 ff c4                  inc    %r12
Code;  ffffffff802078c8 <_raw_spin_lock+8b/f9>
   a:   e8 d2 53 00 00            callq  53e1 <_RIP+0x53e1>
Code;  ffffffff802078cd <_raw_spin_lock+90/f9>
   f:   4d 39 f4                  cmp    %r14,%r12
Code;  ffffffff802078d0 <_raw_spin_lock+93/f9>
  12:   75 e6                     jne    fffffffffffffffa <_RIP+0xfffffffffffffffa>

 NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Pid: 11815, comm: sh Not tainted 2.6.20-rc6 #1
RIP: 0010:[<ffffffff802078b8>]  [<ffffffff802078b8>] _raw_spin_lock+0x7b/0xf9
RSP: 0000:ffff810024e4fcb8  EFLAGS: 00000083
RAX: 000000000000000a RBX: ffff81000000b700 RCX: 00000000f7837878
RDX: 000000000000033d RSI: ffff810024e4fcd8 RDI: 0000000000000001
RBP: ffff810024e4fcd8 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 000000000b7745fb
R13: 0000000000000001 R14: 0000000077c3cc34 R15: ffff81000fc4cc80
FS:  00002b7057d366d0(0000) GS:ffff8100011af138(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b7057899398 CR3: 0000000023ebe000 CR4: 00000000000006e0
Stack:  ffff81000000b700 ffff81000000b440 ffff810001022480 0000000000000000
 ffff810024e4fcf8 ffffffff80262975 ffff81003bdc0ea0 ffff81003ba5ca80
 ffff810024e4fd28 ffffffff8020d436 0000000000000012 ffff81003be9b508
Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff8025fe30>] thread_return+0x88/0x12d
 [<ffffffff80262c8d>] error_exit+0x0/0x96
Code: 31 c0 87 03 85 c0 7f 55 bf 01 00 00 00 49 ff c4 e8 d2 53 00 


>>RIP; ffffffff802078b8 <_raw_spin_lock+7b/f9>   <=====

>>RBX; ffff81000000b700 <phys_startup_64+ffff80ffffe0b600/ffffffff7fffff00>
>>RCX; 00000000f7837878 <phys_startup_64+f7637778/ffffffff7fffff00>
>>RSI; ffff810024e4fcd8 <phys_startup_64+ffff810024c4fbd8/ffffffff7fffff00>
>>RBP; ffff810024e4fcd8 <phys_startup_64+ffff810024c4fbd8/ffffffff7fffff00>
>>R12; 000000000b7745fb <phys_startup_64+b5744fb/ffffffff7fffff00>
>>R14; 0000000077c3cc34 <phys_startup_64+77a3cb34/ffffffff7fffff00>
>>R15; ffff81000fc4cc80 <phys_startup_64+ffff81000fa4cb80/ffffffff7fffff00>

Trace; ffffffff80262975 <_spin_lock_irq+33/38>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff8020ffa0 <lru_cache_add_active+4f/51>
Trace; ffffffff802106f3 <do_wp_page+401/4aa>
Trace; ffffffff80208ff9 <__handle_mm_fault+96b/9e2>
Trace; ffffffff8020aab5 <do_page_fault+364/817>
Trace; ffffffff8020ab74 <do_page_fault+423/817>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff8025fe30 <thread_return+88/12d>
Trace; ffffffff80262c8d <error_exit+0/96>

Code;  ffffffff802078b8 <_raw_spin_lock+7b/f9>
0000000000000000 <_RIP>:
Code;  ffffffff802078b8 <_raw_spin_lock+7b/f9>   <=====
   0:   31 c0                     xor    %eax,%eax   <=====
Code;  ffffffff802078ba <_raw_spin_lock+7d/f9>
   2:   87 03                     xchg   %eax,(%rbx)
Code;  ffffffff802078bc <_raw_spin_lock+7f/f9>
   4:   85 c0                     test   %eax,%eax
Code;  ffffffff802078be <_raw_spin_lock+81/f9>
   6:   7f 55                     jg     5d <_RIP+0x5d>
Code;  ffffffff802078c0 <_raw_spin_lock+83/f9>
   8:   bf 01 00 00 00            mov    $0x1,%edi
Code;  ffffffff802078c5 <_raw_spin_lock+88/f9>
   d:   49 ff c4                  inc    %r12
Code;  ffffffff802078c8 <_raw_spin_lock+8b/f9>
  10:   e8 d2 53 00 00            callq  53e7 <_RIP+0x53e7>

Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff80215c6f>] __lru_add_drain+0x49/0x4d
 [<ffffffff8022e562>] lru_add_drain+0x11/0x13
 [<ffffffff8023969a>] exit_mmap+0x27/0xf1
 [<ffffffff8023b8af>] mmput+0x3d/0x8f
 [<ffffffff8023ffe6>] exit_mm+0xe1/0xea
 [<ffffffff8021490a>] do_exit+0x230/0x83d
 [<ffffffff80267306>] sync_regs+0x0/0x71
 [<ffffffff80272c5b>] nmi_watchdog_tick+0x151/0x23b
 [<ffffffff80267e1d>] default_do_nmi+0x83/0x1c8
 [<ffffffff80272d89>] do_nmi+0x44/0x6f
 [<ffffffff80262f7f>] nmi+0x7f/0x80
 [<ffffffff802078be>] _raw_spin_lock+0x81/0xf9
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff80228ebd>] do_sigaction+0x17a/0x190
 [<ffffffff802621ca>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80262c8d>] error_exit+0x0/0x96
Call Trace:
 [<ffffffff80262975>] _spin_lock_irq+0x33/0x38
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff80215c6f>] __lru_add_drain+0x49/0x4d
 [<ffffffff8022e562>] lru_add_drain+0x11/0x13
 [<ffffffff8023969a>] exit_mmap+0x27/0xf1
 [<ffffffff8023b8af>] mmput+0x3d/0x8f
 [<ffffffff8023ffe6>] exit_mm+0xe1/0xea
 [<ffffffff8021490a>] do_exit+0x230/0x83d
 [<ffffffff80267306>] sync_regs+0x0/0x71
 [<ffffffff80272c5b>] nmi_watchdog_tick+0x151/0x23b
 [<ffffffff80267e1d>] default_do_nmi+0x83/0x1c8
 [<ffffffff80272d89>] do_nmi+0x44/0x6f
 [<ffffffff80262f7f>] nmi+0x7f/0x80
 [<ffffffff802078b8>] _raw_spin_lock+0x7b/0xf9
 [<ffffffff8020d436>] __pagevec_lru_add_active+0x62/0xdf
 [<ffffffff8020ffa0>] lru_cache_add_active+0x4f/0x51
 [<ffffffff802106f3>] do_wp_page+0x401/0x4aa
 [<ffffffff80208ff9>] __handle_mm_fault+0x96b/0x9e2
 [<ffffffff8020aab5>] do_page_fault+0x364/0x817
 [<ffffffff8020ab74>] do_page_fault+0x423/0x817
 [<ffffffff802629e0>] _spin_unlock_irq+0x2b/0x31
 [<ffffffff8025fe30>] thread_return+0x88/0x12d
 [<ffffffff80262c8d>] error_exit+0x0/0x96
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff80262975 <_spin_lock_irq+33/38>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff80215c6f <__lru_add_drain+49/4d>
Trace; ffffffff8022e562 <lru_add_drain+11/13>
Trace; ffffffff8023969a <exit_mmap+27/f1>
Trace; ffffffff8023b8af <mmput+3d/8f>
Trace; ffffffff8023ffe6 <exit_mm+e1/ea>
Trace; ffffffff8021490a <do_exit+230/83d>
Trace; ffffffff80267306 <sync_regs+0/71>
Trace; ffffffff80272c5b <nmi_watchdog_tick+151/23b>
Trace; ffffffff80267e1d <default_do_nmi+83/1c8>
Trace; ffffffff80272d89 <do_nmi+44/6f>
Trace; ffffffff80262f7f <nmi+7f/80>
Trace; ffffffff802078be <_raw_spin_lock+81/f9>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff8020ffa0 <lru_cache_add_active+4f/51>
Trace; ffffffff802106f3 <do_wp_page+401/4aa>
Trace; ffffffff80208ff9 <__handle_mm_fault+96b/9e2>
Trace; ffffffff8020aab5 <do_page_fault+364/817>
Trace; ffffffff8020ab74 <do_page_fault+423/817>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff80228ebd <do_sigaction+17a/190>
Trace; ffffffff802621ca <trace_hardirqs_on_thunk+35/37>
Trace; ffffffff80262c8d <error_exit+0/96>
Trace; ffffffff80262975 <_spin_lock_irq+33/38>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff80215c6f <__lru_add_drain+49/4d>
Trace; ffffffff8022e562 <lru_add_drain+11/13>
Trace; ffffffff8023969a <exit_mmap+27/f1>
Trace; ffffffff8023b8af <mmput+3d/8f>
Trace; ffffffff8023ffe6 <exit_mm+e1/ea>
Trace; ffffffff8021490a <do_exit+230/83d>
Trace; ffffffff80267306 <sync_regs+0/71>
Trace; ffffffff80272c5b <nmi_watchdog_tick+151/23b>
Trace; ffffffff80267e1d <default_do_nmi+83/1c8>
Trace; ffffffff80272d89 <do_nmi+44/6f>
Trace; ffffffff80262f7f <nmi+7f/80>
Trace; ffffffff802078b8 <_raw_spin_lock+7b/f9>
Trace; ffffffff8020d436 <__pagevec_lru_add_active+62/df>
Trace; ffffffff8020ffa0 <lru_cache_add_active+4f/51>
Trace; ffffffff802106f3 <do_wp_page+401/4aa>
Trace; ffffffff80208ff9 <__handle_mm_fault+96b/9e2>
Trace; ffffffff8020aab5 <do_page_fault+364/817>
Trace; ffffffff8020ab74 <do_page_fault+423/817>
Trace; ffffffff802629e0 <_spin_unlock_irq+2b/31>
Trace; ffffffff8025fe30 <thread_return+88/12d>
Trace; ffffffff80262c8d <error_exit+0/96>

0000:04:08.0: ttyS0 at I/O 0xc880 (irq = 19) is a 16550A
ehci_hcd 0000:00:0b.1: debug port 1
9765511 blocks
lo: Disabled Privacy Extensions

3 warnings and 1 error issued.  Results may not be reliable.

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
