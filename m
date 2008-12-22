Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYLVWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYLVWBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbYLVVtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:49 -0500
Received: from mail.suse.de ([195.135.220.2]:41691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbYLVVts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:48 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 34/56] ocfs2: Fix build warnings (64-bit types vs long long)
Date: Mon, 22 Dec 2008 13:48:15 -0800
Message-Id: <1229982517-3455-35-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

fs/ocfs2/quota_local.c: In function 'olq_set_dquot':
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_global.c: In function '__ocfs2_sync_dquot':
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |    6 +++---
 fs/ocfs2/quota_local.c  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 27a8123..b0eae79 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -455,9 +455,9 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
 	olditime = dquot->dq_dqb.dqb_itime;
 	oldbtime = dquot->dq_dqb.dqb_btime;
 	ocfs2_global_disk2memdqb(dquot, &dqblk);
-	mlog(0, "Syncing global dquot %d space %lld+%lld, inodes %lld+%lld\n",
-	     dquot->dq_id, dquot->dq_dqb.dqb_curspace, spacechange,
-	     dquot->dq_dqb.dqb_curinodes, inodechange);
+	mlog(0, "Syncing global dquot %u space %lld+%lld, inodes %lld+%lld\n",
+	     dquot->dq_id, dquot->dq_dqb.dqb_curspace, (long long)spacechange,
+	     dquot->dq_dqb.dqb_curinodes, (long long)inodechange);
 	if (!test_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags))
 		dquot->dq_dqb.dqb_curspace += spacechange;
 	if (!test_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags))
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c008dd9..9b22643 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -848,7 +848,8 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
 					  od->dq_originodes);
 	spin_unlock(&dq_data_lock);
 	mlog(0, "Writing local dquot %u space %lld inodes %lld\n",
-	     od->dq_dquot.dq_id, dqblk->dqb_spacemod, dqblk->dqb_inodemod);
+	     od->dq_dquot.dq_id, (long long)le64_to_cpu(dqblk->dqb_spacemod),
+	     (long long)le64_to_cpu(dqblk->dqb_inodemod));
 }
 
 /* Write dquot to local quota file */
-- 
1.5.6

