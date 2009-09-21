Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZIUNJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZIUNJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZIUNJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:09:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbZIUNJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:09:43 -0400
Date: Mon, 21 Sep 2009 15:09:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [GIT PULL] performance counters fixes/updates
Message-ID: <20090921130934.GA1030@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

Some 'perf timechart' finishing touches, plus fixes.

 Thanks,

	Ingo

------------------>
Arjan van de Ven (4):
      perf timechart: Show the name of the waker/wakee in timechart
      perf timechart: Show the duration of scheduler delays in the SVG
      perf util: Make the timechart SVG width dynamic
      perf util: SVG performance improvements

Paul Mackerras (1):
      perf_counter, powerpc, sparc: Fix compilation after perf_counter_overflow() change

Peter Zijlstra (1):
      perf_counter: x86: Fix PMU resource leak


 arch/powerpc/kernel/perf_counter.c          |    3 +-
 arch/sparc/kernel/perf_counter.c            |    3 +-
 arch/x86/kernel/cpu/perf_counter.c          |    9 +-
 include/linux/perf_counter.h                |   17 ---
 tools/perf/Documentation/perf-timechart.txt |    3 +
 tools/perf/builtin-timechart.c              |   23 +++--
 tools/perf/util/svghelper.c                 |  170 +++++++++++++++++++++-----
 tools/perf/util/svghelper.h                 |   11 +-
 8 files changed, 170 insertions(+), 69 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 7ceefaf..5ccf9bc 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1162,7 +1162,6 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 	 */
 	if (record) {
 		struct perf_sample_data data = {
-			.regs	= regs,
 			.addr	= 0,
 			.period	= counter->hw.last_period,
 		};
@@ -1170,7 +1169,7 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_counter_overflow(counter, nmi, &data)) {
+		if (perf_counter_overflow(counter, nmi, &data, regs)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
 			 * by setting the counter to 0, so it will be
diff --git a/arch/sparc/kernel/perf_counter.c b/arch/sparc/kernel/perf_counter.c
index 09de403..b1265ce 100644
--- a/arch/sparc/kernel/perf_counter.c
+++ b/arch/sparc/kernel/perf_counter.c
@@ -493,7 +493,6 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -513,7 +512,7 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 		if (!sparc_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			sparc_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index dbdf712..a6c8b27 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -924,6 +924,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (err)
 		return err;
 
+	counter->destroy = hw_perf_counter_destroy;
+
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
@@ -953,8 +955,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 			return -EOPNOTSUPP;
 	}
 
-	counter->destroy = hw_perf_counter_destroy;
-
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
@@ -2107,8 +2107,11 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	int err;
 
 	err = __hw_perf_counter_init(counter);
-	if (err)
+	if (err) {
+		if (counter->destroy)
+			counter->destroy(counter);
 		return ERR_PTR(err);
+	}
 
 	return &pmu;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index bd34100..740caad 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -849,23 +849,6 @@ static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
 
-static inline int
-perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
-		  unsigned int size, int nmi, int sample)		{ }
-static inline void perf_output_end(struct perf_output_handle *handle)	{ }
-static inline void
-perf_output_copy(struct perf_output_handle *handle,
-		 const void *buf, unsigned int len)			{ }
-static inline void
-perf_output_sample(struct perf_output_handle *handle,
-		   struct perf_event_header *header,
-		   struct perf_sample_data *data,
-		   struct perf_counter *counter)			{ }
-static inline void
-perf_prepare_sample(struct perf_event_header *header,
-		    struct perf_sample_data *data,
-		    struct perf_counter *counter,
-		    struct pt_regs *regs)				{ }
 #endif
 
 #define perf_output_put(handle, x) \
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
index 58d737e..6004063 100644
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
@@ -822,15 +827,15 @@ static void draw_process_bars(void)
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
 
@@ -910,9 +915,9 @@ static void write_svg_file(const char *filename)
 	if (count < 15)
 		count = determine_display_tasks(TIME_THRESH / 10);
 
-	open_svg(filename, numcpus, count);
+	open_svg(filename, numcpus, count, first_time, last_time);
 
-	svg_time_grid(first_time, last_time);
+	svg_time_grid();
 	svg_legenda();
 
 	for (i = 0; i < numcpus; i++)
@@ -1127,6 +1132,8 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
+	OPT_INTEGER('w', "width", &svg_page_width,
+		    "page width"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index b0fcecd..a778fd0 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -25,7 +25,8 @@ static u64 turbo_frequency, max_freq;
 
 #define SLOT_MULT 30.0
 #define SLOT_HEIGHT 25.0
-#define WIDTH 1000.0
+
+int svg_page_width = 1000;
 
 #define MIN_TEXT_SIZE 0.001
 
@@ -46,21 +47,54 @@ static double time2pixels(u64 time)
 {
 	double X;
 
-	X = WIDTH * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
 	return X;
 }
 
-void open_svg(const char *filename, int cpus, int rows)
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
 
@@ -69,7 +103,8 @@ void open_svg(const char *filename, int cpus, int rows)
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
-	fprintf(svgfile, "      rect.waiting  { fill:rgb(255,255,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(214,214,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
 	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
 	fprintf(svgfile, "      rect.c1       { fill:rgb(255,214,214); fill-opacity:0.5; stroke-width:0; } \n");
@@ -92,26 +127,78 @@ void svg_box(int Yslot, u64 start, u64 end, const char *type)
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
+	font_size = 1.0 * (time2pixels(end)-time2pixels(start));
+
+	if (font_size > 3)
+		font_size = 3;
+
+	font_size = round_text_size(font_size);
+
+	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
+	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(end)-time2pixels(start), SLOT_HEIGHT, style);
+	if (font_size > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%1.8fpt\"> %s</text>\n",
+			font_size, text);
+	fprintf(svgfile, "</g>\n");
+}
+
 static char *cpu_model(void)
 {
 	static char cpu_m[255];
@@ -148,7 +235,7 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
 	sprintf(cpu_string, "CPU %i", (int)cpu+1);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
 	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
@@ -162,15 +249,21 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
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
@@ -191,13 +284,15 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
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
@@ -236,13 +331,13 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
 	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
 		time2pixels(start), time2pixels(end), height, height);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"0.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"0.25pt\">%s</text>\n",
 		time2pixels(start), height+0.9, HzToHuman(freq));
 
 }
 
 
-void svg_partial_wakeline(u64 start, int row1, int row2)
+void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2)
 {
 	double height;
 
@@ -251,21 +346,35 @@ void svg_partial_wakeline(u64 start, int row1, int row2)
 
 
 	if (row1 < row2) {
-		if (row1)
+		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
-
-		if (row2)
+			if (desc2)
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
+					time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_HEIGHT/48, desc2);
+		}
+		if (row2) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
+			if (desc1)
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
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
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+					time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/48, desc1);
+		}
+		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
+			if (desc2)
+				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+					time2pixels(start), row1 * SLOT_MULT - SLOT_HEIGHT/32, desc2);
+		}
 	}
 	height = row1 * SLOT_MULT;
 	if (row2 > row1)
@@ -313,7 +422,7 @@ void svg_text(int Yslot, u64 start, const char *text)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
 		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
 }
 
@@ -324,7 +433,7 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 
 	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
 		X, boxsize, boxsize, style);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.4fpt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.8fpt\">%s</text>\n",
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
@@ -342,15 +451,10 @@ void svg_legenda(void)
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
index ad79b5d..cd93195 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -3,9 +3,10 @@
 
 #include "types.h"
 
-extern void open_svg(const char *filename, int cpus, int rows);
+extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
-extern void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type);
+extern void svg_sample(int Yslot, int cpu, u64 start, u64 end);
+extern void svg_waiting(int Yslot, u64 start, u64 end);
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
@@ -14,12 +15,14 @@ extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
 
-extern void svg_time_grid(u64 start, u64 end);
+extern void svg_time_grid(void);
 extern void svg_legenda(void);
 extern void svg_wakeline(u64 start, int row1, int row2);
-extern void svg_partial_wakeline(u64 start, int row1, int row2);
+extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2);
 extern void svg_interrupt(u64 start, int row);
 extern void svg_text(int Yslot, u64 start, const char *text);
 extern void svg_close(void);
 
+extern int svg_page_width;
+
 #endif
