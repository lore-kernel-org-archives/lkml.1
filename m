Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZJRLaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZJRLaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZJRLaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 07:30:18 -0400
Received: from ozlabs.org ([203.10.76.45]:42411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZJRLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 07:30:17 -0400
Date: Sun, 18 Oct 2009 22:29:23 +1100
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf stat: Add branch performance metric
Message-ID: <20091018112923.GQ4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we count both branches and branch-misses it is useful to print out
the percentage of branch-misses:

# perf stat -e branches -e branch-misses /bin/true

 Performance counter stats for '/bin/true':

         401684  branches                 #      0.000 M/sec
          23301  branch-misses            #      5.801 %  

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3db31e7..6a2e37e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -125,6 +125,7 @@ struct stats			event_res_stats[MAX_COUNTERS][3];
 struct stats			runtime_nsecs_stats;
 struct stats			walltime_nsecs_stats;
 struct stats			runtime_cycles_stats;
+struct stats			runtime_branches_stats;
 
 #define MATCH_EVENT(t, c, counter)			\
 	(attrs[counter].type == PERF_TYPE_##t &&	\
@@ -235,6 +237,8 @@ static void read_counter(int counter)
 		update_stats(&runtime_nsecs_stats, count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
 		update_stats(&runtime_cycles_stats, count[0]);
+	if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
+		update_stats(&runtime_branches_stats, count[0]);
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -352,6 +356,14 @@ static void abs_printout(int counter, double avg)
 			ratio = avg / total;
 
 		fprintf(stderr, " # %10.3f IPC  ", ratio);
+	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter)) {
+		total = avg_stats(&runtime_branches_stats);
+
+		if (total)
+			ratio = avg * 100 / total;
+
+		fprintf(stderr, " # %10.3f %%  ", ratio);
+
 	} else {
 		total = avg_stats(&runtime_nsecs_stats);
 
