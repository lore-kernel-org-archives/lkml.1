Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYJBQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYJBQto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYJBQtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:49:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbYJBQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:49:35 -0400
Message-ID: <48E4FB85.2040204@linux-foundation.org>
Date: Thu, 02 Oct 2008 11:49:09 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
References: <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk> <48E3680E.6040703@linux-foundation.org> <20081001140607.GA22031@flint.arm.linux.org.uk> <48E38E30.70901@linux-foundation.org> <20081001150258.GB22031@flint.arm.linux.org.uk>
In-Reply-To: <20081001150258.GB22031@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:

>> Maybe we should make these physical addresses to avoid the casts?
> 
> Finally, we agree on something.  Yes, they should be phys addresses.
> But not for the sake of getting rid of casts, but because that's what
> the bootmem allocator _actually_ wants to have in the first place.
> 
> And, to do this, the following are going to have to be changed:
> 
> drivers/block/floppy.c: } else if ((unsigned long)current_req->buffer < MAX_DMA_ADDRESS) {
> drivers/block/floppy.c:          * Do NOT use minimum() here---MAX_DMA_ADDRESS is 64 bits wide
> drivers/block/floppy.c:             (MAX_DMA_ADDRESS -
> drivers/net/3c505.c:    if ((unsigned long)(target + rlen) >= MAX_DMA_ADDRESS) {
> drivers/net/3c505.c:    if ((unsigned long)(skb->data + nlen) >= MAX_DMA_ADDRESS || nlen != skb->len) {
> drivers/net/cs89x0.c:                   if ((unsigned long) lp->dma_buff >= MAX_DMA_ADDRESS ||
> drivers/net/wan/cosa.c: if (b+len >= MAX_DMA_ADDRESS)
> drivers/parport/parport_pc.c:   if (end < MAX_DMA_ADDRESS) {
> drivers/scsi/BusLogic.c:        if (HostAdapter->HostAdapterBusType == BusLogic_ISA_Bus && (void *) high_memory > (void *)
> drivers/scsi/BusLogic.c:        if (HostAdapter->BIOS_Address > 0 && strcmp(HostAdapter->ModelName, "BT-445S") == 0 && strc
> sound/oss/dmabuf.c:                 || end_addr >= (char *) (MAX_DMA_ADDRESS)) {
> sound/oss/sscape.c:                 || end_addr >= (char *) (MAX_DMA_ADDRESS)) {
> 
> which probably want to do the check in the phys address space anyway.

Right. Lets do it. MAX_DMA32 needs to be changed too.

While you are at it: Could you make the association with the zones clearer?

MAX_ZONE_DMA32_ADDRESS MAX_ZONE_DMA_ADDRESS, MAX_ZONE_DMA_PFN,
MAX_ZONE_DMA32_PFN ....
