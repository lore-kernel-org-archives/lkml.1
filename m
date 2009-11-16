Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZKPOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZKPOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZKPOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:24 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:42928
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752950AbZKPOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:18 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz14c3Lzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KT7GYZ-02-PYS-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 04/21] cpumask: use modern cpumask style in drivers/edac/amd64_edac.c
Date: Mon, 16 Nov 2009 15:16:31 +0100
Message-ID: <1258381008-18783-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0641 (UTC) FILETIME=[59E86D10:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

cpumask_t -> struct cpumask, and don't put one on the stack.  (Note: this
is actually on the stack unless CONFIG_CPUMASK_OFFSTACK=y).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3408b94..67541e7 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2631,7 +2631,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2707,7 +2707,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2740,7 +2740,7 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 {
 	int cpu;
 
@@ -2752,25 +2752,30 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
 /* check MCG_CTL on all the cpus on this node */
 static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 	struct msr *msrs;
 	int cpu, nbe, idx = 0;
 	bool ret = false;
 
-	cpumask_clear(&mask);
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
+			     __func__);
+		return false;
+	}
 
-	get_cpus_on_this_dct_cpumask(&mask, nid);
+	get_cpus_on_this_dct_cpumask(mask, nid);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(mask), GFP_KERNEL);
 	if (!msrs) {
 		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
 			      __func__);
+		free_cpumask_var(mask);
 		 return false;
 	}
 
-	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
+	rdmsr_on_cpus(mask, MSR_IA32_MCG_CTL, msrs);
 
-	for_each_cpu(cpu, &mask) {
+	for_each_cpu(cpu, mask) {
 		nbe = msrs[idx].l & K8_MSR_MCGCTL_NBE;
 
 		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
@@ -2786,6 +2791,7 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 out:
 	kfree(msrs);
+	free_cpumask_var(mask);
 	return ret;
 }
 
-- 
1.6.4.3


