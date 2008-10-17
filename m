Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYJQMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYJQMvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYJQMuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:50:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbYJQMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pHbyeOBHFFswnHbHJVhAJSrLkz2ET0RwzJ1YT69VXuTpRZzWVEJ72FWJO3AT1KzWB3
         hPTuVPREronqoVzSft0+pIqIu3WALBwAu883hDl+S7fsjBGdFIs/tzVsA4foixlQD4u+
         jptbosOGFMazIL7q2MLacyv7Twi6THZo4kPGw=
Date: Fri, 17 Oct 2008 16:53:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 28/31] proc: move all /proc/kcore stuff to fs/proc/kcore.c
Message-ID: <20081017125320.GC22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 5bfbdb7509742b1fe949c61d61966a3ed418820d Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 14:14:19 +0400
Subject: [PATCH 28/31] proc: move all /proc/kcore stuff to fs/proc/kcore.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/kcore.c         |   14 +++++++++++++-
 fs/proc/proc_misc.c     |    8 --------
 include/linux/proc_fs.h |    4 ----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index c2370c7..59b43a0 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -27,6 +27,8 @@
 #define ELF_CORE_EFLAGS	0
 #endif
 
+static struct proc_dir_entry *proc_root_kcore;
+
 static int open_kcore(struct inode * inode, struct file * filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
@@ -34,7 +36,7 @@ static int open_kcore(struct inode * inode, struct file * filp)
 
 static ssize_t read_kcore(struct file *, char __user *, size_t, loff_t *);
 
-const struct file_operations proc_kcore_operations = {
+static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
 };
@@ -399,3 +401,13 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 
 	return acc;
 }
+
+static int __init proc_kcore_init(void)
+{
+	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+	if (proc_root_kcore)
+		proc_root_kcore->size =
+				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
+	return 0;
+}
+module_init(proc_kcore_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 981efbf..69c8244 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -187,19 +187,11 @@ static struct file_operations proc_kpageflags_operations = {
 };
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
-struct proc_dir_entry *proc_root_kcore;
-
 void __init proc_misc_init(void)
 {
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_PROC_KCORE
-	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-	if (proc_root_kcore)
-		proc_root_kcore->size =
-				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
-#endif
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 27d534f..9d83089 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,8 +97,6 @@ struct vmcore {
 
 #ifdef CONFIG_PROC_FS
 
-extern struct proc_dir_entry *proc_root_kcore;
-
 extern spinlock_t proc_subdir_lock;
 
 extern void proc_root_init(void);
@@ -138,8 +136,6 @@ extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct p
 extern int proc_readdir(struct file *, void *, filldir_t);
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
 
-extern const struct file_operations proc_kcore_operations;
-
 extern int pid_ns_prepare_proc(struct pid_namespace *ns);
 extern void pid_ns_release_proc(struct pid_namespace *ns);
 
-- 
1.5.6.5

