Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYKYVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYKYVqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbYKYVoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:44:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59198 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYKYVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:44:45 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/6] cpufreq_stats: Correct jiffies64/cputime64 conversion
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:44:42 -0800
Message-ID: <20081125214442.22900.20172.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpufreq_stats->time_in_state is a cputime64_t value, we ought
to convert the jiffies64 values to cputime64_t.  On platforms where
cputime != jiffies, this leads to accounting errors in the sysfs
reports.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 drivers/cpufreq/cpufreq_stats.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index c0ff97d..b5ccf86 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -55,14 +55,18 @@ cpufreq_stats_update (unsigned int cpu)
 {
 	struct cpufreq_stats *stat;
 	unsigned long long cur_time;
+	cputime64_t d;
 
 	cur_time = get_jiffies_64();
 	spin_lock(&cpufreq_stats_lock);
 	stat = per_cpu(cpufreq_stats_table, cpu);
-	if (stat->time_in_state)
+	if (stat->time_in_state) {
+		d = jiffies64_to_cputime64(cputime_sub(cur_time,
+					   stat->last_time));
 		stat->time_in_state[stat->last_index] =
 			cputime64_add(stat->time_in_state[stat->last_index],
-				      cputime_sub(cur_time, stat->last_time));
+				      d);
+	}
 	stat->last_time = cur_time;
 	spin_unlock(&cpufreq_stats_lock);
 	return 0;

