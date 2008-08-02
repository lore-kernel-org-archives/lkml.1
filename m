Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYHBLdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYHBLdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 07:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYHBLdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 07:33:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:36248 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYHBLdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 07:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=B4MHYB3AZ8l4ZP0O7IesRUbiZ3ZQslx7yYGWqiOfCAClXjcf6bcgudq8E8wV+mEbLf
         WEGOtW6fdSPjt+cC2i+ffrdLKZUm+l7Lp7s5V9zvtCyjUeRT5WdtUGAOE8fC+LEPvum7
         K7/1EVCkW2+38DM88ecDZcBRJj/A0n9dDT41E=
Date: Sat, 2 Aug 2008 15:33:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] switch /proc/irq/*/smp_affinity et al to seqfiles
Message-ID: <20080802113339.GC3536@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch /proc/irq/*/smp_affinity , /proc/irq/default_smp_affinity to
seq_files.

cat(1) reads with 1024 chunks by default, with high enough NR_CPUS,
there will be -EINVAL.

As side effect twol less users of ->read_proc interface.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/irq/proc.c |   96 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 45 deletions(-)

--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -8,6 +8,7 @@
 
 #include <linux/irq.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
 #include "internals.h"
@@ -16,23 +17,18 @@ static struct proc_dir_entry *root_irq_dir;
 
 #ifdef CONFIG_SMP
 
-static int irq_affinity_read_proc(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_desc + (long)data;
+	struct irq_desc *desc = irq_desc + (long)m->private;
 	cpumask_t *mask = &desc->affinity;
-	int len;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
 		mask = &desc->pending_mask;
 #endif
-	len = cpumask_scnprintf(page, count, *mask);
-
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+	seq_cpumask(m, mask);
+	seq_putc(m, '\n');
+	return 0;
 }
 
 #ifndef is_affinity_mask_valid
@@ -40,11 +36,12 @@ static int irq_affinity_read_proc(char *page, char **start, off_t off,
 #endif
 
 int no_irq_affinity;
-static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
-				   unsigned long count, void *data)
+static ssize_t irq_affinity_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
 {
-	unsigned int irq = (int)(long)data, full_count = count, err;
+	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
 	cpumask_t new_value;
+	int err;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
@@ -65,28 +62,38 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 	if (!cpus_intersects(new_value, cpu_online_map))
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return irq_select_affinity(irq) ? -EINVAL : full_count;
+		return irq_select_affinity(irq) ? -EINVAL : count;
 
 	irq_set_affinity(irq, new_value);
 
-	return full_count;
+	return count;
 }
 
-static int default_affinity_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_affinity_proc_open(struct inode *inode, struct file *file)
 {
-	int len = cpumask_scnprintf(page, count, irq_default_affinity);
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+	return single_open(file, irq_affinity_proc_show, PDE(inode)->data);
 }
 
-static int default_affinity_write(struct file *file, const char __user *buffer,
-				   unsigned long count, void *data)
+static const struct file_operations irq_affinity_proc_fops = {
+	.open		= irq_affinity_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= irq_affinity_proc_write,
+};
+
+static int default_affinity_show(struct seq_file *m, void *v)
+{
+	seq_cpumask(m, &irq_default_affinity);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static ssize_t default_affinity_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	unsigned int full_count = count, err;
 	cpumask_t new_value;
+	int err;
 
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
@@ -105,8 +112,21 @@ static int default_affinity_write(struct file *file, const char __user *buffer,
 
 	irq_default_affinity = new_value;
 
-	return full_count;
+	return count;
 }
+
+static int default_affinity_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, default_affinity_show, NULL);
+}
+
+static const struct file_operations default_affinity_proc_fops = {
+	.open		= default_affinity_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= default_affinity_write,
+};
 #endif
 
 static int irq_spurious_read(char *page, char **start, off_t off,
@@ -178,16 +198,9 @@ void register_irq_proc(unsigned int irq)
 	irq_desc[irq].dir = proc_mkdir(name, root_irq_dir);
 
 #ifdef CONFIG_SMP
-	{
-		/* create /proc/irq/<irq>/smp_affinity */
-		entry = create_proc_entry("smp_affinity", 0600, irq_desc[irq].dir);
-
-		if (entry) {
-			entry->data = (void *)(long)irq;
-			entry->read_proc = irq_affinity_read_proc;
-			entry->write_proc = irq_affinity_write_proc;
-		}
-	}
+	/* create /proc/irq/<irq>/smp_affinity */
+	proc_create_data("smp_affinity", 0600, irq_desc[irq].dir,
+			 &irq_affinity_proc_fops, (void *)(long)irq);
 #endif
 
 	entry = create_proc_entry("spurious", 0444, irq_desc[irq].dir);
@@ -208,15 +221,8 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
-	struct proc_dir_entry *entry;
-
-	/* create /proc/irq/default_smp_affinity */
-	entry = create_proc_entry("default_smp_affinity", 0600, root_irq_dir);
-	if (entry) {
-		entry->data = NULL;
-		entry->read_proc  = default_affinity_read;
-		entry->write_proc = default_affinity_write;
-	}
+	proc_create("irq/default_smp_affinity", 0600, NULL,
+		    &default_affinity_proc_fops);
 #endif
 }
 
-- 
1.5.3.7


