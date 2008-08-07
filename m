Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYHGMWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYHGMWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHGMV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:21:28 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:17497
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYHGMVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:21:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOB8mkh8qVRH/2dsb2JhbACseA
X-IronPort-AV: E=Sophos;i="4.31,319,1215360000"; 
   d="scan'208";a="351404737"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/4] autofs4 - cleanup autofs mount type usage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Aug 2008 19:40:06 +0800
Message-ID: <20080807114002.4142.30417.stgit@web.messagingengine.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of the AUTOFS_TYPE_* defines is a little confusing and
appears inconsistent.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/autofs_i.h    |    6 ++----
 fs/autofs4/expire.c      |    2 +-
 fs/autofs4/inode.c       |    6 +++---
 fs/autofs4/waitq.c       |    8 ++++----
 include/linux/auto_fs4.h |    5 +++++
 5 files changed, 15 insertions(+), 12 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 69a2f5c..ea024d8 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -21,6 +21,8 @@
 #define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
 #define AUTOFS_IOC_COUNT     32
 
+#define AUTOFS_TYPE_TRIGGER	(AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET)
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -92,10 +94,6 @@ struct autofs_wait_queue {
 
 #define AUTOFS_SBI_MAGIC 0x6d4a556d
 
-#define AUTOFS_TYPE_INDIRECT     0x0001
-#define AUTOFS_TYPE_DIRECT       0x0002
-#define AUTOFS_TYPE_OFFSET       0x0004
-
 struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index cdabb79..e79dd09 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -479,7 +479,7 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	if (sbi->type & AUTOFS_TYPE_DIRECT)
+	if (sbi->type & AUTOFS_TYPE_TRIGGER)
 		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
 	else
 		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 7bb3e5b..9ca2d07 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -288,7 +288,7 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 			*type = AUTOFS_TYPE_DIRECT;
 			break;
 		case Opt_offset:
-			*type = AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET;
+			*type = AUTOFS_TYPE_OFFSET;
 			break;
 		default:
 			return 1;
@@ -336,7 +336,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
-	sbi->type = 0;
+	sbi->type = AUTOFS_TYPE_INDIRECT;
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
 	mutex_init(&sbi->wq_mutex);
@@ -378,7 +378,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	}
 
 	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = sbi->type & AUTOFS_TYPE_DIRECT ?
+	root_inode->i_op = sbi->type & AUTOFS_TYPE_TRIGGER ?
 			&autofs4_direct_root_inode_operations :
 			&autofs4_indirect_root_inode_operations;
 
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 35216d1..6d87bb1 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -337,7 +337,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		 * is very similar for indirect mounts except only dentrys
 		 * in the root of the autofs file system may be negative.
 		 */
-		if (sbi->type & (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET))
+		if (sbi->type & AUTOFS_TYPE_TRIGGER)
 			return -ENOENT;
 		else if (!IS_ROOT(dentry->d_parent))
 			return -ENOENT;
@@ -348,7 +348,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		return -ENOMEM;
 
 	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && (sbi->type & AUTOFS_TYPE_DIRECT))
+	if (IS_ROOT(dentry) && sbi->type & AUTOFS_TYPE_TRIGGER)
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
 		qstr.len = autofs4_getpath(sbi, dentry, &name);
@@ -406,11 +406,11 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 				type = autofs_ptype_expire_multi;
 		} else {
 			if (notify == NFY_MOUNT)
-				type = (sbi->type & AUTOFS_TYPE_DIRECT) ?
+				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
 					autofs_ptype_missing_direct :
 					 autofs_ptype_missing_indirect;
 			else
-				type = (sbi->type & AUTOFS_TYPE_DIRECT) ?
+				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
 					autofs_ptype_expire_direct :
 					autofs_ptype_expire_indirect;
 		}
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index b785c6f..aa96a04 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -29,6 +29,11 @@
 #define AUTOFS_EXP_IMMEDIATE		1
 #define AUTOFS_EXP_LEAVES		2
 
+#define AUTOFS_TYPE_ANY			0x0000
+#define AUTOFS_TYPE_INDIRECT		0x0001
+#define AUTOFS_TYPE_DIRECT		0x0002
+#define AUTOFS_TYPE_OFFSET		0x0004
+
 /* Daemon notification packet types */
 enum autofs_notify {
 	NFY_NONE,
