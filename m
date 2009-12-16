Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZLPDM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZLPDM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbZLPDM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:12:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49525 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993AbZLPDM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:12:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:09:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 9/11] mm accessor for sgi gru
Message-Id: <20091216120918.41b684ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing mmap_sem with mm_accessor functions. for sgi-gru.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/misc/sgi-gru/grufault.c |   16 ++++++++--------
 drivers/misc/sgi-gru/grufile.c  |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: mmotm-mm-accessor/drivers/misc/sgi-gru/grufault.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/misc/sgi-gru/grufault.c
+++ mmotm-mm-accessor/drivers/misc/sgi-gru/grufault.c
@@ -81,14 +81,14 @@ static struct gru_thread_state *gru_find
 	struct vm_area_struct *vma;
 	struct gru_thread_state *gts = NULL;
 
-	down_read(&mm->mmap_sem);
+	mm_read_lock(mm);
 	vma = gru_find_vma(vaddr);
 	if (vma)
 		gts = gru_find_thread_state(vma, TSID(vaddr, vma));
 	if (gts)
 		mutex_lock(&gts->ts_ctxlock);
 	else
-		up_read(&mm->mmap_sem);
+		mm_read_unlock(mm);
 	return gts;
 }
 
@@ -98,7 +98,7 @@ static struct gru_thread_state *gru_allo
 	struct vm_area_struct *vma;
 	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
-	down_write(&mm->mmap_sem);
+	mm_write_lock(mm);
 	vma = gru_find_vma(vaddr);
 	if (!vma)
 		goto err;
@@ -107,11 +107,11 @@ static struct gru_thread_state *gru_allo
 	if (IS_ERR(gts))
 		goto err;
 	mutex_lock(&gts->ts_ctxlock);
-	downgrade_write(&mm->mmap_sem);
+	mm_write_to_read_lock(mm);
 	return gts;
 
 err:
-	up_write(&mm->mmap_sem);
+	mm_write_unlock(mm);
 	return gts;
 }
 
@@ -121,7 +121,7 @@ err:
 static void gru_unlock_gts(struct gru_thread_state *gts)
 {
 	mutex_unlock(&gts->ts_ctxlock);
-	up_read(&current->mm->mmap_sem);
+	mm_read_unlock(current->mm);
 }
 
 /*
@@ -583,9 +583,9 @@ static irqreturn_t gru_intr(int chiplet,
 		 */
 		gts->ustats.fmm_tlbmiss++;
 		if (!gts->ts_force_cch_reload &&
-					down_read_trylock(&gts->ts_mm->mmap_sem)) {
+					mm_read_trylock(gts->ts_mm)) {
 			gru_try_dropin(gru, gts, tfh, NULL);
-			up_read(&gts->ts_mm->mmap_sem);
+			mm_read_unlock(gts->ts_mm);
 		} else {
 			tfh_user_polling_mode(tfh);
 			STAT(intr_mm_lock_failed);
Index: mmotm-mm-accessor/drivers/misc/sgi-gru/grufile.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/misc/sgi-gru/grufile.c
+++ mmotm-mm-accessor/drivers/misc/sgi-gru/grufile.c
@@ -144,7 +144,7 @@ static int gru_create_new_context(unsign
 	if (!(req.options & GRU_OPT_MISS_MASK))
 		req.options |= GRU_OPT_MISS_FMM_INTR;
 
-	down_write(&current->mm->mmap_sem);
+	mm_write_lock(current->mm);
 	vma = gru_find_vma(req.gseg);
 	if (vma) {
 		vdata = vma->vm_private_data;
@@ -155,7 +155,7 @@ static int gru_create_new_context(unsign
 		vdata->vd_tlb_preload_count = req.tlb_preload_count;
 		ret = 0;
 	}
-	up_write(&current->mm->mmap_sem);
+	mm_write_unlock(current->mm);
 
 	return ret;
 }

