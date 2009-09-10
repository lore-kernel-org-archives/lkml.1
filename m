Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZIJJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZIJJ7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZIJJ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:59:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZIJJ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:59:35 -0400
Date: Thu, 10 Sep 2009 11:59:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910095933.GA21314@elte.hu>
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <20090910094821.GC18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910094821.GC18599@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Sep 09 2009, Ingo Molnar wrote:
> > At least in my tests these latencies were mainly due to a bug in 
> > latt.c - i've attached the fixed version.
> 
> What bug? I don't see any functional change between the version 
> you attach and the current one.

Here's the diff of what i fixed yesterday over the last latt.c 
version i found in this thread. The poll() thing is the significant 
one.

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
