Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZIMP1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZIMP1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZIMP13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:27:29 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:37592 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZIMP12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:27:28 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	<873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu>
	<87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu>
	<87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu>
Date: Sun, 13 Sep 2009 15:27:28 +0000
In-Reply-To: <20090911061024.GA27833@elte.hu> (Ingo Molnar's message of "Fri,
	11 Sep 2009 08:10:24 +0200")
Message-ID: <87iqfmx3tr.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Ingo Molnar <mingo@elte.hu> writes:

> Could still compare -j5 to -j4 on -tip, to see why -j4 is 3% short 
> of -j5's throughput.
>
> (Plus maybe the NEW_FAIR_SLEEPERS change in -tip fixes the 3% drop.)

I've hacked the "perf" tool a bit (see the attached patch) and obtained
the following results with "perf stat -r9 make -j4 -- make clean":

--------------------------------------------------------------------------------
2.6.31-tip-01381-gf4c92b6:

 Performance counter stats for 'make -j4' (9 runs):

   94730.871493  task-clock-msecs         #      3.503 CPUs    ( +-   0.022% )
          17499  context-switches         #      0.000 M/sec   ( +-   0.270% )
           1127  CPU-migrations           #      0.000 M/sec   ( +-   1.159% )
        4601950  page-faults              #      0.049 M/sec   ( +-   0.001% )
   237853044260  cycles                   #   2510.829 M/sec   ( +-   0.022% )
   200554338937  instructions             #      0.843 IPC     ( +-   0.000% )
    70615226021  cache-references         #    745.430 M/sec   ( +-   0.002% )
     2268068445  cache-misses             #     23.942 M/sec   ( +-   0.020% )

   27.046390652  seconds time elapsed   ( +-   0.085% )


 Performance counter stats for 'make -j5' (9 runs):

   95283.766024  task-clock-msecs         #      3.541 CPUs    ( +-   0.024% )
          20612  context-switches         #      0.000 M/sec   ( +-   0.297% )
           1644  CPU-migrations           #      0.000 M/sec   ( +-   0.711% )
        4601733  page-faults              #      0.048 M/sec   ( +-   0.001% )
   239234709890  cycles                   #   2510.760 M/sec   ( +-   0.024% )
   200562340756  instructions             #      0.838 IPC     ( +-   0.000% )
    70575215911  cache-references         #    740.685 M/sec   ( +-   0.004% )
     2266361085  cache-misses             #     23.785 M/sec   ( +-   0.017% )

   26.909772228  seconds time elapsed   ( +-   0.041% )


 Performance counter stats for 'make -j6' (9 runs):

   95664.586804  task-clock-msecs         #      3.568 CPUs    ( +-   0.020% )
          22358  context-switches         #      0.000 M/sec   ( +-   0.194% )
           1835  CPU-migrations           #      0.000 M/sec   ( +-   0.659% )
        4601777  page-faults              #      0.048 M/sec   ( +-   0.001% )
   240188102235  cycles                   #   2510.732 M/sec   ( +-   0.020% )
   200569036210  instructions             #      0.835 IPC     ( +-   0.000% )
    70565619805  cache-references         #    737.636 M/sec   ( +-   0.006% )
     2265714056  cache-misses             #     23.684 M/sec   ( +-   0.017% )

   26.808072908  seconds time elapsed   ( +-   0.063% )
--------------------------------------------------------------------------------
2.6.31-tip-01385-g1ca1afc:

 Performance counter stats for 'make -j4' (9 runs):

   94873.128287  task-clock-msecs         #      3.422 CPUs    ( +-   0.020% )
          13196  context-switches         #      0.000 M/sec   ( +-   0.181% )
           1777  CPU-migrations           #      0.000 M/sec   ( +-   0.664% )
        4601784  page-faults              #      0.049 M/sec   ( +-   0.001% )
   238126976192  cycles                   #   2509.952 M/sec   ( +-   0.020% )
   200545291785  instructions             #      0.842 IPC     ( +-   0.000% )
    70607104279  cache-references         #    744.227 M/sec   ( +-   0.005% )
     2266980390  cache-misses             #     23.895 M/sec   ( +-   0.022% )

   27.723375828  seconds time elapsed   ( +-   0.134% )


 Performance counter stats for 'make -j5' (9 runs):

   95363.595017  task-clock-msecs         #      3.519 CPUs    ( +-   0.015% )
          15003  context-switches         #      0.000 M/sec   ( +-   0.294% )
           1880  CPU-migrations           #      0.000 M/sec   ( +-   1.017% )
        4601648  page-faults              #      0.048 M/sec   ( +-   0.001% )
   239351549481  cycles                   #   2509.884 M/sec   ( +-   0.015% )
   200552379266  instructions             #      0.838 IPC     ( +-   0.000% )
    70576977633  cache-references         #    740.083 M/sec   ( +-   0.006% )
     2265294365  cache-misses             #     23.754 M/sec   ( +-   0.012% )

   27.096710006  seconds time elapsed   ( +-   0.074% )


 Performance counter stats for 'make -j6' (9 runs):

   95739.941233  task-clock-msecs         #      3.568 CPUs    ( +-   0.024% )
          16327  context-switches         #      0.000 M/sec   ( +-   0.230% )
           1863  CPU-migrations           #      0.000 M/sec   ( +-   0.623% )
        4601715  page-faults              #      0.048 M/sec   ( +-   0.002% )
   240292969273  cycles                   #   2509.851 M/sec   ( +-   0.024% )
   200554772612  instructions             #      0.835 IPC     ( +-   0.000% )
    70566092747  cache-references         #    737.060 M/sec   ( +-   0.004% )
     2264738533  cache-misses             #     23.655 M/sec   ( +-   0.021% )

   26.836474777  seconds time elapsed   ( +-   0.181% )
--------------------------------------------------------------------------------

Note that the disabling NEW_FAIR_SLEEPERS doesn't fix 3% regression from
v2.6.23, but instead makes "make -j4" runtime another 2% worse (27.05 -> 27.72).


--=-=-=
Content-Disposition: attachment; filename=hack-perf-stat-cleanup-command
Content-Description: perf cleanup-command patch

---
 tools/perf/builtin-stat.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux/tools/perf/builtin-stat.c
===================================================================
--- linux.orig/tools/perf/builtin-stat.c
+++ linux/tools/perf/builtin-stat.c
@@ -44,6 +44,7 @@
 #include "util/parse-events.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/run-command.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -458,7 +459,7 @@ static const struct option options[] = {
 
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
-	int status;
+	int status, j, cleanup, cleanup_argc;
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
@@ -467,6 +468,19 @@ int cmd_stat(int argc, const char **argv
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
+	// quick ugly hack: if a "--" appears in the command, treat is as
+	// a delimiter and use remaining part as a "cleanup command",
+	// not affecting performance counters.
+	cleanup = cleanup_argc = 0;
+	for (j = 1; j < (argc-1); j ++) {
+		if (!strcmp (argv[j], "--")) {
+			cleanup = j + 1;
+			cleanup_argc = argc - j - 1;
+			argv[j] = NULL;
+			argc = j;
+		}
+	}
+
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
@@ -493,6 +507,8 @@ int cmd_stat(int argc, const char **argv
 		if (run_count != 1 && verbose)
 			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
 		status = run_perf_stat(argc, argv);
+		if (cleanup)
+			run_command_v_opt (&argv [cleanup], 0);
 	}
 
 	print_stat(argc, argv);

--=-=-=--
