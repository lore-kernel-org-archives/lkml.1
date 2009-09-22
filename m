Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZIVNfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZIVNfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZIVNfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:33896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZIVNfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:10 -0400
Date: Tue, 22 Sep 2009 13:34:29 GMT
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
Subject: [tip:perf/urgent] perf stat: Fix zero total printouts
Message-ID: <tip-c7f7fea30b7e52c9d4b9cef271110a98d59adcbc@git.kernel.org>
Git-Commit-ID: c7f7fea30b7e52c9d4b9cef271110a98d59adcbc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:34:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7f7fea30b7e52c9d4b9cef271110a98d59adcbc
Gitweb:     http://git.kernel.org/tip/c7f7fea30b7e52c9d4b9cef271110a98d59adcbc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 14:53:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 15:01:47 +0200

perf stat: Fix zero total printouts

Before:

           0  sched:sched_switch #        nan M/sec

After:

           0  sched:sched_switch #      0.000 M/sec

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 16af2d8..e5f6ece 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -338,14 +338,24 @@ static void nsec_printout(int counter, double avg)
 
 static void abs_printout(int counter, double avg)
 {
+	double total, ratio = 0.0;
+
 	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
-		fprintf(stderr, " # %10.3f IPC  ",
-				avg / avg_stats(&runtime_cycles_stats));
+		total = avg_stats(&runtime_cycles_stats);
+
+		if (total)
+			ratio = avg / total;
+
+		fprintf(stderr, " # %10.3f IPC  ", ratio);
 	} else {
-		fprintf(stderr, " # %10.3f M/sec",
-				1000.0 * avg / avg_stats(&runtime_nsecs_stats));
+		total = avg_stats(&runtime_nsecs_stats);
+
+		if (total)
+			ratio = 1000.0 * avg / total;
+
+		fprintf(stderr, " # %10.3f M/sec", ratio);
 	}
 }
 
