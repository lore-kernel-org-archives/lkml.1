Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbZBLUIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbZBLUIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZBLUIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:08:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35922 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZBLUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:08:11 -0500
From: Mike Chan <mike@android.com>
To: davej@codemonkey.org.uk
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: Governor poll frequency tuneables exported in config.
Date: Thu, 12 Feb 2009 12:08:04 -0800
Message-Id: <1234469284-15924-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.5.4.5
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    cpufreq: Governor poll frequency tuneables exported in config.
    
    Signed-off-by: Mike Chan <mike@android.com>

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 5f076ae..e9361a9 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -190,4 +190,17 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_MIN_TICKS
+	int "Ticks between governor polling interval."
+	default 10
+	help
+	  Minimum number of ticks between polling interval for governors.
+
+config CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER
+	int "Sampling rate multiplier for governors."
+	default 1000
+	help
+	  Sampling latency rate multiplied by the cpu switch latency.
+	  Affects governor polling.
+
 endif	# CPU_FREQ
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index ac0bbf2..7bc227e 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -51,11 +51,10 @@ static unsigned int def_sampling_rate;
 #define MIN_SAMPLING_RATE_RATIO			(2)
 /* for correct statistics, we need at least 10 ticks between each measure */
 #define MIN_STAT_SAMPLING_RATE			\
-			(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10))
+	(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(CONFIG_CPU_FREQ_MIN_TICKS))
 #define MIN_SAMPLING_RATE			\
 			(def_sampling_rate / MIN_SAMPLING_RATE_RATIO)
 #define MAX_SAMPLING_RATE			(500 * def_sampling_rate)
-#define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(10)
 #define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
@@ -523,7 +522,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				latency = 1;
 
 			def_sampling_rate = 10 * latency *
-					DEF_SAMPLING_RATE_LATENCY_MULTIPLIER;
+				CONFIG_CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER;
 
 			if (def_sampling_rate < MIN_STAT_SAMPLING_RATE)
 				def_sampling_rate = MIN_STAT_SAMPLING_RATE;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 33855cb..c7df643 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -42,11 +42,10 @@ static unsigned int def_sampling_rate;
 #define MIN_SAMPLING_RATE_RATIO			(2)
 /* for correct statistics, we need at least 10 ticks between each measure */
 #define MIN_STAT_SAMPLING_RATE 			\
-			(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10))
+	(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(CONFIG_CPU_FREQ_MIN_TICKS))
 #define MIN_SAMPLING_RATE			\
 			(def_sampling_rate / MIN_SAMPLING_RATE_RATIO)
 #define MAX_SAMPLING_RATE			(500 * def_sampling_rate)
-#define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
 #define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
 
 static void do_dbs_timer(struct work_struct *work);
@@ -542,7 +541,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				latency = 1;
 
 			def_sampling_rate = latency *
-					DEF_SAMPLING_RATE_LATENCY_MULTIPLIER;
+				CONFIG_CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER;
 
 			if (def_sampling_rate < MIN_STAT_SAMPLING_RATE)
 				def_sampling_rate = MIN_STAT_SAMPLING_RATE;
