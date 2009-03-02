Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZCBJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZCBJ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZCBJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:54:48 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:35204 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146AbZCBJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:54:47 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] x86_32: apic/es7000_32, fix cpu_mask_to_apicid
Date: Mon,  2 Mar 2009 10:53:57 +0100
Message-Id: <1235987638-23685-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235987638-23685-2-git-send-email-jirislaby@gmail.com>
References: <20090228082120.GA11425@elte.hu>
 <1235987638-23685-1-git-send-email-jirislaby@gmail.com>
 <1235987638-23685-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform same-cluster checking even for masks with all (nr_cpu_ids)
bits set and report BAD_APICID on failure.

While at it, convert it to for_each_cpu.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/es7000_32.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 9b9e86f..4d8830f 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -577,32 +577,22 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 
 static unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	unsigned int cpu, num_bits_set, cpus_found = 0;
-	int apicid;
+	unsigned int round = 0;
+	int cpu, uninitialized_var(apicid);
 
-	num_bits_set = cpumask_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == nr_cpu_ids)
-		return es7000_cpu_to_logical_apicid(0);
 	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
+	 * The cpus in the mask must all be on the apic cluster.
 	 */
-	cpu = cpumask_first(cpumask);
-	apicid = es7000_cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask)) {
-			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+	for_each_cpu(cpu, cpumask) {
+		int new_apicid = es7000_cpu_to_logical_apicid(cpu);
 
-			if (APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-				WARN(1, "Not a valid mask!");
+		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
+			WARN(1, "Not a valid mask!");
 
-				return es7000_cpu_to_logical_apicid(0);
-			}
-			apicid = new_apicid;
-			cpus_found++;
+			return BAD_APICID;
 		}
-		cpu++;
+		apicid = new_apicid;
+		round++;
 	}
 	return apicid;
 }
-- 
1.6.1.3

