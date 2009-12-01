Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZLAHbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZLAHbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZLAHba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:31:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:34689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZLAHb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:31:29 -0500
Date: Tue, 1 Dec 2009 07:30:52 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, arjan@infradead.org,
       fweisbec@gmail.com, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, arjan@infradead.org,
       fweisbec@gmail.com, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B14B201.9030708@cn.fujitsu.com>
References: <4B14B201.9030708@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix perf data parsing
Message-ID: <tip-bab81b624e970f1138535a465ad2b26b6bb0dd6c@git.kernel.org>
Git-Commit-ID: bab81b624e970f1138535a465ad2b26b6bb0dd6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bab81b624e970f1138535a465ad2b26b6bb0dd6c
Gitweb:     http://git.kernel.org/tip/bab81b624e970f1138535a465ad2b26b6bb0dd6c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 14:04:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:14:08 +0100

perf annotate: Fix perf data parsing

perf-annotate doesn't parse perf.data correctly in that it
doesn't read perf header. Fix this by using
mmap_dispatch_perf_file().

Before:

TOTAL events:      17565
      MMAP events:       3221
      LOST events:         10
      COMM events:        235
      EXIT events:          2
  THROTTLE events:          1
UNTHROTTLE events:          2
      FORK events:         10
      READ events:          1
    SAMPLE events:      14083

After:

TOTAL events:      17290
      MMAP events:       3203
      LOST events:          0
      COMM events:        234
      EXIT events:          1
  THROTTLE events:          0
UNTHROTTLE events:          0
      FORK events:          0
      READ events:          0
    SAMPLE events:      13852

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <4B14B201.9030708@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |  143 +++++-----------------------------------
 tools/perf/util/event.c       |    3 +-
 2 files changed, 19 insertions(+), 127 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7f85c6e..0bf2e8f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,19 +25,16 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
 
 static int		force;
-static int		input;
 
 static int		full_paths;
 
 static int		print_line;
 
-static unsigned long	page_size;
-static unsigned long	mmap_window = 32;
-
 struct sym_hist {
 	u64		sum;
 	u64		ip[0];
@@ -156,35 +153,6 @@ static int process_sample_event(event_t *event)
 	return 0;
 }
 
-static int event__process(event_t *self)
-{
-	switch (self->header.type) {
-	case PERF_RECORD_SAMPLE:
-		return process_sample_event(self);
-
-	case PERF_RECORD_MMAP:
-		return event__process_mmap(self);
-
-	case PERF_RECORD_COMM:
-		return event__process_comm(self);
-
-	case PERF_RECORD_FORK:
-		return event__process_task(self);
-	/*
-	 * We dont process them right now but they are fine:
-	 */
-
-	case PERF_RECORD_THROTTLE:
-	case PERF_RECORD_UNTHROTTLE:
-		return 0;
-
-	default:
-		return -1;
-	}
-
-	return 0;
-}
-
 static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 {
 	struct symbol *sym = he->sym;
@@ -485,99 +453,26 @@ static void find_annotations(void)
 	}
 }
 
+static struct perf_file_handler file_handler = {
+	.process_sample_event	= process_sample_event,
+	.process_mmap_event	= event__process_mmap,
+	.process_comm_event	= event__process_comm,
+	.process_fork_event	= event__process_task,
+};
+
 static int __cmd_annotate(void)
 {
-	int ret, rc = EXIT_FAILURE;
-	unsigned long offset = 0;
-	unsigned long head = 0;
-	struct stat input_stat;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-
-	register_idle_thread();
-
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		perror("failed to open file");
-		exit(-1);
-	}
-
-	ret = fstat(input, &input_stat);
-	if (ret < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
-		exit(-1);
-	}
-
-	if (!input_stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
-
-remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
-	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
-	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
-		int munmap_ret;
-
-		munmap_ret = munmap(buf, page_size * mmap_window);
-		assert(munmap_ret == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-	dump_printf("%p [%p]: event: %d\n",
-			(void *)(offset + head),
-			(void *)(long)event->header.size,
-			event->header.type);
-
-	if (!size || event__process(event) < 0) {
-
-		dump_printf("%p [%p]: skipping unknown header type: %d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.type);
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
-	}
-
-	head += size;
-
-	if (offset + head < (unsigned long)input_stat.st_size)
-		goto more;
+	struct perf_header *header;
+	struct thread *idle;
+	int ret;
 
-	rc = EXIT_SUCCESS;
-	close(input);
+	idle = register_idle_thread();
+	register_perf_file_handler(&file_handler);
 
+	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
+				      &event__cwdlen, &event__cwd);
+	if (ret)
+		return ret;
 
 	if (dump_trace) {
 		event__print_totals();
@@ -595,7 +490,7 @@ more:
 
 	find_annotations();
 
-	return rc;
+	return ret;
 }
 
 static const char * const annotate_usage[] = {
@@ -644,8 +539,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 	if (symbol__init(&symbol_conf) < 0)
 		return -1;
 
-	page_size = getpagesize();
-
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
 	setup_sorting();
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 233d7ad..414b89d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -186,8 +186,7 @@ int event__process_comm(event_t *self)
 {
 	struct thread *thread = threads__findnew(self->comm.pid);
 
-	dump_printf("PERF_RECORD_COMM: %s:%d\n",
-		    self->comm.comm, self->comm.pid);
+	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
 
 	if (thread == NULL || thread__set_comm(thread, self->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
