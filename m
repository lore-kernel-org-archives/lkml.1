Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYHTCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYHTCat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYHTCaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:30:39 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38086 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYHTCai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:30:38 -0400
X-Sasl-enc: UpI3t5lqQ8YhiAG8ddbP/a2H16ixSjUShPZpG5VwMhnG 1219199436
Date: Tue, 19 Aug 2008 23:30:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Awkward rfkill corner cases
Message-ID: <20080820023027.GH29336@khazad-dum.debian.net>
References: <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org> <20080819025815.b5ec1a4c.akpm@linux-foundation.org> <20080819111320.GA19223@srcf.ucam.org> <20080819230950.GC29336@khazad-dum.debian.net> <20080819232411.GA5421@srcf.ucam.org> <20080820011828.GD29336@khazad-dum.debian.net> <20080820012846.GA7467@srcf.ucam.org> <20080820013214.GF29336@khazad-dum.debian.net> <20080820014211.GA7592@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820014211.GA7592@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Matthew Garrett wrote:
> One completely unrelated question. In the following situation (relevant 
> to Dells, not the Eee)
> 
> * The system has a key (not a switch) that in firmware disables the 
> hardware (HARD_BLOCKED)

Ick.  I sure hope you can query the firmware, so that you can look at it as
if it were a switch instead of a key (and look at the key press event as a
"switch changed state" event -- never mind it is difficult to hook to that
event right now)?

I mean, trying to deal with firmware/hardware that changes states on its own
in any other basis than "it is a switch", is error prone.  You miss one
event, you go out of sync.  That's bad.

> * That key generates an event through the keyboard controller, but not 
> through any other obviously detectable means

Ok.

> * The radio control is also controllable through software (SOFT_BLOCKED)
> 
> Should pressing the key generate a KEY_WLAN event?

Frankly?  I think so.  It would be nice if you could hook the key as a "hint
that the rfkill controller may have changed state" on the driver, and ALSO
as a normal input device (so that it can command more than just that one
WLAN radio).

But I think it would be EVEN BETTER if you could somehow suppress that KEY_*
event, and synthesize an EV_SW SW_WLAN in its place (you will have to ask
Dmitry to add it, since it is a first use) instead.  If you cannot, KEY_WLAN
will have to make do.

> I note that rfkill-input will, if the device is in HARD_BLOCKED state, 
> attempt to set it to UNBLOCKED. This sounds like generating the keycode 

I have some patches in flight that will make rfkill-input smarter about it.
But that's just an enhancement.  The current way it operates is annoying,
but last time I checked, it doesn't blow up.

Just return -EPERM on your device driver's toggle_radio() callback if you
are at HARD_BLOCKED and someone asks you to go to UNBLOCKED.  That is what
the API calls for (if it is not clear enough, we can improve the docs).

> is the wrong thing to do, since it'll cause rfkill-input to try to undo 
> the change that's just been made. However, if the key isn't mapped 
> there's no obvious way for any of the stack to determine that a change 
> has been made and propagate that to userspace. What should we be doing 
> here?

Never worry about propagating rfkill state to userspace in a driver.  rfkill
will do it by itself using uevents, that code has already been accepted.
The rfkill class will do it for all rfkill controllers, and rfkill input may
be taught to do it later if userspace people ask for it (nobody did it yet
because it is not very useful, since what you want is reports of what really
IS happening to the radios, and those come from the rfkill class.  All
rfkill-input could tell userspace is what it is *trying* to change radio
states, but not whether they did really happen).

The reason why you'd want to send a KEY_WLAN event (or, if you can, an EV_SW
SW_WLAN event) is to change that key from something that controls an
specific WLAN radio, to something that can *potentially* control every WLAN
radio attached to the box.   It is *not* done to report status to userspace
[unless you meat report state to something in userspace that is doing what
rfkill-input does in the kernel, but we haven't enhanced rfkill-input and
rfkill to export all states needed for such an userspace implementation
yet].

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
