Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZCQWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZCQWlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCQWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:41:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:35360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZCQWlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:41:08 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 25/32] ocfs2/dlm: dlm_set_lockres_owner() and dlm_change_lockres_owner() inlined
Date: Tue, 17 Mar 2009 13:01:15 -0700
Message-Id: <1237320082-12921-26-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch inlines dlm_set_lockres_owner() and dlm_change_lockres_owner().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   21 ++++++++++++++++++---
 fs/ocfs2/dlm/dlmmaster.c |   19 -------------------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e5026ce..266fde9 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -858,9 +858,7 @@ struct dlm_lock_resource * dlm_lookup_lockres(struct dlm_ctxt *dlm,
 					      unsigned int len);
 
 int dlm_is_host_down(int errno);
-void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
-			      struct dlm_lock_resource *res,
-			      u8 owner);
+
 struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
 						 const char *lockid,
 						 int namelen,
@@ -1123,6 +1121,23 @@ static inline int dlm_node_iter_next(struct dlm_node_iter *iter)
 	return bit;
 }
 
+static inline void dlm_set_lockres_owner(struct dlm_ctxt *dlm,
+					 struct dlm_lock_resource *res,
+					 u8 owner)
+{
+	assert_spin_locked(&res->spinlock);
+
+	res->owner = owner;
+}
 
+static inline void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
+					    struct dlm_lock_resource *res,
+					    u8 owner)
+{
+	assert_spin_locked(&res->spinlock);
+
+	if (owner != res->owner)
+		dlm_set_lockres_owner(dlm, res, owner);
+}
 
 #endif /* DLMCOMMON_H */
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index d70cdd5..d9c5c5a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -511,25 +511,6 @@ void dlm_destroy_master_caches(void)
 		kmem_cache_destroy(dlm_lockres_cache);
 }
 
-static void dlm_set_lockres_owner(struct dlm_ctxt *dlm,
-				  struct dlm_lock_resource *res,
-				  u8 owner)
-{
-	assert_spin_locked(&res->spinlock);
-
-	res->owner = owner;
-}
-
-void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
-			      struct dlm_lock_resource *res, u8 owner)
-{
-	assert_spin_locked(&res->spinlock);
-
-	if (owner != res->owner)
-		dlm_set_lockres_owner(dlm, res, owner);
-}
-
-
 static void dlm_lockres_release(struct kref *kref)
 {
 	struct dlm_lock_resource *res;
-- 
1.5.6

