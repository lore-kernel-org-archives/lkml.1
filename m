Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZFHVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZFHVeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbZFHVeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:34:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:40242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbZFHVeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:34:13 -0400
Date: Mon, 8 Jun 2009 21:33:42 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0906082111590.12407@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906082111590.12407@melkki.cs.Helsinki.FI>
Subject: [tip:perfcounters/core] perf report: Add support for profiling JIT generated code
Message-ID: <tip-80d496be89ed7dede5abee5c057634e80a31c82d@git.kernel.org>
Git-Commit-ID: 80d496be89ed7dede5abee5c057634e80a31c82d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 21:33:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80d496be89ed7dede5abee5c057634e80a31c82d
Gitweb:     http://git.kernel.org/tip/80d496be89ed7dede5abee5c057634e80a31c82d
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Mon, 8 Jun 2009 21:12:48 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 23:10:44 +0200

perf report: Add support for profiling JIT generated code

This patch adds support for profiling JIT generated code to 'perf
report'. A JIT compiler is required to generate a "/tmp/perf-$PID.map"
symbols map that is parsed when looking and displaying symbols.

Thanks to Peter Zijlstra for his help with this patch!

Example "perf report" output with the Jato JIT:

 #
 # (40311 samples)
 #
 # Overhead           Command  Shared Object              Symbol
 # ........  ................  .........................  ......
 #
     97.80%              jato  /tmp/perf-11915.map        [.] Fibonacci.fib(I)I
      0.56%              jato  00000000b7fa023b           0x000000b7fa023b
      0.45%              jato  /tmp/perf-11915.map        [.] Fibonacci.main([Ljava/lang/String;)V
      0.38%              jato  [kernel]                   [k] get_page_from_freelist
      0.06%              jato  [kernel]                   [k] kunmap_atomic
      0.05%              jato  ./jato                     [.] utf8Hash
      0.04%              jato  ./jato                     [.] executeJava
      0.04%              jato  ./jato                     [.] defineClass

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: a.p.zijlstra@chello.nl
Cc: acme@redhat.com
LKML-Reference: <Pine.LNX.4.64.0906082111590.12407@melkki.cs.Helsinki.FI>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   15 +++++++++-
 tools/perf/util/symbol.c    |   65 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f053a74..61d8718 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -209,6 +209,11 @@ static uint64_t vdso__map_ip(struct map *map, uint64_t ip)
 	return ip;
 }
 
+static inline int is_anon_memory(const char *filename)
+{
+     return strcmp(filename, "//anon") == 0;
+}
+
 static struct map *map__new(struct mmap_event *event)
 {
 	struct map *self = malloc(sizeof(*self));
@@ -216,6 +221,7 @@ static struct map *map__new(struct mmap_event *event)
 	if (self != NULL) {
 		const char *filename = event->filename;
 		char newfilename[PATH_MAX];
+		int anon;
 
 		if (cwd) {
 			int n = strcommon(filename);
@@ -227,6 +233,13 @@ static struct map *map__new(struct mmap_event *event)
 			}
 		}
 
+		anon = is_anon_memory(filename);
+
+		if (anon) {
+			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
+			filename = newfilename;
+		}
+
 		self->start = event->start;
 		self->end   = event->start + event->len;
 		self->pgoff = event->pgoff;
@@ -235,7 +248,7 @@ static struct map *map__new(struct mmap_event *event)
 		if (self->dso == NULL)
 			goto out_delete;
 
-		if (self->dso == vdso)
+		if (self->dso == vdso || anon)
 			self->map_ip = vdso__map_ip;
 		else
 			self->map_ip = map__map_ip;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 158588c..32dd47d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -220,6 +220,68 @@ out_failure:
 	return -1;
 }
 
+static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verbose)
+{
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	int nr_syms = 0;
+
+	file = fopen(self->name, "r");
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		__u64 start, size;
+		struct symbol *sym;
+		int line_len, len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		len = hex2u64(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		len += hex2u64(line + len, &size);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		sym = symbol__new(start, size, line + len,
+				  self->sym_priv_size, start, verbose);
+
+		if (sym == NULL)
+			goto out_delete_line;
+
+		if (filter && filter(self, sym))
+			symbol__delete(sym, self->sym_priv_size);
+		else {
+			dso__insert_symbol(self, sym);
+			nr_syms++;
+		}
+	}
+
+	free(line);
+	fclose(file);
+
+	return nr_syms;
+
+out_delete_line:
+	free(line);
+out_failure:
+	return -1;
+}
+
 /**
  * elf_symtab__for_each_symbol - iterate thru all the symbols
  *
@@ -507,6 +569,9 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	if (!name)
 		return -1;
 
+	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
+		return dso__load_perf_map(self, filter, verbose);
+
 more:
 	do {
 		switch (variant) {
