Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZBWRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZBWRC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZBWRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:02:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49035 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZBWRCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:02:19 -0500
Date: Mon, 23 Feb 2009 07:56:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223155605.GC6751@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <20090223090735.GH9582@elte.hu> <20090223011712.853aa94d.akpm@linux-foundation.org> <20090223092744.GL9582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223092744.GL9582@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:27:44AM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 23 Feb 2009 10:07:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > ---
> > > > 
> > > >  init/main.c         |    3 +++
> > > >  kernel/rcuclassic.c |    4 +++-
> > > >  kernel/rcutree.c    |    4 +++-
> > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/init/main.c b/init/main.c
> > > > index 8442094..51f4b71 100644
> > > > --- a/init/main.c
> > > > +++ b/init/main.c
> > > > @@ -121,6 +121,8 @@ static char *static_command_line;
> > > >  static char *execute_command;
> > > >  static char *ramdisk_execute_command;
> > > >  
> > > > +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> > > > +
> > > >  #ifdef CONFIG_SMP
> > > >  /* Setup configured maximum number of CPUs to activate */
> > > >  unsigned int __initdata setup_max_cpus = NR_CPUS;
> > > > @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
> > > >  	 * at least once to get things moving:
> > > >  	 */
> > > >  	init_idle_bootup_task(current);
> > > > +	idle_task_is_really_idle = 1;
> > > >  	preempt_enable_no_resched();
> > > >  	schedule();
> > > >  	preempt_disable();
> > > 
> > > Could you please use system_state instead? We could insert a new 
> > > stage - or just use SYSTEM_RUNNING as the trigger.
> > 
> > I think the standalone flag is better (once those 
> > extern-decls-in-C get fixed).
> > 
> > system_state's semantics have, err, evolved over time.  If 
> > this happens again (and the patch sneaks past my attention) 
> > then there's a risk that code which depends upon system_state 
> > will break - this has happened in the past.  Plus piling more 
> > dependencies on system_state of course makes any evolution of 
> > its semantics harder to do...
> 
> All we need is a SYSTEM_BOOTING_EARLY boundary - prior which 
> there's no real scheduling yet. I used SYSTEM_SCHEDULER_BOOTING 
> state before and it worked well and wasnt fragile.
> 
> Our system_state semantics problems were more rooted in the fact 
> that the SYSTEM_BOOTING stage wasnt well defined. But if we did 
> a SYSTEM_SCHEDULER_BOOTING stage that would be pretty 
> bit-rot-safe.

Actually, I should be able to simply use (system_state != SYSTEM_BOOTING),
because the system state transitions to SYSTEM_RUNNING at essentially
the same place that I set my new global variable.  Especially given that
this approach saves others from any bad guesses I might make about the
existing uses of SYSTEM_BOOTING.  ;-)

I will also credit kmemcheck on the resulting patch.

							Thanx, Paul
