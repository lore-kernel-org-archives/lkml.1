Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZL2Oht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZL2Oht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZL2Oht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:37:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:35423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZL2Ohs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:37:48 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
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
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262097042.7135.150.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262097042.7135.150.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 15:37:02 +0100
Message-ID: <1262097422.7135.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 15:30 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > +struct task_struct *pick_next_task_deadline(struct rq *rq)
> > +{
> > +       struct sched_dl_entity *dl_se;
> > +       struct task_struct *p;
> > +       struct dl_rq *dl_rq;
> > +
> > +       dl_rq = &rq->dl;
> > +
> > +       if (likely(!dl_rq->dl_nr_running))
> > +               return NULL;
> > +
> > +       dl_se = pick_next_deadline_entity(rq, dl_rq);
> > +       BUG_ON(!dl_se);
> > +
> > +       p = deadline_task_of(dl_se);
> > +       p->se.exec_start = rq->clock;
> > +#ifdef CONFIG_SCHED_HRTICK
> > +       if (hrtick_enabled(rq))
> > +               start_hrtick_deadline(rq, p);
> > +#endif
> > +       return p;
> > +} 
> 
> I'm not sure about actually using hrtick like this, I'd expect
> SCHED_DEADLINE to always use hrtimers when available.  The only reason
> to use some of the hrtick infrastructure is to re-use the hrtick_start()
> logic which uses IPIs to ensure we program the timer on the right cpu
> (so we can schedule from it).

Hmm I suppose we could ignore all that CONFIG_SCHED_HRTICK stuff and
simply bounce the schedule event using the resched ipi when we find
we're on the wrong cpu. Not ideal though.. frigging mess all this :-)

