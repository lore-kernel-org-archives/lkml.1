Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbZIDPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbZIDPoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbZIDPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:44:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:55580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbZIDPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:43:59 -0400
Date: Fri, 4 Sep 2009 15:43:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf stat: More advanced variance computation
Message-ID: <tip-8a02631a470d6f2ccec7bcf79c1058b0d4240bce@git.kernel.org>
Git-Commit-ID: 8a02631a470d6f2ccec7bcf79c1058b0d4240bce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 15:43:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a02631a470d6f2ccec7bcf79c1058b0d4240bce
Gitweb:     http://git.kernel.org/tip/8a02631a470d6f2ccec7bcf79c1058b0d4240bce
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Sep 2009 17:26:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 17:38:15 +0200

perf stat: More advanced variance computation

Use the more advanced single pass variance algorithm outlined
on the wikipedia page. This is numerically more stable for
larger sample sets.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e9424fa..32b5c00 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -79,29 +79,30 @@ static int			event_scaled[MAX_COUNTERS];
 
 struct stats
 {
-	double sum;
-	double sum_sq;
+	double n, mean, M2;
 };
 
 static void update_stats(struct stats *stats, u64 val)
 {
-	double sq = val;
+	double delta;
 
-	stats->sum += val;
-	stats->sum_sq += sq * sq;
+	stats->n++;
+	delta = val - stats->mean;
+	stats->mean += delta / stats->n;
+	stats->M2 += delta*(val - stats->mean);
 }
 
 static double avg_stats(struct stats *stats)
 {
-	return stats->sum / run_count;
+	return stats->mean;
 }
 
 /*
  * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
  *
- *      (\Sum n_i^2) - ((\Sum n_i)^2)/n
- * s^2  -------------------------------
- *                   n - 1
+ *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
+ * s^2 = -------------------------------
+ *                  n - 1
  *
  * http://en.wikipedia.org/wiki/Stddev
  *
@@ -114,9 +115,8 @@ static double avg_stats(struct stats *stats)
  */
 static double stddev_stats(struct stats *stats)
 {
-	double avg = stats->sum / run_count;
-	double variance = (stats->sum_sq - stats->sum*avg)/(run_count - 1);
-	double variance_mean = variance / run_count;
+	double variance = stats->M2 / (stats->n - 1);
+	double variance_mean = variance / stats->n;
 
 	return sqrt(variance_mean);
 }
