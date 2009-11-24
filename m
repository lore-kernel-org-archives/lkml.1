Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbZKXPKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbZKXPKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbZKXPKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:10:07 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933101AbZKXPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:50 -0500
Message-Id: <20091124150756.505101000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:17 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 20/29] GRU - Fix bug in exception handling
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_kservices_errors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix a GRU driver bug converting a CBR address to the context that
contains the CBR. The conversion is rarely done so performance does
not matter.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grukservices.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:35.000000000 -0600
@@ -97,9 +97,6 @@
 #define ASYNC_HAN_TO_BID(h)	((h) - 1)
 #define ASYNC_BID_TO_HAN(b)	((b) + 1)
 #define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
-#define KCB_TO_GID(cb)		((cb - gru_start_vaddr) /		\
-					(GRU_SIZE * GRU_CHIPLETS_PER_BLADE))
-#define KCB_TO_BS(cb)		gru_base[KCB_TO_GID(cb)]
 
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
@@ -388,11 +385,28 @@ int gru_get_cb_exception_detail(void *cb
 		struct control_block_extended_exc_detail *excdet)
 {
 	struct gru_control_block_extended *cbe;
-	struct gru_blade_state *bs;
-	int cbrnum;
-
-	bs = KCB_TO_BS(cb);
-	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
+	struct gru_thread_state *kgts = NULL;
+	unsigned long off;
+	int cbrnum, bid;
+
+	/*
+	 * Locate kgts for cb. This algorithm is SLOW but
+	 * this function is rarely called (ie., almost never).
+	 * Performance does not matter.
+	 */
+	for_each_possible_blade(bid) {
+		if (!gru_base[bid])
+			break;
+		kgts = gru_base[bid]->bs_kgts;
+		if (!kgts || !kgts->ts_gru)
+			continue;
+		off = cb - kgts->ts_gru->gs_gru_base_vaddr;
+		if (off < GRU_SIZE)
+			break;
+		kgts = NULL;
+	}
+	BUG_ON(!kgts);
+	cbrnum = thread_cbr_number(kgts, get_cb_number(cb));
 	cbe = get_cbe(GRUBASE(cb), cbrnum);
 	gru_flush_cache(cbe);	/* CBE not coherent */
 	sync_core();

