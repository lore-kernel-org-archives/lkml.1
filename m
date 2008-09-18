Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYIRQn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYIRQn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYIRQnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:43:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54612 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbYIRQnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:43:45 -0400
X-Sasl-enc: cqsW/FAB5Y+9RFlt5cOMFmjO7D7bHlpAdSuZroV0oxQE 1221756223
Date: Thu, 18 Sep 2008 13:43:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and
	rfkill->get_state()
Message-ID: <20080918164339.GM1583@khazad-dum.debian.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <1221751166-9927-1-git-send-email-hmh@hmh.eng.br> <200809181724.03723.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809181724.03723.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > rfkill_force_state() is used to update the rfkill core's idea of what is
> > really happening RIGHT NOW to the transmitter hardware in a PUSH model.
> > 
> > rfkill->get_state() does the same, in a PULL model.
> > 
> > Neither of them change the real hardware radio state through a call to
> > rfkill->toggle_radio() or anything of the sort, so they must deal with the
> > real, current state of the hardware.
> > 
> > Change some documentation to make that more clear (I hope).
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> 
> See my other mail I just send out.

I did, and just replied to it.

But only now do I think I realised what you meant:  That even if the driver
tries to keep set txpower off separate from rfkill, if it uses the hardware
soft-rfkill bit to implement both, it cannot use that to feed information to
rfkill_force_state() directly.

Argh.

> But I don't quite agree on this change of rfkill event interpretation.

Well, there is no intended change in interpretation, but I don't know how to
word it in a way that means "the real current hardware state as far as
rfkill is concerned".

Because suppose it is a driver doing txpower off AND software rfkill using
the *same* hardware bit (a sigle software rfkill bit).

Now it must do something like this in pseudo-code:

	1. if (the bit is disabled (i.e. SW rfkill is NOT ACTIVE)) {
		rfkill-SW-status = disabled;
	   }  else if (the bit is enabled (i.e. SW rfkill is ACTIVE)) {
		if (tx power off is NOT ACTIVE)
			rfkill-SW-status = enabled;
		else
			rfkill-SW-status = whatever the user asked
	   }

THEN, it should use rfkill-sw-status, along with the hw rfkill line status,
to synthesize the state it must pass to rfkill_force_status().

ICK.  Of course, if the driver has another way to implement txpower off that
does not clash with sw rfkill, the above is unneeded.

How would you put that into words for the rfkill documentation?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
