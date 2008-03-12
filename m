Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYCLWhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYCLWhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYCLWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:37:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43370 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297AbYCLWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:37:04 -0400
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
From: David Moore <dcm@MIT.EDU>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200803121743.29438.jwilson@redhat.com>
References: <200803121743.29438.jwilson@redhat.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 18:35:49 -0400
Message-Id: <1205361349.19600.24.camel@aries.csail.mit.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 17:43 -0400, Jarod Wilson wrote:
> diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
> index 081a434..fc45868 100644
> --- a/drivers/firewire/fw-ohci.c
> +++ b/drivers/firewire/fw-ohci.c
> @@ -780,6 +780,10 @@ at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
>  
>  	context_append(ctx, d, z, 4 - z);
>  
> +	/* Sync the DMA buffer up for the device to read from */
> +	dma_sync_single_for_device(ohci->card.device, payload_bus,
> +				   packet->payload_length, DMA_TO_DEVICE);
> +
>  	/* If the context isn't already running, start it up. */
>  	reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
>  	if ((reg & CONTEXT_RUN) == 0)
> 

Two things:

1. The dma_sync should probably be done before the context_append
because the controller could in theory start reading the data as soon as
context_append is called right?

2. As an optimization, we should attempt to allocate the payload in the
lower 32-bits of physical memory, to prevent extra memcopies on x86_64.
I think this can be done by adding GFP_DMA32 to kmalloc where the
payload was allocated in fw-cdev.c.  There might be other places where
we would benefit from GFP_DMA32 also.  Of course, these optimizations
are probably better saved for another patch.

-David

