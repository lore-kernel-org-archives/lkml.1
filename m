Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZGFIbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZGFIbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZGFIbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:31:41 -0400
Received: from smtp.fireflyuk.net ([78.156.72.235]:1537 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226AbZGFIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:31:40 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Ben Gamari <bgamari.foss@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf tool: Add a trace point event parser.
Date: Mon,  6 Jul 2009 09:31:34 +0100
Message-Id: <1246869094-21237-2-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
References: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accept events of the form tp=i915/i915_wait and convert those to the
ftrace event id by expanding the short name to
'/sys/kernel/debug/tracing/events/i915/i915_wait/id'. (Substituting the
real debugfs mount path as appropriate.)

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 tools/perf/util/parse-events.c |  133 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5184959..36078a6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,11 +1,12 @@
-
-#include "../perf.h"
 #include "util.h"
+#include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
 
+#include <sys/mount.h>
+
 extern char *strcasestr(const char *haystack, const char *needle);
 
 int					nr_counters;
@@ -339,6 +340,133 @@ parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
 	return 0;
 }
 
+/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
+static const char *
+debug_mntpt (void)
+{
+	static char mntpt[4096];
+	FILE *file;
+	size_t line_len;
+	char *line;
+
+	if (mntpt[0])
+		return mntpt;
+
+	file = fopen("/proc/mounts", "r");
+	if (file == NULL)
+		return NULL;
+
+	while (getline(&line, &line_len, file) >= 0) {
+		char *start, *end;
+
+		if (strstr(line, " debugfs ") == NULL)
+			continue;
+
+		start = strchr(line, ' ') + 1;
+		end = strchr(start + 1, ' ');
+		if(end - start > 4095)
+			goto err_file;
+		memcpy(mntpt, start, end-start);
+		break;
+	}
+	free(line);
+	fclose(file);
+
+	if (mntpt[0] == '\0') {
+		if (mount("none", "/sys/kernel/debug", "debugfs", 0, NULL))
+			return NULL;
+
+		strcpy(mntpt, "/sys/kernel/debug");
+	}
+
+	return mntpt;
+
+err_file:
+	free(line);
+	fclose(file);
+	return NULL;
+}
+
+static int
+safe_strcat(char **strp, int *rem, const char *src, int len)
+{
+	if (len < 0)
+		len = strlen(src);
+	if (len >= *rem)
+		return 0;
+
+	memcpy(*strp, src, len);
+	*strp += len;
+	*rem -= len;
+	**strp = '\0';
+
+	return 1;
+}
+
+static int
+parse_tracepoint_event(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	const char *mntpt;
+	char buf[4096], *bufp;
+	int rem;
+	int fd;
+	int ret;
+	char *comma;
+
+	if (strncmp(str, "tp=", 3))
+	    return 0;
+
+	str += 3;
+
+	/* Expand the tracepoint event to:
+	 *   /sys/kernel/debug/tracing/events/<tracepoint>/id
+	 * and then read that file to determine the ftrace event id to
+	 * pass to perf_counters. Substituting the real debugfs mount path
+	 * as appropriate.
+	 */
+
+	mntpt = debug_mntpt();
+	if (mntpt == NULL)
+		return 0;
+
+	bufp = buf, rem = sizeof(buf);
+	if (!safe_strcat(&bufp, &rem, mntpt, -1))
+		return 0;
+	if (!safe_strcat(&bufp, &rem, "/tracing/events/", -1))
+		return 0;
+
+	comma = strchr(str, ',');
+	if (comma) {
+		if (!safe_strcat(&bufp, &rem, str, comma - str))
+			return 0;
+		*strp = comma;
+	} else {
+		if (!safe_strcat(&bufp, &rem, str, -1))
+			return 0;
+		*strp = str + strlen (str);
+	}
+	if (!safe_strcat(&bufp, &rem, "/id", -1))
+		return 0;
+
+	fd = open(buf, O_RDONLY);
+	if (fd == 0)
+		return 0;
+
+	/* We expect to read a string of "integer\n". */
+	ret = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (ret == -1 || ret == sizeof(buf))
+		return 0;
+
+	buf[ret] = '\0';
+
+	attr->config = strtoul(buf, &bufp, 0);
+	attr->type = PERF_TYPE_TRACEPOINT;
+
+	return bufp == buf + ret-1;
+}
+
 static int
 parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
 {
@@ -377,6 +505,7 @@ static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 	if (!(parse_raw_event(str, attr) ||
 	      parse_numeric_event(str, attr) ||
 	      parse_symbolic_event(str, attr) ||
+	      parse_tracepoint_event(str, attr) ||
 	      parse_generic_hw_event(str, attr)))
 		return 0;
 
-- 
1.6.3.3

