Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYGAN76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYGAN76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYGAN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:59:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:45028 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbYGAN7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,731,1204531200"; 
   d="scan'208";a="301450866"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v4 3/6] dmaengine: Add slave DMA interface
Date: Tue, 1 Jul 2008 14:59:14 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101C21ED5@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240806270225x1d6168b0i452c6e6e964157d3@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 3/6] dmaengine: Add slave DMA interface
thread-index: AcjYN+zZkrcaPsuESWy47vbfxgGH4gDSmXMg
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <haavard.skinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, <drzeus-list@drzeus.cx>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>,
       <kernel@avr32linux.org>, "Nelson, Shannon" <shannon.nelson@intel.com>,
       <david-b@pacbell.net>
X-OriginalArrivalTime: 01 Jul 2008 13:59:16.0217 (UTC) FILETIME=[A64A2E90:01C8DB82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Date: Jun 26, 2008 3:23 PM
> Subject: [PATCH v4 3/6] dmaengine: Add slave DMA interface
> To: Dan Williams <dan.j.williams@intel.com>, Pierre Ossman
> <drzeus-list@drzeus.cx>
> Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
> kernel@avr32linux.org, shannon.nelson@intel.com, David Brownell
> <david-b@pacbell.net>, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com>
> 
> 
> This patch adds the necessary interfaces to the DMA Engine framework
> to use functionality found on most embedded DMA controllers: DMA from
> and to I/O registers with hardware handshaking.
> 
> In this context, hardware hanshaking means that the peripheral that
> owns the I/O registers in question is able to tell the DMA controller
> when more data is available for reading, or when there is room for
> more data to be written. This usually happens internally on the chip,
> but these signals may also be exported outside the chip for things
> like IDE DMA, etc.
> 
> A new struct dma_slave is introduced. This contains information that
> the DMA engine driver needs to set up slave transfers to and from a
> slave device. Most engines supporting DMA slave transfers will want to
> extend this structure with controller-specific parameters.  This
> additional information is usually passed from the platform/board code
> through the client driver.
> 
> A "slave" pointer is added to the dma_client struct. This must point
> to a valid dma_slave structure iff the DMA_SLAVE capability is
> requested.  The DMA engine driver may use this information in its
> device_alloc_chan_resources hook to configure the DMA controller for
> slave transfers from and to the given slave device.
> 
> A new struct dma_slave_descriptor is added. This extends the standard
> dma_async_tx_descriptor with a few members that are needed for doing
> slave DMA from/to peripherals.
> 
> A new operation for creating such descriptors is added to struct
> dma_device. Another new operation for terminating all pending
> transfers is added as well. The latter is needed because there may be
> errors outside the scope of the DMA Engine framework that may require
> DMA operations to be terminated prematurely.
> 
> DMA Engine drivers may extend the dma_device, dma_chan and/or
> dma_slave_descriptor structures to allow controller-specific
> operations. The client driver can detect such extensions by looking at
> the DMA Engine's struct device, or it can request a specific DMA
> Engine device by setting the dma_dev field in struct dma_slave.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
> dmaslave interface changes since v3:
>  * Use dma_data_direction instead of a new enum
>  * Submit slave transfers as scatterlists
>  * Remove the DMA slave descriptor struct
> 
> dmaslave interface changes since v2:
>  * Add a dma_dev field to struct dma_slave. If set, the client can
>    only be bound to the DMA controller that corresponds to this
>    device.  This allows controller-specific extensions of the
>    dma_slave structure; if the device matches, the controller may
>    safely assume its extensions are present.
>  * Move reg_width into struct dma_slave as there are currently no
>    users that need to be able to set the width on a per-transfer
>    basis.
> 
> dmaslave interface changes since v1:
>  * Drop the set_direction and set_width descriptor hooks. Pass the
>    direction and width to the prep function instead.
>  * Declare a dma_slave struct with fixed information about a slave,
>    i.e. register addresses, handshake interfaces and such.
>  * Add pointer to a dma_slave struct to dma_client. Can be NULL if
>    the DMA_SLAVE capability isn't requested.
>  * Drop the set_slave device hook since the alloc_chan_resources hook
>    now has enough information to set up the channel for slave
>    transfers.
> ---
>  drivers/dma/dmaengine.c   |   16 ++++++++++++-
>  include/linux/dmaengine.h |   53
>  ++++++++++++++++++++++++++++++++++++++++++++- 2 files changed, 67
> insertions(+), 2 deletions(-) 
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index ad8d811..2e0035f 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -159,7 +159,12 @@ static void dma_client_chan_alloc(struct
> dma_client *client)
>        enum dma_state_client ack;
> 
>        /* Find a channel */
> -       list_for_each_entry(device, &dma_device_list, global_node)
> +       list_for_each_entry(device, &dma_device_list, global_node) {
> +               /* Does the client require a specific DMA controller?
*/
> +               if (client->slave && client->slave->dma_dev
> +                               && client->slave->dma_dev !=
device->dev)
> +                       continue;
> +
>                list_for_each_entry(chan, &device->channels,
device_node) {
>                        if (!dma_chan_satisfies_mask(chan,
client->cap_mask))
>                                continue;
> @@ -180,6 +185,7 @@ static void dma_client_chan_alloc(struct
dma_client
>                                        *client) return;
>                        }
>                }
> +       }
>  }
> 
>  enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t
cookie)
> @@ -276,6 +282,10 @@ static void dma_clients_notify_removed(struct
> dma_chan *chan)
>  */
>  void dma_async_client_register(struct dma_client *client)
>  {
> +       /* validate client data */
> +       BUG_ON(dma_has_cap(DMA_SLAVE, client->cap_mask) &&
> +               !client->slave);
> +
>        mutex_lock(&dma_list_mutex);
>        list_add_tail(&client->global_node, &dma_client_list);
>        mutex_unlock(&dma_list_mutex);
> @@ -350,6 +360,10 @@ int dma_async_device_register(struct dma_device
*device)
>                !device->device_prep_dma_memset);
>        BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
>                !device->device_prep_dma_interrupt);
> +       BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> +               !device->device_prep_slave_sg);
> +       BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> +               !device->device_terminate_all);
> 
>        BUG_ON(!device->device_alloc_chan_resources);
>        BUG_ON(!device->device_free_chan_resources);
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 4b602d3..8ce03e8 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -89,10 +89,23 @@ enum dma_transaction_type {
>        DMA_MEMSET,
>        DMA_MEMCPY_CRC32C,
>        DMA_INTERRUPT,
> +       DMA_SLAVE,
>  };
> 
>  /* last transaction type for creation of the capabilities mask */
> -#define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
> +#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
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
>  * enum dma_ctrl_flags - DMA flags to augment operation preparation,
> @@ -115,6 +128,33 @@ enum dma_ctrl_flags {
>  typedef struct { DECLARE_BITMAP(bits, DMA_TX_TYPE_END); }
dma_cap_mask_t;
> 
>  /**
> + * struct dma_slave - Information about a DMA slave
> + * @dev: device acting as DMA slave
> + * @dma_dev: required DMA master device. If non-NULL, the client can
not be
> + *     bound to other masters than this. The master driver may use
> + *     this to determine whether it's safe to access
> + * @tx_reg: physical address of data register used for
> + *     memory-to-peripheral transfers
> + * @rx_reg: physical address of data register used for
> + *     peripheral-to-memory transfers
> + * @reg_width: peripheral register width
> + *
> + * If dma_dev is non-NULL, the client can not be bound to other DMA
> + * masters than the one corresponding to this device. The DMA master
> + * driver may use this to determine if there is controller-specific
> + * data wrapped around this struct. Drivers of platform code that
sets
> + * the dma_dev field must therefore make sure to use an appropriate
> + * controller-specific dma slave structure wrapping this struct.
> + */
> +struct dma_slave {
> +       struct device           *dev;
> +       struct device           *dma_dev;
> +       dma_addr_t              tx_reg;
> +       dma_addr_t              rx_reg;
> +       enum dma_slave_width    reg_width;
> +};
> +
> +/**
>  * struct dma_chan_percpu - the per-CPU part of struct dma_chan
>  * @refcount: local_t used for open-coded "bigref" counting
>  * @memcpy_count: transaction counter
> @@ -219,11 +259,14 @@ typedef enum dma_state_client
> (*dma_event_callback) (struct dma_client *client,
>  * @event_callback: func ptr to call when something happens
>  * @cap_mask: only return channels that satisfy the requested
capabilities
>  *  a value of zero corresponds to any capability
> + * @slave: data for preparing slave transfer. Must be non-NULL iff
the
> + *  DMA_SLAVE capability is requested.
>  * @global_node: list_head for global dma_client_list
>  */
>  struct dma_client {
>        dma_event_callback      event_callback;
>        dma_cap_mask_t          cap_mask;
> +       struct dma_slave        *slave;
>        struct list_head        global_node;
>  };
> 
> @@ -280,6 +323,8 @@ struct dma_async_tx_descriptor {
>  * @device_prep_dma_zero_sum: prepares a zero_sum operation
>  * @device_prep_dma_memset: prepares a memset operation
>  * @device_prep_dma_interrupt: prepares an end of chain interrupt
operation
> + * @device_prep_slave_sg: prepares a slave dma operation
> + * @device_terminate_all: terminate all pending operations
>  * @device_issue_pending: push pending transactions to hardware
>  */
>  struct dma_device {
> @@ -315,6 +360,12 @@ struct dma_device {
>        struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
>                struct dma_chan *chan, unsigned long flags);
> 
> +       struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> +               struct dma_chan *chan, struct scatterlist *sgl,
> +               unsigned int sg_len, enum dma_data_direction
direction,
> +               unsigned long flags);
> +       void (*device_terminate_all)(struct dma_chan *chan);
> +
>        enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
>                        dma_cookie_t cookie, dma_cookie_t *last,
>                        dma_cookie_t *used);
> --
> 1.5.5.4

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Regards,
Maciej
