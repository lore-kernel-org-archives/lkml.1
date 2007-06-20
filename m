Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXFTLOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXFTLOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXFTLOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:14:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:47232 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXFTLOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:14:15 -0400
Date: Wed, 20 Jun 2007 15:14:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070620111415.GA91@tv-sign.ru>
References: <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com> <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com> <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain> <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182295473.26853.386.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Benjamin Herrenschmidt wrote:
>
> On Tue, 2007-06-19 at 18:06 +0400, Oleg Nesterov wrote:
> > On 06/19, Benjamin Herrenschmidt wrote:
> > >
> > > On Tue, 2007-06-19 at 13:14 +0400, Oleg Nesterov wrote:
> > > 
> > > > The commited "Fix signalfd interaction with thread-private signals"
> > > > (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> > > > this.
> > > 
> > > Indeed, if you want what Davide described, you need to also change
> > > signalfd side. The patch I did merely prevents another thread from
> > > dequeuing somebody else private signals.
> > 
> > Yes I see, but why do we need this change? Yes, we can dequeue SIGSEGV
> > from another thread. Just don't do it if you have a handler for SIGSEGV?
> 
> Well, for such synchronous signals, it's a fairly stupid idea,
> especially since you can't predict who will get it. Signals such as SEGV
> are forced-in, which means they are force-unblocked. Thus, you can't
> know for sure whome of signalfd or the target thread will get it first,
> depending on who catches the siglock first I suppose. In one case,
> you'll manage to steal it, in the other, you'll thread will be killed.

Yes. As I said, I think this falls into the "just don't do that" category.
But nothing bad happens from the kernel POV.

Also, suppose that some thread does

	for (;;)
		signal(SIGSEGV, SIG_IGN);

Now we have the same situation. do_sigaction() can steal SIGSEGV from
another thread.


Perhaps, the proposed behaviour

	> Multiple threads can wait on the signalfd. Each one will dequeue either
	> its own private signals (tsk->pending) or the process shared ones
	> (tsk->signal->shared_pending).

is more convenient, I can't judge. If we implement this, sys_signalfd(-1) in
essence means "attach to the thread group, not current". This also makes sense.
But what we have now (with this patch applied) is a bit strange, imho.

Oleg.

