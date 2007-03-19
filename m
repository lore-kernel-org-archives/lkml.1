Return-Path: <linux-kernel-owner+w=401wt.eu-S1030738AbXCSXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030738AbXCSXfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030751AbXCSXfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:35:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50898 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030738AbXCSXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:35:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 16:34:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
In-Reply-To: <20070319232842.GB258@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703191633030.3733@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
 <m1mz29xi8g.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com>
 <20070319203615.GA83@tv-sign.ru> <Pine.LNX.4.64.0703191530270.2101@alien.or.mcafeemobile.com>
 <20070319225305.GA258@tv-sign.ru> <20070319232842.GB258@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Oleg Nesterov wrote:

> On 03/20, Oleg Nesterov wrote:
> >
> > On 03/19, Davide Libenzi wrote:
> > >
> > > I'd need a get_task_struct in any case in order to safely call 
> > > unlock_task_sighand(). At that point I'd prefer to just pass through the 
> > > struct pid*. I'll be posting the new version for review as soon as I 
> > > complete a few tests ...
> > 
> > If signalfd_get_sighand()->lock_task_sighand() succeeds, it is safe to
> > dereference ctx->tsk. The task can't be freed and ctx->tsk can't be cleared
> > while we are holding siglock.
> > 
> > However, I was wrong, we still need a re-check after lock_task_sighand().
> > We should check ctx->tsk != NULL.
> 
> IOW, we can (afaics) do
> 
> 	static struct sighand_struct *signalfd_get_sighand(struct signalfd_ctx *ctx,
> 							   unsigned long *flags)
> 	{
> 		struct sighand_struct *sighand = NULL;
> 		struct tsak_struct *tsk;
> 
> 		rcu_read_lock();
> 		tsk = rcu_dereference(ctx->tsk);  // not needed, just a documentation
> 		if (tsk != NULL)
> 			sighand = lock_task_sighand(tsk, flags);
> 		rcu_read_unlock();
> 
> 		if (sighand && !ctx->tsk)) {
> 			unlock_task_sighand(tsk, flags);
> 			sighand = NULL;
> 		}
> 
> 		return sighand;
> 	}
> 
> If signalfd_get_sighand() succeeds, ctx->tsk is pinned.

I did a similar thing, but I renamed the locking functions and its 
parameters. After looking at what the pid thing was doing, I realized that 
it was not really needed.



- Davide


