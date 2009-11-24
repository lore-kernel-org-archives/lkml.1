Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbZKXPKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbZKXPKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933272AbZKXPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:10:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57704 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933271AbZKXPHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:51 -0500
Message-Id: <20091124150757.659866000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:20 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 23/29] GRU - check for correct GRU chiplet assignment
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_check_chiplet_assignment
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Simplify the code that checks for correct assignment
of GRU contexts to users.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grumain.c |   44 +++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:36.000000000 -0600
@@ -53,12 +53,16 @@ struct device *grudev = &gru_device;
  */
 int gru_cpu_fault_map_id(void)
 {
+#ifdef CONFIG_IA64
+	return uv_blade_processor_id() % GRU_NUM_TFM;
+#else
 	int cpu = smp_processor_id();
 	int id, core;
 
 	core = uv_cpu_core_number(cpu);
 	id = core + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
 	return id;
+#endif
 }
 
 /*--------- ASID Management -------------------------------------------
@@ -699,15 +703,34 @@ static int gru_retarget_intr(struct gru_
 }
 
 /*
+ * Check if a GRU context is allowed to use a specific chiplet. By default
+ * a context is assigned to any blade-local chiplet. However, users can
+ * override this.
+ * 	Returns 1 if assignment allowed, 0 otherwise
+ */
+static int gru_check_chiplet_assignment(struct gru_state *gru,
+					struct gru_thread_state *gts)
+{
+	int blade_id;
+	int chiplet_id;
+
+	blade_id = gts->ts_user_blade_id;
+	if (blade_id < 0)
+		blade_id = uv_numa_blade_id();
+
+	chiplet_id = gts->ts_user_chiplet_id;
+	return gru->gs_blade_id == blade_id &&
+		(chiplet_id < 0 || chiplet_id == gru->gs_chiplet_id);
+}
+
+/*
  * Unload the gru context if it is not assigned to the correct blade or
  * chiplet. Misassignment can occur if the process migrates to a different
  * blade or if the user changes the selected blade/chiplet.
- * 	Return 0 if  context correct placed, otherwise 1
  */
 void gru_check_context_placement(struct gru_thread_state *gts)
 {
 	struct gru_state *gru;
-	int blade_id, chiplet_id;
 
 	/*
 	 * If the current task is the context owner, verify that the
@@ -718,13 +741,7 @@ void gru_check_context_placement(struct 
 	if (!gru || gts->ts_tgid_owner != current->tgid)
 		return;
 
-	blade_id = gts->ts_user_blade_id;
-	if (blade_id < 0)
-		blade_id = uv_numa_blade_id();
-
-	chiplet_id = gts->ts_user_chiplet_id;
-	if (gru->gs_blade_id != blade_id ||
-	    (chiplet_id >= 0 && chiplet_id != gru->gs_chiplet_id)) {
+	if (!gru_check_chiplet_assignment(gru, gts)) {
 		STAT(check_context_unload);
 		gru_unload_context(gts, 1);
 	} else if (gru_retarget_intr(gts)) {
@@ -768,9 +785,9 @@ void gru_steal_context(struct gru_thread
 	struct gru_state *gru, *gru0;
 	struct gru_thread_state *ngts = NULL;
 	int ctxnum, ctxnum0, flag = 0, cbr, dsr;
-	int blade_id = gts->ts_user_blade_id;
-	int chiplet_id = gts->ts_user_chiplet_id;
+	int blade_id;
 
+	blade_id = gts->ts_user_blade_id;
 	if (blade_id < 0)
 		blade_id = uv_numa_blade_id();
 	cbr = gts->ts_cbr_au_count;
@@ -788,7 +805,7 @@ void gru_steal_context(struct gru_thread
 	ctxnum0 = ctxnum;
 	gru0 = gru;
 	while (1) {
-		if (chiplet_id < 0 || chiplet_id == gru->gs_chiplet_id) {
+		if (gru_check_chiplet_assignment(gru, gts)) {
 			if (check_gru_resources(gru, cbr, dsr, GRU_NUM_CCH))
 				break;
 			spin_lock(&gru->gs_lock);
@@ -853,7 +870,6 @@ struct gru_state *gru_assign_gru_context
 	struct gru_state *gru, *grux;
 	int i, max_active_contexts;
 	int blade_id = gts->ts_user_blade_id;
-	int chiplet_id = gts->ts_user_chiplet_id;
 
 	if (blade_id < 0)
 		blade_id = uv_numa_blade_id();
@@ -861,7 +877,7 @@ again:
 	gru = NULL;
 	max_active_contexts = GRU_NUM_CCH;
 	for_each_gru_on_blade(grux, blade_id, i) {
-		if (chiplet_id >= 0 && chiplet_id != grux->gs_chiplet_id)
+		if (!gru_check_chiplet_assignment(grux, gts))
 			continue;
 		if (check_gru_resources(grux, gts->ts_cbr_au_count,
 					gts->ts_dsr_au_count,

