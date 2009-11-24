Return-Path: <linux-kernel-owner+w=401wt.eu-S933346AbZKXPJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbZKXPJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbZKXPJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:09:26 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39137 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933279AbZKXPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:52 -0500
Message-Id: <20091124150758.346566000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:22 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 25/29] GRU - Fix bug in allocation of kernel contexts
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_kservices_bug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix a bug in the assignment of GRU contexts used for kernel
functions. If a sleep occurs on the wait for a semaphore, the thread
could switch cpus and allocate resources on the wrong blade.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:37.000000000 -0600
@@ -221,13 +221,21 @@ static int gru_free_kernel_contexts(void
 static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
 {
 	struct gru_blade_state *bs;
+	int bid;
 
 	STAT(lock_kernel_context);
-	bs = gru_base[blade_id];
+again:
+	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
+	bs = gru_base[bid];
 
+	/* Handle the case where migration occured while waiting for the sema */
 	down_read(&bs->bs_kgts_sema);
+	if (blade_id < 0 && bid != uv_numa_blade_id()) {
+		up_read(&bs->bs_kgts_sema);
+		goto again;
+	}
 	if (!bs->bs_kgts || !bs->bs_kgts->ts_gru)
-		gru_load_kernel_context(bs, blade_id);
+		gru_load_kernel_context(bs, bid);
 	return bs;
 
 }
@@ -256,7 +264,7 @@ static int gru_get_cpu_resources(int dsr
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
 	preempt_disable();
-	bs = gru_lock_kernel_context(uv_numa_blade_id());
+	bs = gru_lock_kernel_context(-1);
 	lcpu = uv_blade_processor_id();
 	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
 	*dsr = bs->kernel_dsr + lcpu * GRU_NUM_KERNEL_DSR_BYTES;

