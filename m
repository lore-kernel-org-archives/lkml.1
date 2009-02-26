Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZBZVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZBZVqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZBZVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:46:07 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:42446 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZBZVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:46:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] x86_32: apic/es7000_32, cpu_mask_to_apicid cleanup
Date: Thu, 26 Feb 2009 22:45:30 +0100
Message-Id: <1235684732-5991-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235684732-5991-1-git-send-email-jirislaby@gmail.com>
References: <20090225111002.GA15453@elte.hu>
 <1235684732-5991-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove es7000_cpu_mask_to_apicid_cluster completely, because it's
almost the same as es7000_cpu_mask_to_apicid except 2 code paths.
One of them is about to be removed soon, the another should be
BAD_APICID (it's a fail path).

The _cluster one was not invoked on apic->cpu_mask_to_apicid_and
anyway, since there was no _cluster_and variant.

Also use newer cpumask functions.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/es7000_32.c |   46 ++-----------------------------------
 1 files changed, 3 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 320f2d2..6c15126 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -565,25 +565,21 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 	return 1;
 }
 
-static unsigned int
-es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
+static unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	int cpus_found = 0;
-	int num_bits_set;
+	unsigned int cpu, num_bits_set, cpus_found = 0;
 	int apicid;
-	int cpu;
 
 	num_bits_set = cpumask_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == nr_cpu_ids)
-		return 0xFF;
+		return es7000_cpu_to_logical_apicid(0);
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of target_cpus():
 	 */
 	cpu = cpumask_first(cpumask);
 	apicid = es7000_cpu_to_logical_apicid(cpu);
-
 	while (cpus_found < num_bits_set) {
 		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
@@ -591,40 +587,6 @@ es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 			if (APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 				WARN(1, "Not a valid mask!");
 
-				return 0xFF;
-			}
-			apicid = new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-static unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
-{
-	int cpus_found = 0;
-	int num_bits_set;
-	int apicid;
-	int cpu;
-
-	num_bits_set = cpus_weight(*cpumask);
-	/* Return id to all */
-	if (num_bits_set == nr_cpu_ids)
-		return es7000_cpu_to_logical_apicid(0);
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
-	 */
-	cpu = first_cpu(*cpumask);
-	apicid = es7000_cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
-
-			if (APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-				printk("%s: Not a valid mask!\n", __func__);
-
 				return es7000_cpu_to_logical_apicid(0);
 			}
 			apicid = new_apicid;
@@ -667,8 +629,6 @@ void __init es7000_update_apic_to_cluster(void)
 	apic->irq_dest_mode = 1;
 
 	apic->init_apic_ldr = es7000_init_apic_ldr_cluster;
-
-	apic->cpu_mask_to_apicid = es7000_cpu_mask_to_apicid_cluster;
 }
 
 static int probe_es7000(void)
-- 
1.6.1.3

