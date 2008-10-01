Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYJAOuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYJAOuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYJAOup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:50:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYJAOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:50:45 -0400
Message-ID: <48E38E30.70901@linux-foundation.org>
Date: Wed, 01 Oct 2008 09:50:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
References: <1222230419-15661-21-git-send-email-nico@cam.org> <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk> <48E3680E.6040703@linux-foundation.org> <20081001140607.GA22031@flint.arm.linux.org.uk>
In-Reply-To: <20081001140607.GA22031@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:

>> Someone screwed around with the basics here. MAX_DMA_ADDRESS is no longer
>> related to MAX_DMA_PFN for the x86_32 case. What is the point of relating
>> MAX_DMA_ADDRESS to PAGE_OFFSET? Looks like we are creating more confusion
>> about the strange DMA zone.
> 
> Because it is a virtual address.  It has to be.  You're using __pa() on it,
> and __pa() ONLY takes a virtual address.

Ok. I agree you need to add a __va to it in order to convert it back later.
That was not really the point. MAX_DMA_PFN can be used as a base to calculate
MAX_DMA_ADDRESS. Both are related and currently some arches go one way and
other do vice versa. Its particularly strange that x86_32 and x86_64 go
different ways. Can we unify that to one way only and put the definition of
MAX_DMA_ADDRESS in core code?

Also as a result of the long type used for a kernel "virtual" address we have
the strange situation that all uses of MAX_DMA_ADDRESS require a cast.

>> The best would be to rename these variables to make the semantics clearer
>>
>> ZONE_DMA related variables:
>>
>> MAX_DMA_PFN -> MAX_ZONE_DMA_PFN
>> MAX_DMA_ADDRESS -> MAX_ZONE_DMA_ADDRESS
>>
>> MAX_DMA32_PFN -> MAX_ZONE_DMA32_PFN
>> MAX_DMA32_ADDRESS -> MAX_ZONE_DMA32_ADDRESS
>>
>> Then the general DMAability
>>
>> MAX_DMA_ADDRESS -> DMA_LIMIT
> 
> That's no clearer.  Are they physical addresses?  Or are they virtual
> addresses?  Can't guess that from the names.

It is clearer because the association with ZONE_DMA is in the name now. One no
longer has the impression that MAX_DMA_ADDRESS is upper bound of any DMA
transfer in the system.

Maybe we should make these physical addresses to avoid the casts? That would
avoid casts in the bootmem allocator etc etc.

