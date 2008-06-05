Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYFEMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYFEMuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYFEMtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:49:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:57978 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757402AbYFEMtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:49:51 -0400
Date: Thu, 5 Jun 2008 14:49:50 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 2/2] quota: Convert macros to inline functions
Message-ID: <20080605124950.GB21026@duck.suse.cz>
References: <20080605124226.GF27370@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605124226.GF27370@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quota.h    |    5 +++-
 include/linux/quotaops.h |   65 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index f9983ea..4e004fe 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -223,7 +223,10 @@ struct super_block;
 #define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
 
 extern void mark_info_dirty(struct super_block *sb, int type);
-#define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
+static inline int info_dirty(struct mem_dqinfo *info)
+{
+	return test_bit(DQF_INFO_DIRTY_B, &info->dqi_flags);
+}
 
 struct dqstats {
 	int lookups;
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 7fc1743..5644280 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -52,25 +52,45 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
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
 
 /*
  * Functions for checking status of quota
  */
 
-#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
-	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+}
 
-#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
-				  sb_has_quota_enabled(sb, GRPQUOTA))
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return sb_has_quota_enabled(sb, USRQUOTA) ||
+		sb_has_quota_enabled(sb, GRPQUOTA);
+}
 
-#define sb_has_quota_suspended(sb, type) \
-	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
-			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	if (type == USRQUOTA)
+		return sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED;
+	return sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED;
+}
 
-#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
-				  sb_has_quota_suspended(sb, GRPQUOTA))
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return sb_has_quota_suspended(sb, USRQUOTA) ||
+		sb_has_quota_suspended(sb, GRPQUOTA);
+}
 
 /*
  * Operations supported for diskquotas.
@@ -179,10 +199,25 @@ static inline int vfs_dq_off(struct super_block *sb, int remount)
 
 #else
 
-#define sb_has_quota_enabled(sb, type) 0
-#define sb_any_quota_enabled(sb) 0
-#define sb_has_quota_suspended(sb, type) 0
-#define sb_any_quota_suspended(sb) 0
+static inline int sb_has_quota_enabled(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_enabled(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+{
+	return 0;
+}
+
+static inline int sb_any_quota_suspended(struct super_block *sb)
+{
+	return 0;
+}
 
 /*
  * NO-OP when quota not configured.
-- 
1.5.2.4

