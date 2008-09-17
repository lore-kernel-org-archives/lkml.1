Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYIQQA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYIQQA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYIQQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:00:21 -0400
Received: from bu3sch.de ([62.75.166.246]:55678 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYIQQAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:00:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Wed, 17 Sep 2008 17:59:32 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <48CFC03A.8020708@lwfinger.net> <200809171619.33377.mb@bu3sch.de> <20080917151822.GB5186@khazad-dum.debian.net>
In-Reply-To: <20080917151822.GB5186@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171759.32645.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 17:18:22 Henrique de Moraes Holschuh wrote:
> On Wed, 17 Sep 2008, Michael Buesch wrote:
> > On Tuesday 16 September 2008 23:09:20 Matthew Garrett wrote:
> > > Oh, hey, I suck. This one might stand a better chance of not falling 
> > > over.
> > > 
> > > diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> > > index fec5645..991e318 100644
> > > --- a/drivers/net/wireless/b43/rfkill.c
> > > +++ b/drivers/net/wireless/b43/rfkill.c
> > > @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
> > >  	struct b43_rfkill *rfk = &(dev->wl->rfkill);
> > >  
> > >  	if (!dev->radio_hw_enable) {
> > > -		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
> > > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
> > >  		return;
> > >  	}
> > >  
> > >  	if (!dev->phy.radio_on)
> > > -		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> > > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
> > >  	else
> > > -		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
> > > -
> > > +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
> > >  }
> > 
> > I still thing that it is really wrong to check and change the software
> > rfkill state from within the _hardware_ rfkill state handler.
> > So let's say this handler sets the state to SOFT_BLOCKED. Who is going
> > to set it back to unblocked, if the user unblocks the radio?
> 
> I would suggest reading the updated docs, but I know you'd rather just stay
> away from rfkill.
> 
> For reference:
> 
> Basically, your wireless device driver has to monitor any hardware rfkill
> lines and call rfkill_force_state() accordingly (you don't even need to
> track if the state changed, rfkill core will do that).
> 
> The call to rfkill_force_state() should set state to HARD_BLOCKED (any of
> the hardware rfkill lines are active), SOFT_BLOCKED (no hardware rfkill
> lines are active, but one of the software rfkill lines are active), or
> UNBLOCKED (no rfkill lines of any type are active).
> 
> Whether this is to be done through interrupts or pooling is something that
> depends on your driver and the hardware.
> 
> User and userspace interaction is taken care of by the rfkill core.  You do
> nothing of the sort in the wireless device driver.
> 
> There are *very few* exceptions for the above as far as wireless device
> drivers go.  They are explained in the docs, and I know of no wireless
> device driver that would require any them.
> 
> > We can turn the radio on/off from the mac80211 config callback. Possibly
> > we must tell rfkill about it (I'm not sure. I don't understand the API).
> > I think this is pretty hard to get right, actually. HW-block and SW-block
> > are two completely independent states in b43. You can HW-block and SW-block
> > the device at the same time. So one must make sure that at any time the rfkill
> > is in a sane state if _either_ HW-block or SW-block changes. Currently I think
> > we only change rfkill state if HW-block state changes. Which is wrong.
> 
> Again, for reference:
> 
> You need to synthesize a single state (unblock/soft-block/hard-block) for a
> transmitter from every rfkill line that affects that transmitter.  This
> happens because the interface is a SINGLE ONE rfkill class per independent
> wireless interface ("transmitter").

Right. But that's not what I was talking about. The hw and sw rfkill is something
_completely_ different in b43 and it's handled by _completely_ different codepaths.
I just said that currently the sw-rfkill path does _not_ announce the state
correctly to the rfkill subsystem. Additionally we must _not_ check the sw rfkill
state from within the hw rfkill handlers, as it will get out of sync this way.
(that's what we're currently doing. If you revert the commit from the subject
this will go away, afaics).
Telling rfkill about the state isn't the hard part, but the
"You need to synthesize a single state" part, which currently is not done correctly.
We currently have _two_ states. (Don't get me wrong, the fix is _not_ to remove
either of these. The fix is to introduce a common rfkill notifier that constructs
a common rfkill state from these two states. This notifier is called from hw-rfkill
and sw-rfkill.)

-- 
Greetings Michael.
