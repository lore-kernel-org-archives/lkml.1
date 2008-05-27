Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYE0OIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYE0OIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbYE0OIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:08:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40278 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296AbYE0OIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:08:39 -0400
Message-Id: <1211897317.22073.1255269155@webmail.messagingengine.com>
X-Sasl-Enc: 46d771SsaS6opKdXCEq9Dk82YAsumlKLkkQUUA8fqn2o 1211897317
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>,
       "Dmitry Torokhov" <dtor@mail.ru>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
   <200805201209.06902.IvDoorn@gmail.com>
   <20080522205153.GA18483@khazad-dum.debian.net>
   <200805231615.33414.IvDoorn@gmail.com>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS
   OFF
In-Reply-To: <200805231615.33414.IvDoorn@gmail.com>
Date: Tue, 27 May 2008 11:08:37 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 16:15:33 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> On Thursday 22 May 2008, Henrique de Moraes Holschuh wrote:
> > What makes SW_RFKILL_ALL special, is that it is the kernel view of *The*
> > RFKill Switch.  SW_RFKILL_ALL is the event you get when the user
> > manipulates the very *thing* that created the "rfkill switch" term.
> 
> So do keys that are pressed that only send the KEY_WLAN, KEY_BLUETOOTH or
> KEY_UWB signals. They all indicate the key has been pressed and the
> radios
> should be turned on/off.

Indicate versus enforce.  There is a BIG difference there, and you can see it
even on how it was implemented by the laptop vendor.  The enforcing switch
has hardware behind it to make sure it works.  For the indication keys, you
are lucky if you get firmware that can make it work without the O.S.

> > You get that event when someone moves that slider switch in the side/top
> > of a laptop which has to kill all RF output in hardware as far as safety
> > regulations go.  Therefore, it refers to the only rfkill switch that has
> > guidelines that say that it must always work, and that it must not be
> > possible to override it in software.
> 
> That is a valid point, and rfkill is supposed to do that, but making
> a difference between RFKILL_ALL and the individual types is wrong
> because that won't result in a clearly defined expected behavior for all
> rfkill keys.

IMO, the big difference between regular KEY_* and RFKILL_ALL is that
RFKILL_ALL has EPO (emergency power-off) semanthics, while the others don't.

KEY_WLAN is usually easily overriden in firmware and software, vendors often
don't even bother to implement it in firmware, it is just software.  RFKILL_ALL
switches cannot be overriden at all in any hardware worth its weight, and they
work even if the entire system has gone out for lunch and is deadlocked.
That's quite a big difference.

The only reason I don't usually call the hardware rfkill switches "radio EPO
switches" is because they are not big, red, and shaped like a mushroom.  But
they are in fact required to act like one in airline regulations, AFAIK.  And
that certainly matches the good implementations of the hardware rfkill switch
I know of (they wire-kill the radios, not even firmware gets in the way).

So yes, I do feel RFKILL_ALL is different, and it warrants EPO semanthics in
the kernel, while all other rfkill events, such as KEY_WLAN, don't.

I don't feel strongly about not giving EPO semanthics to other rfkill events,
but I recommend against giving anything else EPO semanthics in rfkill.

> > Too bad that doesn't apply to "removable" radio transmitters, like
> > PCMCIA and ExpressCard WLAN cards, USB RF transmitters, and so on...
> > probably, the user is expected to yank them off when he moves the switch
> > to the "no radios working here!" position.  Well, we can do better.  We
> > can make it apply to these other radio transmitters, too.
> 
> Through the write-only rfkill class right? ;)

More like through the new read-write/write-only rfkill class, since you have
already ACKed those patches, but yes :-)

> > IMO, "kill ALL radios" events are is the only kind of rfkill input event
> > that have to *always work*, even if something in userspace tried to
> > configure it not to.
> 
> Well the definition of "ALL radios" is the part that is the question,
> when the KEY_WLAN is
> pressed it would be "ALL WLAN radios" and should still have the same
> rules for allowing
> or disallowing userspace to overwrite the status.

Not really.  If you are concerned with a type, it is not an emergency situation,
nor is it a "you are entering a no-RF-emission area" situation.  There *IS* a
difference when a human decides to shut down EVERYTHING regardless of type, or
when he just wants the WLAN to stop wasting power but still wants Bluetooth up
so that he can listen to music on his wireless headphones.

And that notion carried over as the UI for circuit switches.  There IS a UI
notion behind "master switches", and it is very different from the notion behind
"sector switches".  And KEY_WLAN would just be a sector switch, with each 
wlan device being the room switch... while RFKILL_ALL is certainly The Master
Switch.

You will find this basic UI notion in *everything* dealing with an hierarchy of
switches: you have it on the power-grid and the mains input on your house, you
have it on your hydraulic pipes, and you have it in just about everything that
has not been bitten by the "standby" disease.  When you place a master switch in
"OFF" state, it bloody well *STAYS* *OFF*, and everything else after it is also
FORCED OFF, no matter what.

But of course, you have to make sure the master switch WILL bloody well stay off
when off by design.  You engineer it so that all possible failure modes will
cause it to go to the off state.

I would really appreciate that the rfkill class would abide to this UI notion for
the master rfkill events (*_RFKILL_ALL).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

