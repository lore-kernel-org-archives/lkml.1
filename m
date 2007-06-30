Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbXF3FAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbXF3FAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 01:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXF3E74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 00:59:56 -0400
Received: from mx34.mail.ru ([194.67.23.200]:22017 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751405AbXF3E7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 00:59:53 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: michal.k.k.piotrowski@gmail.com, rjwysocki@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sat, 30 Jun 2007 08:59:46 +0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6434392.uPL0PW9rUp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706300859.47133.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6434392.uPL0PW9rUp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Since 2.6.18 I do not have suspend to RAM; now I am starting to lose suspen=
d=20
to disk :)

Environment - vanilla kernel (2.6.22-rc6 currently + squashfs + single=20
pata_ali patch to switch off DMA on CD-ROM), single root on reiserfs, libat=
a=20
with pata_ali driver.

Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-rc syste=
m=20
hung at least once in every rcX. Up to rc6 those lockups were absolutely=20
silent (black screen without reaction to any key). In rc6 I just got=20
something different. After resume I got on screem:

swsusp: Marking nosave pages: 000000000009f000-0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed

After that it just sits there doing nothing. Ther was brief sound of HDD bu=
t I=20
suspect it was related more to power-on. System was responding to power-on=
=20
button press:

ACPI Error (event-0305): No installed handler for fixed event [00000002=20
20070125]

And SysRq was functioning. Unfortunately I do not have serial console so I=
=20
copy manually stacks from several last screens of output; I have tried to=20
make a photo but right now my kbluetooth is refusing to work at all so I=20
cannot transfer them :( (but I suspect quality would be too bad anyway)

laptop_mode D
	io_schedule+0xe/0x20
	sync_buffer+0x35/0x40
	__wait_on_bit+0x45/0x70
	out_of_line_wait_on_bit+0x6c/0x80
	__wait_on_buffer+0x27/0x30
	search_by_key+0x15e/0x1250 [reiserfs]
	reiserfs_read_locked_inode+0x64/0x570 [reiserfs]
	reiserfs_iget+0x7e/0xa0 [reiserfs]
	reiserfs_lookup+0xc7/0x120 [reiserfs]
	do_lookup+0x138/0x180
	__link_path_walk+0x787/0xce0
	link_path_walk+0x44/0xc0
	path_walk+0x18/0x20
	do_path_lookup_0x88/0x210
	__path_lookupintent_open+0x4d/0x90
	path_lookup_open+0x1f/0x30
	open_exec+0x28/0xb0
	do_execve+0x36/0x1d0
	sys_execve+0x2e/0x80
	sysenter_past_esp+0x5f/0x99

90clock D
	__mutex_lock_slow_path+0xa1/0x290
	mutex_lock+0x21/0x30
	do_lookup+0xa1/0x180
	__link_path_walk+0x44/0xc0
	path_walk+0x18/0x20
	do_path_lookup+0x78/0x210
	__user_walk_fd+0x38/0x50
	vfs_stat_fd+0x21/0x50
	vfs_stat+0x11/0x20
	sys_stat64+0x14/0x30
	sysenter_past_esp+0x5f/0x99

alsactl D
	io_schedule+0xe/0x20
	sync_page+0x35/0x40
	__wait_on_bit_lock+0x3f/0x70
	__lock_page+0x68/0x70
	filemap_nopage+0x16c/0x300
	__handle_mm_faul+0x1d7/0x610
	do_page_fault+0x1d7/0x610
	error_code+0x6a/0x70
	padzero+0x1f/0x30
	load_elf_binary+0x743/0x1ab0
	search_binary_handler+0x7b/0x1f0
	do_execve+0x137/0x1d0
	sys_execve+0x2e/0x80
	sysenter_past_esp+0x5f/0x90

After that I could remount, sync and reboot using SysRq (well, after reboot=
 it=20
still insisted on replaying insane number of transactions so may be it did=
=20
*not* remount / ro after all). Before reboot there was brief output that=20
resembled lockdep warnings, but it went too fast to be readable.

usual stuff follows

dmesg:=20
[    0.000000] Linux version 2.6.22-rc6-1avb (bor@cooker) (gcc version 4.1.=
2=20
20070302 (prerelease) (4.1.2-1mdv2007.1)) #17 Mon Jun 25 22:07:05 MSD 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 495MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 126816) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] On node 0 totalpages: 126816
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 958 pages used for memmap
[    0.000000]   Normal zone: 121762 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 -=
=20
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 -=
=20
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 -=
=20
0000000000100000
[    0.000000] Built 1 zonelists.  Total pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.22-rc6-1avb root=3DLAB=
EL=3D/=20
resume=3D/dev/sda1 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.774 MHz processor.
[  149.509948] Console: colour dummy device 80x25
[  149.510191] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[  149.510207] ... MAX_LOCKDEP_SUBCLASSES:    8
[  149.510217] ... MAX_LOCK_DEPTH:          30
[  149.510227] ... MAX_LOCKDEP_KEYS:        2048
[  149.510237] ... CLASSHASH_SIZE:           1024
[  149.510247] ... MAX_LOCKDEP_ENTRIES:     8192
[  149.510257] ... MAX_LOCKDEP_CHAINS:      16384
[  149.510267] ... CHAINHASH_SIZE:          8192
[  149.510277]  memory used by lock dependency info: 992 kB
[  149.510288]  per task-struct memory footprint: 1200 bytes
[  149.510301] ------------------------
[  149.510310] | Locking API testsuite:
[ =20
149.510319] ---------------------------------------------------------------=
=2D------------
[  149.510336]                                  | spin |wlock |rlock |mutex=
 |=20
wsem | rsem |
[ =20
149.510352]   -------------------------------------------------------------=
=2D------------
[  149.510396]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.512993]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.514850]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.516746]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.518641]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.520595]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.522549]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.524509]                     double unlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.526307]                   initialize held:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  149.528096]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[ =20
149.529938]   -------------------------------------------------------------=
=2D------------
[  149.529954]               recursive read-lock:             | =20
ok  |             |  ok  |
[  149.530566]            recursive read-lock #2:             | =20
ok  |             |  ok  |
[  149.531177]             mixed read-write-lock:             | =20
ok  |             |  ok  |
[  149.531793]             mixed write-read-lock:             | =20
ok  |             |  ok  |
[ =20
149.532409]   -------------------------------------------------------------=
=2D------------
[  149.532425]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  149.533342]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  149.534259]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  149.535163]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  149.536067]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[  149.536978]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[  149.537884]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  149.538788]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  149.539699]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  149.540607]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  149.541514]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  149.542446]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  149.543376]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  149.544304]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  149.545234]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  149.546165]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  149.547097]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  149.548021]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  149.548951]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  149.549864]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  149.550778]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  149.551703]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  149.552632]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  149.553558]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  149.554493]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  149.555419]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  149.556350]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  149.557277]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  149.558208]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  149.559132]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  149.560060]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  149.560985]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  149.561916]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  149.562840]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  149.563770]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  149.564702]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  149.565636]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  149.566566]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  149.567503]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  149.568432]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  149.569366]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  149.570292]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  149.571223]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  149.572150]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  149.573088]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  149.574012]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  149.574944]       hard-irq read-recursion/123:  ok  |
[  149.575261]       soft-irq read-recursion/123:  ok  |
[  149.575581]       hard-irq read-recursion/132:  ok  |
[  149.575900]       soft-irq read-recursion/132:  ok  |
[  149.576219]       hard-irq read-recursion/213:  ok  |
[  149.576535]       soft-irq read-recursion/213:  ok  |
[  149.576854]       hard-irq read-recursion/231:  ok  |
[  149.577171]       soft-irq read-recursion/231:  ok  |
[  149.577489]       hard-irq read-recursion/312:  ok  |
[  149.577806]       soft-irq read-recursion/312:  ok  |
[  149.578123]       hard-irq read-recursion/321:  ok  |
[  149.578440]       soft-irq read-recursion/321:  ok  |
[  149.578760] -------------------------------------------------------
[  149.578773] Good, all 218 testcases passed! |
[  149.578783] ---------------------------------
[  149.580428] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[  149.583386] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[  149.687843] Memory: 495772k/507264k available (1776k kernel code, 10952k=
=20
reserved, 797k data, 184k init, 0k highmem)
[  149.687917] virtual kernel memory layout:
[  149.687921]     fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
[  149.687925]     vmalloc : 0xdf800000 - 0xffff6000   ( 519 MB)
[  149.687929]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[  149.687934]       .init : 0xc0386000 - 0xc03b4000   ( 184 kB)
[  149.687938]       .data : 0xc02bc2c6 - 0xc0383a64   ( 797 kB)
[  149.687942]       .text : 0xc0100000 - 0xc02bc2c6   (1776 kB)
[  149.687985] Checking if this processor honours the WP bit even in=20
supervisor mode... Ok.
[  149.772147] Calibrating delay using timer specific routine.. 1497.61=20
BogoMIPS (lpj=3D2495379)
[  149.772450] Mount-cache hash table entries: 512
[  149.773396] CPU: After generic identify, caps: 0383f9ff 00000000 0000000=
0=20
00000000 00000000 00000000 00000000
[  149.773433] CPU: L1 I cache: 16K, L1 D cache: 16K
[  149.773451] CPU: L2 cache: 256K
[  149.773468] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040=20
00000000 00000000 00000000
[  149.773503] Compat vDSO mapped to ffffe000.
[  149.773558] CPU: Intel Pentium III (Coppermine) stepping 0a
[  149.773584] Checking 'hlt' instruction... OK.
[  149.785829] ACPI: Core revision 20070126
[  149.794831] ACPI: setting ELCR to 0200 (from 0a00)
[  149.796947] NET: Registered protocol family 16
[  149.798194] ACPI: bus type pci registered
[  149.799315] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[  149.799332] PCI: Using configuration type 1
[  149.799343] Setting up standard PCI resources
[  149.815787] ACPI: Interpreter enabled
[  149.815839] ACPI: (supports S0 S3 S4 S5)
[  149.815958] ACPI: Using PIC for interrupt routing
[  149.844518] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  149.844657] PCI: Probing PCI hardware (bus 00)
[  149.845872] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[  149.845901] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[  149.845969] PCI: Firmware left 0000:00:0a.0 e100 interrupts enabled,=20
disabling
[  149.847602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  149.848090] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[  149.869380] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[  149.870048] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[  149.870677] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[  149.871318] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[  149.871948] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[  149.872600] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[  149.873658] ACPI: Power Resource [PFAN] (off)
[  149.873725] Linux Plug and Play Support v0.97 (c) Adam Belay
[  149.873845] pnp: PnP ACPI init
[  149.873959] ACPI: bus type pnp registered
[  149.894471] pnp: PnP ACPI: found 12 devices
[  149.894516] ACPI: ACPI bus type pnp unregistered
[  149.894827] PCI: Using ACPI for IRQ routing
[  149.894844] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[  149.905433] Time: tsc clocksource has been installed.
[  149.905985] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[  149.906011] pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
[  149.906028] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[  149.906045] pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[  149.938077] PCI: Bridge: 0000:00:01.0
[  149.938108]   IO window: disabled.
[  149.938128]   MEM window: f7f00000-fdffffff
[  149.938145]   PREFETCH window: 48000000-480fffff
[  149.938166] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[  149.938178]   IO window: 00001000-000010ff
[  149.938194]   IO window: 00001400-000014ff
[  149.938210]   PREFETCH window: 30000000-33ffffff
[  149.938226]   MEM window: 34000000-37ffffff
[  149.938241] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[  149.938253]   IO window: 00001800-000018ff
[  149.938268]   IO window: 00001c00-00001cff
[  149.938284]   PREFETCH window: 38000000-3bffffff
[  149.938300]   MEM window: 3c000000-3fffffff
[  149.938316] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[  149.938327]   IO window: 00002000-000020ff
[  149.938342]   IO window: 00002400-000024ff
[  149.938358]   PREFETCH window: 40000000-43ffffff
[  149.938374]   MEM window: 44000000-47ffffff
[  149.938411] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  149.938452] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[  149.939883] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  149.939906] PCI: setting IRQ 11 as level-triggered
[  149.939915] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
=20
(level, low) -> IRQ 11
[  149.939970] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[  149.941026] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[  149.941042] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
=20
(level, low) -> IRQ 11
[  149.941094] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[  149.942168] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[  149.942184] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
=20
(level, low) -> IRQ 11
[  149.942318] NET: Registered protocol family 2
[  149.975626] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[  149.976102] TCP established hash table entries: 16384 (order: 7, 720896=
=20
bytes)
[  149.982713] TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
[  149.989453] TCP: Hash tables configured (established 16384 bind 16384)
[  149.989635] TCP reno registered
[  149.999604] checking if image is initramfs... it is
[  150.289369] Freeing initrd memory: 1467k freed
[  150.291869] audit: initializing netlink socket (disabled)
[  150.292066] audit(1183176386.219:1): initialized
[  150.293388] io scheduler noop registered
[  150.293413] io scheduler anticipatory registered
[  150.293425] io scheduler deadline registered
[  150.293484] io scheduler cfq registered (default)
[  150.293571] Activating ISA DMA hang workarounds.
[  150.293618] Boot video device is 0000:01:00.0
[  150.294459] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng=20
3072k, total 16384k
[  150.294496] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[  150.294510] vesafb: protected mode interface info at c000:775e
[  150.294524] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[  150.294537] vesafb: scrolling: redraw
[  150.294550] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[  150.365069] Console: switching to colour frame buffer device 128x48
[  150.430316] fb0: VESA VGA frame buffer device
[  150.438741] Switched to high resolution mode on CPU 0
[  150.723469] Real Time Clock Driver v1.12ac
[  150.728453] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
=20
blocksize
[  150.731339] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[  150.737090] serio: i8042 KBD port at 0x60,0x64 irq 1
[  150.737790] serio: i8042 AUX port at 0x60,0x64 irq 12
[  150.739621] mice: PS/2 mouse device common for all mice
[  150.741119] NET: Registered protocol family 1
[  150.741728] Using IPI Shortcut mode
[  150.743673] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[  150.745544] Freeing unused kernel memory: 184k freed
[  150.746494] Write protecting the kernel read-only data: 647k
[  150.780285] SCSI subsystem initialized
[  150.809492] input: AT Translated Set 2 keyboard as /class/input/input0
[  150.836367] libata version 2.21 loaded.
[  150.869310] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  150.895102] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  150.921077] scsi0 : pata_ali
[  150.946453] scsi1 : pata_ali
[  150.971029] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma=
=20
0x0001eff0 irq 14
[  150.996036] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma=
=20
0x0001eff8 irq 15
[  151.179128] ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors=
 =3D=20
39070080
[  151.203970] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[  151.228882] ata1.00: 39070080 sectors, multi 0: LBA=20
[  151.253672] ata1.00: limited to UDMA/33 due to 40-wire cable
[  151.292407] ata1.00: ata_hpa_resize 1: sectors =3D 39070080, hpa_sectors=
 =3D=20
39070080
[  151.317745] ata1.00: configured for UDMA/33
[  151.695434] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[  151.925381] ata2.00: configured for UDMA/33
[  151.952116] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA=
3O=20
PQ: 0 ANSI: 5
[  151.981709] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 13=
13=20
PQ: 0 ANSI: 5
[  152.043172] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[  152.069872] sd 0:0:0:0: [sda] Write Protect is off
[  152.096009] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  152.096144] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[  152.123348] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[  152.150047] sd 0:0:0:0: [sda] Write Protect is off
[  152.176476] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  152.176578] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[  152.203561]  sda: sda1 sda2
[  152.257189] sd 0:0:0:0: [sda] Attached SCSI disk
[  152.824389] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[  152.824417] swsusp: Basic memory bitmaps created
[  152.860554] swsusp: Basic memory bitmaps freed
[  152.986271] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[  153.011503] ReiserFS: sda2: using ordered data mode
[  153.065503] ReiserFS: sda2: journal params: device sda2, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[  153.126032] ReiserFS: sda2: checking transaction log (sda2)
[  237.615848] ReiserFS: sda2: replayed 215 transactions in 84 seconds
[  238.059854] ReiserFS: sda2: Using r5 hash to sort names
[  245.216410] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  245.216500] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[  245.583421] usbcore: registered new interface driver usbfs
[  245.583736] usbcore: registered new interface driver hub
[  245.583876] usbcore: registered new device driver usb
[  245.674042] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
[  245.674057] e100: Copyright(c) 1999-2006 Intel Corporation
[  245.675797] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  245.675811] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
=20
(level, low) -> IRQ 11
[  245.704263] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:D7:14:A1
[  245.837801] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[  245.839429] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  245.839442] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[  245.839509] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  245.841383] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[  245.841470] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  245.883060] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[  245.883085] Uniform CD-ROM driver Revision: 3.20
[  245.883591] sr 1:0:0:0: Attached scsi CD-ROM sr0
[  245.897694] usb usb1: configuration #1 chosen from 1 choice
[  245.898023] hub 1-0:1.0: USB hub found
[  245.898124] hub 1-0:1.0: 3 ports detected
[  245.953060] Linux agpgart interface v0.102 (c) Dave Jones
[  246.003878] agpgart: Detected ALi M1644 chipset
[  246.014204] agpgart: AGP aperture is 64M @ 0xf0000000
[  246.241005] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  246.241061] Yenta: Using CSCINT to route CSC interrupts to PCI
[  246.241068] Yenta: Routing CardBus interrupts to PCI
[  246.241081] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  246.471429] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  246.471445] Socket status: 30000059
[  246.472485] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  246.598278] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  246.598294] Socket status: 30000007
[  246.599211] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  246.637275] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=20
sharing enabled
[  246.724810] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  246.724827] Socket status: 30000007
[  246.729762] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  246.729784] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[  246.947074] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  247.104065] pccard: PCMCIA card inserted into slot 0
[  247.127514] NET: Registered protocol family 23
[  247.160721] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  247.160755] Activated ALi 1533 ISA bridge port 0x02e8.
[  247.160768] Activated ALi 1533 ISA bridge port 0x02f8.
[  247.167221] pnp: Device 00:0a activated.
[  247.167275] smsc_ircc_present(), addr 0x02e8 - no device found!
[  247.168808] pnp: Device 00:0a disabled.
[  251.246624] cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcbff=
f=20
0xe0000-0xfffff
[  251.250361] cs: memory probe 0x60000000-0x60ffffff: clean.
[  251.262086] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  251.274209] pcmcia: registering new device pcmcia0.0
[  251.515241] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[  251.515261] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[  251.515270] *** Station Mode (STA) Support: YES
[  251.515276] *** Access Point Mode (AP) Support: YES
[  252.004937] eth1: PRI 31 variant 2 version 9.48
[  252.005004] eth1: NIC 5 variant 2 version 1.02
[  252.008821] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[  252.486400] Toshiba System Managment Mode driver v1.11 26/9/2001
[  252.656154] Non-volatile memory driver v1.2
[  252.770911] input: ImPS/2 Generic Wheel Mouse as /class/input/input1
[  253.425520] ACPI: AC Adapter [ADP1] (on-line)
[  253.473142] ACPI: Battery Slot [BAT1] (battery present)
[  253.473311] ACPI: Battery Slot [BAT2] (battery absent)
[  253.526466] input: Power Button (FF) as /class/input/input2
[  253.649541] ACPI: Power Button (FF) [PWRF]
[  253.675105] input: Lid Switch as /class/input/input3
[  253.769284] ACPI: Lid Switch [LID]
[  253.869262] ACPI: Transitioning device [FAN] to D3
[  253.869278] ACPI: Transitioning device [FAN] to D3
[  253.869303] ACPI: Fan [FAN] (off)
[  253.924528] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  253.997642] ACPI: Thermal Zone [THRM] (55 C)
[  104.349989] Marking TSC unstable due to: possible TSC halt in C2.
[  104.353322] Time: acpi_pm clocksource has been installed.
[  104.363322] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  104.363322] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  104.416656] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[  104.629989] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:=
=20
dm-devel@redhat.com
[  104.749989] Clocksource tsc unstable (delta =3D -134169019 ns)
[  105.006656] loop: module loaded
[  108.389989] ReiserFS: sda2: Removing [1493531 1549696 0x0 SD]..done
[  108.409989] ReiserFS: sda2: Removing [28871 1413609 0x0 SD]..done
[  108.429989] ReiserFS: sda2: Removing [35299 693805 0x0 SD]..done
[  108.453322] ReiserFS: sda2: Removing [35299 210457 0x0 SD]..done
[  108.456655] ReiserFS: sda2: Removing [35299 210455 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [35299 203190 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [35299 195221 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [28871 116283 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [21277 42898 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [21277 42896 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [21277 42895 0x0 SD]..done
[  108.469989] ReiserFS: sda2: Removing [21277 42871 0x0 SD]..done
[  108.469989] ReiserFS: sda2: There were 12 uncompleted unlinks/truncates.=
=20
Completed
[  109.439989] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k
[  124.339987] Bluetooth: Core ver 2.11
[  124.339987] NET: Registered protocol family 31
[  124.339987] Bluetooth: HCI device and connection manager initialized
[  124.339987] Bluetooth: HCI socket layer initialized
[  124.426654] Bluetooth: L2CAP ver 2.8
[  124.426654] Bluetooth: L2CAP socket layer initialized
[  125.306654] Bluetooth: RFCOMM socket layer initialized
[  125.309987] Bluetooth: RFCOMM TTY layer initialized
[  125.309987] Bluetooth: RFCOMM ver 1.8
[  126.296654] NET: Registered protocol family 17
[  130.203320] eth1: PRI 31 variant 2 version 9.48
[  130.203320] eth1: NIC 5 variant 2 version 1.02
[  130.893320] eth1: PRI 31 variant 2 version 9.48
[  130.893320] eth1: NIC 5 variant 2 version 1.02
[  131.249986] eth1: PRI 31 variant 2 version 9.48
[  131.249986] eth1: NIC 5 variant 2 version 1.02
[  639.396602] usb 1-1: new full speed USB device using ohci_hcd and addres=
s 2
[  639.663269] usb 1-1: configuration #1 chosen from 1 choice
[  640.423269] Bluetooth: HCI USB driver ver 2.9
[  640.439935] usbcore: registered new interface driver hci_usb
[ 1492.416517] usb 1-1: USB disconnect, address 2

config:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc6
# Mon Jun 25 20:37:27 2007
#
CONFIG_X86_32=3Dy
CONFIG_GENERIC_TIME=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_X86=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_BROKEN_ON_SMP=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32

#
# General setup
#
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_EMBEDDED=3Dy
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLAB=3Dy
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0

#
# Loadable module support
#
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=3Dy

#
# Block layer
#
CONFIG_BLOCK=3Dy
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
# CONFIG_SMP is not set
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=3Dy
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D5
CONFIG_X86_XADD=3Dy
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_GOOD_APIC=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_MODEL=3D4
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=3Dy
CONFIG_TOSHIBA=3Dm
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=3Dy
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_NOHIGHMEM=3Dy
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=3Dy
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_FLATMEM_MANUAL=3Dy
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
CONFIG_SPARSEMEM_STATIC=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_NR_QUICK=3D1
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=3D0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=3Dy
CONFIG_PM_STD_PARTITION=3D""

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_SLEEP_PROC_FS=3Dy
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=3Dm
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dm
CONFIG_ACPI_SBS=3Dm
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dm
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=3Dy
CONFIG_PCI_BIOS=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=3Dy
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
CONFIG_PCCARD=3Dm
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
CONFIG_PCMCIA_IOCTL=3Dy
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=3Dm
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_AOUT=3Dm
CONFIG_BINFMT_MISC=3Dm

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_MULTIPATH_CACHED=3Dy
CONFIG_IP_ROUTE_MULTIPATH_RR=3Dm
CONFIG_IP_ROUTE_MULTIPATH_RANDOM=3Dm
CONFIG_IP_ROUTE_MULTIPATH_WRANDOM=3Dm
CONFIG_IP_ROUTE_MULTIPATH_DRR=3Dm
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_BEET=3Dm
CONFIG_INET_DIAG=3Dy
CONFIG_INET_TCP_DIAG=3Dy
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dm
CONFIG_TCP_CONG_CUBIC=3Dm
CONFIG_TCP_CONG_WESTWOOD=3Dm
CONFIG_TCP_CONG_HTCP=3Dm
CONFIG_TCP_CONG_HSTCP=3Dm
CONFIG_TCP_CONG_HYBLA=3Dm
CONFIG_TCP_CONG_VEGAS=3Dm
CONFIG_TCP_CONG_SCALABLE=3Dm
CONFIG_TCP_CONG_LP=3Dm
CONFIG_TCP_CONG_VENO=3Dm
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"reno"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK_ENABLED=3Dm
CONFIG_NF_CONNTRACK=3Dm
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=3Dy
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_GRE=3Dm
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NETFILTER_XTABLES=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_IPRANGE=3Dm
CONFIG_IP_NF_MATCH_TOS=3Dm
CONFIG_IP_NF_MATCH_RECENT=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_MATCH_OWNER=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_SAME=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PROTO_GRE=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_TFTP=3Dm
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_TOS=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=3Dm
CONFIG_VLAN_8021Q=3Dm
# CONFIG_DECNET is not set
CONFIG_LLC=3Dm
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=3Dy
CONFIG_NET_SCH_FIFO=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dm
CONFIG_NET_SCH_HTB=3Dm
CONFIG_NET_SCH_HFSC=3Dm
CONFIG_NET_SCH_PRIO=3Dm
CONFIG_NET_SCH_RED=3Dm
CONFIG_NET_SCH_SFQ=3Dm
CONFIG_NET_SCH_TEQL=3Dm
CONFIG_NET_SCH_TBF=3Dm
CONFIG_NET_SCH_GRED=3Dm
CONFIG_NET_SCH_DSMARK=3Dm
CONFIG_NET_SCH_NETEM=3Dm
CONFIG_NET_SCH_INGRESS=3Dm

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dm
CONFIG_NET_CLS_TCINDEX=3Dm
CONFIG_NET_CLS_ROUTE4=3Dm
CONFIG_NET_CLS_ROUTE=3Dy
CONFIG_NET_CLS_FW=3Dm
CONFIG_NET_CLS_U32=3Dm
CONFIG_CLS_U32_PERF=3Dy
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dm
CONFIG_NET_CLS_RSVP6=3Dm
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dm
CONFIG_NET_EMATCH_NBYTE=3Dm
CONFIG_NET_EMATCH_U32=3Dm
CONFIG_NET_EMATCH_META=3Dm
CONFIG_NET_EMATCH_TEXT=3Dm
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dm
CONFIG_NET_ACT_GACT=3Dm
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dm
CONFIG_NET_ACT_IPT=3Dm
CONFIG_NET_ACT_PEDIT=3Dm
CONFIG_NET_ACT_SIMP=3Dm
CONFIG_NET_CLS_IND=3Dy
CONFIG_NET_ESTIMATOR=3Dy

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dm
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
CONFIG_IRDA_ULTRA=3Dy

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=3Dm

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set

#
# Old SIR device drivers
#
CONFIG_IRPORT_SIR=3Dm

#
# Old Serial dongle support
#
# CONFIG_DONGLE_OLD is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
CONFIG_TOSHIBA_FIR=3Dm
CONFIG_SMC_IRCC_FIR=3Dm
CONFIG_ALI_FIR=3Dm
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=3Dm
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy

#
# Wireless
#
CONFIG_CFG80211=3Dm
CONFIG_WIRELESS_EXT=3Dy
CONFIG_MAC80211=3Dm
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=3Dm
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=3Dm
CONFIG_IEEE80211_CRYPT_CCMP=3Dm
CONFIG_IEEE80211_CRYPT_TKIP=3Dm
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dm
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
CONFIG_CONNECTOR=3Dm
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
CONFIG_BLK_DEV_NBD=3Dm
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D32000
CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
CONFIG_CDROM_PKTCDVD=3Dy
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_BLINK is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dm
CONFIG_SCSI_TGT=3Dm
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dm
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# PCMCIA SCSI adapter support
#
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_NINJA_SCSI is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_ATA=3Dm
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ALI=3Dm
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=3Dm
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_PLATFORM=3Dm

#
# Multi-device support (RAID and LVM)
#
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dm
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dm
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_EMC=3Dm
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# Network device support
#
CONFIG_NETDEVICES=3Dy
# CONFIG_IFB is not set
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
# CONFIG_EQUALIZER is not set
CONFIG_TUN=3Dm
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set

#
# Tulip family network device support
#
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=3Dm
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=3Dy
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dm
# CONFIG_NET_FC is not set
CONFIG_SHAPER=3Dm
CONFIG_NETCONSOLE=3Dm
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_TSDEV=3Dm
CONFIG_INPUT_TSDEV_SCREEN_X=3D240
CONFIG_INPUT_TSDEV_SCREEN_Y=3D320
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dm
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=3Dm
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dm
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=3Dm
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dm
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=3Dm
CONFIG_RTC=3Dy
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=3Dm
CONFIG_AGP_ALI=3Dm
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D256
CONFIG_HPET=3Dy
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dm

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dm
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dm

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCF=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dm
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_STUB=3Dm
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
CONFIG_SENSORS_EEPROM=3Dm
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
CONFIG_HWMON=3Dm
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=3Dm
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dm
CONFIG_LCD_CLASS_DEVICE=3Dm
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=3Dy
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=3Dy
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=3Dy
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=3Dy
CONFIG_LOGO_LINUX_MONO=3Dy
CONFIG_LOGO_LINUX_VGA16=3Dy
CONFIG_LOGO_LINUX_CLUT224=3Dy

#
# Sound
#
CONFIG_SOUND=3Dm

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
CONFIG_SND_RTCTIMER=3Dm
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=3Dy
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=3Dm
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=3Dy

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm

#
# HID Devices
#
CONFIG_HID=3Dm
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dm
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=3Dm
CONFIG_USB_MOUSE=3Dm

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=3Dm
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
CONFIG_USB_STORAGE_DPCM=3Dy
CONFIG_USB_STORAGE_USBAT=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy
CONFIG_USB_STORAGE_ALAUDA=3Dy
CONFIG_USB_STORAGE_KARMA=3Dy
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=3Dm
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=3Dm
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=3Dy
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=3Dy
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D866
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=3Dy
CONFIG_CONFIGFS_FS=3Dm

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=3Dm
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
CONFIG_NFS_DIRECTIO=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_TCP=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
CONFIG_CIFS_STATS2=3Dy
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=3Dm
# CONFIG_CODA_FS_OLD_API is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_KPROBES=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_DEBUG_SHIRQ=3Dy
CONFIG_DETECT_SOFTLOCKUP=3Dy
CONFIG_SCHEDSTATS=3Dy
CONFIG_TIMER_STATS=3Dy
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=3Dy
CONFIG_FORCED_INLINING=3Dy
CONFIG_RCU_TORTURE_TEST=3Dm
CONFIG_LKDTM=3Dm
# CONFIG_FAULT_INJECTION is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dm
CONFIG_CRYPTO_BLKCIPHER=3Dm
CONFIG_CRYPTO_HASH=3Dm
CONFIG_CRYPTO_MANAGER=3Dm
CONFIG_CRYPTO_HMAC=3Dm
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dm
CONFIG_CRYPTO_SHA1=3Dm
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_CBC=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_LRW=3Dm
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_586=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_AES=3Dm
CONFIG_CRYPTO_AES_586=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_CRC32C=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_TEST=3Dm

#
# Hardware crypto devices
#
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=3Dy
CONFIG_LIBCRC32C=3Dm
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dm
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_KTIME_SCALAR=3Dy

--nextPart6434392.uPL0PW9rUp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGheNDR6LMutpd94wRAgavAJ4kNSCNttfOyVPg0xA0Nk9FftJUkgCeLgXJ
mRTgzS+7lAg4T8bMG07+9aU=
=XekR
-----END PGP SIGNATURE-----

--nextPart6434392.uPL0PW9rUp--
