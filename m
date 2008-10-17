Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYJQMrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYJQMrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYJQMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:47:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:38451 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYJQMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KtB8wzgLPxSpHKmfmGrH0MFVJjkWyjzaKdQQHjE1ARtdKlyl92sRFaDCDdubqMt58y
         N0wVtY/pnJ6bRtll/qeJk7bMTtfcBcbX67d9jiC62Jggt3wyi5e/0Zdoc7VSCuoJDYR1
         fONo2IWjhuH2Bsp4PdYaxuJy0fPWRRGb8+h8E=
Date: Fri, 17 Oct 2008 16:50:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 20/31] proc: move /proc/vmallocinfo to mm/vmalloc.c
Message-ID: <20081017125012.GU22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 52997f79e2783a3928eb17c877bdabfcb50c5c32 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 03:50:47 +0400
Subject: [PATCH 20/31] proc: move /proc/vmallocinfo to mm/vmalloc.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c     |   28 ----------------------------
 include/linux/vmalloc.h |    2 --
 mm/vmalloc.c            |   33 ++++++++++++++++++++++++++++++++-
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 911a2d3..60b1c07 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -131,31 +131,6 @@ static const struct file_operations proc_modules_operations = {
 };
 #endif
 
-#ifdef CONFIG_MMU
-static int vmalloc_open(struct inode *inode, struct file *file)
-{
-	unsigned int *ptr = NULL;
-	int ret;
-
-	if (NUMA_BUILD)
-		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
-	ret = seq_open(file, &vmalloc_op);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = ptr;
-	} else
-		kfree(ptr);
-	return ret;
-}
-
-static const struct file_operations proc_vmalloc_operations = {
-	.open		= vmalloc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-#endif
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -294,9 +269,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_MMU
-	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
-#endif
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 328eb40..e53f668 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -90,6 +90,4 @@ extern void free_vm_area(struct vm_struct *area);
 extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 
-extern const struct seq_operations vmalloc_op;
-
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bba06c4..de09ba6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/debugobjects.h>
 #include <linux/vmalloc.h>
@@ -996,11 +997,41 @@ static int s_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-const struct seq_operations vmalloc_op = {
+static const struct seq_operations vmalloc_op = {
 	.start = s_start,
 	.next = s_next,
 	.stop = s_stop,
 	.show = s_show,
 };
+
+static int vmalloc_open(struct inode *inode, struct file *file)
+{
+	unsigned int *ptr = NULL;
+	int ret;
+
+	if (NUMA_BUILD)
+		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+	ret = seq_open(file, &vmalloc_op);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = ptr;
+	} else
+		kfree(ptr);
+	return ret;
+}
+
+static const struct file_operations proc_vmalloc_operations = {
+	.open		= vmalloc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+static int __init proc_vmalloc_init(void)
+{
+	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
+	return 0;
+}
+module_init(proc_vmalloc_init);
 #endif
 
-- 
1.5.6.5

