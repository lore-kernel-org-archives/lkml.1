Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYJQMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYJQMiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYJQMhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:37:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:3751 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYJQMhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cAI4N/C1N2M2BBw4Mfofr38YaYY2BL3sOrq6fDDuD+rhWr1edhEMlkQeo2E664s1OP
         rkjqz1q+zKqdPZggJcerTJIIyRYXvpj8wWg0OZT6UgryxEqY2CXuc00KooFUHBUbP9pg
         HvWKnfIOhaCeK6thLttdmv8Uqh+J/gejMYn6s=
Date: Fri, 17 Oct 2008 16:40:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/31] proc: switch /proc/version to seq_file
Message-ID: <20081017124052.GE22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From e312ed7902300b312bce9d5ebf755056010ce02f Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 3 Oct 2008 11:53:19 +0400
Subject: [PATCH 04/31] proc: switch /proc/version to seq_file

and move it to fs/proc/version.c while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/proc_misc.c |   13 -------------
 fs/proc/version.c   |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 13 deletions(-)
 create mode 100644 fs/proc/version.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 70607a0..97985c8 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -12,6 +12,7 @@ proc-y       += inode.o root.o base.o generic.o array.o \
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
 proc-y	+= uptime.o
+proc-y	+= version.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 573dc9e..49815af 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -114,18 +114,6 @@ static const struct file_operations proc_zoneinfo_file_operations = {
 	.release	= seq_release,
 };
 
-static int version_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len;
-
-	len = snprintf(page, PAGE_SIZE, linux_proc_banner,
-		utsname()->sysname,
-		utsname()->release,
-		utsname()->version);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 extern const struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
@@ -682,7 +670,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"version",	version_read_proc},
 #ifdef CONFIG_PROC_HARDWARE
 		{"hardware",	hardware_read_proc},
 #endif
diff --git a/fs/proc/version.c b/fs/proc/version.c
new file mode 100644
index 0000000..76817a6
--- /dev/null
+++ b/fs/proc/version.c
@@ -0,0 +1,34 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/utsname.h>
+
+static int version_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, linux_proc_banner,
+		utsname()->sysname,
+		utsname()->release,
+		utsname()->version);
+	return 0;
+}
+
+static int version_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, version_proc_show, NULL);
+}
+
+static const struct file_operations version_proc_fops = {
+	.open		= version_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_version_init(void)
+{
+	proc_create("version", 0, NULL, &version_proc_fops);
+	return 0;
+}
+module_init(proc_version_init);
-- 
1.5.6.5

