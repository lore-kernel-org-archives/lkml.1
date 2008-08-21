Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYHUDrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYHUDrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYHUDrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:47:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYHUDrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h2BxuQHSMw6uqR4JHcvdYaqq9A6SQKn83Ti5jNLwVJZ20KkBbNdqRZ9CRMSZMcEJWF
         jSQMtjUEVO768kxMwAz1QSvfndKUz0eqYG8xKE6XiW1ekM2Wae/BKl7WihRp6Vfvd+Ye
         opGynT2ItO+dpFxaAoNSDjsp+StYLUqONCC6E=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: sparse_irq need spin_lock in alloc
Date: Wed, 20 Aug 2008 20:46:25 -0700
Message-Id: <1219290385-4976-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acording to Suresh Siddha, we should have spin_lock around it

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |    6 ++++++
 kernel/irq/handle.c       |    7 +++++++
 2 files changed, 13 insertions(+)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -166,6 +166,9 @@ struct irq_desc *irq_to_desc(unsigned in
 	}
 	return NULL;
 }
+
+static DEFINE_SPINLOCK(sparse_irq_lock);
+
 struct irq_desc *irq_to_desc_alloc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
@@ -182,6 +185,7 @@ struct irq_desc *irq_to_desc_alloc(unsig
 		count++;
 	}
 
+	spin_lock(&sparse_irq_lock);
 	/*
 	 *  we run out of pre-allocate ones, allocate more
 	 */
@@ -223,6 +227,9 @@ struct irq_desc *irq_to_desc_alloc(unsig
 	else
 		sparse_irqs = desc;
 	desc->irq = irq;
+
+	spin_unlock(&sparse_irq_lock);
+
 	printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
 #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
 	{
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -210,6 +210,8 @@ static struct irq_cfg *irq_cfg(unsigned
 	return NULL;
 }
 
+static DEFINE_SPINLOCK(irq_cfg_lock);
+
 static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
 {
 	struct irq_cfg *cfg, *cfg_pri;
@@ -226,6 +228,7 @@ static struct irq_cfg *irq_cfg_alloc(uns
 		count++;
 	}
 
+	spin_lock(&irq_cfg_lock);
 	if (!irq_cfgx_free) {
 		unsigned long phys;
 		unsigned long total_bytes;
@@ -263,6 +266,9 @@ static struct irq_cfg *irq_cfg_alloc(uns
 	else
 		irq_cfgx = cfg;
 	cfg->irq = irq;
+
+	spin_unlock(&irq_cfg_lock);
+
 	printk(KERN_DEBUG "found new irq_cfg for irq %d\n", cfg->irq);
 #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
 	{
