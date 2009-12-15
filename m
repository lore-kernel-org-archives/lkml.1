Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZLOIyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZLOIyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZLOIyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:54:00 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46968 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039AbZLOIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mEjylwv/TSDZ1TrAs9AZ9TrOGK/0hT11mk/M82mDWM1FPvq0XGls6lm//4I1IHbG2U
         Dy6i/y4Hd1PBhanoFQPp+X3fzMQfPVycOyuOQDmgpS3CEAjIKzfPZ8Iqiu692R652pUv
         EzhcYM2KOGULfHhTvdFlZmxchiq7zirs7+fzo=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 5/6] perf trace/scripting: add 'record' and 'report' options
Date: Tue, 15 Dec 2009 02:53:39 -0600
Message-Id: <1260867220-15699-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow scripts to be recorded/executed by simply specifying the script
root name (the script name minus extension) along with 'record' or
'report' to 'perf trace'.

The script names shown by 'perf trace -l' can be directly used to run
the command-line contained within the corresponding '-record' and
'-report' versions of scripts in the scripts/*/bin directories.

For example, to record the trace data needed to run the
wakeup-latency.pl script, the user can easily find the name of the
corresponding script from the script list and invoke it using 'perf
trace record', without having to remember the details of how to do the
same thing using the lower-level perf trace command-line options:

root@tropicana:~# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  check-perf-trace                     useless but exhaustive test script
  rw-by-pid                            system-wide r/w activity

root@tropicana:~# perf trace record wakeup-latency
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.296 MB perf.data (~12931 samples) ]

To run the wakeup-latency.pl script using the captured data, change
'record' to 'report' in the command-line:

root@tropicana:~# perf trace report wakeup-latency

wakeup_latency stats:

total_wakeups: 65
avg_wakeup_latency (ns): 22417
min_wakeup_latency (ns): 3470
max_wakeup_latency (ns): 223311

perf trace Perl script stopped

If the script takes options, thay can be simply added to the end of
the 'report' invocation:

root@tropicana:~# perf trace record rw-by-file
^C[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 0.782 MB perf.data (~34171 samples) ]

root@tropicana:~# perf trace report rw-by-file perf

file read counts for perf:

    fd     # reads  bytes_requested
------  ----------  -----------
   122        1934     1980416
   120           1          32

file write counts for perf:

    fd    # writes  bytes_written
------  ----------  -----------
     3        4006      280568

perf trace Perl script stopped

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |   84 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5fb3bf..0543409 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -469,6 +469,49 @@ static int list_available_scripts(const struct option *opt __used,
 	exit(0);
 }
 
+static char *get_script_path(const char *script_root, const char *suffix)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	char script_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char lang_path[MAXPATHLEN];
+	char *str, *__script_root;
+	char *path = NULL;
+
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+
+	scripts_dir = opendir(scripts_path);
+	if (!scripts_dir)
+		return NULL;
+
+	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			 lang_dirent.d_name);
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_dir, script_dirent, script_next) {
+			__script_root = strdup(script_dirent.d_name);
+			str = ends_with(__script_root, suffix);
+			if (str) {
+				*str = '\0';
+				if (strcmp(__script_root, script_root))
+					continue;
+				snprintf(script_path, MAXPATHLEN, "%s/%s",
+					 lang_path, script_dirent.d_name);
+				path = strdup(script_path);
+				free(__script_root);
+				break;
+			}
+			free(__script_root);
+		}
+	}
+
+	return path;
+}
+
 static const char * const annotate_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
@@ -494,8 +537,47 @@ static const struct option options[] = {
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
-	int err;
 	struct perf_session *session;
+	const char *suffix = NULL;
+	const char **__argv;
+	char *script_path;
+	int i, err;
+
+	if (argc >= 2 && strncmp(argv[1], "rec", strlen("rec")) == 0) {
+		if (argc < 3) {
+			fprintf(stderr,
+				"Please specify a record script\n");
+			return -1;
+		}
+		suffix = RECORD_SUFFIX;
+	}
+
+	if (argc >= 2 && strncmp(argv[1], "rep", strlen("rep")) == 0) {
+		if (argc < 3) {
+			fprintf(stderr,
+				"Please specify a report script\n");
+			return -1;
+		}
+		suffix = REPORT_SUFFIX;
+	}
+
+	if (suffix) {
+		script_path = get_script_path(argv[2], suffix);
+		if (!script_path) {
+			fprintf(stderr, "script not found\n");
+			return -1;
+		}
+
+		__argv = malloc((argc + 1) * sizeof(const char *));
+		__argv[0] = "/bin/sh";
+		__argv[1] = script_path;
+		for (i = 3; i < argc; i++)
+			__argv[i - 1] = argv[i];
+		__argv[argc - 1] = NULL;
+
+		execvp("/bin/sh", (char **)__argv);
+		exit(-1);
+	}
 
 	symbol__init(0);
 
-- 
1.6.4.GIT

