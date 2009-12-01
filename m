Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZLAGFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZLAGFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZLAGFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:05:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZLAGFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:05:11 -0500
Message-ID: <4B14B201.9030708@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 14:04:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <f.weisbecker@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf annotate: Fix perf data parsing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-annotate doesn't parse perf.data correctly in that it doesn't
read perf header. Fix this by using mmap_dispatch_perf_file().

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
---
 tools/perf/builtin-annotate.c |  143 +++++-----------------------------------
 tools/perf/util/event.c       |    3 +-
 2 files changed, 19 insertions(+), 127 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7d39bd2..37b163f 100644
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
@@ -197,35 +194,6 @@ static int process_sample_event(event_t *event)
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
@@ -526,99 +494,26 @@ static void find_annotations(void)
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
@@ -636,7 +531,7 @@ more:
 
 	find_annotations();
 
-	return rc;
+	return ret;
 }
 
 static const char * const annotate_usage[] = {
@@ -685,8 +580,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 	if (symbol__init(&symbol_conf) < 0)
 		return -1;
 
-	page_size = getpagesize();
-
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
 	setup_sorting();
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 70b4aa0..b5b333e 100644
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
-- 
1.6.3

