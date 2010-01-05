Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597Ab0AELuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0AELuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564Ab0AELuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:50:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:56234 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754550Ab0AELt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:49:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/C+aoy3rTC6Qy+Dthl1bTxiMZnG/YxWDiX/sHqBU
	Ih8jn27/LfpZjE
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262673817.9534.37.camel@marge.simson.net>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 05 Jan 2010 12:49:53 +0100
Message-Id: <1262692193.15426.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 07:43 +0100, Mike Galbraith wrote:
> On Tue, 2010-01-05 at 04:44 +0100, Mike Galbraith wrote:
> > On Tue, 2010-01-05 at 10:48 +0800, Lin Ming wrote:
> > > On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > > > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > > > Author: Lin Ming <ming.m.lin@intel.com>
> > > > Date:   Mon Jan 4 14:14:50 2010 +0800
> > > > 
> > > >     sched: Pass affine target cpu into wake_affine
> > > >     
> > > >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> > > >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> > > >     instead of current cpu.
> > > >     But wake_affine still use current cpu to calculate load which is wrong.
> > > >     
> > > >     This patch passes affine cpu into wake_affine.
> > > >     
> > > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > 
> > > Mike,
> > > 
> > > Any comment of this patch?
> > 
> > The patch definitely looks like the right thing to do, but when I tried
> > this, it didn't work out well.  Since I can't seem to recall precise
> > details, I'll let my box either remind me or give it's ack.
> 
> Unfortunately, box reminded me.  mysql+oltp peak throughput with
> nr_clients == nr_cpus
> 
> tip   37012.34
> tip+  33025.83
>           .892
> 
> We really only want to check for shared cache on ramp-up and/or longish
> intermission.  Once there's enough work to go around, interleaving is a
> big problem for these synchronous tasks.  Doing the silly thing gets us
> the ramp-up gain without too much pain, though there is definitely pain
> for very fast switchers.
> 
> Looking always costs you a cache miss, not looking costs you throughput
> on ramp/intermission.  Damned if you do, damned if you don't.

FWIW, I'm almost tempted to submit the sched_fair.c bit of the below
even though it costs almost 2% of mysql+oltp peak.  Notice the TCP
numbers went from erratic to stable in the second series of three .33
runs (sched_fair.c bits added), and other microbench improvements.

These bits also gave tbench a little boost.  Cuts wakeup overhead a bit,
which everything appreciates, but still delivers instant affine cpu when
it counts the most.

reference numbers are virgin 31.9.

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge     Linux 2.6.31. 2853 2923 1132 2829.3 4761.9 1235.0 1234.4 4472 1683.
marge     Linux 2.6.31. 2839 2921 1141 2846.5 4779.8 1242.5 1235.9 4455 1684.
marge     Linux 2.6.31. 2838 2935 751. 2838.5 4820.0 1243.6 1235.0 4472 1684.

marge     Linux 2.6.33- 3070 5167 2936 2819.3 4772.9 1231.7 1228.2 4381 1681.
marge     Linux 2.6.33- 3033 5047 2013 2803.0 4745.5 1355.3 1236.5 4461 1665.
marge     Linux 2.6.33- 3061 5176 1145 2800.9 4737.6 1237.6 1233.1 4404 1685.

marge     Linux 2.6.33- 3084 5173 2917 2813.7 4788.5 1340.8 1349.0 4460 1760.
marge     Linux 2.6.33- 3079 5152 2928 2839.2 4795.6 1328.6 1316.7 4438 1752.
marge     Linux 2.6.33- 3082 5173 2924 2808.1 4811.4 1348.6 1326.0 4479 1772.

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 57e6357..5b81156 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched.c b/kernel/sched.c
index 22c14eb..427ebf3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2380,10 +2380,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 	smp_wmb();
 	rq = orig_rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
 
+	update_rq_clock(rq);
+
 	if (p->se.on_rq)
 		goto out_running;
 
@@ -2414,7 +2415,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 		set_task_cpu(p, cpu);
 
 	rq = __task_rq_lock(p);
-	update_rq_clock(rq);
+
+	if (cpu != orig_cpu)
+		update_rq_clock(rq);
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..20f58ec 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1453,11 +1453,14 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int want_affine = 0;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
+	int ramp;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		    cpumask_test_cpu(cpu, &p->cpus_allowed)) {
 			want_affine = 1;
+			ramp = this_rq()->nr_running == 1;
+		}
 		new_cpu = prev_cpu;
 	}
 
@@ -1508,8 +1511,11 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (ramp && tmp->flags & SD_SHARE_PKG_RESOURCES) {
 				target = select_idle_sibling(p, tmp, target);
+				if (target >= 0)
+					ramp++;
+			}
 
 			if (target >= 0) {
 				if (tmp->flags & SD_WAKE_AFFINE) {
@@ -1544,7 +1550,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
+	if (affine_sd && (ramp > 1 || wake_affine(affine_sd, p, sync)))
 		return cpu;
 
 	while (sd) {


