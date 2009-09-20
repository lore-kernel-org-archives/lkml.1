Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZITQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZITQOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZITQOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:14:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:50845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZITQOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:14:35 -0400
Date: Sun, 20 Sep 2009 18:14:16 +0200
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, paulus@samba.org, ahpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH] perf util: Make the timechart SVG width dynamic
Message-ID: <20090920181416.69570c5d@linux.intel.com>
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

>From 356f4322f4c6cfee7c708a172fcd22848ad31a1e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 20 Sep 2009 09:54:58 +0200
Subject: [PATCH] perf util: Make the timechart SVG width dynamic

This patch adds a command line option for timechart that allows the user
to specify the width of the SVG file.

This patch also makes sure that each second of recording has at least 200
units (pixels at 96 DPI) of width.  This impacts recordings longer than 5
seconds; recordings shorter than 5 second will scale up to have a width of
1000 units for the whole recording (as before).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/Documentation/perf-timechart.txt |    3 ++
 tools/perf/builtin-timechart.c              |    6 +++-
 tools/perf/util/svghelper.c                 |   30 ++++++++++++++++++---------
 tools/perf/util/svghelper.h                 |    6 +++-
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 61e0104..1c2ed30 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -28,6 +28,9 @@ OPTIONS
 -i::
 --input=::
         Select the input file (default: perf.data)
+-w::
+--width=::
+        Select the width of the SVG file (default: 1000)
 
 
 SEE ALSO
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 23b3f09..6004063 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -915,9 +915,9 @@ static void write_svg_file(const char *filename)
 	if (count < 15)
 		count = determine_display_tasks(TIME_THRESH / 10);
 
-	open_svg(filename, numcpus, count);
+	open_svg(filename, numcpus, count, first_time, last_time);
 
-	svg_time_grid(first_time, last_time);
+	svg_time_grid();
 	svg_legenda();
 
 	for (i = 0; i < numcpus; i++)
@@ -1132,6 +1132,8 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
+	OPT_INTEGER('w', "width", &svg_page_width,
+		    "page width"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 52f628f..be1555e 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -25,7 +25,8 @@ static u64 turbo_frequency, max_freq;
 
 #define SLOT_MULT 30.0
 #define SLOT_HEIGHT 25.0
-#define WIDTH 1000.0
+
+int svg_page_width = 1000;
 
 #define MIN_TEXT_SIZE 0.001
 
@@ -46,21 +47,35 @@ static double time2pixels(u64 time)
 {
 	double X;
 
-	X = WIDTH * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
 	return X;
 }
 
-void open_svg(const char *filename, int cpus, int rows)
+void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 {
+	int new_width;
 
 	svgfile = fopen(filename, "w");
 	if (!svgfile) {
 		fprintf(stderr, "Cannot open %s for output\n", filename);
 		return;
 	}
+	first_time = start;
+	first_time = first_time / 100000000 * 100000000;
+	last_time = end;
+
+	/*
+	 * if the recording is short, we default to a width of 1000, but
+	 * for longer recordings we want at least 200 units of width per second
+	 */
+	new_width = (last_time - first_time) / 5000000;
+
+	if (new_width > svg_page_width)
+		svg_page_width = new_width;
+
 	total_height = (1 + rows + cpu2slot(cpus)) * SLOT_MULT;
 	fprintf(svgfile, "<?xml version=\"1.0\" standalone=\"no\"?> \n");
-	fprintf(svgfile, "<svg width=\"%4.1f\" height=\"%llu\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", WIDTH, total_height);
+	fprintf(svgfile, "<svg width=\"%i\" height=\"%llu\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", svg_page_width, total_height);
 
 	fprintf(svgfile, "<defs>\n  <style type=\"text/css\">\n    <![CDATA[\n");
 
@@ -404,15 +419,10 @@ void svg_legenda(void)
 	svg_legenda_box(800,	"Blocked on IO", "blocked");
 }
 
-void svg_time_grid(u64 start, u64 end)
+void svg_time_grid(void)
 {
 	u64 i;
 
-	first_time = start;
-	last_time = end;
-
-	first_time = first_time / 100000000 * 100000000;
-
 	if (!svgfile)
 		return;
 
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index ed4ebcf..cd93195 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -3,7 +3,7 @@
 
 #include "types.h"
 
-extern void open_svg(const char *filename, int cpus, int rows);
+extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
 extern void svg_sample(int Yslot, int cpu, u64 start, u64 end);
 extern void svg_waiting(int Yslot, u64 start, u64 end);
@@ -15,7 +15,7 @@ extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
 
-extern void svg_time_grid(u64 start, u64 end);
+extern void svg_time_grid(void);
 extern void svg_legenda(void);
 extern void svg_wakeline(u64 start, int row1, int row2);
 extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2);
@@ -23,4 +23,6 @@ extern void svg_interrupt(u64 start, int row);
 extern void svg_text(int Yslot, u64 start, const char *text);
 extern void svg_close(void);
 
+extern int svg_page_width;
+
 #endif
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
