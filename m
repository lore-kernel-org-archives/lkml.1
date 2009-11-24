Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbZKXPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbZKXPNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbZKXPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:13:15 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39129 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933215AbZKXPHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:44 -0500
Message-Id: <20091124150748.089115000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:00 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 03/29] GRU - fix istatus race in GRU tlb dropin
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_tfh_istatus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

TLB dropins require updates to the CBR instruction istatus field. This
is needed to resolve race conditions in the chip.

The code currently uses the user address of the CBR. This works but opens up
additional endcases related to stealing of contexts and accessing the
CBR from tasks that do not have access to the user address space. (Some
of this non-user task access is debug code that is not currently being pushed
to the community).

User CBRs are also directly accessible using the kernel mapping
of the CBR.  Change the TLB dropin code to use the the kernel
mapping of the CBR.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   53 ++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:27.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:27.000000000 -0600
@@ -122,22 +122,11 @@ static void gru_unlock_gts(struct gru_th
  * is necessary to prevent the user from seeing a stale cb.istatus that will
  * change as soon as the TFH restart is complete. Races may cause an
  * occasional failure to clear the cb.istatus, but that is ok.
- *
- * If the cb address is not valid (should not happen, but...), nothing
- * bad will happen.. The get_user()/put_user() will fail but there
- * are no bad side-effects.
- */
-static void gru_cb_set_istatus_active(unsigned long __user *cb)
-{
-	union {
-		struct gru_instruction_bits bits;
-		unsigned long dw;
-	} u;
-
-	if (cb) {
-		get_user(u.dw, cb);
-		u.bits.istatus = CBS_ACTIVE;
-		put_user(u.dw, cb);
+ */
+static void gru_cb_set_istatus_active(struct gru_instruction_bits *cbk)
+{
+	if (cbk) {
+		cbk->istatus = CBS_ACTIVE;
 	}
 }
 
@@ -322,9 +311,9 @@ upm:
  */
 static int gru_try_dropin(struct gru_thread_state *gts,
 			  struct gru_tlb_fault_handle *tfh,
-			  unsigned long __user *cb)
+			  struct gru_instruction_bits *cbk)
 {
-	int pageshift = 0, asid, write, ret, atomic = !cb;
+	int pageshift = 0, asid, write, ret, atomic = !cbk;
 	unsigned long gpa = 0, vaddr = 0;
 
 	/*
@@ -347,7 +336,7 @@ static int gru_try_dropin(struct gru_thr
 	}
 	if (tfh->state == TFHSTATE_IDLE)
 		goto failidle;
-	if (tfh->state == TFHSTATE_MISS_FMM && cb)
+	if (tfh->state == TFHSTATE_MISS_FMM && cbk)
 		goto failfmm;
 
 	write = (tfh->cause & TFHCAUSE_TLB_MOD) != 0;
@@ -378,7 +367,7 @@ static int gru_try_dropin(struct gru_thr
 			goto failupm;
 		}
 	}
-	gru_cb_set_istatus_active(cb);
+	gru_cb_set_istatus_active(cbk);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
 	STAT(tlb_dropin);
@@ -392,7 +381,7 @@ failnoasid:
 	/* No asid (delayed unload). */
 	STAT(tlb_dropin_fail_no_asid);
 	gru_dbg(grudev, "FAILED no_asid tfh: 0x%p, vaddr 0x%lx\n", tfh, vaddr);
-	if (!cb)
+	if (!cbk)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
@@ -415,17 +404,18 @@ failfmm:
 failnoexception:
 	/* TFH status did not show exception pending */
 	gru_flush_cache(tfh);
-	if (cb)
-		gru_flush_cache(cb);
+	if (cbk)
+		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_no_exception);
-	gru_dbg(grudev, "FAILED non-exception tfh: 0x%p, status %d, state %d\n", tfh, tfh->status, tfh->state);
+	gru_dbg(grudev, "FAILED non-exception tfh: 0x%p, status %d, state %d\n",
+		tfh, tfh->status, tfh->state);
 	return 0;
 
 failidle:
 	/* TFH state was idle  - no miss pending */
 	gru_flush_cache(tfh);
-	if (cb)
-		gru_flush_cache(cb);
+	if (cbk)
+		gru_flush_cache(cbk);
 	STAT(tlb_dropin_fail_idle);
 	gru_dbg(grudev, "FAILED idle tfh: 0x%p, state %d\n", tfh, tfh->state);
 	return 0;
@@ -439,7 +429,7 @@ failinval:
 
 failactive:
 	/* Range invalidate active. Switch to UPM iff atomic */
-	if (!cb)
+	if (!cbk)
 		tfh_user_polling_mode(tfh);
 	else
 		gru_flush_cache(tfh);
@@ -512,7 +502,7 @@ irqreturn_t gru_intr(int irq, void *dev_
 
 static int gru_user_dropin(struct gru_thread_state *gts,
 			   struct gru_tlb_fault_handle *tfh,
-			   unsigned long __user *cb)
+			   void *cb)
 {
 	struct gru_mm_struct *gms = gts->ts_gms;
 	int ret;
@@ -538,7 +528,7 @@ int gru_handle_user_call_os(unsigned lon
 {
 	struct gru_tlb_fault_handle *tfh;
 	struct gru_thread_state *gts;
-	unsigned long __user *cbp;
+	void *cbk;
 	int ucbnum, cbrnum, ret = -EINVAL;
 
 	STAT(call_os);
@@ -548,7 +538,6 @@ int gru_handle_user_call_os(unsigned lon
 	ucbnum = get_cb_number((void *)cb);
 	if ((cb & (GRU_HANDLE_STRIDE - 1)) || ucbnum >= GRU_NUM_CB)
 		return -EINVAL;
-	cbp = (unsigned long *)cb;
 
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
@@ -583,7 +572,9 @@ int gru_handle_user_call_os(unsigned lon
 		gru_unload_context(gts, 1);
 	} else if (gts->ts_gru) {
 		tfh = get_tfh_by_index(gts->ts_gru, cbrnum);
-		ret = gru_user_dropin(gts, tfh, cbp);
+		cbk = get_gseg_base_address_cb(gts->ts_gru->gs_gru_base_vaddr,
+				gts->ts_ctxnum, ucbnum);
+		ret = gru_user_dropin(gts, tfh, cbk);
 	}
 exit:
 	gru_unlock_gts(gts);

