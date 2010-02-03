Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0BCSwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:53437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0BCSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/9] perf probe: Don't use a perf_session instance just to resolve symbols
Date: Wed,  3 Feb 2010 16:52:03 -0200
Message-Id: <1265223128-11786-4-git-send-email-acme@infradead.org>
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

With the recent modifications done to untie the session and symbol layers,
'perf probe' now can use just the symbols layer.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 4fa73ec..ad47bd4 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -41,7 +41,6 @@
 #include "util/debugfs.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/session.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
@@ -59,8 +58,8 @@ static struct {
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
-	struct perf_session *psession;
-	struct map *kmap;
+	struct map_groups kmap_groups;
+	struct map *kmaps[MAP__NR_TYPES];
 	struct line_range line_range;
 } session;
 
@@ -122,7 +121,8 @@ static int opt_del_probe_event(const struct option *opt __used,
 static void evaluate_probe_point(struct probe_point *pp)
 {
 	struct symbol *sym;
-	sym = map__find_symbol_by_name(session.kmap, pp->function, NULL);
+	sym = map__find_symbol_by_name(session.kmaps[MAP__FUNCTION],
+				       pp->function, NULL);
 	if (!sym)
 		die("Kernel symbol \'%s\' not found - probe not added.",
 		    pp->function);
@@ -131,12 +131,13 @@ static void evaluate_probe_point(struct probe_point *pp)
 #ifndef NO_LIBDWARF
 static int open_vmlinux(void)
 {
-	if (map__load(session.kmap, NULL) < 0) {
+	if (map__load(session.kmaps[MAP__FUNCTION], NULL) < 0) {
 		pr_debug("Failed to load kernel map.\n");
 		return -EINVAL;
 	}
-	pr_debug("Try to open %s\n", session.kmap->dso->long_name);
-	return open(session.kmap->dso->long_name, O_RDONLY);
+	pr_debug("Try to open %s\n",
+		 session.kmaps[MAP__FUNCTION]->dso->long_name);
+	return open(session.kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
 
 static int opt_show_lines(const struct option *opt __used,
@@ -212,12 +213,11 @@ static void init_vmlinux(void)
 		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
 	if (symbol__init() < 0)
 		die("Failed to init symbol map.");
-	session.psession = perf_session__new(NULL, O_WRONLY, false);
-	if (session.psession == NULL)
-		die("Failed to init perf_session.");
-	session.kmap = session.psession->vmlinux_maps[MAP__FUNCTION];
-	if (!session.kmap)
-		die("Could not find kernel map.\n");
+
+	map_groups__init(&session.kmap_groups);
+	if (map_groups__create_kernel_maps(&session.kmap_groups,
+					   session.kmaps) < 0)
+		die("Failed to create kernel maps.");
 }
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
-- 
1.6.2.5

