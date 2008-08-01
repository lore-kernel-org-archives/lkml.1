Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYHAJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYHAJkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYHAJim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYHAJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cSHTAxgROpWa4oJ+EhvqnGmHZYMwwQvqrlgkpwAkiqF7drFydjjH0WL4Qtt1n1NYFS
         kS4il/EZ5325RB9CiQ03jUbNzy+GZRowzr3mcGeraEK2ESusWbTCiSw2jiRjpqOWjCIp
         DUMAVNWIPCJiSUbFWidCT5XxdneD7x9glknYQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 07/16] x86: make 64bit support dyn_array
Date: Fri,  1 Aug 2008 02:37:35 -0700
Message-Id: <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set nr_irqs according to nr_cpu_ids, so could get small footprint when use
big kernel.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/Kconfig                     |    2 ++
 arch/x86/Kconfig                 |    1 +
 arch/x86/kernel/io_apic_64.c     |   28 +++++++++++++++++++++-------
 arch/x86/kernel/setup.c          |    6 ++++++
 arch/x86/kernel/vmlinux_64.lds.S |    3 +++
 5 files changed, 33 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -103,3 +103,5 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DYN_ARRAY
+	def_bool n
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -33,6 +33,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_DYN_ARRAY if X86_64
 
 config ARCH_DEFCONFIG
 	string
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -66,7 +66,7 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
+static struct irq_cfg irq_cfg_legacy[] __initdata = {
 	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
 	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
 	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
@@ -85,6 +85,17 @@ static struct irq_cfg irq_cfg[NR_IRQS] _
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
@@ -129,10 +140,9 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
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
@@ -359,7 +373,7 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-int first_free_entry = NR_IRQS;
+int first_free_entry;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
 	struct irq_pin_list *entry = irq_2_pin + irq;
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -856,7 +856,13 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	prefill_possible_map();
+
 #ifdef CONFIG_X86_64
+	/* need to wait for nr_cpu_ids settle down */
+	if (nr_irqs == NR_IRQS)
+		nr_irqs = 32 * nr_cpu_ids + 224;
+	pin_map_size = nr_irqs * 2;
+	first_free_entry = nr_irqs;
 	init_cpu_to_node();
 #endif
 
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -174,6 +174,9 @@ SECTIONS
 	*(.x86cpuvendor.init)
   }
   __x86cpuvendor_end = .;
+
+  DYN_ARRAY_INIT(8)
+
   SECURITY_INIT
 
   . = ALIGN(8);
