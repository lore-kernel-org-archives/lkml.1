Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYLPHVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYLPHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYLPHVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:21:44 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:41201 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYLPHVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:21:43 -0500
Date: Tue, 16 Dec 2008 12:55:02 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 4/7] sched: bias task wakeups to preferred
	semi-idle packages
Message-ID: <20081216072502.GW5457@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com> <20081211174304.2020.14746.stgit@drishya.in.ibm.com> <20081215070139.GE18403@balbir.in.ibm.com> <1229329521.14605.17.camel@twins> <1229329984.14605.18.camel@twins> <20081215084642.GJ18403@balbir.in.ibm.com> <20081215122529.GR5457@dirshya.in.ibm.com> <661de9470812151002h15e523b0s85bf1537d6e7f5fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <661de9470812151002h15e523b0s85bf1537d6e7f5fe@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-12-15 23:32:36]:

> >> > > Sure its racy, but so what?
> >> > >
> >> > > The worst I can see it that we exclude a dying task from this logic,
> >> > > which isn't a problem at all, since its dying anyway.
> >> >
> >> > At which point I seriously doubt it'd still be on the rq anyway.
> >> >
> >>
> >> I forgot to mention that, the check should be (p->mm && !(p->flags & PF_KTHREAD))
> >
> > I can check for PF_KTHREAD for now.  However, I should reduce the
> > number of checks since this may slow down wake_idle for sched_mc=2.
> >
> > We can tolerate p->mm check on a dying process as Peter has suggested,
> > hence we don't need to protect it.  We are not going to access any
> > contents of the mm struct.
> >
> > If PF_KTHREAD is only being used by AIO, then I feel we can drop the
> > check since the threads will not have affinity and they can be moved
> > to other cpus anyway.
> >
> > The main reason for skipping kthread is that they may be using per-cpu
> > variables and sleep/preempted.  I did not want the wake_idle() logic
> > to move them around forcefully.  This is not the general case and this
> > situation should not happen.
> >
> > Second reason is to optimise on the affinity check since most of the
> > kthreads have affinity and cannot be moved.
> >
> > This condition check needs optimisation after getting the framework
> > functionally correct and useful.
> 
> 
> Vaidy, you (or your mailer) seem to have dropped me off of the to/cc
> list while replying and this seems to be the case for all replies.

Hi Balbir,

Thanks for pointing that out.  I will review my mutt setup.  This is
strange... since a group-reply to this message puts you in the to list
as expected, but not the ones that I sent earlier in reply to your
messages.  The header seems to be correct for others except for your
message :(

--Vaidy
