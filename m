Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZL0Xh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZL0Xh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZL0XhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:37:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 08/10] perf session: Move full_paths config to symbol_conf
Date: Sun, 27 Dec 2009 21:37:04 -0200
Message-Id: <1261957026-15580-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now perf_event_ops has just that, event handlers.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |    2 +-
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/session.c   |    2 +-
 tools/perf/util/session.h   |    1 -
 tools/perf/util/symbol.h    |    3 ++-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index bd71b8c..e164b3d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -204,7 +204,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
+	OPT_BOOLEAN('P', "full-paths", &symbol_conf.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0825918..f695084 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -321,7 +321,7 @@ static const struct option options[] = {
 		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
-	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
+	OPT_BOOLEAN('P', "full-paths", &symbol_conf.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4ca427f..4f2eeb5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -306,7 +306,7 @@ int perf_session__process_events(struct perf_session *self,
 
 	head = self->header.data_offset;
 
-	if (!ops->full_paths) {
+	if (!symbol_conf.full_paths) {
 		char bf[PATH_MAX];
 
 		if (getcwd(bf, sizeof(bf)) == NULL) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 585937b..2ff77fe 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -41,7 +41,6 @@ struct perf_event_ops {
 	event_op	process_read_event;
 	event_op	process_throttle_event;
 	event_op	process_unthrottle_event;
-	bool		full_paths;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 8aded23..9eabd60 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -58,7 +58,8 @@ struct symbol_conf {
 			sort_by_name,
 			show_nr_samples,
 			use_callchain,
-			exclude_other;
+			exclude_other,
+			full_paths;
 	const char	*vmlinux_name,
 			*field_sep;
 	char            *dso_list_str,
-- 
1.6.2.5

