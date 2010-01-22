Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520Ab0AVMJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab0AVMJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502Ab0AVMJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:09:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50292 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0AVMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:09:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 13:08:59 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH v1 1/1] Extended events (platform-specific) support in perf
In-reply-to: <1264162139-26788-1-git-send-email-t.fujak@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>
Message-id: <1264162139-26788-2-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
References: <1264162139-26788-1-git-send-email-t.fujak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kuyngmin.park@samsung.com>

---
 tools/perf/util/parse-events.c |  224 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 213 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05d0c5c..3e32198 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -9,6 +9,9 @@
 #include "header.h"
 #include "debugfs.h"
 
+#define			EXTENDED_EVENT_PATH	\
+			"/sys/devices/system/cpu/perf_events/extevents"
+
 int				nr_counters;
 
 struct perf_event_attr		attrs[MAX_COUNTERS];
@@ -60,6 +63,10 @@ static struct event_symbol event_symbols[] = {
 #define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
+static struct event_symbol *extended_event_symbols;
+static unsigned int 	extended_event_count;
+static int 			extended_events_initialized;
+
 static const char *hw_event_names[] = {
 	"cycles",
 	"instructions",
@@ -241,6 +248,157 @@ static const char *tracepoint_id_to_name(u64 config)
 	return buf;
 }
 
+static unsigned count_lines(const char *str, unsigned size)
+{
+	unsigned count = 0;
+
+	while (size--)
+		count += ('\n' == *str++);
+	return count;
+}
+
+#define	BYTES_PER_CHUNK 4096
+/* returns the number of lines read;
+   on fail the return is negative and no memory is allocated
+   otherwise the *buf contains a memory chunk of which first
+   *size bytes are used for file contents
+ */
+static int read_file(int fd, char **buf, unsigned *size)
+{
+	unsigned bytes = BYTES_PER_CHUNK;
+	int lines = 0;
+	char *ptr = malloc(bytes);
+
+	*size = 0;
+	do {
+		int ret = read(fd, ptr + *size, bytes - *size);
+		if (ret < 0) {
+			if (EINTR == errno)
+				continue;
+			else {
+				free(ptr);
+				return -1;
+			}
+		}
+
+		if (!ret)
+			break;
+
+		lines += count_lines(ptr + *size, ret);
+		*size += ret;
+
+		if (*size == bytes) {
+			char *tmp = realloc(ptr, bytes <<= 1);
+			if (!tmp) {
+				free(ptr);
+				return -1;
+			}
+			ptr = tmp;
+		}
+	} while (1);
+
+	*buf = ptr;
+	return lines;
+}
+
+static int parse_extevent_file(struct event_symbol *symbols,
+			unsigned lines, char *buf)
+{
+	char *name, *description, *ptr, *end;
+	unsigned offset = 0, count = 0;
+	int items, eaten;
+	unsigned long long discard;
+
+/* each line format should be "0x%llx\t%s\t%lld-%lld\t%s\n" */
+	while (lines--) {
+		items = sscanf(buf + offset + 2, "%llx",
+				&symbols[count].config);
+		if (1 != items)
+			continue;
+
+		/* skip 0x%llx\t */
+		ptr = strchr(buf + offset, '\t') + 1;
+
+		name = description = NULL;
+
+		end = strchr(ptr, '\t');
+		if (end) {
+			name = strndup(ptr, end - ptr);
+			ptr = end + 1;
+		}
+
+		ptr = end;
+		items = sscanf(ptr, "%lld-%lld\t%n", &discard, &discard,
+			 &eaten);
+		if (2 != items)
+			continue;
+
+		ptr += eaten;
+		end = strchr(ptr, '\n');
+		if (end) {
+			description = strndup(ptr, end - ptr);
+			offset = end - buf + 1;
+		} else
+			break;
+
+		if (name && description) {
+			symbols[count].symbol = name;
+			symbols[count].alias = "";
+			++count;
+			/* description gets lost here */
+			free(description);
+		} else {
+			free(description);
+			free(name);
+		}
+	}
+
+	return count;
+}
+
+static int load_extended_events(const char *extevent_path)
+{
+	int fd;
+	int lines = 0;
+	unsigned size = 0;
+	char *buf = NULL;
+
+	fd = open(extevent_path, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	lines = read_file(fd, &buf, &size);
+	close(fd);
+
+	if (0 < lines) {
+		struct event_symbol *symbols = (struct event_symbol *)
+				calloc(sizeof(struct event_symbol), lines);
+		if (symbols) {
+			int parsed_symbols = parse_extevent_file(symbols,
+							lines, buf);
+			if (0 < parsed_symbols) {
+				extended_event_symbols = symbols;
+				extended_event_count = parsed_symbols;
+			} else
+				free(symbols);
+		} else
+			lines = -1;
+	}
+	free(buf);
+
+	return lines;
+}
+
+static struct event_symbol *extevent_find_config(u64 config)
+{
+	unsigned int i;
+	for (i = 0; i < extended_event_count; ++i)
+		if (extended_event_symbols[i].config == config)
+			return &extended_event_symbols[i];
+
+	return NULL;
+}
+
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 {
 	if (hw_cache_stat[cache_type] & COP(cache_op))
@@ -283,10 +441,16 @@ const char *__event_name(int type, u64 config)
 	}
 
 	switch (type) {
-	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HARDWARE: {
+		const struct event_symbol *event;
+
 		if (config < PERF_COUNT_HW_MAX)
 			return hw_event_names[config];
+		event = extevent_find_config(config);
+		if (event)
+			return event->symbol;
 		return "unknown-hardware";
+	}
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
@@ -611,33 +775,34 @@ parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
 	return EVT_HANDLED;
 }
 
-static int check_events(const char *str, unsigned int i)
+static int check_event(const char *str, const struct event_symbol *event)
 {
 	int n;
 
-	n = strlen(event_symbols[i].symbol);
-	if (!strncmp(str, event_symbols[i].symbol, n))
+	n = strlen(event->symbol);
+	if (!strncmp(str, event->symbol, n))
 		return n;
 
-	n = strlen(event_symbols[i].alias);
+	n = strlen(event->alias);
 	if (n)
-		if (!strncmp(str, event_symbols[i].alias, n))
+		if (!strncmp(str, event->alias, n))
 			return n;
 	return 0;
 }
 
 static enum event_result
-parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+do_parse_symbolic_event(const char **strp, struct perf_event_attr *attr,
+			const struct event_symbol *symbols, unsigned int count)
 {
 	const char *str = *strp;
 	unsigned int i;
 	int n;
 
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		n = check_events(str, i);
+	for (i = 0; i < count; ++i) {
+		n = check_event(str, &symbols[i]);
 		if (n > 0) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
+			attr->type = symbols[i].type;
+			attr->config = symbols[i].config;
 			*strp = str + n;
 			return EVT_HANDLED;
 		}
@@ -646,6 +811,27 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
+parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+{
+	return do_parse_symbolic_event(strp, attr,
+			event_symbols, ARRAY_SIZE(event_symbols));
+}
+
+static enum event_result
+parse_extended_event(const char **strp, struct perf_event_attr *attr)
+{
+	if (!extended_events_initialized)
+		extended_events_initialized =
+			load_extended_events(EXTENDED_EVENT_PATH);
+
+	if (extended_events_initialized < 0)
+		return EVT_FAILED;
+
+	return do_parse_symbolic_event(strp, attr, extended_event_symbols,
+				extended_event_count);
+}
+
+static enum event_result
 parse_raw_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
@@ -744,6 +930,10 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	ret = parse_extended_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	ret = parse_breakpoint_event(str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
@@ -932,6 +1122,18 @@ void print_events(void)
 		}
 	}
 
+    if (!extended_events_initialized)
+		extended_events_initialized =
+			load_extended_events(EXTENDED_EVENT_PATH);
+
+    if (0 < extended_events_initialized) {
+		for (i = 0; i < extended_event_count; ++i)
+			printf("  %-42s [%s]\n",
+				extended_event_symbols[i].symbol,
+				"Hardware platform-specific event");
+	}
+
+
 	printf("\n");
 	printf("  %-42s [%s]\n",
 		"rNNN", event_type_descriptors[PERF_TYPE_RAW]);
-- 
1.5.4.3

