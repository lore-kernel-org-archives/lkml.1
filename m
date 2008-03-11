Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYCKVzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYCKVzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYCKVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:55:30 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:64309 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYCKVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ius7GFVjHviICidLfhNjeHDkkGAfg16VxUdbp1fzYAnP609cHq+cDW6mHzrrJv7RNXWTaP/JiF8NxsIlyFJdbNgERj3ACnGxSF3IMD/disE47hSNSnFQVO3HqOEKc3TK5OmnD3SXb0GY5voi6QILpDLuYVUV1bRKlqAguyxrQGk=
Message-ID: <e9c3a7c20803111455g354741f0sff7d4fc0172dc65e@mail.gmail.com>
Date: Tue, 11 Mar 2008 14:55:28 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>
Subject: Re: [PATCH 2/2] Add device_prep_dma_interrupt support to fsldma.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1205205917-21861-2-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com>
	 <1205205917-21861-2-git-send-email-wei.zhang@freescale.com>
X-Google-Sender-Auth: 5e9c657706344b31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 8:25 PM, Zhang Wei <wei.zhang@freescale.com> wrote:
> This is a bug that I assigned DMA_INTERRUPT capability to fsldma
>  but missing device_prep_dma_interrupt function. For a bug in
>  dmaengine.c the driver passed BUG_ON() checking. The patch fixes it.
>
>  Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
>  ---
>   drivers/dma/fsldma.c |   27 +++++++++++++++++++++++++++
>   1 files changed, 27 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>  index 5dfedf3..5428f81 100644
>  --- a/drivers/dma/fsldma.c
>  +++ b/drivers/dma/fsldma.c
>  @@ -406,6 +406,32 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
>         dma_pool_destroy(fsl_chan->desc_pool);
>   }
>
>  +static struct dma_async_tx_descriptor *fsl_dma_prep_interrupt(
>  +                                               struct dma_chan *chan)
>  +{
>  +       struct fsl_dma_chan *fsl_chan;
>  +       struct fsl_desc_sw *new;
>  +
>  +       if (!chan)
>  +               return NULL;
>  +
>  +       fsl_chan = to_fsl_chan(chan);
>  +
>  +       new = fsl_dma_alloc_descriptor(fsl_chan);
>  +       if (!new) {
>  +               dev_err(fsl_chan->dev, "No free memory for link descriptor\n");
>  +               return NULL;
>  +       }
>  +
>  +       new->async_tx.cookie = -EBUSY;
>  +       new->async_tx.ack = 0;
>  +
>  +       /* Set End-of-link to the last link descriptor of new list*/
>  +       set_ld_eol(fsl_chan, new);

Question, is 'set_ld_eol' safe to call on descriptors that may not be
the last in the list?  For example what about the following sequence:

/* prepare two descriptors */
tx1 = fsl_dma_prep_interrupt(chan);
tx2 = fsl_dma_prep_memcpy(chan);

/* submit out of order */
tx2->tx_submit(tx2);
tx1->tx_submit(tx1);

This is only a concern if you plan to support channel switching at
some point.  For example, switching from a memcpy channel to an xor
channel.

Thanks,
Dan
