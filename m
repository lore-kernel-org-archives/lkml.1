Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYI3UMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYI3UMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYI3UMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:12:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39951 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYI3UMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:12:42 -0400
Date: Tue, 30 Sep 2008 21:12:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
Message-ID: <20080930201224.GL15911@flint.arm.linux.org.uk>
References: <1222230419-15661-21-git-send-email-nico@cam.org> <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E2846A.4030802@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 02:56:26PM -0500, Christoph Lameter wrote:
> Nicolas Pitre wrote:
> > I have implemented highmem for ARM.  To catch wrong usage of __pa() and 
> >
> > One issue is that bootmem.h uses __pa(MAX_DMA_ADDRESS). However 
> > MAX_DMA_ADDRESS on ARM is defined as 0xffffffff because there is usually 
> > no restriction on the maximum DMA-able address.
> > 
> > RMK suggested that those places should be using ISA_DMA_THRESHOLD 
> > instead -- here's an excert of our conversation on this topic:
> >
> 
> ok so do
> 
> #define MAX_DMA_ADDRESS ISA_DMA_THRESHOLD

Not correct.  MAX_DMA_ADDRESS is a virtual address.  ISA_DMA_THRESHOLD
is the last byte of _physical_ memory which ISA DMA can transfer:

include/asm-x86/scatterlist.h:#define ISA_DMA_THRESHOLD (0x00ffffff)

So what you've just suggested is completely insane.

>  >> I suspect all those places which are doing __pa(MAX_DMA_ADDRESS) really
> >> want to be using ISA_DMA_THRESHOLD - that's something to raise on LKML
> >> if it's causing problems.
> 
> MAX_DMA_ADDRESS is the highest address used for ZONE_DMA / GFP_DMA

Incorrect.  MAX_DMA_ADDRESS is the highest possible virtual DMA address:

include/asm-x86/dma.h:#define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)

Think about what that means on an x86 machine with less than 16MB of RAM.

> Does ISA_DMA_THRESHOLD have any meaning on ARM? If you use old ISA stuff then
> you need CONFIG_ZONE_DMA and therefore also MAX_DMA_ADDRESS.

As we have already covered in the past, CONFIG_ZONE_DMA has to always
be enabled on ARM because ARM always puts all memory in the first zone.
To do otherwise introduces lots of special cases, and I steadfastly
refuse to make the memory initialisation any more complicated than it
already is.

And besides, this has nothing to do with that issue.
