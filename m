Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYHUI6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYHUI6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYHUI6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:58:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbYHUI6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:58:38 -0400
Date: Thu, 21 Aug 2008 10:58:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sparse_irq need spin_lock in alloc
Message-ID: <20080821085818.GB29541@elte.hu>
References: <1219290385-4976-1-git-send-email-yhlu.kernel@gmail.com> <20080820210336.3e6ffd6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820210336.3e6ffd6d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Each of these locks can be made local to the function in which they 
> are used (and hence they should be made local).
> 
> It would be nice to add a comment explaining what they are protecting, 
> unless that is obvious (I didn't look).

ok - i moved the locks next to the data structure they protect (the free 
list head), and added a small exlanation as well - as per the commit 
below.

	Ingo

--------------------->
>From 6feb0ac69551df02b49d11794ee77d3ad47aaeb3 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Wed, 20 Aug 2008 20:46:25 -0700
Subject: [PATCH] x86: sparse_irq needs spin_lock in allocations

Suresh Siddha noticed that we should have a spinlock around it.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |   10 ++++++++++
 kernel/irq/handle.c       |   10 ++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 34c74cf..d1370ce 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -146,6 +146,12 @@ static void init_one_irq_cfg(struct irq_cfg *cfg)
 }
 
 static struct irq_cfg *irq_cfgx;
+
+/*
+ * Protect the irq_cfgx_free freelist:
+ */
+static DEFINE_SPINLOCK(irq_cfg_lock);
+
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 static struct irq_cfg *irq_cfgx_free;
 #endif
@@ -226,6 +232,7 @@ static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
 		count++;
 	}
 
+	spin_lock(&irq_cfg_lock);
 	if (!irq_cfgx_free) {
 		unsigned long phys;
 		unsigned long total_bytes;
@@ -263,6 +270,9 @@ static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
 	else
 		irq_cfgx = cfg;
 	cfg->irq = irq;
+
+	spin_unlock(&irq_cfg_lock);
+
 	printk(KERN_DEBUG "found new irq_cfg for irq %d\n", cfg->irq);
 #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
 	{
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 24c83a3..2f02e14 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -107,6 +107,11 @@ static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 	}
 }
 
+/*
+ * Protect the sparse_irqs_free freelist:
+ */
+static DEFINE_SPINLOCK(sparse_irq_lock);
+
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 static struct irq_desc *sparse_irqs_free;
 struct irq_desc *sparse_irqs;
@@ -166,6 +171,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	}
 	return NULL;
 }
+
 struct irq_desc *irq_to_desc_alloc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
@@ -182,6 +188,7 @@ struct irq_desc *irq_to_desc_alloc(unsigned int irq)
 		count++;
 	}
 
+	spin_lock(&sparse_irq_lock);
 	/*
 	 *  we run out of pre-allocate ones, allocate more
 	 */
@@ -223,6 +230,9 @@ struct irq_desc *irq_to_desc_alloc(unsigned int irq)
 	else
 		sparse_irqs = desc;
 	desc->irq = irq;
+
+	spin_unlock(&sparse_irq_lock);
+
 	printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
 #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
 	{
