Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZLGHLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZLGHLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbZLGHLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:11:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:58327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbZLGHLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:11:13 -0500
Date: Mon, 7 Dec 2009 07:10:30 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260163919-6679-3-git-send-email-tzanussi@gmail.com>
References: <1260163919-6679-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Don't display 'scripting unsupported' msg unnecessarily
Message-ID: <tip-67a6259ec97b8408f86f2fe8459d2233f0b0987d@git.kernel.org>
Git-Commit-ID: 67a6259ec97b8408f86f2fe8459d2233f0b0987d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67a6259ec97b8408f86f2fe8459d2233f0b0987d
Gitweb:     http://git.kernel.org/tip/67a6259ec97b8408f86f2fe8459d2233f0b0987d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sun, 6 Dec 2009 23:31:59 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 08:05:07 +0100

perf trace/scripting: Don't display 'scripting unsupported' msg unnecessarily

The 'scripting unsupported' message should only be displayed
when the -s or -g options are used, and not when they aren't, as
the current code does.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: rostedt@goodmis.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1260163919-6679-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-perl.c |   64 +++++++++++++++++++++++++++++++-----
 1 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 59564b2..a5ffe60 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -570,26 +570,72 @@ struct scripting_ops perl_scripting_ops = {
 	.generate_script = perl_generate_script,
 };
 
-#ifdef NO_LIBPERL
-void setup_perl_scripting(void)
+static void print_unsupported_msg(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl and rebuild perf to enable it.  e.g. "
-		"apt-get install libperl-dev (ubuntu), yum install "
-		"perl-ExtUtils-Embed (Fedora), etc.\n");
+		"  Install libperl and rebuild perf to enable it.\n"
+		"For example:\n  # apt-get install libperl-dev (ubuntu)"
+		"\n  # yum install perl-ExtUtils-Embed (Fedora)"
+		"\n  etc.\n");
 }
-#else
-void setup_perl_scripting(void)
+
+static int perl_start_script_unsupported(const char *script __unused)
+{
+	print_unsupported_msg();
+
+	return -1;
+}
+
+static int perl_stop_script_unsupported(void)
+{
+	return 0;
+}
+
+static void perl_process_event_unsupported(int cpu __unused,
+					   void *data __unused,
+					   int size __unused,
+					   unsigned long long nsecs __unused,
+					   char *comm __unused)
+{
+}
+
+static int perl_generate_script_unsupported(const char *outfile __unused)
+{
+	print_unsupported_msg();
+
+	return -1;
+}
+
+struct scripting_ops perl_scripting_unsupported_ops = {
+	.name = "Perl",
+	.start_script = perl_start_script_unsupported,
+	.stop_script = perl_stop_script_unsupported,
+	.process_event = perl_process_event_unsupported,
+	.generate_script = perl_generate_script_unsupported,
+};
+
+static void register_perl_scripting(struct scripting_ops *scripting_ops)
 {
 	int err;
-	err = script_spec_register("Perl", &perl_scripting_ops);
+	err = script_spec_register("Perl", scripting_ops);
 	if (err)
 		die("error registering Perl script extension");
 
-	err = script_spec_register("pl", &perl_scripting_ops);
+	err = script_spec_register("pl", scripting_ops);
 	if (err)
 		die("error registering pl script extension");
 
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
+
+#ifdef NO_LIBPERL
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_unsupported_ops);
+}
+#else
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_ops);
+}
 #endif
