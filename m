Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0BCSwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:53464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab0BCSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/9] perf record: Stop intercepting events, use postprocessing to get build-ids
Date: Wed,  3 Feb 2010 16:52:05 -0200
Message-Id: <1265223128-11786-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1265223128-11786-1-git-send-email-acme@infradead.org>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We want to stream events as fast as possible to perf.data, and also in the
future we want to have splice working, when no interception will be possible.

Using build_id__mark_dso_hit_ops to create the list of DSOs that back MMAPs we
also optimize disk usage in the build-id cache by only caching DSOs that had
hits.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   37 ++++++++++++-------------
 tools/perf/util/header.c    |    7 +++-
 tools/perf/util/session.c   |   64 +++++++++++++++++++++++++-----------------
 tools/perf/util/session.h   |    3 ++
 tools/perf/util/symbol.c    |   13 +++++---
 tools/perf/util/symbol.h    |    2 +-
 6 files changed, 73 insertions(+), 53 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 949167e..706f001 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -12,6 +12,7 @@
 
 #include "perf.h"
 
+#include "util/build-id.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -65,6 +66,7 @@ static int			nr_poll				=      0;
 static int			nr_cpu				=      0;
 
 static int			file_new			=      1;
+static off_t			post_processing_offset;
 
 static struct perf_session	*session;
 
@@ -114,26 +116,10 @@ static void write_output(void *buf, size_t size)
 	}
 }
 
-static void write_event(event_t *buf, size_t size)
-{
-	/*
-	* Add it to the list of DSOs, so that when we finish this
-	 * record session we can pick the available build-ids.
-	 */
-	if (buf->header.type == PERF_RECORD_MMAP) {
-		struct list_head *head = &dsos__user;
-		if (buf->mmap.header.misc == 1)
-			head = &dsos__kernel;
-		__dsos__findnew(head, buf->mmap.filename);
-	}
-
-	write_output(buf, size);
-}
-
 static int process_synthesized_event(event_t *event,
 				     struct perf_session *self __used)
 {
-	write_event(event, event->header.size);
+	write_output(event, event->header.size);
 	return 0;
 }
 
@@ -185,14 +171,14 @@ static void mmap_read(struct mmap_data *md)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		write_event(buf, size);
+		write_output(buf, size);
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	write_event(buf, size);
+	write_output(buf, size);
 
 	md->prev = old;
 	mmap_write_tail(md, old);
@@ -402,10 +388,21 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
+static int process_buildids(void)
+{
+	u64 size = lseek(output, 0, SEEK_CUR);
+
+	session->fd = output;
+	return __perf_session__process_events(session, post_processing_offset,
+					      size - post_processing_offset,
+					      size, &build_id__mark_dso_hit_ops);
+}
+
 static void atexit_header(void)
 {
 	session->header.data_size += bytes_written;
 
+	process_buildids();
 	perf_header__write(&session->header, output, true);
 }
 
@@ -558,6 +555,8 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
+	post_processing_offset = lseek(output, 0, SEEK_CUR);
+
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
 					    session, "_text");
 	if (err < 0) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ed3efd7..d5facd5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -205,8 +205,11 @@ static int __dsos__write_buildid_table(struct list_head *head, u16 misc, int fd)
 	dsos__for_each_with_build_id(pos, head) {
 		int err;
 		struct build_id_event b;
-		size_t len = pos->long_name_len + 1;
+		size_t len;
 
+		if (!pos->hit)
+			continue;
+		len = pos->long_name_len + 1;
 		len = ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
@@ -371,7 +374,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 	u64 sec_start;
 	int idx = 0, err;
 
-	if (dsos__read_build_ids())
+	if (dsos__read_build_ids(true))
 		perf_header__set_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index aa8a031..74cbc64 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -385,8 +385,9 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 	return thread;
 }
 
-int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *ops)
+int __perf_session__process_events(struct perf_session *self,
+				   u64 data_offset, u64 data_size,
+				   u64 file_size, struct perf_event_ops *ops)
 {
 	int err, mmap_prot, mmap_flags;
 	u64 head, shift;
@@ -396,32 +397,11 @@ int perf_session__process_events(struct perf_session *self,
 	uint32_t size;
 	char *buf;
 
-	if (perf_session__register_idle_thread(self) == NULL)
-		return -ENOMEM;
-
 	perf_event_ops__fill_defaults(ops);
 
 	page_size = sysconf(_SC_PAGESIZE);
 
-	head = self->header.data_offset;
-
-	if (!symbol_conf.full_paths) {
-		char bf[PATH_MAX];
-
-		if (getcwd(bf, sizeof(bf)) == NULL) {
-			err = -errno;
-out_getcwd_err:
-			pr_err("failed to get the current directory\n");
-			goto out_err;
-		}
-		self->cwd = strdup(bf);
-		if (self->cwd == NULL) {
-			err = -ENOMEM;
-			goto out_getcwd_err;
-		}
-		self->cwdlen = strlen(self->cwd);
-	}
-
+	head = data_offset;
 	shift = page_size * (head / page_size);
 	offset += shift;
 	head -= shift;
@@ -486,10 +466,10 @@ more:
 
 	head += size;
 
-	if (offset + head >= self->header.data_offset + self->header.data_size)
+	if (offset + head >= data_offset + data_size)
 		goto done;
 
-	if (offset + head < self->size)
+	if (offset + head < file_size)
 		goto more;
 done:
 	err = 0;
@@ -497,6 +477,38 @@ out_err:
 	return err;
 }
 
+int perf_session__process_events(struct perf_session *self,
+				 struct perf_event_ops *ops)
+{
+	int err;
+
+	if (perf_session__register_idle_thread(self) == NULL)
+		return -ENOMEM;
+
+	if (!symbol_conf.full_paths) {
+		char bf[PATH_MAX];
+
+		if (getcwd(bf, sizeof(bf)) == NULL) {
+			err = -errno;
+out_getcwd_err:
+			pr_err("failed to get the current directory\n");
+			goto out_err;
+		}
+		self->cwd = strdup(bf);
+		if (self->cwd == NULL) {
+			err = -ENOMEM;
+			goto out_getcwd_err;
+		}
+		self->cwdlen = strlen(self->cwd);
+	}
+
+	err = __perf_session__process_events(self, self->header.data_offset,
+					     self->header.data_size,
+					     self->size, ops);
+out_err:
+	return err;
+}
+
 bool perf_session__has_traces(struct perf_session *self, const char *msg)
 {
 	if (!(self->sample_type & PERF_SAMPLE_RAW)) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 752d75a..31950fc 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -50,6 +50,9 @@ void perf_session__delete(struct perf_session *self);
 
 void perf_event_header__bswap(struct perf_event_header *self);
 
+int __perf_session__process_events(struct perf_session *self,
+				   u64 data_offset, u64 data_size, u64 size,
+				   struct perf_event_ops *ops);
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e752837..bfb0554 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1076,25 +1076,28 @@ static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
 	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
 }
 
-static bool __dsos__read_build_ids(struct list_head *head)
+static bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 {
 	bool have_build_id = false;
 	struct dso *pos;
 
-	list_for_each_entry(pos, head, node)
+	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
 		if (filename__read_build_id(pos->long_name, pos->build_id,
 					    sizeof(pos->build_id)) > 0) {
 			have_build_id	  = true;
 			pos->has_build_id = true;
 		}
+	}
 
 	return have_build_id;
 }
 
-bool dsos__read_build_ids(void)
+bool dsos__read_build_ids(bool with_hits)
 {
-	bool kbuildids = __dsos__read_build_ids(&dsos__kernel),
-	     ubuildids = __dsos__read_build_ids(&dsos__user);
+	bool kbuildids = __dsos__read_build_ids(&dsos__kernel, with_hits),
+	     ubuildids = __dsos__read_build_ids(&dsos__user, with_hits);
 	return kbuildids || ubuildids;
 }
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index e90568a..1b4192e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -157,7 +157,7 @@ struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
-bool dsos__read_build_ids(void);
+bool dsos__read_build_ids(bool with_hits);
 int build_id__sprintf(const u8 *self, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-- 
1.6.2.5

