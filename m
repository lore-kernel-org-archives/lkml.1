Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbXHVJJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbXHVJJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758938AbXHVIxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:50 -0400
Received: from 1wt.eu ([62.212.114.60]:2170 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbXHVIxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:46 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084045.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:41 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 57/58] CPUFREQ: ondemand: add a check to avoid negative load calculation
Content-Disposition: inline; filename=0057-CPUFREQ-ondemand-add-a-check-to-avoid-negative-loa.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Due to rounding and inexact jiffy accounting, idle_ticks can sometimes
be higher than total_ticks. Make sure those cases are handled as
zero load case.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/cpufreq/cpufreq_ondemand.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 3bfaeb5..1d11d13 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -334,7 +334,7 @@ static struct attribute_group dbs_attr_group = {
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int idle_ticks, total_ticks;
-	unsigned int load;
+	unsigned int load = 0;
 	cputime64_t cur_jiffies;
 
 	struct cpufreq_policy *policy;
@@ -380,7 +380,8 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		if (tmp_idle_ticks < idle_ticks)
 			idle_ticks = tmp_idle_ticks;
 	}
-	load = (100 * (total_ticks - idle_ticks)) / total_ticks;
+	if (likely(total_ticks > idle_ticks))
+		load = (100 * (total_ticks - idle_ticks)) / total_ticks;
 
 	/* Check for frequency increase */
 	if (load > dbs_tuners_ins.up_threshold) {
-- 
1.5.2.5

-- 
