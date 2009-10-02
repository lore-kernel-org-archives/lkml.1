Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZJBMmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZJBMmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZJBMmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:42:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656AbZJBMma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:42:30 -0400
Date: Fri, 2 Oct 2009 14:42:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091002124220.GA20076@elte.hu>
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

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

[ 'perf timeline' is a perf subcommand that is new in .32, so i thought 
  it to be fine to take the new --power-only flag, despite it not being 
  a fix. ]

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      perf timechart: Add a power-only mode

Arnaldo Carvalho de Melo (1):
      perf top: Add poll_idle to the skip list

Mulyadi Santosa (1):
      perf tools: Run generate-cmdlist.sh properly

Xiao Guangrong (2):
      perf_event: Fix event group handling in __perf_event_sched_*()
      perf_event: Clean up perf_event_init_task()


 kernel/perf_event.c                         |   34 +++++++-------------------
 tools/perf/Documentation/perf-timechart.txt |    3 ++
 tools/perf/Makefile                         |    2 +-
 tools/perf/builtin-timechart.c              |   10 +++++--
 tools/perf/builtin-top.c                    |    1 +
 tools/perf/util/svghelper.c                 |   14 ++++++++++-
 6 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0f86feb..e491fb0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1030,14 +1030,10 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
 	update_context_time(ctx);
 
 	perf_disable();
-	if (ctx->nr_active) {
-		list_for_each_entry(event, &ctx->group_list, group_entry) {
-			if (event != event->group_leader)
-				event_sched_out(event, cpuctx, ctx);
-			else
-				group_sched_out(event, cpuctx, ctx);
-		}
-	}
+	if (ctx->nr_active)
+		list_for_each_entry(event, &ctx->group_list, group_entry)
+			group_sched_out(event, cpuctx, ctx);
+
 	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
@@ -1258,12 +1254,8 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
 
-		if (event != event->group_leader)
-			event_sched_in(event, cpuctx, ctx, cpu);
-		else {
-			if (group_can_go_on(event, cpuctx, 1))
-				group_sched_in(event, cpuctx, ctx, cpu);
-		}
+		if (group_can_go_on(event, cpuctx, 1))
+			group_sched_in(event, cpuctx, ctx, cpu);
 
 		/*
 		 * If this pinned group hasn't been scheduled,
@@ -1291,15 +1283,9 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
 
-		if (event != event->group_leader) {
-			if (event_sched_in(event, cpuctx, ctx, cpu))
+		if (group_can_go_on(event, cpuctx, can_add_hw))
+			if (group_sched_in(event, cpuctx, ctx, cpu))
 				can_add_hw = 0;
-		} else {
-			if (group_can_go_on(event, cpuctx, can_add_hw)) {
-				if (group_sched_in(event, cpuctx, ctx, cpu))
-					can_add_hw = 0;
-			}
-		}
 	}
 	perf_enable();
  out:
@@ -4781,9 +4767,7 @@ int perf_event_init_task(struct task_struct *child)
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
-		if (event != event->group_leader)
-			continue;
+	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
 
 		if (!event->attr.inherit) {
 			inherited_all = 0;
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
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5f1953..5881943 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -728,7 +728,7 @@ $(BUILT_INS): perf$X
 common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
 common-cmds.h: $(wildcard Documentation/perf-*.txt)
-	$(QUIET_GEN)util/generate-cmdlist.sh > $@+ && mv $@+ $@
+	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
 	$(QUIET_GEN)$(RM) $@ $@+ && \
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
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1ca8889..37512e9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -782,6 +782,7 @@ static const char *skip_symbols[] = {
 	"exit_idle",
 	"mwait_idle",
 	"mwait_idle_with_hints",
+	"poll_idle",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL
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
 
