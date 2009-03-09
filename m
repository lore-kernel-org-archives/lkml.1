Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZCIR2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZCIR2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZCIR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:28:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:35645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751223AbZCIR2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:28:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18k+35zTykkzw5NEcgmYGkEloFyZD15rNTC6JvmB1
	oRifKcvxRL6f9c
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236615158.8389.705.camel@laptop>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
	 <1236605870.6515.5.camel@marge.simson.net>
	 <1236606389.8389.518.camel@laptop>
	 <1236607083.5980.8.camel@marge.simson.net>
	 <1236607890.6168.7.camel@marge.simson.net>
	 <1236609711.8389.583.camel@laptop>
	 <1236612649.6019.38.camel@marge.simson.net>
	 <1236615158.8389.705.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 18:28:14 +0100
Message-Id: <1236619694.5998.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 17:12 +0100, Peter Zijlstra wrote:
> On Mon, 2009-03-09 at 16:30 +0100, Mike Galbraith wrote:
> > +static void put_prev_task(struct rq *rq, struct task_struct *prev)
> > +{
> > +       if (prev->state == TASK_RUNNING) {
> > +               u64 runtime = prev->se.sum_exec_runtime;
> > +
> > +               runtime -= prev->se.prev_sum_exec_runtime;
> > +               runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
> > +
> > +               /*
> > +                * In order to avoid avg_overlap growing stale when we are
> > +                * indeed overlapping and hence not getting put to sleep, grow
> > +                * the avg_overlap on preemption.
> > +                */
> > +               update_avg(&prev->se.avg_overlap, runtime);
> > +       }
> > +       prev->sched_class->put_prev_task(rq, prev);
> > +}
> 
> Right, so we both found it worked quite well, I'm still slightly puzzled
> but it.
> 
> If something gets preempted a lot and will therefore have short runtimes
> it will be seen as sync even though it might not at all be.

Yes, and the netperf on 2 CPUs with shared cache numbers show that's
happening.  It just so happens that in the non-shared case, netperf's
cache pain far outweighs the benefit of having more CPU available :-/

	-Mike

