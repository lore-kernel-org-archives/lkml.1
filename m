Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYFEMIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYFEMIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYFEMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:07:53 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:46583 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbYFEMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:07:52 -0400
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
	have realtime uses)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: trimarchimichael@yahoo.it
Cc: Max Krasnyansky <maxk@qualcomm.com>, Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dario <faggioli@gandalf.sssup.it>
In-Reply-To: <933603.75777.qm@web26206.mail.ukl.yahoo.com>
References: <933603.75777.qm@web26206.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 14:07:40 +0200
Message-Id: <1212667660.23439.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 11:16 +0000, Michael Trimarchi wrote:
> Hi,
> 
> > > 
> > > I'm working on a partitioned EDF scheduler right
> > now, and I have to
> > > face several issues, starting from the interface to
> > use to expose the
> > > EDF scheduler to userspace, and the integration with
> > the existing
> > > sched_rt policy.
> >
> > I would add a sched_class above sched_rt and let sched_rt
> > run in all
> > unclaimed time by sched_edf.
> >
> I add this type of class before sched_rt, so the next of sched_edf
> point to sched_rt class.

Exactly.

> > Have you looked at deadline inheritance to replace PI? I
> > think it can be
> > done reasonably simple by replacing the plist with a RB
> > tree.
> I think it can be done with an rb tree.  The only tricky 
> part would be mixing tasks coming from  the sched_edf and the sched_rt
> class, but it should not be a problem.

Mapping them onto U64_MAX - prio or something like that ought to do.

Handling wraparound of the timeline might get a little involved though -
then again realtime takes 584 yrs to wrap a 64bit ns counter.

> > > By now I'm experimenting with an additional
> > sched_class that implements
> > > a SCHED_EDF policy, extending the POSIX struct
> > sched_param with the
> > > EDF parameters of the task, do you see any better way
> > to do that?
> > > Could that approach be reasonable?
> >
> > Yes, that is the way I'm leaning.
> By now I'm facing some problems.  I still have not clear what
> parameters a task forked from a sched_edf task should get, as it would
> involve some form of admission control, 

I'd start with something like:

u64 sched_param::edf_period  [ns]
u64 sched_param::edf_runtime [ns]

so that deadline = time_of_schedule + edf_period, and his allowance
within that period is edf_runtime.

fork would inherit the parent's settings, and we'd need to do admission
control on all tasks entering SCHED_EDF, either through setscheduler()
or fork(). We could fail with -ENOTIME or somesuch error.

> and how to deal with tasks that run longer than their nominal
> execution time (i.e., should we use some server mechanism to limit the
> amount of cpu they're using, or handle that in some other way?)

Yeah - we already account the amount of runtime, we can send them
SIGXCPU and stop running them. Look at the rt_bandwidth code upstream -
it basically stops rt task groups from running once their quota is
depleted - waking them up once it gets refreshed due to the period
expiring.

For single tasks its easier, just account their time and dequeue them
once it exceeds the quota, and enqueue them on a refresh timer thingy to
start them again once the period rolls over.

The only tricky bit here is PI :-) it would need to keep running despite
being over quota.

