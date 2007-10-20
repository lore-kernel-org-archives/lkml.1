Return-Path: <linux-kernel-owner+w=401wt.eu-S935280AbXJTC0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935280AbXJTC0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXJTCZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:25:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbXJTCZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:25:47 -0400
Date: Fri, 19 Oct 2007 19:25:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: benh@kernel.crashing.org, akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <200710200402.43106.maximlevitsky@gmail.com>
Message-ID: <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
References: <1192670742.12879.5.camel@pasglop>
 <200710200402.43106.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Maxim Levitsky wrote:
> 
> and the interrupt handler:
> 
> 	smp_rmb();
> 	if (dev->insuspend)
> 		goto out;

Something like that can work, yes. However, you need to make sure that:

 - even when you ignore the interrupt (because the driver doesn't care, 
   it's suspending), you need to make sure the hardware gets shut up by 
   reading (or writing) the proper interrupt status register.

   Otherwise, with a level interrupt, the interrupt will continue to be 
   held active ("screaming") and the CPU will get interrupted over and 
   over again, until the irq subsystem will just turn the irq off 
   entirely.

 - when you resume, make sure that you get the engine going again, with 
   the understanding that some interrupts may have gotten ignored.

Also, in general, these kinds of things shouldn't always even be 
neicessary. If you use the suspend_late()/resume_early() hooks, those will 
be called with interrupts off, and while they can be harder to debug (and 
may be worth avoiding for non-critical drivers), they do allow for simpler 
models partly exactly because they don't need to worry about interrupts 
etc.

		Linus
