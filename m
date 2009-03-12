Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZCLXHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZCLXHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZCLXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:07:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZCLXHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:07:11 -0400
Date: Thu, 12 Mar 2009 23:06:34 GMT
From: Magnus Damm <damm@igel.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312120551.2926.43942.sendpatchset@rx1.opensource.se>
References: <20090312120551.2926.43942.sendpatchset@rx1.opensource.se>
Subject: [tip:irq/genirq] irq: match remove_irq() args with setup_irq()
Message-ID: <tip-cbf94f06824780183e4bba165c7c29d5c7bd9a51@git.kernel.org>
Git-Commit-ID: cbf94f06824780183e4bba165c7c29d5c7bd9a51
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 23:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbf94f06824780183e4bba165c7c29d5c7bd9a51
Gitweb:     http://git.kernel.org/tip/cbf94f06824780183e4bba165c7c29d5c7bd9a51
Author:     Magnus Damm <damm@igel.co.jp>
AuthorDate: Thu, 12 Mar 2009 21:05:51 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 13:16:33 +0100

irq: match remove_irq() args with setup_irq()

Modify remove_irq() to match setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
LKML-Reference: <20090312120551.2926.43942.sendpatchset@rx1.opensource.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irq.h |    2 +-
 kernel/irq/manage.c |   26 +++++++++++++++++---------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 56f9988..737eafb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -236,7 +236,7 @@ typedef struct irq_desc		irq_desc_t;
 #include <asm/hw_irq.h>
 
 extern int setup_irq(unsigned int irq, struct irqaction *new);
-extern struct irqaction *remove_irq(unsigned int irq, void *dev_id);
+extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8b069a7..fc16570 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -550,15 +550,11 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 	return __setup_irq(irq, desc, act);
 }
 
-/**
- *	remove_irq - free an interrupt
- *	@irq: Interrupt line to free
- *	@dev_id: Device identity to free
- *
- * Used to remove interrupts statically setup by the early boot process.
+ /*
+ * Internal function to unregister an irqaction - used to free
+ * regular and special interrupts that are part of the architecture.
  */
-
-struct irqaction *remove_irq(unsigned int irq, void *dev_id)
+static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
@@ -634,6 +630,18 @@ struct irqaction *remove_irq(unsigned int irq, void *dev_id)
 }
 
 /**
+ *	remove_irq - free an interrupt
+ *	@irq: Interrupt line to free
+ *	@act: irqaction for the interrupt
+ *
+ * Used to remove interrupts statically setup by the early boot process.
+ */
+void remove_irq(unsigned int irq, struct irqaction *act)
+{
+	__free_irq(irq, act->dev_id);
+}
+
+/**
  *	free_irq - free an interrupt allocated with request_irq
  *	@irq: Interrupt line to free
  *	@dev_id: Device identity to free
@@ -649,7 +657,7 @@ struct irqaction *remove_irq(unsigned int irq, void *dev_id)
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
-	kfree(remove_irq(irq, dev_id));
+	kfree(__free_irq(irq, dev_id));
 }
 EXPORT_SYMBOL(free_irq);
 
