Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZLOJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZLOJk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbZLOJkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:40:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbZLOJkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:40:47 -0500
Date: Tue, 15 Dec 2009 09:40:15 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260867220-15699-5-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-5-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: List available scripts
Message-ID: <tip-4b9c0c596ea826ef784eb83f663c5351ed01ba6d@git.kernel.org>
Git-Commit-ID: 4b9c0c596ea826ef784eb83f663c5351ed01ba6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b9c0c596ea826ef784eb83f663c5351ed01ba6d
Gitweb:     http://git.kernel.org/tip/4b9c0c596ea826ef784eb83f663c5351ed01ba6d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 15 Dec 2009 02:53:38 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:31:32 +0100

perf trace/scripting: List available scripts

Lists the available perf trace scripts, one per line e.g.:

root@tropicana:~# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  check-perf-trace                     useless but exhaustive test script
  rw-by-pid                            system-wide r/w activity

To be consistent with the other listing options in perf, the
current latency trace option was changed to '-L', and '-l' is
now used to access the script listing as:

To create the list, it searches each scripts/*/bin directory for
files ending with "-report" and reads information found in
certain comment lines contained in those shell scripts:

  - if the comment line starts with "description:", the rest of the
    line is used as a 'half-line' description.  To keep each line in
    the list to a single line, the description should be limited to 40
    characters (the rest of the line contains the script name and
    args)

  - if the comment line starts with "args:", the rest of the line
    names the args the script supports.  Required args should be
    surrounded by <> brackets, optional args by [] brackets.

The current scripts in scripts/perl/bin have also been updated
with description: and args: comments.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1260867220-15699-5-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c                         |  199 +++++++++++++++++++-
 .../perf/scripts/perl/bin/check-perf-trace-report  |    1 +
 tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    1 +
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    1 +
 tools/perf/scripts/perl/bin/workqueue-stats-report |    1 +
 6 files changed, 204 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 88b0353..7674153 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -274,6 +274,201 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
+#define for_each_lang(scripts_dir, lang_dirent, lang_next)		\
+	while (!readdir_r(scripts_dir, &lang_dirent, &lang_next) &&	\
+	       lang_next)						\
+		if (lang_dirent.d_type == DT_DIR &&			\
+		    (strcmp(lang_dirent.d_name, ".")) &&		\
+		    (strcmp(lang_dirent.d_name, "..")))
+
+#define for_each_script(lang_dir, script_dirent, script_next)		\
+	while (!readdir_r(lang_dir, &script_dirent, &script_next) &&	\
+	       script_next)						\
+		if (script_dirent.d_type != DT_DIR)
+
+
+#define RECORD_SUFFIX			"-record"
+#define REPORT_SUFFIX			"-report"
+
+struct script_desc {
+	struct list_head	node;
+	char			*name;
+	char			*half_liner;
+	char			*args;
+};
+
+LIST_HEAD(script_descs);
+
+static struct script_desc *script_desc__new(const char *name)
+{
+	struct script_desc *s = zalloc(sizeof(*s));
+
+	if (s != NULL)
+		s->name = strdup(name);
+
+	return s;
+}
+
+static void script_desc__delete(struct script_desc *s)
+{
+	free(s->name);
+	free(s);
+}
+
+static void script_desc__add(struct script_desc *s)
+{
+	list_add_tail(&s->node, &script_descs);
+}
+
+static struct script_desc *script_desc__find(const char *name)
+{
+	struct script_desc *s;
+
+	list_for_each_entry(s, &script_descs, node)
+		if (strcasecmp(s->name, name) == 0)
+			return s;
+	return NULL;
+}
+
+static struct script_desc *script_desc__findnew(const char *name)
+{
+	struct script_desc *s = script_desc__find(name);
+
+	if (s)
+		return s;
+
+	s = script_desc__new(name);
+	if (!s)
+		goto out_delete_desc;
+
+	script_desc__add(s);
+
+	return s;
+
+out_delete_desc:
+	script_desc__delete(s);
+
+	return NULL;
+}
+
+static char *ends_with(char *str, const char *suffix)
+{
+	size_t suffix_len = strlen(suffix);
+	char *p = str;
+
+	if (strlen(str) > suffix_len) {
+		p = str + strlen(str) - suffix_len;
+		if (!strncmp(p, suffix, suffix_len))
+			return p;
+	}
+
+	return NULL;
+}
+
+static char *ltrim(char *str)
+{
+	int len = strlen(str);
+
+	while (len && isspace(*str)) {
+		len--;
+		str++;
+	}
+
+	return str;
+}
+
+static int read_script_info(struct script_desc *desc, const char *filename)
+{
+	char line[BUFSIZ], *p;
+	FILE *fp;
+
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	while (fgets(line, sizeof(line), fp)) {
+		p = ltrim(line);
+		if (strlen(p) == 0)
+			continue;
+		if (*p != '#')
+			continue;
+		p++;
+		if (strlen(p) && *p == '!')
+			continue;
+
+		p = ltrim(p);
+		if (strlen(p) && p[strlen(p) - 1] == '\n')
+			p[strlen(p) - 1] = '\0';
+
+		if (!strncmp(p, "description:", strlen("description:"))) {
+			p += strlen("description:");
+			desc->half_liner = strdup(ltrim(p));
+			continue;
+		}
+
+		if (!strncmp(p, "args:", strlen("args:"))) {
+			p += strlen("args:");
+			desc->args = strdup(ltrim(p));
+			continue;
+		}
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
+static int list_available_scripts(const struct option *opt __used,
+				  const char *s __used, int unset __used)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char script_path[MAXPATHLEN];
+	char lang_path[MAXPATHLEN];
+	struct script_desc *desc;
+	char first_half[BUFSIZ];
+	char *script_root;
+	char *str;
+
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+
+	scripts_dir = opendir(scripts_path);
+	if (!scripts_dir)
+		return -1;
+
+	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			 lang_dirent.d_name);
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_dir, script_dirent, script_next) {
+			script_root = strdup(script_dirent.d_name);
+			str = ends_with(script_root, REPORT_SUFFIX);
+			if (str) {
+				*str = '\0';
+				desc = script_desc__findnew(script_root);
+				snprintf(script_path, MAXPATHLEN, "%s/%s",
+					 lang_path, script_dirent.d_name);
+				read_script_info(desc, script_path);
+			}
+			free(script_root);
+		}
+	}
+
+	fprintf(stdout, "List of available trace scripts:\n");
+	list_for_each_entry(desc, &script_descs, node) {
+		sprintf(first_half, "%s %s", desc->name,
+			desc->args ? desc->args : "");
+		fprintf(stdout, "  %-36s %s\n", first_half,
+			desc->half_liner ? desc->half_liner : "");
+	}
+
+	exit(0);
+}
+
 static const char * const annotate_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
@@ -284,8 +479,10 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('l', "latency", &latency_format,
+	OPT_BOOLEAN('L', "Latency", &latency_format,
 		    "show latency attributes (irqs/preemption disabled, etc)"),
+	OPT_CALLBACK_NOOPT('l', "list", NULL, NULL, "list available scripts",
+			   list_available_scripts),
 	OPT_CALLBACK('s', "script", NULL, "name",
 		     "script file name (lang:script name, script name, or *)",
 		     parse_scriptname),
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-report b/tools/perf/scripts/perl/bin/check-perf-trace-report
index 89948b0..7fc4a03 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-report
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: useless but exhaustive test script
 perf trace -s ~/libexec/perf-core/scripts/perl/check-perf-trace.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index 1c05675..eddb9cc 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -1,4 +1,6 @@
 #!/bin/bash
+# description: r/w activity for a program, by file
+# args: <comm>
 perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $1
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index cea16f7..7f44c25 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: system-wide r/w activity
 perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index 85769dc..fce3adc 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: system-wide min/max/avg wakeup latency
 perf trace -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index aa68435..71cfbd1 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: workqueue stats (ins/exe/create/destroy)
 perf trace -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
 
 
