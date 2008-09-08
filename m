Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYIHA7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYIHA7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYIHA7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:6916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYIHA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vWcGHEUCu6n1Yb3zlzRCdbAACQY3Y3DuI397A6ZPSqOXZbuVkVJmxOaon0ISCdEx6B
         LhnREG4vAjs3hcYe0aBmSG1F9dpNF0LQvlY5uJJ9AB766W6XYtaRdfxlKV305opMdwqM
         iTVuekvNJq1W/6f5/zkvxQZ2CLGJFYioWO6vI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/9] x86: add srat_detect_node for amd64
Date: Sun,  7 Sep 2008 17:58:52 -0700
Message-Id: <1220835538-18280-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seperate that from amd_detect_cmp()

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/amd_64.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 466a1ea..20c3f12 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -36,19 +36,23 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned bits;
-#ifdef CONFIG_NUMA
-	int cpu = smp_processor_id();
-	int node = 0;
-	unsigned apicid = hard_smp_processor_id();
-#endif
+
 	bits = c->x86_coreid_bits;
 
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
+#endif
+}
 
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+{
 #ifdef CONFIG_NUMA
+	int cpu = smp_processor_id();
+	int node;
+	unsigned apicid = hard_smp_processor_id();
+
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
 		node = apicid_to_node[apicid];
@@ -76,7 +80,6 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 
 	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
 #endif
-#endif
 }
 
 static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
@@ -169,8 +172,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	display_cacheinfo(c);
 
 	/* Multi core CPU? */
-	if (c->extended_cpuid_level >= 0x80000008)
+	if (c->extended_cpuid_level >= 0x80000008) {
 		amd_detect_cmp(c);
+		srat_detect_node(c);
+	}
 
 	if (c->extended_cpuid_level >= 0x80000006) {
 		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
-- 
1.5.4.5

