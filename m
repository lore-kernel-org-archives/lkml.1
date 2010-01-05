Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714Ab0AEAjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0AEAjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410Ab0AEAi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:38:56 -0500
Received: from kroah.org ([198.145.64.141]:42473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab0AEAgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 86/97] cpumask: use modern cpumask style in drivers/edac/amd64_edac.c
Date: Mon,  4 Jan 2010 16:33:39 -0800
Message-Id: <1262651630-7354-86-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

commit ba578cb34a71fb08fff14ac0796b934a8c9991e1 upstream.

cpumask_t -> struct cpumask, and don't put one on the stack.  (Note: this
is actually on the stack unless CONFIG_CPUMASK_OFFSTACK=y).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/amd64_edac.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a38831c..56deaee 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2625,7 +2625,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2701,7 +2701,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
 	struct msr msrs[cpumask_weight(cpumask)];
 	u32 value;
@@ -2734,7 +2734,7 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 {
 	int cpu;
 
@@ -2746,25 +2746,30 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
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
@@ -2780,6 +2785,7 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 out:
 	kfree(msrs);
+	free_cpumask_var(mask);
 	return ret;
 }
 
-- 
1.6.6

