Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbZL2M0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbZL2M0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZL2M0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:26:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:56391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZL2M0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:26:17 -0500
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
Date: Tue, 29 Dec 2009 13:25:38 +0100
Message-ID: <1262089538.7135.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> @@ -5966,10 +5982,14 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
>         if (running)
>                 p->sched_class->put_prev_task(rq, p);
>  
> -       if (rt_prio(prio))
> -               p->sched_class = &rt_sched_class;
> -       else
> -               p->sched_class = &fair_sched_class;
> +       if (deadline_task(p))
> +               p->sched_class = &deadline_sched_class;
> +       else {
> +               if (rt_prio(prio))
> +                       p->sched_class = &rt_sched_class;
> +               else
> +                       p->sched_class = &fair_sched_class;
> +       } 

This looks wrong.

This is PI code, so the effective class should be determined based on
the 'priority' not on the 'policy'.

I understand we don't yet have deadline inheritance like things in
place, but this would be where we should make use of the simple ceiling
protocol to boost things for now.


