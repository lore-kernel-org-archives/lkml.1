Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbXFUSXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbXFUSXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXFUSXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:23:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:46298 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXFUSXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:23:44 -0400
Date: Thu, 21 Jun 2007 22:23:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070621182340.GA92@tv-sign.ru>
References: <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain> <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain> <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> <20070621082509.GA88@tv-sign.ru> <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Linus Torvalds wrote:
>
> On Thu, 21 Jun 2007, Oleg Nesterov wrote:
> > 
> > Yes, force_sig() unblocks and un-ignores the signal. However, unlike group-wide
> > signals, thread-specific signals do not convert themselves to SIGKILL on delivery.
> > The target thread should dequeue SIGSEGV and then it calls do_group_exit().
> 
> No it couldn't.
> 
> Why? Because the target thread is the one that *caused* the SIGSEGV in the 
> first place. It's not going to dequeue *anything*. It's either going to 
> take the SIGSEGV,

Hmm, can't understand.

Yes, the target thread is the one that caused the SIGSEGV, it sends the signal
to itself. entry.S:ret_from_exception should notice this signal and _dequeue_
it, no? This signal could be stealed by signal(SIG_IGN) which runs after it
was delivered.

> or it's going to get another SIGSEGV and now it's no
> longer masked/handled and it's going to die.

Yes sure. As I said,

	> and the target thread will take page fault again.

My point was that it is _possible_ to steal a thread-local SIGSEGV even without
signalfd, nothing bad should happen.

Oleg.

