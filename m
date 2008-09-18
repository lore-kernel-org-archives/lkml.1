Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYIRRkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYIRRkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYIRRkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:40:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:3142 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbYIRRka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=gCkh6wsqle53SBTp/yDkcB3DSokyHVvzViAQi2/oJV1Ae54cT4L8IUrWMjopP8UqA4
         0QAiz2nWYj97oEBmxceX5KaGBk9VnkIIW82E9nTCRnQ7LhPcnRXl7gVutAci8vKaEoTY
         1ZDBr0egTqpvVL7yYHN6ylHG2o4QQuP+Oqn7I=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 19:40:24 +0200
User-Agent: KMail/1.9.9
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <200809181724.03723.IvDoorn@gmail.com> <20080918164339.GM1583@khazad-dum.debian.net>
In-Reply-To: <20080918164339.GM1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181940.24727.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > rfkill_force_state() is used to update the rfkill core's idea of what is
> > > really happening RIGHT NOW to the transmitter hardware in a PUSH model.
> > > 
> > > rfkill->get_state() does the same, in a PULL model.
> > > 
> > > Neither of them change the real hardware radio state through a call to
> > > rfkill->toggle_radio() or anything of the sort, so they must deal with the
> > > real, current state of the hardware.
> > > 
> > > Change some documentation to make that more clear (I hope).
> > > 
> > > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > See my other mail I just send out.
> 
> I did, and just replied to it.
> 
> But only now do I think I realised what you meant:  That even if the driver
> tries to keep set txpower off separate from rfkill, if it uses the hardware
> soft-rfkill bit to implement both, it cannot use that to feed information to
> rfkill_force_state() directly.
> 
> Argh.

Indeed, you need to differentiate between RFKILL and RADIO states.

> > But I don't quite agree on this change of rfkill event interpretation.
> 
> Well, there is no intended change in interpretation, but I don't know how to
> word it in a way that means "the real current hardware state as far as
> rfkill is concerned".

Well my interpretation is that rfkill events and thus rfkill_force_state() calls
should be done for RFKILL state changes only. And RADIO state should be
ignored since they don't matter for rfkill.

> Because suppose it is a driver doing txpower off AND software rfkill using
> the *same* hardware bit (a sigle software rfkill bit).
>
> Now it must do something like this in pseudo-code:
> 
> 	1. if (the bit is disabled (i.e. SW rfkill is NOT ACTIVE)) {
> 		rfkill-SW-status = disabled;
> 	   }  else if (the bit is enabled (i.e. SW rfkill is ACTIVE)) {
> 		if (tx power off is NOT ACTIVE)
> 			rfkill-SW-status = enabled;
> 		else
> 			rfkill-SW-status = whatever the user asked
> 	   }
> 
> THEN, it should use rfkill-sw-status, along with the hw rfkill line status,
> to synthesize the state it must pass to rfkill_force_status().
> 
> ICK.  Of course, if the driver has another way to implement txpower off that
> does not clash with sw rfkill, the above is unneeded.
> 
> How would you put that into words for the rfkill documentation?

The driver is required to keep track of the userspace configuration settings,
when rfkill sends BLOCK to driver it should disable the radio, when rfkill
send UNBLOCK to the driver it should restore to the userspace configuration
settings (which can either be an enabled or disabled radio).

Ivo
