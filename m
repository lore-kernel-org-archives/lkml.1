Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYBGTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYBGTtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYBGTtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:49:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYBGTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:49:16 -0500
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
	tty_poll
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. K. Cliburn" <jacliburn@bellsouth.net>, Zan Lynx <zlynx@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080206182329.b0956b4a.akpm@linux-foundation.org>
References: <1202326722.7488.46.camel@localhost>
	 <47AA68AA.3090009@bellsouth.net>
	 <20080206182329.b0956b4a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 20:49:04 +0100
Message-Id: <1202413744.6274.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 18:23 -0800, Andrew Morton wrote:
> On Wed, 06 Feb 2008 20:10:50 -0600 "J. K. Cliburn" <jacliburn@bellsouth.net> wrote:
> 
> > Zan Lynx wrote:
> > 
> > > gnome-terminal gets stuck.
> > 
> > I began seeing this very thing around 2.6.24 time.  (Fedora 8, vanilla 
> > kernel.)  I could usually cause the gnome terminal to hang if I rapidly 
> > resized the window while executing make check-headers.
> > 
> > Over a couple of days I bisected it down to this commit:
> > 
> > Commit:     37bb6cb4097e29ffee970065b74499cbf10603a3
> > Parent:     d3d74453c34f8fd87674a8cf5b8a327c68f22e99
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri Jan 25 21:08:32 2008 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri Jan 25 21:08:32 2008 +0100
> > 
> >      hrtimer: unlock hrtimer_wakeup
> > 
> >      hrtimer_wakeup creates a
> > 
> >        base->lock
> >          rq->lock
> > 
> >      lock dependancy. Avoid this by switching to 
> > HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
> >      which doesn't hold base->lock.
> > 
> >      This fully untangles hrtimer locks from the scheduler locks, and allows
> >      hrtimer usage in the scheduler proper.
> > 
> >      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >      Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >   kernel/hrtimer.c |    4 +++-
> >   1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > 
> > Reverting the commit seemed to fix the problem for me.
> > 
> > Then I went away on a business trip Monday morning and returned Tuesday 
> > night to a dead computer (won't POST), so I can't do any further 
> > troubleshooting until I get it fixed.
> 
> Useful, thanks.
> 
> > Try reverting that patch and see if your gnome-terminal freezes go away.
> 
> Here is a convenient patch against current mainline:
> 
> 
> --- a/kernel/hrtimer.c~revert-1
> +++ a/kernel/hrtimer.c
> @@ -1292,7 +1292,7 @@ void hrtimer_init_sleeper(struct hrtimer
>  	sl->timer.function = hrtimer_wakeup;
>  	sl->task = task;
>  #ifdef CONFIG_HIGH_RES_TIMERS
> -	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
> +	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
>  #endif
>  }
>  
> @@ -1303,8 +1303,6 @@ static int __sched do_nanosleep(struct h
>  	do {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		hrtimer_start(&t->timer, t->timer.expires, mode);
> -		if (!hrtimer_active(&t->timer))
> -			t->task = NULL;
>  
>  		if (likely(t->task))
>  			schedule();

Bugger, I thought I had it nailed with:

---

commit 3588a085cd52ef080bf72df772378e1ba6bb292f
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Feb 1 17:45:13 2008 +0100

    hrtimer: fix hrtimer_init_sleeper() users
    
    this patch:
    
     commit 37bb6cb4097e29ffee970065b74499cbf10603a3
     Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Date:   Fri Jan 25 21:08:32 2008 +0100
    
         hrtimer: unlock hrtimer_wakeup
    
    Broke hrtimer_init_sleeper() users. It forgot to fix up the futex
    caller of this function to detect the failed queueing and messed up
    the do_nanosleep() caller in that it could leak a TASK_INTERRUPTIBLE
    state.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/futex.c b/kernel/futex.c
index db9824d..0edd314 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1252,6 +1252,8 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 			t.timer.expires = *abs_time;
 
 			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			if (!hrtimer_active(&t.timer))
+				t.task = NULL;
 
 			/*
 			 * the timer could have already expired, in which
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bd5d6b5..1069998 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1315,6 +1315,8 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 
 	} while (t->task && !signal_pending(current));
 
+	__set_current_state(TASK_RUNNING);
+
 	return t->task == NULL;
 }
 

---

But apparently that doesn't do the magic for gnome-terminal (as this
patch is already in the .24-mm1 kernel reported broken). Any way I can
'easily' reproduce this issue?



