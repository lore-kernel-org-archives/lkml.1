Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724Ab0AUDQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0AUDQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974Ab0AUDQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:16:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0AUDQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:16:50 -0500
From: Mike Chan <mike@android.com>
To: cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miller@fmi.uni-stuttgart.de, tj@kernel.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de, davej@redhat.com,
       Mike Chan <mike@android.com>
Subject: [PATCH 1/2] cpufreq: ondemand: Refactor frequency increase code
Date: Wed, 20 Jan 2010 19:15:36 -0800
Message-Id: <1264043737-2505-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make simpler to read and call.

Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b34ade..3dcf126 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -443,6 +443,17 @@ static struct attribute_group dbs_attr_group_old = {
 
 /************************** sysfs end ************************/
 
+static int dbs_freq_increase(struct cpufreq_policy *p, unsigned int target_freq)
+{
+	if (dbs_tuners_ins.powersave_bias)
+		target_freq = powersave_bias_target(p, target_freq,
+				CPUFREQ_RELATION_H);
+
+	__cpufreq_driver_target(p, target_freq,
+			dbs_tuners_ins.powersave_bias ?
+			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
+}
+
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
@@ -520,19 +531,8 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	/* Check for frequency increase */
 	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
-		/* if we are already at full speed then break out early */
-		if (!dbs_tuners_ins.powersave_bias) {
-			if (policy->cur == policy->max)
-				return;
-
-			__cpufreq_driver_target(policy, policy->max,
-				CPUFREQ_RELATION_H);
-		} else {
-			int freq = powersave_bias_target(policy, policy->max,
-					CPUFREQ_RELATION_H);
-			__cpufreq_driver_target(policy, freq,
-				CPUFREQ_RELATION_L);
-		}
+		if (policy->cur != policy->max)
+			dbs_freq_increase(policy, policy->max);
 		return;
 	}
 
-- 
1.6.6

