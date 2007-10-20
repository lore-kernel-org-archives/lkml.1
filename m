Return-Path: <linux-kernel-owner+w=401wt.eu-S936661AbXJTDKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936661AbXJTDKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 23:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXJTDKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 23:10:45 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:34056 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbXJTDKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 23:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KY+kRkGatZiQgdQOKU7Ieb8qBFQBCiPmnv3SlncbLA6JmAd+I3Vjz5mu6+mHbLkcwG2S8NMWV9LpwX358vFxo7qRLIKrCxWLjaLzYIXh2NnfWSrvSw34PY3nEkLWWNPLt3sKLxEkglxUJPZsO0JGleeWBV+dNTABoMV9D6C2sSo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Sat, 20 Oct 2007 05:10:01 +0200
User-Agent: KMail/1.9.6
Cc: benh@kernel.crashing.org, akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
References: <1192670742.12879.5.camel@pasglop> <200710200402.43106.maximlevitsky@gmail.com> <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710200510.01409.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007 04:25:34 Linus Torvalds wrote:
> 
> On Sat, 20 Oct 2007, Maxim Levitsky wrote:
> > 
> > and the interrupt handler:
> > 
> > 	smp_rmb();
> > 	if (dev->insuspend)
> > 		goto out;
> 
> Something like that can work, yes. However, you need to make sure that:
> 
>  - even when you ignore the interrupt (because the driver doesn't care, 
>    it's suspending), you need to make sure the hardware gets shut up by 
>    reading (or writing) the proper interrupt status register.
I agree, but while device is powered off, its registers can't be accessed
Thus, if I ack the IRQ every time the handler is called, I will access the 
powered off device (this is probably won't hurt a lot, but a bit incorrectly)

> 
>    Otherwise, with a level interrupt, the interrupt will continue to be 
>    held active ("screaming") and the CPU will get interrupted over and 
>    over again, until the irq subsystem will just turn the irq off 
>    entirely.
> 
>  - when you resume, make sure that you get the engine going again, with 
>    the understanding that some interrupts may have gotten ignored.
Here it isn't a problem, this is a video capture card, and I suspend it by just stopping dma
on all active buffers even if in the middle of capture, and I send those buffers to card again
to fill them from the beginning during the resume.
> 
> Also, in general, these kinds of things shouldn't always even be 
> neicessary. If you use the suspend_late()/resume_early() hooks, those will 
> be called with interrupts off, and while they can be harder to debug (and 
> may be worth avoiding for non-critical drivers), they do allow for simpler 
> models partly exactly because they don't need to worry about interrupts 
> etc.
Exactly, I am aware of suspend_late , but I don't want to abuse it.
> 
> 		Linus
> 


Best regards,
	Maxim Levitsky

