Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZBWJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZBWJ2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZBWJ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:28:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZBWJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:28:01 -0500
Date: Mon, 23 Feb 2009 10:27:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223092744.GL9582@elte.hu>
References: <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <20090223090735.GH9582@elte.hu> <20090223011712.853aa94d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223011712.853aa94d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Feb 2009 10:07:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > ---
> > > 
> > >  init/main.c         |    3 +++
> > >  kernel/rcuclassic.c |    4 +++-
> > >  kernel/rcutree.c    |    4 +++-
> > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/init/main.c b/init/main.c
> > > index 8442094..51f4b71 100644
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > > @@ -121,6 +121,8 @@ static char *static_command_line;
> > >  static char *execute_command;
> > >  static char *ramdisk_execute_command;
> > >  
> > > +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> > > +
> > >  #ifdef CONFIG_SMP
> > >  /* Setup configured maximum number of CPUs to activate */
> > >  unsigned int __initdata setup_max_cpus = NR_CPUS;
> > > @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
> > >  	 * at least once to get things moving:
> > >  	 */
> > >  	init_idle_bootup_task(current);
> > > +	idle_task_is_really_idle = 1;
> > >  	preempt_enable_no_resched();
> > >  	schedule();
> > >  	preempt_disable();
> > 
> > Could you please use system_state instead? We could insert a new 
> > stage - or just use SYSTEM_RUNNING as the trigger.
> 
> I think the standalone flag is better (once those 
> extern-decls-in-C get fixed).
> 
> system_state's semantics have, err, evolved over time.  If 
> this happens again (and the patch sneaks past my attention) 
> then there's a risk that code which depends upon system_state 
> will break - this has happened in the past.  Plus piling more 
> dependencies on system_state of course makes any evolution of 
> its semantics harder to do...

All we need is a SYSTEM_BOOTING_EARLY boundary - prior which 
there's no real scheduling yet. I used SYSTEM_SCHEDULER_BOOTING 
state before and it worked well and wasnt fragile.

Our system_state semantics problems were more rooted in the fact 
that the SYSTEM_BOOTING stage wasnt well defined. But if we did 
a SYSTEM_SCHEDULER_BOOTING stage that would be pretty 
bit-rot-safe.

	Ingo
