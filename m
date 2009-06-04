Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZFDIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZFDIHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZFDIHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:07:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:44733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbZFDIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:07:17 -0400
Date: Thu, 4 Jun 2009 08:06:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf top: Reduce default filter threshold
Message-ID: <tip-6e53cdf11dfc8d302ebb67e7112d1baf8d7c66d4@git.kernel.org>
Git-Commit-ID: 6e53cdf11dfc8d302ebb67e7112d1baf8d7c66d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 08:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e53cdf11dfc8d302ebb67e7112d1baf8d7c66d4
Gitweb:     http://git.kernel.org/tip/6e53cdf11dfc8d302ebb67e7112d1baf8d7c66d4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 08:53:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 09:02:12 +0200

perf top: Reduce default filter threshold

On idle systems 'perf top' comes up empty by default, because the event
count filter is set to 100.

Reduce it to 5 instead.

Also add an option to limit the number of functions displayed.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 7c907e2..3f7778b 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -64,9 +64,10 @@ static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static __u64			count_filter		       = 100;
+static __u64			count_filter			=  5;
+static int			print_entries			= 15;
 
-static int			target_pid				= -1;
+static int			target_pid			= -1;
 static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
 static unsigned int		realtime_prio			=  0;
@@ -254,7 +255,7 @@ static void print_sym_table(void)
 		struct symbol *sym = (struct symbol *)(syme + 1);
 		float pcnt;
 
-		if (++printed > 18 || syme->snap_count < count_filter)
+		if (++printed > print_entries || syme->snap_count < count_filter)
 			continue;
 
 		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->snap_count) /
@@ -650,7 +651,7 @@ static const struct option options[] = {
 		    "number of seconds to delay between refreshes"),
 	OPT_BOOLEAN('D', "dump-symtab", &dump_symtab,
 			    "dump the symbol table used for profiling"),
-	OPT_INTEGER('f', "--count-filter", &count_filter,
+	OPT_INTEGER('f', "count-filter", &count_filter,
 		    "only display functions with more events than this"),
 	OPT_BOOLEAN('g', "group", &group,
 			    "put the counters into a counter group"),
@@ -662,8 +663,10 @@ static const struct option options[] = {
 		    "track mmap events"),
 	OPT_BOOLEAN('U', "use-munmap", &use_munmap,
 		    "track munmap events"),
-	OPT_INTEGER('F', "--freq", &freq,
+	OPT_INTEGER('F', "freq", &freq,
 		    "profile at this frequency"),
+	OPT_INTEGER('E', "entries", &print_entries,
+		    "display this many functions"),
 	OPT_END()
 };
 
