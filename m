Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZKRLy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZKRLy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZKRLy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:54:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:48042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZKRLyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:54:55 -0500
Date: Wed, 18 Nov 2009 11:54:34 GMT
From: tip-bot for Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, adobriyan@gmail.com
In-Reply-To: <20090828181743.GA14050@x200.localdomain>
References: <20090828181743.GA14050@x200.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: switch /proc/irq/*/spurious to seq_file
Message-ID: <tip-a1afb6371bb5341057056194d1168753f6d77242@git.kernel.org>
Git-Commit-ID: a1afb6371bb5341057056194d1168753f6d77242
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1afb6371bb5341057056194d1168753f6d77242
Gitweb:     http://git.kernel.org/tip/a1afb6371bb5341057056194d1168753f6d77242
Author:     Alexey Dobriyan <adobriyan@gmail.com>
AuthorDate: Fri, 28 Aug 2009 22:19:33 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Nov 2009 12:50:51 +0100

genirq: switch /proc/irq/*/spurious to seq_file

[ tglx: compacted it a bit ]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
LKML-Reference: <20090828181743.GA14050@x200.localdomain>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/proc.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index dfef5b9..4e47f11 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -148,18 +148,28 @@ static const struct file_operations default_affinity_proc_fops = {
 };
 #endif
 
-static int irq_spurious_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_to_desc((long) data);
-	return sprintf(page, "count %u\n"
-			     "unhandled %u\n"
-			     "last_unhandled %u ms\n",
-			desc->irq_count,
-			desc->irqs_unhandled,
-			jiffies_to_msecs(desc->last_unhandled));
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+
+	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
+		   desc->irq_count, desc->irqs_unhandled,
+		   jiffies_to_msecs(desc->last_unhandled));
+	return 0;
+}
+
+static int irq_spurious_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_spurious_proc_show, NULL);
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
@@ -204,7 +214,6 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
-	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir || (desc->chip == &no_irq_chip) || desc->dir)
 		return;
@@ -223,11 +232,8 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
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
