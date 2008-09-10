Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYIJV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYIJV4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYIJVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:55:51 -0400
Received: from mail.queued.net ([207.210.101.209]:4202 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYIJVzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:55:50 -0400
Date: Wed, 10 Sep 2008 17:55:13 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080910175513.17d900bc@dev.queued.net>
In-Reply-To: <20080815031435.GD9438@anvil.corenet.prv>
References: <20080813152459.4d6bb0cb@ephemeral>
	<20080815031435.GD9438@anvil.corenet.prv>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 23:14:35 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Andres,
> 
> On Wed, Aug 13, 2008 at 03:24:59PM -0400, Andres Salomon wrote:
[...]
> 
> > +
> > +	retval = serio_pin_driver(serio);
> > +	if (retval)
> > +		return retval;
> > +
> > +	psmouse = serio_get_drvdata(serio);
> > +	priv = psmouse->private;
> > +
> > +	if (val == priv->powered)
> > +		goto done;
> > +
> > +	/* hgpk_toggle_power will deal w/ state so we're not
> > racing w/ irq */
> > +	retval = hgpk_toggle_power(psmouse, val);
> > +	if (!retval)
> > +		priv->powered = val;
> > +
> > +done:
> > +	serio_unpin_driver(serio);
> > +	return retval ? retval : count;
> > +}
> > +
> > +static DEVICE_ATTR(powered, S_IWUSR | S_IRUGO, hgpk_show_powered,
> > +		hgpk_set_powered);
> > 
> 
> Any particular reason you didn't use PSMOUSE_DEFINE_ATTR? Then you
> would not need to bother with pinning the driver and provode mutual
> exclusion with other things. Btw, what do we do if device is powered
> down an user tries to change some settings via generic attributes
> defined in psmouse-base?
> 

Ok, the problem is this - hgpk_set_powered disables power by sending a
special command, and power is re-enabled with the following code:

                /*
                 * Sending a byte will drive MS-DAT low; this will wake
up
                 * the controller.  Once we get an ACK back from it, it
                 * means we can continue with the touchpad re-init. ALPS
                 * tells us that 1s should be long enough, so set that
as
                 * the upper bound.
                 */
                for (timeo = 20; timeo > 0; timeo--) {
                        if (!ps2_sendbyte(&psmouse->ps2dev,
                                        PSMOUSE_CMD_DISABLE, 20))
                                break;
                        msleep(50);
                }

This means that after telling the ALPS device to turn off power, we
shouldn't be sending any ps2 commands until we want to turn power
back on.  However, psmouse_attr_set_helper code has the following:

        psmouse_deactivate(psmouse);
        retval = attr->set(psmouse, attr->data, buf, count);
        if (retval != -ENODEV)
                psmouse_activate(psmouse);

If we're disabling power, psmouse_activate will proceed to turn
power back on.

There's also the following check in psmouse_attr_set_helper:

        if (psmouse->state == PSMOUSE_IGNORE) {
                retval = -ENODEV;
                goto out_unlock;
        }

That's not at all what we want; when we disable power, we also
do a psmouse_set_state(psmouse, PSMOUSE_IGNORE).  That check
means we'd never be able to turn power back on.


What do you think about either changing PSMOUSE_DEFINE_ATTR
to take an additional 'raw' argument (meaning psmouse->state is
not checked, and psmouse_deactivate/psmouse_activate are not
called), or alternatively adding new helper functions that just
handle the locking (__PSMOUSE_DEFINE_ATTR() and
__psmouse_attr_{set,show}_helper())?  I'd prefer the raw
argument.
