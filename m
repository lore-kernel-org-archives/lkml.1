Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbYEUDdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbYEUDdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbYEUDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:32:54 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44070 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYEUDcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:53 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 39/39] merge aufs
Date: Wed, 21 May 2008 12:23:09 +0900
Message-Id: <1211340189-11813-40-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

- incorporate fs/aufs
- export __lookup_hash()
- make lockdep deeper for debugging locks in a stackble fs

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/Kconfig              |    2 ++
 fs/Makefile             |    1 +
 fs/namei.c              |    2 +-
 include/linux/lockdep.h |    4 ++++
 include/linux/namei.h   |    1 +
 5 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 9178d9f..19550b5 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1074,6 +1074,8 @@ config UNION_FS_DEBUG
 	help
 	  If you say Y here, you can turn on debugging output from Unionfs.
 
+source "fs/aufs/Kconfig"
+
 endmenu
 
 menu "Miscellaneous filesystems"
diff --git a/fs/Makefile b/fs/Makefile
index aa676d3..7d80668 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -125,3 +125,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_AUFS)              += aufs/
diff --git a/fs/namei.c b/fs/namei.c
index 8e2292c..2978030 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1296,7 +1296,7 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
 	return err;
 }
 
-static struct dentry *__lookup_hash(struct qstr *name,
+struct dentry *__lookup_hash(struct qstr *name,
 		struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..f5d0642 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -58,7 +58,11 @@ enum lock_usage_bit
 #define LOCKF_USED_IN_IRQ_READ \
 		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
 
+#ifdef CONFIG_AUFS
+#define MAX_LOCKDEP_SUBCLASSES		16UL
+#else
 #define MAX_LOCKDEP_SUBCLASSES		8UL
+#endif
 
 /*
  * Lock-classes are keyed via unique addresses, by embedding the
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 24d88e9..33c7f23 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -74,6 +74,7 @@ extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
+struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd);
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
-- 
1.5.5.1.308.g1fbb5.dirty

