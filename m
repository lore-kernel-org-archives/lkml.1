Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZF3NKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZF3NKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZF3NKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZF3NKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:10:24 -0400
Subject: Re: [PATCH -tip] perf stat: define CHECK_ATTRS for easy attrs
 checking
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090630100835.GE6942@elte.hu>
References: <1246274348.3018.3.camel@hpdv5.satnam>
	 <20090630100835.GE6942@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 18:39:48 +0530
Message-Id: <1246367388.3026.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 12:08 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > CHECK_ATTRS is useful :
> >  1. for multiple attrs checking
> >  2. avoid repetition of PERF_TYPE_ and PERF_COUNT_ and save space
> >  3. avoids line breakage
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  tools/perf/builtin-stat.c |   18 ++++++++----------
> >  1 files changed, 8 insertions(+), 10 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> > index 3e5ea4e..6231b39 100644
> > --- a/tools/perf/builtin-stat.c
> > +++ b/tools/perf/builtin-stat.c
> > @@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
> >  static u64			runtime_cycles_avg;
> >  static u64			runtime_cycles_noise;
> >  
> > +#define CHECK_ATTRS(t, c, counter)			\
> > +	(attrs[counter].type == PERF_TYPE_##t &&	\
> > +	 attrs[counter].config == PERF_COUNT_##c)
> 
> looks good except that the name should be something like 
> MATCH_EVENT() not CHECK_ATTRS().
> 

[PATCH -tip] perf stat: define MATCH_EVENT for easy attrs checking

MATCH_EVENT is useful :
 1. for multiple attrs checking
 2. avoid repetition of PERF_TYPE_ and PERF_COUNT_ and save space
 3. avoids line breakage

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e5ea4e..00feb8d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
+#define MATCH_EVENT(t, c, counter)			\
+	(attrs[counter].type == PERF_TYPE_##t &&	\
+	 attrs[counter].config == PERF_COUNT_##c)
+
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -191,11 +195,9 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 		runtime_nsecs[run_idx] = count[0];
-	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
-		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
+	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
 		runtime_cycles[run_idx] = count[0];
 }
 
@@ -254,9 +256,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
-
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		if (walltime_nsecs_avg)
 			fprintf(stderr, " # %10.3f CPUs ",
 				(double)count[0] / (double)walltime_nsecs_avg);
@@ -269,9 +269,7 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
-		attrs[counter].type == PERF_TYPE_HARDWARE &&
-			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
+	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
 	} else {
-- 
1.6.0.6



