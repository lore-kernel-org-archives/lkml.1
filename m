Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZFHRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZFHRUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZFHRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:19:48 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752884AbZFHRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:19:47 -0400
Message-Id: <20090608171946.000713000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:50 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 02/12] GRU - add user request to explicitly unload a gru context
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_free_kernel_gts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add user function to explicitly unload GRU kernel contexts from the
GRU. Only contexts that are not in-use will be unloaded.

This function is primarily for testing. It is not expected that this will
be used in normal production systems.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c      |   10 ++----
 drivers/misc/sgi-gru/grukservices.c |   55 ++++++++++++++++++++++--------------
 drivers/misc/sgi-gru/grutables.h    |    4 +-
 3 files changed, 41 insertions(+), 28 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:41:09.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:42:22.000000000 -0500
@@ -287,7 +287,6 @@ static void gru_init_chiplet(struct gru_
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
 		gru->gs_gru_base_paddr);
-	gru_kservices_init(gru);
 }
 
 static int gru_init_tables(unsigned long gru_base_paddr, void *gru_base_vaddr)
@@ -314,6 +313,7 @@ static int gru_init_tables(unsigned long
 		memset(gru_base[bid], 0, sizeof(struct gru_blade_state));
 		gru_base[bid]->bs_lru_gru = &gru_base[bid]->bs_grus[0];
 		spin_lock_init(&gru_base[bid]->bs_lock);
+		init_rwsem(&gru_base[bid]->bs_kgts_sema);
 
 		dsrbytes = 0;
 		cbrs = 0;
@@ -426,6 +426,7 @@ static int __init gru_init(void)
 		printk(KERN_ERR "%s: init tables failed\n", GRU_DRIVER_ID_STR);
 		goto exit3;
 	}
+	gru_kservices_init();
 
 	printk(KERN_INFO "%s: v%s\n", GRU_DRIVER_ID_STR,
 	       GRU_DRIVER_VERSION_STR);
@@ -444,7 +445,7 @@ exit1:
 
 static void __exit gru_exit(void)
 {
-	int i, bid, gid;
+	int i, bid;
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
@@ -453,10 +454,7 @@ static void __exit gru_exit(void)
 
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
-
-	foreach_gid(gid)
-		gru_kservices_exit(GID_TO_GRU(gid));
-
+	gru_kservices_exit();
 	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
 		free_pages((unsigned long)gru_base[bid], order);
 
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:40:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:41:24.000000000 -0500
@@ -188,6 +188,34 @@ static void gru_load_kernel_context(stru
 }
 
 /*
+ * Free all kernel contexts that are not currently in use.
+ *   Returns 0 if all freed, else number of inuse context.
+ */
+static int gru_free_kernel_contexts(void)
+{
+	struct gru_blade_state *bs;
+	struct gru_thread_state *kgts;
+	int bid, ret = 0;
+
+	for (bid = 0; bid < GRU_MAX_BLADES; bid++) {
+		bs = gru_base[bid];
+		if (!bs)
+			continue;
+		if (down_write_trylock(&bs->bs_kgts_sema)) {
+			kgts = bs->bs_kgts;
+			if (kgts && kgts->ts_gru)
+				gru_unload_context(kgts, 0);
+			kfree(kgts);
+			bs->bs_kgts = NULL;
+			up_write(&bs->bs_kgts_sema);
+		} else {
+			ret++;
+		}
+	}
+	return ret;
+}
+
+/*
  * Lock & load the kernel context for the specified blade.
  */
 static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
@@ -1009,35 +1037,22 @@ int gru_ktest(unsigned long arg)
 	case 2:
 		ret = quicktest2(arg);
 		break;
+	case 99:
+		ret = gru_free_kernel_contexts();
+		break;
 	}
 	return ret;
 
 }
 
-int gru_kservices_init(struct gru_state *gru)
+int gru_kservices_init(void)
 {
-	struct gru_blade_state *bs;
-
-	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[0])
-		return 0;
-
-	init_rwsem(&bs->bs_kgts_sema);
 	return 0;
 }
 
-void gru_kservices_exit(struct gru_state *gru)
+void gru_kservices_exit(void)
 {
-	struct gru_blade_state *bs;
-	struct gru_thread_state *kgts;
-
-	bs = gru->gs_blade;
-	if (gru != &bs->bs_grus[0])
-		return;
-
-	kgts = bs->bs_kgts;
-	if (kgts && kgts->ts_gru)
-		gru_unload_context(kgts, 0);
-	kfree(kgts);
+	if (gru_free_kernel_contexts())
+		BUG();
 }
 
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-29 13:40:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-29 13:43:22.000000000 -0500
@@ -638,8 +638,8 @@ extern void gru_unload_context(struct gr
 extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
-extern int gru_kservices_init(struct gru_state *gru);
-extern void gru_kservices_exit(struct gru_state *gru);
+extern int gru_kservices_init(void);
+extern void gru_kservices_exit(void);
 extern int gru_dump_chiplet_request(unsigned long arg);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);

