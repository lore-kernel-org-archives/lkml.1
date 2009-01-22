Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbZAVRzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbZAVRzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZAVRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:44 -0500
Received: from relay3.sgi.com ([192.48.171.31]:56061 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760103AbZAVRub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:31 -0500
Message-Id: <20090122175030.038507000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:30 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 13/14] Fix bugs related to module unload of the GRU driver
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_gru_module_unload
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix bugs related to module unload of the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c      |    5 ++++-
 drivers/misc/sgi-gru/grukservices.c |   19 +++++++++++++++++++
 drivers/misc/sgi-gru/grutables.h    |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-01-21 12:53:18.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-01-21 12:53:19.000000000 -0600
@@ -452,7 +452,7 @@ exit1:
 
 static void __exit gru_exit(void)
 {
-	int i, bid;
+	int i, bid, gid;
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
@@ -462,6 +462,9 @@ static void __exit gru_exit(void)
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
 
+	foreach_gid(gid)
+		gru_kservices_exit(GID_TO_GRU(gid));
+
 	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
 		free_pages((unsigned long)gru_base[bid], order);
 
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-01-21 12:53:17.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-01-21 12:53:24.000000000 -0600
@@ -690,3 +690,22 @@ int gru_kservices_init(struct gru_state 
 		quicktest(gru);
 	return 0;
 }
+
+void gru_kservices_exit(struct gru_state *gru)
+{
+	struct gru_context_configuration_handle *cch;
+	struct gru_blade_state *bs;
+
+	bs = gru->gs_blade;
+	if (gru != &bs->bs_grus[1])
+		return;
+
+	cch = get_cch(gru->gs_gru_base_vaddr, KERNEL_CTXNUM);
+	lock_cch_handle(cch);
+	if (cch_interrupt_sync(cch))
+		BUG();
+	if (cch_deallocate(cch))
+		BUG();
+	unlock_cch_handle(cch);
+}
+
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-01-21 12:53:18.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-01-21 12:53:24.000000000 -0600
@@ -600,6 +600,7 @@ extern void gru_unload_context(struct gr
 extern void gts_drop(struct gru_thread_state *gts);
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(struct gru_state *gru);
+extern void gru_kservices_exit(struct gru_state *gru);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
 extern int gru_user_flush_tlb(unsigned long arg);

