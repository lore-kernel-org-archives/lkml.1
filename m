Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0CCHFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:05:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41733 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0CCHFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GqagkrQUm7C/W9Su0k7SCf1vl3eSOXX4mBhzSYyl3r8oLMWHh3QoonyjxkDWYfJKCY
         J6byq49h3ZcV7Lq8aQDW6h/jvZmPsQ2//rQD8U1cJUzbfQlu/sBr7830ufZf+X72C6ea
         XAElywGxC1GAJFdx/IPR6bws5R9Q7UHmRrF1Y=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 1/7] perf: introduce special handling for pipe input/output
Date: Wed,  3 Mar 2010 01:05:23 -0600
Message-Id: <1267599929-8310-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds special treatment for stdin/stdout - if the user specifies '-o -'
to perf record or '-i -' to perf report et al, the intent is that the
event stream be written to stdout or read from stdin rather than a
disk file.

This initial patch just handles parsing the cmdline for those modes
and setting a couple variables to be used by the code in later
patches.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |   10 ++++++++--
 tools/perf/builtin-report.c |    3 ++-
 tools/perf/util/session.c   |   10 ++++++++++
 tools/perf/util/session.h   |    1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..4fe87e3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,6 +35,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 static int			freq				=   1000;
 static int			output;
+static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static unsigned int		realtime_prio			=      0;
@@ -431,7 +432,9 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!stat(output_name, &st) && st.st_size) {
+	if (!strcmp(output_name, "-"))
+		pipe_output = 1;
+	else if (!stat(output_name, &st) && st.st_size) {
 		if (!force) {
 			if (!append_file) {
 				pr_err("Error, output file %s exists, use -A "
@@ -456,7 +459,10 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		flags |= O_TRUNC;
 
-	output = open(output_name, flags, S_IRUSR|S_IWUSR);
+	if (pipe_output)
+		output = STDOUT_FILENO;
+	else
+		output = open(output_name, flags, S_IRUSR | S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cfc655d..ca12efa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -359,7 +359,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	setup_pager();
+	if (strcmp(input_name, "-") != 0)
+		setup_pager();
 
 	if (symbol__init() < 0)
 		return -1;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0de7258..dd1e923 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,16 @@ static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
 
+	if (!strcmp(self->filename, "-")) {
+		self->fd_pipe = true;
+		self->fd = STDIN_FILENO;
+
+		if (perf_header__read(&self->header, self->fd) < 0)
+			pr_err("incompatible file format");
+
+		return 0;
+	}
+
 	self->fd = open(self->filename, O_RDONLY);
 	if (self->fd < 0) {
 		pr_err("failed to open file: %s", self->filename);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 31950fc..dbfb74a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -26,6 +26,7 @@ struct perf_session {
 	u64			sample_type;
 	struct ref_reloc_sym	ref_reloc_sym;
 	int			fd;
+	bool			fd_pipe;
 	int			cwdlen;
 	char			*cwd;
 	char filename[0];
-- 
1.6.4.GIT

