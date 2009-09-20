Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZITRli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZITRli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZITRlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:41:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:49564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbZITRle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:41:34 -0400
Date: Sun, 20 Sep 2009 17:40:56 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090920181438.3a49cb93@linux.intel.com>
References: <20090920181438.3a49cb93@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf util: SVG performance improvements
Message-ID: <tip-611a546bec3e1af2a87af0862398fc711dc47aef@git.kernel.org>
Git-Commit-ID: 611a546bec3e1af2a87af0862398fc711dc47aef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 17:41:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  611a546bec3e1af2a87af0862398fc711dc47aef
Gitweb:     http://git.kernel.org/tip/611a546bec3e1af2a87af0862398fc711dc47aef
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 20 Sep 2009 18:14:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 19:37:36 +0200

perf util: SVG performance improvements

Tweak the output SVG to increase performance in SVG viewers by
limiting the different types of font sizes and by smarter
transformations on the text.

At least with Inkscape this gives a notable performance improvement
during zoom and scrolling.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090920181438.3a49cb93@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/svghelper.c |   78 ++++++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index be1555e..a778fd0 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -51,6 +51,25 @@ static double time2pixels(u64 time)
 	return X;
 }
 
+/*
+ * Round text sizes so that the svg viewer only needs a discrete
+ * number of renderings of the font
+ */
+static double round_text_size(double size)
+{
+	int loop = 100;
+	double target = 10.0;
+
+	if (size >= 10.0)
+		return size;
+	while (loop--) {
+		if (size >= target)
+			return target;
+		target = target / 2.0;
+	}
+	return size;
+}
+
 void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 {
 	int new_width;
@@ -122,8 +141,10 @@ void svg_sample(int Yslot, int cpu, u64 start, u64 end)
 		text_size = text_size/2;
 	if (text_size > 1.25)
 		text_size = 1.25;
+	text_size = round_text_size(text_size);
+
 	if (text_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"translate(%1.8f,%1.8f)\" font-size=\"%1.6fpt\">%i</text>\n",
+		fprintf(svgfile, "<text x=\"%1.8f\" y=\"%1.8f\" font-size=\"%1.8fpt\">%i</text>\n",
 			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
 
 }
@@ -162,17 +183,20 @@ void svg_waiting(int Yslot, u64 start, u64 end)
 
 	text = time_to_string(end-start);
 
-	font_size = 1.0 * (time2pixels(end)-time2pixels(start)) / strlen(text);
+	font_size = 1.0 * (time2pixels(end)-time2pixels(start));
 
-	if (font_size > 0.2)
-		font_size = 0.2;
+	if (font_size > 3)
+		font_size = 3;
 
+	font_size = round_text_size(font_size);
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
-		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, style);
+	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
+	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(end)-time2pixels(start), SLOT_HEIGHT, style);
 	if (font_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"translate(%1.8f,%1.8f)\" font-size=\"%1.6fpt\">%s</text>\n",
-			time2pixels(start), Yslot * SLOT_MULT + 2, font_size, text);
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%1.8fpt\"> %s</text>\n",
+			font_size, text);
+	fprintf(svgfile, "</g>\n");
 }
 
 static char *cpu_model(void)
@@ -211,7 +235,7 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
 	sprintf(cpu_string, "CPU %i", (int)cpu+1);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
 	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
@@ -225,15 +249,21 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
-		time2pixels(start), time2pixels(end)-time2pixels(start), cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT, type);
+
+	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
+	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(end)-time2pixels(start), SLOT_MULT+SLOT_HEIGHT, type);
 	width = time2pixels(end)-time2pixels(start);
 	if (width > 6)
 		width = 6;
 
+	width = round_text_size(width);
+
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">%s</text>\n",
-			time2pixels(start), cpu2y(cpu), width, name);
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%3.8fpt\">%s</text>\n",
+			width, name);
+
+	fprintf(svgfile, "</g>\n");
 }
 
 void svg_cstate(int cpu, u64 start, u64 end, int type)
@@ -254,13 +284,15 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 		time2pixels(start), time2pixels(end)-time2pixels(start),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
-	width = time2pixels(end)-time2pixels(start);
+	width = (time2pixels(end)-time2pixels(start))/2.0;
 	if (width > 6)
 		width = 6;
 
+	width = round_text_size(width);
+
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">C%i</text>\n",
-			time2pixels(start), cpu2y(cpu), width, type);
+		fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"%3.8fpt\">C%i</text>\n",
+			time2pixels(start), cpu2y(cpu)+width, width, type);
 }
 
 static char *HzToHuman(unsigned long hz)
@@ -299,7 +331,7 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
 	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
 		time2pixels(start), time2pixels(end), height, height);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"0.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"0.25pt\">%s</text>\n",
 		time2pixels(start), height+0.9, HzToHuman(freq));
 
 }
@@ -318,14 +350,14 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc2)
-				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &gt;</text>\n",
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_HEIGHT/48, desc2);
 		}
 		if (row2) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
 			if (desc1)
-				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &gt;</text>\n",
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32, desc1);
 		}
 	} else {
@@ -333,14 +365,14 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc1)
-				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &lt;</text>\n",
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/48, desc1);
 		}
 		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
 			if (desc2)
-				fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"0.02pt\">%s &lt;</text>\n",
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT - SLOT_HEIGHT/32, desc2);
 		}
 	}
@@ -390,7 +422,7 @@ void svg_text(int Yslot, u64 start, const char *text)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
 		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
 }
 
@@ -401,7 +433,7 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 
 	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
 		X, boxsize, boxsize, style);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.4fpt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.8fpt\">%s</text>\n",
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
