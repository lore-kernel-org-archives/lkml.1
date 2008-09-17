Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYIQPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYIQPSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYIQPS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:18:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47747 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYIQPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:18:28 -0400
X-Sasl-enc: Yixf07zMRcv3Lna/fZHs9C24VT2Be0BgZGb0qG9c54/S 1221664707
Date: Wed, 17 Sep 2008 12:18:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917151822.GB5186@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <48D0183E.9010301@lwfinger.net> <20080916210920.GC16470@srcf.ucam.org> <200809171619.33377.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809171619.33377.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Michael Buesch wrote:
> On Tuesday 16 September 2008 23:09:20 Matthew Garrett wrote:
> > Oh, hey, I suck. This one might stand a better chance of not falling 
> > over.
> > 
> > diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> > index fec5645..991e318 100644
> > --- a/drivers/net/wireless/b43/rfkill.c
> > +++ b/drivers/net/wireless/b43/rfkill.c
> > @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
> >  	struct b43_rfkill *rfk = &(dev->wl->rfkill);
> >  
> >  	if (!dev->radio_hw_enable) {
> > -		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
> > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
> >  		return;
> >  	}
> >  
> >  	if (!dev->phy.radio_on)
> > -		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
> >  	else
> > -		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
> > -
> > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
> >  }
> 
> I still thing that it is really wrong to check and change the software
> rfkill state from within the _hardware_ rfkill state handler.
> So let's say this handler sets the state to SOFT_BLOCKED. Who is going
> to set it back to unblocked, if the user unblocks the radio?

I would suggest reading the updated docs, but I know you'd rather just stay
away from rfkill.

For reference:

Basically, your wireless device driver has to monitor any hardware rfkill
lines and call rfkill_force_state() accordingly (you don't even need to
track if the state changed, rfkill core will do that).

The call to rfkill_force_state() should set state to HARD_BLOCKED (any of
the hardware rfkill lines are active), SOFT_BLOCKED (no hardware rfkill
lines are active, but one of the software rfkill lines are active), or
UNBLOCKED (no rfkill lines of any type are active).

Whether this is to be done through interrupts or pooling is something that
depends on your driver and the hardware.

User and userspace interaction is taken care of by the rfkill core.  You do
nothing of the sort in the wireless device driver.

There are *very few* exceptions for the above as far as wireless device
drivers go.  They are explained in the docs, and I know of no wireless
device driver that would require any them.

> We can turn the radio on/off from the mac80211 config callback. Possibly
> we must tell rfkill about it (I'm not sure. I don't understand the API).
> I think this is pretty hard to get right, actually. HW-block and SW-block
> are two completely independent states in b43. You can HW-block and SW-block
> the device at the same time. So one must make sure that at any time the rfkill
> is in a sane state if _either_ HW-block or SW-block changes. Currently I think
> we only change rfkill state if HW-block state changes. Which is wrong.

Again, for reference:

You need to synthesize a single state (unblock/soft-block/hard-block) for a
transmitter from every rfkill line that affects that transmitter.  This
happens because the interface is a SINGLE ONE rfkill class per independent
wireless interface ("transmitter").

> In the end, I do not care about this crap anymore.

That's quite understandable...  b43 is one of the drivers (if not THE
driver) that suffered most from rfkill bugs, as it was an early adopter and
the old rfkill API was just plain broken for the kind of stuff b43 needed it
for.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
