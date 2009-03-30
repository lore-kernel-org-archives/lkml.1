Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZC3RNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZC3RNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZC3RL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171023.871484899@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/15] perf_counter tools: optionally scale counter values in perfstat mode
Content-Disposition: inline; filename=paulus-perf_counter_tools-optionally_scale_counter_values_in_perfstat_mode.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

Impact: new functionality

This adds add an option to the perfstat mode of kerneltop to scale the
reported counter values according to the fraction of time that each
counter gets to count.  This is invoked with the -l option (I used 'l'
because s, c, a and e were all taken already.)  This uses the new
PERF_RECORD_TOTAL_TIME_{ENABLED,RUNNING} read format options.

With this, we get output like this:

$ ./perfstat -l -e 0:0,0:1,0:2,0:3,0:4,0:5 ./spin

 Performance counter stats for './spin':

     4016072055  CPU cycles           (events)  (scaled from 66.53%)
     2005887318  instructions         (events)  (scaled from 66.53%)
        1762849  cache references     (events)  (scaled from 66.69%)
         165229  cache misses         (events)  (scaled from 66.85%)
     1001298009  branches             (events)  (scaled from 66.78%)
          41566  branch misses        (events)  (scaled from 66.61%)

 Wall-clock time elapsed:  2438.227446 msecs

This also lets us detect when a counter is zero because the counter
never got to go on the CPU at all.  In that case we print <not counted>
rather than 0.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   56 ++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 11 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -197,6 +197,8 @@ static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
+static int			scale;
+
 struct source_line {
 	uint64_t		EIP;
 	unsigned long		count;
@@ -305,6 +307,7 @@ static void display_perfstat_help(void)
 	display_events_help();
 
 	printf(
+	" -l                           # scale counter values\n"
 	" -a                           # system-wide collection\n");
 	exit(0);
 }
@@ -328,6 +331,7 @@ static void display_help(void)
 	" -c CNT    --count=CNT        # event period to sample\n\n"
 	" -C CPU    --cpu=CPU          # CPU (-1 for all)                 [default: -1]\n"
 	" -p PID    --pid=PID          # PID of sampled task (-1 for all) [default: -1]\n\n"
+	" -l                           # show scale factor for RR events\n"
 	" -d delay  --delay=<seconds>  # sampling/display delay           [default:  2]\n"
 	" -f CNT    --filter=CNT       # min-event-count filter          [default: 100]\n\n"
 	" -s symbol --symbol=<symbol>  # function to be showed annotated one-shot\n"
@@ -436,6 +440,9 @@ static void create_perfstat_counter(int 
 	hw_event.config		= event_id[counter];
 	hw_event.record_type	= PERF_RECORD_SIMPLE;
 	hw_event.nmi		= 0;
+	if (scale)
+		hw_event.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
+					  PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
 		int cpu;
@@ -507,28 +514,53 @@ int do_perfstat(int argc, char *argv[])
 	fprintf(stderr, "\n");
 
 	for (counter = 0; counter < nr_counters; counter++) {
-		int cpu;
-		__u64 count, single_count;
+		int cpu, nv;
+		__u64 count[3], single_count[3];
+		int scaled;
 
-		count = 0;
+		count[0] = count[1] = count[2] = 0;
+		nv = scale ? 3 : 1;
 		for (cpu = 0; cpu < nr_cpus; cpu ++) {
 			res = read(fd[cpu][counter],
-					(char *) &single_count, sizeof(single_count));
-			assert(res == sizeof(single_count));
-			count += single_count;
+				   single_count, nv * sizeof(__u64));
+			assert(res == nv * sizeof(__u64));
+
+			count[0] += single_count[0];
+			if (scale) {
+				count[1] += single_count[1];
+				count[2] += single_count[2];
+			}
+		}
+
+		scaled = 0;
+		if (scale) {
+			if (count[2] == 0) {
+				fprintf(stderr, " %14s  %-20s\n",
+					"<not counted>", event_name(counter));
+				continue;
+			}
+			if (count[2] < count[1]) {
+				scaled = 1;
+				count[0] = (unsigned long long)
+					((double)count[0] * count[1] / count[2] + 0.5);
+			}
 		}
 
 		if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK) ||
 		    event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK)) {
 
-			double msecs = (double)count / 1000000;
+			double msecs = (double)count[0] / 1000000;
 
-			fprintf(stderr, " %14.6f  %-20s (msecs)\n",
+			fprintf(stderr, " %14.6f  %-20s (msecs)",
 				msecs, event_name(counter));
 		} else {
-			fprintf(stderr, " %14Ld  %-20s (events)\n",
-				count, event_name(counter));
+			fprintf(stderr, " %14Ld  %-20s (events)",
+				count[0], event_name(counter));
 		}
+		if (scaled)
+			fprintf(stderr, "  (scaled from %.2f%%)",
+				(double) count[2] / count[1] * 100);
+		fprintf(stderr, "\n");
 	}
 	fprintf(stderr, "\n");
 	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
@@ -1049,6 +1081,7 @@ static void process_options(int argc, ch
 			{"filter",	required_argument,	NULL, 'f'},
 			{"group",	required_argument,	NULL, 'g'},
 			{"help",	no_argument,		NULL, 'h'},
+			{"scale",	no_argument,		NULL, 'l'},
 			{"nmi",		required_argument,	NULL, 'n'},
 			{"pid",		required_argument,	NULL, 'p'},
 			{"vmlinux",	required_argument,	NULL, 'x'},
@@ -1060,7 +1093,7 @@ static void process_options(int argc, ch
 			{"munmap_info",	no_argument,		NULL, 'U'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hn:m:p:s:Sx:zMU",
+		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:s:Sx:zMU",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1084,6 +1117,7 @@ static void process_options(int argc, ch
 		case 'f': count_filter			=   atoi(optarg); break;
 		case 'g': group				=   atoi(optarg); break;
 		case 'h':      				  display_help(); break;
+		case 'l': scale				=	       1; break;
 		case 'n': nmi				=   atoi(optarg); break;
 		case 'p':
 			/* CPU and PID are mutually exclusive */

-- 

