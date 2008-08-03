Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYHCDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYHCDIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYHCDBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:01:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:10980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbYHCDBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gW4Ve8OExhXkuWq8mJkVt1bn7hnJdcjU/YJKXCBnhcqFX4+y2OrlovnxOhF/6vH7dK
         g7GLkivicpNL0m4r3JOUJOQQS0v+tYNlrHK6LIq+5ZFTfJn9vvBT4GKIg7ezfR63rlxz
         2sSYsBDEm2ERYSF+qyEFnEQVtApZKJqgXhdhE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 23/25] x86: use dyn_array in io_apic_xx.c
Date: Sat,  2 Aug 2008 19:59:23 -0700
Message-Id: <1217732365-16595-24-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-23-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-23-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |   54 +++++++++++++++++++++++++++++++++--------
 arch/x86/kernel/io_apic_64.c |   28 ++++++++++++++++-----
 arch/x86/kernel/setup.c      |    6 ++++
 3 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index d5953ff..a0ce64c 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -70,7 +70,7 @@ int timer_through_8259 __initdata;
  */
 int sis_apic_bug = -1;
 
-int first_free_entry = NR_IRQS;
+int first_free_entry;
 /*
  * # of IRQ routing registers
  */
@@ -98,10 +98,7 @@ static int disable_timer_pin_1 __initdata;
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
@@ -403,9 +402,28 @@ static struct irq_cpu_info {
 
 #define CPU_TO_PACKAGEINDEX(i) (first_cpu(per_cpu(cpu_sibling_map, i)))
 
-static cpumask_t balance_irq_affinity[NR_IRQS] = {
-	[0 ... NR_IRQS-1] = CPU_MASK_ALL
-};
+static cpumask_t balance_irq_affinity_init __initdata = CPU_MASK_ALL;
+
+static cpumask_t *balance_irq_affinity;
+
+
+static void __init irq_affinity_init_work(void *data)
+{
+	struct dyn_array *da = data;
+
+	int i;
+	struct  balance_irq_affinity *affinity;
+
+	affinity = *da->name;
+
+	for (i = 0; i < *da->nr; i++)
+		memcpy(&affinity[i], &balance_irq_affinity_init,
+			 sizeof(struct balance_irq_affinity));
+
+}
+
+DEFINE_DYN_ARRAY(balance_irq_affinity, sizeof(struct balance_irq_affinity), nr_irqs, PAGE_SIZE, irq_affinity_init_work);
+
 
 void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
 {
@@ -1170,14 +1188,28 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
+static u8 irq_vector_init_first __initdata = FIRST_DEVICE_VECTOR;
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
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 456f2e7..9bcb6c2 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -66,7 +66,7 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
+static struct irq_cfg irq_cfg_legacy[] __initdata = {
 	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
 	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
 	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
@@ -85,6 +85,17 @@ static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
+static struct irq_cfg *irq_cfg;
+
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+
+	memcpy(*da->name, irq_cfg_legacy, sizeof(irq_cfg_legacy));
+}
+
+DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+
 static int assign_irq_vector(int irq, cpumask_t mask);
 
 int first_system_vector = 0xfe;
@@ -129,10 +140,9 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
  */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
-int pin_map_size = PIN_MAP_SIZE;
+int pin_map_size;
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -141,8 +151,12 @@ int pin_map_size = PIN_MAP_SIZE;
  */
 
 static struct irq_pin_list {
-	short apic, pin, next;
-} irq_2_pin[PIN_MAP_SIZE];
+	short apic, pin;
+	int next;
+} *irq_2_pin;
+
+DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);
+
 
 struct io_apic {
 	unsigned int index;
@@ -359,7 +373,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-int first_free_entry = NR_IRQS;
+int first_free_entry;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
 	struct irq_pin_list *entry = irq_2_pin + irq;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 60e8de1..39c5106 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -856,9 +856,15 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	prefill_possible_map();
+
 #ifdef CONFIG_X86_64
+	/* need to wait for nr_cpu_ids settle down */
+	if (nr_irqs == NR_IRQS)
+		nr_irqs = 32 * nr_cpu_ids + 224;
 	init_cpu_to_node();
 #endif
+	pin_map_size = nr_irqs * 2;
+	first_free_entry = nr_irqs;
 
 	init_apic_mappings();
 	ioapic_init_mappings();
-- 
1.5.4.5

