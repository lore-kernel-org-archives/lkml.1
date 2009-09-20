Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZITQOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZITQOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZITQOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:14:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZITQOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:14:35 -0400
Date: Sun, 20 Sep 2009 18:13:28 +0200
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, paulus@samba.org, ahpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH] perf timechart: Show the name of the waker/wakee in
 timechart
Message-ID: <20090920181328.68baa978@linux.intel.com>
In-Reply-To: <20090920181248.464c9193@infradead.org>
References: <20090920181248.464c9193@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d1556e254839707ef701edf21ec8e8116137019 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 19:31:12 +0200
Subject: [PATCH] perf timechart: Show the name of the waker/wakee in timechart

Timechart currently shows thin green lines for sending or receiving wakeups.
This patch also prints (in a very small font) the name of the process that
is being woken/wakes up this process.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/builtin-timechart.c |   11 ++++++++---
 tools/perf/util/svghelper.c    |   28 +++++++++++++++++++++-------
 tools/perf/util/svghelper.h    |    2 +-
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 58d737e..3f45b8b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -752,6 +752,7 @@ static void draw_wakeups(void)
 	we = wake_events;
 	while (we) {
 		int from = 0, to = 0;
+		char *task_from = NULL, *task_to = NULL;
 
 		/* locate the column of the waker and wakee */
 		p = all_data;
@@ -760,10 +761,14 @@ static void draw_wakeups(void)
 				c = p->all;
 				while (c) {
 					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
-						if (p->pid == we->waker)
+						if (p->pid == we->waker) {
 							from = c->Y;
-						if (p->pid == we->wakee)
+							task_from = c->comm;
+						}
+						if (p->pid == we->wakee) {
 							to = c->Y;
+							task_to = c->comm;
+						}
 					}
 					c = c->next;
 				}
@@ -776,7 +781,7 @@ static void draw_wakeups(void)
 		else if (from && to && abs(from - to) == 1)
 			svg_wakeline(we->time, from, to);
 		else
-			svg_partial_wakeline(we->time, from, to);
+			svg_partial_wakeline(we->time, from, task_from, to, task_to);
 		we = we->next;
 	}
 }
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index b0fcecd..9f70fa8 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -242,7 +242,7 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 }
 
 
-void svg_partial_wakeline(u64 start, int row1, int row2)
+void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2)
 {
 	double height;
 
@@ -251,21 +251,35 @@ void svg_partial_wakeline(u64 start, int row1, int row2)
 
 
 	if (row1 < row2) {
-		if (row1)
+		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
-
-		if (row2)
+			if (desc2)
+				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &gt;</text>\n",
+					time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_HEIGHT/48, desc2);
+		}
+		if (row2) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
+			if (desc1)
+				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &gt;</text>\n",
+					time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32, desc1);
+		}
 	} else {
-		if (row2)
+		if (row2) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
-
-		if (row1)
+			if (desc1)
+				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &lt;</text>\n",
+					time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/48, desc1);
+		}
+		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
+			if (desc2)
+				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &lt;</text>\n",
+					time2pixels(start), row1 * SLOT_MULT - SLOT_HEIGHT/32, desc2);
+		}
 	}
 	height = row1 * SLOT_MULT;
 	if (row2 > row1)
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index ad79b5d..8260a7e 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -17,7 +17,7 @@ extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 extern void svg_time_grid(u64 start, u64 end);
 extern void svg_legenda(void);
 extern void svg_wakeline(u64 start, int row1, int row2);
-extern void svg_partial_wakeline(u64 start, int row1, int row2);
+extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2);
 extern void svg_interrupt(u64 start, int row);
 extern void svg_text(int Yslot, u64 start, const char *text);
 extern void svg_close(void);
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
