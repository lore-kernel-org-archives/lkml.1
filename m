Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0AOBpm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897Ab0AOBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:45:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:49913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0AOBpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:45:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf buildid-list: Introduce --with-hits option
Date: Thu, 14 Jan 2010 23:45:30 -0200
Message-Id: <1263519930-22803-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263519930-22803-1-git-send-email-acme@infradead.org>
References: <1263519930-22803-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using this option 'perf buildid-list' will process all samples, marking
the DSOs that had some hits to list just them.

This in turn will be used by a new porcelain, 'perf archive', that will
be just a shell script to create a tarball from the 'perf buildid-list
--with-hits' output and the files cached by 'perf record' in ~/.debug.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |   35 ++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.c          |   11 +++++++----
 tools/perf/util/symbol.h          |    3 ++-
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 4229c2c..431f204 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,6 +16,7 @@
 
 static char const *input_name = "perf.data";
 static int force;
+static bool with_hits;
 
 static const char * const buildid_list_usage[] = {
 	"perf buildid-list [<options>]",
@@ -23,6 +24,7 @@ static const char * const buildid_list_usage[] = {
 };
 
 static const struct option options[] = {
+	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -31,6 +33,34 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static int build_id_list__process_event(event_t *event,
+					struct perf_session *session)
+{
+	struct addr_location al;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+
+	if (thread == NULL) {
+		pr_err("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      event->ip.ip, &al);
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	return 0;
+}
+
+static struct perf_event_ops build_id_list__event_ops = {
+	.sample	= build_id_list__process_event,
+	.mmap	= event__process_mmap,
+	.fork	= event__process_task,
+};
+
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
@@ -40,7 +70,10 @@ static int __cmd_buildid_list(void)
 	if (session == NULL)
 		return -1;
 
-	dsos__fprintf_buildid(stdout);
+	if (with_hits)
+		perf_session__process_events(session, &build_id_list__event_ops);
+
+	dsos__fprintf_buildid(stdout, with_hits);
 
 	perf_session__delete(session);
 	return err;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4267138..a4e7459 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1716,22 +1716,25 @@ void dsos__fprintf(FILE *fp)
 	__dsos__fprintf(&dsos__user, fp);
 }
 
-static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp)
+static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+				      bool with_hits)
 {
 	struct dso *pos;
 	size_t ret = 0;
 
 	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
 		ret += dso__fprintf_buildid(pos, fp);
 		ret += fprintf(fp, " %s\n", pos->long_name);
 	}
 	return ret;
 }
 
-size_t dsos__fprintf_buildid(FILE *fp)
+size_t dsos__fprintf_buildid(FILE *fp, bool with_hits)
 {
-	return (__dsos__fprintf_buildid(&dsos__kernel, fp) +
-		__dsos__fprintf_buildid(&dsos__user, fp));
+	return (__dsos__fprintf_buildid(&dsos__kernel, fp, with_hits) +
+		__dsos__fprintf_buildid(&dsos__user, fp, with_hits));
 }
 
 static struct dso *dsos__create_kernel(const char *vmlinux)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 36b7c71..525085f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,6 +97,7 @@ struct dso {
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
 	u8		 kernel:1;
+	u8		 hit:1;
 	unsigned char	 origin;
 	u8		 sorted_by_name;
 	u8		 loaded;
@@ -129,7 +130,7 @@ struct perf_session;
 int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 	      symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
-size_t dsos__fprintf_buildid(FILE *fp);
+size_t dsos__fprintf_buildid(FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
-- 
1.6.2.5

