Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZIPK0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZIPK0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZIPK0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:26:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbZIPK03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:26:29 -0400
Date: Wed, 16 Sep 2009 10:25:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Make idle thread and comm/pid names more consistent
Message-ID: <tip-80ed0987f363d7eb50193df3e6f6d71451f74bc3@git.kernel.org>
Git-Commit-ID: 80ed0987f363d7eb50193df3e6f6d71451f74bc3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:26:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80ed0987f363d7eb50193df3e6f6d71451f74bc3
Gitweb:     http://git.kernel.org/tip/80ed0987f363d7eb50193df3e6f6d71451f74bc3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 14:12:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 12:15:47 +0200

perf sched: Make idle thread and comm/pid names more consistent

Peter noticed that we have 3 ways of referring to the idle thread:

 [idle]:0
 swapper:0
 swapper-0

Standardize on 'swapper:0'.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |    4 ++--
 tools/perf/util/thread.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2d54236..da8f674 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1204,13 +1204,13 @@ static void output_lat_thread(struct work_atoms *work_list)
 	/*
 	 * Ignore idle threads:
 	 */
-	if (!work_list->thread->pid)
+	if (!strcmp(work_list->thread->comm, "swapper"))
 		return;
 
 	all_runtime += work_list->total_runtime;
 	all_count += work_list->nb_atoms;
 
-	ret = printf("  %s-%d ", work_list->thread->comm, work_list->thread->pid);
+	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->pid);
 
 	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7635928..12c4341 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -85,7 +85,7 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
 
-	if (!thread || thread__set_comm(thread, "[init]")) {
+	if (!thread || thread__set_comm(thread, "swapper")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
