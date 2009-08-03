Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZHCFJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZHCFJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZHCFJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:09:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:51615 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751867AbZHCFJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:09:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18T7kkpTg4T/vLvaBuQQcVjGtGJvSPCiIkGYEbNA9
	UXj2y6pieRbRvu
Subject: Re: [patch] perf tools: allow top users to switch between weighted
 and individual counter display
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090802200049.GF24486@elte.hu>
References: <1248422990.28486.3.camel@marge.simson.net>
	 <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net>
	 <20090802200049.GF24486@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 07:09:38 +0200
Message-Id: <1249276178.17959.67.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 22:00 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Fri, 2009-07-24 at 10:58 +0200, Peter Zijlstra wrote:
> > > On Fri, 2009-07-24 at 10:09 +0200, Mike Galbraith wrote:
> > > > (depends on last resurrect annotation patch)
> > > > 
> > > > perf_counter tools: allow top users to switch between weighted and individual counter display.
> > > > 
> > > > Add [w]eighted hotkey.  Pressing [w] toggles between displaying weighted total of all counters,
> > > > and the counter selected via [E]vent select key.
> > > 
> > > /me stuck it next to that other one, let see what happens ;-)
> > 
> > (plugs in Bitwolf-9000 charger)
> 
> seems to work well here.
> 
> A few minor comments:
> 
>  - I had to guess that '?' gets me a help screen. Might make sense 
>    to display a line at the bottom (?) to give some hints.
> 
>  - Once i was on the help screen, i expected either <Enter> or '?' 
>    to make it vanish. Only setting an option got rid of it - i 
>    suspect this should be improved. (Also, a line in the help screen 
>    that tells us how to go back without changing anything would be 
>    helpful as well.)

How about the below?

>  - I randomly tried the 's' option to do annotation. But it didnt do 
>    anything. Probably because i didnt start perf top via --vmlinux, 
>    right? This behavior is not intuitive in any case - it should 
>    probably display an error message at minimum - but if possible it 
>    should try to guess the position of the vmlinux file.

Guessing would require rebuilding symbols, and serialization for the
data acquisition thread, maybe something to do when/if top is made fully
interactive.  In the below, I just show what keys are available with the
provided command line options.

Not sure I like waiting for input at start though, maybe just display
and sleep a couple seconds would be friendlier.


perf_counter tools: improve perf top interactive key handling.

Display mapped keys and wait for input on startup to ensure that the user
knows which keys are available.  Change keypress handling such that current
vairable values are displayed, and pressing an unmapped key continues with
variables unchanged.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

 tools/perf/builtin-top.c |  109 +++++++++++++++++++++++++++++++---------------
 1 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4eef346..f463dc9 100644
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
 
@@ -705,6 +742,8 @@ static void *display_thread(void *arg __used)
 	tc.c_lflag &= ~(ICANON | ECHO);
 	tc.c_cc[VMIN] = 0;
 	tc.c_cc[VTIME] = 0;
+
+	handle_keypress(0);
 repeat:
 	delay_msecs = delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);


