Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYFEMsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYFEMsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbYFEMsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:48:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:57919 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757280AbYFEMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:48:44 -0400
Date: Thu, 5 Jun 2008 14:48:42 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 1/2] quota: Move function-macros from quota.h to quotaops.h
Message-ID: <20080605124842.GA21026@duck.suse.cz>
References: <20080605124226.GF27370@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605124226.GF27370@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move declarations of some macros, which should be in fact functions
to quotaops.h. This way they can be later converted to inline functions
because we can now use declarations from quota.h. Also add necessary
includes of quotaops.h to a few files.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c          |    1 +
 fs/quota_v1.c            |    1 +
 fs/quota_v2.c            |    1 +
 include/linux/quota.h    |   22 +++-------------------
 include/linux/quotaops.h |   25 +++++++++++++++++++++++++
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index ef50cbc..31308a3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -31,6 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/log2.h>
+#include <linux/quotaops.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
diff --git a/fs/quota_v1.c b/fs/quota_v1.c
index a6cf926..5ae15b1 100644
--- a/fs/quota_v1.c
+++ b/fs/quota_v1.c
@@ -1,6 +1,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/quota.h>
+#include <linux/quotaops.h>
 #include <linux/dqblk_v1.h>
 #include <linux/quotaio_v1.h>
 #include <linux/kernel.h>
diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index 234ada9..b53827d 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/quotaops.h>
 
 #include <asm/byteorder.h>
 
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6f1d97d..f9983ea 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -41,9 +41,6 @@
 #define __DQUOT_VERSION__	"dquot_6.5.1"
 #define __DQUOT_NUM_VERSION__	6*10000+5*100+1
 
-typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -172,6 +169,9 @@ enum {
 
 #include <asm/atomic.h>
 
+typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
+typedef __u64 qsize_t;          /* Type in which we store sizes */
+
 extern spinlock_t dq_data_lock;
 
 /* Maximal numbers of writes for quota operation (insert/delete/update)
@@ -225,9 +225,6 @@ struct super_block;
 extern void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
-#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
-
 struct dqstats {
 	int lookups;
 	int drops;
@@ -335,19 +332,6 @@ struct quota_info {
 	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
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
-
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 0c8f9fe..7fc1743 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -52,6 +52,26 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
+#define sb_dqopt(sb) (&(sb)->s_dquot)
+#define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
+
+/*
+ * Functions for checking status of quota
+ */
+
+#define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
+	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
+
+#define sb_any_quota_enabled(sb) (sb_has_quota_enabled(sb, USRQUOTA) | \
+				  sb_has_quota_enabled(sb, GRPQUOTA))
+
+#define sb_has_quota_suspended(sb, type) \
+	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
+			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
+
+#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
+				  sb_has_quota_suspended(sb, GRPQUOTA))
+
 /*
  * Operations supported for diskquotas.
  */
@@ -159,6 +179,11 @@ static inline int vfs_dq_off(struct super_block *sb, int remount)
 
 #else
 
+#define sb_has_quota_enabled(sb, type) 0
+#define sb_any_quota_enabled(sb) 0
+#define sb_has_quota_suspended(sb, type) 0
+#define sb_any_quota_suspended(sb) 0
+
 /*
  * NO-OP when quota not configured.
  */
-- 
1.5.2.4

