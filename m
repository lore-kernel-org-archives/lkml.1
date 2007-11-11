Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXKKPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXKKPT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXKKPTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:19:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52745 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754601AbXKKPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:19:20 -0500
Date: Sun, 11 Nov 2007 15:18:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-ID: <20071111151835.7917a565@the-village.bc.nu>
In-Reply-To: <1658.1194792517@redhat.com>
References: <20071110200935.60d375de@the-village.bc.nu>
	<20071109195303.edbdc631.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
	<24343.1194697130@redhat.com>
	<1658.1194792517@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So you would say change the global h/w register variables[*] to be addresses
> instead, and change all the references to be readX and writeX?  I'm wary of

Ok so these are not addresses but magic registers in the processor ? Then
I guess volatile makes complete sense.

> > Similarly spin_lock/unlock are store barriers so for ring buffers should
> > be sufficient unless you have cache management requirements in which case
> > the dma_* APIs will handle those bits.
> 
> I don't actually need locks, but sticking smp_rmb()/smp_wmb() is probably the
> right thing to do now that I know how to use them.  This code was written five
> or six years ago and I haven't really thought about changing that since.
> 
> I don't see how the dma_* APIs would help.  The buffer is filled by a higher
> priority interrupt routine that does 'virtual DMA'.  It's not actually done by
> real DMA.  Normal interrupt disablement doesn't really disable interrupts, it
> justs excludes normal priority interrupts.

For real DMA the dma_ APIs keep coherency

> The virtual DMA is done is ASM as it has to be really quick.  It's unfortunate,
> but, the on-chip serial ports don't have a FIFO.

For PIO (virtual DMA or otherwise) the locking does that. Because
spin_unlock and spin_lock are compiler barriers the need to use volatile
shouldn't normally be there. If you are doing it via asm without locks
then I would expect atomic_t because the sematics of volatile are
horribly vague on their own ?

