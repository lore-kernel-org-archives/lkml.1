Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbYLWQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbYLWQQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYLWQNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48933 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYLWQNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/10] dlm: fs/dlm/ast.c: fix warning
Date: Tue, 23 Dec 2008 10:58:43 -0600
Message-Id: <1230051523-5478-11-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

fs/dlm/ast.c: In function 'dlm_astd':
fs/dlm/ast.c:64: warning: 'bastmode' may be used uninitialized in this function

Cleans code up.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index fbe840d..dc2ad60 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -61,30 +61,23 @@ static void process_asts(void)
 	struct dlm_lkb *lkb;
 	void (*cast) (void *astparam);
 	void (*bast) (void *astparam, int mode);
-	int type = 0, found, bastmode;
-
-	for (;;) {
-		found = 0;
-		spin_lock(&ast_queue_lock);
-		list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
-			r = lkb->lkb_resource;
-			ls = r->res_ls;
-
-			if (dlm_locking_stopped(ls))
-				continue;
-
-			list_del(&lkb->lkb_astqueue);
-			type = lkb->lkb_ast_type;
-			lkb->lkb_ast_type = 0;
-			bastmode = lkb->lkb_bastmode;
-			found = 1;
-			break;
-		}
-		spin_unlock(&ast_queue_lock);
+	int type = 0, bastmode;
+
+repeat:
+	spin_lock(&ast_queue_lock);
+	list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
+		r = lkb->lkb_resource;
+		ls = r->res_ls;
 
-		if (!found)
-			break;
+		if (dlm_locking_stopped(ls))
+			continue;
 
+		list_del(&lkb->lkb_astqueue);
+		type = lkb->lkb_ast_type;
+		lkb->lkb_ast_type = 0;
+		bastmode = lkb->lkb_bastmode;
+
+		spin_unlock(&ast_queue_lock);
 		cast = lkb->lkb_astfn;
 		bast = lkb->lkb_bastfn;
 
@@ -99,7 +92,9 @@ static void process_asts(void)
 		dlm_put_lkb(lkb);
 
 		cond_resched();
+		goto repeat;
 	}
+	spin_unlock(&ast_queue_lock);
 }
 
 static inline int no_asts(void)
-- 
1.5.5.1

