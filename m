Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZBQQFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZBQQFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZBQQFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:05:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33282 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZBQQFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:05:06 -0500
Date: Tue, 17 Feb 2009 08:05:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217160504.GF6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090216225108.GA15904@linux.vnet.ibm.com> <20090217094657.GA1845@elte.hu> <20090217140130.GA6761@linux.vnet.ibm.com> <20090217153925.GA2308@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217153925.GA2308@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 04:39:25PM +0100, Damien Wyart wrote:
> Hello Paul,
> 
> > > There's no strong reason - we've been back and forth about RCU in
> > > the dynticks code. Mind sending a test patch for Damien to try?
> 
> > But of course!  ;-)
> 
> With this patch, the problem goes away and system activity seems normal,
> both on the P4 with high load and on the recent laptop.
> 
> Btw, could you explain briefly why, without this patch, a kernel
> enabling classical RCU doesn't show the ksoftirqd problem at all?

Classic RCU's rcu_pending() can afford to be much more conservative,
due to the easy availability of global information.  In contrast,
Hierarchical RCU will invoke the softirq in cases where the information
required to make an exact decision is off somewhere else in the tree.

There is also a possibility that Hierarchical RCU is for some reason
failing to detect that its rcu_check_callbacks() is being invoked from
the idle loop -- which would need to be fixed if it is really happening.
But given that the two rcu_check_callbacks() implementations are nearly
identical, I cannot see how this is happening.  (Wouldn't be the first
time that I failed to see how something was happening, though!)

							Thanx, Paul

> Damien
> 
> > The following patch removes the call to rcu_pending() and
> > rcu_check_callbacks() from the x86 32-bit idle loop in order to
> > reduce the softirq load on idle systems.
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> 
> >  process_32.c |    3 ---
> >  1 file changed, 3 deletions(-)
> 
> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > index a546f55..bd4da2a 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -104,9 +104,6 @@ void cpu_idle(void)
> >  			check_pgt_cache();
> >  			rmb();
> 
> > -			if (rcu_pending(cpu))
> > -				rcu_check_callbacks(cpu, 0);
> > -
> >  			if (cpu_is_offline(cpu))
> >  				play_dead();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
