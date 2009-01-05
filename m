Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZAEPtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZAEPtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZAEPs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:48:59 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63286 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbZAEPs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:48:59 -0500
Date: Mon, 5 Jan 2009 16:48:47 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
Message-ID: <20090105164847.6fbca375@hskinnemoen-d830>
In-Reply-To: <20090106.003558.115932572.anemo@mba.ocn.ne.jp>
References: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
	<20090105153024.179c9f29@hskinnemoen-d830>
	<20090106.003558.115932572.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Mon, 5 Jan 2009 15:30:24 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > > 1. map/unmap DMA buffers for slave transfer
> > > 
> > > For slave-DMA, it seems dmac driver is responsible for mapping DMA
> > > buffers, and client is responsible for unmapping them.  Is it right?  
> > 
> > No, it's the other way around, unless DMA_COMPL_SKIP_*_UNMAP is set.
> > But I think the dw_dmac driver wrongly maps the buffers before queuing
> > them.  
> 
> Well, I'm confused...  I reference atmel-mci for client and dw_dmac
> for dma engine.  Currently, dw_dmac calls dma_map_sg() and atmel-mci
> calls dma_unmap_sg().  Do you mean atmel-mci will be changed to call
> dma_map_sg()?

Yes, I think it should.

Preferably, I'd like the client to do both mapping and unmapping in all
cases since it knows best what's actually needed. For example, some
drivers may be using DMA-coherent buffers, which don't need to be
mapped at all.

> > > 4. This is a comment on head of dwc_handle_error().
> > > 
> > > 	/*
> > > 	 * The descriptor currently at the head of the active list is
> > > 	 * borked. Since we don't have any way to report errors, we'll
> > > 	 * just have to scream loudly and try to carry on.
> > > 	 */
> > > 
> > > But, the bad descriptor can be at any place of the active list, no ?
> > > For example, if the active list contained two descriptor and latter
> > > was broken and tasklet was delayed by some reason, the head of the
> > > list should be good.  
> > 
> > Since dwc_scan_descriptors() was just called, all descriptors that were
> > completed successfully have been removed from the active list. So the
> > first entry must be the broken one.  
> 
> But the removal from the active list is done in tasklet too.  If the
> CPU was slow and DMA engine was fast enough, DMA engine will process
> multiple descriptors before the tasklet called, no ?

The DMA engine stops if it encounters a bad address.

Haavard
