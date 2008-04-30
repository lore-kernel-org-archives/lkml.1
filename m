Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbYD3GNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbYD3GNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760385AbYD3GNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:13:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58630
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760737AbYD3GMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:42 -0400
Date: Tue, 29 Apr 2008 23:12:41 -0700 (PDT)
Message-Id: <20080429.231241.221824292.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: y-goto@jp.fujitsu.com, akpm@linux-foundation.org
Subject: sparc64 bootup regression...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Apr_29_23_12_41_2008_792)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Tue_Apr_29_23_12_41_2008_792)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This commit causes bootup failures on sparc64:

commit 86f6dae1377523689bd8468fed2f2dd180fc0560
Author: Yasunori Goto <y-goto@jp.fujitsu.com>
Date:   Mon Apr 28 02:13:33 2008 -0700

    memory hotplug: allocate usemap on the section with pgdat
    
    Usemaps are allocated on the section which has pgdat by this.
    
    Because usemap size is very small, many other sections usemaps are allocated
    on only one page.  If a section has usemap, it can't be removed until removing
    other sections.  This dependency is not desirable for memory removing.
    
    Pgdat has similar feature.  When a section has pgdat area, it must be the last
    section for removing on the node.  So, if section A has pgdat and section B
    has usemap for section A, Both sections can't be removed due to dependency
    each other.
    
    To solve this issue, this patch collects usemap on same section with pgdat.
    If other sections doesn't have any dependency, this section will be able to be
    removed finally.
    
    Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Cc: Badari Pulavarty <pbadari@us.ibm.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

The machine in question has 64 cpus, and 16GB of ram.  CONFIG_NUMA is
not set, and this platform uses sparsemem and vmemmap.

I attach two boot logs.  The first is a successful boot, the second one
is a failing one due to the above commit:

----Next_Part(Tue_Apr_29_23_12_41_2008_792)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="good_boot.log"

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.27.1 2007/09/14 15:17'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 2.6.25 (davem@huronp11) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #124 SMP Tue Apr 29 22:43:36 PDT 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:3e:cb:f4
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 124723 bytes of memory.
[    0.000000] MDESC: Size is 59392 bytes.
[    0.000000] PLATFORM: banner-name [SPARC Enterprise T5220]
[    0.000000] PLATFORM: name [SUNW,SPARC-Enterprise-T5220]
[    0.000000] PLATFORM: hostid [803ecbf4]
[    0.000000] PLATFORM: serial# [00ab4130]
[    0.000000] PLATFORM: stick-frequency [546e74c8]
[    0.000000] PLATFORM: mac-address [144f3ecbf4]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [64]
[    0.000000] Top of RAM: 0x3ffb22000, Total RAM: 0x3f76c6000
[    0.000000] Memory hole size: 132MB
[    0.000000] Entering add_active_range(0, 16896, 2096466) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 2096467, 2096477) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 2096522, 2096529) 2 entries of 256 used
[    0.000000] [0000000200000000-fffff80009000000] page_structs=131072 node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80009400000] page_structs=131072 node=0 entry=1/0
[    0.000000] [0000000200700000-fffff80009800000] page_structs=131072 node=0 entry=2/0
[    0.000000] [0000000200700000-fffff80009c00000] page_structs=131072 node=0 entry=3/0
[    0.000000] [0000000200e00000-fffff8000a000000] page_structs=131072 node=0 entry=4/0
[    0.000000] [0000000200e00000-fffff8000a400000] page_structs=131072 node=0 entry=5/0
[    0.000000] [0000000201500000-fffff8000a800000] page_structs=131072 node=0 entry=6/0
[    0.000000] [0000000201c00000-fffff8000ac00000] page_structs=131072 node=0 entry=7/0
[    0.000000] [0000000201c00000-fffff8000b000000] page_structs=131072 node=0 entry=8/0
[    0.000000] [0000000202300000-fffff8000b400000] page_structs=131072 node=0 entry=9/0
[    0.000000] [0000000202300000-fffff8000b800000] page_structs=131072 node=0 entry=10/0
[    0.000000] [0000000202a00000-fffff8000bc00000] page_structs=131072 node=0 entry=11/0
[    0.000000] [0000000202a00000-fffff8000c000000] page_structs=131072 node=0 entry=12/0
[    0.000000] [0000000203100000-fffff8000c400000] page_structs=131072 node=0 entry=13/0
[    0.000000] [0000000203800000-fffff8000c800000] page_structs=131072 node=0 entry=14/0
[    0.000000] [0000000203800000-fffff8000cc00000] page_structs=131072 node=0 entry=15/0
[    0.000000] [0000000203f00000-fffff8000d000000] page_structs=131072 node=0 entry=16/0
[    0.000000] [0000000203f00000-fffff8000d400000] page_structs=131072 node=0 entry=17/0
[    0.000000] [0000000204600000-fffff8000d800000] page_structs=131072 node=0 entry=18/0
[    0.000000] [0000000204600000-fffff8000dc00000] page_structs=131072 node=0 entry=19/0
[    0.000000] [0000000204d00000-fffff8000e000000] page_structs=131072 node=0 entry=20/0
[    0.000000] [0000000205400000-fffff8000e400000] page_structs=131072 node=0 entry=21/0
[    0.000000] [0000000205400000-fffff8000e800000] page_structs=131072 node=0 entry=22/0
[    0.000000] [0000000205b00000-fffff8000ec00000] page_structs=131072 node=0 entry=23/0
[    0.000000] [0000000205b00000-fffff8000f000000] page_structs=131072 node=0 entry=24/0
[    0.000000] [0000000206200000-fffff8000f400000] page_structs=131072 node=0 entry=25/0
[    0.000000] [0000000206200000-fffff8000f800000] page_structs=131072 node=0 entry=26/0
[    0.000000] [0000000206900000-fffff8000fc00000] page_structs=131072 node=0 entry=27/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal      16896 ->  2096529
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:    16896 ->  2096466
[    0.000000]     0:  2096467 ->  2096477
[    0.000000]     0:  2096522 ->  2096529
[    0.000000] On node 0 totalpages: 2079587
[    0.000000]   Normal zone: 14216 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 2065371 pages, LIFO batch:15
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065371
[    0.000000] Kernel command line: root=/dev/sda2 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.010000] clocksource: mult[b4b9] shift[16]
[    0.010000] clockevent: mult[b550b0f2] shift[31]
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console handover: boot [earlyprom0] -> real [tty0]
[    0.011057] Dentry cache hash table entries: 2097152 (order: 11, 16777216 bytes)
[    0.065074] Inode-cache hash table entries: 1048576 (order: 10, 8388608 bytes)
[    0.623518] Memory: 16390776k available (2760k kernel code, 1048k data, 176k init) [fffff80000000000,00000003ffb22000]
[    0.623658] SLUB: Genslabs=13, HWalign=32, Order=0-2, MinObjects=8, CPUs=64, Nodes=1
[    0.770005] Calibrating delay using timer specific routine.. 2835.74 BogoMIPS (lpj=14178739)
[    0.770222] Mount-cache hash table entries: 512
[    0.795043] Brought up 64 CPUs
[    0.803207] net_namespace: 584 bytes
[    0.803236] ldc.c:v1.0 (June 25, 2007)
[    0.805043] NET: Registered protocol family 16
[    0.827893] VIO: Adding device channel-devices
[    0.828084] VIO: Adding device vldc-port-3-0
[    0.828257] VIO: Adding device vldc-port-3-1
[    0.828426] VIO: Adding device vldc-port-3-2
[    0.828605] VIO: Adding device vldc-port-3-3
[    0.828776] VIO: Adding device vldc-port-3-4
[    0.828951] VIO: Adding device vldc-port-3-5
[    0.829123] VIO: Adding device vldc-port-3-8
[    0.830000] VIO: Adding device vldc-port-2-0
[    0.830183] VIO: Adding device vldc-port-0-0
[    0.830366] VIO: Adding device vldc-port-0-1
[    0.830544] VIO: Adding device vldc-port-0-2
[    0.830721] VIO: Adding device vldc-port-1-0
[    0.830916] VIO: Adding device ds-1
[    0.831096] VIO: Adding device ds-0
[    0.841623] PCI: Probing for controllers.
[    0.841674] SUN4V_PCI: Registered hvapi major[1] minor[0]
[    0.841954] /pci@0: SUN4V PCI Bus Module
[    0.841974] /pci@0: On NUMA node -1
[    0.841994] /pci@0: PCI IO[c810000000] MEM[ca00000000]
[    0.886174] /pci@0: Imported 3 TSB entries from OBP
[    0.887006] /pci@0: MSI Queue first[0] num[36] count[128] devino[0x18]
[    0.887034] /pci@0: MSI first[0] num[256] mask[0xff] width[32]
[    0.887059] /pci@0: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
[    0.887088] /pci@0: MSI queues at RA [00000003fe580000]
[    0.887211] PCI: Scanning PBM /pci@0
[    0.897158] ebus: No EBus's found.
[    0.897733] ds.c:v1.0 (Jul 11, 2007)
[    0.911670] SCSI subsystem initialized
[    0.912152] usbcore: registered new interface driver usbfs
[    0.912644] usbcore: registered new interface driver hub
[    0.912938] usbcore: registered new device driver usb
[    0.962602] NET: Registered protocol family 2
[    0.970014] Switched to high resolution mode on CPU 0
[    0.970026] Switched to high resolution mode on CPU 23
[    0.970036] Switched to high resolution mode on CPU 50
[    0.970376] Switched to high resolution mode on CPU 24
[    0.970387] Switched to high resolution mode on CPU 51
[    0.972938] ds-1: Registered pri service.
[    0.972938] ds-1: Registered var-config-backup service.
[    0.990010] Switched to high resolution mode on CPU 25
[    0.990021] Switched to high resolution mode on CPU 52
[    0.990031] Switched to high resolution mode on CPU 26
[    0.990041] Switched to high resolution mode on CPU 53
[    0.990052] Switched to high resolution mode on CPU 27
[    0.990062] Switched to high resolution mode on CPU 54
[    0.990366] Switched to high resolution mode on CPU 1
[    0.990376] Switched to high resolution mode on CPU 28
[    0.990386] Switched to high resolution mode on CPU 55
[    0.991177] Switched to high resolution mode on CPU 2
[    0.991186] Switched to high resolution mode on CPU 29
[    0.991197] Switched to high resolution mode on CPU 56
[    0.991207] Switched to high resolution mode on CPU 3
[    0.991218] Switched to high resolution mode on CPU 30
[    0.991228] Switched to high resolution mode on CPU 57
[    0.991239] Switched to high resolution mode on CPU 4
[    0.991249] Switched to high resolution mode on CPU 31
[    0.991259] Switched to high resolution mode on CPU 58
[    0.991269] Switched to high resolution mode on CPU 5
[    0.991281] Switched to high resolution mode on CPU 32
[    0.991291] Switched to high resolution mode on CPU 59
[    0.991301] Switched to high resolution mode on CPU 6
[    0.991312] Switched to high resolution mode on CPU 33
[    0.991322] Switched to high resolution mode on CPU 60
[    0.993265] Switched to high resolution mode on CPU 7
[    0.993275] Switched to high resolution mode on CPU 34
[    0.993286] Switched to high resolution mode on CPU 61
[    0.993296] Switched to high resolution mode on CPU 8
[    0.993307] Switched to high resolution mode on CPU 35
[    0.993318] Switched to high resolution mode on CPU 62
[    0.993882] Switched to high resolution mode on CPU 9
[    0.993891] Switched to high resolution mode on CPU 36
[    1.003899] Switched to high resolution mode on CPU 63
[    1.003909] Switched to high resolution mode on CPU 10
[    1.003919] Switched to high resolution mode on CPU 37
[    1.003929] Switched to high resolution mode on CPU 11
[    1.003940] Switched to high resolution mode on CPU 38
[    1.003950] Switched to high resolution mode on CPU 12
[    1.003961] Switched to high resolution mode on CPU 39
[    1.003971] Switched to high resolution mode on CPU 13
[    1.003982] Switched to high resolution mode on CPU 40
[    1.003992] Switched to high resolution mode on CPU 14
[    1.004003] Switched to high resolution mode on CPU 41
[    1.004013] Switched to high resolution mode on CPU 15
[    1.004024] Switched to high resolution mode on CPU 42
[    1.004035] Switched to high resolution mode on CPU 16
[    1.004045] Switched to high resolution mode on CPU 43
[    1.004056] Switched to high resolution mode on CPU 17
[    1.004066] Switched to high resolution mode on CPU 44
[    1.004076] Switched to high resolution mode on CPU 18
[    1.004086] Switched to high resolution mode on CPU 45
[    1.004096] Switched to high resolution mode on CPU 19
[    1.004106] Switched to high resolution mode on CPU 46
[    1.004116] Switched to high resolution mode on CPU 20
[    1.004126] Switched to high resolution mode on CPU 47
[    1.004136] Switched to high resolution mode on CPU 21
[    1.004147] Switched to high resolution mode on CPU 48
[    1.004157] Switched to high resolution mode on CPU 22
[    1.004168] Switched to high resolution mode on CPU 49
[    1.105491] IP route cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    1.107748] TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
[    1.133623] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[    1.138828] TCP: Hash tables configured (established 524288 bind 65536)
[    1.138856] TCP reno registered
[    1.166617] NET: Registered protocol family 1
[    1.167464] Mini RTC Driver
[    1.171082] Total HugeTLB memory allocated, 0
[    1.197344] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.197460] io scheduler noop registered
[    1.197479] io scheduler anticipatory registered (default)
[    1.197501] io scheduler deadline registered
[    1.197830] io scheduler cfq registered
[    1.198015] proc_dir_entry '00.0' already registered
[    1.198036] Call Trace:
[    1.198052]  [00000000004f2534] create_proc_entry+0x7c/0x98
[    1.198092]  [00000000005719e4] pci_proc_attach_device+0xa4/0xd4
[    1.198126]  [00000000007d991c] pci_proc_init+0x64/0x88
[    1.198158]  [00000000007c62a4] kernel_init+0x190/0x330
[    1.198183]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.198210]  [00000000006a0d90] rest_init+0x18/0x5c
[    1.212477] f0279bbc: ttyS0 at I/O 0x0 (irq = 17) is a SUN4V HCONS
[    1.212506] console [ttyHV0] enabled
[    1.695793] proc_dir_entry 'serial' already registered
[    1.695839] Call Trace:
[    1.831891]  [00000000004f2534] create_proc_entry+0x7c/0x98
[    1.833608]  [00000000004f3a58] proc_tty_register_driver+0x40/0x70
[    1.833663]  [0000000000594700] tty_register_driver+0x1fc/0x208
[    1.835371]  [00000000005aade4] uart_register_driver+0x134/0x16c
[    1.841762]  [00000000005ac274] sunserial_register_minors+0x34/0x68
[    1.841818]  [00000000007db2a4] sunsu_init+0xf8/0x150
[    1.867697]  [00000000007c62a4] kernel_init+0x190/0x330
[    1.939147]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.939198]  [00000000006a0d90] rest_init+0x18/0x5c
[    1.953254] f0288ed4: ttyS0 at MMIO 0xfff0ca0000 (irq = 24) is a 16550A
[    1.959818] Uniform Multi-Platform E-IDE driver
[    1.959857] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.964215] Driver 'sd' needs updating - please use bus_type methods
[    1.964681] Fusion MPT base driver 3.04.06
[    1.964714] Copyright (c) 1999-2007 LSI Corporation
[    1.964759] Fusion MPT SPI Host driver 3.04.06
[    1.965026] Fusion MPT FC Host driver 3.04.06
[    2.038302] Fusion MPT SAS Host driver 3.04.06
[    2.038453] mptbase: ioc0: Initiating bringup
[    3.598289] ioc0: LSISAS1068E B1: Capabilities={Initiator}
[    3.608654] mptbase: ioc0: PCI-MSI enabled
[   15.773660] scsi0 : ioc0: LSISAS1068E B1, FwRev=011400dbh, Ports=1, MaxQ=511, IRQ=89
[   15.802521] scsi 0:0:0:0: Direct-Access     SEAGATE  ST973401LSUN72G  0556 PQ: 0 ANSI: 3
[   15.805902] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[   15.807287] sd 0:0:0:0: [sda] Write Protect is off
[   15.807403] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[   15.808800] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   15.809645] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[   15.813249] sd 0:0:0:0: [sda] Write Protect is off
[   15.813386] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[   15.814777] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   15.814994]  sda: sda1 sda2 sda3 sda4
[   15.825854] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.829301] scsi 0:0:1:0: Direct-Access     FUJITSU  MAY2073RCSUN72G  0501 PQ: 0 ANSI: 4
[   15.835766] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[   15.837800] sd 0:0:1:0: [sdb] Write Protect is off
[   15.837838] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[   15.839148] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   15.839984] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[   15.850987] sd 0:0:1:0: [sdb] Write Protect is off
[   15.851024] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[   15.852328] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   15.852546]  sdb: sdb1 sdb2 sdb3
[   15.868166] sd 0:0:1:0: [sdb] Attached SCSI disk
[   15.872190] Fusion MPT misc device (ioctl) driver 3.04.06
[   15.872571] mptctl: Registered with Fusion MPT base driver
[   15.872698] mptctl: /dev/mptctl @ (major,minor=10,220)
[   15.872965] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.873064] ohci_hcd 0000:07:00.0: OHCI Host Controller
[   15.873338] ohci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 1
[   15.873441] ohci_hcd 0000:07:00.0: irq 22, io mem 0xca00300000
[   15.933070] usb usb1: configuration #1 chosen from 1 choice
[   15.933498] hub 1-0:1.0: USB hub found
[   15.933639] hub 1-0:1.0: 3 ports detected
[   16.040653] ohci_hcd 0000:07:00.1: OHCI Host Controller
[   16.041055] ohci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 2
[   16.041227] ohci_hcd 0000:07:00.1: irq 23, io mem 0xca00302000
[   16.102874] usb usb2: configuration #1 chosen from 1 choice
[   16.103286] hub 2-0:1.0: USB hub found
[   16.103422] hub 2-0:1.0: 2 ports detected
[   16.211334] mice: PS/2 mouse device common for all mice
[   16.213075] usbcore: registered new interface driver hiddev
[   16.213457] usbcore: registered new interface driver usbhid
[   16.213587] usbhid: v2.6:USB HID core driver
[   16.215535] TCP cubic registered
[   16.215648] NET: Registered protocol family 17
[   16.244787] kjournald starting.  Commit interval 5 seconds
[   16.244787] EXT3-fs: mounted filesystem with ordered data mode.
[   16.244817] VFS: Mounted root (ext3 filesystem) readonly.
[   21.640822] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
[   21.641049] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   21.641341] PCI: Enabling device: (0000:08:00.0), cmd 147
[   21.655904] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   21.656265] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   21.852257] eth0: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f4
[   21.852479] eth0: Intel(R) PRO/1000 Network Connection
[   21.852676] eth0: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   21.852820] PCI: Enabling device: (0000:07:00.2), cmd 2
[   21.852856] ehci_hcd 0000:07:00.2: EHCI Host Controller
[   21.852998] ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 3
[   21.853234] PCI: Enabling device: (0000:08:00.1), cmd 147
[   21.878911] ehci_hcd 0000:07:00.2: irq 20, io mem 0xca00304000
[   21.898819] ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   21.899394] usb usb3: configuration #1 chosen from 1 choice
[   21.899614] hub 3-0:1.0: USB hub found
[   21.899670] hub 3-0:1.0: 5 ports detected
[   22.098571] eth1: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f5
[   22.098794] eth1: Intel(R) PRO/1000 Network Connection
[   22.098992] eth1: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   22.099132] PCI: Enabling device: (0000:09:00.0), cmd 147
[   22.262472] warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
[   22.368271] eth1: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f6
[   22.368487] eth1: Intel(R) PRO/1000 Network Connection
[   22.368685] eth1: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   22.368840] PCI: Enabling device: (0000:09:00.1), cmd 147
[   22.568009] usb 3-2: new high speed USB device using ehci_hcd and address 2
[   22.591599] eth2: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f7
[   22.591808] eth2: Intel(R) PRO/1000 Network Connection
[   22.592008] eth2: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   22.736807] usb 3-2: configuration #1 chosen from 1 choice
[   22.787592] Initializing USB Mass Storage driver...
[   23.011308] usb 3-4: new high speed USB device using ehci_hcd and address 3
[   23.162939] usb 3-4: configuration #1 chosen from 1 choice
[   23.163641] hub 3-4:1.0: USB hub found
[   23.164294] hub 3-4:1.0: 4 ports detected
[   23.280914] scsi1 : SCSI emulation for USB Mass Storage devices
[   23.281474] usb-storage: device found at 2
[   23.281483] usb-storage: waiting for device to settle before scanning
[   23.283015] usbcore: registered new interface driver usb-storage
[   23.283273] USB Mass Storage support registered.
[   23.726635] loop: module loaded
[   23.975477] Adding 3084464k swap on /dev/sda4.  Priority:-1 extents:1 across:3084464k
[   24.242876] EXT3 FS on sda2, internal journal
[   24.505868] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   24.600589] kjournald starting.  Commit interval 5 seconds
[   24.605044] EXT3 FS on sda1, internal journal
[   24.605063] EXT3-fs: mounted filesystem with ordered data mode.
[   26.705883] NET: Registered protocol family 10
[   26.709144] lo: Disabled Privacy Extensions
[   28.835118] scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-T632A SR02 PQ: 0 ANSI: 0
[   28.835666] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   28.837821] usb-storage: device scan complete
[   28.886072] Driver 'sr' needs updating - please use bus_type methods
[   28.894477] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   28.899626] Uniform CD-ROM driver Revision: 3.20
[   28.899792] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   37.472196] eth0: no IPv6 routers present

----Next_Part(Tue_Apr_29_23_12_41_2008_792)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="failed_boot.log"

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.27.1 2007/09/14 15:17'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 2.6.25 (davem@huronp11) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #108 SMP Tue Apr 29 20:54:20 PDT 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:3e:cb:f4
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 124723 bytes of memory.
[    0.000000] MDESC: Size is 59392 bytes.
[    0.000000] PLATFORM: banner-name [SPARC Enterprise T5220]
[    0.000000] PLATFORM: name [SUNW,SPARC-Enterprise-T5220]
[    0.000000] PLATFORM: hostid [803ecbf4]
[    0.000000] PLATFORM: serial# [00ab4130]
[    0.000000] PLATFORM: stick-frequency [546e74c8]
[    0.000000] PLATFORM: mac-address [144f3ecbf4]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [64]
[    0.000000] Top of RAM: 0x3ffb22000, Total RAM: 0x3f76c6000
[    0.000000] Memory hole size: 132MB
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] alloc_bootmem failed on section 8192.
[    0.000000] sparse_early_usemap_alloc: allocation failed
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal      16896 ->  2096529
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:    16896 ->  2096466
[    0.000000]     0:  2096467 ->  2096477
[    0.000000]     0:  2096522 ->  2096529
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065371
[    0.000000] Kernel command line: root=/dev/sda2 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.010000] clocksource: mult[b4b9] shift[16]
[    0.010000] clockevent: mult[b550b0f2] shift[31]
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console handover: boot [earlyprom0] -> real [tty0]
Program terminated
{0} ok 

----Next_Part(Tue_Apr_29_23_12_41_2008_792)----
