Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbYACPnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbYACPnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYACPmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:23 -0500
Received: from ns.suse.de ([195.135.220.2]:48617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYACPmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH x86] [4/16] Add /proc/irq/*/spurious to dump the spurious irq debugging state
Message-Id: <20080103154217.E57A714DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is useful to debug problems with interrupt handlers that return
sometimes IRQ_NONE.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/irq/proc.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux/kernel/irq/proc.c
===================================================================
--- linux.orig/kernel/irq/proc.c
+++ linux/kernel/irq/proc.c
@@ -75,6 +75,18 @@ static int irq_affinity_write_proc(struc
 
 #endif
 
+static int irq_spurious_read(char *page, char **start, off_t off,
+				  int count, int *eof, void *data)
+{
+	struct irq_desc *d = &irq_desc[(long) data];
+	return sprintf(page, "count %u\n"
+			     "unhandled %u\n"
+			     "last_unhandled %u ms\n",
+			d->irq_count,
+			d->irqs_unhandled,
+			jiffies_to_msecs(d->last_unhandled));
+}
+
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -118,6 +130,7 @@ void register_handler_proc(unsigned int 
 void register_irq_proc(unsigned int irq)
 {
 	char name [MAX_NAMELEN];
+	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir ||
 		(irq_desc[irq].chip == &no_irq_chip) ||
@@ -132,8 +145,6 @@ void register_irq_proc(unsigned int irq)
 
 #ifdef CONFIG_SMP
 	{
-		struct proc_dir_entry *entry;
-
 		/* create /proc/irq/<irq>/smp_affinity */
 		entry = create_proc_entry("smp_affinity", 0600, irq_desc[irq].dir);
 
@@ -144,6 +155,12 @@ void register_irq_proc(unsigned int irq)
 		}
 	}
 #endif
+
+	entry = create_proc_entry("spurious", 0444, irq_desc[irq].dir);
+	if (entry) {
+		entry->data = (void *)(long)irq;
+		entry->read_proc = irq_spurious_read;
+	}
 }
 
 #undef MAX_NAMELEN
