Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZKOObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZKOObp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZKOObp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:55673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZKOObo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:31:44 -0500
Date: Sun, 15 Nov 2009 14:30:37 GMT
From: tip-bot for Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, lucas.de.marchi@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lucas.de.marchi@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091115140507.GB21561@skywalker.lan>
References: <20091115140507.GB21561@skywalker.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Do not print ratio when task-clock event is not counted
Message-ID: <tip-7255fe2a42c612f2b8fe4c347f0a5f0c97d85a46@git.kernel.org>
Git-Commit-ID: 7255fe2a42c612f2b8fe4c347f0a5f0c97d85a46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7255fe2a42c612f2b8fe4c347f0a5f0c97d85a46
Gitweb:     http://git.kernel.org/tip/7255fe2a42c612f2b8fe4c347f0a5f0c97d85a46
Author:     Lucas De Marchi <lucas.de.marchi@gmail.com>
AuthorDate: Sun, 15 Nov 2009 12:05:08 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 15:25:50 +0100

perf stat: Do not print ratio when task-clock event is not counted

The ratio between the number of events and the time elapsed makes
sense only if task-clock event is counted. Otherwise it will be
simply a (confusing)

	#      0.000 M/sec

This patch outputs the ratio only if task-clock event is counted.
Some test examples of before and after:

Before:

 [lucas@skywalker linux.trees.git]$ sudo perf stat -e branch-misses -a -- sleep 1

	 Performance counter stats for 'sleep 1':

		1367818  branch-misses            #      0.000 M/sec

	    1.001494325  seconds time elapsed

After (without task-clock):

 [lucas@skywalker perf]$ sudo ./perf stat -e branch-misses -a -- sleep 1

	 Performance counter stats for 'sleep 1':

		1135044  branch-misses

	    1.001370775  seconds time elapsed

After (with task-clock):

 [lucas@skywalker perf]$ sudo ./perf stat -e branch-misses -e task-clock -a -- sleep 1

	 Performance counter stats for 'sleep 1':

		1070111  branch-misses            #      0.534 M/sec
	    2002.730893  task-clock-msecs         #      1.999 CPUs

	    1.001640292  seconds time elapsed

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091115140507.GB21561@skywalker.lan>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c6df377..c70d720 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -357,7 +357,8 @@ static void abs_printout(int counter, double avg)
 			ratio = avg / total;
 
 		fprintf(stderr, " # %10.3f IPC  ", ratio);
-	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter)) {
+	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter) &&
+			runtime_branches_stats.n != 0) {
 		total = avg_stats(&runtime_branches_stats);
 
 		if (total)
@@ -365,7 +366,7 @@ static void abs_printout(int counter, double avg)
 
 		fprintf(stderr, " # %10.3f %%    ", ratio);
 
-	} else {
+	} else if (runtime_nsecs_stats.n != 0) {
 		total = avg_stats(&runtime_nsecs_stats);
 
 		if (total)
