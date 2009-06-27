Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZF0EhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZF0EhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZF0EhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:37:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZF0EhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:37:02 -0400
Date: Sat, 27 Jun 2009 04:36:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf stat: Fix multi-run stats
Message-ID: <tip-566747e6298289c5cb02d4939cb3abf1c4fe7e5a@git.kernel.org>
Git-Commit-ID: 566747e6298289c5cb02d4939cb3abf1c4fe7e5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Jun 2009 04:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  566747e6298289c5cb02d4939cb3abf1c4fe7e5a
Gitweb:     http://git.kernel.org/tip/566747e6298289c5cb02d4939cb3abf1c4fe7e5a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 27 Jun 2009 06:24:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Jun 2009 06:34:37 +0200

perf stat: Fix multi-run stats

In multi-run (-r/--repeat) printouts, print out the noise of
the wall-clock average as well.

Also, fix a bug in printing out scaled counters: if it was not
scaled then we should not update the average with -1.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index cdcd058..52c176c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -353,8 +353,11 @@ static void calc_avg(void)
 				event_res_avg[j]+1, event_res[i][j]+1);
 			update_avg("counter/2", j,
 				event_res_avg[j]+2, event_res[i][j]+2);
-			update_avg("scaled", j,
-				event_scaled_avg + j, event_scaled[i]+j);
+			if (event_scaled[i][j] != -1)
+				update_avg("scaled", j,
+					event_scaled_avg + j, event_scaled[i]+j);
+			else
+				event_scaled_avg[j] = -1;
 		}
 	}
 	runtime_nsecs_avg /= run_count;
@@ -420,9 +423,13 @@ static void print_stat(int argc, const char **argv)
 
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
+	fprintf(stderr, " %14.9f  seconds time elapsed",
 			(double)walltime_nsecs_avg/1e9);
-	fprintf(stderr, "\n");
+	if (run_count > 1) {
+		fprintf(stderr, "   ( +- %7.3f%% )",
+			100.0*(double)walltime_nsecs_noise/(double)walltime_nsecs_avg);
+	}
+	fprintf(stderr, "\n\n");
 }
 
 static volatile int signr = -1;
