Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0AMCOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0AMCOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211Ab0AMCOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:14:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0AMCOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:14:36 -0500
From: Mike Chan <mike@android.com>
To: cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Jocelyn Falempe <jocelyn.falempe@motorola.com>,
       Mike Chan <mike@android.com>
Subject: [PATCH] cpufreq: ondemand: Don't synchronize sample rate unless mulitple cpus present
Date: Tue, 12 Jan 2010 18:14:30 -0800
Message-Id: <1263348870-2269-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jocelyn Falempe <jocelyn.falempe@motorola.com>

For UP systems this is not required, and results in a more consistent
sample interval.

Signed-off-by: Jocelyn Falempe <jocelyn.falempe@motorola.com>
Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b34ade..d139558 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -576,7 +576,9 @@ static void do_dbs_timer(struct work_struct *work)
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
-	delay -= jiffies % delay;
+	if (num_online_cpus() > 1)
+		delay -= jiffies % delay;
+
 	mutex_lock(&dbs_info->timer_mutex);
 
 	/* Common NORMAL_SAMPLE setup */
@@ -601,7 +603,9 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 {
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
-	delay -= jiffies % delay;
+
+	if (num_online_cpus() > 1)
+ 		delay -= jiffies % delay;
 
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
-- 
1.6.6

