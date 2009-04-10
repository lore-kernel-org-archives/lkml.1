Return-Path: <linux-kernel-owner+w=401wt.eu-S938215AbZDJNYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938215AbZDJNYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbZDJNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:24:20 -0400
Received: from relay3.sgi.com ([192.48.156.57]:33678 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754889AbZDJNYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:24:19 -0400
Date: Fri, 10 Apr 2009 08:24:18 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 03/13] GRU - dynamic allocation of kernel contexts
Message-ID: <20090410132418.GB18113@sgi.com>
References: <20090406160809.278924000@sgi.com> <20090406161011.887146000@sgi.com> <20090409153709.96fb4d96.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409153709.96fb4d96.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the interface to gru_alloc_gts() so that it can be used to
allocate GRU contexts for kernel threads. Kernel threads do
not have vdata structures for the GRU contexts. The GRU resource
count are now passed explicitly instead of inside the vdata structure.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---

Added fixes from Andrew.


 drivers/misc/sgi-gru/grumain.c   |   60 ++++++++++++++++++++-------------------
 drivers/misc/sgi-gru/grutables.h |    2 +
 2 files changed, 33 insertions(+), 29 deletions(-)

Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-04-10 07:32:21.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-04-10 07:39:34.000000000 -0500
@@ -299,15 +299,13 @@ static struct gru_thread_state *gru_find
 /*
  * Allocate a thread state structure.
  */
-static struct gru_thread_state *gru_alloc_gts(struct vm_area_struct *vma,
-					      struct gru_vma_data *vdata,
-					      int tsid)
+struct gru_thread_state *gru_alloc_gts(struct vm_area_struct *vma,
+		int cbr_au_count, int dsr_au_count, int options, int tsid)
 {
 	struct gru_thread_state *gts;
 	int bytes;
 
-	bytes = DSR_BYTES(vdata->vd_dsr_au_count) +
-				CBR_BYTES(vdata->vd_cbr_au_count);
+	bytes = DSR_BYTES(dsr_au_count) + CBR_BYTES(cbr_au_count);
 	bytes += sizeof(struct gru_thread_state);
 	gts = kzalloc(bytes, GFP_KERNEL);
 	if (!gts)
@@ -316,21 +314,22 @@ static struct gru_thread_state *gru_allo
 	STAT(gts_alloc);
 	atomic_set(&gts->ts_refcnt, 1);
 	mutex_init(&gts->ts_ctxlock);
-	gts->ts_cbr_au_count = vdata->vd_cbr_au_count;
-	gts->ts_dsr_au_count = vdata->vd_dsr_au_count;
-	gts->ts_user_options = vdata->vd_user_options;
+	gts->ts_cbr_au_count = cbr_au_count;
+	gts->ts_dsr_au_count = dsr_au_count;
+	gts->ts_user_options = options;
 	gts->ts_tsid = tsid;
-	gts->ts_user_options = vdata->vd_user_options;
 	gts->ts_ctxnum = NULLCTX;
-	gts->ts_mm = current->mm;
-	gts->ts_vma = vma;
 	gts->ts_tlb_int_select = -1;
-	gts->ts_gms = gru_register_mmu_notifier();
 	gts->ts_sizeavail = GRU_SIZEAVAIL(PAGE_SHIFT);
-	if (!gts->ts_gms)
-		goto err;
+	if (vma) {
+		gts->ts_mm = current->mm;
+		gts->ts_vma = vma;
+		gts->ts_gms = gru_register_mmu_notifier();
+		if (!gts->ts_gms)
+			goto err;
+	}
 
-	gru_dbg(grudev, "alloc vdata %p, new gts %p\n", vdata, gts);
+	gru_dbg(grudev, "alloc gts %p\n", gts);
 	return gts;
 
 err:
@@ -381,7 +380,8 @@ struct gru_thread_state *gru_alloc_threa
 	struct gru_vma_data *vdata = vma->vm_private_data;
 	struct gru_thread_state *gts, *ngts;
 
-	gts = gru_alloc_gts(vma, vdata, tsid);
+	gts = gru_alloc_gts(vma, vdata->vd_cbr_au_count, vdata->vd_dsr_au_count,
+			    vdata->vd_user_options, tsid);
 	if (!gts)
 		return NULL;
 
@@ -645,7 +645,7 @@ static int gru_retarget_intr(struct gru_
 #define next_gru(b, g)	(((g) < &(b)->bs_grus[GRU_CHIPLETS_PER_BLADE - 1]) ?  \
 				 ((g)+1) : &(b)->bs_grus[0])
 
-static void gru_steal_context(struct gru_thread_state *gts)
+static void gru_steal_context(struct gru_thread_state *gts, int blade_id)
 {
 	struct gru_blade_state *blade;
 	struct gru_state *gru, *gru0;
@@ -655,8 +655,7 @@ static void gru_steal_context(struct gru
 	cbr = gts->ts_cbr_au_count;
 	dsr = gts->ts_dsr_au_count;
 
-	preempt_disable();
-	blade = gru_base[uv_numa_blade_id()];
+	blade = gru_base[blade_id];
 	spin_lock(&blade->bs_lock);
 
 	ctxnum = next_ctxnum(blade->bs_lru_ctxnum);
@@ -693,7 +692,6 @@ static void gru_steal_context(struct gru
 	blade->bs_lru_gru = gru;
 	blade->bs_lru_ctxnum = ctxnum;
 	spin_unlock(&blade->bs_lock);
-	preempt_enable();
 
 	if (ngts) {
 		STAT(steal_context);
@@ -713,17 +711,17 @@ static void gru_steal_context(struct gru
 /*
  * Scan the GRUs on the local blade & assign a GRU context.
  */
-static struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts)
+static struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
+						int blade)
 {
 	struct gru_state *gru, *grux;
 	int i, max_active_contexts;
 
-	preempt_disable();
 
 again:
 	gru = NULL;
 	max_active_contexts = GRU_NUM_CCH;
-	for_each_gru_on_blade(grux, uv_numa_blade_id(), i) {
+	for_each_gru_on_blade(grux, blade, i) {
 		if (check_gru_resources(grux, gts->ts_cbr_au_count,
 					gts->ts_dsr_au_count,
 					max_active_contexts)) {
@@ -763,7 +761,6 @@ again:
 		STAT(assign_context_failed);
 	}
 
-	preempt_enable();
 	return gru;
 }
 
@@ -778,6 +775,7 @@ int gru_fault(struct vm_area_struct *vma
 {
 	struct gru_thread_state *gts;
 	unsigned long paddr, vaddr;
+	int blade_id;
 
 	vaddr = (unsigned long)vmf->virtual_address;
 	gru_dbg(grudev, "vma %p, vaddr 0x%lx (0x%lx)\n",
@@ -792,8 +790,10 @@ int gru_fault(struct vm_area_struct *vma
 again:
 	mutex_lock(&gts->ts_ctxlock);
 	preempt_disable();
+	blade_id = uv_numa_blade_id();
+
 	if (gts->ts_gru) {
-		if (gts->ts_gru->gs_blade_id != uv_numa_blade_id()) {
+		if (gts->ts_gru->gs_blade_id != blade_id) {
 			STAT(migrated_nopfn_unload);
 			gru_unload_context(gts, 1);
 		} else {
@@ -803,12 +803,14 @@ again:
 	}
 
 	if (!gts->ts_gru) {
-		if (!gru_assign_gru_context(gts)) {
-			mutex_unlock(&gts->ts_ctxlock);
+		if (!gru_assign_gru_context(gts, blade_id)) {
 			preempt_enable();
+			mutex_unlock(&gts->ts_ctxlock);
+			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
+			blade_id = uv_numa_blade_id();
 			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
-				gru_steal_context(gts);
+				gru_steal_context(gts, blade_id);
 			goto again;
 		}
 		gru_load_context(gts);
@@ -818,8 +820,8 @@ again:
 				vma->vm_page_prot);
 	}
 
-	mutex_unlock(&gts->ts_ctxlock);
 	preempt_enable();
+	mutex_unlock(&gts->ts_ctxlock);
 
 	return VM_FAULT_NOPAGE;
 }
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-10 07:32:21.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-10 07:36:41.000000000 -0500
@@ -630,6 +630,8 @@ extern void gru_flush_all_tlb(struct gru
 extern int gru_proc_init(void);
 extern void gru_proc_exit(void);
 
+extern struct gru_thread_state *gru_alloc_gts(struct vm_area_struct *vma,
+		int cbr_au_count, int dsr_au_count, int options, int tsid);
 extern unsigned long gru_reserve_cb_resources(struct gru_state *gru,
 		int cbr_au_count, char *cbmap);
 extern unsigned long gru_reserve_ds_resources(struct gru_state *gru,
