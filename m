Return-Path: <linux-kernel-owner+w=401wt.eu-S935126AbXJRXxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126AbXJRXxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934443AbXJRXxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:53:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:53035 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934384AbXJRXxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:53:15 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 09:52:33 +1000
Message-Id: <1192751553.7367.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So how about something like this (untested! not necessarily very well 
> thought through either!)
> 
> Basic notion: the only thing that serializes the IRQ_INPROGRESS flag is 
> the descriptor lock. And we don't have to (or even want to!) hold it while 
> waiting for the thing, but we want to *have*held*it* in between whatever 
> we're synchronizing with.
> 
> The internal irq handler functions already held the lock when they did 
> whatever they need to serialize - and they are possibly performance 
> critical too - so they use the "internal" function that doesn't get the 
> lock unnecessarily again.

That may do the trick as the read can't cross the spin_lock (it can
cross spin_unlock but not lock). Advantage over adding a barrier to
handle_IRQ_event() is that it keeps the overhead to the slow path
(synchronize_irq).

Note that I didn't actually experience a problem here. I just came upon
that by accident while thinking about a similar issue I have with
napi_synchronize().

Looks good to me on a first glance (unfortunately a bit ugly but heh).

Ben.


