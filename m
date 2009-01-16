Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZAPG0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZAPG0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZAPG0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:26:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:48208 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZAPG0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Zxh/DYgLQgHWcOzXtpB6mt4FHMGTvCRh57u8LQ1zjtltOqKgMzJnDPN0z8KxSrTHEN
         Qo4F3ZRmZpvIGZdrsXsAwxSshwps5wbThU0F9Gq6JgELteISWKVrSZ+9OWIduLeNEKj5
         oPseOGPU2wctXRAd+zkZ0h/TOkn+rJ5Zzw1Jk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       akpm@linux-foundation.org
Date: Fri, 16 Jan 2009 15:24:40 +0900
Message-Id: <20090116062440.19672.53317.sendpatchset@rx1.opensource.se>
Subject: [RESEND][PATCH] Free setup_irq() interrupt using free_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds support for using free_irq() on interrupts
allocated with setup_irq(). Without this patch the kernel
will try to kfree() the struct irqaction passed as argument
to setup_irq().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 This patch was previously posted to LKML 2008-11-25.

 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- 0001/include/linux/interrupt.h
+++ work/include/linux/interrupt.h	2008-11-25 19:43:40.000000000 +0900
@@ -48,6 +48,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_STATIC - Interrupt requested with setup_irq(), do not kfree().
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -57,6 +58,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_STATIC		0x00002000
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
--- 0001/kernel/irq/manage.c
+++ work/kernel/irq/manage.c	2008-11-25 19:44:14.000000000 +0900
@@ -509,6 +509,7 @@ int setup_irq(unsigned int irq, struct i
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	act->flags |= IRQF_STATIC;
 	return __setup_irq(irq, desc, act);
 }
 
@@ -585,7 +586,8 @@ void free_irq(unsigned int irq, void *de
 				local_irq_restore(flags);
 			}
 #endif
-			kfree(action);
+			if (!(action->flags & IRQF_STATIC))
+				kfree(action);
 			return;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
