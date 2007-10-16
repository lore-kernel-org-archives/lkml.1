Return-Path: <linux-kernel-owner+w=401wt.eu-S935525AbXJPTuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935525AbXJPTuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765267AbXJPTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:50:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39409 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763932AbXJPTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:50:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <471515D8.8040703@s5r6.in-berlin.de>
Date: Tue, 16 Oct 2007 21:49:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Subject: Re: [PATCH corrected] firewire: fw-ohci: fix DMA mapping for ar context
References: <tkrat.2493a847503e3d62@s5r6.in-berlin.de> <4714F652.1060007@s5r6.in-berlin.de> <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
In-Reply-To: <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> The CPU must not touch the buffer after it was DMA-mapped.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-ohci.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/drivers/firewire/fw-ohci.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-ohci.c
> +++ linux/drivers/firewire/fw-ohci.c
> @@ -258,6 +258,7 @@ static int ar_context_add_page(struct ar
>  		free_page((unsigned long) ab);
>  		return -ENOMEM;
>  	}
> +	dma_sync_single_for_cpu(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
>  
>  	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
>  	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
> 

This is still not complete:

in ar_context_add_page():
	ctx->last_buffer->descriptor.branch_address = ...;

in ar_context_tasklet():
	dma_unmap_single(ohci->card.device,
		le32_to_cpu(ab->descriptor.data_address) - offset,
		PAGE_SIZE, DMA_BIDIRECTIONAL);

They both access DMA-mapped areas.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
