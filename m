Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbZEOKOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbZEOKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759199AbZEOKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:14:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:47327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbZEOKOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:14:11 -0400
Date: Fri, 15 May 2009 10:12:30 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: handle Ctrl-C
Message-ID: <tip-58d7e993b16b62d30f8ef27757614056fe4def11@git.kernel.org>
Git-Commit-ID: 58d7e993b16b62d30f8ef27757614056fe4def11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 10:12:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58d7e993b16b62d30f8ef27757614056fe4def11
Gitweb:     http://git.kernel.org/tip/58d7e993b16b62d30f8ef27757614056fe4def11
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 15 May 2009 11:03:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 12:09:54 +0200

perf stat: handle Ctrl-C

Before this change, if a long-running perf stat workload was Ctrl-C-ed,
the utility exited without displaying statistics.

After the change, the Ctrl-C gets propagated into the workload (and
causes its early exit there), but perf stat itself will still continue
to run and will display counter results.

This is useful to run open-ended workloads, let them run for
a while, then Ctrl-C them to get the stats.

[ Impact: extend perf stat with new functionality ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index cf575c3..03518d7 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -538,8 +538,14 @@ static void process_options(int argc, char **argv)
 	}
 }
 
+static void skip_signal(int signo)
+{
+}
+
 int cmd_stat(int argc, char **argv, const char *prefix)
 {
+	sigset_t blocked;
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	process_options(argc, argv);
@@ -548,5 +554,15 @@ int cmd_stat(int argc, char **argv, const char *prefix)
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
+	/*
+	 * We dont want to block the signals - that would cause
+	 * child tasks to inherit that and Ctrl-C would not work.
+	 * What we want is for Ctrl-C to work in the exec()-ed
+	 * task, but being ignored by perf stat itself:
+	 */
+	signal(SIGINT,  skip_signal);
+	signal(SIGALRM, skip_signal);
+	signal(SIGABRT, skip_signal);
+
 	return do_perfstat(argc, argv);
 }
