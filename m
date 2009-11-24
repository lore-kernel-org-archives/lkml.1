Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbZKXSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbZKXSgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933799AbZKXSgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:36:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:56362 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933788AbZKXSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:36:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gBgdSdvxger4v5Suc4QXgijJ7/mrFFqoTYrOkvX
	c3yBBfVLun45gx
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259087245.4531.1767.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
	 <1259082449.15249.90.camel@marge.simson.net>
	 <1259084140.4531.1710.camel@laptop>  <1259085280.4531.1730.camel@laptop>
	 <1259086901.15249.121.camel@marge.simson.net>
	 <1259087245.4531.1767.camel@laptop>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 19:36:07 +0100
Message-Id: <1259087767.17066.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 19:27 +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 19:21 +0100, Mike Galbraith wrote:
> > On Tue, 2009-11-24 at 18:54 +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-11-24 at 18:35 +0100, Peter Zijlstra wrote:
> > > > On Tue, 2009-11-24 at 18:07 +0100, Mike Galbraith wrote:
> > > > > >       if (p->sched_class->task_new) {
> > > > > >               /* can detect migration through: task_cpu(p) != smp_processor_id() */
> > > > > 
> > > > > What if the parent was migrated before we got here?
> > > > 
> > > > Well, the only case it really matters for is the child_runs_first crap,
> > > > which is basically broken on SMP anyway, so I don't think we care too
> > > > much if we race here.
> > > > 
> > > > Unless I missed some detail that is ;-)
> > > 
> > > 
> > > Also, we're running all this from the parent context, and we have
> > > preemption disabled, we're not going anywhere.
> > 
> > In sched_fork() and wake_up_new_process(), but in between?
> 
> Hmm, right, back to the previous argument then ;-)

Yeah.

We can be preempted between original task struct copy and getting to
sched_fork(), and after leaving copy_process(), so I don't see any way
around lock parent, update and copy vruntime.  Whether we race in
placing the child wrt parent isn't a big deal, but the child's vruntime
is, as is fiddling with the parent's task struct and runqueue.

	-Mike

