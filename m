Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbYELTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbYELTJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbYELTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:06:58 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59422 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165AbYELTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:06:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18472.38209.615770.265421@alkaid.it.uu.se>
Date: Mon, 12 May 2008 21:06:41 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
In-Reply-To: <20080512.005036.19633770.davem@davemloft.net>
References: <18465.63175.561233.228014@alkaid.it.uu.se>
	<20080512.005036.19633770.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Wed, 7 May 2008 20:36:55 +0200
 > 
 > > Now that 2.6.26-rc1 boots on my Ultra5, I noticed that it
 > > reports having only 128MB RAM, while earlier kernels reported
 > > the correct amount: 256MB.
 > > 
 > > A diff of the dmesg output from 2.6.25 and 2.6.26-rc1 shows:
 > 
 > Try as I might I couldn't reproduce this, although I did find another
 > bug along the way.
 > 
 > But that's OK, we'll add some debugging and fetch the necessary
 > information from your machine.
 > 
 > The good news is that the early bootup does see all 256MB of your
 > memory:
 > 
 > Top of RAM: 0x17f46000, Total RAM: 0xff40000
 > Memory hole size: 128MB
 > Entering add_active_range(0, 0, 16384) 0 entries of 256 used
 > Entering add_active_range(0, 32768, 49023) 1 entries of 256 used
 > Entering add_active_range(0, 49024, 49053) 2 entries of 256 used
 > Entering add_active_range(0, 49055, 49059) 3 entries of 256 used
 > 
 > That "0xff40000" value is 267649024 decimal, and the size of the page
 > ranges registered next match up.
 > 
 > And yet we get:
 > 
 > Memory: 127016k available (1920k kernel code, 744k data, 152k init) [fffff80000000000,0000000017f46000]
 > 
 > which is strange.
 > 
 > Between these two events there is only a handfull of bootmem
 > allocations, which together should not total 128MB on your
 > machine. :-)
 > 
 > We have some existing debugging, which I'd like you to enable on the
 > boot command line.  Simply add "numa=debug" and that'll get some more
 > vebose information.
 > 
 > Please also add the debugging patch below.

Right, 2.6.26-rc2 plus your debugging patch and booted with numa=debug
prints the following:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.25.3 2000/06/29 14:12'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 2.6.26-rc2-test (mikpe@sparge) (gcc version 4.2.3) #1 Mon May 12 19:22:10 CEST 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:fd:ec:1f
[    0.000000] Found ramdisk at physical address 0x10800000, size 3683778
[    0.000000] Kernel: Using 1 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
[    0.000000] PROM: Built device tree with 46850 bytes of memory.
[    0.000000] bootmem_init_numa()
[    0.000000] bootmem_init_nonnuma()
[    0.000000] Top of RAM: 0x17f46000, Total RAM: 0xff40000
[    0.000000] Memory hole size: 128MB
[    0.000000] Initializing tables for non-numa.
[    0.000000] Entering add_active_range(0, 0, 16384) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 32768, 49023) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 49024, 49053) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 49055, 49059) 3 entries of 256 used
[    0.000000] bootmem_init_one_node(0)
[    0.000000]   init_bootmem_node(0, 3ffe, 0, bfa3)
[    0.000000]   free_bootmem_with_active_regions(0, bfa3)
[    0.000000]   trim_reserved_in_node(0)
[    0.000000]     reserve_range_in_node(nid[0],start[7ffc000],end[7ffe000]
[    0.000000]       MATCH reserving range [7ffc000:7ffe000]
[    0.000000]     reserve_range_in_node(nid[0],start[7fff040],end[8000000]
[    0.000000]       MATCH reserving range [7fff040:8001040]
[    0.000000]     reserve_range_in_node(nid[0],start[10000000],end[10359f20]
[    0.000000]       MATCH reserving range [10000000:1035a000]
[    0.000000]     reserve_range_in_node(nid[0],start[107e8cc0],end[213835c2]
[    0.000000]       MATCH reserving range [107e8cc0:21384cc0]
[    0.000000]   sparse_memory_present_with_active_regions(0)
[    0.000000] __alloc_bootmem_core: size(8192) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] __alloc_bootmem_core: size(32768) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] __alloc_bootmem_core: size(48) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] __alloc_bootmem_core: size(4194304) align(4194304) goal[0x7ffffffffff] limit[0x0]
[    0.000000] [0000000200000000-fffff80000400000] page_structs=131072 node=0 entry=0/0
[    0.000000] __alloc_bootmem_core: size(4194304) align(4194304) goal[0x7ffffffffff] limit[0x0]
[    0.000000] [0000000200000000-fffff80000800000] page_structs=131072 node=0 entry=1/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal          0 ->    49059
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->    16384
[    0.000000]     0:    32768 ->    49023
[    0.000000]     0:    49024 ->    49053
[    0.000000]     0:    49055 ->    49059
[    0.000000] On node 0 totalpages: 32672
[    0.000000]   Normal zone: 335 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32337 pages, LIFO batch:7
[    0.000000] __alloc_bootmem_core: size(4096) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Booting Linux...
[    0.000000] __alloc_bootmem_core: size(29) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] __alloc_bootmem_core: size(29) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] __alloc_bootmem_core: size(64) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32337
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/sda5 numa=debug
[    0.000000] __alloc_bootmem_core: size(32768) align(64) goal[0x7ffffffffff] limit[0x0]
[    0.000000] PID hash table entries: 1024 (order: 10, 8192 bytes)
[    0.000000] __alloc_bootmem_core: size(8192) align(64) goal[0x7ffffffffff] limit[0x0]
[   25.221347] clocksource: mult[28000] shift[16]
[   25.321537] clockevent: mult[66666666] shift[32]
[   25.422936] __alloc_bootmem_core: size(424) align(64) goal[0x7ffffffffff] limit[0x0]
[   25.422963] __alloc_bootmem_core: size(4000) align(64) goal[0x7ffffffffff] limit[0x0]
[   25.423055] Console: colour dummy device 80x25
[   25.910678] console handover: boot [earlyprom0] -> real [tty0]
[   26.019608] __alloc_bootmem_core: size(262144) align(64) goal[0x7ffffffffff] limit[0x0]
[   26.021182] Dentry cache hash table entries: 32768 (order: 5, 262144 bytes)
[   26.021716] __alloc_bootmem_core: size(131072) align(64) goal[0x7ffffffffff] limit[0x0]
[   26.022488] Inode-cache hash table entries: 16384 (order: 4, 131072 bytes)
[   26.022748] __alloc_bootmem_core: size(16) align(64) goal[0x7ffffffffff] limit[0x0]
[   26.026505] free_all_bootmem_core: pfn[0x0] idx[0xbfa3] gofast(1) node_boot_start[0x0]
[   26.026758] free_all_bootmem_core: Freed pfn range [0x3a --> 0x200]
[   26.031939] free_all_bootmem_core: Freed pfn range [0x600 --> 0x3ffe]
[   26.032216] free_all_bootmem_core: Freed pfn range [0x81ad --> 0x83f4]
[   26.032341] Memory: 127064k available (2032k kernel code, 800k data, 152k init) [fffff80000000000,0000000017f46000]
[   26.032566] SLUB: Genslabs=14, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=16
[   26.179691] Calibrating delay using timer specific routine.. 800.75 BogoMIPS (lpj=4003753)
[   26.180038] Mount-cache hash table entries: 512
[   26.182670] net_namespace: 344 bytes
[   26.183637] NET: Registered protocol family 16
[   26.197822] PCI: Probing for controllers.
[   26.201140] /pci@1f,0: SABRE PCI Bus Module
[   26.201192] /pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
[   26.201270] PCI: Scanning PBM /pci@1f,0
[   26.205349] ebus0: [auxio] [power] [SUNW,pll] [se] [su] [su] [ecpp] [fdthree] [eeprom] [flashprom] [SUNW,CS4231]
[   26.208785] power: Control reg at 1fff1724000
[   26.214386] SCSI subsystem initialized
[   26.214637] libata version 3.00 loaded.
[   26.230239] AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
[   26.230582] /pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Clock regs at 000001fff1000000
[   26.233300] NET: Registered protocol family 2
[   26.550041] IP route cache hash table entries: 2048 (order: 1, 16384 bytes)
[   26.551261] TCP established hash table entries: 8192 (order: 4, 131072 bytes)
[   26.551948] TCP bind hash table entries: 8192 (order: 3, 65536 bytes)
[   26.552300] TCP: Hash tables configured (established 8192 bind 8192)
[   26.552354] TCP reno registered
[   26.580007] NET: Registered protocol family 1
[   26.580627] Unpacking initramfs... done
[   27.455017] Freeing initrd memory: 3597k freed
[   27.455794] Mini RTC Driver
[   27.480248] msgmni has been set to 255 for ipc namespace 00000000006b07d0
[   27.481545] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   27.481631] io scheduler noop registered
[   27.481677] io scheduler anticipatory registered (default)
[   27.481725] io scheduler deadline registered
[   27.482589] io scheduler cfq registered
[   27.483143] atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
[   27.484393] atyfb: 4M SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 100 Mhz MCLK, 100 MHz XCLK
[   27.484829] fbcon: ATY Mach64 (fb0) is primary device
[   27.562718] Console: switching to colour frame buffer device 160x64
[   27.593689] atyfb: fb0: ATY Mach64 frame buffer device on PCI
[   27.610070] /pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
[   27.610530] /pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
[   27.611497] f006159c: ttyS0 at MMIO 0x1fff1400000 (irq = 5) is a SAB82532 V3.2
[   27.612311] f006159c: ttyS1 at MMIO 0x1fff1400040 (irq = 5) is a SAB82532 V3.2
[   27.613450] Driver 'sd' needs updating - please use bus_type methods
[   27.614385] scsi0 : pata_cmd64x
[   27.615098] scsi1 : pata_cmd64x
[   27.615556] ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
[   27.615910] ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
[   27.616320] pata_cmd64x: active 10 recovery 10 setup 3.
[   27.616343] pata_cmd64x: active 10 recovery 10 setup 3.
[   27.790122] ata1.00: ATA-4: ST320420A, 3.21, max UDMA/66
[   27.790346] ata1.00: 39851760 sectors, multi 0: LBA 
[   27.790603] pata_cmd64x: active 3 recovery 1 setup 1.
[   27.790631] pata_cmd64x: active 3 recovery 1 setup 1.
[   27.830069] ata1.00: configured for MWDMA2
[   27.830306] pata_cmd64x: active 10 recovery 10 setup 3.
[   27.830329] pata_cmd64x: active 10 recovery 10 setup 3.
[   28.010111] ata2.00: ATAPI: CRD-8483B, 1.00, max UDMA/33
[   28.010367] pata_cmd64x: active 3 recovery 1 setup 1.
[   28.010392] pata_cmd64x: active 3 recovery 1 setup 1.
[   28.030077] ata2.00: configured for MWDMA2
[   28.030703] scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.21 PQ: 0 ANSI: 5
[   28.031739] sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
[   28.032111] sd 0:0:0:0: [sda] Write Protect is off
[   28.032317] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.032479] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.033106] sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
[   28.033465] sd 0:0:0:0: [sda] Write Protect is off
[   28.033676] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.033833] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.034192]  sda: sda1 sda2 sda3 sda4 sda5
[   28.040646] sd 0:0:0:0: [sda] Attached SCSI disk
[   28.041747] scsi 1:0:0:0: CD-ROM            LG       CD-ROM CRD-8483B 1.00 PQ: 0 ANSI: 5
[   28.044017] mice: PS/2 mouse device common for all mice
[   28.694315] input: Sun Type 5 keyboard as /class/input/input0
[   28.721130] input: Sun Mouse as /class/input/input1
[   28.752541] TCP cubic registered
[   28.752695] NET: Registered protocol family 17
[   29.749831] kjournald starting.  Commit interval 5 seconds
[   29.757309] EXT3-fs: mounted filesystem with ordered data mode.
[   36.303502] PCI: Enabling device: (0000:01:01.1), cmd 2
[   36.303535] sunhme.c:v3.00 June 23, 2006 David S. Miller (davem@davemloft.net)
[   36.305722] eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:fd:ec:1f
[   39.701765] EXT3 FS on sda5, internal journal
[   39.919869] kjournald starting.  Commit interval 5 seconds
[   39.920286] EXT3 FS on sda1, internal journal
[   39.920311] EXT3-fs: mounted filesystem with ordered data mode.
[   39.938232] kjournald starting.  Commit interval 5 seconds
[   39.938753] EXT3 FS on sda2, internal journal
[   39.938776] EXT3-fs: mounted filesystem with ordered data mode.
[   40.628505] Adding 1048808k swap on /dev/sda4.  Priority:-1 extents:1 across:1048808k
[   46.099830] eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.

One thing that bothers me is the "Memory hole size: 128MB" message.
It wasn't present in 2.6.25, and the amount reported is the exact
same amount of RAM I've lost. Or maybe I'm paranoid :-)

/Mikael

