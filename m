Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676Ab0A0BIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0A0BIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0A0BII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:08:08 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0A0BIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:08:07 -0500
From: Mike Chan <mike@android.com>
Cc: Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
       Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Alexander Miller <Miller@fmi.uni-stuttgart.de>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] cpufreq: ondemand: Refactor frequency increase code
Date: Tue, 26 Jan 2010 17:06:47 -0800
Message-Id: <1264554408-20966-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make simpler to read and call.

*** v3 - Always call when powersave_bias is enabled.

Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b34ade..516d0fe 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -443,6 +443,17 @@ static struct attribute_group dbs_attr_group_old = {
 
 /************************** sysfs end ************************/
 
+static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
+{
+	if (dbs_tuners_ins.powersave_bias)
+		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
+	else if (p->cur == p->max)
+		return;
+
+	__cpufreq_driver_target(p, freq, dbs_tuners_ins.powersave_bias ?
+			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
+}
+
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
@@ -520,19 +531,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
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
+		dbs_freq_increase(policy, policy->max);
 		return;
 	}
 
-- 
1.6.6

