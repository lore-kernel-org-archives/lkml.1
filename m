Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXFUXa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXFUXa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXFUXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:30:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:57303 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbXFUXat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:30:49 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070621185856.GA153@tv-sign.ru>
References: <20070619091452.GA94@tv-sign.ru>
	 <1182254988.26853.334.camel@localhost.localdomain>
	 <20070619140646.GB27343@tv-sign.ru>
	 <1182295473.26853.386.camel@localhost.localdomain>
	 <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:30:04 +1000
Message-Id: <1182468604.24740.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 22:58 +0400, Oleg Nesterov wrote:
> 
> > No "stealing". No signalfd, no *nothing*. Just normal signal
> behaviour.
> 
> _Another_ thread could steal SIGSEGV via read(signalfd) without Ben's patch.
> This is what Ben and Davide are worried about. I think we should not worry,
> we have the same situation if this "another" thread does
> 
>         for (;;)
>                 signal(SIGSEGV, SIG_IGN);
> 
> do_sigaction() does rm_from_queue_full().

Yeah well... I wanted to have the least surprise path... that is,
without my patch, signalfd will "sometimes" steal the SIGSEGV depending
on who races to the lock first, thus causing the target thread to
re-execute the faulting instruction and taking another SIGSEGV, and
sometimes not. It's bad from both the faulting thread point of view and
the signalfd use who gets signals "sometimes" without any guarantee.

I like the current code that at least implement a precise semantic for
all thread local signals -> they are only ever delivered to that thread,
period. If you really want to do funky things from outside, you can
still do ptrace ;-)

Ben.


