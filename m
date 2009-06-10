Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbZFJPnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbZFJPnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760047AbZFJPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:43:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760188AbZFJPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:43:30 -0400
Date: Wed, 10 Jun 2009 15:42:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Propagate signals properly
Message-ID: <tip-f7b7c26e01e51fe46097e11f179dc71ce7950084@git.kernel.org>
Git-Commit-ID: f7b7c26e01e51fe46097e11f179dc71ce7950084
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 15:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7b7c26e01e51fe46097e11f179dc71ce7950084
Gitweb:     http://git.kernel.org/tip/f7b7c26e01e51fe46097e11f179dc71ce7950084
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 15:55:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 16:55:27 +0200

perf_counter tools: Propagate signals properly

Currently report and stat catch SIGINT (and others) without altering
their exit state. This means that things like:

   while :; do perf stat ./foo ; done

Loops become hard-to-interrupt, because bash never sees perf terminate
due to interruption. Fix this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   12 ++++++++++++
 tools/perf/builtin-stat.c   |   13 +++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a5698ad..c10553c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -169,10 +169,21 @@ static void mmap_read(struct mmap_data *md)
 }
 
 static volatile int done = 0;
+static volatile int signr = -1;
 
 static void sig_handler(int sig)
 {
 	done = 1;
+	signr = sig;
+}
+
+static void sig_atexit(void)
+{
+	if (signr == -1)
+		return;
+
+	signal(signr, SIG_DFL);
+	kill(getpid(), signr);
 }
 
 static void pid_synthesize_comm_event(pid_t pid, int full)
@@ -459,6 +470,7 @@ static int __cmd_record(int argc, const char **argv)
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
+	atexit(sig_atexit);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8085509..6404906 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,8 +296,20 @@ static int do_perf_stat(int argc, const char **argv)
 	return 0;
 }
 
+static volatile int signr = -1;
+
 static void skip_signal(int signo)
 {
+	signr = signo;
+}
+
+static void sig_atexit(void)
+{
+	if (signr == -1)
+		return;
+
+	signal(signr, SIG_DFL);
+	kill(getpid(), signr);
 }
 
 static const char * const stat_usage[] = {
@@ -345,6 +357,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	 * What we want is for Ctrl-C to work in the exec()-ed
 	 * task, but being ignored by perf stat itself:
 	 */
+	atexit(sig_atexit);
 	signal(SIGINT,  skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
