Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZFZPwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZFZPwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZFZPwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:52:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62581 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbZFZPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:52:39 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KLUS3B-02-VM5-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, davej@redhat.com, cpufreq@vger.kernel.org
Subject: [PATCH][cpufreq][Powernow-k8] support family 0xf with 2 low p-states
Date: Sun, 26 Jul 2009 10:55:25 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907261055.25501.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 26 Jun 2009 15:52:30.0519 (UTC) FILETIME=[1CB86470:01C9F676]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support for family 0xf processors with 2 P-states
below the elevator voltage.  Remove the checks that prevent
this configuration from being supported and increase the
transition voltage to prevent errors during the transition.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   30 ++++++++++------------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 81cbe64..ae068f5 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -299,7 +299,7 @@ static int transition_pstate(struct powernow_k8_data *data, u32 pstate)
 static int transition_fid_vid(struct powernow_k8_data *data,
 		u32 reqfid, u32 reqvid)
 {
-	if (core_voltage_pre_transition(data, reqvid))
+	if (core_voltage_pre_transition(data, reqvid, reqfid))
 		return 1;
 
 	if (core_frequency_transition(data, reqfid))
@@ -327,17 +327,20 @@ static int transition_fid_vid(struct powernow_k8_data *data,
 
 /* Phase 1 - core voltage transition ... setup voltage */
 static int core_voltage_pre_transition(struct powernow_k8_data *data,
-		u32 reqvid)
+		u32 reqvid, u32 reqfid)
 {
 	u32 rvosteps = data->rvo;
 	u32 savefid = data->currfid;
-	u32 maxvid, lo;
+	u32 maxvid, lo, rvomult = 1;
 
 	dprintk("ph1 (cpu%d): start, currfid 0x%x, currvid 0x%x, "
 		"reqvid 0x%x, rvo 0x%x\n",
 		smp_processor_id(),
 		data->currfid, data->currvid, reqvid, data->rvo);
 
+	if ((savefid < LO_FID_TABLE_TOP) && (reqfid < LO_FID_TABLE_TOP))
+		rvomult = 2;
+	rvosteps *= rvomult;
 	rdmsr(MSR_FIDVID_STATUS, lo, maxvid);
 	maxvid = 0x1f & (maxvid >> 16);
 	dprintk("ph1 maxvid=0x%x\n", maxvid);
@@ -351,7 +354,8 @@ static int core_voltage_pre_transition(struct powernow_k8_data *data,
 			return 1;
 	}
 
-	while ((rvosteps > 0) && ((data->rvo + data->currvid) > reqvid)) {
+	while ((rvosteps > 0) &&
+			((rvomult * data->rvo + data->currvid) > reqvid)) {
 		if (data->currvid == maxvid) {
 			rvosteps = 0;
 		} else {
@@ -384,13 +388,6 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid)
 	u32 vcoreqfid, vcocurrfid, vcofiddiff;
 	u32 fid_interval, savevid = data->currvid;
 
-	if ((reqfid < HI_FID_TABLE_BOTTOM) &&
-	    (data->currfid < HI_FID_TABLE_BOTTOM)) {
-		printk(KERN_ERR PFX "ph2: illegal lo-lo transition "
-				"0x%x 0x%x\n", reqfid, data->currfid);
-		return 1;
-	}
-
 	if (data->currfid == reqfid) {
 		printk(KERN_ERR PFX "ph2 null fid transition 0x%x\n",
 				data->currfid);
@@ -407,6 +404,9 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid)
 	vcofiddiff = vcocurrfid > vcoreqfid ? vcocurrfid - vcoreqfid
 	    : vcoreqfid - vcocurrfid;
 
+	if ((reqfid <= LO_FID_TABLE_TOP) && (data->currfid <= LO_FID_TABLE_TOP))
+		vcofiddiff = 0;
+
 	while (vcofiddiff > 2) {
 		(data->currfid & 1) ? (fid_interval = 1) : (fid_interval = 2);
 
@@ -1081,14 +1081,6 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 		return 0;
 	}
 
-	if ((fid < HI_FID_TABLE_BOTTOM) &&
-	    (data->currfid < HI_FID_TABLE_BOTTOM)) {
-		printk(KERN_ERR PFX
-		       "ignoring illegal change in lo freq table-%x to 0x%x\n",
-		       data->currfid, fid);
-		return 1;
-	}
-
 	dprintk("cpu %d, changing to fid 0x%x, vid 0x%x\n",
 		smp_processor_id(), fid, vid);
 	freqs.old = find_khz_freq_from_fid(data->currfid);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index c9c1190..02ce824 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -215,7 +215,8 @@ struct pst_s {
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k8", msg)
 
-static int core_voltage_pre_transition(struct powernow_k8_data *data, u32 reqvid);
+static int core_voltage_pre_transition(struct powernow_k8_data *data,
+	u32 reqvid, u32 regfid);
 static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvid);
 static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
 
-- 
1.6.0.2


