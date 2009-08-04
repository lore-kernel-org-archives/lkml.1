Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZHDIVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZHDIVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZHDIVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:21:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:42008 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750958AbZHDIV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:21:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+iSmoXUqai1iIIYgKS/sj2p86M6wpXJSsGg6LXod
	Wd0PJsos4fSDOa
Subject: Re: [patch] perf tools: allow top users to switch between weighted
 and individual counter display
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1249276178.17959.67.camel@marge.simson.net>
References: <1248422990.28486.3.camel@marge.simson.net>
	 <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net>
	 <20090802200049.GF24486@elte.hu>
	 <1249276178.17959.67.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:21:23 +0200
Message-Id: <1249374083.10069.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 07:09 +0200, Mike Galbraith wrote:

> Not sure I like waiting for input at start though, maybe just display
> and sleep a couple seconds would be friendlier.

I find both really annoying, so just go straight into displaying.  That
kind of usage information belongs in the man page.  I've updated same to
reflect the current implementation, and will submit separately.

perf_counter tools:  improve perf top interactive key handling.

Pressing any key which is not currently mapped to functionality, based on
startup command line options, displays currently mapped keys, and prompts
for input.  Pressing any unmapped key at the prompt returns the user to
display mode with variables unchanged.  eg, pressing ? <SPACE> <ESC> etc
displays currently available keys, the value of the variable associated
with that key, and prompts.  Pressing same again aborts input.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |  108 +++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 35 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
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
 
@@ -705,6 +742,7 @@ static void *display_thread(void *arg __
 	tc.c_lflag &= ~(ICANON | ECHO);
 	tc.c_cc[VMIN] = 0;
 	tc.c_cc[VTIME] = 0;
+
 repeat:
 	delay_msecs = delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);


