Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYCLXTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYCLXTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYCLXTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:19:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56123 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYCLXS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:18:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D8645B.5040305@s5r6.in-berlin.de>
Date: Thu, 13 Mar 2008 00:16:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
References: <200803121743.29438.jwilson@redhat.com>
In-Reply-To: <200803121743.29438.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> At least on my setup, where I could within seconds reliably reproduce a panic
> in handle_at_packet() by simply dd'ing from two drives on different controllers,
> the panic is gone.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=9617

Alas the panic from comment #10 is still there, i.e. instant crash when 
plugging in an LSI based CD-RW (shortly after SCSI inquiry) --- but only 
if CONFIG_DEBUG_PAGEALLOC=y.

Jarod, did your crashes happen with CONFIG_DEBUG_PAGEALLOC=n?

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

The dma_sync_single_ call should be conditional for 
packet->payload_length > 0.  You would have noticed that if my patch 
"firewire: fw-ohci: shut up false compiler warning on PPC32" wouldn't 
have shadowed the corresponding compiler warning, which would be for 
real after your patch.  And, as David wrote, the call should come before 
context_append.

However, we actually don't need it at all.

The dma_map_single(...) already syncs the payload for the device, and we 
don't access the payload after that anymore.  So this patch shouldn't do 
anything, except that it inserts a call which happens to have barrier 
characteristics on some platforms.

What we rather have to check is:

   - Are we really writing into the context program the order that we
     need to?  This includes ordering WRT MMIO writes.

   - Are we writing the branch address atomically?  (No, we don't enforce
     an atomic access at the moment, although it is very likely that the
     compiler uses an atomic access.)

(We have to expect that the controller reads a descriptor while we write 
into it.)

   - Is there a use-after-free problem somewhere?

(A pattern in the original report and in a crash that you mentioned 
looked like use of freed memory: "Faulting instruction address: 
0x6b6b6b68" in comment #1.)
-- 
Stefan Richter
-=====-==--- --== -==--
http://arcgraph.de/sr/
