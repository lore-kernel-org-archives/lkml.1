Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXIUWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXIUWun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764202AbXIUWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762371AbXIUWcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:47 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [46/50] x86: also show non-zero IRQ counts for vectors that  currently don't have a handler
Message-Id: <20070921223246.CC4EA13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
It doesn't seem to make sense to hide these, even if their counts
can't change at the point in time they're being displayed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/irq.c   |   18 ++++++++++++++----
 arch/x86_64/kernel/irq.c |   18 ++++++++++++++----
 2 files changed, 28 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/irq.c
===================================================================
--- linux.orig/arch/i386/kernel/irq.c
+++ linux/arch/i386/kernel/irq.c
@@ -259,9 +259,17 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
+		unsigned any_count = 0;
+
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
+#ifndef CONFIG_SMP
+		any_count = kstat_irqs(i);
+#else
+		for_each_online_cpu(j)
+			any_count |= kstat_cpu(j).irqs[i];
+#endif
 		action = irq_desc[i].action;
-		if (!action)
+		if (!action && !any_count)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
 #ifndef CONFIG_SMP
@@ -272,10 +280,12 @@ int show_interrupts(struct seq_file *p, 
 #endif
 		seq_printf(p, " %8s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
-		seq_printf(p, "  %s", action->name);
 
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
+		if (action) {
+			seq_printf(p, "  %s", action->name);
+			while ((action = action->next) != NULL)
+				seq_printf(p, ", %s", action->name);
+		}
 
 		seq_putc(p, '\n');
 skip:
Index: linux/arch/x86_64/kernel/irq.c
===================================================================
--- linux.orig/arch/x86_64/kernel/irq.c
+++ linux/arch/x86_64/kernel/irq.c
@@ -64,9 +64,17 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
+		unsigned any_count = 0;
+
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
+#ifndef CONFIG_SMP
+		any_count = kstat_irqs(i);
+#else
+		for_each_online_cpu(j)
+			any_count |= kstat_cpu(j).irqs[i];
+#endif
 		action = irq_desc[i].action;
-		if (!action) 
+		if (!action && !any_count)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
 #ifndef CONFIG_SMP
@@ -78,9 +86,11 @@ int show_interrupts(struct seq_file *p, 
 		seq_printf(p, " %8s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 
-		seq_printf(p, "  %s", action->name);
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
+		if (action) {
+			seq_printf(p, "  %s", action->name);
+			while ((action = action->next) != NULL)
+				seq_printf(p, ", %s", action->name);
+		}
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
