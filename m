Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbZJOVLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbZJOVLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbZJOVK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:10:59 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48874 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbZJOVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ALeSsucawPHcsQTZWzH0ZDZBdiJLfK7RLHCN4xflmy54l4Ba9Di0gA9RlmhhLOaFnf
         Yj4DpRMeyNYS2WNv9LPJQ5sD3lSCFcWO4kKQAMx5CFArzZaJAlG+c7oeasQR80aN3Tmt
         YFNOyDqtHXOioWJax1QogbVzp12pa/98yq5NU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf tools: Add a new generic section in perf.data
Date: Thu, 15 Oct 2009 23:10:17 +0200
Message-Id: <1255641017-13958-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new generic section into the perf.data file. This section simply
stands as a set of subsections that can be added once it is needed.
This section is versioned so that it's flexible enough to carry a
backward and forward compatibility with other versions of this generic
section.

For now it only handles the trace_info subsection.

This whole change is backward compatible with .32 perf.data but
not with the current development version for .33

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/header.c |  104 ++++++++++++++++++++++++++++++++--------------
 tools/perf/util/header.h |    4 +-
 2 files changed, 75 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9aae360..d11c467 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -64,8 +64,8 @@ struct perf_header *perf_header__new(void)
 
 	self->data_offset = 0;
 	self->data_size = 0;
-	self->trace_info_offset = 0;
-	self->trace_info_size = 0;
+	self->adds_offset = 0;
+	self->adds_size = 0;
 
 	return self;
 }
@@ -142,6 +142,15 @@ struct perf_file_attr {
 	struct perf_file_section	ids;
 };
 
+/*
+ * Version 0: contains trace_info section only
+ */
+struct perf_file_additionals {
+	u64				version;
+	struct perf_file_section	trace_info;
+};
+
+
 struct perf_file_header {
 	u64				magic;
 	u64				size;
@@ -149,7 +158,7 @@ struct perf_file_header {
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
 	struct perf_file_section	event_types;
-	struct perf_file_section	trace_info;
+	struct perf_file_section	adds;
 };
 
 static int trace_info;
@@ -172,6 +181,34 @@ static void do_write(int fd, void *buf, size_t size)
 	}
 }
 
+static void perf_header__adds_write(struct perf_header *self, int fd)
+{
+	struct perf_file_additionals adds = {
+		.version = 0,
+		.trace_info = {
+			.offset = 0,
+			.size	= 0,
+		},
+	};
+
+	self->adds_offset = lseek(fd, 0, SEEK_CUR);
+	lseek(fd, sizeof(adds), SEEK_CUR);
+
+	if (trace_info) {
+		adds.trace_info.offset = lseek(fd, 0, SEEK_CUR);
+		read_tracing_data(fd, attrs, nr_counters);
+		adds.trace_info.size = lseek(fd, 0, SEEK_CUR) -
+					     adds.trace_info.offset;
+	}
+
+	self->adds_size = lseek(fd, 0, SEEK_CUR) - self->adds_offset;
+
+	/* Write adds headers */
+	lseek(fd, self->adds_offset, SEEK_SET);
+	do_write(fd, &adds, sizeof(adds));
+	lseek(fd, self->adds_offset + self->adds_size, SEEK_SET);
+};
+
 void perf_header__write(struct perf_header *self, int fd)
 {
 	struct perf_file_header f_header;
@@ -210,23 +247,7 @@ void perf_header__write(struct perf_header *self, int fd)
 	if (events)
 		do_write(fd, events, self->event_size);
 
-	if (trace_info) {
-		static int trace_info_written;
-
-		/*
-		 * Write it only once
-		 */
-		if (!trace_info_written) {
-			self->trace_info_offset = lseek(fd, 0, SEEK_CUR);
-			read_tracing_data(fd, attrs, nr_counters);
-			self->trace_info_size = lseek(fd, 0, SEEK_CUR) -
-						self->trace_info_offset;
-			trace_info_written = 1;
-		} else {
-			lseek(fd, self->trace_info_offset +
-				self->trace_info_size, SEEK_SET);
-		}
-	}
+	perf_header__adds_write(self, fd);
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -246,9 +267,9 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->event_offset,
 			.size	= self->event_size,
 		},
-		.trace_info = {
-			.offset = self->trace_info_offset,
-			.size = self->trace_info_size,
+		.adds = {
+			.offset = self->adds_offset,
+			.size = self->adds_size,
 		},
 	};
 
@@ -274,6 +295,30 @@ static void do_read(int fd, void *buf, size_t size)
 	}
 }
 
+/*
+ * Version 0: only need to read trace info
+ */
+static void perf_header__adds_read(struct perf_header *self, int fd)
+{
+	struct perf_file_additionals adds;
+
+	/* Previous versions don't have adds section */
+	if (!self->adds_size)
+		return;
+
+	lseek(fd, self->adds_offset, SEEK_SET);
+	do_read(fd, &adds, sizeof(adds));
+
+	/*
+	 * Every adds section versions need to handle at least
+	 * the trace info
+	 */
+	if (adds.trace_info.size) {
+		lseek(fd, adds.trace_info.offset, SEEK_SET);
+		trace_report(fd);
+	}
+};
+
 struct perf_header *perf_header__read(int fd)
 {
 	struct perf_header	*self = perf_header__new();
@@ -292,8 +337,8 @@ struct perf_header *perf_header__read(int fd)
 
 	if (f_header.size != sizeof(f_header)) {
 		/* Support the previous format */
-		if (f_header.size == offsetof(typeof(f_header), trace_info))
-			f_header.trace_info.size = 0;
+		if (f_header.size == offsetof(typeof(f_header), adds))
+			f_header.adds.size = 0;
 		else
 			die("incompatible file format");
 	}
@@ -330,13 +375,10 @@ struct perf_header *perf_header__read(int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	self->trace_info_offset = f_header.trace_info.offset;
-	self->trace_info_size = f_header.trace_info.size;
+	self->adds_offset = f_header.adds.offset;
+	self->adds_size = f_header.adds.size;
 
-	if (self->trace_info_size) {
-		lseek(fd, self->trace_info_offset, SEEK_SET);
-		trace_report(fd);
-	}
+	perf_header__adds_read(self, fd);
 
 	self->event_offset = f_header.event_types.offset;
 	self->event_size   = f_header.event_types.size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 30aee51..8198022 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -21,8 +21,8 @@ struct perf_header {
 	u64 data_size;
 	u64 event_offset;
 	u64 event_size;
-	u64 trace_info_offset;
-	u64 trace_info_size;
+	u64 adds_offset;
+	u64 adds_size;
 };
 
 struct perf_header *perf_header__read(int fd);
-- 
1.6.2.3

