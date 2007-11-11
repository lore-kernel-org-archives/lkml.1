Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbXKKOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbXKKOs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXKKOst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:48:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbXKKOss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:48:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071110200935.60d375de@the-village.bc.nu>
References: <20071110200935.60d375de@the-village.bc.nu> <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 14:48:37 +0000
Message-ID: <1658.1194792517@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> memory mapped registers should be read with readw and friends and that
> should contain the volatile not the public code.

So you would say change the global h/w register variables[*] to be addresses
instead, and change all the references to be readX and writeX?  I'm wary of
doing that in case some special logic needs to be inserted in there to handle
funny buses differently.  I used to have code like that in there, though
there's none at the moment.  On the other hand, since the CPU addresses are for
the most part constants, I can probably do something clever with
__builtin_const_p() if it comes to that.

 [*] This includes auxiliary CPU control registers, though I suppose that
     doesn't make any difference.

> Similarly spin_lock/unlock are store barriers so for ring buffers should
> be sufficient unless you have cache management requirements in which case
> the dma_* APIs will handle those bits.

I don't actually need locks, but sticking smp_rmb()/smp_wmb() is probably the
right thing to do now that I know how to use them.  This code was written five
or six years ago and I haven't really thought about changing that since.

I don't see how the dma_* APIs would help.  The buffer is filled by a higher
priority interrupt routine that does 'virtual DMA'.  It's not actually done by
real DMA.  Normal interrupt disablement doesn't really disable interrupts, it
justs excludes normal priority interrupts.

The virtual DMA is done is ASM as it has to be really quick.  It's unfortunate,
but, the on-chip serial ports don't have a FIFO.

David
