Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYCLXbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYCLXbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYCLXbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:31:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56698 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYCLXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:31:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D8679A.10303@s5r6.in-berlin.de>
Date: Thu, 13 Mar 2008 00:30:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH] firewire: fw-ohci: use dma_alloc_coherent for ar_buffer
References: <200803121743.27170.jwilson@redhat.com>
In-Reply-To: <200803121743.27170.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Currently, we do nothing to guarantee we have a consistent DMA buffer for
> asynchronous receive packets. Rather than doing several sync's following a
> dma_map_single() to get consistent buffers, just switch to using
> dma_alloc_coherent().
> 
> Resolves constant buffer failures on my own x86_64 laptop w/4GB of RAM and
> likely to fix a number of other failures witnessed on x86_64 systems with
> 4GB of RAM or more.
> 
> Signed-off-by: Jarod Wilson <jwilson@redhat.com>

Looks good at first glance.  Alas my PCs aren't affected, so I can only 
test it for lack of regressions.

I'm tempted to push this to Linus later this week.  Unless e.g. Kristian 
has reservations.

> 
> ---
> 
>  drivers/firewire/fw-ohci.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
> index 28ea78c..081a434 100644
> --- a/drivers/firewire/fw-ohci.c
> +++ b/drivers/firewire/fw-ohci.c
> @@ -284,16 +284,10 @@ static int ar_context_add_page(struct ar_context *ctx)
>  	dma_addr_t ab_bus;
>  	size_t offset;
>  
> -	ab = (struct ar_buffer *) __get_free_page(GFP_ATOMIC);
> +	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
>  	if (ab == NULL)
>  		return -ENOMEM;
>  
> -	ab_bus = dma_map_single(dev, ab, PAGE_SIZE, DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(ab_bus)) {
> -		free_page((unsigned long) ab);
> -		return -ENOMEM;
> -	}
> -
>  	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
>  	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
>  						    DESCRIPTOR_STATUS |
> @@ -304,8 +298,6 @@ static int ar_context_add_page(struct ar_context *ctx)
>  	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
>  	ab->descriptor.branch_address = 0;
>  
> -	dma_sync_single_for_device(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
> -
>  	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
>  	ctx->last_buffer->next = ab;
>  	ctx->last_buffer = ab;
> @@ -409,6 +401,7 @@ static void ar_context_tasklet(unsigned long data)
>  
>  	if (d->res_count == 0) {
>  		size_t size, rest, offset;
> +		dma_addr_t buffer_bus;
>  
>  		/*
>  		 * This descriptor is finished and we may have a
> @@ -417,9 +410,7 @@ static void ar_context_tasklet(unsigned long data)
>  		 */
>  
>  		offset = offsetof(struct ar_buffer, data);
> -		dma_unmap_single(ohci->card.device,
> -			le32_to_cpu(ab->descriptor.data_address) - offset,
> -			PAGE_SIZE, DMA_BIDIRECTIONAL);
> +		buffer_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
>  
>  		buffer = ab;
>  		ab = ab->next;
> @@ -435,7 +426,8 @@ static void ar_context_tasklet(unsigned long data)
>  		while (buffer < end)
>  			buffer = handle_ar_packet(ctx, buffer);
>  
> -		free_page((unsigned long)buffer);
> +		dma_free_coherent(ohci->card.device, PAGE_SIZE,
> +				  buffer, buffer_bus);
>  		ar_context_add_page(ctx);
>  	} else {
>  		buffer = ctx->pointer;
> 


-- 
Stefan Richter
-=====-==--- --== -==-=
http://arcgraph.de/sr/
