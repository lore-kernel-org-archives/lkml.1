Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZJWOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZJWOtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZJWOtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:49:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZJWOtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:49:24 -0400
Date: Fri, 23 Oct 2009 16:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091023144917.GA10856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (2):
      perf timechart: Fix the wakeup-arrows that point to non-visible processes
      perf timechart: Improve the visual appearance of scheduler delays

Ingo Molnar (1):
      perf tools: Bump version to 0.0.2

Paul Mackerras (1):
      perf_event: Adjust frequency and unthrottle for non-group-leader events

Tim Blechmann (1):
      perf top: Fix --delay_secs 0 division by zero


 kernel/perf_event.c              |    2 +-
 tools/perf/builtin-timechart.c   |   28 ++++++++++++++++++++++++++--
 tools/perf/builtin-top.c         |    2 ++
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 tools/perf/util/svghelper.c      |    2 +-
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9d0b5c6..afb7ef3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1355,7 +1355,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 702d8fe..e8a510d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -765,19 +765,40 @@ static void draw_wakeups(void)
 					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
 						if (p->pid == we->waker) {
 							from = c->Y;
-							task_from = c->comm;
+							task_from = strdup(c->comm);
 						}
 						if (p->pid == we->wakee) {
 							to = c->Y;
-							task_to = c->comm;
+							task_to = strdup(c->comm);
 						}
 					}
 					c = c->next;
 				}
+				c = p->all;
+				while (c) {
+					if (p->pid == we->waker && !from) {
+						from = c->Y;
+						task_from = strdup(c->comm);
+					}
+					if (p->pid == we->wakee && !to) {
+						to = c->Y;
+						task_to = strdup(c->comm);
+					}
+					c = c->next;
+				}
 			}
 			p = p->next;
 		}
 
+		if (!task_from) {
+			task_from = malloc(40);
+			sprintf(task_from, "[%i]", we->waker);
+		}
+		if (!task_to) {
+			task_to = malloc(40);
+			sprintf(task_to, "[%i]", we->wakee);
+		}
+
 		if (we->waker == -1)
 			svg_interrupt(we->time, to);
 		else if (from && to && abs(from - to) == 1)
@@ -785,6 +806,9 @@ static void draw_wakeups(void)
 		else
 			svg_partial_wakeline(we->time, from, task_from, to, task_to);
 		we = we->next;
+
+		free(task_from);
+		free(task_to);
 	}
 }
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 37512e9..a1b1d10 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -686,6 +686,8 @@ static void handle_keypress(int c)
 	switch (c) {
 		case 'd':
 			prompt_integer(&delay_secs, "Enter display delay");
+			if (delay_secs < 1)
+				delay_secs = 1;
 			break;
 		case 'e':
 			prompt_integer(&print_entries, "Enter display entries (lines)");
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index c561d15..54552a0 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=PERF-VERSION-FILE
-DEF_VER=v0.0.1.PERF
+DEF_VER=v0.0.2.PERF
 
 LF='
 '
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 856655d..b3637db 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -103,7 +103,7 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
-	fprintf(svgfile, "      rect.waiting  { fill:rgb(214,214,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
 	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
