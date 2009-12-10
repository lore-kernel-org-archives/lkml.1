Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbZLJHvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbZLJHvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760722AbZLJHvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:51:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:46555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760721AbZLJHu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:50:59 -0500
Date: Thu, 10 Dec 2009 07:50:30 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Add max delay time snapshot
Message-ID: <tip-3786310afe738070be31c439b8deeaeb69b9735d@git.kernel.org>
Git-Commit-ID: 3786310afe738070be31c439b8deeaeb69b9735d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3786310afe738070be31c439b8deeaeb69b9735d
Gitweb:     http://git.kernel.org/tip/3786310afe738070be31c439b8deeaeb69b9735d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 9 Dec 2009 21:40:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:30:26 +0100

perf sched: Add max delay time snapshot

When we have a maximum latency reported for a task, we need a
convenient way to find the matching location to the raw traces
or to perf sched map that shows where the task has been
eventually scheduled in. This gives a pointer to retrieve the
events that occured during this max latency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-sched.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b12b23a..7cca7c1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -140,6 +140,7 @@ struct work_atoms {
 	struct thread		*thread;
 	struct rb_node		node;
 	u64			max_lat;
+	u64			max_lat_at;
 	u64			total_lat;
 	u64			nb_atoms;
 	u64			total_runtime;
@@ -1013,8 +1014,10 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 
 	delta = atom->sched_in_time - atom->wake_up_time;
 	atoms->total_lat += delta;
-	if (delta > atoms->max_lat)
+	if (delta > atoms->max_lat) {
 		atoms->max_lat = delta;
+		atoms->max_lat_at = timestamp;
+	}
 	atoms->nb_atoms++;
 }
 
@@ -1210,10 +1213,11 @@ static void output_lat_thread(struct work_atoms *work_list)
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
+	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
-		 (double)work_list->max_lat / 1e6);
+		 (double)work_list->max_lat / 1e6,
+		 (double)work_list->max_lat_at / 1e9);
 }
 
 static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
@@ -1704,9 +1708,9 @@ static void __cmd_lat(void)
 	read_events();
 	sort_lat();
 
-	printf("\n -----------------------------------------------------------------------------------------\n");
-	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
-	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
+	printf(" ---------------------------------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sorted_atom_root);
 
