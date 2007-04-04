Return-Path: <linux-kernel-owner+w=401wt.eu-S2992920AbXDDPMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992920AbXDDPMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992921AbXDDPMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:12:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42228 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992920AbXDDPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:12:38 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
	 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 08:12:39 -0700
Message-Id: <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 18:16 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > Seems to be an issue with calibrate_delay() spinning in a tight
> > loop :(
> > 
> > BTW, machine boots fine with SLAB code - not sure why ?
> 
> Interrupt disabled sigh.
> 
> Here is the fix:
> 
> 
> 
> 
> SLUB: Fix numa bootstrap
> 
> NUMA bootstrap calls new_slab() if more than one node is found on bootup.
> new_slab() assumes a standard slab context where interrupts must be
> disabled. It enables interrupts for the call into the page allocator
> and then disables them again. Interrupts do not have to be disabled
> during on bootstrap because we still run single threaded there.
> 
> I dropped the interrupt preservation code just before SLUB v6 because
> it looked useless there. SLUB worked on the following NUMA tests
> that just had a single node. Sigh.
> 
> Enable interrupts after calling new_slab.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.21-rc5-mm4/mm/slub.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-03 18:07:41.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-03 18:08:17.000000000 -0700
> @@ -1436,6 +1436,8 @@ static int init_kmem_cache_nodes(struct 
>  
>  			BUG_ON(s->size < sizeof(struct kmem_cache_node));
>  			page = new_slab(kmalloc_caches, gfpflags, node);
> +			/* new_slab() disables interupts */
> +			local_irq_enable();
>  
>  			BUG_ON(!page);
>  			n = page->freelist;

Well !! Helps a little, but not enough to boot (hangs little later) :(
I will try to get stack trace for that.

Thanks,
Badari

boot: 2621rc5mm4
Please wait, loading kernel...
Allocated 0x00400000 bytes for executable @ 0x00400000
   Elf32 kernel loaded...

zImage starting: loaded at 0x00400000 (sp: 0x01a3fb10)
Allocating 0x826c40 bytes for kernel ...
OF version = 'IBM,SF225_096'
gunzipping (0x01c00000 <- 0x00408000:0x006a8e52)...done 0x760df0 bytes
Finalizing device tree... using OF tree (promptr=00c39a50)
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda2
memory layout at init:
  alloc_bottom : 000000000242b000
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
Device tree strings 0x000000000242c000 -> 0x000000000242d2fe
Device tree struct  0x000000000242e000 -> 0x0000000002443000
Calling quiesce ...
returning from prom_init
Partition configured for 8 cpus.
Starting Linux PPC64 #7 SMP Wed Apr 4 07:52:49 PDT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1e8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.21-rc5-mm4-ppc64 (root@elm3a121) (gcc version 4.1.0
(SUSE Linux)) #7 SMP Wed Apr 4 07:52:49 PDT 2007
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
Kernel command line: root=/dev/sda2
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 7855384k/7995392k available (6064k kernel code, 140008k
reserved, 1236k data, 819k bss, 272k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=8, Nodes=16
Calibrating delay loop...475.13 BogoMIPS (lpj=2375680)
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
mm/memory.c:111: bad pud c0000000f20c0480.
could not vmalloc 20971520 bytes for cache!
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20731f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2073290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2073320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20733d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20736c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20737a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2073870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2073940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2073d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2073ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2073f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20731f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2073290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2073320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20733d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20736c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20737a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2073870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2073940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2073d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2073ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2073f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20731f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2073290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2073320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20733d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20736c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20737a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2073870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2073940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2073d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2073ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2073f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20731f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2073290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2073320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20733d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20736c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20737a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2073870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2073940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2073d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2073ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2073f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20731f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2073290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2073320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20733d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20736c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20737a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2073870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2073940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2073d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2073ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2073f90] [c00000000002899c] .kernel_thread+0x4c/0x68
could not vmalloc 20971520 bytes for cache!
migration_cost=0,1000,1000
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
audit(1175698620.610:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
mm/memory.c:111: bad pud c0000000f20c1200.
mm/memory.c:111: bad pud c0000000f20c1680.
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




