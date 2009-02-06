Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZBFWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZBFWJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZBFWJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:09:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:35541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZBFWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:09:07 -0500
Message-ID: <498CB4DC.2010108@kernel.org>
Date: Fri, 06 Feb 2009 14:08:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] irq: clear kstat_irqs v2
References: <498CB0B7.8030009@kernel.org> <20090206140005.44b4bb50.akpm@linux-foundation.org>
In-Reply-To: <20090206140005.44b4bb50.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: get correct kstat_irqs for msi/msi-x etc

need to call clear_kstat_irqs(), so when reuse that irq_desc, could get correct
kstat in /proc/interrupts

also could make /proc/interrupts don't have none-<NULL> entries

don't need to worry about arch that doesn't support genirq, because they
will not call dynamic_irq_cleanup().

v2: simplify and make clear_kstat_irqs more rebust accord to Andrew

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/chip.c      |    1 +
 kernel/irq/handle.c    |    5 +++++
 kernel/irq/internals.h |    1 +
 3 files changed, 7 insertions(+)

Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -81,6 +81,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
 	desc->name = NULL;
+	clear_kstat_irqs(desc);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -270,6 +270,11 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
 }
 #endif /* !CONFIG_SPARSE_IRQ */
 
+void clear_kstat_irqs(struct irq_desc *desc)
+{
+	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+}
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -15,6 +15,7 @@ extern int __irq_set_trigger(struct irq_
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern void clear_kstat_irqs(struct irq_desc *desc);
 extern spinlock_t sparse_irq_lock;
 
 #ifdef CONFIG_SPARSE_IRQ
