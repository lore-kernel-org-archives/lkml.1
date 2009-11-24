Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbZKXPH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbZKXPH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933269AbZKXPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:55 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933252AbZKXPHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:48 -0500
Message-Id: <20091124150754.279614000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:11 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 14/29] GRU - Check for valid vma
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_alloc_gts_check_vma
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix bug caused by failure to allocate a GRU gts structure. The
old code failed to handle the case where the vma was invalid.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:31.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:33.000000000 -0600
@@ -90,19 +90,22 @@ static struct gru_thread_state *gru_allo
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct gru_thread_state *gts = NULL;
+	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
 	down_write(&mm->mmap_sem);
 	vma = gru_find_vma(vaddr);
-	if (vma)
-		gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
-	if (!IS_ERR(gts)) {
-		mutex_lock(&gts->ts_ctxlock);
-		downgrade_write(&mm->mmap_sem);
-	} else {
-		up_write(&mm->mmap_sem);
-	}
+	if (!vma)
+		goto err;
 
+	gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
+	if (IS_ERR(gts))
+		goto err;
+	mutex_lock(&gts->ts_ctxlock);
+	downgrade_write(&mm->mmap_sem);
+	return gts;
+
+err:
+	up_write(&mm->mmap_sem);
 	return gts;
 }
 

