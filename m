Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYISX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYISX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYISX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:29:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYISX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:29:05 -0400
Date: Fri, 19 Sep 2008 16:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: dbrownell@users.sourceforge.net, greg@kroah.com, galak@kernel.crashing.org,
       timur@freescale.com, leoli@freescale.com, laurentp@cse-semaphore.com,
       linuxppc-dev@ozlabs.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB Host
 Controller
Message-Id: <20080919162324.e354ed2f.akpm@linux-foundation.org>
In-Reply-To: <20080918151746.GC31187@oksana.dev.rtsoft.ru>
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
	<20080918151746.GC31187@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 19:17:46 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch adds support for the FHCI USB controller, as found
> in the Freescale MPC836x and MPC832x processors. It can support
> Full or Low speed modes.
> 
> Quite a lot the hardware is doing by itself (SOF generation, CRC
> generation and checking), though scheduling and retransmission is on
> software's shoulders.
> 
> This controller does not integrate the root hub, so this driver also
> fakes one-port hub. External hub is required to support more than
> one device.
>
> ...
>

Please, no.

> new file mode 100644
> index 0000000..23716fa
> --- /dev/null
> +++ b/drivers/usb/host/fhci-cq.c
> @@ -0,0 +1,105 @@
> +/*
> + * Freescale QUICC Engine USB Host Controller Driver
> + *
> + * Copyright (c) Freescale Semicondutor, Inc. 2006.
> + *               Shlomi Gridish <gridish@freescale.com>
> + *               Jerry Huang <Chang-Ming.Huang@freescale.com>
> + * Copyright (c) Logic Product Development, Inc. 2007
> + *               Peter Barada <peterb@logicpd.com>
> + * Copyright (c) MontaVista Software, Inc. 2008.
> + *               Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +/* circular queue structure */

Yet another private ringbuffer implementation.  Sigh.

> +struct cir_q {
> +       int max;		/* size of queue */
> +       int max_in;	/* max items in queue */
> +       int first;	/* index of first in queue */
> +       int last;	/* index after last in queue */
> +       int read;	/* current reading position */
> +       void *table[1];	/* fake size */
> +};
> +
> +/* circular queue handle */
> +static int cq_howmany(struct cir_q *cq)
> +{
> +	int l = cq->last;
> +	int f = cq->first;
> +
> +	return l >= f ? l - f : l + cq->max - f;
> +}
> +
> +static struct cir_q *cq_new(int size)
> +{
> +	struct cir_q *cq;
> +
> +	cq = kzalloc((sizeof(*cq) + size * sizeof(void *)), GFP_KERNEL);
> +	if (cq) {
> +		cq->max = size;
> +		cq->first = 0;
> +		cq->last = 0;
> +		cq->read = 0;
> +		cq->max_in = 0;

The above four statements are unneeded.

> +	}
> +
> +	return cq;
> +}
>
> ...
>
> +++ b/drivers/usb/host/fhci-hcd.c
> @@ -0,0 +1,798 @@
> +/*
> + * Freescale QUICC Engine USB Host Controller Driver
> + *
> + * Copyright (c) Freescale Semicondutor, Inc. 2006.
> + *               Shlomi Gridish <gridish@freescale.com>
> + *               Jerry Huang <Chang-Ming.Huang@freescale.com>
> + * Copyright (c) Logic Product Development, Inc. 2007
> + *               Peter Barada <peterb@logicpd.com>
> + * Copyright (c) MontaVista Software, Inc. 2008.
> + *               Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#if defined(CONFIG_FHCI_DEBUG) && !defined(DEBUG)
> +#define DEBUG
> +#endif
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/usb.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +#include <asm/qe.h>
> +#include <asm/fsl_gtm.h>
> +#include "../core/hcd.h"
> +#include "fhci.h"
> +#include "fhci-hub.c"
> +#include "fhci-q.c"
> +#include "fhci-dbg.c"
> +#include "fhci-mem.c"
> +#include "fhci-cq.c"
> +#include "fhci-tds.c"
> +#include "fhci-sched.c"

hack, gack, nack.

We know that USB likes to prevertedly #include C files all over the
place, but this doesn't mean that it's a sane, tasteful or desirable
thing to do.

I stopped looking there.  Guys - get a grip :(
