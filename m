Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYBGCXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYBGCXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYBGCXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:23:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbYBGCXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:23:15 -0500
Date: Wed, 6 Feb 2008 18:23:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. K. Cliburn" <jacliburn@bellsouth.net>
Cc: Zan Lynx <zlynx@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
 tty_poll
Message-Id: <20080206182329.b0956b4a.akpm@linux-foundation.org>
In-Reply-To: <47AA68AA.3090009@bellsouth.net>
References: <1202326722.7488.46.camel@localhost>
	<47AA68AA.3090009@bellsouth.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 20:10:50 -0600 "J. K. Cliburn" <jacliburn@bellsouth.net> wrote:

> Zan Lynx wrote:
> 
> > gnome-terminal gets stuck.
> 
> I began seeing this very thing around 2.6.24 time.  (Fedora 8, vanilla 
> kernel.)  I could usually cause the gnome terminal to hang if I rapidly 
> resized the window while executing make check-headers.
> 
> Over a couple of days I bisected it down to this commit:
> 
> Commit:     37bb6cb4097e29ffee970065b74499cbf10603a3
> Parent:     d3d74453c34f8fd87674a8cf5b8a327c68f22e99
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri Jan 25 21:08:32 2008 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri Jan 25 21:08:32 2008 +0100
> 
>      hrtimer: unlock hrtimer_wakeup
> 
>      hrtimer_wakeup creates a
> 
>        base->lock
>          rq->lock
> 
>      lock dependancy. Avoid this by switching to 
> HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
>      which doesn't hold base->lock.
> 
>      This fully untangles hrtimer locks from the scheduler locks, and allows
>      hrtimer usage in the scheduler proper.
> 
>      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>      Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>   kernel/hrtimer.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> Reverting the commit seemed to fix the problem for me.
> 
> Then I went away on a business trip Monday morning and returned Tuesday 
> night to a dead computer (won't POST), so I can't do any further 
> troubleshooting until I get it fixed.

Useful, thanks.

> Try reverting that patch and see if your gnome-terminal freezes go away.

Here is a convenient patch against current mainline:


--- a/kernel/hrtimer.c~revert-1
+++ a/kernel/hrtimer.c
@@ -1292,7 +1292,7 @@ void hrtimer_init_sleeper(struct hrtimer
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
 #ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
 #endif
 }
 
@@ -1303,8 +1303,6 @@ static int __sched do_nanosleep(struct h
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start(&t->timer, t->timer.expires, mode);
-		if (!hrtimer_active(&t->timer))
-			t->task = NULL;
 
 		if (likely(t->task))
 			schedule();
_

