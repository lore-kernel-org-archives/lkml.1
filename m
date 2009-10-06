Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZJFGK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZJFGK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZJFGKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:10:55 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:55143 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbZJFGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OG3kDQbCfXce6LC966GzvIijrpupIHeqfWy3TFeVrgMRuf/7K8oNtuzD0M76jRG3bQ
         raHSP9roy9Ijpj0lJgJRCcRx7TctHPHYMyBCZuct92QFIhbWPM9PelZZKMPkzRlJ+d4Q
         U66p+QyVpPoij6SRDWyKPKy0HJjkWbB9e/pPc=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 9/9] perf trace: Add throwaway timestamp sorting
Date: Tue,  6 Oct 2009 01:09:58 -0500
Message-Id: <1254809398-8078-10-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugly, stupid, non-scaleable code for sorting the perf trace input.
Hopefully it will soon be replaced by something better but for now
it's needed for script processing since most scripts like to process
events in the same order they occurred.  Non-scripted perf trace
processing still uses the old unsorted path.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |  525 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 524 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b151e77..e539292 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -20,6 +20,7 @@ static unsigned long	mmap_window = 32;
 
 static unsigned long	total = 0;
 static unsigned long	total_comm = 0;
+static unsigned long	total_sample = 0;
 
 static struct rb_root	threads;
 static struct thread	*last_match;
@@ -32,6 +33,10 @@ static char		const *script_name;
 static int		do_perl;
 static int		generate_handlers;
 
+static unsigned long	outbuf_head;
+static event_t		**sorted_events;
+static int		sorted_idx;
+
 static int default_start_script(const char *script __attribute((unused)))
 {
 	return 0;
@@ -167,6 +172,513 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static int
+count_event(event_t *event)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_MMAP ... PERF_RECORD_LOST:
+		return 0;
+
+	case PERF_RECORD_COMM:
+		total_comm++;
+		return 0;
+
+	case PERF_RECORD_EXIT ... PERF_RECORD_READ:
+		return 0;
+
+	case PERF_RECORD_SAMPLE:
+		total_sample++;
+		return 0;
+
+	case PERF_RECORD_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int count_events(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	if (!size || count_event(event) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static int copy_header(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	char *buf, *outbuf;
+	int output;
+	int res;
+
+	trace_report();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+
+	buf = (char *)mmap(NULL, perf_stat.st_size, PROT_READ,
+			   MAP_SHARED, input, 0);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+	output = open("perf.data.tmp",
+		      O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (output < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	if (ftruncate(output, head) < 0) {
+		perror("failed to truncate file");
+		exit(-1);
+	}
+
+	outbuf = (char *)mmap(NULL, head, PROT_WRITE,
+			      MAP_SHARED, output, 0);
+	if (outbuf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+	memcpy(outbuf, buf, head);
+
+	res = munmap(buf, perf_stat.st_size);
+	assert(res == 0);
+
+	res = munmap(outbuf, head);
+	assert(res == 0);
+
+	close(input);
+	close(output);
+
+	return rc;
+}
+
+static int
+copy_comm_event(char *outbuf, event_t *event, int size)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_MMAP ... PERF_RECORD_LOST:
+		return 0;
+
+	case PERF_RECORD_COMM:
+		memcpy(outbuf, event, size);
+		outbuf_head += size;
+		return 0;
+
+	case PERF_RECORD_EXIT ... PERF_RECORD_READ:
+		return 0;
+
+	case PERF_RECORD_SAMPLE:
+		return 0;
+
+	case PERF_RECORD_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int copy_comm_events(void)
+{
+	struct stat perf_stat, output_perf_stat;
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	char *buf, *outbuf;
+	event_t *event;
+	uint32_t size;
+	int output;
+	int res;
+
+	trace_report();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	output = open("perf.data.tmp",
+		      O_RDWR | O_APPEND | O_LARGEFILE, 0644);
+	if (output < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(output, &output_perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!output_perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	if (ftruncate(output, perf_stat.st_size) < 0) {
+		perror("failed to truncate file");
+		exit(-1);
+	}
+
+	outbuf = (char *)mmap(NULL, perf_stat.st_size, PROT_WRITE,
+			      MAP_SHARED, output, 0);
+	if (outbuf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+	outbuf_head = output_perf_stat.st_size;
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	if (!size || copy_comm_event(outbuf + outbuf_head, event, size) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	res = munmap(outbuf, head);
+	assert(res == 0);
+
+	if (ftruncate(output, output_perf_stat.st_size + outbuf_head) < 0) {
+		perror("failed to truncate file");
+		exit(-1);
+	}
+
+	close(output);
+
+	return rc;
+}
+
+static int
+save_sort_event(event_t *event)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_MMAP ... PERF_RECORD_LOST:
+		return 0;
+
+	case PERF_RECORD_COMM:
+		return 0;
+
+	case PERF_RECORD_EXIT ... PERF_RECORD_READ:
+		return 0;
+
+	case PERF_RECORD_SAMPLE:
+		sorted_events[sorted_idx++] = event;
+		return 0;
+
+	case PERF_RECORD_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int event_cmp(const void *a, const void *b)
+{
+	const event_t **pa = (const event_t **)a;
+	const event_t **pb = (const event_t **)b;
+	const event_t *eventa = *pa;
+	const event_t *eventb = *pb;
+	const void *more_data;
+	u64 timea, timeb;
+
+	more_data = eventa->ip.__more_data;
+	timea = *(u64 *)more_data;
+
+	more_data = eventb->ip.__more_data;
+	timeb = *(u64 *)more_data;
+
+	if (timea < timeb)
+		return -1;
+	if (timea > timeb)
+		return 1;
+
+	return 0;
+}
+
+static int sort_sample_events(void)
+{
+	struct stat perf_stat, output_perf_stat;
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	char *buf, *outbuf;
+	event_t *event;
+	uint32_t size;
+	int output;
+	int res;
+	unsigned i;
+
+	sorted_events = malloc(total_sample * sizeof(event_t *));
+	if (!sorted_events) {
+		perror("failed to malloc sample array");
+		exit(-1);
+	}
+
+	trace_report();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	buf = (char *)mmap(NULL, perf_stat.st_size, PROT_READ,
+			   MAP_SHARED, input, 0);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+
+	if (!size || save_sort_event(event) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	qsort(sorted_events, total_sample, sizeof(event_t *), event_cmp);
+
+	output = open("perf.data.tmp",
+		      O_RDWR | O_APPEND | O_LARGEFILE, 0644);
+	if (output < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(output, &output_perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!output_perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	if (ftruncate(output, perf_stat.st_size) < 0) {
+		perror("failed to truncate file");
+		exit(-1);
+	}
+
+	outbuf = (char *)mmap(NULL, perf_stat.st_size, PROT_WRITE,
+			      MAP_SHARED, output, 0);
+	if (outbuf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+	outbuf_head = output_perf_stat.st_size;
+
+	for (i = 0; i < total_sample; i++) {
+		event = sorted_events[i];
+		memcpy(outbuf + outbuf_head, sorted_events[i],
+		       event->header.size);
+		outbuf_head += event->header.size;
+	}
+
+	res = munmap(outbuf, head);
+	assert(res == 0);
+
+	if (ftruncate(output, output_perf_stat.st_size + outbuf_head) < 0) {
+		perror("failed to truncate file");
+		exit(-1);
+	}
+
+	close(output);
+
+	return rc;
+}
+
 static int __cmd_trace(void)
 {
 	int ret, rc = EXIT_FAILURE;
@@ -180,7 +692,11 @@ static int __cmd_trace(void)
 	trace_report();
 	register_idle_thread(&threads, &last_match);
 
-	input = open(input_name, O_RDONLY);
+	if (script_name)
+		input = open("perf.data.tmp", O_RDONLY);
+	else
+		input = open(input_name, O_RDONLY);
+
 	if (input < 0) {
 		perror("failed to open file");
 		exit(-1);
@@ -334,10 +850,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		err = scripting_ops->start_script(script_name);
 		if (err)
 			goto out;
+
+		count_events();
+		copy_header();
+		copy_comm_events();
+		sort_sample_events();
 	}
 
 	err = __cmd_trace();
 
+	unlink("perf.data.tmp");
+
 	cleanup_scripting();
 out:
 	return err;
-- 
1.6.4.GIT

