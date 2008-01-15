Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYAOCTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYAOCTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYAOCRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:17:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36870 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbYAOCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:17:37 -0500
Message-Id: <20080115021736.402113000@sgi.com>
References: <20080115021735.779102000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jan 2008 18:17:38 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] x86: Change NR_CPUS arrays in powernow-k8 V2
Content-Disposition: inline; filename=NR_CPUS-arrays-in-powernow-k8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the following static arrays sized by NR_CPUS to
per_cpu data variables:

	powernow_k8_data *powernow_data[NR_CPUS];


Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
V1->V2:
    - (none)
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -53,7 +53,7 @@
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
 
-static struct powernow_k8_data *powernow_data[NR_CPUS];
+static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
@@ -1052,7 +1052,7 @@ static int transition_frequency_pstate(s
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask = CPU_MASK_ALL;
-	struct powernow_k8_data *data = powernow_data[pol->cpu];
+	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
 	unsigned int newstate;
@@ -1128,7 +1128,7 @@ err_out:
 /* Driver entry point to verify the policy and range of frequencies */
 static int powernowk8_verify(struct cpufreq_policy *pol)
 {
-	struct powernow_k8_data *data = powernow_data[pol->cpu];
+	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 
 	if (!data)
 		return -EINVAL;
@@ -1233,7 +1233,7 @@ static int __cpuinit powernowk8_cpu_init
 		dprintk("cpu_init done, current fid 0x%x, vid 0x%x\n",
 			data->currfid, data->currvid);
 
-	powernow_data[pol->cpu] = data;
+	per_cpu(powernow_data, pol->cpu) = data;
 
 	return 0;
 
@@ -1247,7 +1247,7 @@ err_out:
 
 static int __devexit powernowk8_cpu_exit (struct cpufreq_policy *pol)
 {
-	struct powernow_k8_data *data = powernow_data[pol->cpu];
+	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 
 	if (!data)
 		return -EINVAL;
@@ -1268,7 +1268,7 @@ static unsigned int powernowk8_get (unsi
 	cpumask_t oldmask = current->cpus_allowed;
 	unsigned int khz = 0;
 
-	data = powernow_data[first_cpu(per_cpu(cpu_core_map, cpu))];
+	data = per_cpu(powernow_data, first_cpu(per_cpu(cpu_core_map, cpu)));
 
 	if (!data)
 		return -EINVAL;

-- 
