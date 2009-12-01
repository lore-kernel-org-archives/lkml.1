Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZLAAUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZLAAUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZLAAUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:20:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZLAAUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:20:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 7/9] perf probe: Add argv_split() from lib/argv_split.c
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 30 Nov 2009 19:20:05 -0500
Message-ID: <20091201002005.10235.55602.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add argv_split() ported from lib/argv_split.c to string.c and use it
in util/probe-event.c.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/util/probe-event.c |   55 ++++++----------------
 tools/perf/util/string.c      |  101 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/string.h      |    2 +
 3 files changed, 118 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7335a3b..e3a683a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -32,6 +32,7 @@
 
 #undef _GNU_SOURCE
 #include "event.h"
+#include "string.h"
 #include "debug.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
@@ -132,62 +133,36 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 /* Parse perf-probe event definition */
 int parse_perf_probe_event(const char *str, struct probe_point *pp)
 {
-	char *argv[MAX_PROBE_ARGS + 1];	/* probe + args */
+	char **argv;
 	int argc, i, need_dwarf = 0;
 
-	/* Separate arguments, similar to argv_split */
-	argc = 0;
-	do {
-		/* Skip separators */
-		while (isspace(*str))
-			str++;
-
-		/* Add an argument */
-		if (*str != '\0') {
-			const char *s = str;
-			/* Check the limit number of arguments */
-			if (argc == MAX_PROBE_ARGS + 1)
-				semantic_error("Too many arguments");
-
-			/* Skip the argument */
-			while (!isspace(*str) && *str != '\0')
-				str++;
-
-			/* Duplicate the argument */
-			argv[argc] = strndup(s, str - s);
-			if (argv[argc] == NULL)
-				die("strndup");
-			pr_debug("argv[%d]=%s\n", argc, argv[argc]);
-			argc++;
-		}
-	} while (*str != '\0');
-	if (!argc)
-		semantic_error("An empty argument.");
+	argv = argv_split(str, &argc);
+	if (!argv)
+		die("argv_split failed.");
+	if (argc > MAX_PROBE_ARGS + 1)
+		semantic_error("Too many arguments");
 
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
-	free(argv[0]);
 	if (pp->file || pp->line)
 		need_dwarf = 1;
 
-	/* Copy arguments */
+	/* Copy arguments and ensure return probe has no C argument */
 	pp->nr_args = argc - 1;
-	if (pp->nr_args > 0) {
-		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
-		if (!pp->args)
-			die("malloc");
-		memcpy(pp->args, &argv[1], sizeof(char *) * pp->nr_args);
-	}
-
-	/* Ensure return probe has no C argument */
-	for (i = 0; i < pp->nr_args; i++)
+	pp->args = zalloc(sizeof(char *) * pp->nr_args);
+	for (i = 0; i < pp->nr_args; i++) {
+		pp->args[i] = strdup(argv[i + 1]);
+		if (!pp->args[i])
+			die("Failed to copy argument.");
 		if (is_c_varname(pp->args[i])) {
 			if (pp->retprobe)
 				semantic_error("You can't specify local"
 						" variable for kretprobe");
 			need_dwarf = 1;
 		}
+	}
 
+	argv_free(argv);
 	return need_dwarf;
 }
 
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 2270435..0977cf4 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -127,3 +127,104 @@ out_err:
 out:
 	return length;
 }
+
+/*
+ * Helper function for splitting a string into an argv-like array.
+ * originaly copied from lib/argv_split.c
+ */
+static const char *skip_sep(const char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static const char *skip_arg(const char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static int count_argc(const char *str)
+{
+	int count = 0;
+
+	while (*str) {
+		str = skip_sep(str);
+		if (*str) {
+			count++;
+			str = skip_arg(str);
+		}
+	}
+
+	return count;
+}
+
+/**
+ * argv_free - free an argv
+ * @argv - the argument vector to be freed
+ *
+ * Frees an argv and the strings it points to.
+ */
+void argv_free(char **argv)
+{
+	char **p;
+	for (p = argv; *p; p++)
+		free(*p);
+
+	free(argv);
+}
+
+/**
+ * argv_split - split a string at whitespace, returning an argv
+ * @str: the string to be split
+ * @argcp: returned argument count
+ *
+ * Returns an array of pointers to strings which are split out from
+ * @str.  This is performed by strictly splitting on white-space; no
+ * quote processing is performed.  Multiple whitespace characters are
+ * considered to be a single argument separator.  The returned array
+ * is always NULL-terminated.  Returns NULL on memory allocation
+ * failure.
+ */
+char **argv_split(const char *str, int *argcp)
+{
+	int argc = count_argc(str);
+	char **argv = zalloc(sizeof(*argv) * (argc+1));
+	char **argvp;
+
+	if (argv == NULL)
+		goto out;
+
+	if (argcp)
+		*argcp = argc;
+
+	argvp = argv;
+
+	while (*str) {
+		str = skip_sep(str);
+
+		if (*str) {
+			const char *p = str;
+			char *t;
+
+			str = skip_arg(str);
+
+			t = strndup(p, str-p);
+			if (t == NULL)
+				goto fail;
+			*argvp++ = t;
+		}
+	}
+	*argvp = NULL;
+
+out:
+	return argv;
+
+fail:
+	argv_free(argv);
+	return NULL;
+}
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index e50b07f..bfecec2 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -6,6 +6,8 @@
 int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
 s64 perf_atoll(const char *str);
+char **argv_split(const char *str, int *argcp);
+void argv_free(char **argv);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
