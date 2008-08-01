Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYHAJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYHAJmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbYHAJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:16382 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbYHAJiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tF6Euwkak2GkkVWhoVJmh1KlhjhcnoeCoF9pdqznymZx0/DwlrtCuAiFmvwNHDFXg2
         2t95GbPCLWnW7ym8ynU3l7kvcVkPi9CRZEZQlBZ5H9PFhiUkvPssF41QiUB1iBh5yN83
         25YjKLl2OqmG6ax+lGYqkaYMxeqj9Q/s/mrjk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 15/16] x86: make 32bit more like with io_apic/dyn_array to 64 bit
Date: Fri,  1 Aug 2008 02:37:43 -0700
Message-Id: <1217583464-28494-16-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-15-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-14-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-15-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also remove NR_IRQ_VECTORS

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c  |   53 +++++++++++++++++++++++++++++++++---------
 arch/x86/kernel/setup.c       |    4 +--
 include/asm-x86/irq_vectors.h |    2 -
 3 files changed, 44 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -70,7 +70,7 @@ int timer_through_8259 __initdata;
  */
 int sis_apic_bug = -1;
 
-int first_free_entry = NR_IRQS;
+int first_free_entry;
 /*
  * # of IRQ routing registers
  */
@@ -98,10 +98,7 @@ static int disable_timer_pin_1 __initdat
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
  */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
-
-int pin_map_size = PIN_MAP_SIZE;
+int pin_map_size;
 
 /*
  * This is performance-critical, we want to do it O(1)
@@ -112,7 +109,9 @@ int pin_map_size = PIN_MAP_SIZE;
 
 static struct irq_pin_list {
 	int apic, pin, next;
-} irq_2_pin[PIN_MAP_SIZE];
+} *irq_2_pin;
+
+DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct irq_pin_list), pin_map_size, 16, NULL);
 
 struct io_apic {
 	unsigned int index;
@@ -403,9 +402,27 @@ static struct irq_cpu_info {
 
 #define CPU_TO_PACKAGEINDEX(i) (first_cpu(per_cpu(cpu_sibling_map, i)))
 
-static cpumask_t balance_irq_affinity[NR_IRQS] = {
-	[0 ... NR_IRQS-1] = CPU_MASK_ALL
-};
+static cpumask_t balance_irq_affinity_init = CPU_MASK_ALL;
+
+static cpumask_t *balance_irq_affinity;
+
+
+static void __init irq_affinity_init_work(void *data)
+{
+        struct dyn_array *da = data;
+
+        int i;
+        struct  balance_irq_affinity *affinity;
+
+        affinity = *da->name;
+
+        for (i = 0; i < *da->nr; i++)
+                memcpy(&affinity[i], &balance_irq_affinity_init, sizeof(struct balance_irq_affinity));
+
+}
+
+DEFINE_DYN_ARRAY(balance_irq_affinity, sizeof(struct balance_irq_affinity), nr_irqs, PAGE_SIZE, irq_affinity_init_work);
+
 
 void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
 {
@@ -1170,14 +1187,28 @@ static inline int IO_APIC_irq_trigger(in
 }
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
+static u8 irq_vector_init_first = FIRST_DEVICE_VECTOR;
+static u8 *irq_vector;
+
+static void __init irq_vector_init_work(void *data)
+{
+	struct dyn_array *da = data;
+
+	u8 *irq_vec;
+
+	irq_vec = *da->name;
+
+	irq_vec[0] = irq_vector_init_first;
+}
+
+DEFINE_DYN_ARRAY(irq_vector, sizeof(u8), nr_irqs, PAGE_SIZE, irq_vector_init_work);
 
 static int __assign_irq_vector(int irq)
 {
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset;
 	int vector, offset;
 
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
+	BUG_ON((unsigned)irq >= nr_irqs);
 
 	if (irq_vector[irq] > 0)
 		return irq_vector[irq];
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -861,10 +861,10 @@ void __init setup_arch(char **cmdline_p)
 	/* need to wait for nr_cpu_ids settle down */
 	if (nr_irqs == NR_IRQS)
 		nr_irqs = 32 * nr_cpu_ids + 224;
-	pin_map_size = nr_irqs * 2;
-	first_free_entry = nr_irqs;
 	init_cpu_to_node();
 #endif
+	pin_map_size = nr_irqs * 2;
+	first_free_entry = nr_irqs;
 
 	init_apic_mappings();
 	ioapic_init_mappings();
Index: linux-2.6/include/asm-x86/irq_vectors.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq_vectors.h
+++ linux-2.6/include/asm-x86/irq_vectors.h
@@ -131,8 +131,6 @@
 
 #endif /* VISWS */
 
-#define NR_IRQ_VECTORS		NR_IRQS
-
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
 #define VIC_CPI_LEVEL0			0
