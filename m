Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZGHN4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZGHN4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZGHN4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:56:38 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33944 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZGHN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Ps5SCrAl4y+WVG20pqovMpRcOVrNRnFCG8v1tTx3Txco9SO62Pz+8oaSvbsBAFN3fF
         PcPjNrWL0/2EtmFnCn/l+X0UddfxVAnIw4XFVPKT2JrzTtxxCPE56FoX3DUTR16wxfmT
         7fCJT3Um3yV6FigzAY9Z59veprHaeGBnDmbpg=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] cpufreq: ondemand: Introduces stepped frequency increase
Date: Wed, 8 Jul 2009 15:56:33 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30.1cz; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081556.34682.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
as found in conservative governor, to chose the frequency increase step,
expressed as percentage (default = 100 is previous behaviour).

This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
* absorb punctual load spikes
* stabilize at the needed frequency, without passing for more power consuming states, and

Signed-off-by: Corrado Zoccolo czoccolo@gmail.com

---
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index e741c33..baa7b5e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -83,6 +83,7 @@ struct cpu_dbs_info_s {
 	unsigned int freq_lo;
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
+	int requested_delta;
 	int cpu;
 	unsigned int enable:1,
 		sample_type:1;
@@ -112,11 +113,13 @@ static struct dbs_tuners {
 	unsigned int down_differential;
 	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int freq_step;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.freq_step = 100,
 };
 
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
@@ -261,6 +264,7 @@ show_one(sampling_rate, sampling_rate);
 show_one(up_threshold, up_threshold);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
+show_one(freq_step, freq_step);
 
 static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
 		const char *buf, size_t count)
@@ -358,6 +362,28 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *unused,
 	return count;
 }
 
+static ssize_t store_freq_step(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+
+	if (ret != 1)
+		return -EINVAL;
+
+	if (input > 100)
+		input = 100;
+
+	/* no need to test here if freq_step is zero as the user might actually
+	 * want this, they would be crazy though :) */
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.freq_step = input;
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
 #define define_one_rw(_name) \
 static struct freq_attr _name = \
 __ATTR(_name, 0644, show_##_name, store_##_name)
@@ -366,6 +392,7 @@ define_one_rw(sampling_rate);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
 define_one_rw(powersave_bias);
+define_one_rw(freq_step);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -374,6 +401,7 @@ static struct attribute *dbs_attributes[] = {
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
+	&freq_step.attr,
 	NULL
 };
 
@@ -464,19 +492,30 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	/* Check for frequency increase */
 	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
+		unsigned int freq_target = this_dbs_info->requested_delta
+			+ policy->cur;
+		unsigned int freq_step;
+
 		/* if we are already at full speed then break out early */
-		if (!dbs_tuners_ins.powersave_bias) {
-			if (policy->cur == policy->max)
-				return;
+		if (freq_target == policy->max)
+			return;
+
+		freq_step = (dbs_tuners_ins.freq_step * (policy->max-policy->min))
+			/ 100;
 
-			__cpufreq_driver_target(policy, policy->max,
-				CPUFREQ_RELATION_H);
+		freq_target += max(freq_step, 5U);
+		freq_target = max(policy->min, min(policy->max, freq_target));
+
+		if (!dbs_tuners_ins.powersave_bias) {
+			__cpufreq_driver_target(policy, freq_target,
+						CPUFREQ_RELATION_H);
 		} else {
-			int freq = powersave_bias_target(policy, policy->max,
-					CPUFREQ_RELATION_H);
+			unsigned int freq = powersave_bias_target(policy, freq_target,
+								  CPUFREQ_RELATION_H);
 			__cpufreq_driver_target(policy, freq,
 				CPUFREQ_RELATION_L);
 		}
+		this_dbs_info->requested_delta = freq_target - policy->cur;
 		return;
 	}
 
@@ -507,6 +546,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			__cpufreq_driver_target(policy, freq,
 				CPUFREQ_RELATION_L);
 		}
+		this_dbs_info->requested_delta = freq_next - policy->cur;
 	}
 }
 

