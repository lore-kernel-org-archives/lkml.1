Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZCSFdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZCSFdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZCSFdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:33:04 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:39062 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZCSFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:33:03 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #3 1/2] replace /sys/fs/aufs/debug by /sys/module/aufs/parmaters/debug
Date: Thu, 19 Mar 2009 14:12:44 +0900
Message-Id: <1237439565-25039-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comments from Greg KH on LKML.
- remove the global variable 'au_cond'.
- new global variable 'aufs_debug' as a module parameter.
- describe the new module parameter 'debug' in the manual.
- remove the global variable 'sysaufs_ktype', debug_show(),
  debug_store(), au_debug_attr, au_attr_show(), au_attr_store(), and
  sysaufs_ktype_body.
- make au_attr empty.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/aufs.5 |    8 ++++
 fs/aufs/debug.c                       |    4 +-
 fs/aufs/debug.h                       |   12 ++---
 fs/aufs/sysaufs.h                     |    2 -
 fs/aufs/sysfs.c                       |   73 ---------------------------------
 5 files changed, 16 insertions(+), 83 deletions(-)

diff --git a/Documentation/filesystems/aufs/aufs.5 b/Documentation/filesystems/aufs/aufs.5
index 0b485ea..b3bca05 100644
--- a/Documentation/filesystems/aufs/aufs.5
+++ b/Documentation/filesystems/aufs/aufs.5
@@ -361,6 +361,14 @@ If your linux version is linux\-2.6.24 and earlier, you need to enable
 CONFIG_AUFS_SYSAUFS too.
 Currently this is for developers only.
 The default is \[oq]a\[cq].
+.
+.TP
+.B debug= 0 | 1
+Specifies disable(0) or enable(1) debug print in aufs.
+This parameter can be changed dynamically.
+You need to enable CONFIG_AUFS_DEBUG.
+Currently this is for developers only.
+The default is \[oq]0\[cq] (disable).
 
 .\" ----------------------------------------------------------------------
 .SH Branch Syntax
diff --git a/fs/aufs/debug.c b/fs/aufs/debug.c
index e8bc59c..63ec24f 100644
--- a/fs/aufs/debug.c
+++ b/fs/aufs/debug.c
@@ -13,7 +13,9 @@
 
 #include "aufs.h"
 
-atomic_t au_cond = ATOMIC_INIT(0);
+int aufs_debug;
+MODULE_PARM_DESC(debug, "debug print");
+module_param_named(debug, aufs_debug, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
 char *au_plevel = KERN_DEBUG;
 #define dpri(fmt, arg...) do { \
diff --git a/fs/aufs/debug.h b/fs/aufs/debug.h
index 0b377a8..36ff0ea 100644
--- a/fs/aufs/debug.h
+++ b/fs/aufs/debug.h
@@ -25,20 +25,18 @@
 
 #ifdef CONFIG_AUFS_DEBUG
 #define AuDebugOn(a)		BUG_ON(a)
-extern atomic_t au_cond;
+
+/* module parameter */
+extern int aufs_debug;
 static inline void au_debug(int n)
 {
-	atomic_set(&au_cond, n);
+	aufs_debug = n;
 	smp_mb();
 }
 
 static inline int au_debug_test(void)
 {
-	int ret;
-
-	ret = atomic_read(&au_cond);
-	smp_mb();
-	return ret;
+	return aufs_debug;
 }
 #else
 #define AuDebugOn(a)		do {} while (0)
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
index 04ffab2..60b18a8 100644
--- a/fs/aufs/sysaufs.h
+++ b/fs/aufs/sysaufs.h
@@ -47,7 +47,6 @@ struct au_branch;
 #ifdef CONFIG_SYSFS
 /* sysfs.c */
 extern struct attribute_group *sysaufs_attr_group;
-extern struct kobj_type *sysaufs_ktype;
 
 int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb);
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
@@ -61,7 +60,6 @@ void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex);
 
 #else
 #define sysaufs_attr_group	NULL
-#define sysaufs_ktype		NULL
 
 static inline
 int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb)
diff --git a/fs/aufs/sysfs.c b/fs/aufs/sysfs.c
index b03c2f7..2112f3b 100644
--- a/fs/aufs/sysfs.c
+++ b/fs/aufs/sysfs.c
@@ -16,36 +16,7 @@
 #include <linux/sysfs.h>
 #include "aufs.h"
 
-#ifdef CONFIG_AUFS_DEBUG
-static ssize_t debug_show(struct kobject *kobj __maybe_unused,
-			  struct kobj_attribute *attr __maybe_unused,
-			  char *buf)
-{
-	return sprintf(buf, "%d\n", au_debug_test());
-}
-
-static ssize_t debug_store(struct kobject *kobj __maybe_unused,
-			   struct kobj_attribute *attr __maybe_unused,
-			   const char *buf, size_t sz)
-{
-	if (unlikely(!sz || (*buf != '0' && *buf != '1')))
-		return -EOPNOTSUPP;
-
-	if (*buf == '0')
-		au_debug(0);
-	else if (*buf == '1')
-		au_debug(1);
-	return sz;
-}
-
-static struct kobj_attribute au_debug_attr = __ATTR(debug, S_IRUGO | S_IWUSR,
-						    debug_show, debug_store);
-#endif
-
 static struct attribute *au_attr[] = {
-#ifdef CONFIG_AUFS_DEBUG
-	&au_debug_attr.attr,
-#endif
 	NULL,	/* need to NULL terminate the list of attributes */
 };
 
@@ -57,50 +28,6 @@ struct attribute_group *sysaufs_attr_group = &sysaufs_attr_group_body;
 
 /* ---------------------------------------------------------------------- */
 
-/*
- * they are copied from linux/lib/kobject.c,
- * and will be exported in the future.
- */
-static ssize_t au_attr_show(struct kobject *kobj, struct attribute *attr,
-			    char *buf)
-{
-	struct kobj_attribute *kattr;
-	ssize_t ret = -EIO;
-
-	kattr = container_of(attr, struct kobj_attribute, attr);
-	if (kattr->show)
-		ret = kattr->show(kobj, kattr, buf);
-	return ret;
-}
-
-#ifdef CONFIG_AUFS_DEBUG
-static ssize_t au_attr_store(struct kobject *kobj, struct attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct kobj_attribute *kattr;
-	ssize_t ret = -EIO;
-
-	kattr = container_of(attr, struct kobj_attribute, attr);
-	if (kattr->store)
-		ret = kattr->store(kobj, kattr, buf, count);
-	return ret;
-}
-#endif
-
-static struct sysfs_ops sysaufs_ops = {
-	.show   = au_attr_show,
-#ifdef CONFIG_AUFS_DEBUG
-	.store  = au_attr_store
-#endif
-};
-
-static struct kobj_type sysaufs_ktype_body = {
-	.sysfs_ops = &sysaufs_ops
-};
-struct kobj_type *sysaufs_ktype = &sysaufs_ktype_body;
-
-/* ---------------------------------------------------------------------- */
-
 static int sysaufs_sbi_xi(struct seq_file *seq, struct file *xf,
 			  struct kstat *st)
 {
-- 
1.6.1.284.g5dc13

