Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZCXPAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZCXPAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZCXPAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:00:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47362 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZCXPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:00:07 -0400
Subject: [PATCH] kmemtrace: move alloc_secdata() and free_secdata()
	linux/security.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: adobriyan@gmail.com, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 17:00:03 +0200
Message-Id: <1237906803.25315.96.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

As suggested by Alexey Dobriyan, move alloc_secdata() and free_secdata() to
linux/security.h and make them static inlines again.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/fs.h       |   18 ------------------
 include/linux/security.h |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11fdc57..159f7b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2230,24 +2230,6 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
 
-
-#ifdef CONFIG_SECURITY
-/*
- * These need to be macros because we cannot include <linux/gfp.h> in this
- * header file.
- */
-#define alloc_secdata()       (char *)get_zeroed_page(GFP_KERNEL)
-#define free_secdata(secdata) free_page((unsigned long) secdata)
-#else
-static inline char *alloc_secdata(void)
-{
-	return (char *)1;
-}
-
-static inline void free_secdata(void *secdata)
-{ }
-#endif	/* CONFIG_SECURITY */
-
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
diff --git a/include/linux/security.h b/include/linux/security.h
index 1f2ab63..e3e2f8a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/key.h>
 #include <linux/xfrm.h>
+#include <linux/gfp.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
@@ -2966,5 +2967,28 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
+#ifdef CONFIG_SECURITY
+
+static inline char *alloc_secdata(void)
+{
+	return (char *)get_zeroed_page(GFP_KERNEL);
+}
+
+static inline void free_secdata(void *secdata)
+{
+	free_page((unsigned long)secdata);
+}
+
+#else
+
+static inline char *alloc_secdata(void)
+{
+        return (char *)1;
+}
+
+static inline void free_secdata(void *secdata)
+{ }
+#endif /* CONFIG_SECURITY */
+
 #endif /* ! __LINUX_SECURITY_H */
 
-- 
1.5.4.3



