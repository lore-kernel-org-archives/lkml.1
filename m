Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYHMQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYHMQhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYHMQhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:37:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41353 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYHMQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:37:38 -0400
Date: Wed, 13 Aug 2008 09:37:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-rt-users@vger.kernel.org,
       =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>
Subject: Re: 2.6.26-rt1
Message-ID: <20080813163728.GC6593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <200807301101.32417.j.mell@t-online.de> <20080801211117.GD14851@linux.vnet.ibm.com> <200808131530.33130.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808131530.33130.jbe@pengutronix.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 03:30:32PM +0200, Juergen Beisert wrote:
> On Freitag, 1. August 2008, Paul E. McKenney wrote:
> > On Wed, Jul 30, 2008 at 11:01:32AM +0200, Jürgen Mell wrote:
> > > On Wednesday, 30. July 2008, Thomas Gleixner wrote:
> > > > We are pleased to announce the 2.6.26-rt1 tree, which can be
> > > > downloaded from the location:
> > >
> > > I have tried the new kernel and have some good news and some bad news:
> > >
> > > The good news: The machine boots and seems to run without major problems.
> > >
> > > The bad news: It produces continuously lots of bug messages in the error
> > > logs (cf. attached dmesg.tgz). The error at rtmutex.c:743 was already
> > > present in 2.6.25-rt* when ACPI was enabled. The 'using smp_processor_id
> > > ()  in preemptible code' is new here with 2.6.26.
> > >
> > > Machine is an old Athlon XP (single core) on an EPOX mainboard with VIA
> > > chipset.
> > >
> > > If I can help with testing, please let me know.
> >
> > The following patch should clear things up.  It is against 2.6.25.8-rt7,
> > but should still apply.
> >
> > ------------------------------------------------------------------------
> >
> > Disable preemption around statistics for RCU boost and unboost calls.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >
> >  rcupreempt-boost.c |   20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff -urpNa -X dontdiff linux-2.6.25.8-rt7/kernel/rcupreempt-boost.c
> > linux-2.6.25.8-rt7-preemptfix/kernel/rcupreempt-boost.c ---
> > linux-2.6.25.8-rt7/kernel/rcupreempt-boost.c	2008-06-24 14:14:52.000000000
> > -0700 +++
> > linux-2.6.25.8-rt7-preemptfix/kernel/rcupreempt-boost.c	2008-06-24
> > 14:38:59.000000000 -0700 @@ -205,11 +205,23 @@
> > RCU_BOOST_TRACE_FUNC_DECL(boost_readers)
> >  RCU_BOOST_TRACE_FUNC_DECL(try_unboost_readers)
> >  RCU_BOOST_TRACE_FUNC_DECL(unboost_readers)
> >  RCU_BOOST_TRACE_FUNC_DECL(over_taken)
> > +static void rcu_trace_boost_boost_called_preempt(void)
> > +{
> > +	preempt_disable();
> > +	rcu_trace_boost_boost_called(RCU_BOOST_ME);
> > +	preempt_enable();
> > +}
> > +static void rcu_trace_boost_unboost_called_preempt(void)
> > +{
> > +	preempt_disable();
> > +	rcu_trace_boost_unboost_called(RCU_BOOST_ME);
> > +	preempt_enable();
> > +}
> >  #else /* CONFIG_RCU_TRACE */
> >  /* These were created by the above macro "RCU_BOOST_TRACE_FUNC_DECL" */
> > -# define rcu_trace_boost_task_boost_called(rbd) do { } while (0)
> > +# define rcu_trace_boost_task_boost_called_preempt(rbd) do { } while (0)
> >  # define rcu_trace_boost_task_boosted(rbd) do { } while (0)
> > -# define rcu_trace_boost_boost_called(rbd) do { } while (0)
> > +# define rcu_trace_boost_boost_called_preempt(rbd) do { } while (0)
> >  # define rcu_trace_boost_try_boost(rbd) do { } while (0)
> >  # define rcu_trace_boost_boosted(rbd) do { } while (0)
> >  # define rcu_trace_boost_unboost_called(rbd) do { } while (0)
> > @@ -261,7 +273,7 @@ void __rcu_preempt_boost(void)
> >
> >  	WARN_ON(!current->rcu_read_lock_nesting);
> >
> > -	rcu_trace_boost_boost_called(RCU_BOOST_ME);
> > +	rcu_trace_boost_boost_called_preempt();
> >
> >  	/* check to see if we are already boosted */
> >  	if (unlikely(rcu_is_boosted(curr)))
> > @@ -313,7 +325,7 @@ void __rcu_preempt_unboost(void)
> >  	int prio;
> >  	unsigned long flags;
> >
> > -	rcu_trace_boost_unboost_called(RCU_BOOST_ME);
> > +	rcu_trace_boost_unboost_called_preempt();
> >
> >  	/* if not boosted, then ignore */
> >  	if (likely(!rcu_is_boosted(curr)))
> >
> Using this patch on top of 2.6.26-rt1 results into:
> 
> [...]
>  CC      kernel/rcupreempt-boost.o
> kernel/rcupreempt-boost.c: In function 'rcu_boost_task':
> kernel/rcupreempt-boost.c:249: error: implicit declaration of function 'rcu_trace_boost_task_boost_called'
> kernel/rcupreempt-boost.c: In function '__rcu_preempt_unboost':
> kernel/rcupreempt-boost.c:328: error: implicit declaration of function 'rcu_trace_boost_unboost_called_preempt'
> 
> when CONFIG_PREEMPT_RCU_BOOST is enabled and target is a PowerPC of
> type MPC5200B.

Ah, 2.6.26-rt1 took a different approach to fix the issue my patch
was targeted at.  Please accept my apologies for the noise!

The other thing to try would be Chirag Jog's patch sent out to
linux-rt-users on July 30.

						Thanx, Paul
