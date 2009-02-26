Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZBZVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZBZVqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbZBZVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:46:09 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:42450 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZBZVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:46:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/4] x86_32: apic/summit_32, fix cpu_mask_to_apicid
Date: Thu, 26 Feb 2009 22:45:32 +0100
Message-Id: <1235684732-5991-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235684732-5991-3-git-send-email-jirislaby@gmail.com>
References: <20090225111002.GA15453@elte.hu>
 <1235684732-5991-1-git-send-email-jirislaby@gmail.com>
 <1235684732-5991-2-git-send-email-jirislaby@gmail.com>
 <1235684732-5991-3-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform same-cluster checking even for masks with all (nr_cpu_ids)
bits set and report correct apicid on success instead.

While at it, convert it to for_each_cpu and newer cpumask api.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/summit_32.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 32838b5..95916dc 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -291,33 +291,21 @@ static int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 
 static unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	int cpus_found = 0;
-	int num_bits_set;
-	int apicid;
-	int cpu;
+	unsigned int round = 0;
+	int cpu, apicid = 0;
 
-	num_bits_set = cpus_weight(*cpumask);
-	if (num_bits_set >= nr_cpu_ids)
-		return BAD_APICID;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
-	cpu = first_cpu(*cpumask);
-	apicid = summit_cpu_to_logical_apicid(cpu);
-
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = summit_cpu_to_logical_apicid(cpu);
+	for_each_cpu(cpu, cpumask) {
+		int new_apicid = summit_cpu_to_logical_apicid(cpu);
 
-			if (APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-				printk("%s: Not a valid mask!\n", __func__);
-
-				return BAD_APICID;
-			}
-			apicid = apicid | new_apicid;
-			cpus_found++;
+		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
+			printk("%s: Not a valid mask!\n", __func__);
+			return BAD_APICID;
 		}
-		cpu++;
+		apicid |= new_apicid;
+		round++;
 	}
 	return apicid;
 }
-- 
1.6.1.3

