Return-Path: <linux-kernel-owner+w=401wt.eu-S1765219AbXHXRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765219AbXHXRy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759183AbXHXRyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:54:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59370 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369AbXHXRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:54:16 -0400
Date: Fri, 24 Aug 2007 10:48:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH v2 -mm 5/7] I/OAT: Add support for MSI and MSI-X
Message-Id: <20070824104837.341fbc12.randy.dunlap@oracle.com>
In-Reply-To: <20070824001517.16997.72496.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
	<20070824001517.16997.72496.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:15:17 -0700 Shannon Nelson wrote:

> Add support for MSI and MSI-X interrupt handling, including the ability
> to choose the desired interrupt method.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
> 
>  drivers/dma/ioat_dma.c          |  353 ++++++++++++++++++++++++++++++++-------
>  drivers/dma/ioatdma.h           |   12 +
>  drivers/dma/ioatdma_registers.h |    6 +
>  3 files changed, 305 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index 9012176..0909fee 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -47,6 +47,71 @@
>  static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
>  static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
>  
> +#define for_each_bit(bit, addr, size) \
> +	for ((bit) = find_first_bit((addr), (size)); \
> +	     (bit) < (size); \
> +	     (bit) = find_next_bit((addr), (size), (bit) + 1))

Any reason that this macro shouldn't be added to
include/linux/bitops.h instead of here?  I'd prefer/expect such
general-purpose macros to live somewhere else.


> @@ -276,6 +352,34 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
>  			in_use_descs - 1);
>  
>  	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
> +	ioat_chan->pending = 0;
> +}
> +/**
> + * ioat_dma_get_next_descriptor - return the next available descriptor from
> + *				  the chain

Unfortunately, function name + short description in kernel-doc must be
on one line (only).  If you want to add more text/description, put it
after the parameters (like you have done :).

> + * @ioat_chan: IOAT DMA channel handle

We normally use one
 *
line between the parameters and following text.

> + * Gets the next descriptor from the chain, and must be called with the
> + * channel's desc_lock held.  Allocates more descriptors if the channel
> + * has run out.
> + */
> +static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
> +						struct ioat_dma_chan *ioat_chan)
> +{
> +	struct ioat_desc_sw *new = NULL;
> +
> +	if (!list_empty(&ioat_chan->free_desc)) {
> +		new = to_ioat_desc(ioat_chan->free_desc.next);
> +		list_del(&new->node);
> +	} else {
> +		/* try to get another desc */
> +		new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
> +		/* will this ever happen? */
> +		/* TODO add upper limit on these */
> +		BUG_ON(!new);
> +	}
> +
> +	prefetch(new->hw);
> +	return new;
>  }
>  
>  static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
> @@ -639,6 +711,162 @@ out:
>  	return err;
>  }
>  
> +static char ioat_interrupt_style[32] = "msix";
> +module_param_string(ioat_interrupt_style, ioat_interrupt_style,
> +		    sizeof(ioat_interrupt_style), 0644);
> +MODULE_PARM_DESC(ioat_interrupt_style,
> +		 "set ioat interrupt style: msix (default), "
> +		 "msix-single-vector, msi, intx)");
> +
> +/**
> + * ioat_dma_setup_interrupts - setup interrupt handler, choosing btwn msix,
> + *                             msi, and legacy

Same one-line nit.  legacy == intx, I suppose.


> + * @device: ioat device
> + */
> +int ioat_dma_setup_interrupts(struct ioatdma_device *device)
> +{
> +	struct ioat_dma_chan *ioat_chan;
> +	int err, i, j, msixcnt;
> +	u8 intrctrl = 0;
> +
> +	if (!strcmp(ioat_interrupt_style, "msix"))
> +		goto msix;
> +	else if (!strcmp(ioat_interrupt_style, "msix-single-vector"))
> +		goto msix_single_vector;
> +	else if (!strcmp(ioat_interrupt_style, "msi"))
> +		goto msi;
> +	else if (!strcmp(ioat_interrupt_style, "intx"))
> +		goto intx;

The "else"s aren't needed.

> +
> +msix:

...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
