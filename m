Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYHGNpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYHGNpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYHGNph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:45:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52548 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYHGNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:45:36 -0400
X-Sasl-enc: QuXzkqf4BdM2fBghkRwxJ8EQZYoWZQHQVglE+KmwUFwT 1218116734
Date: Thu, 7 Aug 2008 10:45:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080807134530.GB17062@khazad-dum.debian.net>
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A7CCF.1090407@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008, Philip Langdale wrote:
> Henrique de Moraes Holschuh wrote:
>> Well, the textbook way to connect that to rfkill is something like this,
>> please check if it makes sense:
>>
>> Export (1) as a input device (you have events to hook to when it changes
>> state) or polled input device (you don't have said events).  Do NOT register
>> (1) with a struct rfkill at all.  It is purely an input device.
>>
>> DO NOT expose (2) as an input device at all.  Instead, register it to a
>> rfkill struct, of type bluetooth.
>>
>> On the event handler for (1), you issue the EV_SW SW_RFKILL_ALL input event.
>> Since you *do* know events from (1) are likely to also have messed with the
>> state of (2), you also check (2)'s state at this time and update it through
>> rfkill_force_state().
>>
>> Due to the interaction of 1 and 2, you need to implement and deal with
>> RFKILL_STATE_HARD_BLOCKED.  Since you do know the firmware will be
>> hard-blocking (2) when (1) is active, you return RFKILL_STATE_HARD_BLOCKED
>> for (2)'s state every time (1) is active.  Otherwise, you return
>> RFKILL_STATE_SOFT_BLOCKED when (2) is blocked, and RFKILL_STATE_UNBLOCKED
>> otherwise.
>>
>> This will cause the state of (2) to go to either RFKILL_STATE_HARD_BLOCKED
>> or RFKILL_STATE_SOFT_BLOCKED when (1) changes state.
>>
>> [Note: the above does assume (1) blocks (2) in some way you cannot override,
>> and that trying to unblock (2) while (1) is blocking it is futile].
>>
>> rfkill-input (now) or userspace (someday) will take care of kicking the
>> radio to RFKILL_STATE_UNBLOCKED when (1) issues an event that signals that
>> radios don't have to remain blocked.  Maybe this is why you see the WLAN
>> going on when you deactivate the radio kill switch?
>>
>> And rfkill-input will soon be enhanced to let the user configure it to do
>> something different if he wants.  Your driver doesn't (and shouldn't)
>> hardcode policy about it.
>
> Hmm. So, I've updated the diff to do this, but rfkill-input is not kicking
> the bluetooth device back on after I release the kill switch. it just returns
> to SOFT_UNBLOCKED and stays there.

Hmm?  UNBLOCKED means it is not being rfkilled.  Why is not working?  Put
some debug printks on your toggle_radio callback, that might help fix the
issue...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
