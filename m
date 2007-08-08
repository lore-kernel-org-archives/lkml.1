Return-Path: <linux-kernel-owner+w=401wt.eu-S937061AbXHHUOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937061AbXHHUOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765702AbXHHUOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:14:44 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:56844 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764922AbXHHUOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:14:42 -0400
Subject: SLUB doesn't work with kdump kernel on Cell
From: Lucio Correia <ljhc@br.ibm.com>
Reply-To: ljhc@br.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, Arnd Bergmann <arndb@arndb.de>
Content-Type: multipart/mixed; boundary="=-9yJDhYVIiM9QUk3NPGFM"
Organization: IBM
Date: Wed, 08 Aug 2007 17:15:51 -0300
Message-Id: <1186604151.3608.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9yJDhYVIiM9QUk3NPGFM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Christoph,

I found a problem with SLUB when trying to boot a kdump kernel on a Cell
QS20 Blade running Fedora 7, kernel 2.6.22.5. If I use SLAB for the
kdump kernel, everything works ok. The fact is that SLUB doesn't find a
page frame for allocation in the current node, due to the flag
GFP_THISNODE on a call to new_slab, and stops at a BUG_ON on line 1802
of slub.c. 

I made a patch (attached) that removes this flag. The kernel passed the
point, booting completely. With 128MB of reserved memory (recommended by
kdump documentation on PPC64), the kdump kernel complains with "Out of
memory" messages during the boot, and also after the boot. With 256MB it
boot fines. 

Also attached is the boot output for 128MB of reserved memory.

I understand that this flag should not be removed, and that there is a
better solution, but it demonstrates the problem. Could you give me some
direction on the better way to solve this problem?


Thanks,

-- 
Lucio Correia
Software Engineer
IBM LTC Brazil

--=-9yJDhYVIiM9QUk3NPGFM
Content-Disposition: attachment; filename=slub-kdump-fix.diff
Content-Type: text/x-patch; name=slub-kdump-fix.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -Nurp linux-2.6.22.orig/mm/slub.c linux-2.6.22/mm/slub.c
--- linux-2.6.22.orig/mm/slub.c	2007-07-08 20:32:17.000000000 -0300
+++ linux-2.6.22/mm/slub.c	2007-08-07 11:55:17.000000000 -0300
@@ -1797,7 +1797,11 @@ static struct kmem_cache_node * __init e
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
+#ifdef CONFIG_CRASH_DUMP
+	page = new_slab(kmalloc_caches, gfpflags, node);
+#else
 	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
+#endif
 
 	BUG_ON(!page);
 	n = page->freelist;

--=-9yJDhYVIiM9QUk3NPGFM
Content-Disposition: attachment; filename=KdumpSlubTest20070808-128.txt
Content-Type: text/plain; name=KdumpSlubTest20070808-128.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

SysRq : Trigger a crashdump
Sending IPI to other cpus...
Starting Linux PPC64 #1 SMP Tue Aug 7 19:33:46 BRT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0xa010000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000009800000
htab_hash_mask                = 0x7fff
physical_start                = 0x2000000
-----------------------------------------------------
Linux version 2.6.22-5.20070723bsckdump (lucio@luciojhc) (gcc version 4.1.1) #1 SMP Tue Aug 7 19:33:46 BRT 2007
*** 0000 : CF000012

*** 0000 : Setup Arch
[boot]0012 Setup Arch
no ISA IO ranges or unexpected isa range,mapping 64k
mmio NVRAM, 1024k at 0x2401fb00000 mapped to d000080080060000
Zone PFN ranges:
  DMA             0 ->    12288
  Normal      12288 ->    12288
early_node_map[2] active PFN ranges
    0:        0 ->     2560
    1:    12287 ->    12288
*** 0000 : CF000015

*** 0000 : Setup Done
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 2559
Kernel command line:  elfcorehdr=42048K savemaxmem=1024M root=LABEL=/1 
IIC for CPU 0 target id 0xe : /interrupt-controller@20000508400
IIC for CPU 1 target id 0xf : /interrupt-controller@20000508400
IIC for CPU 2 target id 0x1e : /interrupt-controller@30000508400
IIC for CPU 3 target id 0x1f : /interrupt-controller@30000508400
spider_pic: node 0, addr: 0x24000008000 /interrupt-controller@24000008000
spider_pic: node 1, addr: 0x34000008000 /interrupt-controller@34000008000
PID hash table entries: 1024 (order: 10, 8192 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Using Cell machine description
Found initrd at 0xc000000002930000:0xc000000002cc0000
Starting Linux PPC64 #1 SMP Tue Aug 7 19:33:46 BRT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0xa010000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000009800000
htab_hash_mask                = 0x7fff
physical_start                = 0x2000000
-----------------------------------------------------
Linux version 2.6.22-5.20070723bsckdump (lucio@luciojhc) (gcc version 4.1.1) #1 SMP Tue Aug 7 19:33:46 BRT 2007
*** 0000 : CF000012

*** 0000 : Setup Arch
[boot]0012 Setup Arch
no ISA IO ranges or unexpected isa range,mapping 64k
mmio NVRAM, 1024k at 0x2401fb00000 mapped to d000080080060000
Zone PFN ranges:
  DMA             0 ->    12288
  Normal      12288 ->    12288
early_node_map[2] active PFN ranges
    0:        0 ->     2560
    1:    12287 ->    12288
*** 0000 : CF000015

*** 0000 : Setup Done
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 2559
Kernel command line:  elfcorehdr=42048K savemaxmem=1024M root=LABEL=/1 
IIC for CPU 0 target id 0xe : /interrupt-controller@20000508400
IIC for CPU 1 target id 0xf : /interrupt-controller@20000508400
IIC for CPU 2 target id 0x1e : /interrupt-controller@30000508400
IIC for CPU 3 target id 0x1f : /interrupt-controller@30000508400
spider_pic: node 0, addr: 0x24000008000 /interrupt-controller@24000008000
spider_pic: node 1, addr: 0x34000008000 /interrupt-controller@34000008000
PID hash table entries: 1024 (order: 10, 8192 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 2, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 1, 131072 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 112512k/163904k available (6400k kernel code, 51392k reserved, 1408k data, 870k bss, 448k init)
SLUB: Genslabs=25, HWalign=128, Order=0-2, MinObjects=8, CPUs=4, Nodes=16
Security Framework v1.0.0 initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 4096
Processor 1 found.
Processor 2 found.
Processor 3 found.
Brought up 4 CPUs
migration_cost=410,3247
NET: Registered protocol family 16
*** 0000 : Linux ppc64

*** 0000 : #1 SMP Tue Aug 7 19:33:46 BRT 2007
CPU Hotplug not supported by firmware - disabling.
iommu: disabled, direct DMA offset is 0x80000000
PCI: Spider MMIO workaround for /pci@24004000000
perfmon: version 2.5, compiled: Aug  7 2007, 19:26:58
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
NET: Registered protocol family 2
IP route cache hash table entries: 8192 (order: 0, 65536 bytes)
TCP established hash table entries: 8192 (order: 1, 196608 bytes)
TCP bind hash table entries: 8192 (order: 1, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3648k freed
IBM eBus Device Driver
scan-log-dump not implemented on this system
of_create_spu: Legacy device tree found, trying to map old style
of_create_spu: Legacy device tree found, trying old style irq
audit: initializing netlink socket (disabled)
audit(1186580375.375:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
ksign: Installing public key data
Loading keyring
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
perfmon: added sampling format default
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Generic RTC Driver v1.07
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
TX39/49 Serial driver version 1.09
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
NO SYSTEMSIM BOGUS DISK DETECTED
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 448k freed
Red Hat nash version 6.0.9 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Loading uhci-hcd.ko module
USB Universal Host Controller Interface driver v3.0
Loading ohci-hcd.ko module
Loading ehci-hcd.ko module
Loading jbd.ko module
Loading ext3.ko module
Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Loading libata.ko module
Loading ata_generic.ko module
Loading pata_sil680.ko module
sil680: BA5_EN = 1 clock = 10
sil680: BA5_EN = 1 clock = 10
sil680: 133MHz clock.
scsi0 : pata_sil680
scsi1 : pata_sil680
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f2 bmdma 0x00000000000106f0 irq 51
ata2: PATA max UDMA/133 cmd 0x00000000000101f8 ctl 0x0000000000010372 bmdma 0x00000000000106f8 irq 51
ata1.00: ATA-7: FUJITSU MHV2040AS, 00000096, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA 
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2040A 0000 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
Waiting for driver initialization.
Trying to resume from LABEL=SWAP-sda5
No suspend signature on swap, not resuming.
Creating root device.
Mounting root filesystem.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Setting up other filesystems.
Setting up new root fs
no fstab.sys, mounting internal defaults
running init.new root and 
unmounting old /dev
unmounting old /proc
unmounting old /sys
SELinux:  Disabled at runtime.
audit(1186580381.473:2): selinux=0 auid=4294967295
INIT: version 2.86 bootin
                Welcome to Fedora 
                Press 'I' to enter interactive startup.
Setting clock  (utc): Wed Aug  8 09:39:44 EDT 2007 [  OK  ]
Starting udev: [  OK  ]
Setting hostname localhost.localdomain:  [  OK  ]
No devices found
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
/1: clean, 205696/4068000 files, 2892028/4066445 blocks
[/sbin/fsck.ext2 (1) -- /boot] fsck.ext2 -a /dev/sda2 
/boot1 was not cleanly unmounted, check forced.
/boot1: 40/66264 files (30.0% non-contiguous), 100045/265024 blocks
[PASSED]
Checking local filesystem quotas:  [  OK  ]
Remounting root filesystem in read-write mode:  [  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  swapon: /dev/sda5: Invalid argument
                                                               [FAILED]
INIT: Entering runlevel: Entering non-interactive startup
Applying iptables firewall rules: [  OK  ]
Loading additional iptables modules: ip_conntrack_netbios_ns [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth1:  
Determining IP information for eth1... done.
[  OK  ]
Starting system logger: [  OK  ]
Starting kernel logger: [  OK  ]
Starting irqbalance: [  OK  ]
Starting rpcbind: [  OK  ]
Starting NFS statd: [  OK  ]
Starting RPC idmapd: [  OK  ]
Starting system message bus: [  OK  ]
Mounting other filesystems:  [  OK  ]
Starting PC/SC smart card daemon (pcscd): [  OK  ]
Starting hidd: [  OK  ]
Starting sshd: [  OK  ]
Starting adacsd: [  OK  ]
Starting ConsoleKit: [  OK  ]
Starting crond: [  OK  ]
Starting anacron: [  OK  ]
Starting dhcdbd:[  OK  ]
Starting yum-updatesd: [  OK  ]
Starting Avahi daemon... [  OK  ]
Starting HAL daemon: dhcdbd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
Call Trace:
[c000000002f57610] [c000000002010404] .show_stack+0x68/0x1b0 (unreliable)
[c000000002f576b0] [c0000000020d8f30] .out_of_memory+0x90/0x3d0
[c000000002f57770] [c0000000020dc8ac] .__alloc_pages+0x29c/0x364
[c000000002f57850] [c0000000020fcf88] .alloc_pages_current+0xd4/0xf8
[c000000002f578e0] [c0000000020d50dc] .__page_cache_alloc+0x8c/0xa8
[c000000002f57960] [c0000000020deedc] .__do_page_cache_readahead+0xd0/0x2cc
[c000000002f57ab0] [c0000000020d7c98] .filemap_nopage+0x168/0x3a4
[c000000002f57b80] [c0000000020e9d80] .__handle_mm_fault+0x1b8/0x10c8
[c000000002f57c70] [c00000000244f7fc] .do_page_fault+0x43c/0x62c
[c000000002f57e30] [c000000002005988] handle_page_fault+0x20/0x58
Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Active:523 inactive:53 dirty:0 writeback:0 unstable:0
 free:36 slab:973 mapped:7 pagetables:88 bounce:0
Node 0 DMA free:2304kB min:1536kB low:1920kB high:2304kB active:33472kB inactive:3392kB present:163712kB pages_scanned:3471 s
lowmem_reserve[]: 0 0
Node 1 DMA free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:64kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 0
Node 0 DMA: 2*64kB 6*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1408kB
Node 1 DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
2561 pages of RAM
737 reserved pages
147 pages shared
0 pages swap cached
Out of memory: kill process 1813 (hald) score 211 or a child
Killed process 1814 (hald-runner)
syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
Call Trace:
hald invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
Call Trace:
[c00000000713f6c0] [c000000002010404] .show_stack+0x68/0x1b0 (unreliable)
[c00000000713f760] [c0000000020d8f30] .out_of_memory+0x90/0x3d0
[c00000000713f820] [c0000000020dc8ac] .__alloc_pages+0x29c/0x364
[c00000000713f900] [c0000000020fcf88] .alloc_pages_current+0xd4/0xf8
[c00000000713f990] [c0000000020d50dc] .__page_cache_alloc+0x8c/0xa8
[c00000000713fa10] [c0000000020d54b4] .page_cache_read+0x3c/0xf4
[c00000000713fab0] [c0000000020d7d1c] .filemap_nopage+0x1ec/0x3a4
[c00000000713fb80] [c0000000020e9d80] .__handle_mm_fault+0x1b8/0x10c8
[c00000000713fc70] [c00000000244f7fc] .do_page_fault+0x43c/0x62c
[c00000000713fe30] [c000000002005988] handle_page_fault+0x20/0x58
Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Active:587 inactive:1 dirty:0 writeback:0 unstable:0
 free:13 slab:975 mapped:20 pagetables:85 bounce:0
Node 0 DMA free:832kB min:1536kB low:1920kB high:2304kB active:37568kB inactive:64kB present:163712kB pages_scanned:3544 alls
lowmem_reserve[]: 0 0<4>dhcdbd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
Call Trace:

[c000000002f57610] [c000000002010404] Node 1 DMA free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:64kB pages
.show_stack+0x68/0x1b0 (unreliable)
[c000000002f576b0] [c0000000020d8f30] lowmem_reserve[]: 0 0
.out_of_memory+0x90/0x3d0
[c000000002f57770] [c0000000020dc8ac] Node 0 .__alloc_pages+0x29c/0x364
[c000000002f57850] [c0000000020fcf88] DMA: .alloc_pages_current+0xd4/0xf8
[c000000002f578e0] [c0000000020d50dc] 21*64kB 2*128kB .__page_cache_alloc+0x8c/0xa8
[c000000002f57960] [c0000000020deedc] 2*256kB 0*512kB .__do_page_cache_readahead+0xd0/0x2cc
0*1024kB [c000000002f57ab0] [c0000000020d7c98] .filemap_nopage+0x168/0x3a4
[c000000002f57b80] [c0000000020e9d80] 0*2048kB .__handle_mm_fault+0x1b8/0x10c8
[c000000002f57c70] [c00000000244f7fc] 0*4096kB .do_page_fault+0x43c/0x62c
[c000000002f57e30] [c000000002005988] 0*8192kB handle_page_fault+0x20/0x58
Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
0*16384kB = 2112kB
Node 1 Active:587 inactive:1 dirty:0 writeback:0 unstable:0
 free:13 slab:975 mapped:20 pagetables:85 bounce:0
Node 0 DMA free:832kB min:1536kB low:1920kB high:2304kB active:37568kB inactive:64kB present:163712kB pages_scanned:3544 alls
lowmem_reserve[]: 0 0
Node 1 DMA free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:64kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 0
Node 0 DMA: 21*64kB 2*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2112kB
Node 1 DMA: DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
2561 pages of RAM
737 reserved pages
93 pages shared
0 pages swap cached
Out of memory: kill process 1813 (hald) score 198 or a child
Killed process 1813 (hald)
2561 pages of RAM
737 reserved pages
93 pages shared
0 pages swap cached
[c000000008b6eb80] [c000000002010404] .show_stack+0x68/0x1b0 (unreliable)
[c000000008b6ec20] [c0000000020d8f30] .out_of_memory+0x90/0x3d0
[c000000008b6ece0] [c0000000020dc8ac] .__alloc_pages+0x29c/0x364
[c000000008b6edc0] [c0000000020fcf88] .alloc_pages_current+0xd4/0xf8
[c000000008b6ee50] [c0000000020d50dc] .__page_cache_alloc+0x8c/0xa8
[c000000008b6eed0] [c0000000020deedc] .__do_page_cache_readahead+0xd0/0x2cc
[c000000008b6f020] [c0000000020d7c98] .filemap_nopage+0x168/0x3a4
[c000000008b6f0f0] [c0000000020e9d80] .__handle_mm_fault+0x1b8/0x10c8
[c000000008b6f1e0] [c00000000244f7fc] .do_page_fault+0x43c/0x62c
[c000000008b6f3a0] [c000000002005988] handle_page_fault+0x20/0x58
--- Exception: 301 at .generic_file_buffered_write+0x1a0/0x8a4
    LR = .generic_file_buffered_write+0x194/0x8a4
[c000000008b6f840] [c0000000020d7460] .__generic_file_aio_write_nolock+0x374/0x3e8
[c000000008b6f940] [c0000000020d7554] .generic_file_aio_write+0x80/0x114
[c000000008b6fa00] [d000000000153060] .ext3_file_write+0x2c/0xd4 [ext3]
[c000000008b6fa90] [c00000000210eb24] .do_sync_readv_writev+0xc8/0x130
[c000000008b6fc30] [c00000000214f4e0] .compat_do_readv_writev+0x23c/0x3a0
[c000000008b6fd90] [c00000000214f6cc] .compat_sys_writev+0x88/0xbc
[c000000008b6fe30] [c0000000020086c8] syscall_exit+0x0/0x40
Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Active:504 inactive:52 dirty:0 writeback:2 unstable:0
 free:63 slab:977 mapped:31 pagetables:82 bounce:0
Node 0 DMA free:4032kB min:1536kB low:1920kB high:2304kB active:32256kB inactive:3328kB present:163712kB pages_scanned:765 ao
lowmem_reserve[]: 0 0
Node 1 DMA free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:64kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 0
Node 0 DMA: 35*64kB 10*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4032kB
Node 1 DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
2561 pages of RAM
737 reserved pages
94 pages shared
0 pages swap cached
Out of memory: kill process 1801 (avahi-daemon) score 136 or a child
Killed process 1802 (avahi-daemon)
[FAILED]
Starting smartd: [  OK  ]

Fedora release 7 (Moonshine)
Kernel 2.6.22-5.20070723bsckdump on an ppc64

localhost.localdomain login: 


--=-9yJDhYVIiM9QUk3NPGFM--

