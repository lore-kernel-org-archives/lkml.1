Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731Ab0ADSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab0ADSTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642Ab0ADSTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:19:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0ADSTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:19:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf session: Keep pointers to the vmlinux maps
Date: Mon,  4 Jan 2010 16:19:29 -0200
Message-Id: <1262629169-22797-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262629169-22797-1-git-send-email-acme@infradead.org>
References: <1262629169-22797-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that tools such as 'perf probe' don't have to lookup '[kernel.kallsyms]' but
instead access them directly after perf_session__create_kernel_maps or
map_groups__create_kernel_maps.

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |    4 +---
 tools/perf/util/session.h  |    1 +
 tools/perf/util/symbol.c   |   29 +++++++++++++----------------
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c1e6774..ffdd3fe 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -235,9 +235,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	session.psession = perf_session__new(NULL, O_WRONLY, false);
 	if (session.psession == NULL)
 		die("Failed to init perf_session.");
-	session.kmap = map_groups__find_by_name(&session.psession->kmaps,
-						MAP__FUNCTION,
-						"[kernel.kallsyms]");
+	session.kmap = session.psession->vmlinux_maps[MAP__FUNCTION];
 	if (!session.kmap)
 		die("Could not find kernel map.\n");
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 77c5ee2..8db37bb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -18,6 +18,7 @@ struct perf_session {
 	struct map_groups	kmaps;
 	struct rb_root		threads;
 	struct thread		*last_match;
+	struct map		*vmlinux_maps[MAP__NR_TYPES];
 	struct events_stats	events_stats;
 	unsigned long		event_total[PERF_RECORD_MAX];
 	unsigned long		unknown_events;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5dffcd1..e290429 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1662,7 +1662,7 @@ size_t dsos__fprintf_buildid(FILE *fp)
 		__dsos__fprintf_buildid(&dsos__user, fp));
 }
 
-static struct dso *dsos__create_kernel( const char *vmlinux)
+static struct dso *dsos__create_kernel(const char *vmlinux)
 {
 	struct dso *kernel = dso__new(vmlinux ?: "[kernel.kallsyms]");
 
@@ -1691,29 +1691,26 @@ out_delete_kernel_dso:
 	return NULL;
 }
 
-static int map_groups__create_kernel_maps(struct map_groups *self, const char *vmlinux)
+static int map_groups__create_kernel_maps(struct map_groups *self,
+					  struct map *vmlinux_maps[MAP__NR_TYPES],
+					  const char *vmlinux)
 {
-	struct map *functions, *variables;
 	struct dso *kernel = dsos__create_kernel(vmlinux);
+	enum map_type type;
 
 	if (kernel == NULL)
 		return -1;
 
-	functions = map__new2(0, kernel, MAP__FUNCTION);
-	if (functions == NULL)
-		return -1;
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		vmlinux_maps[type] = map__new2(0, kernel, type);
+		if (vmlinux_maps[type] == NULL)
+			return -1;
 
-	variables = map__new2(0, kernel, MAP__VARIABLE);
-	if (variables == NULL) {
-		map__delete(functions);
-		return -1;
+		vmlinux_maps[type]->map_ip =
+			vmlinux_maps[type]->unmap_ip = identity__map_ip;
+		map_groups__insert(self, vmlinux_maps[type]);
 	}
 
-	functions->map_ip = functions->unmap_ip =
-		variables->map_ip = variables->unmap_ip = identity__map_ip;
-	map_groups__insert(self, functions);
-	map_groups__insert(self, variables);
-
 	return 0;
 }
 
@@ -1824,7 +1821,7 @@ out_free_comm_list:
 
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	if (map_groups__create_kernel_maps(&self->kmaps,
+	if (map_groups__create_kernel_maps(&self->kmaps, self->vmlinux_maps,
 					   symbol_conf.vmlinux_name) < 0)
 		return -1;
 
-- 
1.6.2.5

