Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXLEPy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXLEPy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXLEPyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:54:50 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53724 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884AbXLEPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:54:49 -0500
Date: Wed, 5 Dec 2007 16:53:13 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC 1/4] dmaengine: Add slave DMA interface
Message-ID: <20071205165313.31b33cb8@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20712031120k8a3e519r6f129bbfe1462ddc@mail.gmail.com>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
	<1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20712031120k8a3e519r6f129bbfe1462ddc@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 12:20:15 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> Hi Haavard,
> 
> Some (delayed) comments.

Thanks for the feedback.

> A few questions:
> The one change that seems to be missing, at least in my mind, is
> extending struct dma_client to include details about the slave device.
>  Whereas it is assumed that a 'dmaengine' can access kernel memory,
> certain device memory regions may be out of bounds for a given
> channel.

Hmm. You mean that some channels may not be able to access the slave's
data registers? dma_set_slave() could check this, but I guess it's too
late by then. We should probably add the slave's data register addresses to
the dma_client struct so that the dma core can verify them against the
channel's dma mask when assigning channels to clients.

I suppose we should add other slave-specific data to the dma_client as
well while we're at it, like handshake interface IDs.

> > +struct dma_slave_descriptor {
> > +       struct dma_async_tx_descriptor txd;
> > +       void (*slave_set_direction)(struct dma_slave_descriptor *desc,
> > +                       enum dma_slave_direction direction);
> 
> I have come to the conclusion that the flexibility provided by
> 'tx_set_src' and 'tx_set_dest' does not really buy anything and adds
> unnecessary indirect branch overhead.  I am developing a patch to just
> add the parameters to the 'device_prep_dma_*' routines.  I assume the
> same can be said for 'slave_set_direction' unless you can think of a
> reason why it should be separate from 'device_prep_slave'?

I thought that these ops might be useful if the client wants to re-use
the descriptors for multiple transactions. But then you would probably
need a "set_length" hook in the descriptor as well.

> > +       void (*slave_set_width)(struct dma_slave_descriptor *desc,
> > +                       enum dma_slave_width width);
> > +       struct list_head client_node;
> > +};
> 
> 'slave_set_width' appears to be something that can be done once at
> channel allocation time and not per each operation.  It seems
> channel-slave associations are exclusive since you only call
> 'device_set_slave' once and do not expect those values to change.  So
> perhaps moving this all to dmaengine common code makes sense,
> something like:

The slave may support different transfer widths. For example, the MMC
driver posted in this thread may need set the controller in "byte mode"
in order to support transfer lengths that are not a multiple of 4
bytes. This means that the DMA transfer width must change as well.

> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 55c9a69..71d4ac2 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -114,10 +114,18 @@ struct dma_chan_percpu {
>         unsigned long bytes_transferred;
>  };
> 
> +struct dma_slave_data {
> +       struct device *slave;
> +       dma_addr_t tx_reg;
> +       dma_addr_t rx_reg;
> +       enum dma_slave_width width;
> +};

Yes, we probably need a struct like this. But I don't think we can
assume that the width is fixed for a given slave, and I'm not entirely
sure why we need a struct device here. The dma_mask of the slave is
irrelevant since it can't access any memory on its own.

>  /**
>   * struct dma_chan - devices supply DMA channels, clients use them
>   * @device: ptr to the dma device who supplies this channel, always !%NULL
>   * @cookie: last cookie value returned to client
> + * @slave_data: data for preparing slave transfers
>   * @chan_id: channel ID for sysfs
>   * @class_dev: class device for sysfs
>   * @refcount: kref, used in "bigref" slow-mode
> @@ -129,6 +137,7 @@ struct dma_chan_percpu {
>  struct dma_chan {
>         struct dma_device *device;
>         dma_cookie_t cookie;
> +       struct dma_slave_data slave_data;
> 
>         /* sysfs */
>         int chan_id;
> @@ -193,6 +202,7 @@ typedef enum dma_state_client
> (*dma_event_callback) (struct dma_client *client,
>  struct dma_client {
>         dma_event_callback      event_callback;
>         dma_cap_mask_t          cap_mask;
> +       struct device           *slave;
>         struct list_head        global_node;
>  };
> 
> If dma_client.slave is non-NULL the client is requesting a channel
> with the ability to talk to the given device.  If
> dma_chan.slave_data.slave is non-NULL this channel has been
> exclusively claimed by the given device.

Or perhaps make dma_chan.slave_data a pointer to struct dma_slave_data
and add a similar pointer to dma_client (or add a separate function for
registering "slave clients".) I don't see how the DMA engine core can
figure out the rest of the data in struct dma_slave_data from a struct
device.

> > +
> > +/**
> >   * struct dma_device - info on the entity supplying DMA services
> >   * @chancnt: how many DMA channels are supported
> >   * @channels: the list of struct dma_chan
> > @@ -258,6 +300,10 @@ struct dma_async_tx_descriptor {
> >   * @device_prep_dma_zero_sum: prepares a zero_sum operation
> >   * @device_prep_dma_memset: prepares a memset operation
> >   * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
> > + * @device_set_slave: set up a channel to do slave DMA for a given
> > + *     peripheral
> > + * @device_prep_slave: prepares a slave dma operation
> > + * @device_terminate_all: terminate all pending operations
> >   * @device_dependency_added: async_tx notifies the channel about new deps
> >   * @device_issue_pending: push pending transactions to hardware
> >   */
> > @@ -291,6 +337,13 @@ struct dma_device {
> >         struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
> >                 struct dma_chan *chan);
> >
> > +       void (*device_set_slave)(struct dma_chan *chan,
> > +                       dma_addr_t rx_reg, unsigned int rx_hs_id,
> > +                       dma_addr_t tx_reg, unsigned int tx_hs_id);
> 
> What is the significance of rx_hs_is and tx_hs_id?

They identify the peripheral handshaking interfaces associated with the
slave. The slave peripheral uses these to request a transfer from the
DMA controller, so the DMA controller needs to know which interface it
should respond to for a given channel.

I guess this hook can go away if we provide the information at channel
allocation time instead.

Haavard
