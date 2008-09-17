Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYIQOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYIQOUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYIQOUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:20:00 -0400
Received: from bu3sch.de ([62.75.166.246]:43057 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYIQOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:19:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Wed, 17 Sep 2008 16:19:33 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <48CFC03A.8020708@lwfinger.net> <48D0183E.9010301@lwfinger.net> <20080916210920.GC16470@srcf.ucam.org>
In-Reply-To: <20080916210920.GC16470@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171619.33377.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 23:09:20 Matthew Garrett wrote:
> Oh, hey, I suck. This one might stand a better chance of not falling 
> over.
> 
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index fec5645..991e318 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
>  	struct b43_rfkill *rfk = &(dev->wl->rfkill);
>  
>  	if (!dev->radio_hw_enable) {
> -		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
>  		return;
>  	}
>  
>  	if (!dev->phy.radio_on)
> -		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
>  	else
> -		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
> -
> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
>  }

I still thing that it is really wrong to check and change the software
rfkill state from within the _hardware_ rfkill state handler.
So let's say this handler sets the state to SOFT_BLOCKED. Who is going
to set it back to unblocked, if the user unblocks the radio?

We can turn the radio on/off from the mac80211 config callback. Possibly
we must tell rfkill about it (I'm not sure. I don't understand the API).
I think this is pretty hard to get right, actually. HW-block and SW-block
are two completely independent states in b43. You can HW-block and SW-block
the device at the same time. So one must make sure that at any time the rfkill
is in a sane state if _either_ HW-block or SW-block changes. Currently I think
we only change rfkill state if HW-block state changes. Which is wrong.


In the end, I do not care about this crap anymore.
Feel free to remove my copyright notice from that file and put yours in
there. So feel free to send any patch to the rfkill code to john, but please
handle any regressions resulting from it. If not, I will handle them by reverting
patches until it starts to work again. ;)

-- 
Greetings Michael.
