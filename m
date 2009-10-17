Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZJQPMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZJQPMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZJQPMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:12:42 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52807 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZJQPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YWLZ4KPg6jKqS1QgYY4Dl985CIutLxBAEFrs2fItZD+p2xUUQw4VOeBmoU8SF+vc1a
         V1OWOwJ172ev/Ehgog3YOeiXzhdSC9SeMUKz5WLvaSx8qL7SqTPC6ccxznM+OgvQPGoR
         yA3PgYtMtIhTqY3Aq7BL7aSpmtRMZvsP1CD8E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] perf tools: Introduce bitmask'ed additional headers
Date: Sat, 17 Oct 2009 17:12:34 +0200
Message-Id: <1255792354-11304-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091016074222.GD30019@elte.hu>
References: <20091016074222.GD30019@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a new set of bitmasked headers. A new field is added
in the perf headers that implements a bitmap storing optional features
present in the perf.data file.

The layout can be pictured like this:

(Usual perf headers)(Features bitmap)[Feature 0][Feature n][Feature 255]

If the bit n is set, then the feature n is used in this file. They are
all set in order. This brings a backward and forward compatibility.

The trace_info section has moved into such optional features, this is
the first and only one for now.

This is backward compatible with the .32 file version although it
doesn't support the previous separate trace.info file.

And finally it doesn't support the current interim development version.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-record.c |    4 +-
 tools/perf/util/header.c    |  100 ++++++++++++++++++++++++-------------------
 tools/perf/util/header.h    |   30 +++++++++----
 3 files changed, 78 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fc3709c..f0467ff 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -574,11 +574,11 @@ static int __cmd_record(int argc, const char **argv)
 		header = perf_header__new();
 
 	if (raw_samples) {
-		perf_header__set_trace_info();
+		perf_header__feat_trace_info(header);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				perf_header__set_trace_info();
+				perf_header__feat_trace_info(header);
 				break;
 			}
 		}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9aae360..171d51b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,6 +8,8 @@
 #include "../perf.h"
 #include "trace-event.h"
 
+#include <linux/bitmap.h>
+
 /*
  * Create new perf.data header attribute:
  */
@@ -48,25 +50,17 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
  */
 struct perf_header *perf_header__new(void)
 {
-	struct perf_header *self = malloc(sizeof(*self));
+	struct perf_header *self = calloc(sizeof(*self), 1);
 
 	if (!self)
 		die("nomem");
 
-	self->frozen = 0;
-
-	self->attrs = 0;
 	self->size = 1;
 	self->attr = malloc(sizeof(void *));
 
 	if (!self->attr)
 		die("nomem");
 
-	self->data_offset = 0;
-	self->data_size = 0;
-	self->trace_info_offset = 0;
-	self->trace_info_size = 0;
-
 	return self;
 }
 
@@ -149,14 +143,12 @@ struct perf_file_header {
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
 	struct perf_file_section	event_types;
-	struct perf_file_section	trace_info;
+	feat_mask_t			adds_features;
 };
 
-static int trace_info;
-
-void perf_header__set_trace_info(void)
+void perf_header__feat_trace_info(struct perf_header *header)
 {
-	trace_info = 1;
+	set_bit(HEADER_TRACE_INFO, perf_header__adds_mask(header));
 }
 
 static void do_write(int fd, void *buf, size_t size)
@@ -172,6 +164,32 @@ static void do_write(int fd, void *buf, size_t size)
 	}
 }
 
+static void perf_header__adds_write(struct perf_header *self, int fd)
+{
+	struct perf_file_section trace_sec;
+	u64 cur_offset = lseek(fd, 0, SEEK_CUR);
+	unsigned long *feat_mask = perf_header__adds_mask(self);
+
+	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
+		/* Write trace info */
+		trace_sec.offset = lseek(fd, sizeof(trace_sec), SEEK_CUR);
+		read_tracing_data(fd, attrs, nr_counters);
+		trace_sec.size = lseek(fd, 0, SEEK_CUR) - trace_sec.offset;
+
+		/* Write trace info headers */
+		lseek(fd, cur_offset, SEEK_SET);
+		do_write(fd, &trace_sec, sizeof(trace_sec));
+
+		/*
+		 * Update cur_offset. So that other (future)
+		 * features can set their own infos in this place. But if we are
+		 * the only feature, at least that seeks to the place the data
+		 * should begin.
+		 */
+		cur_offset = lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
+	}
+};
+
 void perf_header__write(struct perf_header *self, int fd)
 {
 	struct perf_file_header f_header;
@@ -210,23 +228,7 @@ void perf_header__write(struct perf_header *self, int fd)
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
 
@@ -246,12 +248,10 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->event_offset,
 			.size	= self->event_size,
 		},
-		.trace_info = {
-			.offset = self->trace_info_offset,
-			.size = self->trace_info_size,
-		},
 	};
 
+	memcpy(&f_header.adds_features, &self->adds_features, sizeof(feat_mask_t));
+
 	lseek(fd, 0, SEEK_SET);
 	do_write(fd, &f_header, sizeof(f_header));
 	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
@@ -274,6 +274,20 @@ static void do_read(int fd, void *buf, size_t size)
 	}
 }
 
+static void perf_header__adds_read(struct perf_header *self, int fd)
+{
+	const unsigned long *feat_mask = perf_header__adds_mask(self);
+
+	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
+		struct perf_file_section trace_sec;
+
+		do_read(fd, &trace_sec, sizeof(trace_sec));
+		lseek(fd, trace_sec.offset, SEEK_SET);
+		trace_report(fd);
+		lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
+	}
+};
+
 struct perf_header *perf_header__read(int fd)
 {
 	struct perf_header	*self = perf_header__new();
@@ -292,9 +306,11 @@ struct perf_header *perf_header__read(int fd)
 
 	if (f_header.size != sizeof(f_header)) {
 		/* Support the previous format */
-		if (f_header.size == offsetof(typeof(f_header), trace_info))
-			f_header.trace_info.size = 0;
-		else
+		if (f_header.size == offsetof(typeof(f_header), adds_features)) {
+			unsigned long *mask = (unsigned long *)(void *)
+					&f_header.adds_features;
+			bitmap_zero(mask, HEADER_FEAT_BITS);
+		} else
 			die("incompatible file format");
 	}
 	nr_attrs = f_header.attrs.size / sizeof(f_attr);
@@ -330,13 +346,9 @@ struct perf_header *perf_header__read(int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	self->trace_info_offset = f_header.trace_info.offset;
-	self->trace_info_size = f_header.trace_info.size;
+	memcpy(&self->adds_features, &f_header.adds_features, sizeof(feat_mask_t));
 
-	if (self->trace_info_size) {
-		lseek(fd, self->trace_info_offset, SEEK_SET);
-		trace_report(fd);
-	}
+	perf_header__adds_read(self, fd);
 
 	self->event_offset = f_header.event_types.offset;
 	self->event_size   = f_header.event_types.size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 30aee51..0eb4a91 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -12,19 +12,29 @@ struct perf_header_attr {
 	off_t id_offset;
 };
 
+#define HEADER_TRACE_INFO			1
+
+#define HEADER_FEAT_BITS			256
+
+typedef	typeof(u64[HEADER_FEAT_BITS / 8])	feat_mask_t;
+
 struct perf_header {
-	int frozen;
-	int attrs, size;
+	int			frozen;
+	int			attrs, size;
 	struct perf_header_attr **attr;
-	s64 attr_offset;
-	u64 data_offset;
-	u64 data_size;
-	u64 event_offset;
-	u64 event_size;
-	u64 trace_info_offset;
-	u64 trace_info_size;
+	s64			attr_offset;
+	u64			data_offset;
+	u64			data_size;
+	u64			event_offset;
+	u64			event_size;
+	feat_mask_t		adds_features;
 };
 
+static inline unsigned long *perf_header__adds_mask(struct perf_header *self)
+{
+	return (unsigned long *)(void *)&self->adds_features;
+}
+
 struct perf_header *perf_header__read(int fd);
 void perf_header__write(struct perf_header *self, int fd);
 
@@ -42,7 +52,7 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
-void perf_header__set_trace_info(void);
+void perf_header__feat_trace_info(struct perf_header *header);
 
 struct perf_header *perf_header__new(void);
 
-- 
1.6.2.3

