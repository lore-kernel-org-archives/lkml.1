Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZEZRz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZEZRz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZEZRzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:39141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZEZRzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:55:15 -0400
Date: Tue, 26 May 2009 17:54:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: add --dump-raw-trace option
Message-ID: <tip-97b07b699b11d4bd1218a841e5dfed16bd53de06@git.kernel.org>
Git-Commit-ID: 97b07b699b11d4bd1218a841e5dfed16bd53de06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 17:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97b07b699b11d4bd1218a841e5dfed16bd53de06
Gitweb:     http://git.kernel.org/tip/97b07b699b11d4bd1218a841e5dfed16bd53de06
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 18:48:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 18:48:58 +0200

perf report: add --dump-raw-trace option

To help the inspection of various data files, implement an ASCII dump
method that just dumps the records as they are read in - then we exit.

[ Impact: new feature ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   39 ++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index e178190..8ea8aaa 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -20,6 +20,8 @@ static char		const *input_name = "output.perf";
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
+static int		dump_trace = 0;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
@@ -643,7 +645,7 @@ static int __cmd_report(void)
 	char *buf;
 	event_t *event;
 	int ret, rc = EXIT_FAILURE;
-	unsigned long total = 0;
+	unsigned long total = 0, total_mmap = 0, total_comm = 0;
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -706,6 +708,13 @@ more:
 		struct thread *thread = threads__findnew(event->ip.pid);
 		uint64_t ip = event->ip.ip;
 
+		if (dump_trace) {
+			fprintf(stderr, "PERF_EVENT (IP, %d): %d: %p\n",
+				event->header.misc,
+				event->ip.pid,
+				(void *)event->ip.ip);
+		}
+
 		if (thread == NULL) {
 			fprintf(stderr, "problem processing %d event, bailing out\n",
 				event->header.type);
@@ -743,23 +752,40 @@ more:
 		struct thread *thread = threads__findnew(event->mmap.pid);
 		struct map *map = map__new(&event->mmap);
 
+		if (dump_trace) {
+			fprintf(stderr, "PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+				(void *)event->mmap.start,
+				(void *)event->mmap.len,
+				(void *)event->mmap.pgoff,
+				event->mmap.filename);
+		}
 		if (thread == NULL || map == NULL) {
 			fprintf(stderr, "problem processing PERF_EVENT_MMAP, bailing out\n");
 			goto done;
 		}
 		thread__insert_map(thread, map);
+		total_mmap++;
 		break;
 	}
 	case PERF_EVENT_COMM: {
 		struct thread *thread = threads__findnew(event->comm.pid);
 
+		if (dump_trace) {
+			fprintf(stderr, "PERF_EVENT_COMM: %s:%d\n",
+				event->comm.comm, event->comm.pid);
+		}
 		if (thread == NULL ||
 		    thread__set_comm(thread, event->comm.comm)) {
 			fprintf(stderr, "problem processing PERF_EVENT_COMM, bailing out\n");
 			goto done;
 		}
+		total_comm++;
 		break;
 	}
+	default: {
+		fprintf(stderr, "skipping unknown header type: %d\n",
+			event->header.type);
+	}
 	}
 
 	if (offset + head < stat.st_size)
@@ -768,6 +794,15 @@ more:
 	rc = EXIT_SUCCESS;
 done:
 	close(input);
+
+	if (dump_trace) {
+		fprintf(stderr, "   IP events: %10ld\n", total);
+		fprintf(stderr, " mmap events: %10ld\n", total_mmap);
+		fprintf(stderr, " comm events: %10ld\n", total_comm);
+
+		return 0;
+	}
+
 	//dsos__fprintf(stdout);
 	threads__fprintf(stdout);
 #if 0
@@ -796,6 +831,8 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
 	OPT_END()
 };
 
