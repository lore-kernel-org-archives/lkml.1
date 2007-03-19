Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXCSWwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXCSWwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXCSWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:52:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:55427 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965370AbXCSWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:52:50 -0400
Date: Tue, 20 Mar 2007 01:53:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Message-ID: <20070319225305.GA258@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2> <m1mz29xi8g.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com> <20070319203615.GA83@tv-sign.ru> <Pine.LNX.4.64.0703191530270.2101@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703191530270.2101@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Davide Libenzi wrote:
>
> On Mon, 19 Mar 2007, Oleg Nesterov wrote:
> 
> > On 03/19, Davide Libenzi wrote:
> > >
> > > On Mon, 19 Mar 2007, Eric W. Biederman wrote:
> > > 
> > > > > +struct signalfd_ctx {
> > > > > +	struct list_head lnk;
> > > > > +	wait_queue_head_t wqh;
> > > > > +	sigset_t sigmask;
> > > > > +	struct task_struct *tsk;
> > > > > +};
> > > > 
> > > > I think you want to use a struct pid *pid instead of a pointer to the
> > > > task struct here.  It is slightly less efficient (one more
> > > > dereference) but it means that we won't pin the task struct in memory
> > > > indefinitely.  Pinning the task_struct like this makes for a very
> > > > interesting way to get around the limits on the number of processes a
> > > > user can have.
> > > 
> > > Hmm, when the task is detached from the sighand, we get a notify, so I 
> > > could do a put from there. This would avoid the extra de-reference. I need 
> > > to verify locking though ...
> > 
> > In that case (if I understand you correctly) we don't need {get,put}_task_struct()
> > at all.
> > 
> > signalfd_deliver(-1) sets ctx->tsk = NULL, signalfd_get_sighand() reads ->tsk
> > under rcu_read_lock(). The code becomes even simpler, we don't need to check
> > list_empty(&ctx->lnk).
> 
> I'd need a get_task_struct in any case in order to safely call 
> unlock_task_sighand(). At that point I'd prefer to just pass through the 
> struct pid*. I'll be posting the new version for review as soon as I 
> complete a few tests ...

No.

First, you don't need to use unlock_task_sighand(), you can just use
spin_unlock_irqrestore(sighand) directly. But this is, I agree, not good.

If signalfd_get_sighand()->lock_task_sighand() succeeds, it is safe to
dereference ctx->tsk. The task can't be freed and ctx->tsk can't be cleared
while we are holding siglock.

However, I was wrong, we still need a re-check after lock_task_sighand().
We should check ctx->tsk != NULL.

Oleg.

