Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYE0IVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYE0IVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYE0IUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:20:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:58194 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753654AbYE0IUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:20:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ajO80dDzaANHNYN4l7zu1iEhZSmiECY/9M9m/n/
	8EG4hf33TKCBUN
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in
	2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211867950.5505.47.camel@marge.simson.net>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
	 <1211867950.5505.47.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 27 May 2008 10:20:48 +0200
Message-Id: <1211876448.5760.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 07:59 +0200, Mike Galbraith wrote:
> On Mon, 2008-05-26 at 20:28 -0400, Greg Smith wrote:
> 
> > 2) Mike suggested a patch to 2.6.25 in this thread that backports
> the 
> > feature for disabling SCHED_FEAT_SYNC_WAKEUPS.  Would it be reasonable to 
> > push that into 2.6.25.5?  It's clearly quite useful for this load and 
> > therefore possibly others.
> 
> If the patch above flies, imho, that should be folded into the backport
> to stable.  The heart of the patch is a bugfix, so definitely stable
> material.  Whether to enable the debugging/tweaking knobs as well is a
> different question.  (I would do it, but I ain't the maintainer;)

Hm, pbench's extreme dislike of preemption, and the starvation testcase
I sent earlier having an absolute requirement of preemption kinda argues
that some knobs and dials should be per task or task group (or, or... or
scheduler should be all knowing all seeing;) 
 
2.6.25.4-feat=45  2.6.25.4-feat=111    2.6.25.4-feat=47
1  11385.471887        10292.721924         9551.157672
2  16709.515434        15540.399522        16283.968970
3  25456.658841        20187.320016        24562.735943
4  24453.435157        24975.037450        23391.583053
5  25504.302958        23102.131056        23671.860667
6  27076.359200        24688.791507        25947.592071
8  31758.200682        29462.639752        29700.144372
10 32190.081142        30428.413809        27439.441838
15 31175.074906        11097.668025        20344.284129
20 30513.974332        10742.166624        19256.695409
30 28307.399275        10233.708047        17535.423344
40 26720.463867        10037.856773        16104.895695
50 24899.945793         9907.624283        15768.746911

Anyway, if patchlet flies, and Ingo concurs, I'll submit the below.

Prevent short-running wakers of short-running threads from overloading a
single
cpu via wakeup affinity, and provide affinity related debug/tuning
options.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched.c      |    9 ++++++++-
 kernel/sched_fair.c |   25 ++++++++++++++-----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1e4596c..d6d70a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -596,6 +596,8 @@ enum {
 	SCHED_FEAT_START_DEBIT		= 4,
 	SCHED_FEAT_HRTICK		= 8,
 	SCHED_FEAT_DOUBLE_TICK		= 16,
+	SCHED_FEAT_AFFINE_WAKEUPS	= 32,
+	SCHED_FEAT_SYNC_WAKEUPS		= 64,
 };
 
 const_debug unsigned int sysctl_sched_features =
@@ -603,7 +605,9 @@ const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
 		SCHED_FEAT_HRTICK		* 1 |
-		SCHED_FEAT_DOUBLE_TICK		* 0;
+		SCHED_FEAT_DOUBLE_TICK		* 0 |
+		SCHED_FEAT_AFFINE_WAKEUPS	* 1 |
+		SCHED_FEAT_SYNC_WAKEUPS		* 1;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
@@ -1902,6 +1906,9 @@ static int try_to_wake_up(struct task_struct *p,
unsigned int state, int sync)
 	long old_state;
 	struct rq *rq;
 
+	if (!sched_feat(SYNC_WAKEUPS))
+		sync = 0;
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0080968..bf2defe 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -992,16 +992,27 @@ wake_affine(struct rq *rq, struct sched_domain
*this_sd, struct rq *this_rq,
 	struct task_struct *curr = this_rq->curr;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	int bad_imbalance;
 
-	if (!(this_sd->flags & SD_WAKE_AFFINE))
+	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
 	/*
+	 * If sync wakeup then subtract the (maximum possible)
+	 * effect of the currently running task from the load
+	 * of the current CPU:
+	 */
+	if (sync && tl)
+		tl -= curr->se.load.weight;
+
+	bad_imbalance = 100*(tl + p->se.load.weight) > imbalance*load;
+
+	/*
 	 * If the currently running task will sleep within
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && curr->sched_class == &fair_sched_class) {
+	if (sync && !bad_imbalance && curr->sched_class == &fair_sched_class)
{
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
 				p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
@@ -1010,16 +1021,8 @@ wake_affine(struct rq *rq, struct sched_domain
*this_sd, struct rq *this_rq,
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	/*
-	 * If sync wakeup then subtract the (maximum possible)
-	 * effect of the currently running task from the load
-	 * of the current CPU:
-	 */
-	if (sync)
-		tl -= current->se.load.weight;
-
 	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			100*(tl + p->se.load.weight) <= imbalance*load) {
+			!bad_imbalance) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and




