Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbXFUIZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbXFUIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFUIZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:25:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:47864 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbXFUIZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:25:05 -0400
Date: Thu, 21 Jun 2007 12:25:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070621082509.GA88@tv-sign.ru>
References: <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com> <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain> <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain> <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Linus Torvalds wrote:
> 
> On Wed, 20 Jun 2007, Oleg Nesterov wrote:
> > 
> > Also, suppose that some thread does
> > 
> > 	for (;;)
> > 		signal(SIGSEGV, SIG_IGN);
> > 
> > Now we have the same situation. do_sigaction() can steal SIGSEGV from
> > another thread.
> 
> Actually, that shouldn't be possible.
> 
> See "force_sig_info()". It does not allow blocking or ignoring forced 
> signals. We will reset such a signal handler to SIG_DFL, and unlock it.
> 
> So if you get a SIGSEGV while SIGSEGV's are blocked or ignored, the kernel 
> *will* kill you. No questions asked.

Yes, and no.

Yes, force_sig() unblocks and un-ignores the signal. However, unlike group-wide
signals, thread-specific signals do not convert themselves to SIGKILL on delivery.
The target thread should dequeue SIGSEGV and then it calls do_group_exit().
Before it does so, another thread doing signal(SIGSEGV, SIG_IGN) can steal
the signal.

Of course, this is unlikely, and the target thread will take page fault again.
The same for signalfd.

Oleg.

