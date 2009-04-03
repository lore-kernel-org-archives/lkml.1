Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbZDCKgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbZDCKgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763425AbZDCKgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:36:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761770AbZDCKgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:36:07 -0400
Date: Fri, 3 Apr 2009 10:34:10 GMT
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
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, fs, security: move alloc_secdata() and free_secdata() to linux/security.h
Message-ID: <tip-3d544f411f2971eb82f5c52322251eb04494542a@git.kernel.org>
Git-Commit-ID: 3d544f411f2971eb82f5c52322251eb04494542a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:34:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d544f411f2971eb82f5c52322251eb04494542a
Gitweb:     http://git.kernel.org/tip/3d544f411f2971eb82f5c52322251eb04494542a
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 11:59:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:08:57 +0200

kmemtrace, fs, security: move alloc_secdata() and free_secdata() to linux/security.h

Impact: cleanup

We want to remove percpu.h from rcupdate.h (for upcoming kmemtrace
changes), but this is not possible currently without breaking the
build because fs.h has implicit include file depedencies: it uses
GFP_* types in inlines but does not include gfp.h.

In practice most fs.h using .c files get gfp.h included implicitly,
via an indirect route: via rcupdate.h inclusion - so this underlying
problem gets masked in practice.

So we want to solve fs.h's dependency on gfp.h.

gfp.h can not be included here directly because it is not exported and it
would break the build the following way:

  /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
  /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
  make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
  make[2]: *** [linux] Error 2

As suggested by Alexey Dobriyan, move alloc_secdata() and free_secdata()
to linux/security.h - they belong there. This also cleans fs.h of GFP_*
usage.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237906803.25315.96.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/fs.h       |   21 ---------------------
 include/linux/security.h |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 61211ad..fc4dc28 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2382,27 +2382,6 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
 
-
-#ifdef CONFIG_SECURITY
-static inline char *alloc_secdata(void)
-{
-	return (char *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void free_secdata(void *secdata)
-{
-	free_page((unsigned long)secdata);
-}
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
index 54ed157..d5fd616 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/key.h>
 #include <linux/xfrm.h>
+#include <linux/gfp.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
@@ -2953,5 +2954,28 @@ static inline void securityfs_remove(struct dentry *dentry)
 
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
 
