Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbYEVUwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbYEVUwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYEVUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:51:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36297 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771AbYEVUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:51:57 -0400
X-Sasl-enc: W12e4tNZ0La/VlFvdGDA+R6rKPw0NybjUwa4ESjNA9A7 1211489516
Date: Thu, 22 May 2008 17:51:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080522205153.GA18483@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-15-git-send-email-hmh@hmh.eng.br> <200805201209.06902.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805201209.06902.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Ivo van Doorn wrote:
> On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> > SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
> > be handled, and must always do the same thing as far as the rfkill system
> > is concerned: all transmitters are to go *immediately* offline.
> 
> I don't quite agree here. The SW_RFKILL_ALL key is the one send by thinkpad-acpi,
> what makes that key so special that is has to be handled differently then a key
> that only controls a single radio type?

Well, first there is no KEY involved, it is a SWITCH :-)  But that's not
the reason it is special.

What makes SW_RFKILL_ALL special, is that it is the kernel view of *The*
RFKill Switch.  SW_RFKILL_ALL is the event you get when the user
manipulates the very *thing* that created the "rfkill switch" term.

You get that event when someone moves that slider switch in the side/top
of a laptop which has to kill all RF output in hardware as far as safety
regulations go.  Therefore, it refers to the only rfkill switch that has
guidelines that say that it must always work, and that it must not be
possible to override it in software.

Too bad that doesn't apply to "removable" radio transmitters, like
PCMCIA and ExpressCard WLAN cards, USB RF transmitters, and so on...
probably, the user is expected to yank them off when he moves the switch
to the "no radios working here!" position.  Well, we can do better.  We
can make it apply to these other radio transmitters, too.

So yes, it *is* special when it is doing its "power DOWN the
transmitters" function.  It is not special at all when it is in the
"allow radios to function if they want to" position, which is why I
special-cased only the "OFF" state.

IMHO, that makes it special enough to implement it in a different way
that is not subject to, e.g., brain damage in userspace.

As for thinkpad-acpi being the only in-tree code issuing that event so
far, well... I have seen laptops from many vendors with that switch, and
it is likely that the firmware of at least some of these laptops let you
know the state of the switch (like the thinkpad firmware does), so I'd
expect more users of SW_RFKILL_ALL to show up soon.  I am just paving
the way.

That, and as an user, I'd really like to be able to implement a
KEY_RFKILL_ALL keycode to use when I don't have a proper SW_RFKILL_ALL
in my laptop.  But one thing at a time.  Small steps.

> All keys should have the same rules when it is pressed, so either all keys should
> force the change, or none of them should.

IMO, "kill ALL radios" events are is the only kind of rfkill input event
that have to *always work*, even if something in userspace tried to
configure it not to.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
