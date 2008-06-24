Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYFXC4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYFXC4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYFXCy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:54:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:7087 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYFXCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=sg7W46TNDbgGxrmJ/QcRJ8voxUAbqe5XC1x+V63aFMt65iky+tQLv7ALoWT9UuJNUz
         x3zyD7Qb0KAIV1nZYS2O9VOkmzNeLgydB3tiGGVjNg54PzKQ6huIY1jAKIX7KEahhVsb
         dMBEYozOcVqZC1WmnhBLtu+GOoQaxZc6elgxM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move some func calling from setup_arch to paging_init
Date: Mon, 23 Jun 2008 19:51:10 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231951.10898.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


those function depends on paging setup pgtable, so they could access
the ram in bootmem region but just get mapped.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   34 ++--------------------------------
 arch/x86/mm/init_32.c      |   29 +++++++++++++++++++++++++++++
 include/asm-x86/setup.h    |    1 +
 3 files changed, 32 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -250,7 +250,7 @@ static void __init reserve_initrd(void)
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
-static void __init post_reserve_initrd(void)
+void __init post_reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
@@ -308,29 +308,11 @@ static void __init post_reserve_initrd(v
 void __init reserve_initrd(void)
 {
 }
-static void __init post_reserve_initrd(void)
+void __init post_reserve_initrd(void)
 {
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-/*
- * The node 0 pgdat is initialized before all of these because
- * it's needed for bootmem.  node>0 pgdats have their virtual
- * space allocated before the pagetables are in place to access
- * them, so they can't be cleared then.
- *
- * This should all compile down to nothing when NUMA is off.
- */
-static void __init remapped_pgdat_init(void)
-{
-	int nid;
-
-	for_each_online_node(nid) {
-		if (nid != 0)
-			memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
-	}
-}
-
 #ifdef CONFIG_MCA
 static void set_mca_bus(int x)
 {
@@ -530,18 +512,6 @@ void __init setup_arch(char **cmdline_p)
 		init_ohci1394_dma_on_all_controllers();
 #endif
 
-	/*
-	 * NOTE: at this point the bootmem allocator is fully available.
-	 */
-
-	post_reserve_initrd();
-
-	remapped_pgdat_init();
-	sparse_init();
-	zone_sizes_init();
-
-	paravirt_post_allocator_init();
-
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -705,6 +705,23 @@ void __init setup_bootmem_allocator(void
 
 }
 
+/*
+ * The node 0 pgdat is initialized before all of these because
+ * it's needed for bootmem.  node>0 pgdats have their virtual
+ * space allocated before the pagetables are in place to access
+ * them, so they can't be cleared then.
+ *
+ * This should all compile down to nothing when NUMA is off.
+ */
+static void __init remapped_pgdat_init(void)
+{
+	int nid;
+
+	for_each_online_node(nid) {
+		if (nid != 0)
+			memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+	}
+}
 
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
@@ -727,6 +744,18 @@ void __init paging_init(void)
 	__flush_tlb_all();
 
 	kmap_init();
+
+	/*
+	 * NOTE: at this point the bootmem allocator is fully available.
+	 */
+
+	post_reserve_initrd();
+
+	remapped_pgdat_init();
+	sparse_init();
+	zone_sizes_init();
+
+	paravirt_post_allocator_init();
 }
 
 /*
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -39,6 +39,7 @@ void reserve_crashkernel(void);
 #include <asm/bootparam.h>
 
 void reserve_standard_io_resources(void);
+extern void post_reserve_initrd(void);
 
 #ifndef _SETUP
 
