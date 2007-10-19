Return-Path: <linux-kernel-owner+w=401wt.eu-S966312AbXJSE3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312AbXJSE3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXJSE3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:29:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:48980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbXJSE3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:29:44 -0400
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
Date: Fri, 19 Oct 2007 14:29:03 +1000
Message-Id: <1192768143.7367.98.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 12:20 +0800, Herbert Xu wrote:
> 
> That's why I think this patch is in fact the only one that
> solves all the races in this thread.  The case that it solves
> which the lock/unlock patch does not is the one where action
> flows downwards past the clearing of IRQ_INPROGRESS.  I missed
> this case earlier.
> 
> In fact this bug exists elsewhere too.  For example, the network
> stack does this in net/sched/sch_generic.c:
> 
>         /* Wait for outstanding qdisc_run calls. */
>         while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
>                 yield();
> 
> This has the same problem as the current synchronize_irq code.

The network stack always made be nervous with it's bitops use as locks.
Any loop of test_bit() alone as a synchronisation method, without locks
or barriers is, imho, inherently buggy.

Ben.


