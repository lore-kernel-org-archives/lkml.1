Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXDDP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXDDP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992960AbXDDP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:27:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35924 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992956AbXDDP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:27:14 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
	 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
	 <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 08:27:17 -0700
Message-Id: <1175700437.6185.27.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 08:12 -0700, Badari Pulavarty wrote:
> On Tue, 2007-04-03 at 18:16 -0700, Christoph Lameter wrote:
> > On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> > 
> > > Seems to be an issue with calibrate_delay() spinning in a tight
> > > loop :(
> > > 
> > > BTW, machine boots fine with SLAB code - not sure why ?
> > 
> > Interrupt disabled sigh.
> > 
> > Here is the fix:
> > 
> > 
> > 
> > 
> > SLUB: Fix numa bootstrap
> > 
> > NUMA bootstrap calls new_slab() if more than one node is found on bootup.
> > new_slab() assumes a standard slab context where interrupts must be
> > disabled. It enables interrupts for the call into the page allocator
> > and then disables them again. Interrupts do not have to be disabled
> > during on bootstrap because we still run single threaded there.
> > 
> > I dropped the interrupt preservation code just before SLUB v6 because
> > it looked useless there. SLUB worked on the following NUMA tests
> > that just had a single node. Sigh.
> > 
> > Enable interrupts after calling new_slab.
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > 
> > Index: linux-2.6.21-rc5-mm4/mm/slub.c
> > ===================================================================
> > --- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-03 18:07:41.000000000 -0700
> > +++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-03 18:08:17.000000000 -0700
> > @@ -1436,6 +1436,8 @@ static int init_kmem_cache_nodes(struct 
> >  
> >  			BUG_ON(s->size < sizeof(struct kmem_cache_node));
> >  			page = new_slab(kmalloc_caches, gfpflags, node);
> > +			/* new_slab() disables interupts */
> > +			local_irq_enable();
> >  
> >  			BUG_ON(!page);
> >  			n = page->freelist;
> 
> Well !! Helps a little, but not enough to boot (hangs little later) :(
> I will try to get stack trace for that.

Better debug with slub_debug.
Hope this helps.

Thanks,
Badari

boot: 2621rc5mm4 xmon=on slub_debug
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
command line: root=/dev/sda2 xmon=on slub_debug
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
Memory: 7855384k/7995392k available (6064k kernel code, 140008k
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
mm/memory.c:111: bad pud c000000005100480.
could not vmalloc 20971520 bytes for cache!
*** SLUB: Redzone Inactive check fails in kmalloc-64@0xc000000005081180
Slab 0xc000000000941eb8
    offset=384 flags=0x5000000000c7 inuse=3 freelist=0xc000000005081180
  Bytes b4 0xc000000005081170:  00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 ................
    Object 0xc000000005081180:  00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 ................
    Object 0xc000000005081190:  00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 ................
    Object 0xc0000000050811a0:  00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 ................
    Object 0xc0000000050811b0:  00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 ................
   Redzone 0xc0000000050811c0:  00 00 00 00 00 00 00
00                         ........
FreePointer 0xc0000000050811c8 -> 0x0000000000000000
Call Trace:
[c0000000f20974c0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097560] [c0000000000d8ef0] .object_err+0x1bc/0x1e4
[c0000000f2097600] [c0000000000d91c8] .check_object+0x140/0x220
[c0000000f20976a0] [c0000000000d9f98] .alloc_object_checks+0xc0/0x150
[c0000000f2097730] [c0000000000da318] .kmem_cache_alloc_node+0x2f0/0x34c
[c0000000f20977f0] [c0000000000c69f4] .__get_vm_area_node+0xb0/0x208
[c0000000f20978b0] [c0000000000c75e8] .__vmalloc_node+0x5c/0xb4
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20971f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2097320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20973d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20976c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20977a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2097870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20971f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2097320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20973d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20976c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20977a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2097870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20971f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2097320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20973d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20976c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20977a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2097870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20971f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2097320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20973d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20976c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20977a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2097870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
------------[ cut here ]------------
Badness at mm/vmalloc.c:100
Call Trace:
[c0000000f20971f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2097290] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2097320] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f20973d0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .map_vm_area+0x1b0/0x324
    LR = .__vmalloc_area_node+0x198/0x1ec
[c0000000f20976c0] [ffffffffffffffff] 0xffffffffffffffff (unreliable)
[c0000000f20977a0] [c0000000000c7538] .__vmalloc_area_node+0x198/0x1ec
[c0000000f2097870] [c0000000000c740c] .__vmalloc_area_node+0x6c/0x1ec
[c0000000f2097940] [c000000000059580] .arch_init_sched_domains
+0xb9c/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
Unable to handle kernel paging request for data at address
0x500000000008
Faulting instruction address: 0xc0000000000c7164
cpu 0x4: Vector: 300 (Data Access) at [c0000000f20975a0]
    pc: c0000000000c7164: .remove_vm_area+0x38/0xb8
    lr: c0000000000c7158: .remove_vm_area+0x2c/0xb8
    sp: c0000000f2097820
   msr: 8000000000009032
   dar: 500000000008
 dsisr: 40000000
  current = 0xc0000000050a0000
  paca    = 0xc000000000611000
    pid   = 1, comm = swapper
------------[ cut here ]------------
Badness at arch/powerpc/kernel/entry_64.S:651
Call Trace:
[c0000000f20969f0] [c00000000001098c] .show_stack+0x68/0x1b0
(unreliable)
[c0000000f2096a90] [c0000000001ed454] .report_bug+0x94/0xe8
[c0000000f2096b20] [c00000000042a068] .program_check_exception
+0x178/0x634
[c0000000f2096bd0] [c0000000000046f4] program_check_common+0xf4/0x100
--- Exception: 700 at .enter_rtas+0xa0/0x10c
    LR = .xmon_core+0x584/0x934
[c0000000f2096ec0] [0000000000000000] 0x0 (unreliable)
[c0000000f20970a0] [c000000000051ac0] .xmon_core+0x584/0x934
[c0000000f2097230] [c0000000000520c0] .xmon+0x38/0x4c
[c0000000f2097410] [c000000000026dc8] .die+0x58/0x264
[c0000000f20974b0] [c00000000002fce4] .bad_page_fault+0xb8/0xd4
[c0000000f2097530] [c000000000004b18] handle_page_fault+0x3c/0x58
--- Exception: 300 at .remove_vm_area+0x38/0xb8
    LR = .remove_vm_area+0x2c/0xb8
[c0000000f20978b0] [c0000000000c7234] .__vunmap+0x50/0x100
[c0000000f2097940] [c0000000000597cc] .arch_init_sched_domains
+0xde8/0x10b0
[c0000000f2097d80] [c0000000005c330c] .sched_init_smp+0x60/0x430
[c0000000f2097ea0] [c0000000005a8b18] .kernel_init+0x158/0x3c0
[c0000000f2097f90] [c00000000002899c] .kernel_thread+0x4c/0x68
enter ? for help
[c0000000f20978b0] c0000000000c7234 .__vunmap+0x50/0x100
[c0000000f2097940] c0000000000597cc .arch_init_sched_domains
+0xde8/0x10b0
[c0000000f2097d80] c0000000005c330c .sched_init_smp+0x60/0x430
[c0000000f2097ea0] c0000000005a8b18 .kernel_init+0x158/0x3c0
[c0000000f2097f90] c00000000002899c .kernel_thread+0x4c/0x68
4:mon>


