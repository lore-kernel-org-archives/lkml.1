Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZGADE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZGADE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZGADEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:04:47 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54957 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZGADEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:04:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19018.53826.843815.189847@cargo.ozlabs.ibm.com>
Date: Wed, 1 Jul 2009 13:04:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: tools: Rework event parsing
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reworks the parser for event descriptors to make it more
consistent in what it accepts.  It is now structured as a recursive
descent parser for the following grammar:

events		::= event ( ("," | space) space* event )*
event		::= ( raw_event | numeric_event | symbolic_event |
		      generic_hw_event ) [ event_modifier ]
raw_event	::= "r" hex_number
numeric_event	::= number ":" number
number		::= decimal_number | "0x" hex_number | "0" octal_number
symbolic_event	::= string_from_event_symbols_array
generic_hw_event::= cache_type ( "-" ( cache_op | cache_result ) )*
event_modifier	::= ":" ( "u" | "k" | "h" )+

with the extra restriction that you can have at most one cache_op
and at most one cache_result.

We pass the current string pointer by reference (i.e. as a const char **)
to the various parsing functions so that they can advance the pointer
to indicate how much they consumed.  They return 0 if they didn't
recognize the thing at the pointer or 1 if they did (and advance the
pointer past it).

This also fixes parse_aliases to take the longest matching alias from
the table, not the first one.  Otherwise "l1-data" would match the
"l1-d" alias and the "ata" would not be consumed.

This allows event modifiers indicating what processor modes to count in
to be applied to any event, not just numeric events, and adds a ":h"
modifier to indicate counting in hypervisor mode.  Specifying ":u"
now sets both exclude_kernel and exclude_hv, and so on.  Multiple
modes can be specified, e.g. ":uk" will count in user or hypervisor
mode (i.e. only exclude_kernel will be set).

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/parse-events.c |  232 +++++++++++++++++++++++++++------------
 1 files changed, 160 insertions(+), 72 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..76f5d62 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -184,16 +184,20 @@ char *event_name(int counter)
 	return "unknown";
 }
 
-static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
+static int parse_aliases(const char **str, char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
+	int n, longest = -1;
 
 	for (i = 0; i < size; i++) {
-		for (j = 0; j < MAX_ALIASES; j++) {
-			if (!names[i][j])
-				break;
-			if (strcasestr(str, names[i][j]))
-				return i;
+		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
+			n = strlen(names[i][j]);
+			if (n > longest && !strncasecmp(*str, names[i][j], n))
+				longest = n;
+		}
+		if (longest > 0) {
+			*str += longest;
+			return i;
 		}
 	}
 
@@ -201,30 +205,53 @@ static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
 }
 
 static int
-parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
+parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 {
-	int cache_type = -1, cache_op = 0, cache_result = 0;
+	const char *s = *str;
+	int cache_type = -1, cache_op = -1, cache_result = -1;
 
-	cache_type = parse_aliases(str, hw_cache, PERF_COUNT_HW_CACHE_MAX);
+	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
 	/*
 	 * No fallback - if we cannot get a clear cache type
 	 * then bail out:
 	 */
 	if (cache_type == -1)
-		return -EINVAL;
+		return 0;
+
+	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
+		++s;
+
+		if (cache_op == -1) {
+			cache_op = parse_aliases(&s, hw_cache_op,
+						PERF_COUNT_HW_CACHE_OP_MAX);
+			if (cache_op >= 0) {
+				if (!is_cache_op_valid(cache_type, cache_op))
+					return 0;
+				continue;
+			}
+		}
 
-	cache_op = parse_aliases(str, hw_cache_op, PERF_COUNT_HW_CACHE_OP_MAX);
+		if (cache_result == -1) {
+			cache_result = parse_aliases(&s, hw_cache_result,
+						PERF_COUNT_HW_CACHE_RESULT_MAX);
+			if (cache_result >= 0)
+				continue;
+		}
+
+		/*
+		 * Can't parse this as a cache op or result, so back up
+		 * to the '-'.
+		 */
+		--s;
+		break;
+	}
+		
 	/*
 	 * Fall back to reads:
 	 */
 	if (cache_op == -1)
 		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
 
-	if (!is_cache_op_valid(cache_type, cache_op))
-		return -EINVAL;
-
-	cache_result = parse_aliases(str, hw_cache_result,
-					PERF_COUNT_HW_CACHE_RESULT_MAX);
 	/*
 	 * Fall back to accesses:
 	 */
@@ -234,93 +261,154 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
 	attr->type = PERF_TYPE_HW_CACHE;
 
-	return 0;
+	*str = s;
+	return 1;
 }
 
 static int check_events(const char *str, unsigned int i)
 {
-	if (!strncmp(str, event_symbols[i].symbol,
-		     strlen(event_symbols[i].symbol)))
-		return 1;
+	int n;
 
-	if (strlen(event_symbols[i].alias))
-		if (!strncmp(str, event_symbols[i].alias,
-			     strlen(event_symbols[i].alias)))
-			return 1;
+	n = strlen(event_symbols[i].symbol);
+	if (!strncmp(str, event_symbols[i].symbol, n))
+		return n;
+
+	n = strlen(event_symbols[i].alias);
+	if (n)
+		if (!strncmp(str, event_symbols[i].alias, n))
+			return n;
 	return 0;
 }
 
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
+static int
+parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
-	u64 config, id;
-	int type;
+	const char *str = *strp;
 	unsigned int i;
-	const char *sep, *pstr;
+	int n;
 
-	if (str[0] == 'r' && hex2u64(str + 1, &config) > 0) {
-		attr->type = PERF_TYPE_RAW;
-		attr->config = config;
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		n = check_events(str, i);
+		if (n > 0) {
+			attr->type = event_symbols[i].type;
+			attr->config = event_symbols[i].config;
+			*strp = str + n;
+			return 1;
+		}
+	}
+	return 0;
+}
 
+static int parse_raw_event(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	u64 config;
+	int n;
+
+	if (*str != 'r')
 		return 0;
+	n = hex2u64(str + 1, &config);
+	if (n > 0) {
+		*strp = str + n + 1;
+		attr->type = PERF_TYPE_RAW;
+		attr->config = config;
+		return 1;
 	}
+	return 0;
+}
 
-	pstr = str;
-	sep = strchr(pstr, ':');
-	if (sep) {
-		type = atoi(pstr);
-		pstr = sep + 1;
-		id = atoi(pstr);
-		sep = strchr(pstr, ':');
-		if (sep) {
-			pstr = sep + 1;
-			if (strchr(pstr, 'k'))
-				attr->exclude_user = 1;
-			if (strchr(pstr, 'u'))
-				attr->exclude_kernel = 1;
+static int
+parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	char *endp;
+	unsigned long type;
+	u64 config;
+
+	type = strtoul(str, &endp, 0);
+	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
+		str = endp + 1;
+		config = strtoul(str, &endp, 0);
+		if (endp > str) {
+			attr->type = type;
+			attr->config = config;
+			*strp = endp;
+			return 1;
 		}
-		attr->type = type;
-		attr->config = id;
+	}
+	return 0;
+}
 
+static int
+parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	int eu = 1, ek = 1, eh = 1;
+
+	if (*str++ != ':')
 		return 0;
+	while (*str) {
+		if (*str == 'u')
+			eu = 0;
+		else if (*str == 'k')
+			ek = 0;
+		else if (*str == 'h')
+			eh = 0;
+		else
+			break;
+		++str;
+	}
+	if (str >= *strp + 2) {
+		*strp = str;
+		attr->exclude_user   = eu;
+		attr->exclude_kernel = ek;
+		attr->exclude_hv     = eh;
+		return 1;
 	}
+	return 0;
+}
 
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (check_events(str, i)) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
+/*
+ * Each event can have multiple symbolic names.
+ * Symbolic names are (almost) exactly matched.
+ */
+static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
+{
+	if (!(parse_raw_event(str, attr) ||
+	      parse_numeric_event(str, attr) ||
+	      parse_symbolic_event(str, attr) ||
+	      parse_generic_hw_event(str, attr)))
+		return 0;
 
-			return 0;
-		}
-	}
+	parse_event_modifier(str, attr);
 
-	return parse_generic_hw_symbols(str, attr);
+	return 1;
 }
 
 int parse_events(const struct option *opt, const char *str, int unset)
 {
 	struct perf_counter_attr attr;
-	int ret;
 
-	memset(&attr, 0, sizeof(attr));
-again:
-	if (nr_counters == MAX_COUNTERS)
-		return -1;
+	for (;;) {
+		if (nr_counters == MAX_COUNTERS)
+			return -1;
+
+		memset(&attr, 0, sizeof(attr));
+		if (!parse_event_symbols(&str, &attr))
+			return -1;
 
-	ret = parse_event_symbols(str, &attr);
-	if (ret < 0)
-		return ret;
+		if (!(*str == 0 || *str == ',' || isspace(*str)))
+			return -1;
 
-	attrs[nr_counters] = attr;
-	nr_counters++;
+		attrs[nr_counters] = attr;
+		nr_counters++;
 
-	str = strstr(str, ",");
-	if (str) {
-		str++;
-		goto again;
+		if (*str == 0)
+			break;
+		if (*str == ',')
+			++str;
+		while (isspace(*str))
+			++str;
 	}
 
 	return 0;
-- 
1.6.0.4

