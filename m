Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222Ab0AGNOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0AGNOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022Ab0AGNOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:14:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:56644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751839Ab0AGNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:14:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+VaGwy3FaVKI3Y73Fhz5U0XMPDJnoNtvEpGv9d58
	MTKpb0LEkKuMBa
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262853903.18931.17.camel@minggr.sh.intel.com>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
	 <1262853903.18931.17.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 14:14:15 +0100
Message-Id: <1262870055.9337.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 16:45 +0800, Lin Ming wrote:
> On Tue, 2010-01-05 at 14:43 +0800, Mike Galbraith wrote:
> > On Tue, 2010-01-05 at 04:44 +0100, Mike Galbraith wrote:
> > > On Tue, 2010-01-05 at 10:48 +0800, Lin Ming wrote:
> > > > On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > > > > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > > > > Author: Lin Ming <ming.m.lin@intel.com>
> > > > > Date:   Mon Jan 4 14:14:50 2010 +0800
> > > > > 
> > > > >     sched: Pass affine target cpu into wake_affine
> > > > >     
> > > > >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> > > > >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> > > > >     instead of current cpu.
> > > > >     But wake_affine still use current cpu to calculate load which is wrong.
> > > > >     
> > > > >     This patch passes affine cpu into wake_affine.
> > > > >     
> > > > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > > 
> > > > Mike,
> > > > 
> > > > Any comment of this patch?
> > > 
> > > The patch definitely looks like the right thing to do, but when I tried
> > > this, it didn't work out well.  Since I can't seem to recall precise
> > > details, I'll let my box either remind me or give it's ack.
> > 
> > Unfortunately, box reminded me.  mysql+oltp peak throughput with
> > nr_clients == nr_cpus
> 
> Did you test with your vmark regression fix patch also applied?

Below is a complete retest.  Mind testing my hacklet?  I bet a nickle
it'll work at least as well as yours on your beefy boxen.

Everything is a trade, but I wonder what your patch puts on the table
that mine doesn't.  Mine trades a bit of peak for better ramp just as
yours does (not as much pain, for more gain on my box), but cuts out
overhead when there's a very good chance that sage advice is unneeded,
and when a return on the investment is unlikely.  It also tosses
opportunities that might have worked out with some load, but I'm not
seeing numbers that justify the pain.  The big gain is the ramp.

The tail I don't care much about.  When mysql starts jamming up, tossing
in balancing always extends the tail.  Turn newidle loose, and it'll get
considerably better.. at the expense of just about everything else.

(all have vmark regression fix)

tip = v2.6.33-rc3-260-gadd8174
tip+ = pass affine target
tip++ = ramp

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10097.67   19850.62   36652.15   36175.93   35131.83   33968.09   32264.10   28861.89   25264.55
             10360.76   19969.69   37217.48   36679.43   35670.86   34281.49   32575.91   28424.81   24415.42
             10254.75   19732.79   37122.05   36523.65   35500.15   34181.83   32508.23   28182.73   23319.44
tip avg      10237.72   19851.03   36997.22   36459.67   35434.28   34143.80   32449.41   28489.81   24333.13

tip+         10994.71   20056.54   32689.38   36210.83   35372.91   34277.60   32629.49   28264.63   26220.13
             11025.81   20084.65   32709.84   36671.23   35789.21   34602.03   32849.03   29198.10   25902.69
             11002.07   20148.40   32257.20   36627.57   35859.69   35859.69   32871.66   29160.72   26346.97
tip+ avg     11007.53   20096.53   32552.14   36503.21   35673.93   34913.10   32783.39   28874.48   26156.59
vs tip          1.075      1.012       .879      1.001      1.006      1.022      1.010      1.013      1.074


tip++        10841.88   20578.16   36161.14   36330.32   35552.39   34178.19   32181.05   27447.47   25213.32
             11101.92   20912.30   36471.23   36850.12   35749.46   34518.61   32921.50   28669.84   24672.39
             11116.54   20899.96   36553.23   36853.72   35859.07   34572.91   32887.71   28518.16   25535.70
tip+ avg     11020.11   20796.80   36395.20   36678.05   35720.30   34423.23   32663.42   28211.82   25140.47
vs tip          1.076      1.047       .983      1.005      1.008      1.008      1.006       .990      1.033
vs tip+         1.001      1.034      1.118      1.004      1.001       .985       .996       .977       .961

(combo pack)

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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..1f9cc7a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1450,14 +1450,16 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, ramp = 0;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		    cpumask_test_cpu(cpu, &p->cpus_allowed)) {
 			want_affine = 1;
+			ramp = this_rq()->nr_running == 1;
+		}
 		new_cpu = prev_cpu;
 	}
 
@@ -1508,8 +1510,11 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
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
@@ -1544,7 +1549,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
+	if (affine_sd && (ramp > 1 || wake_affine(affine_sd, p, sync)))
 		return cpu;
 
 	while (sd) {


