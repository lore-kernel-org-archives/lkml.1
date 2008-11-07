Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYKGRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYKGRlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYKGRli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:41:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYKGRlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:41:37 -0500
Date: Fri, 7 Nov 2008 19:42:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Doug Chapman <doug.chapman@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       adobriyan@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
Message-ID: <20081107184205.GA30523@redhat.com>
References: <20081107165238.GA23055@redhat.com> <20081107162101.GA2178@elte.hu> <1226077087.6451.18.camel@oberon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226077087.6451.18.camel@oberon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Doug Chapman wrote:
> 
> On Fri, 2008-11-07 at 17:21 +0100, Ingo Molnar wrote:
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
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
> > i think this will lock up: the signal lock must not nest inside the rq 
> > lock, and these accounting functions are called from within the 
> > scheduler.
>
> I can confirm that this does hang on bootup.

Thanks a lot Doug.

If only I could understand what happens. I am running the 2.6.27 kernel
with the patch below just fine.

Ingo, could you please explain?

OK, perhaps we can check ->exit_state... I'll return on Monday.


--- linux-2.6.27/kernel/sched_fair.c~DBG	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/kernel/sched_fair.c	2008-11-07 19:15:28.000000000 +0100
@@ -484,6 +484,16 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	curr->vruntime += delta_exec_weighted;
 }
 
+static void ttt(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	if (unlikely(!lock_task_sighand(tsk, &flags)))
+		return;
+
+	unlock_task_sighand(tsk, &flags);
+}
+
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
@@ -507,6 +517,7 @@ static void update_curr(struct cfs_rq *c
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
+		ttt(curtask);
 	}
 }
 

