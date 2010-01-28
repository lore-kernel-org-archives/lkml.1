Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203Ab0A1JfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0A1JfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147Ab0A1Je5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:34:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab0A1Jeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:34:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 28 Jan 2010 10:34:23 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v2 3/3] perf: Extended events (platform-specific) support
 in perf
In-reply-to: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, m.nazarewicz@samsung.com,
       Tomasz Fujak <t.fujak@samsung.com>
Message-id: <1264671263-21412-4-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 tools/perf/util/parse-events.c |  217 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 206 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5bc0fb..37a9b25 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -9,6 +9,9 @@
 #include "header.h"
 #include "debugfs.h"
 
+#define			PLATFORM_EVENT_FILE_NAME\
+				"perf_events_platform"
+
 int				nr_counters;
 
 struct perf_event_attr		attrs[MAX_COUNTERS];
@@ -60,6 +63,10 @@ static struct event_symbol event_symbols[] = {
 #define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
+static struct event_symbol	*platform_event_symbols;
+static unsigned int		platform_event_count;
+static int			platform_events_initialized;
+
 static const char *hw_event_names[] = {
 	"cycles",
 	"instructions",
@@ -241,6 +248,150 @@ static const char *tracepoint_id_to_name(u64 config)
 	return buf;
 }
 
+/* o for valid line, 1 for invalid */
+/* each line format should be "0x%llx\t%s\t%lld-%lld\t%s\n" */
+static int parse_platevent_line(char *line, struct event_symbol *symbol)
+{
+	char *name = NULL;
+	char *description, *ptr, *end;
+	int eaten;
+	unsigned long long discard;
+
+	if (1 !=  sscanf(line + 2, "%llx", &symbol->config))
+		return 1;
+
+	/* skip 0x%llx\t */
+	ptr = strchr(line + 2, '\t') + 1;
+	if (!ptr)
+		return 1;
+
+	end = strchr(ptr, '\t');
+	if (!end)
+		return 1;
+
+	name = strndup(ptr, end - ptr);
+	ptr = end + 1;
+
+	if (2 != sscanf(ptr, "%lld-%lld\t%n", &discard, &discard, &eaten)) {
+		free(name);
+		return 1;
+	}
+
+
+	description = strdup(ptr + eaten);
+	description[strlen(description) - 1] = 0;
+
+	if (name && description) {
+		symbol->symbol = name;
+		symbol->alias = "";
+		/* description gets lost here */
+	} else
+		free(name);
+	free(description);
+
+	return 0;
+}
+
+#define LINE_SIZE_MAX 256
+/* 0 - event ok, < 0 - unrecoverable error, > 0 - eof */
+static int extract_platevent_item(FILE *file, struct event_symbol *symbol)
+{
+	int result = -1;
+
+	do {
+		char line[LINE_SIZE_MAX];
+
+		if (!fgets(line, LINE_SIZE_MAX, file)) {
+			if (feof(file))
+				return 1;
+			 if (ferror(file))
+				return -1;
+			continue;
+		}
+		result = parse_platevent_line(line, symbol);
+	} while (0 < result);
+
+	return result;
+}
+
+#define PATH_LEN_MAX 256
+static int load_platform_events(const char *platevent_entry)
+{
+	FILE *file;
+	int count = 0;
+	int capacity = 16;
+	int result;
+	char platevent_file_path[PATH_LEN_MAX];
+
+	struct event_symbol *symbols = NULL;
+
+	/* if the path is of excessive length, skip it */
+	if (debugfs_make_path(platevent_entry, platevent_file_path,
+		ARRAY_SIZE(platevent_file_path)))
+		return -1;
+
+	file = fopen(platevent_file_path, "r");
+	if (!file) {
+		fprintf(stderr, "can't open platform event file '%s'\n",
+			platevent_file_path);
+		return -1;
+	}
+
+	symbols = (struct event_symbol *)
+				calloc(sizeof(struct event_symbol), capacity);
+	if (!symbols) {
+		fclose(file);
+		return -1;
+	}
+
+	do {
+		result = extract_platevent_item(file, &symbols[count]);
+		if (!result)
+			++count;
+
+		if (capacity == count) {
+			struct event_symbol *tmp =
+				(struct event_symbol *)realloc(symbols,
+				sizeof(struct event_symbol) *
+				(capacity <<= 1));
+
+			if (!tmp) {
+				result = -1;
+				break;
+			}
+			symbols = tmp;
+		}
+	} while (!result);
+	/* <0 - error */
+
+	fclose(file);
+
+	if ((result < 0) || (0 == count)) {
+		/* ditching the collection for there was a parse error */
+		free(symbols);
+		count = 0;
+	} else {
+		/* trim the collection storage */
+		if (count != capacity)
+			platform_event_symbols = realloc(symbols,
+				sizeof(struct event_symbol) * count);
+		else
+			platform_event_symbols = symbols;
+		platform_event_count = count;
+	}
+	return count;
+}
+
+static struct event_symbol *platevent_find_config(u64 config)
+{
+	unsigned int i;
+	for (i = 0; i < platform_event_count; ++i)
+		if (platform_event_symbols[i].config == config)
+			return &platform_event_symbols[i];
+
+	return NULL;
+}
+
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 {
 	if (hw_cache_stat[cache_type] & COP(cache_op))
@@ -283,10 +434,16 @@ const char *__event_name(int type, u64 config)
 	}
 
 	switch (type) {
-	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HARDWARE: {
+		const struct event_symbol *event;
+
 		if (config < PERF_COUNT_HW_MAX)
 			return hw_event_names[config];
+		event = platevent_find_config(config);
+		if (event)
+			return event->symbol;
 		return "unknown-hardware";
+	}
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
@@ -606,33 +763,34 @@ parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
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
@@ -641,6 +799,27 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
+parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+{
+	return do_parse_symbolic_event(strp, attr,
+			event_symbols, ARRAY_SIZE(event_symbols));
+}
+
+static enum event_result
+parse_platform_event(const char **strp, struct perf_event_attr *attr)
+{
+	if (!platform_events_initialized)
+		platform_events_initialized =
+			load_platform_events(PLATFORM_EVENT_FILE_NAME);
+
+	if (platform_events_initialized < 0)
+		return EVT_FAILED;
+
+	return do_parse_symbolic_event(strp, attr, platform_event_symbols,
+				platform_event_count);
+}
+
+static enum event_result
 parse_raw_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
@@ -739,6 +918,10 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	ret = parse_platform_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	ret = parse_breakpoint_event(str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
@@ -924,6 +1107,18 @@ void print_events(void)
 		}
 	}
 
+    if (!platform_events_initialized)
+		platform_events_initialized =
+			load_platform_events(PLATFORM_EVENT_FILE_NAME);
+
+    if (0 < platform_events_initialized) {
+		for (i = 0; i < platform_event_count; ++i)
+			printf("  %-42s [%s]\n",
+				platform_event_symbols[i].symbol,
+				"Hardware platform-specific event");
+	}
+
+
 	printf("\n");
 	printf("  %-42s [raw hardware event descriptor]\n",
 		"rNNN");
-- 
1.5.4.3

