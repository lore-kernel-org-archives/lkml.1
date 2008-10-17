Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJQMnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJQMnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYJQMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:43:01 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:49765 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbYJQMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=B1BbSIUsfFhudcLs/y2w9D65cFFJPzg8PyRJO+mCn4eJjLgivmxRPiJJrYC7W2kR0p
         P//uDQA340F9nRVS348O1t3L+H2T/VlbSSOntSmZzClWFL79SuMUGef+/fciGqW4n2uc
         fQkaFi3MRP0kFVvNFz9Tu/yiu7qxYcklA9dzs=
Date: Fri, 17 Oct 2008 16:46:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/31] proc: move /proc/devices code to fs/proc/devices.c
Message-ID: <20081017124601.GN22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1ef9788b6d36c6aef19878b15a7ef268b157c076 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 23:11:37 +0400
Subject: [PATCH 13/31] proc: move /proc/devices code to fs/proc/devices.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/devices.c   |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c |   60 -------------------------------------------
 3 files changed, 71 insertions(+), 60 deletions(-)
 create mode 100644 fs/proc/devices.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 48f9f0f..f24ebfd 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
 proc-y	+= cmdline.o
+proc-y	+= devices.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
 proc-y	+= uptime.o
diff --git a/fs/proc/devices.c b/fs/proc/devices.c
new file mode 100644
index 0000000..59ee7da
--- /dev/null
+++ b/fs/proc/devices.c
@@ -0,0 +1,70 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+static int devinfo_show(struct seq_file *f, void *v)
+{
+	int i = *(loff_t *) v;
+
+	if (i < CHRDEV_MAJOR_HASH_SIZE) {
+		if (i == 0)
+			seq_printf(f, "Character devices:\n");
+		chrdev_show(f, i);
+	}
+#ifdef CONFIG_BLOCK
+	else {
+		i -= CHRDEV_MAJOR_HASH_SIZE;
+		if (i == 0)
+			seq_printf(f, "\nBlock devices:\n");
+		blkdev_show(f, i);
+	}
+#endif
+	return 0;
+}
+
+static void *devinfo_start(struct seq_file *f, loff_t *pos)
+{
+	if (*pos < (BLKDEV_MAJOR_HASH_SIZE + CHRDEV_MAJOR_HASH_SIZE))
+		return pos;
+	return NULL;
+}
+
+static void *devinfo_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= (BLKDEV_MAJOR_HASH_SIZE + CHRDEV_MAJOR_HASH_SIZE))
+		return NULL;
+	return pos;
+}
+
+static void devinfo_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static const struct seq_operations devinfo_ops = {
+	.start = devinfo_start,
+	.next  = devinfo_next,
+	.stop  = devinfo_stop,
+	.show  = devinfo_show
+};
+
+static int devinfo_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &devinfo_ops);
+}
+
+static const struct file_operations proc_devinfo_operations = {
+	.open		= devinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_devices_init(void)
+{
+	proc_create("devices", 0, NULL, &proc_devinfo_operations);
+	return 0;
+}
+module_init(proc_devices_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 19cf7a0..8018979 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -106,65 +106,6 @@ static const struct file_operations proc_cpuinfo_operations = {
 	.release	= seq_release,
 };
 
-static int devinfo_show(struct seq_file *f, void *v)
-{
-	int i = *(loff_t *) v;
-
-	if (i < CHRDEV_MAJOR_HASH_SIZE) {
-		if (i == 0)
-			seq_printf(f, "Character devices:\n");
-		chrdev_show(f, i);
-	}
-#ifdef CONFIG_BLOCK
-	else {
-		i -= CHRDEV_MAJOR_HASH_SIZE;
-		if (i == 0)
-			seq_printf(f, "\nBlock devices:\n");
-		blkdev_show(f, i);
-	}
-#endif
-	return 0;
-}
-
-static void *devinfo_start(struct seq_file *f, loff_t *pos)
-{
-	if (*pos < (BLKDEV_MAJOR_HASH_SIZE + CHRDEV_MAJOR_HASH_SIZE))
-		return pos;
-	return NULL;
-}
-
-static void *devinfo_next(struct seq_file *f, void *v, loff_t *pos)
-{
-	(*pos)++;
-	if (*pos >= (BLKDEV_MAJOR_HASH_SIZE + CHRDEV_MAJOR_HASH_SIZE))
-		return NULL;
-	return pos;
-}
-
-static void devinfo_stop(struct seq_file *f, void *v)
-{
-	/* Nothing to do */
-}
-
-static const struct seq_operations devinfo_ops = {
-	.start = devinfo_start,
-	.next  = devinfo_next,
-	.stop  = devinfo_stop,
-	.show  = devinfo_show
-};
-
-static int devinfo_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &devinfo_ops);
-}
-
-static const struct file_operations proc_devinfo_operations = {
-	.open		= devinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
@@ -593,7 +534,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
 	proc_create("partitions", 0, NULL, &proc_partitions_operations);
-- 
1.5.6.5

