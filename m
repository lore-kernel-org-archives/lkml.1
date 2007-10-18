Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbXJRC5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbXJRC5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbXJRC51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:57:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:36573 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759100AbXJRC5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:57:25 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <1192675254.12879.29.camel@pasglop>
References: <1192670742.12879.5.camel@pasglop>
	 <alpine.LFD.0.999.0710171906150.26902@woody.linux-foundation.org>
	 <1192675254.12879.29.camel@pasglop>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 12:57:15 +1000
Message-Id: <1192676235.12879.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> In general, I tend to think that for this function to make any sense
> (that is, to synchronize anything at all), it needs a barrier or you are
> just making a decision based on a totally random value of desc->status
> since it can have been re-ordered, speculatively loaded, pre-fetched,
> whatever'ed... :-).

Take a real life example:

drivers/message/fusion/mptbase.c

	/* Disable interrupts! */
	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);

	ioc->active = 0;
	synchronize_irq(pdev->irq);

And we aren't in a spinlock here. 

That's just a random example grepped.... I think I see a few more. Then,
some drivers like tg3 actually do an smp_mb() before calling
synchronize_irq(). But then, some don't.

I think trying to have all drivers be correct here is asking for
trouble, we'd rather have synchronize_irq() be uber-safe. It's not like
it was used in hot path anyway.

Ben.




