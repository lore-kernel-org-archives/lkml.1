Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJQMqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJQMqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYJQMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:45:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4920 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYJQMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MIDl/xdKVOA4hPJJyMYht/2sle/D6cwqqp4IRh+I3kk+BVf41Fz/oDuKT1rJAzEyn5
         tOvSiOa5dIXPSrVMLgfmHhq83R3dCVZPqF8ZayddAocQeIgdO5RN9qEhXImX/7/L17uU
         4epuiT/FK7H5X9af/mNtdqN+301sA+YUAB+lY=
Date: Fri, 17 Oct 2008 16:48:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: [PATCH 18/31] proc: move /proc/slab_allocators boilerplate to
	mm/slab.c
Message-ID: <20081017124854.GS22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 777d02988b44d1cc31b7cb6d82c94e4d337f5abe Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 00:59:10 +0400
Subject: [PATCH 18/31] proc: move /proc/slab_allocators boilerplate to mm/slab.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c |   30 ------------------------------
 mm/slab.c           |   36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 1b46976..4fb05d1 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -143,33 +143,6 @@ static const struct file_operations proc_slabinfo_operations = {
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
-
-#ifdef CONFIG_DEBUG_SLAB_LEAK
-extern const struct seq_operations slabstats_op;
-static int slabstats_open(struct inode *inode, struct file *file)
-{
-	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	int ret = -ENOMEM;
-	if (n) {
-		ret = seq_open(file, &slabstats_op);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			*n = PAGE_SIZE / (2 * sizeof(unsigned long));
-			m->private = n;
-			n = NULL;
-		}
-		kfree(n);
-	}
-	return ret;
-}
-
-static const struct file_operations proc_slabstats_operations = {
-	.open		= slabstats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-#endif
 #endif
 
 #ifdef CONFIG_MMU
@@ -337,9 +310,6 @@ void __init proc_misc_init(void)
 	/* And now for trickier ones */
 #ifdef CONFIG_SLABINFO
 	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
-#ifdef CONFIG_DEBUG_SLAB_LEAK
-	proc_create("slab_allocators", 0, NULL, &proc_slabstats_operations);
-#endif
 #endif
 #ifdef CONFIG_MMU
 	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
diff --git a/mm/slab.c b/mm/slab.c
index e76eee4..d53ac9c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -95,6 +95,7 @@
 #include	<linux/init.h>
 #include	<linux/compiler.h>
 #include	<linux/cpuset.h>
+#include	<linux/proc_fs.h>
 #include	<linux/seq_file.h>
 #include	<linux/notifier.h>
 #include	<linux/kallsyms.h>
@@ -4443,13 +4444,46 @@ static int leaks_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-const struct seq_operations slabstats_op = {
+static const struct seq_operations slabstats_op = {
 	.start = leaks_start,
 	.next = s_next,
 	.stop = s_stop,
 	.show = leaks_show,
 };
+
+static int slabstats_open(struct inode *inode, struct file *file)
+{
+	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	int ret = -ENOMEM;
+	if (n) {
+		ret = seq_open(file, &slabstats_op);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			*n = PAGE_SIZE / (2 * sizeof(unsigned long));
+			m->private = n;
+			n = NULL;
+		}
+		kfree(n);
+	}
+	return ret;
+}
+
+static const struct file_operations proc_slabstats_operations = {
+	.open		= slabstats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+#endif
+
+static int __init slab_proc_init(void)
+{
+#ifdef CONFIG_DEBUG_SLAB_LEAK
+	proc_create("slab_allocators", 0, NULL, &proc_slabstats_operations);
 #endif
+	return 0;
+}
+module_init(slab_proc_init);
 #endif
 
 /**
-- 
1.5.6.5

