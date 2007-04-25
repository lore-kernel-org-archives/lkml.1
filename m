Return-Path: <linux-kernel-owner+w=401wt.eu-S2992726AbXDYLj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992726AbXDYLj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992717AbXDYLj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:39:57 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47228 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992730AbXDYLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:39:56 -0400
Subject: [PATCH 8/10] __send_IPI_dest_field - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: horms@verge.net.au, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, vgoyal@in.ibm.com,
       mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 20:39:55 +0900
Message-Id: <1177501195.17974.42.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement __send_IPI_dest_field which can be used to send IPIs when the
"destination shorthand" field of the ICR is set to 00 (destination
field). Use it whenever possible.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc7-orig/arch/x86_64/kernel/genapic_flat.c linux-2.6.21-rc7/arch/x86_64/kernel/genapic_flat.c
--- linux-2.6.21-rc7-orig/arch/x86_64/kernel/genapic_flat.c	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc7/arch/x86_64/kernel/genapic_flat.c	2007-04-23 17:19:14.000000000 +0900
@@ -60,31 +60,10 @@ static void flat_init_apic_ldr(void)
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
 
diff -urNp linux-2.6.21-rc7-orig/include/asm-x86_64/ipi.h linux-2.6.21-rc7/include/asm-x86_64/ipi.h
--- linux-2.6.21-rc7-orig/include/asm-x86_64/ipi.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc7/include/asm-x86_64/ipi.h	2007-04-23 17:11:04.000000000 +0900
@@ -76,10 +76,39 @@ static inline void __send_IPI_shortcut(u
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
@@ -88,28 +117,9 @@ static inline void send_IPI_mask_sequenc
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


