Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbZBLQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbZBLQqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbZBLQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:46:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49284 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZBLQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:46:24 -0500
Date: Thu, 12 Feb 2009 08:46:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212164621.GC6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090211063520.GE8132@Krystal> <20090211153246.GA6694@linux.vnet.ibm.com> <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212070539.GA15896@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 02:05:39AM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Wed, Feb 11, 2009 at 11:08:24PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > 
> > [ . . . ]
> > 
> > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > things up.  :-/
> > > > 
> > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > Even better, gives the expected error if you comment out line 180 and
> > > > uncomment line 213, this latter corresponding to the error case I called
> > > > out a few days ago.
> > > > 
> > > 
> > > Great ! :) I added this version to the git repository, hopefully it's ok
> > > with you ?
> > 
> > Works for me!
> > 
> > > > I will play with removing models of mb...
> > > 
> > > OK, I see you already did..
> > 
> > I continued this, and surprisingly few are actually required, though
> > I don't fully trust the modeling of removed memory barriers.
> 
> On my side I cleaned up the code a lot, and actually added some barriers
> ;) Especially in the busy loops, where we expect the other thread's
> value to change eventually between iterations. A smp_rmb() seems more
> appropriate that barrier(). I also added a lot of comments about
> barriers in the code, and made the reader side much easier to review.
> 
> Please feel free to comment on my added code comments.

The torture test now looks much more familiar.  ;-)

I fixed some compiler warnings (in my original, sad to say), added an
ACCESS_ONCE() to rcu_read_lock() (also in my original), and downgraded
a few of your memory barriers with comments as to why.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.h |   11 +++++------
 urcu.c       |   12 ++++++++----
 urcu.h       |    2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/rcutorture.h b/rcutorture.h
index bda2ad5..8ba6763 100644
--- a/rcutorture.h
+++ b/rcutorture.h
@@ -112,7 +112,6 @@ void *rcu_read_perf_test(void *arg)
 {
 	int i;
 	int me = (long)arg;
-	cpu_set_t mask;
 	long long n_reads_local = 0;
 
 	urcu_register_thread();
@@ -150,6 +149,7 @@ void *rcu_update_perf_test(void *arg)
 		n_updates_local++;
 	}
 	__get_thread_var(n_updates_pt) += n_updates_local;
+	return NULL;
 }
 
 void perftestinit(void)
@@ -242,7 +242,7 @@ struct rcu_stress {
 	int mbtest;
 };
 
-struct rcu_stress rcu_stress_array[RCU_STRESS_PIPE_LEN] = { 0 };
+struct rcu_stress rcu_stress_array[RCU_STRESS_PIPE_LEN] = { { 0 } };
 struct rcu_stress *rcu_stress_current;
 int rcu_stress_idx = 0;
 
@@ -314,19 +314,18 @@ void *rcu_update_stress_test(void *arg)
 		synchronize_rcu();
 		n_updates++;
 	}
+	return NULL;
 }
 
 void *rcu_fake_update_stress_test(void *arg)
 {
-	int i;
-	struct rcu_stress *p;
-
 	while (goflag == GOFLAG_INIT)
 		poll(NULL, 0, 1);
 	while (goflag == GOFLAG_RUN) {
 		synchronize_rcu();
 		poll(NULL, 0, 1);
 	}
+	return NULL;
 }
 
 void stresstest(int nreaders)
@@ -360,7 +359,7 @@ void stresstest(int nreaders)
 	wait_all_threads();
 	for_each_thread(t)
 		n_reads += per_thread(n_reads_pt, t);
-	printf("n_reads: %lld  n_updates: %ld  n_mberror: %ld\n",
+	printf("n_reads: %lld  n_updates: %ld  n_mberror: %d\n",
 	       n_reads, n_updates, n_mberror);
 	printf("rcu_stress_count:");
 	for (i = 0; i <= RCU_STRESS_PIPE_LEN; i++) {
diff --git a/urcu.c b/urcu.c
index f2aae34..a696439 100644
--- a/urcu.c
+++ b/urcu.c
@@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
 	 * BUSY-LOOP.
 	 */
 	while (sig_done < 1)
-		smp_rmb();	/* ensure we re-read sig-done */
+		barrier();	/* ensure compiler re-reads sig-done */
+				/* cache coherence guarantees CPU re-read. */
 	smp_mb();	/* read sig_done before ending the barrier */
 }
 
@@ -113,7 +114,8 @@ static void force_mb_all_threads(void)
 	if (!reader_data)
 		return;
 	sig_done = 0;
-	smp_mb();	/* write sig_done before sending the signals */
+	/* smp_mb();	write sig_done before sending the signals */
+			/* redundant with barriers in pthread_kill(). */
 	for (index = reader_data; index < reader_data + num_readers; index++)
 		pthread_kill(index->tid, SIGURCU);
 	/*
@@ -121,7 +123,8 @@ static void force_mb_all_threads(void)
 	 * BUSY-LOOP.
 	 */
 	while (sig_done < num_readers)
-		smp_rmb();	/* ensure we re-read sig-done */
+		barrier();	/* ensure compiler re-reads sig-done */
+				/* cache coherence guarantees CPU re-read. */
 	smp_mb();	/* read sig_done before ending the barrier */
 }
 #endif
@@ -181,7 +184,8 @@ void synchronize_rcu(void)
 	 * the writer waiting forever while new readers are always accessing
 	 * data (no progress).
 	 */
-	smp_mb();
+	/* smp_mb(); Don't need this one for CPU, only compiler. */
+	barrier();
 
 	switch_next_urcu_qparity();	/* 1 -> 0 */
 
diff --git a/urcu.h b/urcu.h
index 3eca5ea..79d9464 100644
--- a/urcu.h
+++ b/urcu.h
@@ -244,7 +244,7 @@ static inline void rcu_read_lock(void)
 	/* The data dependency "read urcu_gp_ctr, write urcu_active_readers",
 	 * serializes those two memory operations. */
 	if (likely(!(tmp & RCU_GP_CTR_NEST_MASK)))
-		urcu_active_readers = urcu_gp_ctr;
+		urcu_active_readers = ACCESS_ONCE(urcu_gp_ctr);
 	else
 		urcu_active_readers = tmp + RCU_GP_COUNT;
 	/*
