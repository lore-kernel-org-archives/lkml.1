Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbZIPNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbZIPNwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbZIPNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:58 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:48856
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759123AbZIPNvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:53 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H69-03-4NM-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/5] amd64_edac: check NB MCE bank enable on the current node properly
Date: Wed, 16 Sep 2009 15:50:50 +0200
Message-ID: <1253109050-31165-6-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
References: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:51:24.0300 (UTC) FILETIME=[C796DCC0:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code was using smp_call_function_many which skips the current
cpu if it is in the supplied cpumask. Switch to the rdmsr_on_cpus()
interface which takes care of that.

In addition, add get_cpus_on_this_dct_cpumask helper which computes a
cpumask of all the cores on a node and thus on a DCT.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   66 ++++++++++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f943ad8..4e551e6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2741,30 +2741,53 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
 }
 
-static void check_mcg_ctl(void *ret)
+/* get all cores on this DCT */
+static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
 {
-	u64 msr_val = 0;
-	u8 nbe;
+	int cpu;
 
-	rdmsrl(MSR_IA32_MCG_CTL, msr_val);
-	nbe = msr_val & K8_MSR_MCGCTL_NBE;
-
-	debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
-		raw_smp_processor_id(), msr_val,
-		(nbe ? "enabled" : "disabled"));
-
-	if (!nbe)
-		*(int *)ret = 0;
+	for_each_online_cpu(cpu)
+		if (amd_get_nb_id(cpu) == nid)
+			cpumask_set_cpu(cpu, mask);
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static int mcg_ctl_enabled_on_node(const struct cpumask *mask)
+static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
-	int ret = 1;
-	preempt_disable();
-	smp_call_function_many(mask, check_mcg_ctl, &ret, 1);
-	preempt_enable();
+	cpumask_t mask;
+	struct msr *msrs;
+	int cpu, nbe, idx = 0;
+	bool ret = false;
+
+	cpumask_clear(&mask);
+
+	get_cpus_on_this_dct_cpumask(&mask, nid);
+
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			      __func__);
+		 return false;
+	}
+
+	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
+
+	for_each_cpu(cpu, &mask) {
+		nbe = msrs[idx].l & K8_MSR_MCGCTL_NBE;
+
+		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
+			cpu, msrs[idx].q,
+			(nbe ? "enabled" : "disabled"));
+
+		if (!nbe)
+			goto out;
+
+		idx++;
+	}
+	ret = true;
 
+out:
+	kfree(msrs);
 	return ret;
 }
 
@@ -2783,7 +2806,8 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 {
 	u32 value;
 	int err = 0;
-	u8 ecc_enabled = 0, mcg_ctl_en = 0;
+	u8 ecc_enabled = 0;
+	bool nb_mce_en = false;
 
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
 	if (err)
@@ -2797,13 +2821,13 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 	else
 		amd64_printk(KERN_INFO, "ECC is enabled by BIOS.\n");
 
-	mcg_ctl_en = mcg_ctl_enabled_on_node(cpumask_of_node(pvt->mc_node_id));
-	if (!mcg_ctl_en)
+	nb_mce_en = amd64_nb_mce_bank_enabled_on_node(pvt->mc_node_id);
+	if (!nb_mce_en)
 		amd64_printk(KERN_WARNING, "NB MCE bank disabled, set MSR "
 			     "0x%08x[4] on node %d to enable.\n",
 			     MSR_IA32_MCG_CTL, pvt->mc_node_id);
 
-	if (!ecc_enabled || !mcg_ctl_en) {
+	if (!ecc_enabled || !nb_mce_en) {
 		if (!ecc_enable_override) {
 			amd64_printk(KERN_WARNING, "%s", ecc_warning);
 			return -ENODEV;
-- 
1.6.3.3


