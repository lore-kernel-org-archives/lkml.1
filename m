Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZFDOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZFDOfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZFDOe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:34:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:36697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZFDOe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:34:58 -0400
Date: Thu, 4 Jun 2009 14:33:30 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add color terminal output support
Message-ID: <tip-8fc0321f1ad0ffef969056dda91b453bbd7a494d@git.kernel.org>
Git-Commit-ID: 8fc0321f1ad0ffef969056dda91b453bbd7a494d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 14:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fc0321f1ad0ffef969056dda91b453bbd7a494d
Gitweb:     http://git.kernel.org/tip/8fc0321f1ad0ffef969056dda91b453bbd7a494d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 15:19:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 15:28:11 +0200

perf_counter tools: Add color terminal output support

Add Git's color printing library to util/color.[ch].

Add it to perf report, with a trivial example to print high-overhead
entries in red, low-overhead entries in green.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile           |    2 +
 Documentation/perf_counter/builtin-report.c   |   15 ++-
 Documentation/perf_counter/builtin-top.c      |   23 ++-
 Documentation/perf_counter/util/color.c       |  230 +++++++++++++++++++++++++
 Documentation/perf_counter/util/color.h       |   36 ++++
 Documentation/perf_counter/util/environment.c |    1 +
 6 files changed, 300 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 414399c..c9ec458 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -298,6 +298,7 @@ LIB_H += util/string.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
+LIB_H += util/color.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -319,6 +320,7 @@ LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
 LIB_OBJS += util/symbol.o
+LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 
 BUILTIN_OBJS += builtin-help.o
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index e930b4e..7beedc6 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -9,6 +9,7 @@
 
 #include "util/util.h"
 
+#include "util/color.h"
 #include "util/list.h"
 #include "util/cache.h"
 #include "util/rbtree.h"
@@ -548,7 +549,19 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 	size_t ret;
 
 	if (total_samples) {
-		ret = fprintf(fp, "   %6.2f%%",
+		double percent = self->count * 100.0 / total_samples;
+		char *color = PERF_COLOR_NORMAL;
+
+		/*
+		 * We color high-overhead entries in red, low-overhead
+		 * entries in green - and keep the middle ground normal:
+		 */
+		if (percent >= 5.0)
+			color = PERF_COLOR_RED;
+		if (percent < 0.5)
+			color = PERF_COLOR_GREEN;
+
+		ret = color_fprintf(fp, color, "   %6.2f%%",
 				(self->count * 100.0) / total_samples);
 	} else
 		ret = fprintf(fp, "%12d ", self->count);
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 548a8da..20e5b12 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -21,6 +21,7 @@
 #include "perf.h"
 
 #include "util/symbol.h"
+#include "util/color.h"
 #include "util/util.h"
 #include "util/rbtree.h"
 #include "util/parse-options.h"
@@ -253,7 +254,8 @@ static void print_sym_table(void)
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
 		struct symbol *sym = (struct symbol *)(syme + 1);
-		float pcnt;
+		char *color = PERF_COLOR_NORMAL;
+		double pcnt;
 
 		if (++printed > print_entries || syme->snap_count < count_filter)
 			continue;
@@ -261,13 +263,22 @@ static void print_sym_table(void)
 		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->snap_count) /
 					 sum_kevents));
 
+		/*
+		 * We color high-overhead entries in red, low-overhead
+		 * entries in green - and keep the middle ground normal:
+		 */
+		if (pcnt >= 5.0)
+			color = PERF_COLOR_RED;
+		if (pcnt < 0.5)
+			color = PERF_COLOR_GREEN;
+
 		if (nr_counters == 1)
-			printf("%19.2f - %4.1f%% - %016llx : %s\n",
-				syme->weight, pcnt, sym->start, sym->name);
+			printf("%19.2f - ", syme->weight);
 		else
-			printf("%8.1f %10ld - %4.1f%% - %016llx : %s\n",
-				syme->weight, syme->snap_count,
-				pcnt, sym->start, sym->name);
+			printf("%8.1f %10ld - ", syme->weight, syme->snap_count);
+
+		color_fprintf(stdout, color, "%4.1f%%", pcnt);
+		printf(" - %016llx : %s\n", sym->start, sym->name);
 	}
 
 	{
diff --git a/Documentation/perf_counter/util/color.c b/Documentation/perf_counter/util/color.c
new file mode 100644
index 0000000..a77975d
--- /dev/null
+++ b/Documentation/perf_counter/util/color.c
@@ -0,0 +1,230 @@
+#include "cache.h"
+#include "color.h"
+
+int perf_use_color_default = 0;
+
+static int parse_color(const char *name, int len)
+{
+	static const char * const color_names[] = {
+		"normal", "black", "red", "green", "yellow",
+		"blue", "magenta", "cyan", "white"
+	};
+	char *end;
+	int i;
+	for (i = 0; i < ARRAY_SIZE(color_names); i++) {
+		const char *str = color_names[i];
+		if (!strncasecmp(name, str, len) && !str[len])
+			return i - 1;
+	}
+	i = strtol(name, &end, 10);
+	if (end - name == len && i >= -1 && i <= 255)
+		return i;
+	return -2;
+}
+
+static int parse_attr(const char *name, int len)
+{
+	static const int attr_values[] = { 1, 2, 4, 5, 7 };
+	static const char * const attr_names[] = {
+		"bold", "dim", "ul", "blink", "reverse"
+	};
+	int i;
+	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
+		const char *str = attr_names[i];
+		if (!strncasecmp(name, str, len) && !str[len])
+			return attr_values[i];
+	}
+	return -1;
+}
+
+void color_parse(const char *value, const char *var, char *dst)
+{
+	color_parse_mem(value, strlen(value), var, dst);
+}
+
+void color_parse_mem(const char *value, int value_len, const char *var,
+		char *dst)
+{
+	const char *ptr = value;
+	int len = value_len;
+	int attr = -1;
+	int fg = -2;
+	int bg = -2;
+
+	if (!strncasecmp(value, "reset", len)) {
+		strcpy(dst, PERF_COLOR_RESET);
+		return;
+	}
+
+	/* [fg [bg]] [attr] */
+	while (len > 0) {
+		const char *word = ptr;
+		int val, wordlen = 0;
+
+		while (len > 0 && !isspace(word[wordlen])) {
+			wordlen++;
+			len--;
+		}
+
+		ptr = word + wordlen;
+		while (len > 0 && isspace(*ptr)) {
+			ptr++;
+			len--;
+		}
+
+		val = parse_color(word, wordlen);
+		if (val >= -1) {
+			if (fg == -2) {
+				fg = val;
+				continue;
+			}
+			if (bg == -2) {
+				bg = val;
+				continue;
+			}
+			goto bad;
+		}
+		val = parse_attr(word, wordlen);
+		if (val < 0 || attr != -1)
+			goto bad;
+		attr = val;
+	}
+
+	if (attr >= 0 || fg >= 0 || bg >= 0) {
+		int sep = 0;
+
+		*dst++ = '\033';
+		*dst++ = '[';
+		if (attr >= 0) {
+			*dst++ = '0' + attr;
+			sep++;
+		}
+		if (fg >= 0) {
+			if (sep++)
+				*dst++ = ';';
+			if (fg < 8) {
+				*dst++ = '3';
+				*dst++ = '0' + fg;
+			} else {
+				dst += sprintf(dst, "38;5;%d", fg);
+			}
+		}
+		if (bg >= 0) {
+			if (sep++)
+				*dst++ = ';';
+			if (bg < 8) {
+				*dst++ = '4';
+				*dst++ = '0' + bg;
+			} else {
+				dst += sprintf(dst, "48;5;%d", bg);
+			}
+		}
+		*dst++ = 'm';
+	}
+	*dst = 0;
+	return;
+bad:
+	die("bad color value '%.*s' for variable '%s'", value_len, value, var);
+}
+
+int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty)
+{
+	if (value) {
+		if (!strcasecmp(value, "never"))
+			return 0;
+		if (!strcasecmp(value, "always"))
+			return 1;
+		if (!strcasecmp(value, "auto"))
+			goto auto_color;
+	}
+
+	/* Missing or explicit false to turn off colorization */
+	if (!perf_config_bool(var, value))
+		return 0;
+
+	/* any normal truth value defaults to 'auto' */
+ auto_color:
+	if (stdout_is_tty < 0)
+		stdout_is_tty = isatty(1);
+	if (stdout_is_tty || (pager_in_use() && pager_use_color)) {
+		char *term = getenv("TERM");
+		if (term && strcmp(term, "dumb"))
+			return 1;
+	}
+	return 0;
+}
+
+int perf_color_default_config(const char *var, const char *value, void *cb)
+{
+	if (!strcmp(var, "color.ui")) {
+		perf_use_color_default = perf_config_colorbool(var, value, -1);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
+static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
+		va_list args, const char *trail)
+{
+	int r = 0;
+
+	if (*color)
+		r += fprintf(fp, "%s", color);
+	r += vfprintf(fp, fmt, args);
+	if (*color)
+		r += fprintf(fp, "%s", PERF_COLOR_RESET);
+	if (trail)
+		r += fprintf(fp, "%s", trail);
+	return r;
+}
+
+
+
+int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+	va_start(args, fmt);
+	r = color_vfprintf(fp, color, fmt, args, NULL);
+	va_end(args);
+	return r;
+}
+
+int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+	va_start(args, fmt);
+	r = color_vfprintf(fp, color, fmt, args, "\n");
+	va_end(args);
+	return r;
+}
+
+/*
+ * This function splits the buffer by newlines and colors the lines individually.
+ *
+ * Returns 0 on success.
+ */
+int color_fwrite_lines(FILE *fp, const char *color,
+		size_t count, const char *buf)
+{
+	if (!*color)
+		return fwrite(buf, count, 1, fp) != 1;
+	while (count) {
+		char *p = memchr(buf, '\n', count);
+		if (p != buf && (fputs(color, fp) < 0 ||
+				fwrite(buf, p ? p - buf : count, 1, fp) != 1 ||
+				fputs(PERF_COLOR_RESET, fp) < 0))
+			return -1;
+		if (!p)
+			return 0;
+		if (fputc('\n', fp) < 0)
+			return -1;
+		count -= p + 1 - buf;
+		buf = p + 1;
+	}
+	return 0;
+}
+
+
diff --git a/Documentation/perf_counter/util/color.h b/Documentation/perf_counter/util/color.h
new file mode 100644
index 0000000..5abfd37
--- /dev/null
+++ b/Documentation/perf_counter/util/color.h
@@ -0,0 +1,36 @@
+#ifndef COLOR_H
+#define COLOR_H
+
+/* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
+#define COLOR_MAXLEN 24
+
+#define PERF_COLOR_NORMAL	""
+#define PERF_COLOR_RESET	"\033[m"
+#define PERF_COLOR_BOLD		"\033[1m"
+#define PERF_COLOR_RED		"\033[31m"
+#define PERF_COLOR_GREEN	"\033[32m"
+#define PERF_COLOR_YELLOW	"\033[33m"
+#define PERF_COLOR_BLUE		"\033[34m"
+#define PERF_COLOR_MAGENTA	"\033[35m"
+#define PERF_COLOR_CYAN		"\033[36m"
+#define PERF_COLOR_BG_RED	"\033[41m"
+
+/*
+ * This variable stores the value of color.ui
+ */
+extern int perf_use_color_default;
+
+
+/*
+ * Use this instead of perf_default_config if you need the value of color.ui.
+ */
+int perf_color_default_config(const char *var, const char *value, void *cb);
+
+int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
+void color_parse(const char *value, const char *var, char *dst);
+void color_parse_mem(const char *value, int len, const char *var, char *dst);
+int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
+int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
+int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
+
+#endif /* COLOR_H */
diff --git a/Documentation/perf_counter/util/environment.c b/Documentation/perf_counter/util/environment.c
index 9b1c819..275b0ee 100644
--- a/Documentation/perf_counter/util/environment.c
+++ b/Documentation/perf_counter/util/environment.c
@@ -6,3 +6,4 @@
 #include "cache.h"
 
 const char *pager_program;
+int pager_use_color = 1;
