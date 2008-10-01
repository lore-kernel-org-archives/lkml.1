Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYJAMIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYJAMIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYJAMIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:08:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYJAMIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:08:05 -0400
Message-ID: <48E3680E.6040703@linux-foundation.org>
Date: Wed, 01 Oct 2008 07:07:42 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
References: <1222230419-15661-21-git-send-email-nico@cam.org> <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk>
In-Reply-To: <20080930201224.GL15911@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:

> Not correct.  MAX_DMA_ADDRESS is a virtual address.  ISA_DMA_THRESHOLD
> is the last byte of _physical_ memory which ISA DMA can transfer:

> include/asm-x86/scatterlist.h:#define ISA_DMA_THRESHOLD (0x00ffffff)
> 
> So what you've just suggested is completely insane.

Someone screwed around with the basics here. MAX_DMA_ADDRESS is no longer
related to MAX_DMA_PFN for the x86_32 case. What is the point of relating
MAX_DMA_ADDRESS to PAGE_OFFSET? Looks like we are creating more confusion
about the strange DMA zone.

The best would be to rename these variables to make the semantics clearer

ZONE_DMA related variables:

MAX_DMA_PFN -> MAX_ZONE_DMA_PFN
MAX_DMA_ADDRESS -> MAX_ZONE_DMA_ADDRESS

MAX_DMA32_PFN -> MAX_ZONE_DMA32_PFN
MAX_DMA32_ADDRESS -> MAX_ZONE_DMA32_ADDRESS

Then the general DMAability

MAX_DMA_ADDRESS -> DMA_LIMIT


> Incorrect.  MAX_DMA_ADDRESS is the highest possible virtual DMA address:

MAX_DMA_ADDRESS is the highest possible address for the DMA zone. Not the
highest possible address that any DMA controller can use. And now we have
special casing that makes the semantics different between 32 bit and 64 bit
x86? Insane! Please clean up the fuzzy semantics.

> include/asm-x86/dma.h:#define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)
> 
> Think about what that means on an x86 machine with less than 16MB of RAM.

> As we have already covered in the past, CONFIG_ZONE_DMA has to always
> be enabled on ARM because ARM always puts all memory in the first zone.
> To do otherwise introduces lots of special cases, and I steadfastly
> refuse to make the memory initialisation any more complicated than it
> already is.

I believe we have been over this. If you just have one zone then the core code
would expect you to disable CONFIG_ZONE_DMA and have all memory treated equal
in ZONE_NORMAL.

The naming seems to be the problem here. Maybe renaming ZONE_DMA to
ZONE_RESTRICTED_DMA or something would help. We are currently creating two
different paradigms of using these constants.



