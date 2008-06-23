Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbYFWRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbYFWRdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYFWRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:32:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:41528 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYFWRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FbYldHL0Zg0rU2P39iSAJgAOtKnYayQGfUq2m3do8Iv/Yc99y1xKJnU/+kKZW+jR5W
         +e/j7JKv6nf9pbmPKxEwIGKMzBgVLTAVLTN3ligYxNfkwdZDUMY+k2zGxKEsz6/goAi0
         Dq/WQkU7ZKzhN9tc9BYsZVPRtE82vOc7WTaak=
Message-ID: <84144f020806231032t19120112jda26567037d722f2@mail.gmail.com>
Date: Mon, 23 Jun 2008 20:32:54 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Altobelli" <david.altobelli@hp.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <20080623160052.GA7616@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623160052.GA7616@ldl.fc.hp.com>
X-Google-Sender-Auth: b15ed5230012f248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Some minor nitpicks follow.

On Mon, Jun 23, 2008 at 7:00 PM, David Altobelli <david.altobelli@hp.com> wrote:
> +
> +/*
> + * FIFO queues, shared with hardware.
> + *
> + * If a queue has empty slots, an entry is added to the queue tail,
> + * and that entry is marked as occupied.
> + * Entries can be dequeued from the head of the list, when the device
> + * has marked the entry as consumed.
> + *
> + * Returns true on successful queue/dequeue, false on failure.
> + */
> +static int fifo_enqueue(struct ilo_hwinfo *hw, char *fifobar, int entry)
> +{
> +       struct fifo *Q = FIFOBARTOHANDLE(fifobar);

The upper case Q is not a proper local variable name (appears
elsewhere as well).


> diff -urpN linux-2.6.26-rc7.orig/drivers/misc/hpilo.h linux-2.6.26-rc7/drivers/misc/hpilo.h
> --- linux-2.6.26-rc7.orig/drivers/misc/hpilo.h  1969-12-31 18:00:00.000000000 -0600
> +++ linux-2.6.26-rc7/drivers/misc/hpilo.h       2008-06-23 08:52:25.000000000 -0500

> +#define IS_DEVICE_RESET(hw) (ioread32(&(hw)->mmio_vaddr[DB_OUT]) & (1 << 26))
> +/* clear the device (reset bits, pending channel entries) */
> +#define CLEAR_DEVICE(hw)    (iowrite32(-1, &(hw)->mmio_vaddr[DB_OUT]))

> +#define DESC_MEM_SZ(_descs) ((_descs) << L2_QENTRY_SZ)

> +#define CTRL_SET(_c, _l, _f, _d, _a, _g)        \
> +       ((_c) =                                  \
> +        (((_l) << CTRL_BITPOS_L2SZ)            |\
> +         ((_f) << CTRL_BITPOS_FIFOINDEXMASK)   |\
> +         ((_d) << CTRL_BITPOS_DESCLIMIT)       |\
> +         ((_a) << CTRL_BITPOS_A)               |\
> +         ((_g) << CTRL_BITPOS_G)))
> +

> +#define DOORBELL_SET(_ccb)     (iowrite8(1, (_ccb)->ccb_u5.db_base))
> +#define DOORBELL_CLR(_ccb)     (iowrite8(2, (_ccb)->ccb_u5.db_base))

> +#define FIFOBARTOHANDLE(_fifo) \
> +       ((struct fifo *)(((char *)(_fifo)) - FIFOHANDLESIZE))
> +
> +/* set a flag indicating this channel needs a reset */
> +#define SET_CHANNEL_RESET(_ccb) \
> +       (FIFOBARTOHANDLE((_ccb)->ccb_u1.send_fifobar)->reset = 1)
> +
> +/* check for this particular channel needing a reset */
> +#define IS_CHANNEL_RESET(_ccb) \
> +       (FIFOBARTOHANDLE((_ccb)->ccb_u1.send_fifobar)->reset)
> +
> +/* overall size of a fifo is determined by the number of entries it contains */
> +#define FIFO_SZ(_num) (((_num)*sizeof(u64)) + FIFOHANDLESIZE)

> +#define GETQWORDS(_e) (((_e) & ENTRY_MASK_QWORDS) >> ENTRY_BITPOS_QWORDS)
> +#define GETDESC(_e) (((_e) & ENTRY_MASK_DESCRIPTOR) >> ENTRY_BITPOS_DESCRIPTOR)
> +
> +#define QWORDS(_B) (((_B) & 7) ? (((_B) >> 3) + 1) : ((_B) >> 3))

Static inline functions are preferred over function-like macros.
