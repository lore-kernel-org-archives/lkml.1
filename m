Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYEOSna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYEOSna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYEOSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:43:19 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47509 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYEOSnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:43:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18476.33854.71781.133881@harpo.it.uu.se>
Date: Thu, 15 May 2008 20:43:10 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
In-Reply-To: <20080514.231111.107604885.davem@davemloft.net>
References: <20080512.153628.193699676.davem@davemloft.net>
	<20080512.153948.193688062.davem@davemloft.net>
	<18473.60551.911448.98269@alkaid.it.uu.se>
	<20080514.231111.107604885.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Tue, 13 May 2008 21:31:19 +0200
 > 
 > Ok, Mikael, I think I figured out this bug:
 > 
 > > Found ramdisk at physical address 0x10800000, size 3683665
 > > lmb_dump_all:
 > >     memory.cnt		  = 0x4
 > >     memory.size		  = 0xff40000
 > >     memory.region[0x0].base       = 0x0
 > > 		      .size     = 0x8000000
 > >     memory.region[0x1].base       = 0x10000000
 > > 		      .size     = 0x7efe000
 > >     memory.region[0x2].base       = 0x17f00000
 > > 		      .size     = 0x3a000
 > >     memory.region[0x3].base       = 0x17f3e000
 > > 		      .size     = 0x8000
 > >     reserved.cnt	  = 0x2
 > >     reserved.size	  = 0x0
 > >     reserved.region[0x0].base       = 0x10000000
 > > 		      .size     = 0x35bf60
 > >     reserved.region[0x1].base       = 0x10800000
 > > 		      .size     = 0x10b83551
 > 
 > >From the very beginning your higher RAM is gone.
 > It's correct that some memory should be reserved,
 > for the ramdisk, but not 128MB :-)
 > 
 > The ramdisk is just under 4MB in size, so something is fishy here.
 > 
 > And indeed, I'm reserving the wrong length.  Please try this
 > patch:
 > 
 > sparc64: Fix lmb_reserve() args in find_ramdisk().
 > 
 > This fixes the missing ram regression reported by
 > Mikael Pettersson <mikpe@it.uu.se>, much thanks for
 > all of this help in diagnosing this.
 > 
 > The second argument to lmb_reserve() is a size,
 > not an end address bounds.
 > 
 > Signed-off-by: David S. Miller <davem@davemloft.net>
 > ---
 >  arch/sparc64/mm/init.c |    2 +-
 >  1 files changed, 1 insertions(+), 1 deletions(-)
 > 
 > diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
 > index a9828d7..3c7b947 100644
 > --- a/arch/sparc64/mm/init.c
 > +++ b/arch/sparc64/mm/init.c
 > @@ -768,7 +768,7 @@ static void __init find_ramdisk(unsigned long phys_base)
 >  		initrd_start = ramdisk_image;
 >  		initrd_end = ramdisk_image + sparc_ramdisk_size;
 >  
 > -		lmb_reserve(initrd_start, initrd_end);
 > +		lmb_reserve(initrd_start, sparc_ramdisk_size);
 >  
 >  		initrd_start += PAGE_OFFSET;
 >  		initrd_end += PAGE_OFFSET;
 > -- 
 > 1.5.5.1.57.g5909c
 > 

Thanks Dave. As the dmesg diff below shows, this patch fixed
my lost RAM issue. I actually have about 8KB more available
now than I had with 2.6.25.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

--- dmesg-2.6.26-rc2-a	2008-05-15 16:12:39.000000000 +0200
+++ dmesg-2.6.26-rc2-b	2008-05-15 16:18:37.000000000 +0200
@@ -1,14 +1,14 @@
 PROMLIB: Sun IEEE Boot Prom 'OBP 3.25.3 2000/06/29 14:12'
 PROMLIB: Root node compatible: 
-Linux version 2.6.26-rc2 (mikpe@sparge) (gcc version 4.2.3) #1 Wed May 14 22:27:26 CEST 2008
+Linux version 2.6.26-rc2 (mikpe@sparge) (gcc version 4.2.3) #2 Thu May 15 16:14:24 CEST 2008
 console [earlyprom0] enabled
 ARCH: SUN4U
 Ethernet address: 08:00:20:fd:ec:1f
-Found ramdisk at physical address 0x10800000, size 3780573
+Found ramdisk at physical address 0x10800000, size 3780646
 Kernel: Using 1 locked TLB entries for main kernel image.
 Remapping the kernel... done.
 OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
-PROM: Built device tree with 42146 bytes of memory.
+PROM: Built device tree with 42148 bytes of memory.
 bootmem_init_nonnuma()
 Top of RAM: 0x17f46000, Total RAM: 0xff42000
 Memory hole size: 128MB
@@ -25,8 +25,12 @@
       MATCH reserving range [7ffe000:8000000]
     reserve_range_in_node(nid[0],start[10000000],end[1030ed28]
       MATCH reserving range [10000000:1030ed28]
-    reserve_range_in_node(nid[0],start[107eb3c0],end[2139afdd]
-      MATCH reserving range [107eb3c0:2139afdd]
+    reserve_range_in_node(nid[0],start[10800000],end[10b9b026]
+      MATCH reserving range [10800000:10b9b026]
+    reserve_range_in_node(nid[0],start[17f2f3c0],end[17f3c000]
+      MATCH reserving range [17f2f3c0:17f3c000]
+    reserve_range_in_node(nid[0],start[17f3e000],end[17f46000]
+      MATCH reserving range [17f3e000:17f46000]
   sparse_memory_present_with_active_regions(0)
 [0000000200000000-fffff80000400000] page_structs=131072 node=0 entry=0/0
 [0000000200000000-fffff80000800000] page_structs=131072 node=0 entry=1/0
@@ -53,9 +57,9 @@
 console handover: boot [earlyprom0] -> real [tty0]
 Dentry cache hash table entries: 32768 (order: 5, 262144 bytes)
 Inode-cache hash table entries: 16384 (order: 4, 131072 bytes)
-Memory: 127016k available (1920k kernel code, 744k data, 152k init) [fffff80000000000,0000000017f46000]
+Memory: 245448k available (1920k kernel code, 744k data, 152k init) [fffff80000000000,0000000017f46000]
...
