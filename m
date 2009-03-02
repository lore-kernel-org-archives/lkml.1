Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZCBJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZCBJ4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbZCBJyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:54:46 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:35199 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbZCBJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:54:43 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] x86_32: apic/es7000_32, cpu_mask_to_apicid cleanup
Date: Mon,  2 Mar 2009 10:53:56 +0100
Message-Id: <1235987638-23685-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235987638-23685-1-git-send-email-jirislaby@gmail.com>
References: <20090228082120.GA11425@elte.hu>
 <1235987638-23685-1-git-send-email-jirislaby@gmail.com>
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
 arch/x86/kernel/apic/es7000_32.c |   46 +++----------------------------------
 1 files changed, 4 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index da37e2c..9b9e86f 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -575,25 +575,21 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
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
@@ -601,40 +597,6 @@ es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
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
@@ -739,7 +701,7 @@ struct apic apic_es7000_cluster = {
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0xFF << 24,
 
-	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid_cluster,
+	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= es7000_send_IPI_mask,
-- 
1.6.1.3

