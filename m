Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZJ0Ofi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZJ0Ofi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZJ0Ofh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:35:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:33680 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754222AbZJ0Ofg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:35:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18BYnxpli4BUo8zkBccLFAIA7gwdCDZUnapjKuGE8
	UtvuCh4rHXiu5r
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256522035.7356.19.camel@laptop>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
Content-Type: text/plain
Date: Tue, 27 Oct 2009 15:35:38 +0100
Message-Id: <1256654138.17752.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 02:53 +0100, Peter Zijlstra wrote:
> On Sun, 2009-10-25 at 23:04 +0100, Mike Galbraith wrote:
> >                 if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
> > -                   cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
> > +                               (level == SD_LV_SIBLING || level == SD_LV_MC)) {
> 
> quick comment without actually having looked at the patch, we should
> really get rid of sd->level and encode properties of the sched domains
> in sd->flags.

I used SD_PREFER_SIBLING in the below.  Did I break anything?

(wonder what it does for pgsql+oltp on beefy box with siblings)

tip v2.6.32-rc5-1724-g77a088c

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip           9999.77   18472.11   34931.60   34412.09   33006.76   32104.36   30700.47   28111.31   25535.09
             10082.75   18625.12   34928.17   34476.91   33088.70   32002.36   30695.77   28173.94   25551.05
              9949.05   18466.54   34942.66   34420.74   33092.45   32041.10   30666.43   28090.90   25467.63
tip avg      10010.52   18521.25   34934.14   34436.58   33062.63   32049.27   30687.55   28125.38   25517.92

tip+          9622.23   18297.65   34496.12   34230.85   32704.20   31796.54   30480.45   27740.20   25394.12
             10207.79   18275.83   34622.39   34222.47   32996.69   31936.48   30551.29   28144.48   25616.62
             10225.32   18515.02   34538.41   34278.06   33014.14   31965.31   30363.90   28089.41   25531.81
tip+ avg     10018.44   18362.83   34552.30   34243.79   32905.01   31899.44   30465.21   27991.36   25514.18
vs tip          1.000       .991       .989       .994       .995       .995       .992       .995       .999

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13945.42   26973.91   52504.18   52613.32   51310.82   50442.61   49826.52   48760.62   45570.45
             13921.41   27021.48   52722.64   52565.16   51483.19   50638.83   49499.51   48621.31   46115.77
             13924.94   26961.02   52624.45   52365.49   51384.91   50499.44   49622.83   48065.03   45743.14
tip avg      13930.59   26985.47   52617.09   52514.65   51392.97   50526.96   49649.62   48482.32   45809.78

tip+         15259.79   29162.31   52609.01   52562.16   51578.48   50631.90   49537.41   48376.23   46058.95
             15156.54   29114.10   52760.02   52524.86   51412.94   50656.30   48774.34   47968.77   45905.02
             15118.64   29190.73   52929.34   52503.58   51574.34   50232.27   49599.15   48283.42   45766.74
tip+ avg     15178.32   29155.71   52766.12   52530.20   51521.92   50506.82   49303.63   48209.47   45910.23
vs tip          1.089      1.080      1.002      1.000      1.002       .999       .993       .994      1.002

sched: check for an idle shared cache in select_task_rq_fair()

When waking affine, check for an idle shared cache, and if found, wake to
that CPU/sibling instead of the waker's CPU.  This improves pgsql+oltp
ramp up by roughly 8%.  Possibly more for other loads, depending on overlap.
The trade-off is a roughly 1% peak downturn if tasks are truly synchronous.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1398,11 +1398,36 @@ static int select_task_rq_fair(struct ta
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+			int candidate = -1, i;
 
-			affine_sd = tmp;
-			want_affine = 0;
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
+				candidate = cpu;
+
+			/*
+			 * Check for an idle shared cache.
+			 */
+			if (tmp->flags & SD_PREFER_SIBLING) {
+				if (candidate == cpu) {
+					if (!cpu_rq(prev_cpu)->cfs.nr_running)
+						candidate = prev_cpu;
+				}
+
+				if (candidate == -1 || candidate == cpu) {
+					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpu_rq(i)->cfs.nr_running) {
+							candidate = i;
+							break;
+						}
+					}
+				}
+			}
+
+			if (candidate >= 0) {
+				affine_sd = tmp;
+				want_affine = 0;
+				cpu = candidate;
+			}
 		}
 
 		if (!want_sd && !want_affine)


