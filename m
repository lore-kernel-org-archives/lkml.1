Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087Ab0AMQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0AMQr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051Ab0AMQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:47:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0AMQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:47:25 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Dario Faggioli <faggioli@gandalf.sssup.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1263400341.3853.287.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262097042.7135.150.camel@laptop>
	 <1263400341.3853.287.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:47:01 +0100
Message-ID: <1263401221.4244.250.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 17:32 +0100, Dario Faggioli wrote:
> On Tue, 2009-12-29 at 15:30 +0100, Peter Zijlstra wrote:
> > On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > > +struct task_struct *pick_next_task_deadline(struct rq *rq)
> > > +{
> > > +       struct sched_dl_entity *dl_se;
> > > +       struct task_struct *p;
> > > +       struct dl_rq *dl_rq;
> > > +
> > > +       dl_rq = &rq->dl;
> > > +
> > > +       if (likely(!dl_rq->dl_nr_running))
> > > +               return NULL;
> > > +
> > > +       dl_se = pick_next_deadline_entity(rq, dl_rq);
> > > +       BUG_ON(!dl_se);
> > > +
> > > +       p = deadline_task_of(dl_se);
> > > +       p->se.exec_start = rq->clock;
> > > +#ifdef CONFIG_SCHED_HRTICK
> > > +       if (hrtick_enabled(rq))
> > > +               start_hrtick_deadline(rq, p);
> > > +#endif
> > > +       return p;
> > > +} 
> > 
> > I'm not sure about actually using hrtick like this, I'd expect
> > SCHED_DEADLINE to always use hrtimers when available.  The only reason
> > to use some of the hrtick infrastructure is to re-use the hrtick_start()
> > logic which uses IPIs to ensure we program the timer on the right cpu
> > (so we can schedule from it).
> > 
> Yeah, that and the fact that it seemed to me very easy and clean to:
> - check for runtime enforcement inside the task_tick_deadline function,
>   as other scheduling classes do, and then
> - if possible, ask that task_tick_deadline function to be called right 
>   at the time instant I expect my runtime to be depleted. If that won't 
>   happen --because of no-hrtick or no-hires-hrtimers-- the check will
>   still be performed during the next tick.
> 
> > The whole IPI mess requires USE_GENERIC_SMP_HELPERS, which makes
> > CONFIG_HRTICK useful (ensures we have hrtimers enabled and have generic
> > IPI bits)
> > 
> > The problem is that things like hrtick_enabled() also check
> > sched_feat(HRTICK) which is disabled by default (because programming the
> > clock hw on each schedule was found too expensive) but that should not
> > stop SCHED_DEADLINE from using it.
> > 
> Mmm... I might have lost you here... :-(

I had a little chat with fabio around new-years and I think we ended up
agreeing that your current usage is ok, we can always fix it up later.

Its an unfortunate complicated dance of hrtimer being configured in,
having capable hardware and dealing with all the fallout cases.

The only thing which is unfortunate for your current usage is the
sched_feat(HRTICK) thing, we generally do not want HRTICK for
SCHED_OTHER, whereas we'd always (when configured and having capable
hardware) want if for SCHED_DEADLINE..

