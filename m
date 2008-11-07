Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYKGQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYKGQ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYKGQ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:58:12 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36233 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYKGQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:58:11 -0500
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
From: Doug Chapman <doug.chapman@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       adobriyan@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081107162101.GA2178@elte.hu>
References: <20081107165238.GA23055@redhat.com>
	 <20081107162101.GA2178@elte.hu>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 11:58:07 -0500
Message-Id: <1226077087.6451.18.camel@oberon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-11-07 at 17:21 +0100, Ingo Molnar wrote:
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Compile tested.
> > 
> > Unlike other similar routines, account_group_exec_runtime() could be
> > called "implicitly" after exit_notify(). This means we can race with
> > the parent doing release_task(), we can't just check ->signal != NULL.
> > 
> > Take ->siglock to make sure ->signal can't go away.
> > 
> > This is the minimal fix, with this patch we don't need need get/put cpu,
> > and I think we should uninline this function.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> > 
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
> i think this will lock up: the signal lock must not nest inside the rq 
> lock, and these accounting functions are called from within the 
> scheduler.
> 
> 	Ingo

I can confirm that this does hang on bootup.

- Doug


