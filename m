Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZFMPZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZFMPZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZFMPZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:25:35 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:54135 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZFMPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CBvh0EAR8G2YLUaxKsprRAvdZBwExeCX99JiCUQduKEVY1P8Lu7hEuVhr2TtPqUg4O
         NWz3mBDtpEjse5LRwyV3WGGEhHFCk9CpczVoNyPi/xmEiVfnProAmbU0S9SuFr2p+w8v
         5Yyv5wuB4zN/O92HwkheErwy6GpuTeT/1B+LQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] perfcounters: Print the filename:line for annotated colored lines
Date: Sat, 13 Jun 2009 17:25:31 +0200
Message-Id: <1244906732-7521-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have a colored line in perf annotate, ie a middle/high
overhead one, it's sometimes useful to get the matching line
and filename from the source file, especially this path prepares
to another subsequent one which will print a sorted summary of
midle/high overhead lines in the beginning of the output.

Filename:Lines have the same color than the concerned ip lines.

It can be slow because it relies on addr2line. We could also
use objdump with -l but that implies we would have to bufferize
objdump output and parse it to filter the relevant lines since
we want to print a sorted summary in the beginning.

Changes in v2:
- fix addr2line on userspace binary
- fix string allocation size (missing ending null char room)
- fix overflow in symbol extra info

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-annotate.c |   99 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h      |    1 +
 2 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b1ed5f7..15192a3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -39,6 +39,8 @@ static int		dump_trace = 0;
 
 static int		verbose;
 
+static int		print_line;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
@@ -84,6 +86,12 @@ typedef union event_union {
 	struct period_event		period;
 } event_t;
 
+
+struct sym_ext {
+	double		percent;
+	char		*path;
+};
+
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
@@ -1034,6 +1042,8 @@ static int
 parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 {
 	char *line = NULL, *tmp, *tmp2;
+	static const char *prev_line;
+	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
 	__u64 line_ip;
@@ -1073,15 +1083,20 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 	}
 
 	if (line_ip != -1) {
+		const char *path = NULL;
 		unsigned int hits = 0;
 		double percent = 0.0;
 		char *color = PERF_COLOR_NORMAL;
+		struct sym_ext *sym_ext = sym->priv;
 
 		offset = line_ip - start;
 		if (offset < len)
 			hits = sym->hist[offset];
 
-		if (sym->hist_sum)
+		if (offset < len && sym_ext) {
+			path = sym_ext[offset].path;
+			percent = sym_ext[offset].percent;
+		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
 		/*
@@ -1096,6 +1111,20 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 				color = PERF_COLOR_GREEN;
 		}
 
+		/*
+		 * Also color the filename and line if needed, with
+		 * the same color than the percentage. Don't print it
+		 * twice for close colored ip with the same filename:line
+		 */
+		if (path) {
+			if (!prev_line || strcmp(prev_line, path)
+				       || color != prev_color) {
+				color_fprintf(stdout, color, " %s", path);
+				prev_line = path;
+				prev_color = color;
+			}
+		}
+
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", line);
@@ -1109,6 +1138,68 @@ parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
 	return 0;
 }
 
+static void free_source_line(struct symbol *sym, int len)
+{
+	struct sym_ext *sym_ext = sym->priv;
+	int i;
+
+	if (!sym_ext)
+		return;
+
+	for (i = 0; i < len; i++)
+		free(sym_ext[i].path);
+	free(sym_ext);
+
+	sym->priv = NULL;
+}
+
+/* Get the filename:line for the colored entries */
+static void
+get_source_line(struct symbol *sym, __u64 start, int len, char *filename)
+{
+	int i;
+	char cmd[PATH_MAX * 2];
+	struct sym_ext *sym_ext;
+
+	if (!sym->hist_sum)
+		return;
+
+	sym->priv = calloc(len, sizeof(struct sym_ext));
+	if (!sym->priv)
+		return;
+
+	sym_ext = sym->priv;
+
+	for (i = 0; i < len; i++) {
+		char *path = NULL;
+		size_t line_len;
+		__u64 offset;
+		FILE *fp;
+
+		sym_ext[i].percent = 100.0 * sym->hist[i] / sym->hist_sum;
+		if (sym_ext[i].percent <= 0.5)
+			continue;
+
+		offset = start + i;
+		sprintf(cmd, "addr2line -e %s %016llx", filename, offset);
+		fp = popen(cmd, "r");
+		if (!fp)
+			continue;
+
+		if (getline(&path, &line_len, fp) < 0 || !line_len)
+			goto next;
+
+		sym_ext[i].path = malloc(sizeof(char) * line_len + 1);
+		if (!sym_ext[i].path)
+			goto next;
+
+		strcpy(sym_ext[i].path, path);
+
+	next:
+		pclose(fp);
+	}
+}
+
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
 	char *filename = dso->name;
@@ -1135,6 +1226,9 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	end = start + sym->end - sym->start + 1;
 	len = sym->end - sym->start;
 
+	if (print_line)
+		get_source_line(sym, start, len, filename);
+
 	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (__u64)start, (__u64)end, filename);
 
 	if (verbose >= 3)
@@ -1150,6 +1244,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	}
 
 	pclose(file);
+	free_source_line(sym, len);
 }
 
 static void find_annotations(void)
@@ -1308,6 +1403,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('l', "print-line", &print_line,
+		    "print matching source lines (may be slow)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0d1292b..5ad9b06 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,6 +12,7 @@ struct symbol {
 	__u64		obj_start;
 	__u64		hist_sum;
 	__u64		*hist;
+	void		*priv;
 	char		name[0];
 };
 
-- 
1.6.2.3

