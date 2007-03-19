Return-Path: <linux-kernel-owner+w=401wt.eu-S1030737AbXCSX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030737AbXCSX23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030735AbXCSX23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:28:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:44148 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030732AbXCSX22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:28:28 -0400
Date: Tue, 20 Mar 2007 02:28:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Message-ID: <20070319232842.GB258@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2> <m1mz29xi8g.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com> <20070319203615.GA83@tv-sign.ru> <Pine.LNX.4.64.0703191530270.2101@alien.or.mcafeemobile.com> <20070319225305.GA258@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319225305.GA258@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Oleg Nesterov wrote:
>
> On 03/19, Davide Libenzi wrote:
> >
> > I'd need a get_task_struct in any case in order to safely call 
> > unlock_task_sighand(). At that point I'd prefer to just pass through the 
> > struct pid*. I'll be posting the new version for review as soon as I 
> > complete a few tests ...
> 
> If signalfd_get_sighand()->lock_task_sighand() succeeds, it is safe to
> dereference ctx->tsk. The task can't be freed and ctx->tsk can't be cleared
> while we are holding siglock.
> 
> However, I was wrong, we still need a re-check after lock_task_sighand().
> We should check ctx->tsk != NULL.

IOW, we can (afaics) do

	static struct sighand_struct *signalfd_get_sighand(struct signalfd_ctx *ctx,
							   unsigned long *flags)
	{
		struct sighand_struct *sighand = NULL;
		struct tsak_struct *tsk;

		rcu_read_lock();
		tsk = rcu_dereference(ctx->tsk);  // not needed, just a documentation
		if (tsk != NULL)
			sighand = lock_task_sighand(tsk, flags);
		rcu_read_unlock();

		if (sighand && !ctx->tsk)) {
			unlock_task_sighand(tsk, flags);
			sighand = NULL;
		}

		return sighand;
	}

If signalfd_get_sighand() succeeds, ctx->tsk is pinned.

Oleg.

