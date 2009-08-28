Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZH1StC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZH1StC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZH1StC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:49:02 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54407 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZH1StA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=STAGhKTvU/mKJkG+5Lw0D7tprmSCgTjgwrc4uHzJgYhj6pQE29aLobI7OUs9/luIbd
         Ahs5wNm3VJH+t/w+IqVXoVSQtGfFBNh5SnXECDFMkfVEdkUxUVK5fLeaWkaCV6nKJhAq
         aYI7RaYVZfLu1p0/DMeBQytTJ0JgdpbQPk0p0=
Date: Fri, 28 Aug 2009 22:48:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] switch /proc/irq/prof_cpu_mask to seq_file
Message-ID: <20090828184856.GA14499@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/profile.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -442,48 +442,51 @@ void profile_tick(int type)
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 
-static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int prof_cpu_mask_proc_show(struct seq_file *m, void *v)
 {
-	int len = cpumask_scnprintf(page, count, data);
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+	seq_cpumask(m, prof_cpu_mask);
+	seq_putc(m, '\n');
+	return 0;
 }
 
-static int prof_cpu_mask_write_proc(struct file *file,
-	const char __user *buffer,  unsigned long count, void *data)
+static int prof_cpu_mask_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, prof_cpu_mask_proc_show, NULL);
+}
+
+static ssize_t prof_cpu_mask_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
-	struct cpumask *mask = data;
-	unsigned long full_count = count, err;
 	cpumask_var_t new_value;
+	int err;
 
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (!err) {
-		cpumask_copy(mask, new_value);
-		err = full_count;
+		cpumask_copy(prof_cpu_mask, new_value);
+		err = count;
 	}
 	free_cpumask_var(new_value);
 	return err;
 }
 
+static const struct file_operations prof_cpu_mask_proc_fops = {
+	.open		= prof_cpu_mask_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= prof_cpu_mask_proc_write,
+};
+
 void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
 {
-	struct proc_dir_entry *entry;
-
 	/* create /proc/irq/prof_cpu_mask */
-	entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir);
-	if (!entry)
-		return;
-	entry->data = prof_cpu_mask;
-	entry->read_proc = prof_cpu_mask_read_proc;
-	entry->write_proc = prof_cpu_mask_write_proc;
+	proc_create("prof_cpu_mask", 0600, root_irq_dir, &prof_cpu_mask_proc_fops);
 }
 
 /*
