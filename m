Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZG3JKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZG3JKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZG3JKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:10:53 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:21346 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbZG3JKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:10:52 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNL85M-03-N7T-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] x86, msr: unify rdmsr_on_cpus/wrmsr_on_cpus
Date: Thu, 30 Jul 2009 11:10:02 +0200
Message-ID: <1248945002-2931-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4A7099E8.30003@zytor.com>
References: <4A7099E8.30003@zytor.com>
X-OriginalArrivalTime: 30 Jul 2009 09:10:03.0658 (UTC) FILETIME=[861D4EA0:01CA10F5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rdmsr_on_cpus and wrmsr_on_cpus are almost identical, unify them
into a common __rwmsr_on_cpus helper thus avoiding code duplication.

While at it, convert cpumask_t's to const struct cpumask *.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

This one is .32 material.

 arch/x86/include/asm/msr.h |    4 +-
 arch/x86/lib/msr.c         |   46 ++++++++++++++++++-------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..f2f4309 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -224,8 +224,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index caa24ac..2f26cf4 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -71,14 +71,9 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 EXPORT_SYMBOL(wrmsr_on_cpu);
 
-/* rdmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+			    struct msr *msrs,
+			    void (*msr_func) (void *info))
 {
 	struct msr_info rv;
 	int this_cpu;
@@ -92,11 +87,23 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	this_cpu = get_cpu();
 
 	if (cpumask_test_cpu(this_cpu, mask))
-		__rdmsr_on_cpu(&rv);
+		msr_func(&rv);
 
-	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
+	smp_call_function_many(mask, msr_func, &rv, 1);
 	put_cpu();
 }
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
+}
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
 /*
@@ -107,24 +114,9 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 {
-	struct msr_info rv;
-	int this_cpu;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.off    = cpumask_first(mask);
-	rv.msrs   = msrs;
-	rv.msr_no = msr_no;
-
-	this_cpu = get_cpu();
-
-	if (cpumask_test_cpu(this_cpu, mask))
-		__wrmsr_on_cpu(&rv);
-
-	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
-	put_cpu();
+	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
-- 
1.6.3.3


