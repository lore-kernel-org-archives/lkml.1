Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYDLM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYDLM4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYDLM4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:56:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43022 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbYDLM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:56:23 -0400
X-Sasl-enc: OndLRTpoFdeSCuVI6IfyiWymR/v8P3dSbIz9rUFPdBbk 1208004982
Date: Sat, 12 Apr 2008 09:56:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Message-ID: <20080412125620.GC3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-9-git-send-email-hmh@hmh.eng.br> <200804121236.46626.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121236.46626.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > Currently, radios are always enabled when their rfkill interface is
> > registered.  This is not optimal, the safest state for a radio is to be
> > offline unless the user turns it on.
> 
> It defaults to the current state of the switch type.

Hmm, I better reword that to "Currently, the desired radio state is
hardcoded in rfkill to be initially ON."  Would that be more clear?

The patch changes the initial state of the switch type, the one rfkill
currently is hardcoded to set to "RADIO IS ON" at module load.  I.e. it
just removes the hardcoding by making it possible to set the desired
initial state of all radios at module load time.

This makes rfkill actually a damn good UI for radio switch
initialization, IMHO.  You tell the kernel what is the state you want
for all radios in just one place and rfkill enforces all radios are set
to that state during bootstrap and initial coldplug party.

Drivers loaded later will be set to whatever the global state of their
switch type in rfkill is at the moment.

> What perhaps could be done, is that during registration it either reads
> the status directly from rfkill to what the device initialized it to,

I am *all* for a proper init of rfkill->state to match the real hardware
state.  I have always been, and I complained about that when rfkill
initially landed in mainline.

But I do agree that the current "desired behaviour" of rfkill (i.e. what
it should be doing, barring any bugs): that it will immediately set
newly registered radios to the state their type switch is at, to be a
good idea.

In fact, for write-only radios, you *have* to enforce their initial
state, because it is effectively unknown.  And in order to do that, you
must avoid any code paths that would do stuff like "if (rfk->state !=
desired_state) toggle_radio(desired_state)".

> or call get_status() during registration to determine the new state itself.
> That way we prevent series of module parameters and initialize to the state
> the driver has indicated..

As an user, I do NOT want to have to deal with per-radio-module
parameters in order to set their initial state to ON or OFF.  Yes, it is
what we have right now for some radio devices, and it is extremely
unoptimal.

Keeping track of the radio state (including which initial state it
should be set to) is exactly what something like the rfkill layer is
supposed to be good at: set parameters for an entire class of hardware
in a generic way, in a single place, and in one go.

> > Add a module parameter that causes all radios to be disabled when their
> > rfkill interface is registered.  Add override parameters for each rfkill
> > switch type as well, just in case the user wants the defaults to be
> > different for a given radio type.
> 
> I am not a big fan of large series of module parameters, so in that aspect
> I am not a fan of this patch.

If you think per-radio-type is too much, we just drop that part of the
patch.  It will make it quite smaller, and it will preserve the
functionality that is really needed (let the user tell the kernel to not
try to power up radios by default).

I made it type-aware because I can see an user wanting the long-range
radios off by default, and his personal-device-space radios (UWB,
Bluetooth) on by default.

> > We don't change the module default, but I'd really recommed doing so in a
> > future patch.

In fact, I better ask it now: do you want me to respin the patch with
just one global switch, and make its default to be "radios offline" ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
