Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbZLOT2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbZLOT2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933508AbZLOT2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:28:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:50958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933504AbZLOT2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:28:36 -0500
Date: Tue, 15 Dec 2009 19:26:40 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153210.17436.12327.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153210.17436.12327.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Add glob matching support on --del
Message-ID: <tip-bbbb521bc61008b280c72ad6e29a8a7558d3acfa@git.kernel.org>
Git-Commit-ID: bbbb521bc61008b280c72ad6e29a8a7558d3acfa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbbb521bc61008b280c72ad6e29a8a7558d3acfa
Gitweb:     http://git.kernel.org/tip/bbbb521bc61008b280c72ad6e29a8a7558d3acfa
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:32:10 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:03 +0100

perf probe: Add glob matching support on --del

Add glob-expression matching support on --del option.
You can use wildcards for specifying deleting events.
e.g.

 Clear all probe events:

 # perf probe --del '*'

 Clear probes on schedule():

 # perf probe --del 'schedule*'

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153210.17436.12327.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   52 ++++++++++++++++++++++++++++++----------
 tools/perf/util/string.c      |   25 +++++++++++++++++++
 tools/perf/util/string.h      |    2 +
 3 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3e30be9..5e99e52 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -532,26 +532,50 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
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
-		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
-		return;
-	}
-	/* Convert from perf-probe event to trace-kprobe event */
-	if (e_snprintf(buf, 128, "-:%s/%s", group, event) < 0)
-		die("Failed to copy event.");
 
-	write_trace_kprobe_event(fd, buf);
-	printf("Remove event: %s:%s\n", group, event);
-	strlist__remove(namelist, ent);
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
+		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
 }
 
 void del_trace_kprobe_events(struct strlist *dellist)
@@ -570,15 +594,17 @@ void del_trace_kprobe_events(struct strlist *dellist)
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
