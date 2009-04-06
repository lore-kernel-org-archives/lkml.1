Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZDFQNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZDFQNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZDFQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:27 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41543 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753178AbZDFQKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:17 -0400
Message-Id: <20090406161015.275417000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:20 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 11/13] GRU - support for asynchronous gru instructions
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_async_requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add support for asynchronous GRU instructions. Currently, asynchronous
instructions are supported only for GRU instructions issued by the
kernel.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c     |    4 
 drivers/misc/sgi-gru/grukservices.c |  178 ++++++++++++++++++++++++++++++++----
 drivers/misc/sgi-gru/grukservices.h |   51 ++++++++++
 3 files changed, 215 insertions(+), 18 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:05:28.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:06:06.000000000 -0500
@@ -469,8 +469,8 @@ irqreturn_t gru_intr(int irq, void *dev_
 	}
 	get_clear_fault_map(gru, &imap, &dmap);
 	gru_dbg(grudev,
-		"irq %d, gid %d, imap %016lx %016lx, dmap %016lx %016lx\n",
-		irq, gru->gs_gid, dmap.fault_bits[0], dmap.fault_bits[1],
+		"chiplet %d, gid %d, imap %016lx %016lx, dmap %016lx %016lx\n",
+		chiplet, gru->gs_gid, imap.fault_bits[0], imap.fault_bits[1],
 		dmap.fault_bits[0], dmap.fault_bits[1]);
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-04-06 07:48:04.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-04-06 09:05:31.000000000 -0500
@@ -52,7 +52,53 @@
  * loaded on demand & can be stolen by a user if the user demand exceeds the
  * kernel demand. The kernel can always reload the kernel context but
  * a SLEEP may be required!!!.
+ *
+ * Async Overview:
+ *
+ * 	Each blade has one "kernel context" that owns GRU kernel resources
+ * 	located on the blade. Kernel drivers use GRU resources in this context
+ * 	for sending messages, zeroing memory, etc.
+ *
+ * 	The kernel context is dynamically loaded on demand. If it is not in
+ * 	use by the kernel, the kernel context can be unloaded & given to a user.
+ * 	The kernel context will be reloaded when needed. This may require that
+ * 	a context be stolen from a user.
+ * 		NOTE: frequent unloading/reloading of the kernel context is
+ * 		expensive. We are depending on batch schedulers, cpusets, sane
+ * 		drivers or some other mechanism to prevent the need for frequent
+ *	 	stealing/reloading.
+ *
+ * 	The kernel context consists of two parts:
+ * 		- 1 CB & a few DSRs that are reserved for each cpu on the blade.
+ * 		  Each cpu has it's own private resources & does not share them
+ * 		  with other cpus. These resources are used serially, ie,
+ * 		  locked, used & unlocked  on each call to a function in
+ * 		  grukservices.
+ * 		  	(Now that we have dynamic loading of kernel contexts, I
+ * 		  	 may rethink this & allow sharing between cpus....)
+ *
+ *		- Additional resources can be reserved long term & used directly
+ *		  by UV drivers located in the kernel. Drivers using these GRU
+ *		  resources can use asynchronous GRU instructions that send
+ *		  interrupts on completion.
+ *		  	- these resources must be explicitly locked/unlocked
+ *		  	- locked resources prevent (obviously) the kernel
+ *		  	  context from being unloaded.
+ *			- drivers using these resource directly issue their own
+ *			  GRU instruction and must wait/check completion.
+ *
+ * 		  When these resources are reserved, the caller can optionally
+ * 		  associate a wait_queue with the resources and use asynchronous
+ * 		  GRU instructions. When an async GRU instruction completes, the
+ * 		  driver will do a wakeup on the event.
+ *
  */
+
+
+#define ASYNC_HAN_TO_BID(h)	((h) - 1)
+#define ASYNC_BID_TO_HAN(b)	((b) + 1)
+#define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
+
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
 #define GRU_NUM_KERNEL_DSR_CL	(GRU_NUM_KERNEL_DSR_BYTES /		\
@@ -99,20 +145,6 @@ struct message_header {
 #define HSTATUS(mq, h)	((mq) + offsetof(struct message_queue, hstatus[h]))
 
 /*
- * Allocate a kernel context (GTS) for the specified blade.
- * 	- protected by writelock on bs_kgts_sema.
- */
-static void gru_alloc_kernel_context(struct gru_blade_state *bs, int blade_id)
-{
-	int cbr_au_count, dsr_au_count, ncpus;
-
-	ncpus = uv_blade_nr_possible_cpus(blade_id);
-	cbr_au_count = GRU_CB_COUNT_TO_AU(GRU_NUM_KERNEL_CBR * ncpus);
-	dsr_au_count = GRU_DS_BYTES_TO_AU(GRU_NUM_KERNEL_DSR_BYTES * ncpus);
-	bs->bs_kgts = gru_alloc_gts(NULL, cbr_au_count, dsr_au_count, 0, 0);
-}
-
-/*
  * Reload the blade's kernel context into a GRU chiplet. Called holding
  * the bs_kgts_sema for READ. Will steal user contexts if necessary.
  */
@@ -121,17 +153,23 @@ static void gru_load_kernel_context(stru
 	struct gru_state *gru;
 	struct gru_thread_state *kgts;
 	void *vaddr;
-	int ctxnum;
+	int ctxnum, ncpus;
 
 	up_read(&bs->bs_kgts_sema);
 	down_write(&bs->bs_kgts_sema);
 
 	if (!bs->bs_kgts)
-		gru_alloc_kernel_context(bs, blade_id);
+		bs->bs_kgts = gru_alloc_gts(NULL, 0, 0, 0, 0);
 	kgts = bs->bs_kgts;
 
 	if (!kgts->ts_gru) {
 		STAT(load_kernel_context);
+		ncpus = uv_blade_nr_possible_cpus(blade_id);
+		kgts->ts_cbr_au_count = GRU_CB_COUNT_TO_AU(
+			GRU_NUM_KERNEL_CBR * ncpus + bs->bs_async_cbrs);
+		kgts->ts_dsr_au_count = GRU_DS_BYTES_TO_AU(
+			GRU_NUM_KERNEL_DSR_BYTES * ncpus +
+				bs->bs_async_dsr_bytes);
 		while (!gru_assign_gru_context(kgts, blade_id)) {
 			msleep(1);
 			gru_steal_context(kgts, blade_id);
@@ -203,6 +241,114 @@ static void gru_free_cpu_resources(void 
 	preempt_enable();
 }
 
+/*
+ * Reserve GRU resources to be used asynchronously.
+ *   Note: currently supports only 1 reservation per blade.
+ *
+ * 	input:
+ * 		blade_id  - blade on which resources should be reserved
+ * 		cbrs	  - number of CBRs
+ * 		dsr_bytes - number of DSR bytes needed
+ *	output:
+ *		handle to identify resource
+ *		(0 = async resources already reserved)
+ */
+unsigned long gru_reserve_async_resources(int blade_id, int cbrs, int dsr_bytes,
+			struct completion *cmp)
+{
+	struct gru_blade_state *bs;
+	struct gru_thread_state *kgts;
+	int ret = 0;
+
+	bs = gru_base[blade_id];
+
+	down_write(&bs->bs_kgts_sema);
+
+	/* Verify no resources already reserved */
+	if (bs->bs_async_dsr_bytes + bs->bs_async_cbrs)
+		goto done;
+	bs->bs_async_dsr_bytes = dsr_bytes;
+	bs->bs_async_cbrs = cbrs;
+	bs->bs_async_wq = cmp;
+	kgts = bs->bs_kgts;
+
+	/* Resources changed. Unload context if already loaded */
+	if (kgts && kgts->ts_gru)
+		gru_unload_context(kgts, 0);
+	ret = ASYNC_BID_TO_HAN(blade_id);
+
+done:
+	up_write(&bs->bs_kgts_sema);
+	return ret;
+}
+
+/*
+ * Release async resources previously reserved.
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+void gru_release_async_resources(unsigned long han)
+{
+	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
+
+	down_write(&bs->bs_kgts_sema);
+	bs->bs_async_dsr_bytes = 0;
+	bs->bs_async_cbrs = 0;
+	bs->bs_async_wq = NULL;
+	up_write(&bs->bs_kgts_sema);
+}
+
+/*
+ * Wait for async GRU instructions to complete.
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+void gru_wait_async_cbr(unsigned long han)
+{
+	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
+
+	wait_for_completion(bs->bs_async_wq);
+	mb();
+}
+
+/*
+ * Lock previous reserved async GRU resources
+ *
+ *	input:
+ *		han - handle to identify resources
+ *	output:
+ *		cb  - pointer to first CBR
+ *		dsr - pointer to first DSR
+ */
+void gru_lock_async_resource(unsigned long han,  void **cb, void **dsr)
+{
+	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
+	int blade_id = ASYNC_HAN_TO_BID(han);
+	int ncpus;
+
+	gru_lock_kernel_context(blade_id);
+	ncpus = uv_blade_nr_possible_cpus(blade_id);
+	if (cb)
+		*cb = bs->kernel_cb + ncpus * GRU_HANDLE_STRIDE;
+	if (dsr)
+		*dsr = bs->kernel_dsr + ncpus * GRU_NUM_KERNEL_DSR_BYTES;
+}
+
+/*
+ * Unlock previous reserved async GRU resources
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+void gru_unlock_async_resource(unsigned long han)
+{
+	int blade_id = ASYNC_HAN_TO_BID(han);
+
+	gru_unlock_kernel_context(blade_id);
+}
+
 /*----------------------------------------------------------------------*/
 int gru_get_cb_exception_detail(void *cb,
 		struct control_block_extended_exc_detail *excdet)
Index: linux/drivers/misc/sgi-gru/grukservices.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.h	2009-04-06 07:47:58.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.h	2009-04-06 09:05:27.000000000 -0500
@@ -146,4 +146,55 @@ extern void *gru_get_next_message(struct
 extern int gru_copy_gpa(unsigned long dest_gpa, unsigned long src_gpa,
 							unsigned int bytes);
 
+/*
+ * Reserve GRU resources to be used asynchronously.
+ *
+ * 	input:
+ * 		blade_id  - blade on which resources should be reserved
+ * 		cbrs	  - number of CBRs
+ * 		dsr_bytes - number of DSR bytes needed
+ * 		cmp	  - completion structure for waiting for
+ * 			    async completions
+ *	output:
+ *		handle to identify resource
+ *		(0 = no resources)
+ */
+extern unsigned long gru_reserve_async_resources(int blade_id, int cbrs, int dsr_bytes,
+				struct completion *cmp);
+
+/*
+ * Release async resources previously reserved.
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+extern void gru_release_async_resources(unsigned long han);
+
+/*
+ * Wait for async GRU instructions to complete.
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+extern void gru_wait_async_cbr(unsigned long han);
+
+/*
+ * Lock previous reserved async GRU resources
+ *
+ *	input:
+ *		han - handle to identify resources
+ *	output:
+ *		cb  - pointer to first CBR
+ *		dsr - pointer to first DSR
+ */
+extern void gru_lock_async_resource(unsigned long han,  void **cb, void **dsr);
+
+/*
+ * Unlock previous reserved async GRU resources
+ *
+ *	input:
+ *		han - handle to identify resources
+ */
+extern void gru_unlock_async_resource(unsigned long han);
+
 #endif 		/* __GRU_KSERVICES_H_ */

