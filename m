Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbXFVWrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbXFVWrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXFVWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:47:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbXFVWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:47:28 -0400
Date: Fri, 22 Jun 2007 15:47:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <1182551618.24740.79.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
References: <20070620111415.GA91@tv-sign.ru> 
 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> 
 <20070621082509.GA88@tv-sign.ru>  <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
  <20070621182340.GA92@tv-sign.ru>  <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
  <20070621185856.GA153@tv-sign.ru>  <1182468604.24740.22.camel@localhost.localdomain>
  <20070622084034.GA134@tv-sign.ru>  <1182512473.24740.54.camel@localhost.localdomain>
  <20070622160405.GA189@tv-sign.ru>
 <1182551618.24740.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Benjamin Herrenschmidt wrote:
> 
> > 
> > It does exactly so, please note this chunk
> > 
> >  @@ -330,7 +339,7 @@ asmlinkage long sys_signalfd(int ufd, si
> > 
> >                  init_waitqueue_head(&ctx->wqh);
> >                  ctx->sigmask = sigmask;
> >  -               ctx->tsk = current;
> >  +               ctx->tsk = current->group_leader;
> > 
> > > It might well be that signalfd's concept of context is wrong in the
> > > first place and it should be attached to processes rather than threads
> > > and that made more explicit in the first place...
> 
> Yup, looks like I was looking at a wrong patch... I think it's the right
> thing to do indeed.

Quite frankly, it strikes me that if we want to do this, then we shouldn't 
save the _process_ information at all, we should save the "sighand" 
instead.

So either we save the process info, or we save the sighand, but saving the 
"group_leader" seems totally bogus. Especially as the group leader can 
change (by execve()).

One thing that strikes me as I look at that function is that the whole 
signalfd thing doesn't seem to do any reference counting. Ie it looks 
totally buggy wrt passing the resulting fd off to somebody else, and then 
exiting in the original process.

What did I miss?

		Linus
