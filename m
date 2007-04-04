Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXDDRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXDDRdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXDDRdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:33:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58549 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXDDRdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:33:18 -0400
Subject: Re: 2.6.21-rc5-mm4 (SLUB powerpc)
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704041003170.24640@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
	 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
	 <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041003170.24640@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 10:33:21 -0700
Message-Id: <1175708002.6185.29.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:13 -0700, Christoph Lameter wrote:
> On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> 
> > Well !! Helps a little, but not enough to boot (hangs little later) :(
> > I will try to get stack trace for that.
> 
> Great! Thanks for all the debugging help.
> 
>  
> > Processor 6 found.
> > Processor 7 found.
> > Brought up 8 CPUs
> > mm/memory.c:111: bad pud c0000000f20c0480.
> 
> Hmmm... Checking for slabs used in powerpc arch code:
> 
> The pgtable cache is configured as
> 
> 
>           pgtable_cache[i] = kmem_cache_create(name,
>                                                      size, size,
>                                                      SLAB_HWCACHE_ALIGN |
>                                                      SLAB_MUST_HWCACHE_ALIGN,
>                                                      zero_ctor,
>                                                      NULL);
> 
> Hmmm.... aligned slabs at size and then we MUST_HWCACHE_ALIGN?? Two 
> competing alignment requirements and a constructor. Constructor requires
> the moving of the free pointer after the slab and thus increases the slab 
> size.
> 
> Sigh. IF SLAB_HWCACHE_ALIGN is set then SLUB believes this to be the 
> ultimate demand that overrides all other alignments and only aligns to the 
> cacheline. Try the following fix:
> 
> 
> 
> SLUB: Treat SLAB_HWCACHE_ALIGN as a mininum and not as *the* alignment
> 
> If the specified alignment is higher than L1_CACHE_BYTES and
> SLAB_HWCACHE_ALIGN is set then use the higher alignment.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.21-rc5-mm4/mm/slub.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 10:09:20.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 10:09:42.000000000 -0700
> @@ -1373,10 +1373,7 @@ static int calculate_order(int size)
>  static unsigned long calculate_alignment(unsigned long flags,
>  		unsigned long align)
>  {
> -	if (flags & SLAB_HWCACHE_ALIGN)
> -		return L1_CACHE_BYTES;
> -
> -	if (flags & SLAB_MUST_HWCACHE_ALIGN)
> +	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
>  		return max_t(unsigned long, align, L1_CACHE_BYTES);
>  
>  	if (align < ARCH_SLAB_MINALIGN)

Next issue ? Sorry.

Thanks,
Badari

Allocated 0x00400000 bytes for executable @ 0x00400000
   Elf32 kernel loaded...

zImage starting: loaded at 0x00400000 (sp: 0x01a3fb10)
Allocating 0x822c40 bytes for kernel ...
OF version = 'IBM,SF225_096'
gunzipping (0x01c00000 <- 0x00408000:0x006a8eac)...done 0x75cdf0 bytes
Finalizing device tree... using OF tree (promptr=00c39a50)
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda2 xmon=on slub_debug
memory layout at init:
  alloc_bottom : 0000000002427000
  alloc_top    : 0000000008000000
  alloc_top_hi : 00000001e8000000
  rmo_top      : 0000000008000000
  ram_top      : 00000001e8000000
Looking for displays
found display   : /pci@800000020000002/pci@2,2/pci@1/display@0,
opening ... done
instantiating rtas at 0x00000000077ca000 ... done
0000000000000000 : boot cpu     0000000000000000
0000000000000002 : starting cpu hw idx 0000000000000002... done
0000000000000004 : starting cpu hw idx 0000000000000004... done
0000000000000006 : starting cpu hw idx 0000000000000006... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000002428000 -> 0x00000000024292fe
Device tree struct  0x000000000242a000 -> 0x000000000243f000
Calling quiesce ...
returning from prom_init
Partition configured for 8 cpus.
Starting Linux PPC64 #8 SMP Wed Apr 4 10:21:43 PDT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1e8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.21-rc5-mm4-ppc64 (root@elm3a121) (gcc version 4.1.0
(SUSE Linux)) #8 SMP Wed Apr 4 10:21:43 PDT 2007
[boot]0012 Setup Arch
No ramdisk, default root is /dev/sda2
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 8192 bytes
Zone PFN ranges:
  DMA             0 ->  1998848
  Normal    1998848 ->  1998848
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->   974848
    1:   974848 ->  1998848
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 1971520
Kernel command line: root=/dev/sda2 xmon=on slub_debug
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 7855400k/7995392k available (6060k kernel code, 139992k
reserved, 1236k data, 819k bss, 272k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=8, Nodes=16
Calibrating delay loop... 475.13 BogoMIPS (lpj=2375680)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
Processor 1 found.
Processor 2 found.
Processor 3 found.
Processor 4 found.
Processor 5 found.
Processor 6 found.
Processor 7 found.
Brought up 8 CPUs
migration_cost=0,1,2744
NET: Registered protocol family 16
IOMMU table initialized, virtual merging enabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
IBM eBus Device Driver
audit: initializing netlink socket (disabled)
audit(1175707672.950:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
rpaphp: Slot [0001:00:02.0](PCI location=U7879.001.DQD02PW-P1-C3)
registered
rpaphp: Slot [0001:00:02.2](PCI location=U7879.001.DQD02PW-P1-C4)
registered
rpaphp: Slot [0001:00:02.4](PCI location=U7879.001.DQD02PW-P1-C5)
registered
rpaphp: Slot [0001:00:02.6](PCI location=U7879.001.DQD02PW-P1-C6)
registered
rpaphp: Slot [0002:00:02.0](PCI location=U7879.001.DQD02PW-P1-C1)
registered
rpaphp: Slot [0002:00:02.6](PCI location=U7879.001.DQD02PW-P1-C2)
registered
matroxfb: Matrox G450 detected
PInS data found at offset 31168
PInS memtype = 5
matroxfb: 640x480x8bpp (virtual: 640x26214)
matroxfb: framebuffer at 0x40170000000, mapped to 0xd000080080004000,
size 33554432
Console: switching to colour frame buffer device 80x30
fb0: MATROX frame buffer device
matroxfb_crtc2: secondary head of fb0 was registered as fb1
Kernel panic - not syncing: Couldn't register hvsi console driver


