Return-Path: <linux-kernel-owner+w=401wt.eu-S1030766AbXCTAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766AbXCTAVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXCTAVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:21:37 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51017 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030766AbXCTAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:21:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 17:20:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
In-Reply-To: <20070320001310.GA327@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703191718020.3733@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
 <20070320001310.GA327@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Oleg Nesterov wrote:

> On 03/19, Davide Libenzi wrote:
> >
> > +struct signalfd_lockctx {
> > +	struct task_struct *tsk;
> > +	struct sighand_struct *sighand;
> > +	unsigned long flags;
> > +};
> 
> signalfd_lockctx is "private" to signalfd_lock/signalfd_unlock. But lk->sighand
> is used only by signalfd_lock(). I'd suggest to remove it.

Ack



> > +void signalfd_deliver(struct task_struct *tsk, int sig)
> > +{
> > +	struct sighand_struct *sighand = tsk->sighand;
> > +	struct signalfd_ctx *ctx, *tmp;
> > +
> > +	list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
> > +		/*
> > +		 * We use a negative signal value as a way to broadcast that the
> > +		 * sighand has been orphaned, so that we can notify all the
> > +		 * listeners about this. Remeber the ctx->sigmask is inverted,
> > +		 * so if the user is interested in a signal, that corresponding
> > +		 * bit will be zero.
> > +		 */
> > +		if (sig < 0) {
> > +			if (ctx->tsk == tsk) {
> > +				ctx->tsk = NULL;
> > +				list_del_init(&ctx->lnk);
> > +				wake_up(&ctx->wqh);
> > +			}
> > +		} else if (sig > 0) {
> > +			if (!sigismember(&ctx->sigmask, sig))
> > +				wake_up(&ctx->wqh);
> > +		}
> > +	}
> > +}
> 
> I tried to avoid this comment, but can't help myself :)

Added BUG_ON() and using "else".



- Davide


