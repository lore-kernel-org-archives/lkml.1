Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXJRXS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXJRXS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbXJRXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:18:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:55155 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXJRXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:18:18 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 09:17:29 +1000
Message-Id: <1192749449.7367.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 15:52 -0700, Linus Torvalds wrote:
> 
> On Fri, 19 Oct 2007, Benjamin Herrenschmidt wrote:
> > 
> > The barrier would guarantee that ioc->active (and in fact the write to
> > the chip too above) are globally visible
> 
> No, it doesn't really guarantee that.
> 
> The thing is, there is no such thing as "globally visible".
> 
> There is a "ordering of visibility wrt CPU's", but it's not global, it's 
> quite potentially per-CPU. So a barrier on one CPU doesn't guarantee 
> anything at all without a barrier on the *other* CPU.
> 
> That said, the interrupt handling itself contains various barriers on the 
> CPU's that receive interrupts, thanks to the spinlocking. But I do agree 
> with Herbert that adding a "smb_mb()" is certainly in no way "obviously 
> correct", because it doesn't talk about what the other side does wrt 
> barriers and that word in memory.

I agree and you can see that in fact, we don't have enough barrier on
the other side since spin_unlock doesn't prevent subsequent loads from
crossing a previous store...

I wonder if that's worth trying to address, adding a barrier in
handle_IRQ_event for example, or we can continue ignoring the barrier
and let some drivers do their own fixes in fancy ways.

Ben.


