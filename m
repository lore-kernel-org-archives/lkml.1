Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZJ2Wqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZJ2Wqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZJ2Wqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:46:34 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:42271 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbZJ2Wqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Du4e8WLARzTfZOOxS775WUyPnibJo6VrewB+b557M4MVBmndq29d2qQqgdSoQrTpuO
         kVoDvIO3vXzhVzV9nhcGmACSSYYaMPpoYztH9cM/99FD5O5P69vXFTsTTcRZQI0QtcJz
         jhxuXN7nb8hC2O7BIV6yIkN+qjU29b2D9YJtk=
MIME-Version: 1.0
In-Reply-To: <1255588866-4133-2-git-send-email-Vishnu@freescale.com>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
	 <1255588866-4133-2-git-send-email-Vishnu@freescale.com>
Date: Thu, 29 Oct 2009 15:46:37 -0700
X-Google-Sender-Auth: d8b4e55156e4ac53
Message-ID: <e9c3a7c20910291546r2603e191g87a23023c32f1b1b@mail.gmail.com>
Subject: Re: [PATCH v0 2/2] Crypto: Talitos: Support for Async_tx XOR offload
From: Dan Williams <dan.j.williams@intel.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       herbert@gondor.apana.org.au, Kim Phillips <kim.phillips@freescale.com>,
       Dipen Dudhat <Dipen.Dudhat@freescale.com>,
       Maneesh Gupta <Maneesh.Gupta@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh <Vishnu@freescale.com> wrote:
[..]
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index b08403d..343e578 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -192,6 +192,8 @@ config CRYPTO_DEV_TALITOS
>        select CRYPTO_ALGAPI
>        select CRYPTO_AUTHENC
>        select HW_RANDOM
> +       select DMA_ENGINE
> +       select ASYNC_XOR

You need only select DMA_ENGINE.  ASYNC_XOR is selected by its users.

>        depends on FSL_SOC
>        help
>          Say 'Y' here to use the Freescale Security Engine (SEC)
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c47ffe8..84819d4 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
[..]
> +static void talitos_process_pending(struct talitos_xor_chan *xor_chan)
> +{
> +       struct talitos_xor_desc *desc, *_desc;
> +       unsigned long flags;
> +       int status;
> +
> +       spin_lock_irqsave(&xor_chan->desc_lock, flags);
> +
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->pending_q, node) {
> +               status = talitos_submit(xor_chan->dev, &desc->hwdesc,
> +                                       talitos_release_xor, desc);
> +               if (status != -EINPROGRESS)
> +                       break;
> +
> +               list_del(&desc->node);
> +               list_add_tail(&desc->node, &xor_chan->in_progress_q);
> +       }
> +
> +       spin_unlock_irqrestore(&xor_chan->desc_lock, flags);
> +}

The driver uses spin_lock_bh everywhere else which is either a bug, or
this code is being overly protective.  In any event lockdep will
rightly complain about this.  The API and its users do not submit
operations in hard-irq context.

> +
> +static void talitos_release_xor(struct device *dev, struct talitos_desc *hwdesc,
> +                               void *context, int error)
> +{
> +       struct talitos_xor_desc *desc = context;
> +       struct talitos_xor_chan *xor_chan;
> +       dma_async_tx_callback callback;
> +       void *callback_param;
> +
> +       if (unlikely(error)) {
> +               dev_err(dev, "xor operation: talitos error %d\n", error);
> +               BUG();
> +       }
> +
> +       xor_chan = container_of(desc->async_tx.chan, struct talitos_xor_chan,
> +                               common);
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       if (xor_chan->completed_cookie < desc->async_tx.cookie)
> +               xor_chan->completed_cookie = desc->async_tx.cookie;
> +
> +       callback = desc->async_tx.callback;
> +       callback_param = desc->async_tx.callback_param;
> +
> +       if (callback) {
> +               spin_unlock_bh(&xor_chan->desc_lock);
> +               callback(callback_param);
> +               spin_lock_bh(&xor_chan->desc_lock);
> +       }

You do not need to unlock to call the callback.  Users of the API
assume that they are called in bh context and that they are not
allowed to submit new operations directly from the callback (this
simplifies the descriptor cleanup routines in other drivers).

> +
> +       list_del(&desc->node);
> +       list_add_tail(&desc->node, &xor_chan->free_desc);
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +       if (!list_empty(&xor_chan->pending_q))
> +               talitos_process_pending(xor_chan);
> +}

It appears this routine is missing a call to dma_run_dependencies()?
This is needed if another channel is handling memory copy offload.  I
assume this is the case due to your other patch to fsldma.  See
iop_adma_run_tx_complete_actions().  If this xor resource can also
handle copy operations that would be more efficient as it eliminates
channel switching.  See the ioatdma driver and its use of
ASYNC_TX_DISABLE_CHANNEL_SWITCH.

> +static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
> +                       struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
> +                       unsigned int src_cnt, size_t len, unsigned long flags)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       struct talitos_xor_desc *new;
> +       struct talitos_desc *desc;
> +       int i, j;
> +
> +       BUG_ON(unlikely(len > TALITOS_MAX_DATA_LEN));
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       if (!list_empty(&xor_chan->free_desc)) {
> +               new = container_of(xor_chan->free_desc.next,
> +                                  struct talitos_xor_desc, node);
> +               list_del(&new->node);
> +       } else {
> +               new = talitos_xor_alloc_descriptor(xor_chan, GFP_KERNEL);
> +       }
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +
> +       if (!new) {
> +               dev_err(xor_chan->common.device->dev,
> +                       "No free memory for XOR DMA descriptor\n");
> +               return NULL;
> +       }
> +       dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
> +
> +       INIT_LIST_HEAD(&new->node);
> +       INIT_LIST_HEAD(&new->tx_list);

You can save some overhead in the fast path by moving this
initialization to talitos_xor_alloc_descriptor.

> +
> +       desc = &new->hwdesc;
> +       /* Set destination: Last pointer pair */
> +       to_talitos_ptr(&desc->ptr[6], dest);
> +       desc->ptr[6].len = cpu_to_be16(len);
> +       desc->ptr[6].j_extent = 0;
> +
> +       /* Set Sources: End loading from second-last pointer pair */
> +       for (i = 5, j = 0; (j < src_cnt) && (i > 0); i--, j++) {
> +               to_talitos_ptr(&desc->ptr[i], src[j]);
> +               desc->ptr[i].len = cpu_to_be16(len);
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       /*
> +        * documentation states first 0 ptr/len combo marks end of sources
> +        * yet device produces scatter boundary error unless all subsequent
> +        * sources are zeroed out
> +        */
> +       for (; i >= 0; i--) {
> +               to_talitos_ptr(&desc->ptr[i], 0);
> +               desc->ptr[i].len = 0;
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       desc->hdr = DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_XOR
> +                   | DESC_HDR_TYPE_RAID_XOR;
> +
> +       new->async_tx.parent = NULL;
> +       new->async_tx.next = NULL;

These fields are managed by the async_tx channel switch code.  No need
to manage it here.

> +       new->async_tx.cookie = 0;

This is set below to -EBUSY, it's redundant to touch it here.

> +       async_tx_ack(&new->async_tx);

This makes it impossible to attach a dependency to this operation.
Not sure this is what you want.

--
Dan
