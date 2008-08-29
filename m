Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYH2GuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYH2GuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYH2GuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:50:13 -0400
Received: from mail.queued.net ([207.210.101.209]:4595 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYH2GuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:50:11 -0400
Date: Fri, 29 Aug 2008 02:49:59 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080829024959.68bcdc98@fred>
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

Hi Dmitry,

Sorry, just now getting the chance to look at this...

On Thu, 14 Aug 2008 23:14:35 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Andres,
> 
[...]
> > +
> > +/*
> > + * We have no idea why this particular hardware bug occurs.  The
> > touchpad
> > + * will randomly start spewing packets without anything touching
> > the
> > + * pad.  This wouldn't necessarily be bad, but it's indicative of a
> > + * severely miscalibrated pad; attempting to use the touchpad
> > while it's
> > + * spewing means the cursor will jump all over the place, and act
> > "drunk".
> > + *
> > + * The packets that are spewed tend to all have deltas between -2
> > and 2, and
> > + * the cursor will move around without really going very far.  It
> > will
> > + * tend to end up in the same location; if we tally up the changes
> > over
> > + * 100 packets, we end up w/ a final delta of close to 0.  This
> > happens
> > + * pretty regularly when the touchpad is spewing, and is pretty
> > hard to
> > + * manually trigger (at least for *my* fingers).  So, it makes a
> > perfect
> > + * scheme for detecting spews.
> > + */
> > +static void hgpk_spewing_hack(struct psmouse *psmouse, int l, int
> > r, int x,
> > +		int y)
> > +{
> > +	struct hgpk_data *priv = psmouse->private;
> > +	static int count;
> > +	static int x_tally;
> > +	static int y_tally;
> 
> Hmm, I guess we'll never see 2 such devices in one box, but still
> moving it to psmouse->private woudl be a good practice.


Can you please clarify this comment?


> 
> > +
> > +static int hgpk_reconnect(struct psmouse *psmouse)
> > +{
> > +	if (olpc_board_at_least(olpc_board(0xb2)))
> > +		if
> > (psmouse->ps2dev.serio->dev.power.power_state.event !=
> > +				PM_EVENT_ON)
> > +			return 0;
> > +
> > +	psmouse_reset(psmouse);
> > +	return 0;
> 
> We should not return success if we can't detect the same hardware. I
> think if olpc_board_at_least(olpc_board(0xb2) fails we need to return
> -1;
> 

This check isn't any kind of failure; it's due to a hardware quirk with
earlier prototypes.  Basically, during suspend/resume, the touchpad
rails stay powered.  We don't want to do any sort of reset of the
psmouse device, otherwise we lose data (especially if someone is waking
up the device via touchpad usage or button press, we certainly don't
want to reset and drop the packets).

However, b1 hardware required a reset for reasons that I can't recall
anymore.  In both cases, the reconnect worked just fine; the difference
is that a psmouse_reset was issued for b2 hardware and higher.

I suppose the code should have a comment saying just that, eh? :)

> > +}
> > +
> > +static ssize_t hgpk_show_powered(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct serio *serio = to_serio_port(dev);
> > +	struct psmouse *psmouse;
> > +	struct hgpk_data *priv;
> > +	int retval;
> > +
> > +	retval = serio_pin_driver(serio);
> > +	if (retval)
> > +		return retval;
> > +
> > +	psmouse = serio_get_drvdata(serio);
> > +	priv = psmouse->private;
> > +
> > +	retval = sprintf(buf, "%d\n", priv->powered);
> > +	serio_unpin_driver(serio);
> > +	return retval;
> > +}
> > +
> > +static ssize_t hgpk_set_powered(struct device *dev,
> > +		struct device_attribute *attr, const char *buf,
> > size_t count) +{
> > +	struct serio *serio = to_serio_port(dev);
> > +	struct psmouse *psmouse;
> > +	struct hgpk_data *priv;
> > +	unsigned long val;
> > +	int retval;
> > +
> > +	if (*buf == '1')
> > +		val = 1;
> > +	else if (*buf == '0')
> > +		val = 0;
> > +	else
> > +		return -EINVAL;
> 
> I'd use strict_strtoul() and checked for val <= 1.
> 

*nod*

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

PSMOUSE_DEFINE_ATTR is fine for show_powered, but doesn't work for
set_powered because it
a) doesn't change the value if psmouse->state == PSMOUSE_IGNORE
b) does some deactivation dance/activate dance

I don't remember the specifics, but our powered stuff wasn't working as
a PSMOUSE_DEFINE_ATTR callback.  At some point soon I'll take another
look at it and see what the specific problem was.

> would not need to bother with pinning the driver and provode mutual
> exclusion with other things. Btw, what do we do if device is powered

Agreed, the mutex stuff is not ideal.

> down an user tries to change some settings via generic attributes
> defined in psmouse-base?
> 

Hm, good point; set_powered should be setting PSMOUSE_IGNORE when
powering the device off!

> +
> > +static void hgpk_disconnect(struct psmouse *psmouse)
> > +{
> > +	struct hgpk_data *priv = psmouse->private;
> > +
> > +	device_remove_file(&psmouse->ps2dev.serio->dev,
> > &dev_attr_powered);
> > +	psmouse_reset(psmouse);
> > +	flush_scheduled_work();
> 
> What does this flush protect from? We are using specialized workqueue.
> Plus psmouse_disconnect should take care of this, shouldn't it?
>

According to the commit I made some time ago, it's to protect against
a race with kpsmouse_wq that would cause an oops.  I don't actually
know if I was being paranoid there, or if there actually _was_ an oops
that was being triggered.

You're right though, psmouse_disconnect should take care of it for us..
 
> > +	kfree(priv);
> > +}
> > +
> 
> > +static void hgpk_recalib_work(struct work_struct *work)
> > +{
> > +	struct delayed_work *w = container_of(work, struct
> > delayed_work, work);
> > +	struct hgpk_data *priv = container_of(w, struct hgpk_data,
> > recalib_wq);
> > +	struct psmouse *psmouse = priv->psmouse;
> > +
> > +	hgpk_dbg(psmouse, "recalibrating touchpad..\n");
> > +
> > +	if (hgpk_force_recalibrate(psmouse))
> > +		hgpk_err(psmouse, "recalibration failed!\n");
> > +}
> > +
> 
> Overall I am concerned about mutual exclusions between operations,
> such as settin power state and adjusting genericmouse  properties
> (repeaqt rate, resolution, etc). Psmouse-base usues psmouse_mutex for
> that, mayne olps should do that too...
> 

*nod*, I'll see what I can do about the powered thing.  Thanks!
