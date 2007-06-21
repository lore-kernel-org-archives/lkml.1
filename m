Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXFUS6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXFUS6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXFUS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:58:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:57131 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbXFUS6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:58:41 -0400
Date: Thu, 21 Jun 2007 22:58:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070621185856.GA153@tv-sign.ru>
References: <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain> <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain> <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> <20070621082509.GA88@tv-sign.ru> <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org> <20070621182340.GA92@tv-sign.ru> <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Linus Torvalds wrote:
> 
> On Thu, 21 Jun 2007, Oleg Nesterov wrote:
> > 
> > Yes, the target thread is the one that caused the SIGSEGV, it sends the signal
> > to itself. entry.S:ret_from_exception should notice this signal and _dequeue_
> > it, no? This signal could be stealed by signal(SIG_IGN) which runs after it
> > was delivered.
> 
> Right. But it will dequeue it by *taking* it.
> 
> IOW, this has absolutely nothing to do with signalfd.
> 
> That's all I mean.

Yes.

> > My point was that it is _possible_ to steal a thread-local SIGSEGV even without
> > signalfd, nothing bad should happen.
> 
> That makes no sense.
> 
> You don't "steal" it. You take it. It's what SIGSEGV (and _any_ signal) 
> has always been about. You get the signal, enter the signal handler, and 
> handle it. 
> 
> No "stealing". No signalfd, no *nothing*. Just normal signal behaviour.

_Another_ thread could steal SIGSEGV via read(signalfd) without Ben's patch.
This is what Ben and Davide are worried about. I think we should not worry,
we have the same situation if this "another" thread does

	for (;;)
		signal(SIGSEGV, SIG_IGN);

do_sigaction() does rm_from_queue_full().

Oleg.

