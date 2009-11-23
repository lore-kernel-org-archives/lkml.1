Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZKWOmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZKWOmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZKWOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:42:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:2653 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZKWOmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:42:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=THk8QYKLO7KMsgt/ktPEDwgYNMbh4TB+VVGrslggzg+AfUtE4hUTwHpWlPnh+g4fUk
         iIVG8ArhpOlv8/WVwqQNGKC2uNq7FjSwUXq1BXm4j4Q+0JtMfOpvKWp2kgQNgGKXNQX0
         MlSyDOQXM+uV4otT95wxyouWxWNI4joga82zM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 4/4] perf tools: Add support for breakpoint events in perf tools
Date: Mon, 23 Nov 2009 15:42:35 +0100
Message-Id: <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the breakpoint events support with this new sysnopsis:

mem:addr[:access]

Where addr is a raw addr value in the kernel and access can be
either [r][w][x]

Example to profile tasklist_lock:

	$ grep tasklist_lock /proc/kallsyms
	ffffffff8189c000 D tasklist_lock

	$ perf record -e mem:0xffffffff8189c000:rw -a -f -c 1
	$ perf report

	# Samples: 62
	#
	# Overhead          Command  Shared Object  Symbol
	# ........  ...............  .............  ......
	#
	    29.03%          swapper  [kernel]       [k] _raw_read_trylock
	    29.03%          swapper  [kernel]       [k] _raw_read_unlock
	    19.35%             init  [kernel]       [k] _raw_read_trylock
	    19.35%             init  [kernel]       [k] _raw_read_unlock
	     1.61%         events/0  [kernel]       [k] _raw_read_trylock
	     1.61%         events/0  [kernel]       [k] _raw_read_unlock

Coming soon:

- support for symbols in the event definition.
- default period to 1 for breakpoint events because these are not
  high frequency events. The same thing is needed for trace events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-record.txt |   16 ++++--
 tools/perf/util/parse-events.c           |   84 +++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 0ff23de..fc46c0b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -26,11 +26,19 @@ OPTIONS
 
 -e::
 --event=::
-	Select the PMU event. Selection can be a symbolic event name
-	(use 'perf list' to list all events) or a raw PMU
-	event (eventsel+umask) in the form of rNNN where NNN is a
-	hexadecimal event descriptor.
+	Select the PMU event. Selection can be:
 
+        - a symbolic event name	(use 'perf list' to list all events)
+
+        - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
+	  hexadecimal event descriptor.
+
+        - a hardware breakpoint event in the form of '\mem:addr[:access]'
+          where addr is the address in memory you want to break in.
+          Access is the memory access type (read, write, execute) it can
+          be passed as follows: '\mem:addr[:[r][w][x]]'.
+          If you want to profile read-write accesses in 0x1000, just set
+          'mem:0x1000:rw'.
 -a::
         System-wide collection.
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0faf4f2..0700274 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,4 +1,4 @@
-
+#include "../../../include/linux/hw_breakpoint.h"
 #include "util.h"
 #include "../perf.h"
 #include "parse-options.h"
@@ -540,6 +540,81 @@ static enum event_result parse_tracepoint_event(const char **strp,
 						     attr, strp);
 }
 
+static enum event_result
+parse_breakpoint_type(const char *type, const char **strp,
+		      struct perf_event_attr *attr)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (!type[i])
+			break;
+
+		switch (type[i]) {
+		case 'r':
+			attr->bp_type |= HW_BREAKPOINT_R;
+			break;
+		case 'w':
+			attr->bp_type |= HW_BREAKPOINT_W;
+			break;
+		case 'x':
+			attr->bp_type |= HW_BREAKPOINT_X;
+			break;
+		default:
+			return EVT_FAILED;
+		}
+	}
+	if (!attr->bp_type) /* Default */
+		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
+
+	*strp = type + i;
+
+	return EVT_HANDLED;
+}
+
+static enum event_result
+parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
+{
+	const char *target;
+	const char *type;
+	char *endaddr;
+	u64 addr;
+	enum event_result err;
+
+	target = strchr(*strp, ':');
+	if (!target)
+		return EVT_FAILED;
+
+	if (strncmp(*strp, "mem", target - *strp) != 0)
+		return EVT_FAILED;
+
+	target++;
+
+	addr = strtoull(target, &endaddr, 0);
+	if (target == endaddr)
+		return EVT_FAILED;
+
+	attr->bp_addr = addr;
+	*strp = endaddr;
+
+	type = strchr(target, ':');
+
+	/* If no type is defined, just rw as default */
+	if (!type) {
+		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
+	} else {
+		err = parse_breakpoint_type(++type, strp, attr);
+		if (err == EVT_FAILED)
+			return EVT_FAILED;
+	}
+
+	/* We should find a nice way to override the access type */
+	attr->bp_len = HW_BREAKPOINT_LEN_4;
+	attr->type = PERF_TYPE_BREAKPOINT;
+
+	return EVT_HANDLED;
+}
+
 static int check_events(const char *str, unsigned int i)
 {
 	int n;
@@ -673,6 +748,10 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	ret = parse_breakpoint_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
 	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return EVT_FAILED;
@@ -859,6 +938,9 @@ void print_events(void)
 		"rNNN");
 	printf("\n");
 
+	printf("  %-42s [hardware breakpoint]\n", "mem:<addr>[:access]");
+	printf("\n");
+
 	print_tracepoint_events();
 
 	exit(129);
-- 
1.6.2.3

