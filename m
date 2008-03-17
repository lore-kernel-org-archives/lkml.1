Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYCQSqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYCQSqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYCQSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:46:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:39877 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYCQSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Lrs1TAmnRzKRZkvTPSaIJzSlAaf/Zjf+UO/Sm5peYvTkPd0Czm15OGhPQYZyKdFnjxHpOU+F3941dCmUnO/PDU7Xeq157oTH1bds1oufcJAeoFzoTC5DQ4OVEWciZ5x+WAaE+RdmiQtBxVIFcp2buv9NFYN3Vk0RqEPVREsm/yc=
Message-ID: <e9c3a7c20803171146m5a7f0e11m31e074634de22b42@mail.gmail.com>
Date: Mon, 17 Mar 2008 11:46:39 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH v2] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       pasemi-linux@ozlabs.org, linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
In-Reply-To: <20080316213002.GA2589@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306233900.GA3969@lixom.net> <20080316213002.GA2589@lixom.net>
X-Google-Sender-Auth: 004cd70098617877
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 2:30 PM, Olof Johansson <olof@lixom.net> wrote:
> pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
>
>  DMA copy offload driver for PA Semi PWRficient. It uses the
>
> platform-specific functions to allocate channels, etc.
>
>  Signed-off-by: Olof Johansson <olof@lixom.net>
>
>  ---
>
>  Changes since last post:
>
>  * Add DMA_INTERRUPT support and handling of the interrupt flag
>  * Fix interrupt handler for above and add tasklet
>  * Switch to spin_lock_bh() where possible
>  * Remove empty dependency_added() function since it's no longer
>   used in the framework.
>  * Fix bug in "ring full" estimation.
>

Hi Olof,

Looks good, makes me want to go back and cleanup iop-adma a bit.  A
few fyi's below, but no other review comments.

>  Note that this still needs to go on top of the powerpc.git tree due to the
>  pasemi_dma.h updates that this driver depends on. I suggest merging this
>  through pasemi.git->powerpc.git->linus with an Acked-by from the DMA guys.

Ok, it still may not compile in mainline until after 2.6.26-rc1 due to
additional dmaengine cleanups like the ack-to-flags change I posted
earlier.  Any better way to handle this?  Go through -mm?

>
>  -Olof
>

Acked-by: Dan Williams <dan.j.williams@intel.com>

> --- /dev/null
>  +++ b/drivers/dma/pasemi_dma.c
[..]
>  +static void pasemi_dma_clean(struct pasemi_dma_chan *chan)
>  +{
>  +       int old, new, i;
>
> +       struct pasemi_dma_desc *desc;
>  +       dma_async_tx_callback callback;
>  +
>  +restart:
>  +       spin_lock_bh(&chan->desc_lock);
>
> +
>  +       old = chan->next_to_clean;
>  +
>  +       new = *chan->chan.status & PAS_STATUS_PCNT_M;
>  +       new <<= 2;
>  +       new &= (RING_SZ-1);
>  +
>  +       if (old > new)
>  +               new += RING_SZ;
>  +
>  +       for (i = old; i < new; i += 4) {
>  +               if (unlikely(chan->chan.ring_virt[i & (RING_SZ-1)] & XCT_COPY_O))
>  +                       break;
>  +               desc = chan->ring_info[i & (RING_SZ-1)];
>  +
>  +               callback = desc->async_tx.callback;
>  +               if (callback) {
>  +                       /* Can't re-lock and just loop, since another cpu
>  +                        * might have came in here while we released the lock.
>  +                        * Instead, start all over again to re-read status words.
>  +                        */
>
> +                       chan->next_to_clean = i & (RING_SZ-1);
>  +                       spin_unlock_bh(&chan->desc_lock);
>  +                       callback(desc->async_tx.callback_param);
>  +                       goto restart;
>  +               }

Clients do not submit new operations in their callback routines so it
is "ok" to hold this lock over the callback.

Also, if your platform will need to support channel switching at some
point you can go ahead and add a call to async_tx_run_dependencies()
here.
