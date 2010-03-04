Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0CDCbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:31:03 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51265 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0CDCas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:30:48 -0500
Message-ID: <4B8F1B58.5000702@linux.vnet.ibm.com>
Date: Wed, 03 Mar 2010 18:30:48 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic event
 names to "perf stat"
Content-Type: multipart/mixed;
 boundary="------------080205060905080606000707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080205060905080606000707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

For your review, this patch adds support for arch-dependent symbolic event names 
to the "perf stat" tool, and could be expanded to other "perf *" commands fairly 
easily, I suspect.

To support arch-dependent event names without adding arch-dependent code to 
perf, I added a callout mechanism whereby perf will look for the environment 
variable: PERF_ARCH_DEP_LIB, and if it exists, it will try to open it as a 
shared object.  If that succeeds, it looks for the symbol 
"parse_arch_dep_event".  If that exists, that function will be called by 
parse_events() before all of the other event parsing functions in 
parse-events.c.  It is passed the same arguments as the other parse_*_event 
functions, namely the event string and a pointer to an event attribute structure.

As the code existed, "perf stat" would print out the count results, but for raw 
events (which is how arch-dependent events are supported in perf_events), it 
would just print out a raw code.  This is not acceptable, especially when a 
symbolic name was placed on the command line.  So I changed the code to save 
away the event name that was passed on the command line, rather than doing a 
reverse translation to an event string based on the event type and config fields 
of the attr structure.  In this way, there's no need for a reverse translation 
function in the arch-dependent library; only a event string->attr struct 
function is needed.

I could well be missing something, but I don't understand why reverse 
translation is ever needed in perf, as long as the tool keeps track of the 
original event strings.

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


--------------080205060905080606000707
Content-Type: text/plain;
 name="perf_symbolic_event.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf_symbolic_event.diff"

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 54a5b50..20d3255 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -199,7 +199,7 @@ ifndef PERF_DEBUG
 endif
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lpthread -lrt -lelf -lm -ldl
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05d0c5c..ba4a663 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -8,11 +8,13 @@
 #include "cache.h"
 #include "header.h"
 #include "debugfs.h"
+#include "dlfcn.h"
 
 int				nr_counters;
 
 struct perf_event_attr		attrs[MAX_COUNTERS];
 char				*filters[MAX_COUNTERS];
+char 				*event_names[MAX_COUNTERS];
 
 struct event_symbol {
 	u8		type;
@@ -267,10 +269,7 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 
 const char *event_name(int counter)
 {
-	u64 config = attrs[counter].config;
-	int type = attrs[counter].type;
-
-	return __event_name(type, config);
+	return event_names[counter];
 }
 
 const char *__event_name(int type, u64 config)
@@ -324,6 +323,38 @@ const char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
+#define PERF_ARCH_DEP_LIB_ENV_VAR "PERF_ARCH_DEP_LIB"
+
+static int arch_dep_lib_initialized = 0;
+static int (*parse_arch_dep_event_callout)(const char **strp,
+				   	   struct perf_event_attr *attr) = NULL;
+
+static void initialize_arch_dep_lib(void)
+{
+	char *lib_name = getenv(PERF_ARCH_DEP_LIB_ENV_VAR);
+	void *lib_handle;
+
+	if (!lib_name)
+		return;
+
+	lib_handle = dlopen(lib_name, RTLD_NOW);
+	if (!lib_handle) {
+		fprintf(stderr, "The environment variable %s is set to %s, "
+				"but we couldn't open it.  error: %s\n",
+				PERF_ARCH_DEP_LIB_ENV_VAR, lib_name, dlerror());
+		exit(1);
+	}
+	parse_arch_dep_event_callout = dlsym(lib_handle, "parse_arch_dep_event");
+	if (!parse_arch_dep_event_callout) {
+		fprintf(stderr, "The environment variable %s is set to %s, "
+				"but we couldn't obtain from it the required function - "
+				"parse_arch_dep_event.  error: %s\n",
+				PERF_ARCH_DEP_LIB_ENV_VAR, lib_name, dlerror());
+		exit(1);
+	}
+	arch_dep_lib_initialized = 1;
+}
+
 static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
@@ -686,6 +717,18 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 	return EVT_FAILED;
 }
 
+static int
+parse_arch_dep_event(const char **strp, struct perf_event_attr *attr)
+{
+	if (! arch_dep_lib_initialized)
+		initialize_arch_dep_lib();
+
+	if (arch_dep_lib_initialized)
+		return parse_arch_dep_event_callout(strp, attr);
+	else
+		return 0;
+}
+
 static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
@@ -724,6 +767,11 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 {
 	enum event_result ret;
 
+	ret = parse_arch_dep_event(str, attr);
+	if (ret != EVT_FAILED)
+		/* modifiers are already processed */
+		return ret;
+
 	ret = parse_tracepoint_event(str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
@@ -784,6 +832,17 @@ static int store_event_type(const char *orgname)
 	return perf_header__push_event(id, orgname);
 }
 
+static char *make_substr(char *start, char *end)
+{
+	int length = end - start;
+	char *result = malloc(length + 1);
+
+	strncpy(result, start, length);
+	result[length] = '\0';
+
+	return result;
+}
+
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_event_attr attr;
@@ -794,19 +853,23 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 			return -1;
 
 	for (;;) {
+		char *start, *end;
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
 
 		memset(&attr, 0, sizeof(attr));
+		start = (char *)str;
 		ret = parse_event_symbols(&str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
 
 		if (!(*str == 0 || *str == ',' || isspace(*str)))
 			return -1;
+		end = (char *)str;
 
 		if (ret != EVT_HANDLED_ALL) {
 			attrs[nr_counters] = attr;
+			event_names[nr_counters] = make_substr(start, end);
 			nr_counters++;
 		}
 

--------------080205060905080606000707--

