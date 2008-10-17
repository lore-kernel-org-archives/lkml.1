Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYJQMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYJQMpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYJQMop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:44:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:3922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbYJQMoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ALuW5mL70GAmwL31wNpfyq8s7ddioge2xPhibp5hQYHkpZqh5EMQIO/IrCJ5zKIXq+
         Q4Va4ywe7oC+mfY4D5v/TyI5f896AI0Z1qt5qCdn9QVwt2ZiDfQNIsdyJSGaLL3Lz5sj
         KiL3obZRSuyAAUa6fxJcYwiA6pt4WGiPrqvTg=
Date: Fri, 17 Oct 2008 16:47:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/31] proc: move /proc/interrupts boilerplate code to
	fs/proc/interrupts.c
Message-ID: <20081017124747.GR22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 749e0c5f82318acc1332cd41e043bdb41a8759ad Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 5 Oct 2008 00:08:44 +0400
Subject: [PATCH 17/31] proc: move /proc/interrupts boilerplate code to fs/proc/interrupts.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile     |    1 +
 fs/proc/interrupts.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c  |   42 ---------------------------------------
 3 files changed, 54 insertions(+), 42 deletions(-)
 create mode 100644 fs/proc/interrupts.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 13ffa7b..b921f44 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -12,6 +12,7 @@ proc-y       += inode.o root.o base.o generic.o array.o \
 proc-y	+= cmdline.o
 proc-y	+= cpuinfo.o
 proc-y	+= devices.o
+proc-y	+= interrupts.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
 proc-y	+= stat.o
diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
new file mode 100644
index 0000000..bb492f0
--- /dev/null
+++ b/fs/proc/interrupts.c
@@ -0,0 +1,53 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <asm/irq.h>
+
+/*
+ * /proc/interrupts
+ */
+static void *int_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos <= NR_IRQS) ? pos : NULL;
+}
+
+static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos > NR_IRQS)
+		return NULL;
+	return pos;
+}
+
+static void int_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static const struct seq_operations int_seq_ops = {
+	.start = int_seq_start,
+	.next  = int_seq_next,
+	.stop  = int_seq_stop,
+	.show  = show_interrupts
+};
+
+static int interrupts_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &int_seq_ops);
+}
+
+static const struct file_operations proc_interrupts_operations = {
+	.open		= interrupts_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_interrupts_init(void)
+{
+	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
+	return 0;
+}
+module_init(proc_interrupts_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index d49b956..1b46976 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -197,47 +197,6 @@ static const struct file_operations proc_vmalloc_operations = {
 };
 #endif
 
-/*
- * /proc/interrupts
- */
-static void *int_seq_start(struct seq_file *f, loff_t *pos)
-{
-	return (*pos <= NR_IRQS) ? pos : NULL;
-}
-
-static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
-{
-	(*pos)++;
-	if (*pos > NR_IRQS)
-		return NULL;
-	return pos;
-}
-
-static void int_seq_stop(struct seq_file *f, void *v)
-{
-	/* Nothing to do */
-}
-
-
-static const struct seq_operations int_seq_ops = {
-	.start = int_seq_start,
-	.next  = int_seq_next,
-	.stop  = int_seq_stop,
-	.show  = show_interrupts
-};
-
-static int interrupts_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &int_seq_ops);
-}
-
-static const struct file_operations proc_interrupts_operations = {
-	.open		= interrupts_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -376,7 +335,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 #ifdef CONFIG_SLABINFO
 	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
-- 
1.5.6.5

