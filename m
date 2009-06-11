Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZFKP1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZFKP1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbZFKP0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:26:48 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:3088 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZFKP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:26:47 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: davej@codemonkey.org.uk
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, andreas.herrmann3@amd.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com, trenn@suse.de
Message-Id: <20090611152603.8510.31943.sendpatchset@linux-fd7s.americas.hpqcorp.net>
In-Reply-To: <20090611152558.8510.75249.sendpatchset@linux-fd7s.americas.hpqcorp.net>
References: <20090611152558.8510.75249.sendpatchset@linux-fd7s.americas.hpqcorp.net>
Subject: [PATCH 1/2] powernow-k8: read P-state from HW
Date: Thu, 11 Jun 2009 15:26:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By definition, "cpuinfo_cur_freq" should report the value from HW. So, don't
depend on the cached value. Instead read P-state directly from HW, while
taking into account the erratum 311 workaround for Fam 11h processors.


Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Langsdorf, Mark <mark.langsdorf@amd.com>
Cc: Thomas Renninger <trenn@suse.de>

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Langsdorf, Mark <mark.langsdorf@amd.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index cf52215..700ede9 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -117,20 +117,17 @@ static int query_current_values_with_pending_wait(struct powernow_k8_data *data)
 	u32 i = 0;
 
 	if (cpu_family == CPU_HW_PSTATE) {
-		if (data->currpstate == HW_PSTATE_INVALID) {
-			/* read (initial) hw pstate if not yet set */
-			rdmsr(MSR_PSTATE_STATUS, lo, hi);
-			i = lo & HW_PSTATE_MASK;
-
-			/*
-			 * a workaround for family 11h erratum 311 might cause
-			 * an "out-of-range Pstate if the core is in Pstate-0
-			 */
-			if (i >= data->numps)
-				data->currpstate = HW_PSTATE_0;
-			else
-				data->currpstate = i;
-		}
+		rdmsr(MSR_PSTATE_STATUS, lo, hi);
+		i = lo & HW_PSTATE_MASK;
+		data->currpstate = i;
+
+		/*
+		 * a workaround for family 11h erratum 311 might cause
+		 * an "out-of-range Pstate if the core is in Pstate-0
+		 */
+		if ((boot_cpu_data.x86 == 0x11) && (i >= data->numps))
+			data->currpstate = HW_PSTATE_0;
+
 		return 0;
 	}
 	do {
-- 
1.6.2.2

