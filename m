Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbXJAFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbXJAFzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXJAFvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40753 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbXJAFv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:26 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 09/19] Unionfs: use pr_debug() instead of custom dprintk()
Date: Mon,  1 Oct 2007 01:50:46 -0400
Message-Id: <11912178601007-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also turn on DEBUG if CONFIG_UNION_FS_DEBUG is on

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/Makefile     |    4 ++++
 fs/unionfs/commonfops.c |    4 ++--
 fs/unionfs/dentry.c     |    6 +++---
 fs/unionfs/lookup.c     |    2 +-
 fs/unionfs/union.h      |    6 +-----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/Makefile b/fs/unionfs/Makefile
index 38fed90..17ca4a7 100644
--- a/fs/unionfs/Makefile
+++ b/fs/unionfs/Makefile
@@ -7,3 +7,7 @@ unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
 unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
 
 unionfs-$(CONFIG_UNION_FS_DEBUG) += debug.o
+
+ifeq ($(CONFIG_UNION_FS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 8550a34..16df572 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -394,8 +394,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
 	    is_robranch(dentry)) {
-		dprintk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
-			dentry->d_name.name);
+		pr_debug("unionfs: do delay copyup of \"%s\"\n",
+			 dentry->d_name.name);
 		err = do_delayed_copyup(file);
 	}
 
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 89f6a91..5dde6af 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -46,9 +46,9 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 
 	/* if the dentry is unhashed, do NOT revalidate */
 	if (d_deleted(dentry)) {
-		dprintk(KERN_DEBUG "unionfs: unhashed dentry being "
-			"revalidated: %*s\n",
-			dentry->d_name.len, dentry->d_name.name);
+		pr_debug("unionfs: unhashed dentry being "
+			 "revalidated: %*s\n",
+			 dentry->d_name.len, dentry->d_name.name);
 		goto out;
 	}
 
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 53668d6..9c6fd56 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -629,7 +629,7 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		 * We should never get here, for now.
 		 * We can add new cases here later on.
 		 */
-		dprintk("unionfs: unknown nameidata flag 0x%x\n", flags);
+		pr_debug("unionfs: unknown nameidata flag 0x%x\n", flags);
 		BUG();
 		break;
 	}
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 91f7f1e..4e3cb53 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -508,10 +508,8 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 
 #ifdef CONFIG_UNION_FS_DEBUG
 
-#define dprintk(args...)		printk(args)
-
 /* useful for tracking code reachability */
-#define UDBG printk("DBG:%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)
+#define UDBG pr_debug("DBG:%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)
 
 #define unionfs_check_inode(i)	__unionfs_check_inode((i),	\
 	__FILE__,__FUNCTION__,__LINE__)
@@ -550,8 +548,6 @@ extern void __show_inode_counts(const struct inode *inode,
 
 #else /* not CONFIG_UNION_FS_DEBUG */
 
-#define dprintk(args...)		do { } while (0)
-
 /* we leave useful hooks for these check functions throughout the code */
 #define unionfs_check_inode(i)		do { } while(0)
 #define unionfs_check_dentry(d)		do { } while(0)
-- 
1.5.2.2

