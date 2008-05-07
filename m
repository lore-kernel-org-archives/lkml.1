Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYEGVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYEGVjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYEGVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:38:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:61550 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYEGViy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=xZnnvCqXo/d72o5rQ5SQRkePSVi+7p9u5BmULVaYrmVElM8cNLbNx92zk8MO4fqAWuNgkGXRbChhM/QM+ikl4Bvg1EA37ZgGjcwTcuU4XlpgCCgZhpjEfyV6pjSwtiuYAFm3ELvcQIbCmoeJl3pJoqfDEVvSX2EreTq8vtOuvg0=
Date: Thu, 8 May 2008 02:34:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] proc: convert /proc/irq/prof_cpu_mask to seq_files
Message-ID: <20080507223413.GD14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: we know that code only wants prof_cpu_mask, so use that directly
      in ->show and ->write code and avoid ->data passing.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/profile.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -419,45 +419,48 @@ void profile_tick(int type)
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 
-static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int prof_cpu_mask_proc_show(struct seq_file *m, void *v)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+	seq_cpumask(m, &prof_cpu_mask);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int prof_cpu_mask_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, prof_cpu_mask_proc_show, NULL);
 }
 
-static int prof_cpu_mask_write_proc(struct file *file,
-	const char __user *buffer,  unsigned long count, void *data)
+static ssize_t prof_cpu_mask_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *ppos)
 {
-	cpumask_t *mask = (cpumask_t *)data;
-	unsigned long full_count = count, err;
 	cpumask_t new_value;
+	int err;
 
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
 		return err;
 
-	*mask = new_value;
-	return full_count;
+	prof_cpu_mask = new_value;
+	return count;
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
-	entry->data = (void *)&prof_cpu_mask;
-	entry->read_proc = prof_cpu_mask_read_proc;
-	entry->write_proc = prof_cpu_mask_write_proc;
+	proc_create("prof_cpu_mask", 0600, root_irq_dir, &prof_cpu_mask_proc_fops);
 }
 
 /*

