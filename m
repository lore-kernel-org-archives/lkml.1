Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZBGHui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZBGHui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBGHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:50:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZBGHu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:50:29 -0500
Message-ID: <498D3D15.5090005@kernel.org>
Date: Fri, 06 Feb 2009 23:49:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
References: <498CB0B7.8030009@kernel.org> <20090206140005.44b4bb50.akpm@linux-foundation.org> <498CB4DC.2010108@kernel.org>
In-Reply-To: <498CB4DC.2010108@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: even later type of kstat_irqs is changed

simplify and make init_kstat_irqs etc more type prof according to Andrew

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c       |   20 +++++++++++---------
 kernel/irq/numa_migrate.c |   11 +++--------
 2 files changed, 14 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -82,19 +82,21 @@ static struct irq_desc irq_desc_init = {
 
 void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 {
-	unsigned long bytes;
-	char *ptr;
 	int node;
-
-	/* Compute how many bytes we need per irq and allocate them */
-	bytes = nr * sizeof(unsigned int);
+	void *ptr;
 
 	node = cpu_to_node(cpu);
-	ptr = kzalloc_node(bytes, GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
 
-	if (ptr)
-		desc->kstat_irqs = (unsigned int *)ptr;
+	/*
+	 * don't overwite if can not get new one
+	 * init_copy_kstat_irqs() could still use old one
+	 */
+	if (ptr) {
+		printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n",
+			 cpu, node);
+		desc->kstat_irqs = ptr;
+	}
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -17,16 +17,11 @@ static void init_copy_kstat_irqs(struct
 				 struct irq_desc *desc,
 				 int cpu, int nr)
 {
-	unsigned long bytes;
-
 	init_kstat_irqs(desc, cpu, nr);
 
-	if (desc->kstat_irqs != old_desc->kstat_irqs) {
-		/* Compute how many bytes we need per irq and allocate them */
-		bytes = nr * sizeof(unsigned int);
-
-		memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
-	}
+	if (desc->kstat_irqs != old_desc->kstat_irqs)
+		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
+			 nr * sizeof(*desc->kstat_irqs));
 }
 
 static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
