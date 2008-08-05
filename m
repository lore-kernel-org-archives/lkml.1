Return-Path: <linux-kernel-owner+w=401wt.eu-S1765603AbYHEVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765603AbYHEVYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYHEVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:24:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57808 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbYHEVYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:24:23 -0400
X-Sasl-enc: hnkxzDawcB8M9SQJuRiUZ9uO0lUhokY2SLxQoOHXtsaX 1217971461
Date: Tue, 5 Aug 2008 18:24:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080805212416.GB21738@khazad-dum.debian.net>
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48965716.6020508@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2008, Philip Langdale wrote:
>>> +static void bt_acpi_notify(acpi_handle handle, u32 event, void *data)
>>> +{
>>> +	struct toshiba_acpi_dev *dev = data;
>>> +
>>> +	switch (event) {
>>> +	case BT_ACPI_SOFT_UNBLOCKED_EVENT:
>>> +		if (!dev->ignore_next_bt_event) {
>>> +			bt_rfkill_toggle_radio(data, RFKILL_STATE_UNBLOCKED);
>>> +			rfkill_force_state(dev->rfk_dev,
>>> +					   RFKILL_STATE_UNBLOCKED);
>>
>> This one got me confused.  Why do you need that bt_rfkill_toggle_radio call
>> here?
>
> When you turn off the hardware kill switch, the hardware will not reactivate
> the bluetooth device. it just returns to the SOFT_UNBLOCKED state. I put that
> in so that it would turn the device back on - a generally more desirable
> behaviour - otherwise the user has to dig around for a software way to turn
> it back. All the other hardware I've ever seen (including the wifi device on
> this laptop) turns it back on, so it seemed sensible to try and make it work
> as people would expect.

Well, you really shouldn't be doing things this way.  It hardcodes policy on
something that is for either rfkill-input or for userspace to decide.

I think I got the picture of how it works in toshiba, it is similar to the
thinkpads.

If I got it right, you have

(1) a input device (a hardware kill switch)
(2) a rfkill controller for bluetooth

And the firmware causes (1) to force-disable (2), but loses state when it
does so and leaves it disabled when (1) is not forcing the state to disable
anymore.

Well, the textbook way to connect that to rfkill is something like this,
please check if it makes sense:

Export (1) as a input device (you have events to hook to when it changes
state) or polled input device (you don't have said events).  Do NOT register
(1) with a struct rfkill at all.  It is purely an input device.

DO NOT expose (2) as an input device at all.  Instead, register it to a
rfkill struct, of type bluetooth.

On the event handler for (1), you issue the EV_SW SW_RFKILL_ALL input event.
Since you *do* know events from (1) are likely to also have messed with the
state of (2), you also check (2)'s state at this time and update it through
rfkill_force_state().

Due to the interaction of 1 and 2, you need to implement and deal with
RFKILL_STATE_HARD_BLOCKED.  Since you do know the firmware will be
hard-blocking (2) when (1) is active, you return RFKILL_STATE_HARD_BLOCKED
for (2)'s state every time (1) is active.  Otherwise, you return
RFKILL_STATE_SOFT_BLOCKED when (2) is blocked, and RFKILL_STATE_UNBLOCKED
otherwise.

This will cause the state of (2) to go to either RFKILL_STATE_HARD_BLOCKED
or RFKILL_STATE_SOFT_BLOCKED when (1) changes state.

[Note: the above does assume (1) blocks (2) in some way you cannot override,
and that trying to unblock (2) while (1) is blocking it is futile].

rfkill-input (now) or userspace (someday) will take care of kicking the
radio to RFKILL_STATE_UNBLOCKED when (1) issues an event that signals that
radios don't have to remain blocked.  Maybe this is why you see the WLAN
going on when you deactivate the radio kill switch?

And rfkill-input will soon be enhanced to let the user configure it to do
something different if he wants.  Your driver doesn't (and shouldn't)
hardcode policy about it.


>> Read the kernel-doc headers of every rfkill function you call at least
>> once...  Never rfkill_free() something you rfkill_unregister()'ed.
>>
>> rfkill_free() is just for the error unwind of a failure between
>> rfkill_allocate() and rfkill_register().
>
> Fair enough, but it doesn't help that rfkill and input-polldev work in
> exactly opposite ways; polldev requires you to unregister and then free;
> some consistency wouldn't hurt.

That's just how the code was when I started enhancing it, you can ask Ivo
(the rfkill maintainer) about the reasons behind it if you want, or you
could try to submit a patch to Ivo changing rfkill (and every driver using
rfkill) to rfkill_free() after rfkill_unregister().

>>> +		toshiba_acpi.rfk_dev->dev.class->suspend = NULL;
>>> +		toshiba_acpi.rfk_dev->dev.class->resume = NULL;
>>
>> Why?
>
> Good question. Gone.

Thanks.  Please take note that rfkill will, right now, try to BLOCK all
radios on suspend.  That will be changed soon (2.6.28 at the latest), and
your driver will have to handle blocking radios on suspend directly if it is
needed for toshibas.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
