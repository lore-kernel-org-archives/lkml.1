Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYHTPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYHTPPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHTPPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:15:45 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:58742 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYHTPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:15:44 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: adobriyan@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <200808210110.37204.nickpiggin@yahoo.com.au>
References: <1912217169.25608.228.camel@ymzhang>
	 <20080820143209.GA32156@x200.localdomain> <1219242796.8651.54.camel@twins>
	 <200808210110.37204.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 17:15:41 +0200
Message-Id: <1219245341.8651.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 01:10 +1000, Nick Piggin wrote:
> On Thursday 21 August 2008 00:33, Peter Zijlstra wrote:
> > On Wed, 2008-08-20 at 18:32 +0400, adobriyan@gmail.com wrote:
> > > On Wed, Aug 20, 2008 at 03:32:17PM +0200, Peter Zijlstra wrote:
> 
> > > > +#define avg(x, y) ({				\
> > > > +	typeof(x) _avg1 = ((x)+1)/2;		\
> > > > +	typeof(x) _avg2 = ((y)+1)/2;		\
> > >
> > > ITYM, typeof(y)
> >
> > you thought right, I did mean that :-)
> >
> > > > +	(void) (&_avg1 == &_avg2);		\
> > > > +	_avg1 + _avg2; })
> 
> I don't think this implementation of avg should go in kernel.h?
> 
> It gives an average of 1 and 1 to be 2, 3 and 3 is 4, 1 and 3 is
> 3 etc.
> 
> Maybe it is reasonable for very high numbers that would overflow
> if added first, but it doesn't seem reasonable for a generic
> averaging function.

I had it in sched.c, then moved it to kernel.h and back again, etc.. I'm
fine with wherever..

---
Subject: sched: load-balance bias fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Aug 20 15:28:51 CEST 2008

Yanmin spotted a regression with my patch that introduces LB_BIAS:

  commit 93b75217df39e6d75889cc6f8050343286aff4a5
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Fri Jun 27 13:41:33 2008 +0200

And I just spotted the brainfart - I should have replaced min/max with avg
instead of removing it completely.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1996,6 +1996,12 @@ void kick_process(struct task_struct *p)
 	preempt_enable();
 }
 
+#define avg(x, y) ({				\
+	typeof(x) _avg1 = ((x)+1)/2;		\
+	typeof(y) _avg2 = ((y)+1)/2;		\
+	(void) (&_avg1 == &_avg2);		\
+	_avg1 + _avg2; })
+
 /*
  * Return a low guess at the load of a migration-source cpu weighted
  * according to the scheduling class and "nice" value.
@@ -2008,9 +2014,12 @@ static unsigned long source_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0)
 		return total;
 
+	if (!sched_feat(LB_BIAS))
+		return avg(rq->cpu_load[type-1], total);
+
 	return min(rq->cpu_load[type-1], total);
 }
 
@@ -2023,9 +2032,12 @@ static unsigned long target_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0)
 		return total;
 
+	if (!sched_feat(LB_BIAS))
+		return avg(rq->cpu_load[type-1], total);
+
 	return max(rq->cpu_load[type-1], total);
 }
 


