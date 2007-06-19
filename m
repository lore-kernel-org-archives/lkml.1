Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXFSXY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXFSXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXFSXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:24:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:36071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbXFSXYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:24:50 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070619140646.GB27343@tv-sign.ru>
References: <1182064500.2798.6.camel@entropy>
	 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
	 <1182108399.3794.4.camel@entropy>
	 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
	 <1182125303.3794.8.camel@entropy>
	 <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
	 <1182127391.26853.207.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
	 <20070619091452.GA94@tv-sign.ru>
	 <1182254988.26853.334.camel@localhost.localdomain>
	 <20070619140646.GB27343@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 09:24:33 +1000
Message-Id: <1182295473.26853.386.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 18:06 +0400, Oleg Nesterov wrote:
> On 06/19, Benjamin Herrenschmidt wrote:
> >
> > On Tue, 2007-06-19 at 13:14 +0400, Oleg Nesterov wrote:
> > 
> > > The commited "Fix signalfd interaction with thread-private signals"
> > > (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> > > this.
> > 
> > Indeed, if you want what Davide described, you need to also change
> > signalfd side. The patch I did merely prevents another thread from
> > dequeuing somebody else private signals.
> 
> Yes I see, but why do we need this change? Yes, we can dequeue SIGSEGV
> from another thread. Just don't do it if you have a handler for SIGSEGV?

Well, for such synchronous signals, it's a fairly stupid idea,
especially since you can't predict who will get it. Signals such as SEGV
are forced-in, which means they are force-unblocked. Thus, you can't
know for sure whome of signalfd or the target thread will get it first,
depending on who catches the siglock first I suppose. In one case,
you'll manage to steal it, in the other, you'll thread will be killed.

Ben.


