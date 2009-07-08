Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZGHLUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZGHLUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZGHLUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:20:42 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8743 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbZGHLUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:20:41 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dN1805M179dNzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMGNI3-01-G17-01
Date: Wed, 8 Jul 2009 13:19:11 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [x86, msr]: execute on the correct CPU subset (was: Re:
 [PATCH] [x86, msr]: remove code duplication)
Message-ID: <20090708111911.GC19315@aftab>
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
 <4A526D38.7000803@zytor.com>
 <20090707103723.GD5668@aftab>
 <4A537010.3050905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A537010.3050905@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Jul 2009 11:19:10.0247 (UTC) FILETIME=[EA5A7B70:01C9FFBD]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:56:00AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > 
> > Actually, the more important question is why am I executing anything on
> > my own CPU without first checking if it is in the cpumask _at_ _all_?!
> > /me ducks behind the sofa.
> > 
> > The right thing to do should be something like the following:
> > 
> > preempt_disable();
> > this_cpu = raw_smp_processor_id();
> > 
> > if (cpumask_test_cpu(this_cpu, mask)) {
> > 	local_irq_disable();
> > 	msr_func(&rv);
> > 	local_irq_enable();
> > }
> > 
> > smp_call_function_many(mask, msr_func, &rv, 1);
> > preempt_enable();
> > 
> 
> I don't see why you're disabling local IRQs.

I guess I was trying to be overly careful but can't seem to think of a
case when this would be appropriate. Hmm...

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 6 Jul 2009 16:08:34 +0200
Subject: [PATCH] [x86, msr]: execute on the correct CPU subset

rdmsr_on_cpus/wrmsr_on_cpus were erroneously executing on the current
CPU even in the case where it wasn't in the supplied bitmask. Add a
check for that and handle accordingly.

While at it, since rdmsr_on_cpus and wrmsr_on_cpus are almost identical,
fold them into a common __rwmsr_on_cpus helper passing a function
pointer arg to the actual MSR operation.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/lib/msr.c |   53 +++++++++++++++++++--------------------------------
 1 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 1440b9c..8242b12 100644
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
@@ -90,16 +85,26 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msr_no = msr_no;
 
 	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
 	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
 
-	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
+	if (cpumask_test_cpu(this_cpu, mask))
+		msr_func(&rv);
+
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
@@ -112,25 +117,7 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
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


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

