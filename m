Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbZK0Gnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbZK0Gnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZK0Gnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:43:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:9842 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZK0Gnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=yEX/xWdJ1Cu/MMeiukqxPPruabyMn811NXpsUiKMaFNuw8Vt5vmklivNlbFVhFsUJd
         PjCTxQx1XrNHvtXib2PxZ2Ncq9eJOsvmKrUJG6b768ez+UbtAmzfwaQgCp68RXnqPaBy
         2Vi40veyd8d8EuJXuqw8QfF7t7l9XJnRoLSfA=
Date: Fri, 27 Nov 2009 09:43:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jdike@addtoit.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uml: convert to seq_file/proc_fops
Message-ID: <20091127064347.GE25983@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/um/drivers/mconsole_kern.c |   14 +++++++------
 arch/um/drivers/ubd_kern.c      |   36 ++++++++++++++++-----------------
 arch/um/kernel/exitcode.c       |   43 +++++++++++++++++++++-------------------
 arch/um/kernel/process.c        |   31 +++++++++++++++++++---------
 4 files changed, 70 insertions(+), 54 deletions(-)

--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -833,8 +833,8 @@ static int __init mconsole_init(void)
 
 __initcall(mconsole_init);
 
-static int write_proc_mconsole(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+static ssize_t mconsole_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *buf;
 
@@ -855,6 +855,11 @@ static int write_proc_mconsole(struct file *file, const char __user *buffer,
 	return count;
 }
 
+static const struct file_operations mconsole_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= mconsole_proc_write,
+};
+
 static int create_proc_mconsole(void)
 {
 	struct proc_dir_entry *ent;
@@ -862,15 +867,12 @@ static int create_proc_mconsole(void)
 	if (notify_socket == NULL)
 		return 0;
 
-	ent = create_proc_entry("mconsole", S_IFREG | 0200, NULL);
+	ent = proc_create("mconsole", 0200, NULL, &mconsole_proc_fops);
 	if (ent == NULL) {
 		printk(KERN_INFO "create_proc_mconsole : create_proc_entry "
 		       "failed\n");
 		return 0;
 	}
-
-	ent->read_proc = NULL;
-	ent->write_proc = write_proc_mconsole;
 	return 0;
 }
 
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -27,6 +27,7 @@
 #include "linux/init.h"
 #include "linux/cdrom.h"
 #include "linux/proc_fs.h"
+#include "linux/seq_file.h"
 #include "linux/ctype.h"
 #include "linux/capability.h"
 #include "linux/mm.h"
@@ -200,23 +201,25 @@ static void make_proc_ide(void)
 	proc_ide = proc_mkdir("ide0", proc_ide_root);
 }
 
-static int proc_ide_read_media(char *page, char **start, off_t off, int count,
-			       int *eof, void *data)
+static int fake_ide_media_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-
-	strcpy(page, "disk\n");
-	len = strlen("disk\n");
-	len -= off;
-	if (len < count){
-		*eof = 1;
-		if (len <= 0) return 0;
-	}
-	else len = count;
-	*start = page + off;
-	return len;
+	seq_puts(m, "disk\n");
+	return 0;
+}
+
+static int fake_ide_media_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fake_ide_media_proc_show, NULL);
 }
 
+static const struct file_operations fake_ide_media_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fake_ide_media_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static void make_ide_entries(const char *dev_name)
 {
 	struct proc_dir_entry *dir, *ent;
@@ -227,11 +230,8 @@ static void make_ide_entries(const char *dev_name)
 	dir = proc_mkdir(dev_name, proc_ide);
 	if(!dir) return;
 
-	ent = create_proc_entry("media", S_IFREG|S_IRUGO, dir);
+	ent = proc_create("media", S_IRUGO, dir, &fake_ide_media_proc_fops);
 	if(!ent) return;
-	ent->data = NULL;
-	ent->read_proc = proc_ide_read_media;
-	ent->write_proc = NULL;
 	snprintf(name, sizeof(name), "ide0/%s", dev_name);
 	proc_symlink(dev_name, proc_ide_root, name);
 }
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -6,7 +6,9 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
 
@@ -16,30 +18,26 @@
  */
 int uml_exitcode = 0;
 
-static int read_proc_exitcode(char *page, char **start, off_t off,
-			      int count, int *eof, void *data)
+static int exitcode_proc_show(struct seq_file *m, void *v)
 {
-	int len, val;
+	int val;
 
 	/*
 	 * Save uml_exitcode in a local so that we don't need to guarantee
 	 * that sprintf accesses it atomically.
 	 */
 	val = uml_exitcode;
-	len = sprintf(page, "%d\n", val);
-	len -= off;
-	if (len <= off+count)
-		*eof = 1;
-	*start = page + off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-	return len;
+	seq_printf(m, "%d\n", val);
+	return 0;
+}
+
+static int exitcode_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, exitcode_proc_show, NULL);
 }
 
-static int write_proc_exitcode(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+static ssize_t exitcode_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
 	char *end, buf[sizeof("nnnnn\0")];
 	int tmp;
@@ -55,20 +53,25 @@ static int write_proc_exitcode(struct file *file, const char __user *buffer,
 	return count;
 }
 
+static const struct file_operations exitcode_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= exitcode_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= exitcode_proc_write,
+};
+
 static int make_proc_exitcode(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = create_proc_entry("exitcode", 0600, NULL);
+	ent = proc_create("exitcode", 0600, NULL, &exitcode_proc_fops);
 	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
 		return 0;
 	}
-
-	ent->read_proc = read_proc_exitcode;
-	ent->write_proc = write_proc_exitcode;
-
 	return 0;
 }
 
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -9,11 +9,13 @@
 #include <linux/hardirq.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/personality.h>
 #include <linux/proc_fs.h>
 #include <linux/ptrace.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/tick.h>
 #include <linux/threads.h>
 #include <asm/current.h>
@@ -336,16 +338,19 @@ int get_using_sysemu(void)
 	return atomic_read(&using_sysemu);
 }
 
-static int proc_read_sysemu(char *buf, char **start, off_t offset, int size,int *eof, void *data)
+static int sysemu_proc_show(struct seq_file *m, void *v)
 {
-	if (snprintf(buf, size, "%d\n", get_using_sysemu()) < size)
-		/* No overflow */
-		*eof = 1;
+	seq_printf(m, "%d\n", get_using_sysemu());
+	return 0;
+}
 
-	return strlen(buf);
+static int sysemu_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sysemu_proc_show, NULL);
 }
 
-static int proc_write_sysemu(struct file *file,const char __user *buf, unsigned long count,void *data)
+static ssize_t sysemu_proc_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *pos)
 {
 	char tmp[2];
 
@@ -358,13 +363,22 @@ static int proc_write_sysemu(struct file *file,const char __user *buf, unsigned
 	return count;
 }
 
+static const struct file_operations sysemu_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sysemu_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= sysemu_proc_write,
+};
+
 int __init make_proc_sysemu(void)
 {
 	struct proc_dir_entry *ent;
 	if (!sysemu_supported)
 		return 0;
 
-	ent = create_proc_entry("sysemu", 0600, NULL);
+	ent = proc_create("sysemu", 0600, NULL, &sysemu_proc_fops);
 
 	if (ent == NULL)
 	{
@@ -372,9 +386,6 @@ int __init make_proc_sysemu(void)
 		return 0;
 	}
 
-	ent->read_proc  = proc_read_sysemu;
-	ent->write_proc = proc_write_sysemu;
-
 	return 0;
 }
 
