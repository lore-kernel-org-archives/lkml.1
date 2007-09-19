Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXISOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXISOlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXISOlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:41:04 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23450
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbXISOlC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:41:02 -0400
Message-Id: <46F15155.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 19 Sep 2007 15:41:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: also show non-zero IRQ counts for vectors that
	currently don't have a handler
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't seem to make sense to hide these, even if their counts
can't change at the point in time they're being displayed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/irq.c   |   18 ++++++++++++++----
 arch/x86_64/kernel/irq.c |   18 ++++++++++++++----
 2 files changed, 28 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc6/arch/i386/kernel/irq.c	2007-09-14 17:38:46.000000000 +0200
+++ 2.6.23-rc6-x86-irq-stats/arch/i386/kernel/irq.c	2007-09-17 15:16:59.000000000 +0200
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
--- linux-2.6.23-rc6/arch/x86_64/kernel/irq.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc6-x86-irq-stats/arch/x86_64/kernel/irq.c	2007-09-17 16:42:48.000000000 +0200
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



