Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYIWSbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYIWSbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYIWSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:31:33 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:30392 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752911AbYIWSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:31:32 -0400
Date: Tue, 23 Sep 2008 22:31:29 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net, greg@kroah.com, galak@kernel.crashing.org,
       timur@freescale.com, leoli@freescale.com, laurentp@cse-semaphore.com,
       linuxppc-dev@ozlabs.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB Host
	Controller
Message-ID: <20080923183129.GA19024@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru> <20080918151746.GC31187@oksana.dev.rtsoft.ru> <20080919162324.e354ed2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080919162324.e354ed2f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 04:23:24PM -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2008 19:17:46 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This patch adds support for the FHCI USB controller, as found
> > in the Freescale MPC836x and MPC832x processors. It can support
> > Full or Low speed modes.
> > 
> > Quite a lot the hardware is doing by itself (SOF generation, CRC
> > generation and checking), though scheduling and retransmission is on
> > software's shoulders.
> > 
> > This controller does not integrate the root hub, so this driver also
> > fakes one-port hub. External hub is required to support more than
> > one device.
> >
> > ...
> >
> 
> Please, no.

What exactly 'no'? ;-)

> > new file mode 100644
> > index 0000000..23716fa
> > --- /dev/null
> > +++ b/drivers/usb/host/fhci-cq.c
> > @@ -0,0 +1,105 @@
> > +/*
> > + * Freescale QUICC Engine USB Host Controller Driver
> > + *
> > + * Copyright (c) Freescale Semicondutor, Inc. 2006.
> > + *               Shlomi Gridish <gridish@freescale.com>
> > + *               Jerry Huang <Chang-Ming.Huang@freescale.com>
> > + * Copyright (c) Logic Product Development, Inc. 2007
> > + *               Peter Barada <peterb@logicpd.com>
> > + * Copyright (c) MontaVista Software, Inc. 2008.
> > + *               Anton Vorontsov <avorontsov@ru.mvista.com>
> > + *
> > + * This program is free software; you can redistribute  it and/or modify it
> > + * under  the terms of  the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > + * option) any later version.
> > + */
> > +
> > +/* circular queue structure */
> 
> Yet another private ringbuffer implementation.  Sigh.

Heh. I changed this to kfifo, though I don't quite like it,
since it feels heavy to hold mere pointers...

[...]
> > +++ b/drivers/usb/host/fhci-hcd.c
> > @@ -0,0 +1,798 @@
> > +/*
> > + * Freescale QUICC Engine USB Host Controller Driver
> > + *
> > + * Copyright (c) Freescale Semicondutor, Inc. 2006.
> > + *               Shlomi Gridish <gridish@freescale.com>
> > + *               Jerry Huang <Chang-Ming.Huang@freescale.com>
> > + * Copyright (c) Logic Product Development, Inc. 2007
> > + *               Peter Barada <peterb@logicpd.com>
> > + * Copyright (c) MontaVista Software, Inc. 2008.
> > + *               Anton Vorontsov <avorontsov@ru.mvista.com>
> > + *
> > + * This program is free software; you can redistribute  it and/or modify it
> > + * under  the terms of  the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > + * option) any later version.
> > + */
> > +
> > +#if defined(CONFIG_FHCI_DEBUG) && !defined(DEBUG)
> > +#define DEBUG
> > +#endif
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/list.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/usb.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/of_gpio.h>
> > +#include <asm/qe.h>
> > +#include <asm/fsl_gtm.h>
> > +#include "../core/hcd.h"
> > +#include "fhci.h"
> > +#include "fhci-hub.c"
> > +#include "fhci-q.c"
> > +#include "fhci-dbg.c"
> > +#include "fhci-mem.c"
> > +#include "fhci-cq.c"
> > +#include "fhci-tds.c"
> > +#include "fhci-sched.c"
> 
> hack, gack, nack.
> 
> We know that USB likes to prevertedly #include C files all over the
> place, but this doesn't mean that it's a sane, tasteful or desirable
> thing to do.

Hm. I fixed this, but for lengthy drivers, where we want split the
driver in multiple logical files, this sometimes makes sense (for
example, we don't need externed functions. plus gcc automatically
might inline some of them, etc).


Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
