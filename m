Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbXKMP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbXKMP4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbXKMP4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:56:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39647 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXKMP4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:56:40 -0500
Date: Tue, 13 Nov 2007 18:56:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sigwait eats blocked default-ignore signals
Message-ID: <20071113155638.GB74@tv-sign.ru>
References: <20071112234155.783744D04C9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071112234155.783744D04C9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Roland McGrath wrote:
> 
> cf http://bugzilla.kernel.org/show_bug.cgi?id=9347
> 
> While a signal is blocked, it must be posted even if its action is
> SIG_IGN or is SIG_DFL with the default action to ignore.  This works
> right most of the time, but is broken when a sigwait (rt_sigtimedwait)
> is in progress.  This changes the early-discard check to respect
> real_blocked.  ~blocked is the set to check for "should wake up now",
> but ~(blocked|real_blocked) is the set for "blocked" semantics as
> defined by POSIX.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  kernel/signal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 0ac614a..9b22790 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -55,7 +55,7 @@ static int sig_ignored(struct task_struct *t, int sig)
>  	 * signal handler may change by the time it is
>  	 * unblocked.
>  	 */
> -	if (sigismember(&t->blocked, sig))
> +	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
>  		return 0;

I believe the patch is correct and fixes the 9347 bug.

But I suspect we have other issues here. Let's suppose we have threads T1 (main)
and T2. T2 blocks SIGCHLD and does sigwait(SIGCHLD).

Now, we send SIGCHLD to the thread group. The signal is lost again because
sig_ignored() returns true on T1's side.

Is this OK? For example, let's modify the test-case:

	void *tfunc(void *arg)
	{
		sleep(1);

		if (!fork())
			exit(0);

		for (;;)
			pause();
	}

	int main(void)
	{
		pthread_t pt;
		sigset_t set;
		int signum;

		pthread_create(&pt, 0, tfunc, 0);

		sigemptyset(&set);
		sigaddset(&set, SIGCHLD);
		sigprocmask(SIG_BLOCK, &set, NULL);

		sigwait(&set, &signum);
		return 0;
	}

I bet sigwait() will hang again.

I think __group_send_sig_info() shouldn't use sig_ignored() at all. Instead,
we should split __group_complete_signal() into 2 functions. The first one, say,
choose_target() shoud be used instead. The second one, handle_fatal_signal()
can also be used by tkill() and friends.

What do you think?

Actually, I was going to do this cleanup a long ago, but can't find the time
to try to do this.

Oleg.

