Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZJELsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZJELsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbZJELsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:48:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:56787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbZJELsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:48:37 -0400
Date: Mon, 5 Oct 2009 11:47:22 GMT
From: tip-bot for Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, chris@chris-wilson.co.uk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, chris@chris-wilson.co.uk, mingo@elte.hu
In-Reply-To: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
References: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Propagate term signal to child
Message-ID: <tip-933da83aa17939a78d59708321c0b27d0ec8c6ce@git.kernel.org>
Git-Commit-ID: 933da83aa17939a78d59708321c0b27d0ec8c6ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 11:47:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  933da83aa17939a78d59708321c0b27d0ec8c6ce
Gitweb:     http://git.kernel.org/tip/933da83aa17939a78d59708321c0b27d0ec8c6ce
Author:     Chris Wilson <chris@chris-wilson.co.uk>
AuthorDate: Sun, 4 Oct 2009 01:35:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 4 Oct 2009 19:37:39 +0200

perf: Propagate term signal to child

If we launch the child on behalf of the user, ensure that it dies
along with ourselves when we are interrupted.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
LKML-Reference: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
