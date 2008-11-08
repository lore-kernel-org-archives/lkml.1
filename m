Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYKHJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYKHJ2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYKHJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:28:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52453 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYKHJ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:28:22 -0500
Date: Sat, 8 Nov 2008 10:28:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
Message-ID: <20081108092802.GA32664@elte.hu>
References: <20081107165238.GA23055@redhat.com> <20081107162101.GA2178@elte.hu> <20081107174016.GA24812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107174016.GA24812@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 11/07, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > --- K-28/kernel/sched_stats.h~A_G_E_R_FIX	2008-11-07 17:32:02.000000000 +0100
> > > +++ K-28/kernel/sched_stats.h	2008-11-07 17:44:39.000000000 +0100
> > > @@ -351,10 +351,12 @@ static inline void account_group_exec_ru
> > >  					      unsigned long long ns)
> > >  {
> > >  	struct signal_struct *sig;
> > > +	unsigned long flags;
> > >
> > > -	sig = tsk->signal;
> > > -	if (unlikely(!sig))
> > > +	if (unlikely(!lock_task_sighand(tsk, &flags)))
> > >  		return;
> >
> > i think this will lock up:
> 
> Ah. I worried about this, but convinced myself this is OK...
> 
> > the signal lock must not nest inside the rq
> > lock, and these accounting functions are called from within the
> > scheduler.
> 
> Why? we seem to never do task_rq_lock() under ->siglock ?

signal_wake_up() ?

	Ingo
