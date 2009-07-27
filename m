Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZG0Igg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZG0Igg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZG0Igg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:36:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64232 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZG0Igf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:36:35 -0400
X-SpamScore: -27
X-BigFish: VPS-27(z21eWz1432R98dNzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNFMJ3-04-91J-01
Date: Mon, 27 Jul 2009 10:35:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86 fixes for 2.6.31-rc5
Message-ID: <20090727083514.GA23931@aftab>
References: <200907270526.n6R5QK5G032346@voreg.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200907270526.n6R5QK5G032346@voreg.hos.anvin.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2009 08:35:16.0086 (UTC) FILETIME=[2A95D960:01CA0E95]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 26, 2009 at 10:26:20PM -0700, H. Peter Anvin wrote:
> Hi Linus,
> 
> The following changes since commit 78af08d90b8f745044b1274430bc4bc6b2b27aca:
>   Linus Torvalds (1):
>         Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

any chance you can pick that one too:

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

