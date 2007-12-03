Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbXLCTUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbXLCTUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXLCTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:20:20 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:55228 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752990AbXLCTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FjTqFmn/eK1dKjF9w64P+US7B/KaiXNhy0gJRiyNXmY4sMqQWfMeIUCpaxVsHWfM8Ml8oh/AWD9oMZ3oBMy+lr4ac9Zxirp2zO4nj0yqeAsF6l33l/daSzKV5ius3yGx2Z0RdlVWabrq9UXPxFVc+DlCd1tQh1LNUjYKgqitHYw=
Message-ID: <e9c3a7c20712031120k8a3e519r6f129bbfe1462ddc@mail.gmail.com>
Date: Mon, 3 Dec 2007 12:20:15 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC 1/4] dmaengine: Add slave DMA interface
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
	 <1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 6f49a7e89b72d10a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

Some (delayed) comments.

On Nov 23, 2007 5:20 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> Add a new struct dma_slave_descriptor which extends the standard
> dma_async_tx_descriptor with a few members that are needed for doing
> DMA from/to peripherals with hardware handshaking (aka slave DMA.)
>
> Add new operations to struct dma_device for creating such descriptors,
> for setting up the controller to do slave DMA for a given device, and
> for terminating all pending transfers. The latter is needed because
> there may be errors outside the scope of the DMA Engine framework that
> requires DMA operations to be terminated prematurely.
>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/dma/dmaengine.c   |    6 +++++
>  include/linux/dmaengine.h |   55 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 60 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index ec7e871..3d17918 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -362,6 +362,12 @@ int dma_async_device_register(struct dma_device *device)
>                 !device->device_prep_dma_memset);
>         BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
>                 !device->device_prep_dma_interrupt);
> +       BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> +               !device->device_set_slave);
> +       BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> +               !device->device_prep_slave);
> +       BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> +               !device->device_terminate_all);
>
>         BUG_ON(!device->device_alloc_chan_resources);
>         BUG_ON(!device->device_free_chan_resources);
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 55c9a69..e81189f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h

A few questions:
The one change that seems to be missing, at least in my mind, is
extending struct dma_client to include details about the slave device.
 Whereas it is assumed that a 'dmaengine' can access kernel memory,
certain device memory regions may be out of bounds for a given
channel.

> @@ -89,10 +89,33 @@ enum dma_transaction_type {
>         DMA_MEMSET,
>         DMA_MEMCPY_CRC32C,
>         DMA_INTERRUPT,
> +       DMA_SLAVE,
>  };
>
>  /* last transaction type for creation of the capabilities mask */
> -#define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
> +#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
> +
> +/**
> + * enum dma_slave_direction - direction of a DMA slave transfer
> + * @DMA_SLAVE_TO_MEMORY: Transfer data from peripheral to memory
> + * @DMA_SLAVE_FROM_MEMORY: Transfer data from memory to peripheral
> + */
> +enum dma_slave_direction {
> +       DMA_SLAVE_TO_MEMORY,
> +       DMA_SLAVE_FROM_MEMORY,
> +};
> +
> +/**
> + * enum dma_slave_width - DMA slave register access width.
> + * @DMA_SLAVE_WIDTH_8BIT: Do 8-bit slave register accesses
> + * @DMA_SLAVE_WIDTH_16BIT: Do 16-bit slave register accesses
> + * @DMA_SLAVE_WIDTH_32BIT: Do 32-bit slave register accesses
> + */
> +enum dma_slave_width {
> +       DMA_SLAVE_WIDTH_8BIT,
> +       DMA_SLAVE_WIDTH_16BIT,
> +       DMA_SLAVE_WIDTH_32BIT,
> +};
>
>  /**
>   * dma_cap_mask_t - capabilities bitmap modeled after cpumask_t.
> @@ -240,6 +263,25 @@ struct dma_async_tx_descriptor {
>  };
>
>  /**
> + * struct dma_slave_descriptor - extended DMA descriptor for slave DMA
> + * @async_tx: async transaction descriptor
> + * @slave_set_direction: set the direction of the slave DMA
> + *     transaction in the hardware descriptor
> + * @slave_set_width: set the slave register access width in the
> + *     hardware descriptor
> + * @client_node: for use by the client, for example when operating on
> + *     scatterlists.
> + */
> +struct dma_slave_descriptor {
> +       struct dma_async_tx_descriptor txd;
> +       void (*slave_set_direction)(struct dma_slave_descriptor *desc,
> +                       enum dma_slave_direction direction);

I have come to the conclusion that the flexibility provided by
'tx_set_src' and 'tx_set_dest' does not really buy anything and adds
unnecessary indirect branch overhead.  I am developing a patch to just
add the parameters to the 'device_prep_dma_*' routines.  I assume the
same can be said for 'slave_set_direction' unless you can think of a
reason why it should be separate from 'device_prep_slave'?

> +       void (*slave_set_width)(struct dma_slave_descriptor *desc,
> +                       enum dma_slave_width width);
> +       struct list_head client_node;
> +};

'slave_set_width' appears to be something that can be done once at
channel allocation time and not per each operation.  It seems
channel-slave associations are exclusive since you only call
'device_set_slave' once and do not expect those values to change.  So
perhaps moving this all to dmaengine common code makes sense,
something like:

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 55c9a69..71d4ac2 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -114,10 +114,18 @@ struct dma_chan_percpu {
        unsigned long bytes_transferred;
 };

+struct dma_slave_data {
+       struct device *slave;
+       dma_addr_t tx_reg;
+       dma_addr_t rx_reg;
+       enum dma_slave_width width;
+};
+
 /**
  * struct dma_chan - devices supply DMA channels, clients use them
  * @device: ptr to the dma device who supplies this channel, always !%NULL
  * @cookie: last cookie value returned to client
+ * @slave_data: data for preparing slave transfers
  * @chan_id: channel ID for sysfs
  * @class_dev: class device for sysfs
  * @refcount: kref, used in "bigref" slow-mode
@@ -129,6 +137,7 @@ struct dma_chan_percpu {
 struct dma_chan {
        struct dma_device *device;
        dma_cookie_t cookie;
+       struct dma_slave_data slave_data;

        /* sysfs */
        int chan_id;
@@ -193,6 +202,7 @@ typedef enum dma_state_client
(*dma_event_callback) (struct dma_client *client,
 struct dma_client {
        dma_event_callback      event_callback;
        dma_cap_mask_t          cap_mask;
+       struct device           *slave;
        struct list_head        global_node;
 };

If dma_client.slave is non-NULL the client is requesting a channel
with the ability to talk to the given device.  If
dma_chan.slave_data.slave is non-NULL this channel has been
exclusively claimed by the given device.

> +
> +/**
>   * struct dma_device - info on the entity supplying DMA services
>   * @chancnt: how many DMA channels are supported
>   * @channels: the list of struct dma_chan
> @@ -258,6 +300,10 @@ struct dma_async_tx_descriptor {
>   * @device_prep_dma_zero_sum: prepares a zero_sum operation
>   * @device_prep_dma_memset: prepares a memset operation
>   * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
> + * @device_set_slave: set up a channel to do slave DMA for a given
> + *     peripheral
> + * @device_prep_slave: prepares a slave dma operation
> + * @device_terminate_all: terminate all pending operations
>   * @device_dependency_added: async_tx notifies the channel about new deps
>   * @device_issue_pending: push pending transactions to hardware
>   */
> @@ -291,6 +337,13 @@ struct dma_device {
>         struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
>                 struct dma_chan *chan);
>
> +       void (*device_set_slave)(struct dma_chan *chan,
> +                       dma_addr_t rx_reg, unsigned int rx_hs_id,
> +                       dma_addr_t tx_reg, unsigned int tx_hs_id);

What is the significance of rx_hs_is and tx_hs_id?

> +       struct dma_slave_descriptor *(*device_prep_slave)(
> +               struct dma_chan *chan, size_t len, int int_en);
> +       void (*device_terminate_all)(struct dma_chan *chan);
> +
>         void (*device_dependency_added)(struct dma_chan *chan);
>         enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
>                         dma_cookie_t cookie, dma_cookie_t *last,
> --

Regards,
Dan
