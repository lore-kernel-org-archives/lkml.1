Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZFHRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZFHRWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZFHRUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:22 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57154 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753662AbZFHRUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:21 -0400
Message-Id: <20090608172016.208698000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:57 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 09/12] GRU - fix potential use-after-free when purging GRU tlbs
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_flush_tlb_fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix potential SGI GRU bug that could cause a use-after-free. If one
thread in a task is flushing the GRU and another thread destroys the GRU context,
there is the potential to access a table after it has been freed.

Copy the gms pointer to a local variable before unlocking the gts table.
Note that no refcnt is needed for the gms - the reference is held indirectly
by the task's mm_struct.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-06-05 15:33:05.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-06-05 15:33:05.000000000 -0500
@@ -706,6 +706,7 @@ int gru_user_flush_tlb(unsigned long arg
 {
 	struct gru_thread_state *gts;
 	struct gru_flush_tlb_req req;
+	struct gru_mm_struct *gms;
 
 	STAT(user_flush_tlb);
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
@@ -718,8 +719,9 @@ int gru_user_flush_tlb(unsigned long arg
 	if (!gts)
 		return -EINVAL;
 
-	gru_flush_tlb_range(gts->ts_gms, req.vaddr, req.len);
+	gms = gts->ts_gms;
 	gru_unlock_gts(gts);
+	gru_flush_tlb_range(gms, req.vaddr, req.len);
 
 	return 0;
 }

