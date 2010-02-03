Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0BCSwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:53450 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab0BCSwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 7/9] perf tools: Adjust some verbosity levels
Date: Wed,  3 Feb 2010 16:52:06 -0200
Message-Id: <1265223128-11786-7-git-send-email-acme@infradead.org>
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

Not to pollute too much 'perf annotate' debugging sessions.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |   33 +++++++++++--------------------
 tools/perf/util/include/linux/kernel.h |    1 +
 tools/perf/util/symbol.c               |    9 ++++---
 3 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 73c202e..4fc3899 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -97,9 +97,7 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	sym_size = sym->end - sym->start;
 	offset = ip - sym->start;
 
-	if (verbose)
-		fprintf(stderr, "%s: ip=%Lx\n", __func__,
-			he->map->unmap_ip(he->map, ip));
+	pr_debug3("%s: ip=%#Lx\n", __func__, he->map->unmap_ip(he->map, ip));
 
 	if (offset >= sym_size)
 		return;
@@ -108,12 +106,8 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	h->sum++;
 	h->ip[offset]++;
 
-	if (verbose >= 3)
-		printf("%p %s: count++ [ip: %p, %08Lx] => %Ld\n",
-			(void *)(unsigned long)he->sym->start,
-			he->sym->name,
-			(void *)(unsigned long)ip, ip - he->sym->start,
-			h->ip[offset]);
+	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", he->sym->start,
+		  he->sym->name, ip, ip - he->sym->start, h->ip[offset]);
 }
 
 static int perf_session__add_hist_entry(struct perf_session *self,
@@ -136,14 +130,14 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		    event->ip.pid, event->ip.ip);
 
 	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_warning("problem processing %d event, skipping it.\n",
+			   event->header.type);
 		return -1;
 	}
 
 	if (!al.filtered && perf_session__add_hist_entry(session, &al, 1)) {
-		fprintf(stderr, "problem incrementing symbol count, "
-				"skipping event\n");
+		pr_warning("problem incrementing symbol count, "
+			   "skipping event\n");
 		return -1;
 	}
 
@@ -378,11 +372,9 @@ static void annotate_sym(struct hist_entry *he)
 	if (!filename)
 		return;
 
-	if (verbose)
-		fprintf(stderr, "%s: filename=%s, sym=%s, start=%Lx, end=%Lx\n",
-			__func__, filename, sym->name,
-			map->unmap_ip(map, sym->start),
-			map->unmap_ip(map, sym->end));
+	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
+		 filename, sym->name, map->unmap_ip(map, sym->start),
+		 map->unmap_ip(map, sym->end));
 
 	if (full_paths)
 		d_filename = filename;
@@ -542,9 +534,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 	setup_pager();
 
 	if (field_sep && *field_sep == '.') {
-		fputs("'.' is the only non valid --field-separator argument\n",
-				stderr);
-		exit(129);
+		pr_err("'.' is the only non valid --field-separator argument\n");
+		return -1;
 	}
 
 	return __cmd_annotate();
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 21c0274..f261165 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -101,5 +101,6 @@ simple_strtoul(const char *nptr, char **endptr, int base)
 	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
 
 #endif
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index bfb0554..a60ba2b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -137,7 +137,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
 
-	pr_debug3("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
+	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
 
 	memcpy(self->name, name, namelen);
 
@@ -1024,9 +1024,10 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		}
 
 		if (curr_dso->adjust_symbols) {
-			pr_debug2("adjusting symbol: st_value: %Lx sh_addr: "
-				  "%Lx sh_offset: %Lx\n", (u64)sym.st_value,
-				  (u64)shdr.sh_addr, (u64)shdr.sh_offset);
+			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
+				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
+				  (u64)sym.st_value, (u64)shdr.sh_addr,
+				  (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
 		/*
-- 
1.6.2.5

