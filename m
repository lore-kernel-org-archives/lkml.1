Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZJQHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZJQHcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 03:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZJQHcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 03:32:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZJQHcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 03:32:20 -0400
Date: Sat, 17 Oct 2009 07:31:51 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0910170842500.9213@ask.diku.dk>
References: <Pine.LNX.4.64.0910170842500.9213@ask.diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move dereference after NULL test
Message-ID: <tip-f39cdf25bf77219676ec5360980ac40b1a7e144a@git.kernel.org>
Git-Commit-ID: f39cdf25bf77219676ec5360980ac40b1a7e144a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 07:31:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f39cdf25bf77219676ec5360980ac40b1a7e144a
Gitweb:     http://git.kernel.org/tip/f39cdf25bf77219676ec5360980ac40b1a7e144a
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Sat, 17 Oct 2009 08:43:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:29:10 +0200

perf tools: Move dereference after NULL test

In each case, if the NULL test on thread is needed, then the
dereference should be after the NULL test.

A simplified version of the semantic match that detects this
problem is as follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
LKML-Reference: <Pine.LNX.4.64.0910170842500.9213@ask.diku.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 tools/perf/builtin-sched.c    |    4 ++--
 tools/perf/builtin-trace.c    |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3fe0de0..56ba716 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -104,14 +104,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		event->ip.pid,
 		(void *)(long)ip);
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (thread == NULL) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
 	if (event->header.misc & PERF_RECORD_MISC_KERNEL) {
 		level = 'k';
 		sym = kernel_maps__find_symbol(ip, &map);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 015c797..a4f8cc2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -629,14 +629,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		}
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (thread == NULL) {
 		eprintf("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
 	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
 		return 0;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c9c6856..57ad3f4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1667,14 +1667,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (thread == NULL) {
 		eprintf("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
 	if (profile_cpu != -1 && profile_cpu != (int) cpu)
 		return 0;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ce8459a..4c129ff 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -80,14 +80,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (thread == NULL) {
 		eprintf("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
 	if (sample_type & PERF_SAMPLE_RAW) {
 		struct {
 			u32 size;
