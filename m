Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYEGVkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYEGVkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYEGVka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:40:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:64693 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYEGVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=siZCZHaxLRdhfgVuYsFLZ1DHXWEww8BlN8WQ2gNFXRKWOwvCkh1Bd9bf6SzLOl1/4yJeJaEAH3Bueg42Ffpz9mgXwnlpvonEzZqmpmLUOOLF/f/ZkzPAJZwfkvSlkEfRyYChjFa/yDQSQ3BUc2k+bKuLh+gGW2clovsvDhFZuxo=
Date: Thu, 8 May 2008 02:35:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] proc: convert /proc/irq/*/{smp_affinity,spurious} to
	seq_files
Message-ID: <20080507223548.GE14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	Don't even think applying this before fixed
	bitmask_scnprintf_len()!

 kernel/irq/proc.c |   78 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -8,6 +8,7 @@
 
 #include <linux/irq.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
 #include "internals.h"
@@ -16,23 +17,23 @@ static struct proc_dir_entry *root_irq_dir;
 
 #ifdef CONFIG_SMP
 
-static int irq_affinity_read_proc(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_desc + (long)data;
+	struct irq_desc *desc = irq_desc + (long)v;
 	cpumask_t *mask = &desc->affinity;
-	int len;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
 		mask = &desc->pending_mask;
 #endif
-	len = cpumask_scnprintf(page, count, *mask);
+	seq_cpumask(m, mask);
+	seq_putc(m, '\n');
+	return 0;
+}
 
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+static int irq_affinity_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_affinity_proc_show, PDE(inode)->data);
 }
 
 #ifndef is_affinity_mask_valid
@@ -40,11 +41,12 @@ static int irq_affinity_read_proc(char *page, char **start, off_t off,
 #endif
 
 int no_irq_affinity;
-static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
-				   unsigned long count, void *data)
+static ssize_t irq_affinity_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	unsigned int irq = (int)(long)data, full_count = count, err;
+	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
 	cpumask_t new_value, tmp;
+	int err;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
@@ -66,27 +68,46 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 	if (cpus_empty(tmp))
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return select_smp_affinity(irq) ? -EINVAL : full_count;
+		return select_smp_affinity(irq) ? -EINVAL : count;
 
 	irq_set_affinity(irq, new_value);
 
-	return full_count;
+	return count;
 }
 
+static const struct file_operations irq_affinity_proc_fops = {
+	.open		= irq_affinity_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= irq_affinity_proc_write,
+};
 #endif
 
-static int irq_spurious_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *d = &irq_desc[(long) data];
-	return sprintf(page, "count %u\n"
+	struct irq_desc *d = &irq_desc[(long) m->private];
+	seq_printf(m, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
 			d->irq_count,
 			d->irqs_unhandled,
 			jiffies_to_msecs(d->last_unhandled));
+	return 0;
+}
+
+static int irq_spurious_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations irq_spurious_proc_fops = {
+	.open		= irq_spurious_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -130,7 +151,6 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 void register_irq_proc(unsigned int irq)
 {
 	char name [MAX_NAMELEN];
-	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir ||
 		(irq_desc[irq].chip == &no_irq_chip) ||
@@ -144,23 +164,13 @@ void register_irq_proc(unsigned int irq)
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
 
-	entry = create_proc_entry("spurious", 0444, irq_desc[irq].dir);
-	if (entry) {
-		entry->data = (void *)(long)irq;
-		entry->read_proc = irq_spurious_read;
-	}
+	proc_create_data("spurious", 0444, irq_desc[irq].dir,
+			 &irq_spurious_proc_fops, (void *)(long)irq);
 }
 
 #undef MAX_NAMELEN

