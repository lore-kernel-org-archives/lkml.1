Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZILLEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZILLEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZILLEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:04:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:43138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZILLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:07 -0400
Date: Sat, 12 Sep 2009 13:04:05 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: [PATCH 2/8] perf: Store trace event name/id pairs in perf.data
Message-ID: <20090912130405.6960d099@infradead.org>
In-Reply-To: <20090912130306.5d0086ea@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c9d9dfc617df7a6a6029feb486f2433b7d825ef4 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 12 Sep 2009 07:52:51 +0200
Subject: [PATCH] perf: Store trace event name/id pairs in perf.data

The trace event name<->id mapping is dynamic for each kernel compile.
In order for perf.data to be useable outside the actual system, we thus
need to store a table of this mapping for later use.

This patch adds this table to perf.data, and provides helper functions
for lookup up fields from this table.

To avoid mistakes, lookup-from-table is kept completely seprate from
lookup-from-local-debugfs.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/util/header.c       |   59 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h       |    6 ++++
 tools/perf/util/parse-events.c |   25 +++++++++++++++++
 3 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ec4d4c2..ef91145 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -86,6 +86,44 @@ void perf_header__add_attr(struct perf_header *self,
 	self->attr[pos] = attr;
 }
 
+struct perf_trace_event_type {
+	u64	event_id;
+	char	name[64];
+};
+
+static int event_count;
+static struct perf_trace_event_type *events;
+
+void perf_header__push_event(u64 id, const char *name)
+{
+	if (strlen(name) > 64)
+		printf("Event %s will be truncated\n", name);
+
+	if (!events) {
+		events = malloc(sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	} else {
+		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	}
+	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
+	events[event_count].event_id = id;
+	strncpy(events[event_count].name, name, 63);
+	event_count++;
+}
+
+char *perf_header__find_event(u64 id)
+{
+	int i;
+	for (i = 0 ; i < event_count; i++) {
+		if (events[i].event_id == id)
+			return events[i].name;
+	}
+	return NULL;
+}
+
 static const char *__perf_magic = "PERFFILE";
 
 #define PERF_MAGIC	(*(u64 *)__perf_magic)
@@ -106,6 +144,7 @@ struct perf_file_header {
 	u64				attr_size;
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
+	struct perf_file_section	event_types;
 };
 
 static void do_write(int fd, void *buf, size_t size)
@@ -154,6 +193,11 @@ void perf_header__write(struct perf_header *self, int fd)
 		do_write(fd, &f_attr, sizeof(f_attr));
 	}
 
+	self->event_offset = lseek(fd, 0, SEEK_CUR);
+	self->event_size = event_count * sizeof(struct perf_trace_event_type);
+	if (events)
+		do_write(fd, events, self->event_size);
+
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -169,6 +213,10 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->data_offset,
 			.size	= self->data_size,
 		},
+		.event_types = {
+			.offset = self->event_offset,
+			.size	= self->event_size,
+		},
 	};
 
 	lseek(fd, 0, SEEK_SET);
@@ -234,6 +282,17 @@ struct perf_header *perf_header__read(int fd)
 		lseek(fd, tmp, SEEK_SET);
 	}
 
+	if (f_header.event_types.size) {
+		lseek(fd, f_header.event_types.offset, SEEK_SET);
+		events = malloc(f_header.event_types.size);
+		if (!events)
+			die("nomem");
+		do_read(fd, events, f_header.event_types.size);
+		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+	}
+	self->event_offset = f_header.event_types.offset;
+	self->event_size   = f_header.event_types.size;
+
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 5d0a72e..7b0e84a 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -19,6 +19,8 @@ struct perf_header {
 	s64 attr_offset;
 	u64 data_offset;
 	u64 data_size;
+	u64 event_offset;
+	u64 event_size;
 };
 
 struct perf_header *perf_header__read(int fd);
@@ -27,6 +29,10 @@ void perf_header__write(struct perf_header *self, int fd);
 void perf_header__add_attr(struct perf_header *self,
 			   struct perf_header_attr *attr);
 
+void perf_header__push_event(u64 id, const char *name);
+char *perf_header__find_event(u64 id);
+
+
 struct perf_header_attr *
 perf_header_attr__new(struct perf_counter_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a587d41..37f1357 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,6 +6,7 @@
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
+#include "header.h"
 
 int					nr_counters;
 
@@ -583,10 +584,34 @@ static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 	return 1;
 }
 
+static void store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id;
+
+	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return;
+	if (fscanf(file, "%i", &id) < 1)
+		die("cannot store event ID");
+	fclose(file);
+	perf_header__push_event(id, orgname);
+}
+
+
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
 
+	if (strchr(str, ':'))
+		store_event_type(str);
+
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
