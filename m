Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYHODOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYHODOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHODOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:14:41 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57274 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYHODOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xr4dsUfUbDmbfJYttsagqPjP5iFXr0puDSSD/83u0SqXeMF8Pl43VbclSuzkHRkZuV
         jnUUhaXtk37mPnZ4FMPJlQU4MSWPUdo0Sgz2tAPGzYHvMO/xsSu1nKljuyhLJNoIegI+
         70kUATh04X/ZvE2BUrVZxwDqUn5qd1TjO5Tlo=
Date: Thu, 14 Aug 2008 23:14:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080815031435.GD9438@anvil.corenet.prv>
References: <20080813152459.4d6bb0cb@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813152459.4d6bb0cb@ephemeral>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Wed, Aug 13, 2008 at 03:24:59PM -0400, Andres Salomon wrote:
> 
> This adds support for OLPC's touchpad.  It has lots of neat features,
> none of which are enabled because the hardware is too buggy.  Instead,
> we use it like a normal touchpad, but with a number of workarounds in
> place to deal with the frequent hardware spasms.  Humidity changes,
> sweat, tinfoil underwear, plugging in AC, drinks, evil felines.. All
> tend to cause the touchpad to freak out.
> 
> Stuff like this keeps me from getting bored.
> 
> We make use of psmouse_set_state and psmouse_queue_work quite a bit.
> 
> (also, extension renamed from olpc.c to hgpk.c)
> 

Whoo-hoo, thanks!

> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/input/mouse/Kconfig        |   10 +
>  drivers/input/mouse/Makefile       |    1 +
>  drivers/input/mouse/hgpk.c         |  492 ++++++++++++++++++++++++++++++++++++
>  drivers/input/mouse/hgpk.h         |   48 ++++
>  drivers/input/mouse/psmouse-base.c |   23 ++-
>  drivers/input/mouse/psmouse.h      |    2 +-
>  6 files changed, 574 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/input/mouse/hgpk.c
>  create mode 100644 drivers/input/mouse/hgpk.h
> 
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index 7bbea09..fff0253 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -96,6 +96,16 @@ config MOUSE_PS2_TOUCHKIT
>  
>  	  If unsure, say N.
>  
> +config MOUSE_PS2_OLPC
> +	bool "OLPC PS/2 mouse protocol extension"
> +	depends on MOUSE_PS2 && OLPC
> +	help
> +	  Say Y here if you have an OLPC XO-1 laptop (with built-in
> +	  PS/2 touchpad/tablet device).  The manufacturer calls the
> +	  touchpad an HGPK.
> +
> +	  If unsure, say N.
> +
>  config MOUSE_SERIAL
>  	tristate "Serial mouse"
>  	select SERIO
> diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
> index 9e6e363..799aa3f 100644
> --- a/drivers/input/mouse/Makefile
> +++ b/drivers/input/mouse/Makefile
> @@ -24,3 +24,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+= logips2pp.o
>  psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
>  psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
>  psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
> +psmouse-$(CONFIG_MOUSE_PS2_OLPC)	+= hgpk.o
> diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
> new file mode 100644
> index 0000000..ac7c2a8
> --- /dev/null
> +++ b/drivers/input/mouse/hgpk.c
> @@ -0,0 +1,492 @@
> +/*
> + * OLPC HGPK (XO-1) touchpad PS/2 mouse driver
> + *
> + * Copyright (c) 2006-2008 One Laptop Per Child
> + * Authors:
> + *   Zephaniah E. Hull
> + *   Andres Salomon <dilinger@debian.org>
> + *
> + * This driver is partly based on the ALPS driver, which is:
> + *
> + * Copyright (c) 2003 Neil Brown <neilb@cse.unsw.edu.au>
> + * Copyright (c) 2003-2005 Peter Osterlund <petero2@telia.com>
> + * Copyright (c) 2004 Dmitry Torokhov <dtor@mail.ru>
> + * Copyright (c) 2005 Vojtech Pavlik <vojtech@suse.cz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * The spec from ALPS is available from
> + * <http://wiki.laptop.org/go/Touch_Pad/Tablet>.  It refers to this
> + * device as HGPK (Hybrid GS, PT, and Keymatrix).
> + *
> + * The earliest versions of the device had simultaneous reporting; that
> + * was removed.  After that, the device used the Advanced Mode GS/PT streaming
> + * stuff.  That turned out to be too buggy to support, so we've finally
> + * switched to Mouse Mode (which utilizes only the center 1/3 of the touchpad).
> + */
> +
> +#define DEBUG
> +#include <linux/input.h>
> +#include <linux/serio.h>
> +#include <linux/libps2.h>
> +#include <linux/delay.h>
> +#include <asm/olpc.h>
> +
> +#include "psmouse.h"
> +#include "hgpk.h"
> +
> +static int tpdebug;
> +module_param(tpdebug, int, 0644);
> +MODULE_PARM_DESC(tpdebug, "enable debugging, dumping packets to KERN_DEBUG.");
> +
> +static int recalib_delta = 100;
> +module_param(recalib_delta, int, 0644);
> +MODULE_PARM_DESC(recalib_delta,
> +	"packets containing a delta this large will cause a recalibration.");
> +
> +/*
> + * When the touchpad gets ultra-sensitive, one can keep their finger 1/2"
> + * above the pad and still have it send packets.  This causes a jump cursor
> + * when one places their finger on the pad.  We can probably detect the
> + * jump as we see a large deltas (>= 100px).  In mouse mode, I've been
> + * unable to even come close to 100px deltas during normal usage, so I think
> + * this threshold is safe.  If a large delta occurs, trigger a recalibration.
> + */
> +static void hgpk_jumpy_hack(struct psmouse *psmouse, int x, int y)
> +{
> +	struct hgpk_data *priv = psmouse->private;
> +
> +	if (abs(x) > recalib_delta || abs(y) > recalib_delta) {
> +		hgpk_err(psmouse, ">%dpx jump detected (%d,%d)\n",
> +				recalib_delta, x, y);
> +		/* My car gets forty rods to the hogshead and that's the
> +		 * way I likes it! */
> +		psmouse_queue_work(psmouse, &priv->recalib_wq,
> +				msecs_to_jiffies(1000));
> +	}
> +}
> +
> +/*
> + * We have no idea why this particular hardware bug occurs.  The touchpad
> + * will randomly start spewing packets without anything touching the
> + * pad.  This wouldn't necessarily be bad, but it's indicative of a
> + * severely miscalibrated pad; attempting to use the touchpad while it's
> + * spewing means the cursor will jump all over the place, and act "drunk".
> + *
> + * The packets that are spewed tend to all have deltas between -2 and 2, and
> + * the cursor will move around without really going very far.  It will
> + * tend to end up in the same location; if we tally up the changes over
> + * 100 packets, we end up w/ a final delta of close to 0.  This happens
> + * pretty regularly when the touchpad is spewing, and is pretty hard to
> + * manually trigger (at least for *my* fingers).  So, it makes a perfect
> + * scheme for detecting spews.
> + */
> +static void hgpk_spewing_hack(struct psmouse *psmouse, int l, int r, int x,
> +		int y)
> +{
> +	struct hgpk_data *priv = psmouse->private;
> +	static int count;
> +	static int x_tally;
> +	static int y_tally;

Hmm, I guess we'll never see 2 such devices in one box, but still moving
it to psmouse->private woudl be a good practice.

> +
> +static int hgpk_reconnect(struct psmouse *psmouse)
> +{
> +	if (olpc_board_at_least(olpc_board(0xb2)))
> +		if (psmouse->ps2dev.serio->dev.power.power_state.event !=
> +				PM_EVENT_ON)
> +			return 0;
> +
> +	psmouse_reset(psmouse);
> +	return 0;

We should not return success if we can't detect the same hardware. I
think if olpc_board_at_least(olpc_board(0xb2) fails we need to return
-1;

> +}
> +
> +static ssize_t hgpk_show_powered(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct serio *serio = to_serio_port(dev);
> +	struct psmouse *psmouse;
> +	struct hgpk_data *priv;
> +	int retval;
> +
> +	retval = serio_pin_driver(serio);
> +	if (retval)
> +		return retval;
> +
> +	psmouse = serio_get_drvdata(serio);
> +	priv = psmouse->private;
> +
> +	retval = sprintf(buf, "%d\n", priv->powered);
> +	serio_unpin_driver(serio);
> +	return retval;
> +}
> +
> +static ssize_t hgpk_set_powered(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct serio *serio = to_serio_port(dev);
> +	struct psmouse *psmouse;
> +	struct hgpk_data *priv;
> +	unsigned long val;
> +	int retval;
> +
> +	if (*buf == '1')
> +		val = 1;
> +	else if (*buf == '0')
> +		val = 0;
> +	else
> +		return -EINVAL;

I'd use strict_strtoul() and checked for val <= 1.

> +
> +	retval = serio_pin_driver(serio);
> +	if (retval)
> +		return retval;
> +
> +	psmouse = serio_get_drvdata(serio);
> +	priv = psmouse->private;
> +
> +	if (val == priv->powered)
> +		goto done;
> +
> +	/* hgpk_toggle_power will deal w/ state so we're not racing w/ irq */
> +	retval = hgpk_toggle_power(psmouse, val);
> +	if (!retval)
> +		priv->powered = val;
> +
> +done:
> +	serio_unpin_driver(serio);
> +	return retval ? retval : count;
> +}
> +
> +static DEVICE_ATTR(powered, S_IWUSR | S_IRUGO, hgpk_show_powered,
> +		hgpk_set_powered);
> 

Any particular reason you didn't use PSMOUSE_DEFINE_ATTR? Then you would
not need to bother with pinning the driver and provode mutual exclusion
with other things. Btw, what do we do if device is powered down an user
tries to change some settings via generic attributes defined in
psmouse-base?

+
> +static void hgpk_disconnect(struct psmouse *psmouse)
> +{
> +	struct hgpk_data *priv = psmouse->private;
> +
> +	device_remove_file(&psmouse->ps2dev.serio->dev, &dev_attr_powered);
> +	psmouse_reset(psmouse);
> +	flush_scheduled_work();

What does this flush protect from? We are using specialized workqueue.
Plus psmouse_disconnect should take care of this, shouldn't it?

> +	kfree(priv);
> +}
> +

> +static void hgpk_recalib_work(struct work_struct *work)
> +{
> +	struct delayed_work *w = container_of(work, struct delayed_work, work);
> +	struct hgpk_data *priv = container_of(w, struct hgpk_data, recalib_wq);
> +	struct psmouse *psmouse = priv->psmouse;
> +
> +	hgpk_dbg(psmouse, "recalibrating touchpad..\n");
> +
> +	if (hgpk_force_recalibrate(psmouse))
> +		hgpk_err(psmouse, "recalibration failed!\n");
> +}
> +

Overall I am concerned about mutual exclusions between operations, such
as settin power state and adjusting genericmouse  properties (repeaqt
rate, resolution, etc). Psmouse-base usues psmouse_mutex for that, mayne
olps should do that too...

-- 
Dmitry
