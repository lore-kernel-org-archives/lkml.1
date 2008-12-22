Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYLVVuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYLVVuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbYLVVsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:41550 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYLVVst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:49 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 04/56] quota: Make _SUSPENDED just a flag
Date: Mon, 22 Dec 2008 13:47:45 -0800
Message-Id: <1229982517-3455-5-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Upto now, DQUOT_USR_SUSPENDED behaved like a state - i.e., either quota
was enabled or suspended or none. Now allowed states are 0, ENABLED,
ENABLED | SUSPENDED. This will be useful later when we implement separate
enabling of quota usage tracking and limits enforcement because we need to
keep track of a state which has been suspended.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c               |   10 ++++++----
 include/linux/quotaops.h |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 735e2c3..1f9f1f1 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1570,18 +1570,20 @@ static inline void reset_enable_flags(struct quota_info *dqopt, int type,
 {
 	switch (type) {
 		case USRQUOTA:
-			dqopt->flags &= ~DQUOT_USR_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_USR_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_USR_ENABLED;
 				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
+			}
 			break;
 		case GRPQUOTA:
-			dqopt->flags &= ~DQUOT_GRP_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_GRP_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_GRP_ENABLED;
 				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
+			}
 			break;
 	}
 }
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index adcc7ba..ffd9707 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -67,8 +67,10 @@ static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 static inline int sb_has_quota_enabled(struct super_block *sb, int type)
 {
 	if (type == USRQUOTA)
-		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
-	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+		return (sb_dqopt(sb)->flags & DQUOT_USR_ENABLED)
+			&& !(sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED);
+	return (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED)
+		&& !(sb_dqopt(sb)->flags & DQUOT_GROUP_SUSPENDED);
 }
 
 static inline int sb_any_quota_enabled(struct super_block *sb)
-- 
1.5.6

