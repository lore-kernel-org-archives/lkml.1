Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZHDLho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZHDLho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZHDLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:37:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:44837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbZHDLhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:37:42 -0400
Date: Tue, 4 Aug 2009 11:36:54 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249374083.10069.18.camel@marge.simson.net>
References: <1249374083.10069.18.camel@marge.simson.net>
Subject: [tip:perfcounters/core] perf top: Improve interactive key handling
Message-ID: <tip-0aafe6d2af76ea03501683d7d972edd0018878be@git.kernel.org>
Git-Commit-ID: 0aafe6d2af76ea03501683d7d972edd0018878be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 11:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0aafe6d2af76ea03501683d7d972edd0018878be
Gitweb:     http://git.kernel.org/tip/0aafe6d2af76ea03501683d7d972edd0018878be
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 4 Aug 2009 10:21:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 10:35:18 +0200

perf top: Improve interactive key handling

Pressing any key which is not currently mapped to
functionality, based on startup command line options, displays
currently mapped keys, and prompts for input.

Pressing any unmapped key at the prompt returns the user to
display mode with variables unchanged.  eg, pressing ? <SPACE>
<ESC> etc displays currently available keys, the value of the
variable associated with that key, and prompts.

Pressing same again aborts input.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1249374083.10069.18.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |  108 +++++++++++++++++++++++++++++++---------------
 1 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4eef346..7de28ce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -595,25 +595,84 @@ out_free:
 	free(buf);
 }
 
-static void print_known_keys(void)
+static void print_mapped_keys(void)
 {
-	fprintf(stdout, "\nknown keys:\n");
-	fprintf(stdout, "\t[d]     select display delay.\n");
-	fprintf(stdout, "\t[e]     select display entries (lines).\n");
-	fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_counter));
-	fprintf(stdout, "\t[f]     select normal display count filter.\n");
-	fprintf(stdout, "\t[F]     select annotation display count filter (percentage).\n");
-	fprintf(stdout, "\t[qQ]    quit.\n");
-	fprintf(stdout, "\t[s]     select annotation symbol and start annotation.\n");
-	fprintf(stdout, "\t[S]     stop annotation, revert to normal display.\n");
-	fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
+	char *name = NULL;
+
+	if (sym_filter_entry) {
+		struct symbol *sym = (struct symbol *)(sym_filter_entry+1);
+		name = sym->name;
+	}
+
+	fprintf(stdout, "\nMapped keys:\n");
+	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", delay_secs);
+	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
+
+	if (nr_counters > 1)
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_counter));
+
+	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
+
+	if (vmlinux) {
+		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
+		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
+		fprintf(stdout, "\t[S]     stop annotation.\n");
+	}
+
+	if (nr_counters > 1)
+		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
+
 	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", zero ? 1 : 0);
+	fprintf(stdout, "\t[qQ]    quit.\n");
+}
+
+static int key_mapped(int c)
+{
+	switch (c) {
+		case 'd':
+		case 'e':
+		case 'f':
+		case 'z':
+		case 'q':
+		case 'Q':
+			return 1;
+		case 'E':
+		case 'w':
+			return nr_counters > 1 ? 1 : 0;
+		case 'F':
+		case 's':
+		case 'S':
+			return vmlinux ? 1 : 0;
+	}
+
+	return 0;
 }
 
 static void handle_keypress(int c)
 {
-	int once = 0;
-repeat:
+	if (!key_mapped(c)) {
+		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
+		struct termios tc, save;
+
+		print_mapped_keys();
+		fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
+		fflush(stdout);
+
+		tcgetattr(0, &save);
+		tc = save;
+		tc.c_lflag &= ~(ICANON | ECHO);
+		tc.c_cc[VMIN] = 0;
+		tc.c_cc[VTIME] = 0;
+		tcsetattr(0, TCSANOW, &tc);
+
+		poll(&stdin_poll, 1, -1);
+		c = getc(stdin);
+
+		tcsetattr(0, TCSAFLUSH, &save);
+		if (!key_mapped(c))
+			return;
+	}
+
 	switch (c) {
 		case 'd':
 			prompt_integer(&delay_secs, "Enter display delay");
@@ -669,28 +728,6 @@ repeat:
 		case 'z':
 			zero = ~zero;
 			break;
-		default: {
-			struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-			struct termios tc, save;
-
-			if (!once) {
-				print_known_keys();
-				once++;
-			}
-
-			tcgetattr(0, &save);
-			tc = save;
-			tc.c_lflag &= ~(ICANON | ECHO);
-			tc.c_cc[VMIN] = 0;
-			tc.c_cc[VTIME] = 0;
-			tcsetattr(0, TCSANOW, &tc);
-
-			poll(&stdin_poll, 1, -1);
-			c = getc(stdin);
-
-			tcsetattr(0, TCSAFLUSH, &save);
-			goto repeat;
-		}
 	}
 }
 
@@ -705,6 +742,7 @@ static void *display_thread(void *arg __used)
 	tc.c_lflag &= ~(ICANON | ECHO);
 	tc.c_cc[VMIN] = 0;
 	tc.c_cc[VTIME] = 0;
+
 repeat:
 	delay_msecs = delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);
