Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYJAOHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYJAOHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYJAOG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:06:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36327 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYJAOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:06:56 -0400
Date: Wed, 1 Oct 2008 15:06:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
Message-ID: <20081001140607.GA22031@flint.arm.linux.org.uk>
References: <1222230419-15661-21-git-send-email-nico@cam.org> <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk> <48E3680E.6040703@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3680E.6040703@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 07:07:42AM -0500, Christoph Lameter wrote:
> Russell King - ARM Linux wrote:
> 
> > Not correct.  MAX_DMA_ADDRESS is a virtual address.  ISA_DMA_THRESHOLD
> > is the last byte of _physical_ memory which ISA DMA can transfer:
> 
> > include/asm-x86/scatterlist.h:#define ISA_DMA_THRESHOLD (0x00ffffff)
> > 
> > So what you've just suggested is completely insane.
> 
> Someone screwed around with the basics here. MAX_DMA_ADDRESS is no longer
> related to MAX_DMA_PFN for the x86_32 case. What is the point of relating
> MAX_DMA_ADDRESS to PAGE_OFFSET? Looks like we are creating more confusion
> about the strange DMA zone.

Because it is a virtual address.  It has to be.  You're using __pa() on it,
and __pa() ONLY takes a virtual address.

> The best would be to rename these variables to make the semantics clearer
> 
> ZONE_DMA related variables:
> 
> MAX_DMA_PFN -> MAX_ZONE_DMA_PFN
> MAX_DMA_ADDRESS -> MAX_ZONE_DMA_ADDRESS
> 
> MAX_DMA32_PFN -> MAX_ZONE_DMA32_PFN
> MAX_DMA32_ADDRESS -> MAX_ZONE_DMA32_ADDRESS
> 
> Then the general DMAability
> 
> MAX_DMA_ADDRESS -> DMA_LIMIT

That's no clearer.  Are they physical addresses?  Or are they virtual
addresses?  Can't guess that from the names.

> > Incorrect.  MAX_DMA_ADDRESS is the highest possible virtual DMA address:
> 
> MAX_DMA_ADDRESS is the highest possible address for the DMA zone. Not the
> highest possible address that any DMA controller can use.

Semantically disagree.

If you only have a controller which can address 1MB of memory (yes, they do
exist) then MAX_DMA_ADDRESS must be PAGE_OFFSET + 1MB, otherwise you have
precisely NO way to obtain memory from the kernel for this DMA controller
- and that means you want the DMA zone to be sized to 1MB.  So _indirectly_
it's true that MAX_DMA_ADDRESS is the highest possible address for the DMA
zone.
