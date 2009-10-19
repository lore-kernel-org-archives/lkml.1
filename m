Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZJSH4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZJSH4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZJSH4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:56:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZJSH4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:56:03 -0400
Date: Mon, 19 Oct 2009 07:55:31 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091018112923.GQ4808@kryten>
References: <20091018112923.GQ4808@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add branch performance metric
Message-ID: <tip-11018201b831e19304c0d639f105ad6c27e120b1@git.kernel.org>
Git-Commit-ID: 11018201b831e19304c0d639f105ad6c27e120b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Oct 2009 07:55:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11018201b831e19304c0d639f105ad6c27e120b1
Gitweb:     http://git.kernel.org/tip/11018201b831e19304c0d639f105ad6c27e120b1
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Sun, 18 Oct 2009 22:29:23 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Oct 2009 09:20:21 +0200

perf stat: Add branch performance metric

When we count both branches and branch-misses it is useful to
print out the percentage of branch-misses:

 # perf stat -e branches -e branch-misses /bin/true

 Performance counter stats for '/bin/true':

         401684  branches                 #      0.000 M/sec
          23301  branch-misses            #      5.801 %

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: paulus@samba.org
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <20091018112923.GQ4808@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3db31e7..c373683 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -125,6 +125,7 @@ struct stats			event_res_stats[MAX_COUNTERS][3];
 struct stats			runtime_nsecs_stats;
 struct stats			walltime_nsecs_stats;
 struct stats			runtime_cycles_stats;
+struct stats			runtime_branches_stats;
 
 #define MATCH_EVENT(t, c, counter)			\
 	(attrs[counter].type == PERF_TYPE_##t &&	\
@@ -235,6 +236,8 @@ static void read_counter(int counter)
 		update_stats(&runtime_nsecs_stats, count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
 		update_stats(&runtime_cycles_stats, count[0]);
+	if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
+		update_stats(&runtime_branches_stats, count[0]);
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -352,6 +355,14 @@ static void abs_printout(int counter, double avg)
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
 
