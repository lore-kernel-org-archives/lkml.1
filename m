Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZKQGcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZKQGcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZKQGcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:32:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:58549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbZKQGc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:32:29 -0500
Date: Tue, 17 Nov 2009 06:31:53 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258407027-384-2-git-send-email-acme@infradead.org>
References: <1258407027-384-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use all the lines in the screen
Message-ID: <tip-3b6ed98895b0fccd8c387f3fc44016fb922c0658@git.kernel.org>
Git-Commit-ID: 3b6ed98895b0fccd8c387f3fc44016fb922c0658
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b6ed98895b0fccd8c387f3fc44016fb922c0658
Gitweb:     http://git.kernel.org/tip/3b6ed98895b0fccd8c387f3fc44016fb922c0658
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 19:30:27 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:53 +0100

perf top: Use all the lines in the screen

By querying the current number of rows, if the user specifies
the number of entries, use that instead. If the user uses the
'e' command to change the number of lines 0 will mean do it
automatically, any other number disables the auto resizing.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258407027-384-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6613f98..3af9520 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -60,7 +60,7 @@ static int			system_wide			=      0;
 static int			default_interval		=      0;
 
 static int			count_filter			=      5;
-static int			print_entries			=     15;
+static int			print_entries;
 
 static int			target_pid			=     -1;
 static int			inherit				=      0;
@@ -115,6 +115,36 @@ struct sym_entry {
  * Source functions
  */
 
+/* most GUI terminals set LINES (although some don't export it) */
+static int term_rows(void)
+{
+	char *lines_string = getenv("LINES");
+	int n_lines;
+
+	if (lines_string && (n_lines = atoi(lines_string)) > 0)
+		return n_lines;
+#ifdef TIOCGWINSZ
+	else {
+		struct winsize ws;
+		if (!ioctl(1, TIOCGWINSZ, &ws) && ws.ws_row)
+			return ws.ws_row;
+	}
+#endif
+	return 25;
+}
+
+static void update_print_entries(void)
+{
+	print_entries = term_rows();
+	if (print_entries > 9)
+		print_entries -= 9;
+}
+
+static void sig_winch_handler(int sig __used)
+{
+	update_print_entries();
+}
+
 static void parse_source(struct sym_entry *syme)
 {
 	struct symbol *sym;
@@ -668,6 +698,11 @@ static void handle_keypress(int c)
 			break;
 		case 'e':
 			prompt_integer(&print_entries, "Enter display entries (lines)");
+			if (print_entries == 0) {
+				update_print_entries();
+				signal(SIGWINCH, sig_winch_handler);
+			} else
+				signal(SIGWINCH, SIG_DFL);
 			break;
 		case 'E':
 			if (nr_counters > 1) {
@@ -1228,5 +1263,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (target_pid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 
+	if (print_entries == 0) {
+		update_print_entries();
+		signal(SIGWINCH, sig_winch_handler);
+	}
+
 	return __cmd_top();
 }
