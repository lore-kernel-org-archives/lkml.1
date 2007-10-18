Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbXJRCMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbXJRCMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXJRCMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:12:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbXJRCMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:12:32 -0400
Date: Wed, 17 Oct 2007 19:12:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <1192670742.12879.5.camel@pasglop>
Message-ID: <alpine.LFD.0.999.0710171906150.26902@woody.linux-foundation.org>
References: <1192670742.12879.5.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Benjamin Herrenschmidt wrote:
>  
> +	smp_mb();
>  	while (desc->status & IRQ_INPROGRESS)
>  		cpu_relax();

So, what exactly does it protect against? At a minimum, this needs a 
comment in the changelog, and probably preferably in the source code too.

The thing is, synchronize_irq() can only protect against interrupts that 
are *already*running* on another CPU, and the caller must have made sure 
that no new interrupts are coming in (or at least that whatever new 
interrupts that come in will not pick up a certain piece of data). 

So I can imagine that the smb_mb() is there so that the caller - who has 
cleared some list or done something like that - will have any preceding 
writes that it did be serialized with actually checking the old state of 
"desc->status".

Fair enough - I can see that a smp_mb() is useful. But I think it needs 
documenting as such, and preferably with an example of how this actually 
happened in the first place (do you have one?)

The synchronize_irq() users that are really fundamental (ie the irq 
datastructures themselves) all should use the irq descriptor spinlock, and 
should *not* be needing any of this, since they would have serialized with 
whoever actually set the IRQ_INPROGRESS bit in the first place.

So in *that* sense, I think the memory barrier is useless, and I can't 
make up my mind whether it's good or bad. Which is why I'd really like to 
have an example scenario spelled out where it makes a difference..

Ok?

		Linus
