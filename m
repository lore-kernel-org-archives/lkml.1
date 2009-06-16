Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbZFPURP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbZFPURP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761436AbZFPUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:10 -0400
Received: from claw.goop.org ([74.207.240.146]:40575 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbZFPUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/16] perf record/top: Clarify events/samples naming
Date: Tue, 16 Jun 2009 13:15:43 -0700
Message-Id: <1245183355-25808-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

A number of places said 'events' while they should say 'samples'.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/perf_counter/builtin-record.c |   22 ++++++------
 Documentation/perf_counter/builtin-top.c    |   46 +++++++++++++-------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index e2301f3..d4ad305 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -65,7 +65,7 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
-static long events;
+static long samples;
 static struct timeval last_read, this_read;
 
 static __u64 bytes_written;
@@ -83,7 +83,7 @@ static void mmap_read(struct mmap_data *md)
 
 	/*
 	 * If we're further behind than half the buffer, there's a chance
-	 * the writer will bite our tail and screw up the events under us.
+	 * the writer will bite our tail and mess up the samples under us.
 	 *
 	 * If we somehow ended up ahead of the head, we got messed up.
 	 *
@@ -109,7 +109,7 @@ static void mmap_read(struct mmap_data *md)
 	last_read = this_read;
 
 	if (old != head)
-		events++;
+		samples++;
 
 	size = head - old;
 
@@ -257,7 +257,7 @@ out_failure:
 	exit(EXIT_FAILURE);
 }
 
-static void pid_synthesize_mmap_events(pid_t pid)
+static void pid_synthesize_mmap_samples(pid_t pid)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -315,7 +315,7 @@ static void pid_synthesize_mmap_events(pid_t pid)
 	fclose(fp);
 }
 
-static void synthesize_events(void)
+static void synthesize_samples(void)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -331,7 +331,7 @@ static void synthesize_events(void)
 			continue;
 
 		pid_synthesize_comm_event(pid, 1);
-		pid_synthesize_mmap_events(pid);
+		pid_synthesize_mmap_samples(pid);
 	}
 
 	closedir(proc);
@@ -396,7 +396,7 @@ static void open_counters(int cpu, pid_t pid)
 
 	if (pid > 0) {
 		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_events(pid);
+		pid_synthesize_mmap_samples(pid);
 	}
 
 	group_fd = -1;
@@ -469,17 +469,17 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (system_wide)
-		synthesize_events();
+		synthesize_samples();
 
 	while (!done) {
-		int hits = events;
+		int hits = samples;
 
 		for (i = 0; i < nr_cpu; i++) {
 			for (counter = 0; counter < nr_counters; counter++)
 				mmap_read(&mmap_array[i][counter]);
 		}
 
-		if (hits == events)
+		if (hits == samples)
 			ret = poll(event_array, nr_poll, 100);
 	}
 
@@ -487,7 +487,7 @@ static int __cmd_record(int argc, const char **argv)
 	 * Approximate RIP event size: 24 bytes.
 	 */
 	fprintf(stderr,
-		"[ perf record: Captured and wrote %.3f MB %s (~%lld events) ]\n",
+		"[ perf record: Captured and wrote %.3f MB %s (~%lld samples) ]\n",
 		(double)bytes_written / 1024.0 / 1024.0,
 		output_name,
 		bytes_written / 24);
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 2fee595..ff7e13c 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -137,8 +137,8 @@ static double sym_weight(const struct sym_entry *sym)
 	return weight;
 }
 
-static long			events;
-static long			userspace_events;
+static long			samples;
+static long			userspace_samples;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
 static void __list_insert_active_sym(struct sym_entry *syme)
@@ -177,14 +177,14 @@ static void print_sym_table(void)
 {
 	int printed = 0, j;
 	int counter;
-	float events_per_sec = events/delay_secs;
-	float kevents_per_sec = (events-userspace_events)/delay_secs;
-	float sum_kevents = 0.0;
+	float samples_per_sec = samples/delay_secs;
+	float ksamples_per_sec = (samples-userspace_samples)/delay_secs;
+	float sum_ksamples = 0.0;
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
 
-	events = userspace_events = 0;
+	samples = userspace_samples = 0;
 
 	/* Sort the active symbols */
 	pthread_mutex_lock(&active_symbols_lock);
@@ -196,7 +196,7 @@ static void print_sym_table(void)
 		if (syme->snap_count != 0) {
 			syme->weight = sym_weight(syme);
 			rb_insert_active_sym(&tmp, syme);
-			sum_kevents += syme->snap_count;
+			sum_ksamples += syme->snap_count;
 
 			for (j = 0; j < nr_counters; j++)
 				syme->count[j] = zero ? 0 : syme->count[j] * 7 / 8;
@@ -209,8 +209,8 @@ static void print_sym_table(void)
 	printf(
 "------------------------------------------------------------------------------\n");
 	printf( "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% [",
-		events_per_sec,
-		100.0 - (100.0*((events_per_sec-kevents_per_sec)/events_per_sec)));
+		samples_per_sec,
+		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
 	if (nr_counters == 1) {
 		printf("%d", event_count[0]);
@@ -246,12 +246,12 @@ static void print_sym_table(void)
 	printf("------------------------------------------------------------------------------\n\n");
 
 	if (nr_counters == 1)
-		printf("             events    pcnt");
+		printf("             samples    pcnt");
 	else
-		printf("  weight     events    pcnt");
+		printf("  weight     samples    pcnt");
 
 	printf("         RIP          kernel function\n"
-	       	       "  ______     ______   _____   ________________   _______________\n\n"
+	       	       "  ______     _______   _____   ________________   _______________\n\n"
 	);
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
@@ -263,8 +263,8 @@ static void print_sym_table(void)
 		if (++printed > print_entries || syme->snap_count < count_filter)
 			continue;
 
-		pcnt = 100.0 - (100.0 * ((sum_kevents - syme->snap_count) /
-					 sum_kevents));
+		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
+					 sum_ksamples));
 
 		/*
 		 * We color high-overhead entries in red, low-overhead
@@ -276,9 +276,9 @@ static void print_sym_table(void)
 			color = PERF_COLOR_GREEN;
 
 		if (nr_counters == 1)
-			printf("%19.2f - ", syme->weight);
+			printf("%20.2f - ", syme->weight);
 		else
-			printf("%8.1f %10ld - ", syme->weight, syme->snap_count);
+			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
 		color_fprintf(stdout, color, "%4.1f%%", pcnt);
 		printf(" - %016llx : %s\n", sym->start, sym->name);
@@ -318,7 +318,7 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
-	/* Tag events to be skipped. */
+	/* Tag samples to be skipped. */
 	if (!strcmp("default_idle", name) ||
 	    !strcmp("cpu_idle", name) ||
 	    !strcmp("enter_idle", name) ||
@@ -405,15 +405,15 @@ static void record_ip(uint64_t ip, int counter)
 		}
 	}
 
-	events--;
+	samples--;
 }
 
 static void process_event(uint64_t ip, int counter)
 {
-	events++;
+	samples++;
 
 	if (ip < min_ip || ip > max_ip) {
-		userspace_events++;
+		userspace_samples++;
 		return;
 	}
 
@@ -451,7 +451,7 @@ static void mmap_read(struct mmap_data *md)
 
 	/*
 	 * If we're further behind than half the buffer, there's a chance
-	 * the writer will bite our tail and screw up the events under us.
+	 * the writer will bite our tail and mess up the samples under us.
 	 *
 	 * If we somehow ended up ahead of the head, we got messed up.
 	 *
@@ -608,14 +608,14 @@ static int __cmd_top(void)
 	}
 
 	while (1) {
-		int hits = events;
+		int hits = samples;
 
 		for (i = 0; i < nr_cpus; i++) {
 			for (counter = 0; counter < nr_counters; counter++)
 				mmap_read(&mmap_array[i][counter]);
 		}
 
-		if (hits == events)
+		if (hits == samples)
 			ret = poll(event_array, nr_poll, 100);
 	}
 
-- 
1.6.2.2

