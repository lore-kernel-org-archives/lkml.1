Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0CCUq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:46:58 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:20784
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752525Ab0CCUqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:46:52 -0500
X-SpamScore: 4
X-BigFish: VPS4(zzab9bha4b1kzz1202hzzz32i2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYQ4DW-02-MXU-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <bhavna.sarathy@amd.com>, <joachim.deguara@amd.com>,
       <borislav.petkov@amd.com>
Subject: [PATCH 3/3] cpufreq: add sysfs knob for toggling core performance boost
Date: Wed, 3 Mar 2010 14:59:27 -0600
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc6-tip; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201003031459.27757.mark.langsdorf@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1ba7af20a37b72a4375d3e3ddd33a033f204ee21 Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Wed, 3 Mar 2010 14:34:47 -0600
Subject: [PATCH 2/2] cpufreq: add sysfs knob for toggling core performance boost

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 drivers/cpufreq/cpufreq.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 67bc2ec..e0fe93f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -662,6 +662,30 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+				 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1))
+		policy->flags.cpb = val;
+	else
+		return -EINVAL;
+
+	ret = __cpufreq_driver_target(policy, policy->cur, CPUFREQ_RELATION_H);
+	if (ret)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", policy->flags.cpb);
+}
+
 #define define_one_ro(_name) \
 static struct freq_attr _name = \
 __ATTR(_name, 0444, show_##_name, NULL)
@@ -688,6 +712,7 @@ define_one_rw(scaling_min_freq);
 define_one_rw(scaling_max_freq);
 define_one_rw(scaling_governor);
 define_one_rw(scaling_setspeed);
+define_one_rw(cpb);
 
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
@@ -701,6 +726,7 @@ static struct attribute *default_attrs[] = {
 	&scaling_driver.attr,
 	&scaling_available_governors.attr,
 	&scaling_setspeed.attr,
+	&cpb.attr,
 	NULL
 };
 
-- 
1.6.0.2


