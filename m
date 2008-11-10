Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYKJMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYKJMER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYKJMEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:04:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbYKJMEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:04:00 -0500
Date: Mon, 10 Nov 2008 14:04:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] account_group_exec_runtime: fix the racy usage of
	->signal
Message-ID: <20081110130404.GA10294@redhat.com>
References: <20081107165238.GA23055@redhat.com> <20081107162101.GA2178@elte.hu> <20081107174016.GA24812@redhat.com> <20081108092802.GA32664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108092802.GA32664@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 11/07, Ingo Molnar wrote:
> > >
> > > the signal lock must not nest inside the rq
> > > lock, and these accounting functions are called from within the
> > > scheduler.
> >
> > Why? we seem to never do task_rq_lock() under ->siglock ?
>
> signal_wake_up() ?

I'd wish very much I could say I have already realized this, but I didn't.
Thanks Ingo!

I don't see the good solution for this problem. I'll send the new patch in
a minute, but it is ugly. Basically it is

	--- a/kernel/exit.c
	+++ b/kernel/exit.c
	@@ -141,6 +141,8 @@ static void __exit_signal(struct task_st
		if (sig) {
			flush_sigqueue(&sig->shared_pending);
			taskstats_tgid_free(sig);
	+		smp_mb();
	+		spin_unlock_wait(&task_rq(tsk)->lock);
			__cleanup_signal(sig);
		}
	 }

except this needs a helper in sched.c. You can nack it right now ;)
Of course we can protect ->signal with rcu, but this is even worse
imho.

Anybody sees a bettter fix?


Perhaps we can change sched.c to do update_curr() only when the
task is not running (except ->task_tick), iow perhaps we can check
sleep/wakeup == T before calling update_cur(). But this is not easy
even if really possible.

Oleg.

