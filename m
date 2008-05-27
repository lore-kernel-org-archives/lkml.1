Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYE0Rls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYE0Rls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYE0Rlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:41:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48732 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbYE0Rlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:41:36 -0400
Message-Id: <1211910094.13064.1255315907@webmail.messagingengine.com>
X-Sasl-Enc: G2LzJFOZfSkARvwKuC2lOJfpIU7hvLIqYHb892VthCPG 1211910094
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
   <200805231615.33414.IvDoorn@gmail.com>
   <1211897317.22073.1255269155@webmail.messagingengine.com>
   <200805271638.04290.IvDoorn@gmail.com>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS
   OFF
In-Reply-To: <200805271638.04290.IvDoorn@gmail.com>
Date: Tue, 27 May 2008 14:41:34 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 16:38:04 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> > So yes, I do feel RFKILL_ALL is different, and it warrants EPO semanthics in
> > the kernel, while all other rfkill events, such as KEY_WLAN, don't.
> > 
> > I don't feel strongly about not giving EPO semanthics to other rfkill events,
> > but I recommend against giving anything else EPO semanthics in rfkill.
> 
> You just made my 2 laptops very happy because apparently they
> don't behave like most keys do. ;)
> 
> Laptop 1)
> 	- Key to control WLAN (Broadcom)
> 	- Key to control Bluetooth (Broadcom??)
> Laptop 2)
> 	- Key to control WLAN (Intel)

You don't have a SW_RFKILL_ALL switch :-)   It is the same as my ThinkPad T43,
it does *NOT* have a SW_RFKILL_ALL switch, and it has a wireless config hotkey,
which is handled in firmware.  The firmware can wire-kill the Intel WLAN card,
and it can also unplug(!) the internal Bluetooth device from the internal USB
bus.

You'd typically assign KEY_WLAN or something else to those keys, but NOT a 
(fictitious) KEY_RFKILL_ALL.

So, my ThinkPad T43 would NEVER issue *_RFKILL_ALL events by default.

> And each key really controls the hardware, without any software required.

Works just like a ThinkPad before you set its hotkey mask to request the firmware
to hands-off the hotkeys, then.

> Especially for Laptop one it will not be nice to attack RFKILL_ALL to
> both keys,
> since both control specific radio types.

Those keys definately are *NOT* to have *_RFKILL_ALL attached to them by default,
I agree.

> key or not. Perhaps you do know with some hardware like thinkpad, but
> with my second laptop for example, it only has 1 kind of radio and that 
> is WLAN it also has 1 key.
> When it is pressed, you simply don't know if it is switched off because
> of the no-RF area or to powersave.

Then you assume it is just a normal key.  If the user wants to promote that
key to the Wireless EPO key, he changes the default assignment of KEY_WLAN to
KEY_RFKILL_ALL (although I didn't propose a KEY_RFKILL_ALL yet).

> With my first laptop, the broadcom WLAN driver will register the key, but
> it doesn't know if it is alone or if Bluetooth hardware is also present. So
> it cannot know if it is a master switch or not.

Correct.

This is *explicitly* documented by the patches.  The broadcomm driver has to assume
it is a slave rfkill device, and NEVER report any input events.  It has no knowledge
of which platform the broadcomm chip was installed into, after all.  OTOH, it *will*
report the status change through the rfkill notify chain and also through the rfkill
uevents, and either a platform module for your laptop, or HAL (in userspace) can
trap those, and issue the relevant input events.

*IF* you get the events only through the broadcomm device, that is. If you get them
from ACPI as well, you probably want to let the ACPI driver issue the input events.

> > But of course, you have to make sure the master switch WILL bloody well stay off
> > when off by design.  You engineer it so that all possible failure modes will
> > cause it to go to the off state.
> > 
> > I would really appreciate that the rfkill class would abide to this UI notion for
> > the master rfkill events (*_RFKILL_ALL).
> 
> Such a thing would indeed be nice, as long as you can positively identify
> a master switch,
> but as long as that is not possible/implemented it will only be confusing
> for driver developers,
> userspace developers and the users.

We document it *throughoutly*, and add a big fat warning about the misuse of
RFKILL_ALL.   It should be enough.   Will you consider ACKing a new version of
the patchset which documents better the *_RFKILL_ALL events?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

