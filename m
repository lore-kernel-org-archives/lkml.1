Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZD2Q2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZD2Q2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZD2Q2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:28:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:42654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZD2Q2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:28:42 -0400
Message-ID: <49F87FF3.1090600@kernel.org>
Date: Wed, 29 Apr 2009 09:27:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: using move_irq_desc
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org> <20090429120056.GE11586@elte.hu>
In-Reply-To: <20090429120056.GE11586@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move_irq_desc will try to move irq_desc to node wanted if allocated one is not correct.
(happen on device on different nodes that are using MSI, drivers are loaded and unloaded
randomly)

[ Impact: make irq_desc go with device on node ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    6 +-----
 include/linux/irq.h            |    4 ++++
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3155,11 +3155,7 @@ unsigned int create_irq_nr(unsigned int
 		if (cfg_new->vector != 0)
 			continue;
 
-#ifdef CONFIG_NUMA_IRQ_DESC
-		/* different node ?*/
-		if (desc_new->node != node)
-			desc = move_irq_desc(desc, node);
-#endif
+		desc_new = move_irq_desc(desc_new, node);
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -206,6 +206,10 @@ extern void arch_free_chip_data(struct i
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
+static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
+{
+	return desc;
+}
 #else /* CONFIG_SPARSE_IRQ */
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
 #endif /* CONFIG_SPARSE_IRQ */
