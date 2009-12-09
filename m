Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZLIUkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZLIUkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbZLIUkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:40:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5171 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780AbZLIUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jXjDcZ/fF+ka9vRa6czFLM7cNnv7JhqmaAPysGWYKvMvnkxQCJRpw/cfHmAo/8idZV
         clmP6ns1zMqyuyyUQ6S3kE73shn+mKn8OkPYb8EgzMCXbu6ll/iG4Yu42pgv+y515Zme
         JkMfeXJnxas4kQqWcesX3iFww4S8rmsIKCQ7c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf sched: Add max delay time snapshot
Date: Wed,  9 Dec 2009 21:40:08 +0100
Message-Id: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have a maximum latency reported for a task, we need a
convenient way to find the matching location to the raw traces
or to perf sched map that shows where the task has been eventually
scheduled in. This gives a pointer to retrieve the events that occured
during this max latency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
 
-- 
1.6.2.3

