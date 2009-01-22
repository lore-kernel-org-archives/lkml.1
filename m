Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbZAVRxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbZAVRxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZAVRui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:38 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39037 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760094AbZAVRua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:30 -0500
Message-Id: <20090122175028.969013000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:27 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 10/14] Restructure the GRU vtop functions
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_gru_vtop
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Restructure the GRU vtop functions in preparation for future changes.
This patch simply moves code around & does not change the algorithm.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   68 +++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 24 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:10.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:12.000000000 -0600
@@ -267,6 +267,44 @@ err:
 	return 1;
 }
 
+static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
+		    int write, int atomic, unsigned long *gpa, int *pageshift)
+{
+	struct mm_struct *mm = gts->ts_mm;
+	struct vm_area_struct *vma;
+	unsigned long paddr;
+	int ret, ps;
+
+	vma = find_vma(mm, vaddr);
+	if (!vma)
+		goto inval;
+
+	/*
+	 * Atomic lookup is faster & usually works even if called in non-atomic
+	 * context.
+	 */
+	rmb();	/* Must/check ms_range_active before loading PTEs */
+	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
+	if (ret) {
+		if (atomic)
+			goto upm;
+		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
+			goto inval;
+	}
+	if (is_gru_paddr(paddr))
+		goto inval;
+	paddr = paddr & ~((1UL << ps) - 1);
+	*gpa = uv_soc_phys_ram_to_gpa(paddr);
+	*pageshift = ps;
+	return 0;
+
+inval:
+	return -1;
+upm:
+	return -2;
+}
+
+
 /*
  * Drop a TLB entry into the GRU. The fault is described by info in an TFH.
  *	Input:
@@ -281,10 +319,8 @@ static int gru_try_dropin(struct gru_thr
 			  struct gru_tlb_fault_handle *tfh,
 			  unsigned long __user *cb)
 {
-	struct mm_struct *mm = gts->ts_mm;
-	struct vm_area_struct *vma;
-	int pageshift, asid, write, ret;
-	unsigned long paddr, gpa, vaddr;
+	int pageshift = 0, asid, write, ret, atomic = !cb;
+	unsigned long gpa = 0, vaddr = 0;
 
 	/*
 	 * NOTE: The GRU contains magic hardware that eliminates races between
@@ -318,28 +354,12 @@ static int gru_try_dropin(struct gru_thr
 	if (atomic_read(&gts->ts_gms->ms_range_active))
 		goto failactive;
 
-	vma = find_vma(mm, vaddr);
-	if (!vma)
-		goto failinval;
-
-	/*
-	 * Atomic lookup is faster & usually works even if called in non-atomic
-	 * context.
-	 */
-	rmb();	/* Must/check ms_range_active before loading PTEs */
-	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &pageshift);
-	if (ret) {
-		if (!cb)
-			goto failupm;
-		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr,
-					  &pageshift))
-			goto failinval;
-	}
-	if (is_gru_paddr(paddr))
+	ret = gru_vtop(gts, vaddr, write, atomic, &gpa, &pageshift);
+	if (ret == -1)
 		goto failinval;
+	if (ret == -2)
+		goto failupm;
 
-	paddr = paddr & ~((1UL << pageshift) - 1);
-	gpa = uv_soc_phys_ram_to_gpa(paddr);
 	gru_cb_set_istatus_active(cb);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));

