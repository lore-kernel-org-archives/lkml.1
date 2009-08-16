Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZHPUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZHPUFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZHPUFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:05:54 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39774 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZHPUFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OK6C9jVRTwfpdu3V8/CyHAfR4XJlUUaa+Wi7sAXxHXScfHHCEHIu/38A8FyQTHdWEh
         FhBGbPhk9Zolrm92jfS46LwAcN80FLDuwh6RosO0kVwNWZc7JGsWZ+O3IXaqBG5+am7D
         oPeRZdrW5y7VGyck6rknZX9g22aa3Zgk+uPZM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Librarize trace_event() helper
Date: Sun, 16 Aug 2009 22:05:48 +0200
Message-Id: <1250453149-664-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
References: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Librarize trace_event() helper so that perf trace can use it too.
Also cleanup a bit the debug.h includes. It's not good to have it
included in perf.h because it doesn't make it flexible against other
headers it may need (headers that can also depend on perf.h and then
create a recursive header dependency).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-annotate.c |    1 +
 tools/perf/builtin-record.c   |    1 +
 tools/perf/builtin-report.c   |   39 +--------------------------
 tools/perf/builtin-stat.c     |    2 +
 tools/perf/builtin-top.c      |    2 +
 tools/perf/perf.h             |    1 -
 tools/perf/util/color.c       |   10 +++++--
 tools/perf/util/color.h       |    1 +
 tools/perf/util/debug.c       |   58 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h       |    1 +
 tools/perf/util/symbol.c      |    2 +
 11 files changed, 76 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6d75151..96d421f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -17,6 +17,7 @@
 #include "util/string.h"
 
 #include "perf.h"
+#include "util/debug.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65b4115..6a5db67 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -16,6 +16,7 @@
 
 #include "util/header.h"
 #include "util/event.h"
+#include "util/debug.h"
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c6326de..1e3ad22 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -20,6 +20,7 @@
 #include "util/values.h"
 
 #include "perf.h"
+#include "util/debug.h"
 #include "util/header.h"
 
 #include "util/parse-options.h"
@@ -39,8 +40,6 @@ static char		*field_sep;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
-#define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
-
 static int		full_paths;
 static int		show_nr_samples;
 
@@ -1285,42 +1284,6 @@ process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static void trace_event(event_t *event)
-{
-	unsigned char *raw_event = (void *)event;
-	const char *color = PERF_COLOR_BLUE;
-	int i, j;
-
-	if (!dump_trace)
-		return;
-
-	dump_printf(".");
-	cdprintf("\n. ... raw event: size %d bytes\n", event->header.size);
-
-	for (i = 0; i < event->header.size; i++) {
-		if ((i & 15) == 0) {
-			dump_printf(".");
-			cdprintf("  %04x: ", i);
-		}
-
-		cdprintf(" %02x", raw_event[i]);
-
-		if (((i & 15) == 15) || i == event->header.size-1) {
-			cdprintf("  ");
-			for (j = 0; j < 15-(i & 15); j++)
-				cdprintf("   ");
-			for (j = 0; j < (i & 15); j++) {
-				if (isprint(raw_event[i-15+j]))
-					cdprintf("%c", raw_event[i-15+j]);
-				else
-					cdprintf(".");
-			}
-			cdprintf("\n");
-		}
-	}
-	dump_printf(".\n");
-}
-
 static int
 process_read_event(event_t *event, unsigned long offset, unsigned long head)
 {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 4b9dd4a..1a26262 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -42,6 +42,8 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/event.h"
+#include "util/debug.h"
 
 #include <sys/prctl.h>
 #include <math.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 06f763e..62b55ec 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -27,6 +27,8 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/debug.h"
+
 #include <assert.h>
 #include <fcntl.h>
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f550921..e5148e2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -48,7 +48,6 @@
 
 #include "../../include/linux/perf_counter.h"
 #include "util/types.h"
-#include "util/debug.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index e47fdeb..e88bca5 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -166,7 +166,7 @@ int perf_color_default_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
+static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
 		va_list args, const char *trail)
 {
 	int r = 0;
@@ -191,6 +191,10 @@ static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
 	return r;
 }
 
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args)
+{
+	return __color_vfprintf(fp, color, fmt, args, NULL);
+}
 
 
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
@@ -199,7 +203,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args, NULL);
+	r = color_vfprintf(fp, color, fmt, args);
 	va_end(args);
 	return r;
 }
@@ -209,7 +213,7 @@ int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...)
 	va_list args;
 	int r;
 	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args, "\n");
+	r = __color_vfprintf(fp, color, fmt, args, "\n");
 	va_end(args);
 	return r;
 }
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 43d0d1b..58d5975 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -32,6 +32,7 @@ int perf_color_default_config(const char *var, const char *value, void *cb);
 int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
 void color_parse(const char *value, const char *var, char *dst);
 void color_parse_mem(const char *value, int len, const char *var, char *dst);
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 8318fde..e8ca98f 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -1,10 +1,15 @@
 /* For general debugging purposes */
 
 #include "../perf.h"
+
 #include <string.h>
 #include <stdarg.h>
 #include <stdio.h>
 
+#include "color.h"
+#include "event.h"
+#include "debug.h"
+
 int verbose = 0;
 int dump_trace = 0;
 
@@ -35,3 +40,56 @@ int dump_printf(const char *fmt, ...)
 
 	return ret;
 }
+
+static int dump_printf_color(const char *fmt, const char *color, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, color);
+		ret = color_vfprintf(stdout, color, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+
+void trace_event(event_t *event)
+{
+	unsigned char *raw_event = (void *)event;
+	const char *color = PERF_COLOR_BLUE;
+	int i, j;
+
+	if (!dump_trace)
+		return;
+
+	dump_printf(".");
+	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
+			  event->header.size);
+
+	for (i = 0; i < event->header.size; i++) {
+		if ((i & 15) == 0) {
+			dump_printf(".");
+			dump_printf_color("  %04x: ", color, i);
+		}
+
+		dump_printf_color(" %02x", color, raw_event[i]);
+
+		if (((i & 15) == 15) || i == event->header.size-1) {
+			dump_printf_color("  ", color);
+			for (j = 0; j < 15-(i & 15); j++)
+				dump_printf_color("   ", color);
+			for (j = 0; j < (i & 15); j++) {
+				if (isprint(raw_event[i-15+j]))
+					dump_printf_color("%c", color,
+							  raw_event[i-15+j]);
+				else
+					dump_printf_color(".", color);
+			}
+			dump_printf_color("\n", color);
+		}
+	}
+	dump_printf(".\n");
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index a683bd5..437eea5 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,3 +5,4 @@ extern int dump_trace;
 
 int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+void trace_event(event_t *event);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3159d47..fd3d9c8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -3,6 +3,8 @@
 #include "string.h"
 #include "symbol.h"
 
+#include "debug.h"
+
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
-- 
1.6.2.3

