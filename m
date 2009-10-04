Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZJDAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZJDAgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 20:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZJDAgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 20:36:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:64438 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756234AbZJDAgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 20:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,500,1249282800"; 
   d="scan'208";a="499603513"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] perf: Propagate term signal to child
Date: Sun,  4 Oct 2009 01:35:01 +0100
Message-Id: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we launch the child on behalf of the user, ensure that it dies along
with ourselves when we are interrupted.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 tools/perf/builtin-record.c |    6 ++++++
 tools/perf/builtin-stat.c   |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a5a050a..3eeef33 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,6 +41,7 @@ static int			raw_samples			= 0;
 static int			system_wide			= 0;
 static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
+static pid_t			child_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
@@ -184,6 +185,9 @@ static void sig_handler(int sig)
 
 static void sig_atexit(void)
 {
+	if (child_pid != -1)
+		kill(child_pid, SIGTERM);
+
 	if (signr == -1)
 		return;
 
@@ -610,6 +614,8 @@ static int __cmd_record(int argc, const char **argv)
 				exit(-1);
 			}
 		}
+
+		child_pid = pid;
 	}
 
 	if (realtime_prio) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e5f6ece..3db31e7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -69,7 +69,8 @@ static int			run_idx				=  0;
 static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
-static int			target_pid			= -1;
+static pid_t			target_pid			= -1;
+static pid_t			child_pid			= -1;
 static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -285,6 +286,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 		exit(-1);
 	}
 
+	child_pid = pid;
+
 	/*
 	 * Wait for the child to be ready to exec.
 	 */
@@ -433,6 +436,9 @@ static void skip_signal(int signo)
 
 static void sig_atexit(void)
 {
+	if (child_pid != -1)
+		kill(child_pid, SIGTERM);
+
 	if (signr == -1)
 		return;
 
-- 
1.6.4.3

