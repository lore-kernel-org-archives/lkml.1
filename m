Return-Path: <linux-kernel-owner+w=401wt.eu-S1423489AbXD3QBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423489AbXD3QBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423504AbXD3P4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423451AbXD3Ptq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:46 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/34] x86_64: __send_IPI_dest_field - x86_64
Message-Id: <20070430154945.83282151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:45 +0200 (CEST)
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
 arch/x86_64/kernel/genapic_flat.c |   23 ----------------
 include/asm-x86_64/ipi.h          |   54 ++++++++++++++++++++++----------------
 2 files changed, 33 insertions(+), 44 deletions(-)

Index: linux/arch/x86_64/kernel/genapic_flat.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic_flat.c
+++ linux/arch/x86_64/kernel/genapic_flat.c
@@ -61,31 +61,10 @@ static void flat_init_apic_ldr(void)
 static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
 {
 	unsigned long mask = cpus_addr(cpumask)[0];
-	unsigned long cfg;
 	unsigned long flags;
 
 	local_irq_save(flags);
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	/*
-	 * prepare target chip field
-	 */
-	cfg = __prepare_ICR2(mask);
-	apic_write(APIC_ICR2, cfg);
-
-	/*
-	 * program the ICR
-	 */
-	cfg = __prepare_ICR(0, vector, APIC_DEST_LOGICAL);
-
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write(APIC_ICR, cfg);
+	__send_IPI_dest_field(mask, vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
Index: linux/include/asm-x86_64/ipi.h
===================================================================
--- linux.orig/include/asm-x86_64/ipi.h
+++ linux/include/asm-x86_64/ipi.h
@@ -74,10 +74,39 @@ static inline void __send_IPI_shortcut(u
 	apic_write(APIC_ICR, cfg);
 }
 
+/*
+ * This is used to send an IPI with no shorthand notation (the destination is
+ * specified in bits 56 to 63 of the ICR).
+ */
+static inline void __send_IPI_dest_field(unsigned int mask, int vector, unsigned int dest)
+{
+	unsigned long cfg;
+
+	/*
+	 * Wait for idle.
+	 */
+	apic_wait_icr_idle();
+
+	/*
+	 * prepare target chip field
+	 */
+	cfg = __prepare_ICR2(mask);
+	apic_write(APIC_ICR2, cfg);
+
+	/*
+	 * program the ICR
+	 */
+	cfg = __prepare_ICR(0, vector, dest);
+
+	/*
+	 * Send the IPI. The write to APIC_ICR fires this off.
+	 */
+	apic_write(APIC_ICR, cfg);
+}
 
 static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
 {
-	unsigned long cfg, flags;
+	unsigned long flags;
 	unsigned long query_cpu;
 
 	/*
@@ -86,28 +115,9 @@ static inline void send_IPI_mask_sequenc
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-
 	for_each_cpu_mask(query_cpu, mask) {
-		/*
-		 * Wait for idle.
-		 */
-		apic_wait_icr_idle();
-
-		/*
-		 * prepare target chip field
-		 */
-		cfg = __prepare_ICR2(x86_cpu_to_apicid[query_cpu]);
-		apic_write(APIC_ICR2, cfg);
-
-		/*
-		 * program the ICR
-		 */
-		cfg = __prepare_ICR(0, vector, APIC_DEST_PHYSICAL);
-
-		/*
-		 * Send the IPI. The write to APIC_ICR fires this off.
-		 */
-		apic_write(APIC_ICR, cfg);
+		__send_IPI_dest_field(x86_cpu_to_apicid[query_cpu],
+				      vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
