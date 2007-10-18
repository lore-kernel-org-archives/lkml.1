Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXJRAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXJRAit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbXJRAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:38:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762610AbXJRAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:38:05 -0400
Date: Wed, 17 Oct 2007 17:37:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shannon.nelson@intel.com, dan.j.williams@intel.com,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] I/OAT: Add completion callback for async_tx
 interface use
Message-Id: <20071017173754.cdbe4363.akpm@linux-foundation.org>
In-Reply-To: <20071018001439.31147.52329.stgit@localhost.localdomain>
References: <20071018001416.31147.86176.stgit@localhost.localdomain>
	<20071018001439.31147.52329.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 17:14:39 -0700
Shannon Nelson <shannon.nelson@intel.com> wrote:

> The async_tx interface includes a completion callback.  This adds support
> for using that callback, including using interrupts on completion.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> ---
> 
>  drivers/dma/ioat_dma.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index 117ac38..f560527 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -212,6 +212,18 @@ static dma_cookie_t ioat_tx_submit(struct dma_async_tx_descriptor *tx)
>  	} while (len && (new = ioat_dma_get_next_descriptor(ioat_chan)));
>  
>  	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
> +	if (new->async_tx.callback) {
> +		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
> +		if (first != new) {
> +			/* move callback into to last desc */
> +			new->async_tx.callback = first->async_tx.callback;
> +			new->async_tx.callback_param
> +					= first->async_tx.callback_param;
> +			first->async_tx.callback = NULL;
> +			first->async_tx.callback_param = NULL;
> +		}
> +	}
> +
>  	new->tx_cnt = desc_count;
>  	new->async_tx.ack = orig_ack; /* client is in control of this ack */
>  
> @@ -516,6 +528,11 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
>  					pci_unmap_addr(desc, src),
>  					pci_unmap_len(desc, len),
>  					PCI_DMA_TODEVICE);
> +			if (desc->async_tx.callback) {
> +				desc->async_tx.callback(
> +						desc->async_tx.callback_param);
> +				desc->async_tx.callback = NULL;
> +			}
>  		}
>  
>  		if (desc->async_tx.phys != phys_complete) {
> @@ -637,6 +654,13 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
>   */
>  #define IOAT_TEST_SIZE 2000
>  
> +static dma_async_tx_callback ioat_dma_test_callback(void *dma_async_param)
> +{
> +	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
> +		(u64)dma_async_param);
> +	return 0;
> +}

This wanted to be `return NULL'.  I'll fix.

>  /**
>   * ioat_dma_self_test - Perform a IOAT transaction to verify the HW works.
>   * @device: device to be tested
> @@ -691,6 +715,8 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
>  	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
>  			DMA_FROM_DEVICE);
>  	ioat_set_dest(addr, tx, 0);
> +	tx->callback = (void *)ioat_dma_test_callback;

This cast is unneeded, surely?  It had better be..

> +	tx->callback_param = (void *)0x8086;

eh?

>  	cookie = ioat_tx_submit(tx);
>  	if (cookie < 0) {
>  		dev_err(&device->pdev->dev,
