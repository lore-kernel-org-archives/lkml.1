Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYJQMnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYJQMnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbYJQMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:43:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:43358 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbYJQMnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tewV46YHLLkq2jEBts+Dc4NPUaUCEBfvDS5t3NLjHG4goQTsE1sfSr6QGxsW9XIRNy
         jsJH2sSqxXlUPc6ialKREe4hxMjMDjSDbkIsxJjaroWERhVnVauB3S2NQh82IXmZetn1
         3LuQrQr669xbPDrSVaEv+EYyi+XDKgvYqIq1I=
Date: Fri, 17 Oct 2008 16:46:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/31] proc: move /proc/cpuinfo code to fs/proc/cpuinfo.c
Message-ID: <20081017124615.GO22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From fe9d1f429e3b66c6e7b71a5370316d58fa4ceec6 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 23:40:23 +0400
Subject: [PATCH 14/31] proc: move /proc/cpuinfo code to fs/proc/cpuinfo.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/cpuinfo.c   |   24 ++++++++++++++++++++++++
 fs/proc/proc_misc.c |   14 --------------
 3 files changed, 25 insertions(+), 14 deletions(-)
 create mode 100644 fs/proc/cpuinfo.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index f24ebfd..c91cc9c 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
 proc-y	+= cmdline.o
+proc-y	+= cpuinfo.o
 proc-y	+= devices.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
diff --git a/fs/proc/cpuinfo.c b/fs/proc/cpuinfo.c
new file mode 100644
index 0000000..5a1e539
--- /dev/null
+++ b/fs/proc/cpuinfo.c
@@ -0,0 +1,24 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern const struct seq_operations cpuinfo_op;
+static int cpuinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &cpuinfo_op);
+}
+
+static const struct file_operations proc_cpuinfo_operations = {
+	.open		= cpuinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_cpuinfo_init(void)
+{
+	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
+	return 0;
+}
+module_init(proc_cpuinfo_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 8018979..916ed4d 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -93,19 +93,6 @@ static const struct file_operations proc_zoneinfo_file_operations = {
 	.release	= seq_release,
 };
 
-extern const struct seq_operations cpuinfo_op;
-static int cpuinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &cpuinfo_op);
-}
-
-static const struct file_operations proc_cpuinfo_operations = {
-	.open		= cpuinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
@@ -534,7 +521,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
 	proc_create("partitions", 0, NULL, &proc_partitions_operations);
 #endif
-- 
1.5.6.5

