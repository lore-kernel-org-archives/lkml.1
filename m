Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZCQW7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZCQW7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZCQW7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:59:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:36185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZCQW7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:59:09 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 23/32] ocfs2/dlm: Track number of mles
Date: Tue, 17 Mar 2009 13:01:13 -0700
Message-Id: <1237320082-12921-24-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

The lifetime of a mle is limited to the duration of the lockres mastery
process. While typically this lifetime is fairly short, we have noticed
the number of mles explode under certain circumstances. This patch tracks
the number of each different types of mles and should help us determine
how best to speed up the mastery process.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    5 ++++-
 fs/ocfs2/dlm/dlmdomain.c |    5 +++++
 fs/ocfs2/dlm/dlmmaster.c |    5 +++++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index aa55271..67b3447 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -52,7 +52,8 @@
 enum dlm_mle_type {
 	DLM_MLE_BLOCK,
 	DLM_MLE_MASTER,
-	DLM_MLE_MIGRATION
+	DLM_MLE_MIGRATION,
+	DLM_MLE_NUM_TYPES
 };
 
 struct dlm_lock_name {
@@ -156,6 +157,8 @@ struct dlm_ctxt
 	struct list_head mle_hb_events;
 
 	/* these give a really vague idea of the system load */
+	atomic_t mle_tot_count[DLM_MLE_NUM_TYPES];
+	atomic_t mle_cur_count[DLM_MLE_NUM_TYPES];
 	atomic_t local_resources;
 	atomic_t remote_resources;
 	atomic_t unknown_resources;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 869648c..0479bdf 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1608,6 +1608,11 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	atomic_set(&dlm->remote_resources, 0);
 	atomic_set(&dlm->unknown_resources, 0);
 
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i) {
+		atomic_set(&dlm->mle_tot_count[i], 0);
+		atomic_set(&dlm->mle_cur_count[i], 0);
+	}
+
 	spin_lock_init(&dlm->work_lock);
 	INIT_LIST_HEAD(&dlm->work_list);
 	INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 604552e..acfc928 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -325,6 +325,9 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 		mle->u.mlename.hash = dlm_lockid_hash(name, namelen);
 	}
 
+	atomic_inc(&dlm->mle_tot_count[mle->type]);
+	atomic_inc(&dlm->mle_cur_count[mle->type]);
+
 	/* copy off the node_map and register hb callbacks on our copy */
 	memcpy(mle->node_map, dlm->domain_map, sizeof(mle->node_map));
 	memcpy(mle->vote_map, dlm->domain_map, sizeof(mle->vote_map));
@@ -467,6 +470,8 @@ static void dlm_mle_release(struct kref *kref)
 	/* detach the mle from the domain node up/down events */
 	__dlm_mle_detach_hb_events(dlm, mle);
 
+	atomic_dec(&dlm->mle_cur_count[mle->type]);
+
 	/* NOTE: kfree under spinlock here.
 	 * if this is bad, we can move this to a freelist. */
 	kmem_cache_free(dlm_mle_cache, mle);
-- 
1.5.6

