Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZIKGUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZIKGUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZIKGUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZIKGUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:20:40 -0400
Date: Fri, 11 Sep 2009 08:20:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [long] Another BFS versus CFS shakedown
Message-ID: <20090911062032.GB27833@elte.hu>
References: <200909090142.41738.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909090142.41738.elendil@planet.nl>
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


Frans, thanks for the detailed tests, they are very useful!

* Frans Pop <elendil@planet.nl> wrote:

> [1] I used Peter's version from:
>     http://marc.info/?l=linux-kernel&m=125242343131497&w=2
[...]
> Disclaimer: I have no idea what the numbers from 'latt' mean or 
> how reliable they are.

Note, the one you used was a still buggy version of latt.c producing 
bogus latency numbers - you will need the fix to it attached below. 

Furthermore, the following tune might be needed on mainline to make 
it produce consistently good max numbers (not just good averages):

   echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns

Let me pick out the worst observed mainline interactive behavior you 
reported:

> - with CFS the movie showed major skips during -j4 compile and 
>   Chromium was only barely playable (and zero fun); with compile 
>   at nice -n 10 Chromium was a lot more playable, but movie still 
>   skipped a lot

FYI, this ought to be fixed in the latest scheduler tree which you 
can find in -tip:

  http://people.redhat.com/mingo/tip.git/README

Which fix was confirmed by Nikos Chantziaras for a very similar set 
of workloads. (and partly confirmed by Jens for a different 
workload)

Also, the make -j<nr_cpus> performance results improved in latest 
-tip, although it's still an open question whether all issues have 
been fixed.

	Ingo

--- latt.c.orig
+++ latt.c
@@ -39,6 +39,7 @@ static unsigned int verbose;
 struct stats
 {
 	double n, mean, M2, max;
+	int max_pid;
 };
 
 static void update_stats(struct stats *stats, unsigned long long val)
@@ -85,22 +86,6 @@ static double stddev_stats(struct stats 
 	return sqrt(variance);
 }
 
-/*
- * The std dev of the mean is related to the std dev by:
- *
- *             s
- * s_mean = -------
- *          sqrt(n)
- *
- */
-static double stddev_mean_stats(struct stats *stats)
-{
-	double variance = stats->M2 / (stats->n - 1);
-	double variance_mean = variance / stats->n;
-
-	return sqrt(variance_mean);
-}
-
 struct stats delay_stats;
 
 static int pipes[MAX_CLIENTS*2][2];
@@ -212,7 +197,7 @@ static unsigned long usec_since(struct t
 static void log_delay(unsigned long delay)
 {
 	if (verbose) {
-		fprintf(stderr, "log delay %8lu usec\n", delay);
+		fprintf(stderr, "log delay %8lu usec (pid %d)\n", delay, getpid());
 		fflush(stderr);
 	}
 
@@ -300,7 +285,7 @@ static int __write_ts(int i, struct time
 	return write(fd, ts, sizeof(*ts)) != sizeof(*ts);
 }
 
-static long __read_ts(int i, struct timespec *ts)
+static long __read_ts(int i, struct timespec *ts, pid_t *cpids)
 {
 	int fd = pipes[2*i+1][0];
 	struct timespec t;
@@ -309,11 +294,14 @@ static long __read_ts(int i, struct time
 		return -1;
 
 	log_delay(usec_since(ts, &t));
+	if (verbose)
+		fprintf(stderr, "got delay %ld from child %d [pid %d]\n", usec_since(ts, &t), i, cpids[i]);
 
 	return 0;
 }
 
-static int read_ts(struct pollfd *pfd, unsigned int nr, struct timespec *ts)
+static int read_ts(struct pollfd *pfd, unsigned int nr, struct timespec *ts,
+		   pid_t *cpids)
 {
 	unsigned int i;
 
@@ -322,7 +310,7 @@ static int read_ts(struct pollfd *pfd, u
 			return -1L;
 		if (pfd[i].revents & POLLIN) {
 			pfd[i].events = 0;
-			if (__read_ts(i, &ts[i]))
+			if (__read_ts(i, &ts[i], cpids))
 				return -1L;
 			nr--;
 		}
@@ -368,7 +356,6 @@ static void run_parent(pid_t *cpids)
 	srand(1234);
 
 	do {
-		unsigned long delay;
 		unsigned pending_events;
 
 		do_rand_sleep();
@@ -404,17 +391,17 @@ static void run_parent(pid_t *cpids)
 		 */
 		pending_events = clients;
 		while (pending_events) {
-			int evts = poll(ipfd, clients, 0);
+			int evts = poll(ipfd, clients, -1);
 
 			if (evts < 0) {
 				do_exit = 1;
 				break;
 			} else if (!evts) {
-				/* printf("bugger2\n"); */
+				printf("bugger2\n");
 				continue;
 			}
 
-			if (read_ts(ipfd, evts, t1)) {
+			if (read_ts(ipfd, evts, t1, cpids)) {
 				do_exit = 1;
 				break;
 			}
