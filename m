Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZITQOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZITQOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZITQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:14:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:50858 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZITQOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:14:37 -0400
Date: Sun, 20 Sep 2009 18:13:53 +0200
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, paulus@samba.org, ahpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH] perf timechart: Show the duration of scheduler delays in
 the SVG
Message-ID: <20090920181353.796f4509@linux.intel.com>
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

>From 04d386297c5ffb97a7fcea79cb3300359e4f5dcc Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 20:06:24 +0200
Subject: [PATCH] perf timechart: Show the duration of scheduler delays in the SVG

Given that scheduler latencies are the hot thing nowadays, show the
duration of said latencies in the SVG in text form.

In addition, if the latency is more than 10 msec, pick a brighter
yellow color as a way to point these long delays out.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/builtin-timechart.c |    6 ++--
 tools/perf/util/svghelper.c    |   56 +++++++++++++++++++++++++++++++++++++---
 tools/perf/util/svghelper.h    |    3 +-
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3f45b8b..23b3f09 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -827,15 +827,15 @@ static void draw_process_bars(void)
 				continue;
 			}
 
-			svg_box(Y, p->start_time, p->end_time, "process");
+			svg_box(Y, c->start_time, c->end_time, "process");
 			sample = c->samples;
 			while (sample) {
 				if (sample->type == TYPE_RUNNING)
-					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time, "sample");
+					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time);
 				if (sample->type == TYPE_BLOCKED)
 					svg_box(Y, sample->start_time, sample->end_time, "blocked");
 				if (sample->type == TYPE_WAITING)
-					svg_box(Y, sample->start_time, sample->end_time, "waiting");
+					svg_waiting(Y, sample->start_time, sample->end_time);
 				sample = sample->next;
 			}
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 9f70fa8..52f628f 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -69,7 +69,8 @@ void open_svg(const char *filename, int cpus, int rows)
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
-	fprintf(svgfile, "      rect.waiting  { fill:rgb(255,255,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(214,214,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
 	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
 	fprintf(svgfile, "      rect.c1       { fill:rgb(255,214,214); fill-opacity:0.5; stroke-width:0; } \n");
@@ -92,14 +93,14 @@ void svg_box(int Yslot, u64 start, u64 end, const char *type)
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
 }
 
-void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type)
+void svg_sample(int Yslot, int cpu, u64 start, u64 end)
 {
 	double text_size;
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
-		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"sample\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT);
 
 	text_size = (time2pixels(end)-time2pixels(start));
 	if (cpu > 9)
@@ -112,6 +113,53 @@ void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type)
 
 }
 
+static char *time_to_string(u64 duration)
+{
+	static char text[80];
+
+	text[0] = 0;
+
+	if (duration < 1000) /* less than 1 usec */
+		return text;
+
+	if (duration < 1000 * 1000) { /* less than 1 msec */
+		sprintf(text, "%4.1f us", duration / 1000.0);
+		return text;
+	}
+	sprintf(text, "%4.1f ms", duration / 1000.0 / 1000);
+
+	return text;
+}
+
+void svg_waiting(int Yslot, u64 start, u64 end)
+{
+	char *text;
+	const char *style;
+	double font_size;
+
+	if (!svgfile)
+		return;
+
+	style = "waiting";
+
+	if (end-start > 10 * 1000000) /* 10 msec */
+		style = "WAITING";
+
+	text = time_to_string(end-start);
+
+	font_size = 1.0 * (time2pixels(end)-time2pixels(start)) / strlen(text);
+
+	if (font_size > 0.2)
+		font_size = 0.2;
+
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, style);
+	if (font_size > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text transform=\"translate(%1.8f,%1.8f)\" font-size=\"%1.6fpt\">%s</text>\n",
+			time2pixels(start), Yslot * SLOT_MULT + 2, font_size, text);
+}
+
 static char *cpu_model(void)
 {
 	static char cpu_m[255];
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index 8260a7e..ed4ebcf 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -5,7 +5,8 @@
 
 extern void open_svg(const char *filename, int cpus, int rows);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
-extern void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type);
+extern void svg_sample(int Yslot, int cpu, u64 start, u64 end);
+extern void svg_waiting(int Yslot, u64 start, u64 end);
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
