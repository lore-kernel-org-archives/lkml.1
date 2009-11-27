Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZK0S33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZK0S33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZK0S33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbZK0S31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 04/12] perf symbols: Unexport kernel_map__functions
Date: Fri, 27 Nov 2009 16:29:15 -0200
Message-Id: <1259346563-12568-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-3-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

perf annotate was the only user, and it doesn't really needs it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    8 +++-----
 tools/perf/util/symbol.c      |    3 +--
 tools/perf/util/symbol.h      |    1 -
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 377cb7c..0846c8a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -169,7 +169,6 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		level = '.';
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
-got_map:
 			ip = map->map_ip(map, ip);
 			sym = map__find_function(map, ip, symbol_filter);
 		} else {
@@ -183,10 +182,9 @@ got_map:
 			 * the "[vdso]" dso, but for now lets use the old
 			 * trick of looking in the whole kernel symbol list.
 			 */
-			if ((long long)ip < 0) {
-				map = kernel_map__functions;
-				goto got_map;
-			}
+			if ((long long)ip < 0)
+				sym = kernel_maps__find_function(ip, &map,
+								 symbol_filter);
 		}
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index dc25231..0b8a298 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -36,6 +36,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
+static struct map *kernel_map__functions;
 
 static struct symbol_conf symbol_conf__defaults = {
 	.use_modules	  = true,
@@ -1164,8 +1165,6 @@ out:
 	return ret;
 }
 
-struct map *kernel_map__functions;
-
 static void kernel_maps__insert(struct map *map)
 {
 	maps__insert(&kernel_maps__functions, map);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5d0371f..fb0be9e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -105,6 +105,5 @@ size_t kernel_maps__fprintf(FILE *fp);
 int symbol__init(struct symbol_conf *conf);
 
 extern struct list_head dsos__user, dsos__kernel;
-extern struct map *kernel_map__functions;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

