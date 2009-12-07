Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZLGMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZLGMVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZLGMVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:21:31 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19059 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZLGMV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:21:29 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzab9bh1102Kzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUA7NL-02-84A-02
X-M-MSG: 
Date: Mon, 7 Dec 2009 13:21:33 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: [PATCH] x86, msr: add support for non-contiguous cpumasks
Message-ID: <20091207122133.GA24877@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Dec 2009 12:21:22.0340 (UTC) FILETIME=[C9A4AE40:01CA7737]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

can you please take a look at the following patch which fixes a problem
with non-contiguous cpumasks submitted to rd/wrmsr_on_cpus() (see URL in
the commit message below) and let me know whether this approach looks
ok. If yes, I could submit it with my patchqueue along with the rest of
amd64_edac updates for it'll be very convenient if we could get it in
now so that it could be backported to .32.

Thanks.

---
The current rd/wrmsr_on_cpus helpers assume that the supplied
cpumasks are contiguous. However, there are machines out there
like some K8 multinode Opterons which have a non-contiguous core
enumeration on each node (e.g. cores 0,2 on node 0 instead of 0,1), see
http://www.gossamer-threads.com/lists/linux/kernel/1160268.

This patch fixes out-of-bounds writes (see URL above) by making sure we
stay inbounds by using an msr->cpu field which tells us which CPU's MSRs
to access.

Additionally, this patch adds msrs_{alloc,free} helpers for preparing
the array of MSRs to access.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Not-yet-signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   11 ++++++
 arch/x86/lib/msr.c         |   81 +++++++++++++++++++++++++++++++++++++------
 drivers/edac/amd64_edac.c  |   17 ++++-----
 3 files changed, 87 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9a00219..4f528f8 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -18,6 +18,7 @@
 #include <asm/cpumask.h>
 
 struct msr {
+	int cpu;
 	union {
 		struct {
 			u32 l;
@@ -247,6 +248,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+struct msr *msrs_alloc(const struct cpumask *mask);
+void msrs_free(struct msr *msrs);
 void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
@@ -264,6 +267,14 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
+struct msr *msrs_alloc(const struct cpumask *mask)
+{
+	return kzalloc(sizeof(struct msr), GFP_KERNEL);
+}
+void msrs_free(struct msr *msrs)
+{
+	kfree(msrs);
+}
 static inline void rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
 				struct msr *msrs)
 {
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 41628b1..e2213de 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -7,20 +7,40 @@ struct msr_info {
 	u32 msr_no;
 	struct msr reg;
 	struct msr *msrs;
-	int off;
+	unsigned msrs_len;
 	int err;
 };
 
+static inline struct msr *scroll_to_cpu(struct msr_info *rv, int this_cpu,
+					const char *caller)
+{
+	int i = 0;
+
+	if (!rv->msrs)
+		return &rv->reg;
+
+	while (i < rv->msrs_len &&
+		rv->msrs[i].cpu != this_cpu)
+		i++;
+
+	if (rv->msrs[i].cpu != this_cpu) {
+		pr_err("%s: called on a wrong cpu (%d vs %d)?\n",
+			caller, rv->msrs[i].cpu, this_cpu);
+		return NULL;
+	}
+
+	return &rv->msrs[i];
+}
+
 static void __rdmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
 	struct msr *reg;
 	int this_cpu = raw_smp_processor_id();
 
-	if (rv->msrs)
-		reg = &rv->msrs[this_cpu - rv->off];
-	else
-		reg = &rv->reg;
+	reg = scroll_to_cpu(rv, this_cpu, __func__);
+	if (!reg)
+		return;
 
 	rdmsr(rv->msr_no, reg->l, reg->h);
 }
@@ -31,10 +51,9 @@ static void __wrmsr_on_cpu(void *info)
 	struct msr *reg;
 	int this_cpu = raw_smp_processor_id();
 
-	if (rv->msrs)
-		reg = &rv->msrs[this_cpu - rv->off];
-	else
-		reg = &rv->reg;
+	reg = scroll_to_cpu(rv, this_cpu, __func__);
+	if (!reg)
+		return;
 
 	wrmsr(rv->msr_no, reg->l, reg->h);
 }
@@ -80,9 +99,9 @@ static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
 
 	memset(&rv, 0, sizeof(rv));
 
-	rv.off    = cpumask_first(mask);
-	rv.msrs	  = msrs;
-	rv.msr_no = msr_no;
+	rv.msr_no   = msr_no;
+	rv.msrs	    = msrs;
+	rv.msrs_len = cpumask_weight(mask);
 
 	this_cpu = get_cpu();
 
@@ -120,6 +139,44 @@ void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
+/*
+ * Allocate enough msr structs for the supplied cpumask. Also, take care of
+ * non-contigious bitmasks.
+ */
+struct msr *msrs_alloc(const struct cpumask *mask)
+{
+	struct msr *msrs;
+	int i, cpu = -1;
+	unsigned msrs_len;
+
+	if (cpumask_empty(mask)) {
+		pr_warning("%s: empty cpumask!\n", __func__);
+		return NULL;
+	}
+
+	msrs_len = cpumask_weight(mask);
+
+	msrs = kzalloc(sizeof(struct msr) * msrs_len, GFP_KERNEL);
+	if (!msrs) {
+		pr_warning("%s: error allocating msrs\n", __func__);
+		return NULL;
+	}
+
+	for (i = 0; i < msrs_len; i++) {
+		cpu = cpumask_next(cpu, mask);
+		msrs[i].cpu = cpu;
+	}
+
+	return msrs;
+}
+EXPORT_SYMBOL(msrs_alloc);
+
+void msrs_free(struct msr *msrs)
+{
+	kfree(msrs);
+}
+EXPORT_SYMBOL(msrs_free);
+
 /* These "safe" variants are slower and should be used when the target MSR
    may not actually exist. */
 static void __rdmsr_safe_on_cpu(void *info)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 533f5ff..784c968 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2507,10 +2507,8 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	get_cpus_on_this_dct_cpumask(mask, nid);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(mask), GFP_KERNEL);
+	msrs = msrs_alloc(mask);
 	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			      __func__);
 		free_cpumask_var(mask);
 		 return false;
 	}
@@ -2532,7 +2530,7 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 	ret = true;
 
 out:
-	kfree(msrs);
+	msrs_free(msrs);
 	free_cpumask_var(mask);
 	return ret;
 }
@@ -2551,17 +2549,16 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 
 	get_cpus_on_this_dct_cpumask(cmask, pvt->mc_node_id);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(cmask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			     __func__);
+	msrs = msrs_alloc(cmask);
+	if (!msrs)
 		return -ENOMEM;
-	}
 
 	rdmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
 
 	for_each_cpu(cpu, cmask) {
 
+		WARN_ON(cpu != msrs[idx].cpu);
+
 		if (on) {
 			if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
 				pvt->flags.ecc_report = 1;
@@ -2578,7 +2575,7 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 	}
 	wrmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
 
-	kfree(msrs);
+	msrs_free(msrs);
 	free_cpumask_var(cmask);
 
 	return 0;
-- 
1.6.5.3


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

