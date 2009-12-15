Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZLOJkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZLOJkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZLOJkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:40:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:59163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZLOJkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:40:07 -0500
Date: Tue, 15 Dec 2009 09:39:33 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260867220-15699-2-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Add support for script args
Message-ID: <tip-586bc5cce88be993dad584c3936c49f945368551@git.kernel.org>
Git-Commit-ID: 586bc5cce88be993dad584c3936c49f945368551
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  586bc5cce88be993dad584c3936c49f945368551
Gitweb:     http://git.kernel.org/tip/586bc5cce88be993dad584c3936c49f945368551
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 15 Dec 2009 02:53:35 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:31:31 +0100

perf trace/scripting: Add support for script args

One oversight of the original scripting_ops patch was a lack of
support for passing args to handler scripts.  This adds
argc/argv to the start_script() scripting_op, and changes the
rw-by-file script to take 'comm' arg rather than the 'perf'
value currently hard-coded.  It also takes the opportunity to do
some related minor cleanup.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1260867220-15699-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c                    |   19 +++++--------
 tools/perf/scripts/perl/bin/rw-by-file-report |    2 +-
 tools/perf/scripts/perl/rw-by-file.pl         |    5 ++-
 tools/perf/util/trace-event-perl.c            |   36 ++++++++++++++++++-------
 tools/perf/util/trace-event.h                 |    2 +-
 5 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 07da665..88b0353 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -12,7 +12,9 @@
 static char const		*script_name;
 static char const		*generate_script_lang;
 
-static int default_start_script(const char *script __attribute((unused)))
+static int default_start_script(const char *script __unused,
+				int argc __unused,
+				const char **argv __unused)
 {
 	return 0;
 }
@@ -22,7 +24,7 @@ static int default_stop_script(void)
 	return 0;
 }
 
-static int default_generate_script(const char *outfile __attribute ((unused)))
+static int default_generate_script(const char *outfile __unused)
 {
 	return 0;
 }
@@ -302,15 +304,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_scripting();
 
-	argc = parse_options(argc, argv, options, annotate_usage, 0);
-	if (argc) {
-		/*
-		 * Special case: if there's an argument left then assume tha
-		 * it's a symbol filter:
-		 */
-		if (argc > 1)
-			usage_with_options(annotate_usage, options);
-	}
+	argc = parse_options(argc, argv, options, annotate_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
@@ -350,7 +345,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (script_name) {
-		err = scripting_ops->start_script(script_name);
+		err = scripting_ops->start_script(script_name, argc, argv);
 		if (err)
 			goto out;
 	}
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index f5dcf9c..1c05675 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl
+perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $1
 
 
 
diff --git a/tools/perf/scripts/perl/rw-by-file.pl b/tools/perf/scripts/perl/rw-by-file.pl
index 61f9156..2a39097 100644
--- a/tools/perf/scripts/perl/rw-by-file.pl
+++ b/tools/perf/scripts/perl/rw-by-file.pl
@@ -18,8 +18,9 @@ use lib "./Perf-Trace-Util/lib";
 use Perf::Trace::Core;
 use Perf::Trace::Util;
 
-# change this to the comm of the program you're interested in
-my $for_comm = "perf";
+my $usage = "perf trace -s rw-by-file.pl <comm>\n";
+
+my $for_comm = shift or die $usage;
 
 my %reads;
 my %writes;
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index a5ffe60..6f10e76 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -267,7 +267,7 @@ int common_lock_depth(struct scripting_context *context)
 }
 
 static void perl_process_event(int cpu, void *data,
-			       int size __attribute((unused)),
+			       int size __unused,
 			       unsigned long long nsecs, char *comm)
 {
 	struct format_field *field;
@@ -359,28 +359,42 @@ static void run_start_sub(void)
 /*
  * Start trace script
  */
-static int perl_start_script(const char *script)
+static int perl_start_script(const char *script, int argc, const char **argv)
 {
-	const char *command_line[2] = { "", NULL };
+	const char **command_line;
+	int i, err = 0;
 
+	command_line = malloc((argc + 2) * sizeof(const char *));
+	command_line[0] = "";
 	command_line[1] = script;
+	for (i = 2; i < argc + 2; i++)
+		command_line[i] = argv[i - 2];
 
 	my_perl = perl_alloc();
 	perl_construct(my_perl);
 
-	if (perl_parse(my_perl, xs_init, 2, (char **)command_line,
-		       (char **)NULL))
-		return -1;
+	if (perl_parse(my_perl, xs_init, argc + 2, (char **)command_line,
+		       (char **)NULL)) {
+		err = -1;
+		goto error;
+	}
 
 	perl_run(my_perl);
-	if (SvTRUE(ERRSV))
-		return -1;
+	if (SvTRUE(ERRSV)) {
+		err = -1;
+		goto error;
+	}
 
 	run_start_sub();
 
+	free(command_line);
 	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
-
 	return 0;
+error:
+	perl_free(my_perl);
+	free(command_line);
+
+	return err;
 }
 
 /*
@@ -579,7 +593,9 @@ static void print_unsupported_msg(void)
 		"\n  etc.\n");
 }
 
-static int perl_start_script_unsupported(const char *script __unused)
+static int perl_start_script_unsupported(const char *script __unused,
+					 int argc __unused,
+					 const char **argv __unused)
 {
 	print_unsupported_msg();
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 81698d5..6ad4056 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -270,7 +270,7 @@ enum trace_flag_type {
 
 struct scripting_ops {
 	const char *name;
-	int (*start_script) (const char *);
+	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
 	void (*process_event) (int cpu, void *data, int size,
 			       unsigned long long nsecs, char *comm);
