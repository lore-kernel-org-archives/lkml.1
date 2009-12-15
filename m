Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbZLOIzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbZLOIzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbZLOIyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:54:53 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53661 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZLOIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YBCiZ1mzV92BVCJJyI1RfSDuX7p99U+SoPDJ1PORDqeKDKxb5lt8NkXy0Ak8Mkx3qO
         bu0/wK+QS8tPNqZHKdnDqwUFeBv/GSenIb4Ozh2u+PizJAm77TCYWKcdFvQj/mzO9vpK
         AjkfJyD2BjJqIew+onfnEa1WcQjuhaBuzHPRQ=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 1/6] perf trace/scripting: add support for script args
Date: Tue, 15 Dec 2009 02:53:35 -0600
Message-Id: <1260867220-15699-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One oversight of the original scripting_ops patch was a lack of
support for passing args to handler scripts.  This adds argc/argv to
the start_script() scripting_op, and changes the rw-by-file script to
take 'comm' arg rather than the 'perf' value currently hard-coded.  It
also takes the opportunity to do some related minor cleanup.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c                    |   19 +++++--------
 tools/perf/scripts/perl/bin/rw-by-file-report |    2 +-
 tools/perf/scripts/perl/rw-by-file.pl         |    5 ++-
 tools/perf/util/trace-event-perl.c            |   36 ++++++++++++++++++-------
 tools/perf/util/trace-event.h                 |    2 +-
 5 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9ee976d..e60e35e 100644
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
-- 
1.6.4.GIT

