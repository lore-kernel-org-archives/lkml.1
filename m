Return-Path: <linux-kernel-owner+w=401wt.eu-S1761083AbYCST4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083AbYCST4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYCSThj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbYCSThh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:37 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 05/79] [PATCH] add an smp_apply_quirks to smpboot_32.c
Date: Wed, 19 Mar 2008 14:25:00 -0300
Message-Id: <12059475982810-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059475944070-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

The split of smp_store_cpu_info in a quirks-only part
will ease integration with x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 8676eec..e050064 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -78,19 +78,8 @@ static void map_cpu_to_logical_apicid(void);
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-/*
- * The bootstrap kernel entry code has set these up. Save them for
- * a given CPU
- */
-
-void __cpuinit smp_store_cpu_info(int id)
+static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
-	struct cpuinfo_x86 *c = &cpu_data(id);
-
-	*c = boot_cpu_data;
-	c->cpu_index = id;
-	if (id!=0)
-		identify_secondary_cpu(c);
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
@@ -138,6 +127,23 @@ void __cpuinit smp_store_cpu_info(int id)
 
 valid_k7:
 	;
+
+}
+
+/*
+ * The bootstrap kernel entry code has set these up. Save them for
+ * a given CPU
+ */
+
+void __cpuinit smp_store_cpu_info(int id)
+{
+	struct cpuinfo_x86 *c = &cpu_data(id);
+
+	*c = boot_cpu_data;
+	c->cpu_index = id;
+	if (id != 0)
+		identify_secondary_cpu(c);
+	smp_apply_quirks(c);
 }
 
 static atomic_t init_deasserted;
-- 
1.5.0.6

