Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYFBRM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYFBRM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYFBRLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:55202 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753649AbYFBRLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Convert macros to inline functions
Date: Mon,  2 Jun 2008 19:11:11 +0200
Message-Id: <12124266723140-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124266721420-git-send-email-jack@suse.cz>
References: y
 <12124266712214-git-send-email-jack@suse.cz>
 <12124266711334-git-send-email-jack@suse.cz>
 <12124266712838-git-send-email-jack@suse.cz>
 <12124266722979-git-send-email-jack@suse.cz>
 <12124266723968-git-send-email-jack@suse.cz>
 <12124266721420-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quota.h |   53 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 841c4ae..04ec8c5 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -125,10 +125,20 @@ extern spinlock_t dq_data_lock;
 #define DQUOT_DEL_REWRITE max(V1_DEL_REWRITE, V2_DEL_REWRITE)
 
 void mark_info_dirty(struct super_block *sb, int type);
-#define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
+static inline int info_dirty(struct mem_dqinfo *info)
+{
+	return test_bit(DQF_INFO_DIRTY_B, &info->dqi_flags);
+}
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
+static inline struct quota_info *sb_dqopt(struct super_block *sb)
+{
+	return &sb->s_dquot;
+}
+
+static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
+{
+	return sb_dqopt(sb)->info + type;
+}
 
 struct dqstats {
 	int lookups;
@@ -146,18 +156,31 @@ extern struct dqstats dqstats;
 #define QUOTA_OK          0
 #define NO_QUOTA          1
 
-#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
-	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
-
-#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
-				  sb_has_quota_enabled(sb, GRPQUOTA))
-
-#define sb_has_quota_suspended(sb, type) \
-	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
-			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
-
-#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
-				  sb_has_quota_suspended(sb, GRPQUOTA))
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+}
+
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return sb_has_quota_enabled(sb, USRQUOTA) ||
+		sb_has_quota_enabled(sb, GRPQUOTA);
+}
+
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED;
+}
+
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return sb_has_quota_suspended(sb, USRQUOTA) ||
+		sb_has_quota_suspended(sb, GRPQUOTA);
+}
 
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
-- 
1.5.2.4

