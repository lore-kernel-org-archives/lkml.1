Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYJQMmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYJQMmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYJQMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:42:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:65193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbYJQMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AERyS/B1AsZsX1eVTsmp/7l2IVvXqmO7dEGXG5yzU+x19MpfVmfaw7mFycKwCgyz7s
         CNiKwZqnX4I77OEgynmlGGjsrBx+sR0sgbXUhu/F+OCfb+hEvRU7C7m7z3eIVCzk6tnr
         DA00fkkDBvk1bceTuJj9Na+67Wb2FGVehpdyg=
Date: Fri, 17 Oct 2008 16:45:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bfields@citi.umich.edu
Subject: [PATCH 12/31] proc: move rest of /proc/locks to fs/locks.c
Message-ID: <20081017124540.GM22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 09a3878c4ba92dc906e6573245fb18bef5d760ff Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 22:34:18 +0400
Subject: [PATCH 12/31] proc: move rest of /proc/locks to fs/locks.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/locks.c          |   22 +++++++++++++++++++++-
 fs/proc/proc_misc.c |   17 -----------------
 include/linux/fs.h  |    1 -
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 5eb259e..90e87f5 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2078,6 +2078,7 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 
 #ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 static void lock_get_status(struct seq_file *f, struct file_lock *fl,
@@ -2183,12 +2184,31 @@ static void locks_stop(struct seq_file *f, void *v)
 	unlock_kernel();
 }
 
-struct seq_operations locks_seq_operations = {
+static const struct seq_operations locks_seq_operations = {
 	.start	= locks_start,
 	.next	= locks_next,
 	.stop	= locks_stop,
 	.show	= locks_show,
 };
+
+static int locks_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &locks_seq_operations);
+}
+
+static const struct file_operations proc_locks_operations = {
+	.open		= locks_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_locks_init(void)
+{
+	proc_create("locks", 0, NULL, &proc_locks_operations);
+	return 0;
+}
+module_init(proc_locks_init);
 #endif
 
 /**
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 8ae7d38..19cf7a0 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -455,20 +455,6 @@ static const struct file_operations proc_interrupts_operations = {
 	.release	= seq_release,
 };
 
-#ifdef CONFIG_FILE_LOCKING
-static int locks_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &locks_seq_operations);
-}
-
-static const struct file_operations proc_locks_operations = {
-	.open		= locks_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-#endif /* CONFIG_FILE_LOCKING */
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -607,9 +593,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_FILE_LOCKING
-	proc_create("locks", 0, NULL, &proc_locks_operations);
-#endif
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6a625b..0240495 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1037,7 +1037,6 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
-extern struct seq_operations locks_seq_operations;
 #else /* !CONFIG_FILE_LOCKING */
 #define fcntl_getlk(a, b) ({ -EINVAL; })
 #define fcntl_setlk(a, b, c, d) ({ -EACCES; })
-- 
1.5.6.5

