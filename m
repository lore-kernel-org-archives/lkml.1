Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYEMTbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYEMTbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYEMTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:31:31 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43039 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYEMTb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:31:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18473.60551.911448.98269@alkaid.it.uu.se>
Date: Tue, 13 May 2008 21:31:19 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
In-Reply-To: <20080512.153948.193688062.davem@davemloft.net>
References: <18472.38209.615770.265421@alkaid.it.uu.se>
	<20080512.153143.48741227.davem@davemloft.net>
	<20080512.153628.193699676.davem@davemloft.net>
	<20080512.153948.193688062.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: David Miller <davem@davemloft.net>
 > Date: Mon, 12 May 2008 15:36:28 -0700 (PDT)
 > 
 > > Nevermind I see why the messages don't show up.  Hold on for a second
 > > and I'll send an updated debugging patch.
 > 
 > Try this patch instead, thanks!
 > 
 > diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
 > index a9828d7..a628a99 100644
 > --- a/arch/sparc64/mm/init.c
 > +++ b/arch/sparc64/mm/init.c
 > @@ -1353,6 +1353,8 @@ static void __init bootmem_init_one_node(int nid)
 >  
 >  	numadbg("bootmem_init_one_node(%d)\n", nid);
 >  
 > +	lmb_dump_all();
 > +
 >  	p = NODE_DATA(nid);
 >  
 >  	if (p->node_spanned_pages) {
 > diff --git a/lib/lmb.c b/lib/lmb.c
 > index 83287d3..f294bbc 100644
 > --- a/lib/lmb.c
 > +++ b/lib/lmb.c
 > @@ -10,6 +10,8 @@
 >   *      2 of the License, or (at your option) any later version.
 >   */
 >  
 > +#define DEBUG
 > +
 >  #include <linux/kernel.h>
 >  #include <linux/init.h>
 >  #include <linux/bitops.h>
 > @@ -29,7 +31,7 @@ void lmb_dump_all(void)
 >  	pr_debug("    memory.size		  = 0x%llx\n",
 >  	    (unsigned long long)lmb.memory.size);
 >  	for (i=0; i < lmb.memory.cnt ;i++) {
 > -		pr_debug("    memory.region[0x%x].base       = 0x%llx\n",
 > +		pr_debug("    memory.region[0x%lx].base       = 0x%llx\n",
 >  		    i, (unsigned long long)lmb.memory.region[i].base);
 >  		pr_debug("		      .size     = 0x%llx\n",
 >  		    (unsigned long long)lmb.memory.region[i].size);
 > @@ -38,7 +40,7 @@ void lmb_dump_all(void)
 >  	pr_debug("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
 >  	pr_debug("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 >  	for (i=0; i < lmb.reserved.cnt ;i++) {
 > -		pr_debug("    reserved.region[0x%x].base       = 0x%llx\n",
 > +		pr_debug("    reserved.region[0x%lx].base       = 0x%llx\n",
 >  		    i, (unsigned long long)lmb.reserved.region[i].base);
 >  		pr_debug("		      .size     = 0x%llx\n",
 >  		    (unsigned long long)lmb.reserved.region[i].size);
 > 

Ok, reverting previous patch and applying this done results in:

PROMLIB: Sun IEEE Boot Prom 'OBP 3.25.3 2000/06/29 14:12'
PROMLIB: Root node compatible: 
Linux version 2.6.26-rc2-test (mikpe@sparge) (gcc version 4.2.3) #2 Tue May 13 18:26:56 CEST 2008
console [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:fd:ec:1f
Found ramdisk at physical address 0x10800000, size 3683665
lmb_dump_all:
    memory.cnt		  = 0x4
    memory.size		  = 0xff40000
    memory.region[0x0].base       = 0x0
		      .size     = 0x8000000
    memory.region[0x1].base       = 0x10000000
		      .size     = 0x7efe000
    memory.region[0x2].base       = 0x17f00000
		      .size     = 0x3a000
    memory.region[0x3].base       = 0x17f3e000
		      .size     = 0x8000
    reserved.cnt	  = 0x2
    reserved.size	  = 0x0
    reserved.region[0x0].base       = 0x10000000
		      .size     = 0x35bf60
    reserved.region[0x1].base       = 0x10800000
		      .size     = 0x10b83551
Kernel: Using 1 locked TLB entries for main kernel image.
Remapping the kernel... done.
OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
PROM: Built device tree with 46641 bytes of memory.
bootmem_init_numa()
bootmem_init_nonnuma()
Top of RAM: 0x17f46000, Total RAM: 0xff40000
Memory hole size: 128MB
Initializing tables for non-numa.
Entering add_active_range(0, 0, 16384) 0 entries of 256 used
Entering add_active_range(0, 32768, 49023) 1 entries of 256 used
Entering add_active_range(0, 49024, 49053) 2 entries of 256 used
Entering add_active_range(0, 49055, 49059) 3 entries of 256 used
bootmem_init_one_node(0)
lmb_dump_all:
    memory.cnt		  = 0x4
    memory.size		  = 0xff40000
    memory.region[0x0].base       = 0x0
		      .size     = 0x8000000
    memory.region[0x1].base       = 0x10000000
		      .size     = 0x7efe000
    memory.region[0x2].base       = 0x17f00000
		      .size     = 0x3a000
    memory.region[0x3].base       = 0x17f3e000
		      .size     = 0x8000
    reserved.cnt	  = 0x4
    reserved.size	  = 0x0
    reserved.region[0x0].base       = 0x7ffc000
		      .size     = 0x2000
    reserved.region[0x1].base       = 0x7fff040
		      .size     = 0xfc0
    reserved.region[0x2].base       = 0x10000000
		      .size     = 0x35bf60
    reserved.region[0x3].base       = 0x107e8e00
		      .size     = 0x10b9a751
  init_bootmem_node(0, 3ffe, 0, bfa3)
  free_bootmem_with_active_regions(0, bfa3)
  trim_reserved_in_node(0)
    reserve_range_in_node(nid[0],start[7ffc000],end[7ffe000]
      MATCH reserving range [7ffc000:7ffe000]
    reserve_range_in_node(nid[0],start[7fff040],end[8000000]
      MATCH reserving range [7fff040:8001040]
    reserve_range_in_node(nid[0],start[10000000],end[1035bf60]
      MATCH reserving range [10000000:1035c000]
    reserve_range_in_node(nid[0],start[107e8e00],end[21383551]
      MATCH reserving range [107e8e00:21384e00]
  sparse_memory_present_with_active_regions(0)
[0000000200000000-fffff80000400000] page_structs=131072 node=0 entry=0/0
[0000000200000000-fffff80000800000] page_structs=131072 node=0 entry=1/0
Zone PFN ranges:
  Normal          0 ->    49059
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->    16384
    0:    32768 ->    49023
    0:    49024 ->    49053
    0:    49055 ->    49059
On node 0 totalpages: 32672
  Normal zone: 335 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 32337 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
Booting Linux...
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32337
Policy zone: Normal
Kernel command line: ro root=/dev/sda5 numa=debug
PID hash table entries: 1024 (order: 10, 8192 bytes)
clocksource: mult[28000] shift[16]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
console handover: boot [earlyprom0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 5, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 4, 131072 bytes)
Memory: 127056k available (2040k kernel code, 808k data, 152k init) [fffff80000000000,0000000017f46000]
SLUB: Genslabs=14, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=16
Calibrating delay using timer specific routine.. 800.75 BogoMIPS (lpj=4003776)
Mount-cache hash table entries: 512
net_namespace: 344 bytes
NET: Registered protocol family 16
PCI: Probing for controllers.
/pci@1f,0: SABRE PCI Bus Module
/pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
PCI: Scanning PBM /pci@1f,0
ebus0: [auxio] [power] [SUNW,pll] [se] [su] [su] [ecpp] [fdthree] [eeprom] [flashprom] [SUNW,CS4231]
power: Control reg at 1fff1724000
SCSI subsystem initialized
libata version 3.00 loaded.
AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
/pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Clock regs at 000001fff1000000
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 16384 bytes)
TCP established hash table entries: 8192 (order: 4, 131072 bytes)
TCP bind hash table entries: 8192 (order: 3, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 3597k freed
Mini RTC Driver
msgmni has been set to 255 for ipc namespace 00000000006b27c8
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
atyfb: 4M SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 100 Mhz MCLK, 100 MHz XCLK
fbcon: ATY Mach64 (fb0) is primary device
Console: switching to colour frame buffer device 144x56
atyfb: fb0: ATY Mach64 frame buffer device on PCI
/pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
/pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
f006159c: ttyS0 at MMIO 0x1fff1400000 (irq = 5) is a SAB82532 V3.2
f006159c: ttyS1 at MMIO 0x1fff1400040 (irq = 5) is a SAB82532 V3.2
Driver 'sd' needs updating - please use bus_type methods
scsi0 : pata_cmd64x
scsi1 : pata_cmd64x
ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
ata1.00: ATA-4: ST320420A, 3.21, max UDMA/66
ata1.00: 39851760 sectors, multi 0: LBA 
pata_cmd64x: active 3 recovery 1 setup 1.
pata_cmd64x: active 3 recovery 1 setup 1.
ata1.00: configured for MWDMA2
pata_cmd64x: active 10 recovery 10 setup 3.
pata_cmd64x: active 10 recovery 10 setup 3.
ata2.00: ATAPI: CRD-8483B, 1.00, max UDMA/33
pata_cmd64x: active 3 recovery 1 setup 1.
pata_cmd64x: active 3 recovery 1 setup 1.
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.21 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            LG       CD-ROM CRD-8483B 1.00 PQ: 0 ANSI: 5
mice: PS/2 mouse device common for all mice
input: Sun Type 5 keyboard as /class/input/input0
input: Sun Mouse as /class/input/input1
TCP cubic registered
NET: Registered protocol family 17
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
PCI: Enabling device: (0000:01:01.1), cmd 2
sunhme.c:v3.00 June 23, 2006 David S. Miller (davem@davemloft.net)
eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:fd:ec:1f
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1048808k swap on /dev/sda4.  Priority:-1 extents:1 across:1048808k
eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.

I also tried your two lmb patches from today (had to revert this patch first),
but they made no significant difference.

/Mikael
