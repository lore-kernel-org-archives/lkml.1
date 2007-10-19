Return-Path: <linux-kernel-owner+w=401wt.eu-S935212AbXJSE7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbXJSE7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXJSE70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:59:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:39943 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760752AbXJSE7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:59:25 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071019044806.GA10080@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	 <20071019042025.GA9617@gondor.apana.org.au>
	 <20071019044806.GA10080@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 14:58:30 +1000
Message-Id: <1192769910.7367.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 12:48 +0800, Herbert Xu wrote:

> [IRQ]: Fix synchronize_irq races with IRQ handler
> 
> As it is some callers of synchronize_irq rely on memory barriers
> to provide synchronisation against the IRQ handlers.  For example,
> the tg3 driver does
> 
> 	tp->irq_sync = 1;
> 	smp_mb();
> 	synchronize_irq();
> 
> and then in the IRQ handler:
> 
> 	if (!tp->irq_sync)
> 		netif_rx_schedule(dev, &tp->napi);
> 
> Unfortunately memory barriers only work well when they come in
> pairs.  Because we don't actually have memory barriers on the
> IRQ path, the memory barrier before the synchronize_irq() doesn't
> actually protect us.
> 
> In particular, synchronize_irq() may return followed by the
> result of netif_rx_schedule being made visible.
> 
> This patch (mostly written by Linus) fixes this by using spin
> locks instead of memory barries on the synchronize_irq() path.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Good for me.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


