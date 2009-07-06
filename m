Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZGFOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZGFOpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZGFOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:45:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:46227 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGFOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:45:09 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 10:45:08 EDT
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KMD6XT-01-FDR-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] [x86, msr]: remove code duplication
Date: Mon, 6 Jul 2009 16:29:52 +0200
Message-ID: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 06 Jul 2009 14:29:57.0529 (UTC) FILETIME=[3CA39890:01C9FE46]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rdmsr_on_cpus and wrmsr_on_cpus are almost identical, make them
call into a common __rwmsr_on_cpus helper passing a function pointer arg
to the actual MSR operation.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/lib/msr.c |   48 ++++++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 1440b9c..20b6df5 100644
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
+static inline void __rwmsr_on_cpus(const cpumask_t *mask, u32 msr_no,
+				   struct msr *msrs,
+				   void (*msr_func) (void *info))
 {
 	struct msr_info rv;
 	int this_cpu;
@@ -95,11 +90,22 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	 * smp_call_function_many has been fixed to not skip it.
 	 */
 	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
-
-	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
+	smp_call_function_single(this_cpu, msr_func, &rv, 1);
+	smp_call_function_many(mask, msr_func, &rv, 1);
 	preempt_enable();
 }
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
+}
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
 /*
@@ -112,25 +118,7 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  */
 void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
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
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __wrmsr_on_cpu, &rv, 1);
-
-	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
-- 
1.6.3.3


