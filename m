Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZEYLDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZEYLDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZEYLD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:03:28 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:46764
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751599AbZEYLD1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:03:27 -0400
X-BigFish: VPS4(zzzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KK75DF-01-2QZ-01
Date: Mon, 25 May 2009 13:03:18 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090525110318.GB10303@aftab>
References: <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab> <4A156361.2040507@zytor.com> <20090521162638.GA10824@aftab> <4A159179.6070607@zytor.com> <20090522143918.GA22850@aftab> <4A16D735.8090104@zytor.com> <20090525110147.GB8956@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090525110147.GB8956@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 25 May 2009 11:03:17.0206 (UTC) FILETIME=[681EF760:01C9DD28]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 22 May 2009 13:52:19 +0200
Subject: [PATCH 02/26] x86: MSR: add methods for writing of an MSR on several CPUs

Provide for concurrent MSR writes on all the CPUs in the cpumask. Also,
add a temporary workaround for smp_call_function_many which skips the
CPU we're executing on.

CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   12 ++++++
 arch/x86/lib/msr.c         |   86 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 5e12132..2260376 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -227,6 +227,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
@@ -240,6 +242,16 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
+static inline void rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+				struct msr *msrs)
+{
+       rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
+}
+static inline void wrmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+				struct msr *msrs)
+{
+       wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
+}
 static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no,
 				    u32 *l, u32 *h)
 {
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index cade714..52edaf0 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -6,21 +6,37 @@
 struct msr_info {
 	u32 msr_no;
 	struct msr reg;
+	struct msr *msrs;
+	int off;
 	int err;
 };
 
 static void __rdmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
 
-	rdmsr(rv->msr_no, rv->reg.l, rv->reg.h);
+	if (rv->msrs)
+		reg = &rv->msrs[this_cpu - rv->off];
+	else
+		reg = &rv->reg;
+
+	rdmsr(rv->msr_no, reg->l, reg->h);
 }
 
 static void __wrmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
+
+	if (rv->msrs)
+		reg = &rv->msrs[this_cpu - rv->off];
+	else
+		reg = &rv->reg;
 
-	wrmsr(rv->msr_no, rv->reg.l, rv->reg.h);
+	wrmsr(rv->msr_no, reg->l, reg->h);
 }
 
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
@@ -35,6 +51,7 @@ int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 
 	return err;
 }
+EXPORT_SYMBOL(rdmsr_on_cpu);
 
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
@@ -48,6 +65,66 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 
 	return err;
 }
+EXPORT_SYMBOL(wrmsr_on_cpu);
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
+	struct msr_info rv;
+	int this_cpu;
+
+	rv.off    = cpumask_first(mask);
+	rv.msrs	  = msrs;
+	rv.msr_no = msr_no;
+
+	preempt_disable();
+	/*
+	 * FIXME: handle the CPU we're executing on separately for now until
+	 * smp_call_function_many has been fixed to not skip it.
+	 */
+	this_cpu = raw_smp_processor_id();
+	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
+
+	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
+	preempt_enable();
+}
+EXPORT_SYMBOL(rdmsr_on_cpus);
+
+/*
+ * wrmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+{
+	struct msr_info rv;
+	int this_cpu;
+
+	rv.off    = cpumask_first(mask);
+	rv.msrs   = msrs;
+	rv.msr_no = msr_no;
+
+	preempt_disable();
+	/*
+	 * FIXME: handle the CPU we're executing on separately for now until
+	 * smp_call_function_many has been fixed to not skip it.
+	 */
+	this_cpu = raw_smp_processor_id();
+	smp_call_function_single(this_cpu, __wrmsr_on_cpu, &rv, 1);
+
+	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
+	preempt_enable();
+}
+EXPORT_SYMBOL(wrmsr_on_cpus);
 
 /* These "safe" variants are slower and should be used when the target MSR
    may not actually exist. */
@@ -77,6 +154,7 @@ int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 
 	return err ? err : rv.err;
 }
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
 
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
@@ -90,8 +168,4 @@ int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 
 	return err ? err : rv.err;
 }
-
-EXPORT_SYMBOL(rdmsr_on_cpu);
-EXPORT_SYMBOL(wrmsr_on_cpu);
-EXPORT_SYMBOL(rdmsr_safe_on_cpu);
 EXPORT_SYMBOL(wrmsr_safe_on_cpu);
-- 
1.6.2.4

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

