Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYJQMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYJQMkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYJQMkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:40:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:40929 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYJQMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EnV9I4zlUnuEihkxVmYvwLgHDXxpZR2bQRgR+iWqgwWY+bFpJm+vKzMbi5DyTIGAdJ
         bln70cGWObmun1FkqjU52X93R2cduBoOa8TvZWgwvl2+sIZkAP3gxVOfOSc6bvhxmymQ
         o7aGcbYAomW6zfagJeWAfD/yaz+h/RqDKGdNY=
Date: Fri, 17 Oct 2008 16:43:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/31] proc: switch /proc/cmdline to seq_file
Message-ID: <20081017124313.GI22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 49e074119ae92121b7dc4a092a488cffbf3f22c8 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 14:13:59 +0400
Subject: [PATCH 08/31] proc: switch /proc/cmdline to seq_file

and move it to fs/proc/cmdline.c while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/cmdline.c   |   29 +++++++++++++++++++++++++++++
 fs/proc/proc_misc.c |   10 ----------
 3 files changed, 30 insertions(+), 10 deletions(-)
 create mode 100644 fs/proc/cmdline.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 97985c8..48f9f0f 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -9,6 +9,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
+proc-y	+= cmdline.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
 proc-y	+= uptime.o
diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
new file mode 100644
index 0000000..82676e3
--- /dev/null
+++ b/fs/proc/cmdline.c
@@ -0,0 +1,29 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+static int cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s\n", saved_command_line);
+	return 0;
+}
+
+static int cmdline_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cmdline_proc_show, NULL);
+}
+
+static const struct file_operations cmdline_proc_fops = {
+	.open		= cmdline_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_cmdline_init(void)
+{
+	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
+	return 0;
+}
+module_init(proc_cmdline_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 3bedbd2..60c35a0 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -474,15 +474,6 @@ static const struct file_operations proc_interrupts_operations = {
 	.release	= seq_release,
 };
 
-static int cmdline_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len;
-
-	len = sprintf(page, "%s\n", saved_command_line);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 #ifdef CONFIG_FILE_LOCKING
 static int locks_open(struct inode *inode, struct file *filp)
 {
@@ -643,7 +634,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"cmdline",	cmdline_read_proc},
 		{"execdomains",	execdomains_read_proc},
 		{NULL,}
 	};
-- 
1.5.6.5

