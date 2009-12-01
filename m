Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZLAHbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZLAHbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZLAHbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:31:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:37181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZLAHbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:31:41 -0500
Date: Tue, 1 Dec 2009 07:31:06 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, arjan@infradead.org,
       fweisbec@gmail.com, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, arjan@infradead.org,
       fweisbec@gmail.com, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B14B21C.2040406@cn.fujitsu.com>
References: <4B14B21C.2040406@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Remove open-coded event parsing code
Message-ID: <tip-5cbd08056142dcb2aea0dca7261afcb810a63c55@git.kernel.org>
Git-Commit-ID: 5cbd08056142dcb2aea0dca7261afcb810a63c55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cbd08056142dcb2aea0dca7261afcb810a63c55
Gitweb:     http://git.kernel.org/tip/5cbd08056142dcb2aea0dca7261afcb810a63c55
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 14:05:16 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:14:09 +0100

perf timechart: Remove open-coded event parsing code

Convert builtin-timechart.c to mmap_dispatch_perf_file() +
perf_file_handler.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B14B21C.2040406@cn.fujitsu.com>
[ v2: cleaned up the printout, fixed a whitespace detail ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-timechart.c |  170 +++++++---------------------------------
 1 files changed, 30 insertions(+), 140 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index dd4d82a..cb58b66 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -29,14 +29,14 @@
 #include "util/header.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/event.h"
+#include "util/data_map.h"
 #include "util/svghelper.h"
 
 static char		const *input_name = "perf.data";
 static char		const *output_name = "output.svg";
 
 
-static unsigned long	page_size;
-static unsigned long	mmap_window = 32;
 static u64		sample_type;
 
 static unsigned int	numcpus;
@@ -49,8 +49,6 @@ static u64		first_time, last_time;
 static int		power_only;
 
 
-static struct perf_header	*header;
-
 struct per_pid;
 struct per_pidcomm;
 
@@ -156,9 +154,9 @@ struct sample_wrapper *all_samples;
 
 struct process_filter;
 struct process_filter {
-	char 			*name;
-	int  			pid;
-	struct process_filter 	*next;
+	char			*name;
+	int			pid;
+	struct process_filter	*next;
 };
 
 static struct process_filter *process_filter;
@@ -1045,36 +1043,6 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static int
-process_event(event_t *event)
-{
-
-	switch (event->header.type) {
-
-	case PERF_RECORD_COMM:
-		return process_comm_event(event);
-	case PERF_RECORD_FORK:
-		return process_fork_event(event);
-	case PERF_RECORD_EXIT:
-		return process_exit_event(event);
-	case PERF_RECORD_SAMPLE:
-		return queue_sample_event(event);
-
-	/*
-	 * We dont process them right now but they are fine:
-	 */
-	case PERF_RECORD_MMAP:
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
 static void process_samples(void)
 {
 	struct sample_wrapper *cursor;
@@ -1090,114 +1058,38 @@ static void process_samples(void)
 	}
 }
 
-
-static int __cmd_timechart(void)
+static int sample_type_check(u64 type)
 {
-	int err, rc = EXIT_FAILURE;
-	unsigned long offset = 0;
-	unsigned long head, shift;
-	struct stat statbuf;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-	int input;
-
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		fprintf(stderr, " failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			fprintf(stderr, "  (try 'perf record' first)");
-		fprintf(stderr, "\n");
-		exit(-1);
-	}
-
-	err = fstat(input, &statbuf);
-	if (err < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!statbuf.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
+	sample_type = type;
 
-	header = perf_header__new();
-	if (header == NULL)
-		return -ENOMEM;
-
-	err = perf_header__read(header, input);
-	if (err < 0) {
-		perf_header__delete(header);
-		return err;
-	}
-
-	head = header->data_offset;
-
-	sample_type = perf_header__sample_type(header);
-
-	shift = page_size * (head / page_size);
-	offset += shift;
-	head -= shift;
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
-		int ret2;
-
-		shift = page_size * (head / page_size);
-
-		ret2 = munmap(buf, page_size * mmap_window);
-		assert(ret2 == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-	if (!size || process_event(event) < 0) {
-		pr_warning("%p [%p]: skipping unknown header type: %d\n",
-			   (void *)(offset + head),
-			   (void *)(long)(event->header.size),
-			   event->header.type);
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
+	if (!(sample_type & PERF_SAMPLE_RAW)) {
+		fprintf(stderr, "No trace samples found in the file.\n"
+				"Have you used 'perf timechart record' to record it?\n");
+		return -1;
 	}
 
-	head += size;
+	return 0;
+}
 
-	if (offset + head >= header->data_offset + header->data_size)
-		goto done;
+static struct perf_file_handler file_handler = {
+	.process_comm_event	= process_comm_event,
+	.process_fork_event	= process_fork_event,
+	.process_exit_event	= process_exit_event,
+	.process_sample_event	= queue_sample_event,
+	.sample_type_check	= sample_type_check,
+};
 
-	if (offset + head < (unsigned long)statbuf.st_size)
-		goto more;
+static int __cmd_timechart(void)
+{
+	struct perf_header *header;
+	int ret;
 
-done:
-	rc = EXIT_SUCCESS;
-	close(input);
+	register_perf_file_handler(&file_handler);
 
+	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
+				      &event__cwdlen, &event__cwd);
+	if (ret)
+		return EXIT_FAILURE;
 
 	process_samples();
 
@@ -1210,7 +1102,7 @@ done:
 	pr_info("Written %2.1f seconds of trace to %s.\n",
 		(last_time - first_time) / 1000000000.0, output_name);
 
-	return rc;
+	return EXIT_SUCCESS;
 }
 
 static const char * const timechart_usage[] = {
@@ -1277,8 +1169,6 @@ int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init(0);
 
-	page_size = getpagesize();
-
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
