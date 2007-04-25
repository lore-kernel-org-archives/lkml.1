Return-Path: <linux-kernel-owner+w=401wt.eu-S2992724AbXDYLh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992724AbXDYLh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992723AbXDYLh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:37:57 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47216 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992726AbXDYLh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:37:56 -0400
Subject: [PATCH 7/10] __send_IPI_dest_field - i386
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
Date: Wed, 25 Apr 2007 20:37:55 +0900
Message-Id: <1177501075.17974.40.camel@sebastian.intellilink.co.jp>
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

diff -urNp linux-2.6.21-rc7-orig/arch/i386/kernel/smp.c linux-2.6.21-rc7/arch/i386/kernel/smp.c
--- linux-2.6.21-rc7-orig/arch/i386/kernel/smp.c	2007-04-18 15:27:48.000000000 +0900
+++ linux-2.6.21-rc7/arch/i386/kernel/smp.c	2007-04-23 16:29:24.000000000 +0900
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


