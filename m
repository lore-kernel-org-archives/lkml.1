Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYHaTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYHaTXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYHaTXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:23:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39127 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbYHaTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:23:12 -0400
Date: Sun, 31 Aug 2008 12:23:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
Message-ID: <20080831192309.GB30283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200808311809.m7VI9whf014532@mail.q-ag.de> <20080831191721.GH7015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831191721.GH7015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 12:17:21PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 31, 2008 at 07:58:49PM +0200, Manfred Spraul wrote:
> > When a cpu is taken offline, the CPU_DYING notifiers are called on the
> > dying cpu. According to <linux/notifiers.h>, the cpu should be "not
> > running any task, not handling interrupts, soon dead".
> > 
> > For the current implementation, this is not true:
> > - __cpu_disable can fail. If it fails, then the cpu will remain alive
> >   and happy.
> > - At least on x86, __cpu_disable() briefly enables the local interrupts
> >   to handle any outstanding interrupts.
> > 
> > What about moving CPU_DYING down a few lines, behind the __cpu_disable()
> > line?
> > There are only two CPU_DYING handlers in the kernel right now: one in
> > kvm, one in the scheduler. Both should work with the patch applied
> > [and: I'm not sure if either one handles a failing __cpu_disable()]
> > 
> > The patch survives simple offlining a cpu. kvm untested due to lack
> > of a test setup.
> 
> Several architectures re-enable interrupts in __cpu_disable() or in
> functions called from __cpu_disable(), which happens after CPU_DYING,
> if I understand correctly.  :-(

Never mind -- you are moving CPU_DYING after __cpu_disable().  :-/

							Thanx, Paul

> > Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
> > ---
> >  kernel/cpu.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index e202a68..5b7c88f 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -199,13 +199,14 @@ static int __ref take_cpu_down(void *_param)
> >  	struct take_cpu_down_param *param = _param;
> >  	int err;
> > 
> > -	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
> > -				param->hcpu);
> >  	/* Ensure this CPU doesn't handle any more interrupts. */
> >  	err = __cpu_disable();
> >  	if (err < 0)
> >  		return err;
> > 
> > +	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
> > +				param->hcpu);
> > +
> >  	/* Force idle task to run as soon as we yield: it should
> >  	   immediately notice cpu is offline and die quickly. */
> >  	sched_idle_next();
> > -- 
> > 1.5.5.1
> > 
