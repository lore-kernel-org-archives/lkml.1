Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYKGQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYKGQjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYKGQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:39:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYKGQjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:39:44 -0500
Date: Fri, 7 Nov 2008 18:40:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
Message-ID: <20081107174016.GA24812@redhat.com>
References: <20081107165238.GA23055@redhat.com> <20081107162101.GA2178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107162101.GA2178@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > --- K-28/kernel/sched_stats.h~A_G_E_R_FIX	2008-11-07 17:32:02.000000000 +0100
> > +++ K-28/kernel/sched_stats.h	2008-11-07 17:44:39.000000000 +0100
> > @@ -351,10 +351,12 @@ static inline void account_group_exec_ru
> >  					      unsigned long long ns)
> >  {
> >  	struct signal_struct *sig;
> > +	unsigned long flags;
> >
> > -	sig = tsk->signal;
> > -	if (unlikely(!sig))
> > +	if (unlikely(!lock_task_sighand(tsk, &flags)))
> >  		return;
>
> i think this will lock up:

Ah. I worried about this, but convinced myself this is OK...

> the signal lock must not nest inside the rq
> lock, and these accounting functions are called from within the
> scheduler.

Why? we seem to never do task_rq_lock() under ->siglock ?

Oleg.

