Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZH1STi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZH1STi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZH1STh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:19:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:17690 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZH1STf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uZ6kmGKJvMuOv9+VNKsYzDE8Vlu08Nqx0frxY67Fs5sVOLYjwv978ibvGo4YP+j38/
         krXHv5wokNvceclbxVi+v+X0EWW6O82ehZ+mGvoGUUIav0Kw3ZhBGgFhP+Y9AkzgzYjq
         XuSfeENtLEYrMuAKiJg/JmZJwntczTUQ3IsCM=
Date: Fri, 28 Aug 2009 22:19:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: switch /proc/irq/*/spurious to seq_file
Message-ID: <20090828181743.GA14050@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/irq/proc.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -148,18 +148,30 @@ static const struct file_operations default_affinity_proc_fops = {
 };
 #endif
 
-static int irq_spurious_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_to_desc((long) data);
-	return sprintf(page, "count %u\n"
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+	seq_printf(m, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
 			desc->irq_count,
 			desc->irqs_unhandled,
 			jiffies_to_msecs(desc->last_unhandled));
+	return 0;
 }
 
+static int irq_spurious_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_spurious_proc_show, NULL);
+}
+
+static const struct file_operations irq_spurious_proc_fops = {
+	.open		= irq_spurious_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -204,7 +216,6 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
-	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir || (desc->chip == &no_irq_chip) || desc->dir)
 		return;
@@ -221,11 +232,8 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 #endif
 
-	entry = create_proc_entry("spurious", 0444, desc->dir);
-	if (entry) {
-		entry->data = (void *)(long)irq;
-		entry->read_proc = irq_spurious_read;
-	}
+	proc_create_data("spurious", 0444, desc->dir,
+			 &irq_spurious_proc_fops, (void *)(long)irq);
 }
 
 #undef MAX_NAMELEN
