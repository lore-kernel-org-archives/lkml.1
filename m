Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0BDJ4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:56:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:52251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab0BDJ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:56:03 -0500
Date: Thu, 4 Feb 2010 09:54:36 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1265223128-11786-9-git-send-email-acme@infradead.org>
References: <1265223128-11786-9-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Teach it to autolocate vmlinux
Message-ID: <tip-6cff0e8dbaa4d5d822a814e5028683d7e71c3291@git.kernel.org>
Git-Commit-ID: 6cff0e8dbaa4d5d822a814e5028683d7e71c3291
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cff0e8dbaa4d5d822a814e5028683d7e71c3291
Gitweb:     http://git.kernel.org/tip/6cff0e8dbaa4d5d822a814e5028683d7e71c3291
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Wed, 3 Feb 2010 16:52:08 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:33:28 +0100

perf top: Teach it to autolocate vmlinux

By relying on logic in dso__load_kernel_sym(), we can
automatically load vmlinux.

The only thing which needs to be adjusted, is how --sym-annotate
option is handled - now we can't rely on vmlinux been loaded
until full successful pass of dso__load_vmlinux(), but that's
not the case if we'll do sym_filter_entry setup in
symbol_filter().

So move this step right after event__process_sample() where we
know the whole dso__load_kernel_sym() pass is done.

By the way, though conceptually similar `perf top` still can't
annotate userspace - see next patches with fixes.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1265223128-11786-9-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-top.txt |    2 +-
 tools/perf/builtin-top.c              |   39 +++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 4a7d558..785b9fc 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -74,7 +74,7 @@ OPTIONS
 
 -s <symbol>::
 --sym-annotate=<symbol>::
-        Annotate this symbol.  Requires -k option.
+        Annotate this symbol.
 
 -v::
 --verbose::
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1fc018e..83c09c8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -94,6 +94,7 @@ struct source_line {
 
 static char			*sym_filter			=   NULL;
 struct sym_entry		*sym_filter_entry		=   NULL;
+struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 static int			sym_counter			=      0;
 static int			display_weighted		=     -1;
@@ -695,11 +696,9 @@ static void print_mapped_keys(void)
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 
-	if (symbol_conf.vmlinux_name) {
-		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
-		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
-		fprintf(stdout, "\t[S]     stop annotation.\n");
-	}
+	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
+	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
+	fprintf(stdout, "\t[S]     stop annotation.\n");
 
 	if (nr_counters > 1)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
@@ -725,14 +724,13 @@ static int key_mapped(int c)
 		case 'Q':
 		case 'K':
 		case 'U':
+		case 'F':
+		case 's':
+		case 'S':
 			return 1;
 		case 'E':
 		case 'w':
 			return nr_counters > 1 ? 1 : 0;
-		case 'F':
-		case 's':
-		case 'S':
-			return symbol_conf.vmlinux_name ? 1 : 0;
 		default:
 			break;
 	}
@@ -910,8 +908,12 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	syme = symbol__priv(sym);
 	syme->map = map;
 	syme->src = NULL;
-	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
-		sym_filter_entry = syme;
+
+	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter)) {
+		/* schedule initial sym_filter_entry setup */
+		sym_filter_entry_sched = syme;
+		sym_filter = NULL;
+	}
 
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
@@ -976,6 +978,13 @@ static void event__process_sample(const event_t *self,
 		return;
 	}
 
+	/* let's see, whether we need to install initial sym_filter_entry */
+	if (sym_filter_entry_sched) {
+		sym_filter_entry = sym_filter_entry_sched;
+		sym_filter_entry_sched = NULL;
+		parse_source(sym_filter_entry);
+	}
+
 	syme = symbol__priv(al.sym);
 	if (!syme->skip) {
 		syme->count[counter]++;
@@ -1270,7 +1279,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
 	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
-		    "symbol to annotate - requires -k option"),
+		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
@@ -1306,16 +1315,14 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
 				 (nr_counters + 1) * sizeof(unsigned long));
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
+
+	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
 		return -1;
 
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-	parse_source(sym_filter_entry);
-
 	/*
 	 * User specified count overrides default frequency.
 	 */
