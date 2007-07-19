Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbXGSJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbXGSJ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXGSJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:33032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbXGSJyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:50 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/58] x86_64: Report the pending irq if available in smp_affinity
Message-Id: <20070719095449.15A2D14E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise smp_affinity would only update after the next interrupt
on x86 systems.

Cc: tglx@linutronix.de
Cc: mingo@elte.hu

Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/irq/proc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/kernel/irq/proc.c
===================================================================
--- linux.orig/kernel/irq/proc.c
+++ linux/kernel/irq/proc.c
@@ -19,7 +19,14 @@ static struct proc_dir_entry *root_irq_d
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, irq_desc[(long)data].affinity);
+	struct irq_desc *desc = irq_desc + (long)data;
+	cpumask_t *mask = &desc->affinity;
+	int len;
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (desc->status & IRQ_MOVE_PENDING)
+		mask = &desc->pending_mask;
+#endif
+	len = cpumask_scnprintf(page, count, *mask);
 
 	if (count - len < 2)
 		return -EINVAL;
