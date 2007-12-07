Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXLGA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXLGA4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXLGA4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:56:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:50570 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbXLGA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:56:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 6 Dec 2007 16:56:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] move the related code from exit_notify() to exit_signals()
In-Reply-To: <20071206162244.GA9878@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0712061651480.6399@alien.or.mcafeemobile.com>
References: <20071206162244.GA9878@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007, Oleg Nesterov wrote:

> The previous bugfix was not optimal, we shouldn't care about group stop when
> we are the only thread or the group stop is in progress. In that case nothing
> special is needed, just set PF_EXITING and return.
> 
> Also, take the related "TIF_SIGPENDING re-targeting" code from exit_notify().
> 
> So, from the performance POV the only difference is that we don't trust
> !signal_pending() until we take ->siglock. But this in fact fixes another
> ___pure___ theoretical minor race. __group_complete_signal() finds the task
> without PF_EXITING and chooses it as the target for signal_wake_up(). But
> nothing prevents this task from exiting in between without noticing the
> pending signal and thus unpredictably delaying the actual delivery.

For a second there, you got me confused, since it wasn't clear to me this 
patch was going over the previous one. When posting patches that are not 
in any tree, it may be wise to include the set they nest onto ;)


> +	if (!signal_pending(tsk))
> +		goto out;
> +
> +	/* It could be that __group_complete_signal() choose us to
> +	 * notify about group-wide signal. Another thread should be
> +	 * woken now to take the signal since we will not.
> +	 */
> +	for (t = tsk; (t = next_thread(t)) != tsk; )
> +		if (!signal_pending(t) && !(t->flags & PF_EXITING))
> +			recalc_sigpending_and_wake(t);
> +
> +	if (unlikely(tsk->signal->group_stop_count) &&
> +			!--tsk->signal->group_stop_count) {
> +		tsk->signal->flags = SIGNAL_STOP_STOPPED;
> +		group_stop = 1;
> +	}
> +out:

Looks fine to me, even though the one above could simply be an:

if (signal_pending(tsk)) {
	...
}

(since the "out" label is used by that "if" only).



- Davide


