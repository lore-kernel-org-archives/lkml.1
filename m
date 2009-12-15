Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbZLOPaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbZLOPaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZLOPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804AbZLOP20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:28:26 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 09/14] perf probe: Add glob matching support on --del
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:32:10 -0500
Message-ID: <20091215153210.17436.12327.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add glob-expression matching support on --del option.
You can use wildcards for specifying deleting events.
e.g.

 Clear all probe events:

 # perf probe --del '*'

 Clear probes on schedule():

 # perf probe --del 'schedule*'

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/probe-event.c |   52 +++++++++++++++++++++++++++++++----------
 tools/perf/util/string.c      |   25 ++++++++++++++++++++
 tools/perf/util/string.h      |    2 ++
 3 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index fa7e8e5..af7cc76 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -532,27 +532,51 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 	close(fd);
 }
 
+static void __del_trace_kprobe_event(int fd, struct str_node *ent)
+{
+	char *p;
+	char buf[128];
+
+	/* Convert from perf-probe event to trace-kprobe event */
+	if (e_snprintf(buf, 128, "-:%s", ent->s) < 0)
+		die("Failed to copy event.");
+	p = strchr(buf + 2, ':');
+	if (!p)
+		die("Internal error: %s should have ':' but not.", ent->s);
+	*p = '/';
+
+	write_trace_kprobe_event(fd, buf);
+	printf("Remove event: %s\n", ent->s);
+}
+
 static void del_trace_kprobe_event(int fd, const char *group,
 				   const char *event, struct strlist *namelist)
 {
 	char buf[128];
-	struct str_node *ent;
+	struct str_node *ent, *n;
+	int found = 0;
 
 	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
 		die("Failed to copy event.");
-	ent = strlist__find(namelist, buf);
-	if (!ent) {
+
+	if (strpbrk(buf, "*?")) { /* Glob-exp */
+		strlist__for_each_safe(ent, n, namelist)
+			if (strglobmatch(ent->s, buf)) {
+				found++;
+				__del_trace_kprobe_event(fd, ent);
+				strlist__remove(namelist, ent);
+			}
+	} else {
+		ent = strlist__find(namelist, buf);
+		if (ent) {
+			found++;
+			__del_trace_kprobe_event(fd, ent);
+			strlist__remove(namelist, ent);
+		}
+	}
+	if (found == 0)
 		pr_info("Info: event \"%s\" does not exist."
 			" Could not remove it.\n", buf);
-		return;
-	}
-	/* Convert from perf-probe event to trace-kprobe event */
-	if (e_snprintf(buf, 128, "-:%s/%s", group, event) < 0)
-		die("Failed to copy event.");
-
-	write_trace_kprobe_event(fd, buf);
-	printf("Remove event: %s:%s\n", group, event);
-	strlist__remove(namelist, ent);
 }
 
 void del_trace_kprobe_events(struct strlist *dellist)
@@ -571,15 +595,17 @@ void del_trace_kprobe_events(struct strlist *dellist)
 		str = strdup(ent->s);
 		if (!str)
 			die("Failed to copy event.");
+		pr_debug("Parsing: %s\n", str);
 		p = strchr(str, ':');
 		if (p) {
 			group = str;
 			*p = '\0';
 			event = p + 1;
 		} else {
-			group = PERFPROBE_GROUP;
+			group = "*";
 			event = str;
 		}
+		pr_debug("Group: %s, Event: %s\n", group, event);
 		del_trace_kprobe_event(fd, group, event, namelist);
 		free(str);
 	}
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index f24a8cc..5352d7d 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -226,3 +226,28 @@ fail:
 	argv_free(argv);
 	return NULL;
 }
+
+/* Glob expression pattern matching */
+bool strglobmatch(const char *str, const char *pat)
+{
+	while (*str && *pat && *pat != '*') {
+		if (*pat == '?') {
+			str++;
+			pat++;
+		} else
+			if (*str++ != *pat++)
+				return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (strglobmatch(str++, pat))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index bfecec2..02ede58 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_STRING_H_
 #define __PERF_STRING_H_
 
+#include <stdbool.h>
 #include "types.h"
 
 int hex2u64(const char *ptr, u64 *val);
@@ -8,6 +9,7 @@ char *strxfrchar(char *s, char from, char to);
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
+bool strglobmatch(const char *str, const char *pat);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
