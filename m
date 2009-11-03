Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZKCE0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZKCE0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZKCE0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:26:32 -0500
Received: from ozlabs.org ([203.10.76.45]:39389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbZKCE0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:26:31 -0500
To: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       bluesmoke-devel@lists.sourceforge.net
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031456.35354.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:56:35 +1030
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/14] cpumask: use modern cpumask style in drivers/edac/amd64_edac.c
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask_t -> struct cpumask, and don't put one on the stack.  (Note: this
is actually on the stack unless CONFIG_CPUMASK_OFFSTACK=y).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/edac/amd64_edac.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2625,7 +2625,7 @@ static int amd64_init_csrows(struct mem_
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2701,7 +2701,7 @@ static void amd64_enable_ecc_error_repor
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2734,7 +2734,7 @@ static void amd64_restore_ecc_error_repo
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 {
 	int cpu;
 
@@ -2746,25 +2746,30 @@ static void get_cpus_on_this_dct_cpumask
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
@@ -2780,6 +2785,7 @@ static bool amd64_nb_mce_bank_enabled_on
 
 out:
 	kfree(msrs);
+	free_cpumask_var(mask);
 	return ret;
 }
 

