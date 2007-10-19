Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbXJSE1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbXJSE1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXJSE1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:27:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:48960 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXJSE1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:27:37 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192767073.7367.84.camel@pasglop>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	 <1192767073.7367.84.camel@pasglop>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 14:26:54 +1000
Message-Id: <1192768014.7367.96.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The whole lock/set IRQ_INPROGRESS/unlock path can then only happen
> before the locked section above, in which case we see and wait nicely
> and all is good, or after, in which case the store to foo will be
> visible to the IRQ handler as it will be ordered with the unlock in the
> code above.

Note that napi_synchronize needs a slightly different treatement.

Here, the situation boils down to:

one CPU does:

	foo = 1;
	while(test_bit(bar))
		barrier();

and the other:

	if (!test_and_set_bit(bar)) {
		read & use foo
		smp_mb__before_clear_bit();
		clear_bit(bar);
	}

The good thing here is that read & use foo is part of the critical
section (I hate hand-made locks ...) defined by bar which makes
things somewhat easier than the synchronize_irq() case.

I think a simple smp_mb(); here after foo = 1; is enough, which means
basically just having an smp_mp(); inside napi_synchronize(), before
the test_bit(). Or do I miss something ?

Cheers,
Ben.


