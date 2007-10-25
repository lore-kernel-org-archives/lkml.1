Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbXJYRhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbXJYRhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXJYRh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:37:27 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53409 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbXJYRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:37:26 -0400
Date: Thu, 25 Oct 2007 13:36:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 3/3] RT: CPU priority management
In-Reply-To: <1193333198.4021.24.camel@ghaskins-t60p.haskins.net>
Message-ID: <Pine.LNX.4.58.0710251332470.8874@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net> 
 <20071025144633.19876.10342.stgit@novell1.haskins.net> 
 <Pine.LNX.4.58.0710251124370.5639@gandalf.stny.rr.com>
 <1193333198.4021.24.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 25 Oct 2007, Gregory Haskins wrote:

> Oh crap.  I just realized this is an older version of the patch..mustv'e
> forgot to refresh...grr.  Ill send out the refreshed one.

Been there, done that ;-)

>
> But anyway, I digress.
>
> On Thu, 2007-10-25 at 11:27 -0400, Steven Rostedt wrote:
>
> >
> > The cpu_priority and the cp->lock will be aboslutely horrible for
> > cacheline bouncing.
>
> In the form presented here in this email, perhaps.  I think you will see
> some significant improvements in the refreshed version.  The big change
> is that the global lock is gone.
>
> >   Ironically, this will kill performance for the very
> > machines this code is to help with.  The larger the number of CPUs you
> > have the more cacheline bouncing this code will create.
>
> Don't forget:  The same is precisely true for the current -rt2
> algorithm.  For instance, the -rt2 algorithm aside from being linear in
> general, scales cacheline bouncing linearly as well.  Each cpu is going
> to trash rq->rt.highest_prio and then we will walk them for each scan.

Yep, -rt2 (and -rt3) are both horrible too. That's why I'm working on a
sched-domain version now to handle that.

>
> The fact is, you can't maintain a global dynamic policy without bouncing
> cachelines, period.  But hopefully we can minimize it, and I just want
> to see the fastest code here.

Well, we need a balance between cacheline hits, and where to pull from.
As performance goes, the two are inverse perportional. The secret is to
find a nice middle ground.

>
> >
> > I still don't see the benefit from the cpupri code.
>
> I still owe you timing data, but at this juncture I think I can beat
> linear (especially as we start throwing in big-iron) ;)  I originally
> got involved in this scheduler rework from observations of poor scaling
> on our 8/16-ways, so I want it to scale as much as you ;)  If this alg
> doesn't pan out, that's cool.  But I think it will in the end.  Linear
> algs in the fast path just make my skin crawl.  Perhaps it will still be
> the best design in the end, but I am not giving up that easy until I
> prove it to myself.

It's only linear in respect to the size of the domain or cpus allowed. Any
8/16 way boxes worried about cacheline bouncing need to reign in on the
cpus allowed mask. Otherwise, we would simply have bouncing anyway with
the tasks themselves.

-- Steve

