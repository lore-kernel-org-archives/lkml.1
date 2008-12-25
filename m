Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYLYSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYLYSO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYLYSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYLYSFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:39 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 26/35] ocfs2/dlm: Clean up errors in dlm_proxy_ast_handler()
Date: Thu, 25 Dec 2008 10:04:41 -0800
Message-Id: <1230228290-22803-27-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

Patch cleans printed errors in dlm_proxy_ast_handler(). The errors now includes
the node number that sent the (b)ast. Also it reduces the number of endian swaps
of the cookie.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmast.c |   52 +++++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 644bee5..d07ddbe 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -275,6 +275,7 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct list_head *iter, *head=NULL;
 	u64 cookie;
 	u32 flags;
+	u8 node;
 
 	if (!dlm_grab(dlm)) {
 		dlm_error(DLM_REJECTED);
@@ -286,18 +287,21 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	name = past->name;
 	locklen = past->namelen;
-	cookie = be64_to_cpu(past->cookie);
+	cookie = past->cookie;
 	flags = be32_to_cpu(past->flags);
+	node = past->node_idx;
 
 	if (locklen > DLM_LOCKID_NAME_MAX) {
 		ret = DLM_IVBUFLEN;
-		mlog(ML_ERROR, "Invalid name length in proxy ast handler!\n");
+		mlog(ML_ERROR, "Invalid name length (%d) in proxy ast "
+		     "handler!\n", locklen);
 		goto leave;
 	}
 
 	if ((flags & (LKM_PUT_LVB|LKM_GET_LVB)) ==
 	     (LKM_PUT_LVB|LKM_GET_LVB)) {
-		mlog(ML_ERROR, "both PUT and GET lvb specified\n");
+		mlog(ML_ERROR, "Both PUT and GET lvb specified, (0x%x)\n",
+		     flags);
 		ret = DLM_BADARGS;
 		goto leave;
 	}
@@ -310,22 +314,21 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	if (past->type != DLM_AST &&
 	    past->type != DLM_BAST) {
 		mlog(ML_ERROR, "Unknown ast type! %d, cookie=%u:%llu"
-		     "name=%.*s\n", past->type, 
-		     dlm_get_lock_cookie_node(cookie),
-		     dlm_get_lock_cookie_seq(cookie),
-		     locklen, name);
+		     "name=%.*s, node=%u\n", past->type,
+		     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
+		     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+		     locklen, name, node);
 		ret = DLM_IVLOCKID;
 		goto leave;
 	}
 
 	res = dlm_lookup_lockres(dlm, name, locklen);
 	if (!res) {
-		mlog(0, "got %sast for unknown lockres! "
-		     "cookie=%u:%llu, name=%.*s, namelen=%u\n",
-		     past->type == DLM_AST ? "" : "b",
-		     dlm_get_lock_cookie_node(cookie),
-		     dlm_get_lock_cookie_seq(cookie),
-		     locklen, name, locklen);
+		mlog(0, "Got %sast for unknown lockres! cookie=%u:%llu, "
+		     "name=%.*s, node=%u\n", (past->type == DLM_AST ? "" : "b"),
+		     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
+		     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+		     locklen, name, node);
 		ret = DLM_IVLOCKID;
 		goto leave;
 	}
@@ -337,12 +340,12 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	spin_lock(&res->spinlock);
 	if (res->state & DLM_LOCK_RES_RECOVERING) {
-		mlog(0, "responding with DLM_RECOVERING!\n");
+		mlog(0, "Responding with DLM_RECOVERING!\n");
 		ret = DLM_RECOVERING;
 		goto unlock_out;
 	}
 	if (res->state & DLM_LOCK_RES_MIGRATING) {
-		mlog(0, "responding with DLM_MIGRATING!\n");
+		mlog(0, "Responding with DLM_MIGRATING!\n");
 		ret = DLM_MIGRATING;
 		goto unlock_out;
 	}
@@ -351,7 +354,7 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	lock = NULL;
 	list_for_each(iter, head) {
 		lock = list_entry (iter, struct dlm_lock, list);
-		if (be64_to_cpu(lock->ml.cookie) == cookie)
+		if (lock->ml.cookie == cookie)
 			goto do_ast;
 	}
 
@@ -363,15 +366,15 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	list_for_each(iter, head) {
 		lock = list_entry (iter, struct dlm_lock, list);
-		if (be64_to_cpu(lock->ml.cookie) == cookie)
+		if (lock->ml.cookie == cookie)
 			goto do_ast;
 	}
 
-	mlog(0, "got %sast for unknown lock!  cookie=%u:%llu, "
-	     "name=%.*s, namelen=%u\n", past->type == DLM_AST ? "" : "b", 
-	     dlm_get_lock_cookie_node(cookie),
-	     dlm_get_lock_cookie_seq(cookie),
-	     locklen, name, locklen);
+	mlog(0, "Got %sast for unknown lock! cookie=%u:%llu, name=%.*s, "
+	     "node=%u\n", past->type == DLM_AST ? "" : "b",
+	     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
+	     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+	     locklen, name, node);
 
 	ret = DLM_NORMAL;
 unlock_out:
@@ -383,8 +386,8 @@ do_ast:
 	if (past->type == DLM_AST) {
 		/* do not alter lock refcount.  switching lists. */
 		list_move_tail(&lock->list, &res->granted);
-		mlog(0, "ast: adding to granted list... type=%d, "
-			  "convert_type=%d\n", lock->ml.type, lock->ml.convert_type);
+		mlog(0, "ast: Adding to granted list... type=%d, "
+		     "convert_type=%d\n", lock->ml.type, lock->ml.convert_type);
 		if (lock->ml.convert_type != LKM_IVMODE) {
 			lock->ml.type = lock->ml.convert_type;
 			lock->ml.convert_type = LKM_IVMODE;
@@ -408,7 +411,6 @@ do_ast:
 		dlm_do_local_bast(dlm, res, lock, past->blocked_type);
 
 leave:
-
 	if (res)
 		dlm_lockres_put(res);
 
-- 
1.5.6

