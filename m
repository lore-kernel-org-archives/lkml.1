Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbZISJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbZISJwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbZISJwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:57081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbZISJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:52:17 -0400
Date: Sat, 19 Sep 2009 09:51:51 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090912130405.6960d099@infradead.org>
References: <20090912130405.6960d099@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Store trace event name/id pairs in perf.data
Message-ID: <tip-8755a8f27ae590dde225f9005ee18c6d9c4c6d78@git.kernel.org>
Git-Commit-ID: 8755a8f27ae590dde225f9005ee18c6d9c4c6d78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 09:51:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8755a8f27ae590dde225f9005ee18c6d9c4c6d78
Gitweb:     http://git.kernel.org/tip/8755a8f27ae590dde225f9005ee18c6d9c4c6d78
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 12 Sep 2009 07:52:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 11:42:11 +0200

perf: Store trace event name/id pairs in perf.data

The trace event name<->id mapping is dynamic for each kernel
compile. In order for perf.data to be useable outside the actual
system, we thus need to store a table of this mapping for later
use.

This patch adds this table to perf.data, and provides helper
functions for lookup up fields from this table.

To avoid mistakes, lookup-from-table is kept completely seprate
from lookup-from-local-debugfs.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090912130405.6960d099@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index a9bdcab..89172fd 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,6 +6,7 @@
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
+#include "header.h"
 
 int					nr_counters;
 
@@ -687,11 +688,35 @@ modifier:
 	return ret;
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
 	enum event_result ret;
 
+	if (strchr(str, ':'))
+		store_event_type(str);
+
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
