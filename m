Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZL2ObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZL2ObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZL2ObV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:31:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:57780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZL2ObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:31:20 -0500
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
In-Reply-To: <1255707614.6228.453.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 15:30:42 +0100
Message-ID: <1262097042.7135.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> +struct task_struct *pick_next_task_deadline(struct rq *rq)
> +{
> +       struct sched_dl_entity *dl_se;
> +       struct task_struct *p;
> +       struct dl_rq *dl_rq;
> +
> +       dl_rq = &rq->dl;
> +
> +       if (likely(!dl_rq->dl_nr_running))
> +               return NULL;
> +
> +       dl_se = pick_next_deadline_entity(rq, dl_rq);
> +       BUG_ON(!dl_se);
> +
> +       p = deadline_task_of(dl_se);
> +       p->se.exec_start = rq->clock;
> +#ifdef CONFIG_SCHED_HRTICK
> +       if (hrtick_enabled(rq))
> +               start_hrtick_deadline(rq, p);
> +#endif
> +       return p;
> +} 

I'm not sure about actually using hrtick like this, I'd expect
SCHED_DEADLINE to always use hrtimers when available.  The only reason
to use some of the hrtick infrastructure is to re-use the hrtick_start()
logic which uses IPIs to ensure we program the timer on the right cpu
(so we can schedule from it).

The whole IPI mess requires USE_GENERIC_SMP_HELPERS, which makes
CONFIG_HRTICK useful (ensures we have hrtimers enabled and have generic
IPI bits)

The problem is that things like hrtick_enabled() also check
sched_feat(HRTICK) which is disabled by default (because programming the
clock hw on each schedule was found too expensive) but that should not
stop SCHED_DEADLINE from using it.



