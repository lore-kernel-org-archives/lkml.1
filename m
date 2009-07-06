Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZGFFmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZGFFmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZGFFlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:41:53 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49498 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZGFFlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g+nZah6Jn+MhUr2jzods9rprh8bF9Yxk0G6/DYdz+XFjDgyRew/6Breb+tUIYi7fhH
         wXULbuYIfLwrUpH6DdwWnTxlblrgE3EJ6BJWC8SOAeJxpZFcG/2fTl7gi0GnsBPE29tV
         axp3VpxH8VoGGpmtfIRDDVbFlNGJ83CHuu1Z4=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 01:41:54 -0400
Message-ID: <3fee128b0907052241k103df985g5d2222c72b6aa22d@mail.gmail.com>
Subject: [patch] perf_counter : add new parameter to set cpu affinity
From: Erdem Aktas <eaktas1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    new parameter to set cpu affinity
    when tracing the cache related performance counters, task migration
    might cause unpredicted cache events. We can use the cpu affinity to
    limit which cpus can be used to migrate the current task. I am
    suggesting -c parameter as in
    ./perf stat -c 1 -- ls -al
    ./perf stat -c 1,2 -- ls -al
    ./perf stat -c 1-3 -- ls -al

    Signed-off-by: eaktas <eaktas1@gmail.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 27921a8..f55923c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -37,6 +37,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */

+#define _GNU_SOURCE
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
@@ -45,6 +46,7 @@

 #include <sys/prctl.h>
 #include <math.h>
+#include <sched.h>

 static struct perf_counter_attr default_attrs[] = {

@@ -242,6 +244,10 @@ static int run_perf_stat(int argc __used, const
char **argv)
 		if (read(go_pipe[0], &buf, 1) == -1)
 			perror("unable to read pipe");

+		if (enableaffinity)
+			sched_setaffinity(pid, sizeof(affinity_mask),
+				&affinity_mask);
+
 		execvp(argv[0], (char **)argv);

 		perror(argv[0]);
@@ -504,6 +510,9 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
+	OPT_CALLBACK('c', "cpus", NULL, "n",
+		     "Set cpu affinity i.e: -c 1,3,5-8",
+		     set_cpu_affinity),
 	OPT_END()
 };

@@ -511,6 +520,7 @@ int cmd_stat(int argc, const char **argv, const
char *prefix __used)
 {
 	int status;

+  enableaffinity = 0;
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5184959..8a90117 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,4 +1,5 @@

+#define _GNU_SOURCE
 #include "../perf.h"
 #include "util.h"
 #include "parse-options.h"
@@ -9,6 +10,8 @@
 extern char *strcasestr(const char *haystack, const char *needle);

 int					nr_counters;
+cpu_set_t affinity_mask;
+int enableaffinity;

 struct perf_counter_attr		attrs[MAX_COUNTERS];

@@ -474,3 +477,49 @@ void print_events(void)

 	exit(129);
 }
+
+/*
+ * Set cpu affinity
+ * Sets which cpus this task can be assigned.
+ * usage can be 1   1,2   1,2,4-8
+ */
+int set_cpu_affinity(const struct option *opt, const char *str, int unset)
+{
+	char *str_dup, *token, *paramlist[30];
+	int paramcount = 0;
+
+	/*I need this dumy if statement, otherwise the compiler gives error */
+	if (opt == NULL && unset == 0) {
+	}
+	str_dup = strdup(str);
+	token = strtok(str_dup, ",");
+	CPU_ZERO(&affinity_mask);
+	while (token) {
+		paramlist[paramcount++] = token;
+		token = strtok(NULL, ",");
+	}
+	while (paramcount > 0) {
+		int number;
+
+		token = strtok(paramlist[--paramcount], "-");
+		number = -1;
+		while (token != NULL) {
+			if (number != -1) {
+				int number2;
+				number2 = atoi(token);
+				while (number < number2) {
+					CPU_SET(++number, &affinity_mask);
+				}
+			} else {
+				number = atoi(token);
+				CPU_SET(number, &affinity_mask);
+			}
+			token = strtok(NULL, "-");
+		}
+	}
+	free(str_dup);
+	enableaffinity = 1;
+	return 0;
+}
+
+
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e3d5529..c94f0ac 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -3,6 +3,12 @@
  * Parse symbolic events/counts passed in as options:
  */

+#include <sched.h>
+
+extern cpu_set_t affinity_mask;
+
+extern int			enableaffinity;
+
 extern int			nr_counters;

 extern struct perf_counter_attr attrs[MAX_COUNTERS];
@@ -15,3 +21,5 @@ extern int parse_events(const struct option *opt,
const char *str, int unset);

 extern void print_events(void);

+extern int set_cpu_affinity(const struct option *opt,
+						const char *str, int unset);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b4be607..6db141d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -44,6 +44,7 @@
 #define _XOPEN_SOURCE_EXTENDED 1 /* AIX 5.3L needs this */
 #endif
 #define _ALL_SOURCE 1
+#undef _GNU_SOURCE
 #define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
