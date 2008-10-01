Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYJAPDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYJAPDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYJAPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:03:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58353 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJAPDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:03:14 -0400
Date: Wed, 1 Oct 2008 16:02:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
Message-ID: <20081001150258.GB22031@flint.arm.linux.org.uk>
References: <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk> <48E3680E.6040703@linux-foundation.org> <20081001140607.GA22031@flint.arm.linux.org.uk> <48E38E30.70901@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E38E30.70901@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 09:50:24AM -0500, Christoph Lameter wrote:
> Russell King - ARM Linux wrote:
> >> The best would be to rename these variables to make the semantics clearer
> >>
> >> ZONE_DMA related variables:
> >>
> >> MAX_DMA_PFN -> MAX_ZONE_DMA_PFN
> >> MAX_DMA_ADDRESS -> MAX_ZONE_DMA_ADDRESS
> >>
> >> MAX_DMA32_PFN -> MAX_ZONE_DMA32_PFN
> >> MAX_DMA32_ADDRESS -> MAX_ZONE_DMA32_ADDRESS
> >>
> >> Then the general DMAability
> >>
> >> MAX_DMA_ADDRESS -> DMA_LIMIT
> > 
> > That's no clearer.  Are they physical addresses?  Or are they virtual
> > addresses?  Can't guess that from the names.
> 
> It is clearer because the association with ZONE_DMA is in the name now.
> One no longer has the impression that MAX_DMA_ADDRESS is upper bound of
> any DMA transfer in the system.

... so you didn't get my point.

> Maybe we should make these physical addresses to avoid the casts?

Finally, we agree on something.  Yes, they should be phys addresses.
But not for the sake of getting rid of casts, but because that's what
the bootmem allocator _actually_ wants to have in the first place.

And, to do this, the following are going to have to be changed:

drivers/block/floppy.c: } else if ((unsigned long)current_req->buffer < MAX_DMA_ADDRESS) {
drivers/block/floppy.c:          * Do NOT use minimum() here---MAX_DMA_ADDRESS is 64 bits wide
drivers/block/floppy.c:             (MAX_DMA_ADDRESS -
drivers/net/3c505.c:    if ((unsigned long)(target + rlen) >= MAX_DMA_ADDRESS) {
drivers/net/3c505.c:    if ((unsigned long)(skb->data + nlen) >= MAX_DMA_ADDRESS || nlen != skb->len) {
drivers/net/cs89x0.c:                   if ((unsigned long) lp->dma_buff >= MAX_DMA_ADDRESS ||
drivers/net/wan/cosa.c: if (b+len >= MAX_DMA_ADDRESS)
drivers/parport/parport_pc.c:   if (end < MAX_DMA_ADDRESS) {
drivers/scsi/BusLogic.c:        if (HostAdapter->HostAdapterBusType == BusLogic_ISA_Bus && (void *) high_memory > (void *)
drivers/scsi/BusLogic.c:        if (HostAdapter->BIOS_Address > 0 && strcmp(HostAdapter->ModelName, "BT-445S") == 0 && strc
sound/oss/dmabuf.c:                 || end_addr >= (char *) (MAX_DMA_ADDRESS)) {
sound/oss/sscape.c:                 || end_addr >= (char *) (MAX_DMA_ADDRESS)) {

which probably want to do the check in the phys address space anyway.
