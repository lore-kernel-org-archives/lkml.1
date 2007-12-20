Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXLTHHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXLTHHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbXLTHHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:07:05 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:45919 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbXLTHHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:07:04 -0500
To: rusty@rustcorp.com.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200712201649.31254.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au>
	<200712201648.58480.rusty@rustcorp.com.au>
	<200712201649.31254.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071220160631S.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 20 Dec 2007 16:06:31 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 16:49:30 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Obvious counterpart to dma_map_sg.  Note that this is arch-independent
> code; sg_rings are backwards compatible with simple sg arrays.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/base/dma-mapping.c  |   13 +++++++++++++
>  include/linux/dma-mapping.h |    4 ++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
> --- a/drivers/base/dma-mapping.c
> +++ b/drivers/base/dma-mapping.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/dma-mapping.h>
> +#include <linux/sg_ring.h>
>  
>  /*
>   * Managed DMA API
> @@ -162,6 +163,59 @@ void dmam_free_noncoherent(struct device
>  }
>  EXPORT_SYMBOL(dmam_free_noncoherent);
>  
> +/**
> + * dma_map_sg_ring - Map an entire sg ring
> + * @dev: Device to free noncoherent memory for
> + * @sg: The sg_ring
> + * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> + *
> + * This returns -ENOMEM if mapping fails.  It's not clear that telling you
> + * it failed is useful though.
> + */
> +int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
> +		     enum dma_data_direction direction)
> +{
> +	struct sg_ring *i;
> +	unsigned int num;
> +
> +	for (i = sg; i; i = sg_ring_next(i, sg)) {
> +		BUG_ON(i->num > i->max);
> +		num = dma_map_sg(dev, i->sg, i->num, direction);
> +		if (num == 0 && i->num != 0)
> +			goto unmap;
> +	}
> +	return 0;

I don't think that this works for IOMMUs that could merge sg entries.
