Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXJSEgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXJSEgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXJSEfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:35:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:36328 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXJSEfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:35:52 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071019042025.GA9617@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	 <20071019042025.GA9617@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 14:35:10 +1000
Message-Id: <1192768510.7367.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What may happen is that action can either float upwards to give
> 
> 	spin_lock
> 	action
> 	set IRQ_INPROGRESS
> 	spin_unlock
> 
> 	spin_lock
> 	clear IRQ_INPROGRESS
> 	spin_unlock
> 
> or it can float downwards to give
> 
> 	spin_lock
> 	set IRQ_INPROGRESS
> 	spin_unlock
> 
> 	spin_lock
> 	clear IRQ_INPROGRESS
> 	action
> 	spin_unlock
> 

Well, we are generally safer here. That is, unless action is a store,
it will not pass spin_lock, at least not on powerpc afaik.

In fact, if action, as it is in our case, is something like

if (foo)
	return;

We cant execute the store inside spin_lock() without having loaded
foo, there is an implicit dependency here.

But anyway, Linus patch fixes that too if it was a problem. Now if
we grep for while (test_bit and while (!test_bit I'm sure we'll find
other similar surprises.

That's also one of the reasons why I _love_ nick patches that add a
proper lock/unlock API on bits, because at least those who are doing
those hand-made pseudo-locks with bitops to save space will be
getting a proper lock/unlock API, no more excuse.

The network stack is doing more fancy things so it's harder (though I
wonder sometimes if it's really worth the risks taken for not using
spinlocks... maybe).

Ben.


