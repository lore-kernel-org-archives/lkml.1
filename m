Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717Ab0AEAjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0AEAjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346Ab0AEAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:39:33 -0500
Received: from kroah.org ([198.145.64.141]:42465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0AEAgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 85/97] x86, msr: Unify rdmsr_on_cpus/wrmsr_on_cpus
Date: Mon,  4 Jan 2010 16:33:38 -0800
Message-Id: <1262651630-7354-85-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

commit b8a4754147d61f5359a765a3afd3eb03012aa052 upstream.

Since rdmsr_on_cpus and wrmsr_on_cpus are almost identical, unify them
into a common __rwmsr_on_cpus helper thus avoiding code duplication.

While at it, convert cpumask_t's to const struct cpumask *.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/msr.h |    4 +-
 arch/x86/lib/msr.c         |   46 ++++++++++++++++++-------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 7e2b6ba..9a00219 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -247,8 +247,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 33a1e3c..41628b1 100644
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
1.6.6

