Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYL0GjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYL0GjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYL0Giv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:38:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:50424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYL0Giv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:38:51 -0500
Message-ID: <4955CD57.8050702@kernel.org>
Date: Fri, 26 Dec 2008 22:38:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: venkatesh.pallipadi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: fix hang with !SPARSE_IRQ
References: <20081225020853.GI26490@linux-os.sc.intel.com>
In-Reply-To: <20081225020853.GI26490@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix hang

Suresh report his two sockets system only works with SPARSE_IRQ enable
it turns out we miss the setting desc->irq

so provide early_irq_init() even !SPARSE_IRQ to set desc->irq

Reported by: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 init/main.c         |    6 ------
 kernel/irq/handle.c |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -218,6 +218,21 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
+void __init early_irq_init(void)
+{
+	struct irq_desc *desc;
+	int count;
+	int i;
+
+	desc = irq_desc;
+	count = ARRAY_SIZE(irq_desc);
+
+	for (i = 0; i < count; i++)
+		desc[i].irq = i;
+
+	arch_early_irq_init();
+}
+
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -549,15 +549,9 @@ void __init __weak thread_info_cache_ini
 	barrier();
 }
 
-void __init __weak arch_early_irq_init(void)
-{
-	barrier();
-}
-
 void __init __weak early_irq_init(void)
 {
 	barrier();
-	arch_early_irq_init();
 }
 
 asmlinkage void __init start_kernel(void)
