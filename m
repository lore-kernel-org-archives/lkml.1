Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZCXPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZCXPoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZCXPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:44:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:56339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbZCXPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:44:00 -0400
Date: Tue, 24 Mar 2009 15:43:03 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       adobriyan@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <1237906803.25315.96.camel@penberg-laptop>
References: <1237906803.25315.96.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] kmemtrace, fs, security: move alloc_secdata() and free_secdata() linux/security.h
Message-ID: <tip-f3edf88c0f4cd0ef90b6dd18953fb8ca6842d5a8@git.kernel.org>
Git-Commit-ID: f3edf88c0f4cd0ef90b6dd18953fb8ca6842d5a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 15:43:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3edf88c0f4cd0ef90b6dd18953fb8ca6842d5a8
Gitweb:     http://git.kernel.org/tip/f3edf88c0f4cd0ef90b6dd18953fb8ca6842d5a8
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 17:00:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 16:39:13 +0100

kmemtrace, fs, security: move alloc_secdata() and free_secdata() linux/security.h

Impact: cleanup

As suggested by Alexey Dobriyan, move alloc_secdata() and free_secdata()
to linux/security.h and make them static inlines again.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237906803.25315.96.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
