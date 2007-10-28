Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXJ1TSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXJ1TSC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXJ1TRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:17:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:37144 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXJ1TRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uNcHnIIDFhKlvqq+BlatCJJTvtmQHevfrE0gd1xwzf9QK4NB2kJGsf9ZIAqcUXC8rHWx81dtumq3dwwETIeKynQXQvnEkQppXVDjx93R88l03IR6Ppf1XY8AZV2tqdzYNZlkQqHLEhZs1mOcthl5N7sWl/QoU7qyW1I72P0psFA=
Message-ID: <3cce60f30710281217h44abb72dvece026e4e079da5f@mail.gmail.com>
Date: Sun, 28 Oct 2007 12:17:48 -0700
From: "Shannon Nelson" <shannon.lee.nelson@gmail.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] DMA: Fix broken device refcounting
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
In-Reply-To: <1193512357.18911.6.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1193415162504-git-send-email-hskinnemoen@atmel.com>
	 <1193416577.9353.5.camel@dwillia2-linux.ch.intel.com>
	 <20071027154947.6836a3d9@siona>
	 <1193512357.18911.6.camel@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/07, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, 2007-10-27 at 06:49 -0700, Haavard Skinnemoen wrote:
> > On Fri, 26 Oct 2007 09:36:17 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > > @@ -221,7 +220,6 @@ void dma_chan_cleanup(struct kref *kref)
> > >  {
> > >       struct dma_chan *chan = container_of(kref, struct dma_chan, refcount);
> > >       chan->device->device_free_chan_resources(chan);
> > > -     kref_put(&chan->device->refcount, dma_async_device_cleanup);
> > >  }
> > >  EXPORT_SYMBOL(dma_chan_cleanup);
> >
> > While I can't see any problems with the rest of the patch, I think this
> > part is wrong for the same reasons removing the kref_put() from the
> > class device cleanup function is. I don't see any constraint that
> > guarantees that dma_chan_cleanup() will always be called before
> > dma_dev_release(), which means that "chan" may have been freed before
> > this function gets a chance to run. Please correct me if I'm wrong.
>
> Absolutely right, the driver, not dmaengine, frees the memory so there
> must be a per channel reference on the device to hold off the driver's
> remove routine.
> >
> > Håvard
>
> So how about this...
>
> ---snip---
> dmaengine: Fix broken device refcounting
>
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
>
> When a DMA device is unregistered, its reference count is decremented
> twice for each channel: Once dma_class_dev_release() and once in
> dma_chan_cleanup(). This may result in the DMA device driver's
> remove() function completing before all channels have been cleaned
> up, causing lots of use-after-free fun.
>
> Fix it by incrementing the device's reference count twice for each
> channel during registration.
>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> [dan.j.williams@intel.com: kill unnecessary client refcounting]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
>  drivers/dma/dmaengine.c |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 84257f7..ec7e871 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -186,10 +186,9 @@ static void dma_client_chan_alloc(struct dma_client *client)
>                                 /* we are done once this client rejects
>                                  * an available resource
>                                  */
> -                               if (ack == DMA_ACK) {
> +                               if (ack == DMA_ACK)
>                                         dma_chan_get(chan);
> -                                       kref_get(&device->refcount);
> -                               } else if (ack == DMA_NAK)
> +                               else if (ack == DMA_NAK)
>                                         return;
>                         }
>                 }
> @@ -276,11 +275,8 @@ static void dma_clients_notify_removed(struct dma_chan *chan)
>                 /* client was holding resources for this channel so
>                  * free it
>                  */
> -               if (ack == DMA_ACK) {
> +               if (ack == DMA_ACK)
>                         dma_chan_put(chan);
> -                       kref_put(&chan->device->refcount,
> -                               dma_async_device_cleanup);
> -               }
>         }
>
>         mutex_unlock(&dma_list_mutex);
> @@ -320,11 +316,8 @@ void dma_async_client_unregister(struct dma_client *client)
>                         ack = client->event_callback(client, chan,
>                                 DMA_RESOURCE_REMOVED);
>
> -                       if (ack == DMA_ACK) {
> +                       if (ack == DMA_ACK)
>                                 dma_chan_put(chan);
> -                               kref_put(&chan->device->refcount,
> -                                       dma_async_device_cleanup);
> -                       }
>                 }
>
>         list_del(&client->global_node);
> @@ -401,6 +394,8 @@ int dma_async_device_register(struct dma_device *device)
>                         goto err_out;
>                 }
>
> +               /* One for the channel, one of the class device */
> +               kref_get(&device->refcount);
>                 kref_get(&device->refcount);
>                 kref_init(&chan->refcount);
>                 chan->slow_ref = 0;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks - when I get back in tomorrow morning I'll test this to see
that it gets rid of the panic that I've been getting.

sln
-- 
==============================================
Mr. Shannon Nelson         Parents can't afford to be squeamish.
