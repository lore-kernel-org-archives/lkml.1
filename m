Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZFDHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZFDHcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZFDHcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:32:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60398 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbZFDHcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:32:17 -0400
Date: Thu, 4 Jun 2009 09:32:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090604073218.GT11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03 2009, Leon Woestenberg wrote:
> Hello all,
> 
> On Wed, May 13, 2009 at 6:59 PM, Steve Rottinger <steve@pentek.com> wrote:
> > is passing in the pages into splice_to_pipe.  The pages are associated
> > with a PCI BAR, not main memory.  I'm wondering if this could be a problem?
> >
> Good question; my newbie answer would be the pages need to be mapped
> in kernel space.

That is what the ->map() hook is for.

> I have a similar use case but with memory being DMA'd to host main
> memory (instead of the data sitting in your PCI device) in a character
> device driver. The driver is a complete rewrite from scratch from
> what's currently sitting-butt-ugly in staging/altpcichdma.c
> so-please-don't-look-there.
> 
> I have already implemented zero-latency overlapping transfers in the
> DMA engine (i.e. it never sits idle if async I/O is performed through
> threads), now it would be really cool to add zero-copy.
> 
> What is it my driver is expected to do?
> 
> .splice_read:
> 
> - Allocate a bunch of single pages
> - Create a scatter-gather list
> - "stuff the data pages in question into a struct page *pages[]." a la
> "fs/splice.c:vmsplice_to_pipe()"
> - Start the DMA from the device to the pages (i.e. the transfer)
> - Return.
> 
> .splice_write:
> 
> - Create a scatter-gather list
> 
> interrupt handler / DMA service routine:
> - device book keeping
> - wake_up_interruptible(transfer_queue)
> 
> .confirm():
> 
> "then you need to provide a suitable ->confirm() hook that can wait on
> this IO to complete if needed."
> - wait_on_event_interruptibe(transfer_queue)
> 
> .release():
> 
> - release the pages
> 
> .steal():
> 
> unsure

This is what allows zero copy throughout the pipe line. ->steal(), if
sucesful, should pass ownership of that page to the caller. The previous
owner must no longer modify it.

> .map
> 
> unsure

See above :-)

-- 
Jens Axboe

