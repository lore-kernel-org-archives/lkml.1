Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0ADK7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0ADK7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344Ab0ADK7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:59:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:36936 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752923Ab0ADK7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:59:51 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+O5CAnU4OO4LkDk6fhkWzAPNIR8r6BVYSWeEuFfG
	RwcAZknDFdjVBg
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262597566.6408.101.camel@laptop>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262597105.6408.99.camel@laptop>
	 <1262596364.22471.110.camel@minggr.sh.intel.com>
	 <1262597566.6408.101.camel@laptop>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 11:59:45 +0100
Message-Id: <1262602785.9734.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 10:32 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 17:12 +0800, Lin Ming wrote:
> > On Mon, 2010-01-04 at 17:25 +0800, Peter Zijlstra wrote:
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
> > > 
> > > Does this at all help with that regression?
> > 
> > No.
> 
> crap :/
> 
> The change does look sensible though.

I piddled with all kinds of ways to get around calling wake_affine()
entirely, and/or calling it with the affine candidate to no avail.  Best
result was always to do the silly looking thing, namely test the current
cpu for wake affine decision, but slip in the shared cache cpu.

I bet the below helps, though there will still be cache misses, so there
will still be pain for extreme switchers.  Question is whether the
ramp-up gain is worth it.  I think yes, since it's up to 100%.  Would be
most excellent to find a way to know in advance when the cost will be
too high, and then not go there.  Same applies for doing the affinity
decision every time for extreme switchers.  It's expensive for those,
especially so when they're pinned, but pays in the general case.

Anyway...

PREFER_SIBLING is set at the CPU domain level if you don't have power
saving set, so you get to eat cache misses for each cpu, whether it's
sharing a cache or not as you traverse.  Lots of CPUs, LOTS of pain.

not-signed-off

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
index 42ac3c9..8fe7ee8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1508,7 +1508,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {


