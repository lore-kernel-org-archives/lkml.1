Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbYDLUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbYDLUgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYDLUgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:36:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40583 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbYDLUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:36:06 -0400
X-Sasl-enc: 9xZuCUiZhHEtjNdmgDV6Y5hzE7RDnM4aNfoYVf55lJzH 1208032565
Date: Sat, 12 Apr 2008 17:36:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Message-ID: <20080412203601.GA30014@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080412180219.GI3402@khazad-dum.debian.net> <200804122014.41583.IvDoorn@gmail.com> <200804122009.29968.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804122009.29968.carlos@strangeworlds.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Carlos Corbacho wrote:
> Although the current wireless driver implementations of rfkill/ input polling 
> have been causing me a bit of a headache lately, with no nice solution in 
> site, because of the following (b43 does this, but I suspect rt2x00 may also 
> do the same, so it's a slightly more generic problem). Now, I have a patch 
> locally to add rfkill support to acer-wmi, but still keep seeing the 
> following:
> 
> 1) acer-wmi loads
> 2) Press KEY_WLAN
> 3) rfkill-input notifies all registered KEY_WLAN rfkill drivers that KEY_WLAN 
> has been pressed.

No.  It changes the global state for WLAN rfkill switches, and then it
causes rfkill to call the toggle_radio(new global state) hooks of all
these switches.  I know that's what you meant, but we better be explicit
about this.

There is NO notification of a key press, there is an explicit command to
change the radio switch state to an specific new state (it is not a
toggle command, even if the name of the hook is toggle_radio).

> 4) acer-wmi toggles the wireless radio state
> 5) b43 notices this state change because of it's polling, then sends a 
> KEY_WLAN event (even though b43 knows it can't control the radio on my 
> laptop)

b43 should not be issuing KEY_WLAN events in this case.  It should be
updating its rfkill->state (one of my patches add a proper way to do
this), but that's it.  See below.

> 6) Goto 3.
>
> And this continues in a loop. Removing the offending input_report_key() lines 
> in the wireless driver stops this.

No wonder it does, it is a Bug From Hell to use the input layer to
*report* events that happened and were already handled.  You use it to
*issue* events that *are still to be acted upon*, and that's only if you
are NOT the only one that will act upon them!  Sometimes it is not
trivial at all to know in which side of the fence you are.

And here things get difficult.  ipw2200 (or b43, or iwl*, etc) would
HAVE to know if its hardware rfkill input pin is supposed to be handled
as the canon way to know if rfkill is active or not, for example, not to
mention wheter it even makes sense for them to request that all other
radios change state (THAT is what issuing an input event means).

The simple, and IMHO any sane solution is to do the following:

1. Add a kernel notifier chain for b43, ipw*, iwl*, and other such
drivers to report any changes in their radio state (which is a product
of ALL their rfkill lines, software and hardware), and also changes in
their hardware rfkill input pins, using different events so that you
KNOW which ones are informing the world about input pin state changes,
and which one are just reports of a changed radio state.

2. NEVER issue input events from these drivers. At all. Just update the
rfkill switch state using rfkill_force_state, or let the pooling do it.

Then, we leave for userspace (hal + hal-info?) or a kernel platform
driver to decide if the kernel notification b43/ipw*/ilw*/etc issued
when it noticed its rfkill input pin changed state is to be made an
input event.

> Ideally, I think we are going to need some way of saying that platform 
> firmware level drivers (e.g. acer-wmi, thinkpad-acpi, etc) take priority over 
> the wireless drivers, and that the drivers should _not_ send out these 
> KEY_WLAN events if one of acer-wmi, etc are loaded (or find some other nice 
> way of handling this).

Better to have nothing but the platform firmware drivers issue such
input events.  Have all other drivers issue notification events instead
(which are not input events), and have something else that can be model
specific decide which notification events are to be made input events.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
