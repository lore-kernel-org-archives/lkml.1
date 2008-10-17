Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYJQMkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYJQMkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYJQMjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:39:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:40929 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYJQMjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Lr1mShPMTBaFdPyUTnRR+kJzoFBK1Q0GdPLPHtqTHPA80GJ0Zh88933IlfN91kuOPr
         EU828mTh2ipY0uoR+YVnFCdoXb47DpkkubnvZPRV9vwvs87Q/uSkF8/0+5dlDv8AqrxD
         AbcfvN17DxO56HVyfLEA5FepkipPoMv4IoZy0=
Date: Fri, 17 Oct 2008 16:42:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Subject: [PATCH 07/31] proc: move /proc/filesystems to fs/filesystems.c
Message-ID: <20081017124254.GH22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 92375a6ec7f042657dc5661f0b887dc4c2dbdbc5 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 14:08:37 +0400
Subject: [PATCH 07/31] proc: move /proc/filesystems to fs/filesystems.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/filesystems.c    |   39 +++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c |    8 --------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..d0e20ce 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -8,6 +8,8 @@
 
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/init.h>
@@ -214,6 +216,43 @@ int get_filesystem_list(char * buf)
 	return len;
 }
 
+#ifdef CONFIG_PROC_FS
+static int filesystems_proc_show(struct seq_file *m, void *v)
+{
+	struct file_system_type * tmp;
+
+	read_lock(&file_systems_lock);
+	tmp = file_systems;
+	while (tmp) {
+		seq_printf(m, "%s\t%s\n",
+			(tmp->fs_flags & FS_REQUIRES_DEV) ? "" : "nodev",
+			tmp->name);
+		tmp = tmp->next;
+	}
+	read_unlock(&file_systems_lock);
+	return 0;
+}
+
+static int filesystems_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, filesystems_proc_show, NULL);
+}
+
+static const struct file_operations filesystems_proc_fops = {
+	.open		= filesystems_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_filesystems_init(void)
+{
+	proc_create("filesystems", 0, NULL, &filesystems_proc_fops);
+	return 0;
+}
+module_init(proc_filesystems_init);
+#endif
+
 struct file_system_type *get_fs_type(const char *name)
 {
 	struct file_system_type *fs;
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index c70e2f5..3bedbd2 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -474,13 +474,6 @@ static const struct file_operations proc_interrupts_operations = {
 	.release	= seq_release,
 };
 
-static int filesystems_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len = get_filesystem_list(page);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 static int cmdline_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
 {
@@ -650,7 +643,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"filesystems",	filesystems_read_proc},
 		{"cmdline",	cmdline_read_proc},
 		{"execdomains",	execdomains_read_proc},
 		{NULL,}
-- 
1.5.6.5

