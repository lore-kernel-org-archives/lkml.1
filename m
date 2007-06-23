Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbXFWQf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbXFWQf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXFWQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:35:22 -0400
Received: from mail.screens.ru ([213.234.233.54]:35460 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXFWQfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:35:22 -0400
Date: Sat, 23 Jun 2007 20:35:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070623163531.GA2346@tv-sign.ru>
References: <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org> <20070621182340.GA92@tv-sign.ru> <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org> <20070621185856.GA153@tv-sign.ru> <1182468604.24740.22.camel@localhost.localdomain> <20070622084034.GA134@tv-sign.ru> <1182512473.24740.54.camel@localhost.localdomain> <20070622160405.GA189@tv-sign.ru> <1182551618.24740.79.camel@localhost.localdomain> <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Linus Torvalds wrote:
> 
> On Sat, 23 Jun 2007, Benjamin Herrenschmidt wrote:
> > 
> > > 
> > > It does exactly so, please note this chunk
> > > 
> > >  @@ -330,7 +339,7 @@ asmlinkage long sys_signalfd(int ufd, si
> > > 
> > >                  init_waitqueue_head(&ctx->wqh);
> > >                  ctx->sigmask = sigmask;
> > >  -               ctx->tsk = current;
> > >  +               ctx->tsk = current->group_leader;
> > > 
> > > > It might well be that signalfd's concept of context is wrong in the
> > > > first place and it should be attached to processes rather than threads
> > > > and that made more explicit in the first place...
> > 
> > Yup, looks like I was looking at a wrong patch... I think it's the right
> > thing to do indeed.
> 
> Quite frankly, it strikes me that if we want to do this, then we shouldn't 
> save the _process_ information at all, we should save the "sighand" 
> instead.

Yes, unless we pass signalfd to another process.

> So either we save the process info, or we save the sighand, but saving the 
> "group_leader" seems totally bogus. Especially as the group leader can 
> change (by execve()).

Note that exec() can change ->sighand as well, so in general this can't help.

Currently not a problem, exec() detaches process from signalfd anyway.


This reminds me, we have a similar problem with !CPUCLOCK_PERTHREAD()
cpu-timers, iirc. They can survive after exec(), but only if it was
->group_leader who does exec.

Oleg.

