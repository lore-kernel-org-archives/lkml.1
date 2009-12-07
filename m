Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLGFc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLGFc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZLGFcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:32:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52642 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZLGFcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ef4F9hKA4wT9asV9H0eqaxXpVWQ0IZH97umxmbD9YjxopZgeHcTwhVC9ZcV34b0mTo
         pu6yZapL09ARSNp1ZN0wxPKOTOOVb63fV9VKkOfEnIGWiboPN5cN6yGOgYjBhFySkuUS
         /91ROeH8MnJcql6KjCNiffthFzd3vfHt7LeRo=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [PATCH 2/2] perf trace/scripting: Don't display 'scripting unsupported' msg unnecessarily
Date: Sun,  6 Dec 2009 23:31:59 -0600
Message-Id: <1260163919-6679-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'scripting unsupported' message should only be displayed when the
-s or -g options are used, and not when they aren't, as the current
code does.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
-- 
1.6.4.GIT

