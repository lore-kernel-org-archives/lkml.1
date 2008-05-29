Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYE2Pl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYE2Pl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYE2Plu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:41:50 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:64671 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYE2Plt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:41:49 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Patch/RFC]: check CONFIG_GENERIC_HARDIRQS for request/free_irq in interrupt.h
Date: Thu, 29 May 2008 17:41:13 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291741.13956.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I currently try to evaluate virtio_console for kvm on s390 and got
the following problem:

virtio_console uses hvc_alloc with irq=0. That means, register_irq
and free_irq are never called by hvc_console.c, but the linker will
still complain about unknown references to free_irq and request_irq.

As the whole kernel/irq folder depends on CONFIG_GENERIC_HARDIRQS 
it seems consistent to declare all functions from kernel/irq only if
CONFIG_GENERIC_HARDIRQS is set. Otherwise we can use empty functions.

This patch does that for register_irq and free_irq. 

Comments?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/interrupt.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -69,9 +69,22 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
+
+#ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
+#else
+static inline int request_irq(unsigned int irq, irq_handler_t handler,
+		unsigned long irqflags, const char *devname, void *dev_id)
+{
+	return -EINVAL;
+}
+
+static inline void free_irq(unsigned int irq, void *dev_id)
+{
+}
+#endif
 
 struct device;
 
