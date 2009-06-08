Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZFHSNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZFHSNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZFHSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:12:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53468 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbZFHSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:12:46 -0400
Date: Mon, 8 Jun 2009 21:12:48 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@redhat.com
Subject: [PATCH 2/2] perf report: support for profiling JIT generated code
Message-ID: <Pine.LNX.4.64.0906082111590.12407@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch adds support for profiling JIT generate code to 'perf
report'. A JIT compile is required to generate a "/tmp/perf-$PID.map"
symbols map that is parsed when looking and displaying symbols.

Thanks to Peter Zijlstra for his help with this patch!

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
-- 
1.5.6.3

