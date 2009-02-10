Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZBJCWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZBJCWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZBJCWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:22:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:4287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZBJCWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:22:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,183,1233561600"; 
   d="scan'208";a="385457996"
Subject: Re: [PATCH] perf_counter: Make software counters work as per-cpu
	counters
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090209114852.GF18757@elte.hu>
References: <18832.5815.706605.434454@cargo.ozlabs.ibm.com>
	 <20090209114852.GF18757@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 10:21:58 +0800
Message-Id: <1234232518.2604.335.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 12:48 +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Impact: kernel crash fix
> > 
> > Yanmin Zhang reported that using a PERF_COUNT_TASK_CLOCK software
> > counter as a per-cpu counter would reliably crash the system, because
> > it calls __task_delta_exec with a null pointer.  The page fault,
> > context switch and cpu migration counters also won't function
> > correctly as per-cpu counters since they reference the current task.
> > 
> > This fixes the problem by redirecting the task_clock counter to the
> > cpu_clock counter when used as a per-cpu counter, and by implementing
> > per-cpu page fault, context switch and cpu migration counters.
> > 
> > Along the way, this:
> > 
> > - Initializes counter->ctx earlier, in perf_counter_alloc, so that
> >   sw_perf_counter_init can use it
> > - Adds code to kernel/sched.c to count task migrations into each
> >   cpu, in rq->nr_migrations_in
> > - Exports the per-cpu context switch and task migration counts
> >   via new functions added to kernel/sched.c
> > - Makes sure that if sw_perf_counter_init fails, we don't try to
> >   initialize the counter as a hardware counter.  Since the user has
> >   passed a negative, non-raw event type, they clearly don't intend
> >   for it to be interpreted as a hardware event.
> > 
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
I tested it. The patch does fix the crash.

> 
> Very nice, thanks Paul!
> 
> > I'm a little concerned about the use of u64 for the existing
> > rq->nr_switches and the new rq->nr_migrations_in.  On 32-bit machines
> > this will get updated in two halves, so there is a very small but
> > non-zero probability that reading it will give a bogus value.  It's
> > not clear to me what the best way to fix it is, since not all 32-bit
> > platforms have atomic64_t.  Maybe make nr_switches and
> > nr_migrations_in unsigned long, or atomic_t?
> 
> It used to be 'just stats' so we dont really mind. But now that we
> expose it in a bit more systematic way i agree that it should be
> fixed. Updating to 'unsigned long' sounds good to me.
> 
> > I have some sort of git problem with my perfcounters.git repository.
> > I'll let you know when I have that sorted out.
> 
> ok - i've applied your patch from email to allow Yanmin to test tip:master.
Ingo,

Here is the patch to add system-wide collection for perfstat.c.

With the new parameter '-s', perfstat introduces very little overhead to benchmark
testing. If tracking performance data without '-s', sometimes perfstat has too much
impact on benchmark results, especially on netperf UDP-U-4k.

Yanmin

---

--- perfstat.c	2009-01-23 03:18:31.000000000 +0800
+++ perfstat_ymz.c	2009-02-10 10:17:46.000000000 +0800
@@ -172,14 +172,18 @@ static char *sw_event_names [] = {
 };
 
 #define MAX_COUNTERS					64
+#define MAX_NR_CPUS					256
 
 static int			nr_counters		= 0;
+static int			nr_cpus			= 0;
 
 static int			event_id[MAX_COUNTERS]	=
 					 { -2, -5, -4, -3, 0, 1, 2, 3};
 
 static int			event_raw[MAX_COUNTERS];
 
+static int			system_wide		= 0;
+
 static void display_help(void)
 {
 	printf(
@@ -195,6 +199,7 @@ static void display_help(void)
 	"                                   4: branch instructions\n"
 	"                                   5: branch prediction misses\n\n"
 	"                                   6: bus cycles\n"
+	" -s                                # system-wide collection\n"
 	" -c <cmd..>   --command=<cmd..>    # command+arguments to be timed.\n"
 	"\n");
 
@@ -269,7 +274,7 @@ static void process_options(int argc, ch
 			{"command",	no_argument,		NULL, 'c'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:e:c",
+		int c = getopt_long(argc, argv, "+:e:c:s",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -277,6 +282,9 @@ static void process_options(int argc, ch
 		switch (c) {
 		case 'c':
 			break;
+		case 's':
+			system_wide = 1;
+			break;
 		case 'e':
 			parse_events(optarg);
 			break;
@@ -302,7 +310,7 @@ char fault_here[1000000];
 #define PR_TASK_PERF_COUNTERS_DISABLE           31
 #define PR_TASK_PERF_COUNTERS_ENABLE            32
 
-static int fd[MAX_COUNTERS];
+static int fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static void create_counter(int counter)
 {
@@ -313,16 +321,29 @@ static void create_counter(int counter)
 	hw_event.raw		= event_raw[counter];
 	hw_event.record_type	= PERF_RECORD_SIMPLE;
 	hw_event.nmi		= 0;
-	hw_event.inherit	= 1;
-	hw_event.disabled	= 1;
 
-	fd[counter] = sys_perf_counter_open(&hw_event, 0, -1, -1);
-	if (fd[counter] < 0) {
-		printf("perfstat error: syscall returned with %d (%s)\n",
-			fd[counter], strerror(errno));
-		exit(-1);
+	if (system_wide) {
+		int cpu;
+		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+			fd[cpu][counter] = sys_perf_counter_open(&hw_event, -1, cpu, -1);
+			if (fd[cpu][counter] < 0) {
+				printf("perfstat error: syscall returned with %d (%s)\n",
+						fd[cpu][counter], strerror(errno));
+				exit(-1);
+			}
+			
+		}
+	} else {
+		hw_event.inherit	= 1;
+		hw_event.disabled	= 1;
+
+		fd[0][counter] = sys_perf_counter_open(&hw_event, 0, -1, -1);
+		if (fd[0][counter] < 0) {
+			printf("perfstat error: syscall returned with %d (%s)\n",
+					fd[0][counter], strerror(errno));
+			exit(-1);
+		}
 	}
-	assert(fd[counter] >= 0);
 }
 
 
@@ -344,6 +365,13 @@ int main(int argc, char *argv[])
 
 	process_options(argc, argv);
 
+	if (system_wide) {
+		nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+		assert(nr_cpus <= MAX_NR_CPUS);
+		assert(nr_cpus >= 0);
+	} else
+		nr_cpus = 1;
+
 	for (counter = 0; counter < nr_counters; counter++)
 		create_counter(counter);
 
@@ -375,12 +403,16 @@ int main(int argc, char *argv[])
 	fprintf(stderr, "\n");
 
 	for (counter = 0; counter < nr_counters; counter++) {
-		u64 count;
-
-		res = read(fd[counter],
-			   (char *) &count, sizeof(count));
-		assert(res == sizeof(count));
+		int cpu;
+		u64 count, single_count;
 
+		count = 0;
+		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+			res = read(fd[cpu][counter],
+					(char *) &single_count, sizeof(single_count));
+			assert(res == sizeof(single_count));
+			count += single_count;
+		}
 
 		if (!event_raw[counter] &&
 		    (event_id[counter] == PERF_COUNT_CPU_CLOCK ||


