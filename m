Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZAEOar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZAEOar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZAEOai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:30:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51766 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753905AbZAEOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:30:37 -0500
Date: Mon, 5 Jan 2009 15:30:24 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
Message-ID: <20090105153024.179c9f29@hskinnemoen-d830>
In-Reply-To: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
References: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> Hi.  I'm writing a new DMA driver, using dw_dmac driver in kernel
> 2.6.28 as a reference implementation.
> 
> I can see an outline of the dw_dmac driver and framework (well,
> hopefully), but have some questions in details.
> 
> 
> 1. map/unmap DMA buffers for slave transfer
> 
> For slave-DMA, it seems dmac driver is responsible for mapping DMA
> buffers, and client is responsible for unmapping them.  Is it right?

No, it's the other way around, unless DMA_COMPL_SKIP_*_UNMAP is set.
But I think the dw_dmac driver wrongly maps the buffers before queuing
them.

> Now dwc_descriptor_complete() unmaps DMA buffer unless
> DMA_COMPL_SKIP_XXX_UNMAP set.  These unmapping should be done only for
> non-slave transfers?  I.e. I suppose "if (!dwc->dws)" is required
> around dma_unmap_page() pair.

Yes, perhaps. Or we could just forcibly set those flags in
prep_slave_sg().

> I also wonder why dwc_prep_slave_sg() calculates total_len. The
> total_len is stored in first descriptor of the chain and it is only
> referenced for unmapping DMA buffers.  But the scatterlist may contain
> uncontinuous buffers, so they can not be unmaped at a time.

Yes, it is indeed a bit pointless to keep the total length around for
scatterlists.

> 2.  dwc_is_tx_complete() and dwc->lock
> 
> The function dwc_is_tx_complete() calls dwc_scan_descriptors() without
> dwc->lock (and disabling bh).  Is it safe?  All other callers of
> dwc_scan_descriptors() take dwc->lock and disable bh.

No, that does indeed look unsafe. We should probably take dwc->lock and
disable bh around the call to dwc_scan_descriptors().

> 3.  dwc->queue list management
> 
> The function dwc_tx_submit() add the descriptor to dwc->queue list if
> active list was not empty.  But it does not manage lli.llp list.  And
> all descriptors in the queue list will be moved to active list at a
> time.  So it seems non-first descriptors in queue list will never
> processed by the hardware.
> 
> The dwc_tx_submit() should rewrite lli.llp of the last descriptor in
> queue list (it it had children, the last children of it) by txd.phys
> of newly queued descriptor.  Or, only first elements of queue list
> should be moved to active list at a time.
> 
> Is my analysis correct?

Yes, I think you're right. lli.llp of the last queued entry should be
updated when adding new entries to the queue.

> 
> BTW, I found some redundant code in the driver.
> 
> * memset(dw, 0, sizeof *dw) seems redundant while dw is allocated
>   kzalloc().

Indeed.

> * platform_get_drvdata(pdev) is called twice in dw_shutdown,
>   dw_suspend_late.
> 
> Both of them harmless.

Right.

> 4. This is a comment on head of dwc_handle_error().
> 
> 	/*
> 	 * The descriptor currently at the head of the active list is
> 	 * borked. Since we don't have any way to report errors, we'll
> 	 * just have to scream loudly and try to carry on.
> 	 */
> 
> But, the bad descriptor can be at any place of the active list, no ?
> For example, if the active list contained two descriptor and latter
> was broken and tasklet was delayed by some reason, the head of the
> list should be good.

Since dwc_scan_descriptors() was just called, all descriptors that were
completed successfully have been removed from the active list. So the
first entry must be the broken one.

Haavard
