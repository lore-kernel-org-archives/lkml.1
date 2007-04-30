Return-Path: <linux-kernel-owner+w=401wt.eu-S1423515AbXD3P7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423515AbXD3P7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423453AbXD3P4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423452AbXD3Ptq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:46 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/34] i386: __send_IPI_dest_field - i386
Message-Id: <20070430154944.736FF151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis [** ISO-8859-1 charset **] VázquezCao <fernando@oss.ntt.co.jp>
Implement __send_IPI_dest_field which can be used to send IPIs when the
"destination shorthand" field of the ICR is set to 00 (destination
field). Use it whenever possible.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/smp.c |   47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -165,16 +165,13 @@ void fastcall send_IPI_self(int vector)
 }
 
 /*
- * This is only used on smaller machines.
+ * This is used to send an IPI with no shorthand notation (the destination is
+ * specified in bits 56 to 63 of the ICR).
  */
-void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
+static inline void __send_IPI_dest_field(unsigned long mask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
 	unsigned long cfg;
-	unsigned long flags;
 
-	local_irq_save(flags);
-	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
 	/*
 	 * Wait for idle.
 	 */
@@ -195,13 +192,25 @@ void send_IPI_mask_bitmask(cpumask_t cpu
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
 	apic_write_around(APIC_ICR, cfg);
+}
 
+/*
+ * This is only used on smaller machines.
+ */
+void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
+{
+	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long flags;
+
+	local_irq_save(flags);
+	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
+	__send_IPI_dest_field(mask, vector);
 	local_irq_restore(flags);
 }
 
 void send_IPI_mask_sequence(cpumask_t mask, int vector)
 {
-	unsigned long cfg, flags;
+	unsigned long flags;
 	unsigned int query_cpu;
 
 	/*
@@ -211,30 +220,10 @@ void send_IPI_mask_sequence(cpumask_t ma
 	 */ 
 
 	local_irq_save(flags);
-
 	for (query_cpu = 0; query_cpu < NR_CPUS; ++query_cpu) {
 		if (cpu_isset(query_cpu, mask)) {
-		
-			/*
-			 * Wait for idle.
-			 */
-			apic_wait_icr_idle();
-		
-			/*
-			 * prepare target chip field
-			 */
-			cfg = __prepare_ICR2(cpu_to_logical_apicid(query_cpu));
-			apic_write_around(APIC_ICR2, cfg);
-		
-			/*
-			 * program the ICR 
-			 */
-			cfg = __prepare_ICR(0, vector);
-			
-			/*
-			 * Send the IPI. The write to APIC_ICR fires this off.
-			 */
-			apic_write_around(APIC_ICR, cfg);
+			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
+					      vector);
 		}
 	}
 	local_irq_restore(flags);
