Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZIXNj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZIXNj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZIXNj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:39:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:38263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIXNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:39:56 -0400
Date: Thu, 24 Sep 2009 15:40:13 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org
Subject: [patch] perf timechart: Add a power-only mode
Message-ID: <20090924154013.0675ab71@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: perf timechart: Add a power-only mode

For doing work on the Linux power management components,
I need to make long (30+ seconds) traces. Currently,
this then results in a HUGE svg file, with mostly
process data that isn't interesting.

This patch adds a --power-only mode to perf timechart
that only outputs the CPU power section of the SVG;
this significantly reduces the size of the SVG file,
making even 30+ second traces viewable with inkscape.

As a minor tweak for the same effect, the minimum text
size is decreased; current inkscape cannot zoom in
deep enough to show text this small, but it reduces
inkscape compute time.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 1c2ed30..a791009 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -31,6 +31,9 @@ OPTIONS
 -w::
 --width=::
         Select the width of the SVG file (default: 1000)
+-p::
+--power-only::
+        Only output the CPU power section of the diagram
 
 
 SEE ALSO
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 4405681..702d8fe 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -46,6 +46,8 @@ static u64		turbo_frequency;
 
 static u64		first_time, last_time;
 
+static int		power_only;
+
 
 static struct perf_header	*header;
 
@@ -547,7 +549,7 @@ static void end_sample_processing(void)
 	u64 cpu;
 	struct power_event *pwr;
 
-	for (cpu = 0; cpu < numcpus; cpu++) {
+	for (cpu = 0; cpu <= numcpus; cpu++) {
 		pwr = malloc(sizeof(struct power_event));
 		if (!pwr)
 			return;
@@ -871,7 +873,7 @@ static int determine_display_tasks(u64 threshold)
 		/* no exit marker, task kept running to the end */
 		if (p->end_time == 0)
 			p->end_time = last_time;
-		if (p->total_time >= threshold)
+		if (p->total_time >= threshold && !power_only)
 			p->display = 1;
 
 		c = p->all;
@@ -882,7 +884,7 @@ static int determine_display_tasks(u64 threshold)
 			if (c->start_time == 1)
 				c->start_time = first_time;
 
-			if (c->total_time >= threshold) {
+			if (c->total_time >= threshold && !power_only) {
 				c->display = 1;
 				count++;
 			}
@@ -1134,6 +1136,8 @@ static const struct option options[] = {
 		    "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width,
 		    "page width"),
+	OPT_BOOLEAN('p', "power-only", &power_only,
+		    "output power data only"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index a778fd0..856655d 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -28,7 +28,7 @@ static u64 turbo_frequency, max_freq;
 
 int svg_page_width = 1000;
 
-#define MIN_TEXT_SIZE 0.001
+#define MIN_TEXT_SIZE 0.01
 
 static u64 total_height;
 static FILE *svgfile;
@@ -217,6 +217,18 @@ static char *cpu_model(void)
 		}
 		fclose(file);
 	}
+
+	/* CPU type */
+	file = fopen("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", "r");
+	if (file) {
+		while (fgets(buf, 255, file)) {
+			unsigned int freq;
+			freq = strtoull(buf, NULL, 10);
+			if (freq > max_freq)
+				max_freq = freq;
+		}
+		fclose(file);
+	}
 	return cpu_m;
 }
 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
