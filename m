Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZFCIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZFCIrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZFCIrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbZFCIrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:47:06 -0400
Date: Wed, 3 Jun 2009 08:46:32 GMT
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
Subject: [tip:perfcounters/core] perf report: Print -D to stdout
Message-ID: <tip-97dd543cbd39f762357ba6cd5bfd94771851c96b@git.kernel.org>
Git-Commit-ID: 97dd543cbd39f762357ba6cd5bfd94771851c96b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 08:46:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97dd543cbd39f762357ba6cd5bfd94771851c96b
Gitweb:     http://git.kernel.org/tip/97dd543cbd39f762357ba6cd5bfd94771851c96b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 09:38:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 09:38:58 +0200

perf report: Print -D to stdout

-D prints to stderr - which is a bit confusing - print to stdout
instead.

Also clean up the if (dump_trace) patterns via a dprintf helper.

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
 Documentation/perf_counter/builtin-report.c |   65 ++++++++++++--------------
 1 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 9da990f..2c8034f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -31,6 +31,8 @@ static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
+#define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
+
 static int		verbose;
 static int		full_paths;
 
@@ -729,14 +731,12 @@ more:
 		uint64_t ip = event->ip.ip;
 		struct map *map = NULL;
 
-		if (dump_trace) {
-			fprintf(stderr, "%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
-				(void *)(offset + head),
-				(void *)(long)(event->header.size),
-				event->header.misc,
-				event->ip.pid,
-				(void *)(long)ip);
-		}
+		dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->header.misc,
+			event->ip.pid,
+			(void *)(long)ip);
 
 		if (thread == NULL) {
 			fprintf(stderr, "problem processing %d event, skipping it.\n",
@@ -781,15 +781,14 @@ more:
 		struct thread *thread = threads__findnew(event->mmap.pid);
 		struct map *map = map__new(&event->mmap, cwdp, cwdlen);
 
-		if (dump_trace) {
-			fprintf(stderr, "%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
-				(void *)(offset + head),
-				(void *)(long)(event->header.size),
-				(void *)(long)event->mmap.start,
-				(void *)(long)event->mmap.len,
-				(void *)(long)event->mmap.pgoff,
-				event->mmap.filename);
-		}
+		dprintf("%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			(void *)(long)event->mmap.start,
+			(void *)(long)event->mmap.len,
+			(void *)(long)event->mmap.pgoff,
+			event->mmap.filename);
+
 		if (thread == NULL || map == NULL) {
 			if (verbose)
 				fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
@@ -802,12 +801,11 @@ more:
 	case PERF_EVENT_COMM: {
 		struct thread *thread = threads__findnew(event->comm.pid);
 
-		if (dump_trace) {
-			fprintf(stderr, "%p [%p]: PERF_EVENT_COMM: %s:%d\n",
-				(void *)(offset + head),
-				(void *)(long)(event->header.size),
-				event->comm.comm, event->comm.pid);
-		}
+		dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->comm.comm, event->comm.pid);
+
 		if (thread == NULL ||
 		    thread__set_comm(thread, event->comm.comm)) {
 			fprintf(stderr, "problem processing PERF_EVENT_COMM, skipping event.\n");
@@ -818,11 +816,10 @@ more:
 	}
 	default: {
 broken_event:
-		if (dump_trace)
-			fprintf(stderr, "%p [%p]: skipping unknown header type: %d\n",
-					(void *)(offset + head),
-					(void *)(long)(event->header.size),
-					event->header.type);
+		dprintf("%p [%p]: skipping unknown header type: %d\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->header.type);
 
 		total_unknown++;
 
@@ -846,14 +843,12 @@ broken_event:
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	if (dump_trace) {
-		fprintf(stderr, "      IP events: %10ld\n", total);
-		fprintf(stderr, "    mmap events: %10ld\n", total_mmap);
-		fprintf(stderr, "    comm events: %10ld\n", total_comm);
-		fprintf(stderr, " unknown events: %10ld\n", total_unknown);
+	dprintf("      IP events: %10ld\n", total);
+	dprintf("    mmap events: %10ld\n", total_mmap);
+	dprintf("    comm events: %10ld\n", total_comm);
+	dprintf(" unknown events: %10ld\n", total_unknown);
 
-		return 0;
-	}
+	return 0;
 
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
