Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZG2Quw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZG2Quw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZG2Quw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:50:52 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:23461
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755458AbZG2Quv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:50:51 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dNzz1202hzzz32i6bh203h6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNJYSC-02-ALQ-02
X-M-MSG: 
Date: Wed, 29 Jul 2009 18:49:41 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
Message-ID: <20090729164941.GA9388@aftab>
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
 <4A526D38.7000803@zytor.com>
 <20090707103723.GD5668@aftab>
 <4A537010.3050905@zytor.com>
 <20090708111911.GC19315@aftab>
 <4A6E1222.5010709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A6E1222.5010709@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 16:49:42.0225 (UTC) FILETIME=[91CEEC10:01CA106C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 01:46:26PM -0700, H. Peter Anvin wrote:
> Any reason not to use get_cpu() ... put_cpu() instead?

In case you haven't applied the one from yesterday yet, here's a better
one which uses struct cpumask * instead of cpumask_t.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 6 Jul 2009 16:08:34 +0200
Subject: [PATCH] [x86, msr]: execute on the correct CPU subset

rdmsr_on_cpus/wrmsr_on_cpus were erroneously executing on the current
CPU even in the case where it wasn't in the supplied bitmask. Add a
check for that and handle accordingly.

While at it, since rdmsr_on_cpus and wrmsr_on_cpus are almost identical,
fold them call into a common __rwmsr_on_cpus helper passing a function
pointer arg to the actual MSR operation.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |    4 +-
 arch/x86/lib/msr.c         |   60 +++++++++++++++++---------------------------
 2 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..988b067 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -224,8 +224,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 1440b9c..da156b8 100644
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
+static inline void __rwmsr_on_cpus(struct cpumask *mask, u32 msr_no,
+				   struct msr *msrs,
+				   void (*msr_func) (void *info))
 {
 	struct msr_info rv;
 	int this_cpu;
@@ -89,16 +84,25 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msrs	  = msrs;
 	rv.msr_no = msr_no;
 
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
+	this_cpu = get_cpu();
 
-	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	if (cpumask_test_cpu(this_cpu, mask))
+		msr_func(&rv);
+
+	smp_call_function_many(mask, msr_func, &rv, 1);
+	put_cpu();
+}
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void rdmsr_on_cpus(struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
 }
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
@@ -110,27 +114,9 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(struct cpumask *mask, u32 msr_no, struct msr *msrs)
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

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

