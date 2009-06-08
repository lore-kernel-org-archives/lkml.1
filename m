Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZFHRUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZFHRUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZFHRTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:19:44 -0400
Received: from relay3.sgi.com ([192.48.156.57]:39319 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752873AbZFHRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:19:43 -0400
Message-Id: <20090608171942.356996000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:49 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 01/12] GRU - fix cache coherency issues with instruction retry
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_flush_cbe_at_exception
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix 2 problems related to GRU instruction failures. Cache coherency
is not maintained for CBEs except when loading or unloading contexts.
When reading a CBE to extract error information, the CBE must first be flushed
from the cache.

The function that reads kerrnel CBEs was reading the wrong CBE.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c     |    3 ++-
 drivers/misc/sgi-gru/grufile.c      |    2 +-
 drivers/misc/sgi-gru/grukservices.c |   12 ++++++++++--
 drivers/misc/sgi-gru/grutables.h    |    1 +
 4 files changed, 14 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-04-29 13:40:17.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-04-29 13:40:36.000000000 -0500
@@ -618,7 +618,7 @@ int gru_get_exception_detail(unsigned lo
 	} else if (gts->ts_gru) {
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
-		prefetchw(cbe);/* Harmless on hardware, required for emulator */
+		gru_flush_cache(cbe);	/* CBE not coherent */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
@@ -626,6 +626,7 @@ int gru_get_exception_detail(unsigned lo
 		excdet.exceptdet1 = cbe->idef3upd;
 		excdet.cbrstate = cbe->cbrstate;
 		excdet.cbrexecstatus = cbe->cbrexecstatus;
+		gru_flush_cache(cbe);
 		ret = 0;
 	} else {
 		ret = -EAGAIN;
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:40:16.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:41:09.000000000 -0500
@@ -46,6 +46,7 @@
 
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
 unsigned long gru_start_paddr __read_mostly;
+void *gru_start_vaddr __read_mostly;
 unsigned long gru_end_paddr __read_mostly;
 unsigned int gru_max_gids __read_mostly;
 struct gru_stats_s gru_stats;
@@ -376,7 +377,6 @@ static int __init gru_init(void)
 {
 	int ret, irq, chip;
 	char id[10];
-	void *gru_start_vaddr;
 
 	if (!is_uv_system())
 		return 0;
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:40:17.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-04-29 13:40:36.000000000 -0500
@@ -98,6 +98,9 @@
 #define ASYNC_HAN_TO_BID(h)	((h) - 1)
 #define ASYNC_BID_TO_HAN(b)	((b) + 1)
 #define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
+#define KCB_TO_GID(cb)		((cb - gru_start_vaddr) /		\
+					(GRU_SIZE * GRU_CHIPLETS_PER_BLADE))
+#define KCB_TO_BS(cb)		gru_base[KCB_TO_GID(cb)]
 
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
@@ -354,14 +357,19 @@ int gru_get_cb_exception_detail(void *cb
 		struct control_block_extended_exc_detail *excdet)
 {
 	struct gru_control_block_extended *cbe;
+	struct gru_blade_state *bs;
+	int cbrnum;
 
-	cbe = get_cbe(GRUBASE(cb), get_cb_number(cb));
-	prefetchw(cbe);	/* Harmless on hardware, required for emulator */
+	bs = KCB_TO_BS(cb);
+	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
+	cbe = get_cbe(GRUBASE(cb), cbrnum);
+	gru_flush_cache(cbe);	/* CBE not coherent */
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
 	excdet->exceptdet0 = cbe->idef1upd;
 	excdet->exceptdet1 = cbe->idef3upd;
+	gru_flush_cache(cbe);
 	return 0;
 }
 
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-29 13:40:17.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-29 13:40:36.000000000 -0500
@@ -153,6 +153,7 @@
 extern struct gru_stats_s gru_stats;
 extern struct gru_blade_state *gru_base[];
 extern unsigned long gru_start_paddr, gru_end_paddr;
+extern void *gru_start_vaddr;
 extern unsigned int gru_max_gids;
 
 #define GRU_MAX_BLADES		MAX_NUMNODES

