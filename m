Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0CIRcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:32:48 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:44152 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0CIRcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:32:45 -0500
Message-ID: <4B968628.7060409@seas.upenn.edu>
Date: Tue, 09 Mar 2010 12:32:24 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: Re: [PATCH 7/7] HID: N-trig MTM Driver fix And cleanup patch 7
References: <micki@n-trig.com> <1268083024-3029-1-git-send-email-micki@n-trig.com> <4B95A521.3070208@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190301AF42@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190301AF42@Exchange-IL.n-trig.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 11:40 AM, Micki Balanga wrote:
>
> Hi All
> In this mail I will try to answer all your questions. First I will
> explain to you N-trig Solution:
> N-trig solution contains:
> 1. Hid kernel driver
> 2. User space application  N-trig propriety IP. An application which
> analyzes the data received from the driver
> (Pen and touch) into real events.

Already are real events.  Just a little messy/noisy.

> 3. X11 Driver  communicate with N-trig user space application.
> N-trig will release to the open source updates (bugs, and features) for
> the driver and an installation package (RPM, DEB)
> for user space applications. I will release an update version of the
> driver, once we agree about all the changes.

Why hold back on the userspace and x11 driver source?  I'm not 
suggesting a press release or a major publication.  But perhaps showing 
off your other applications might explain some of your proposed changes 
and offer us an opportunity to help you refactor your kernel<->user 
space assumptions to bring them in line with other devices.

Please remember, people already have these things working in the field. 
  They are already using pen, touch and even multi-touch.  You can not 
offer initial support, its too late for that.  And you have not been 
making much of a case for why your support is an improvement.  Please 
enlighten us.

> 1. I'd rather remove all the MODULE_VERSION: Answer: will be done in the
> next patch release,
> also with the change log update.
>
> 2. MODULE_NAME "hid_ntrig - Answer will change it back to ntrig, as
> it was in the first patch submitted.
>
> 3. N-trig application (Propriety IP) analyze (math algorithms) the
> information received from the driver
> into real touch event. Events like fake fingers, frame index , generic
> byte, palm
Is frame index any more than a checksum?

Still haven't explained what you mean by "fake fingers".  Its not clear 
what they have to do with the user space.  And its really unclear why 
you bother with extra computation and an extra field in the kernel 
driver.  The only place in the kernel code you actually be replaced with 
"real_fingers == 0", or "real_fingers == 1".

> used by the application in parsing the events received from the driver
> (firmware)
> into real fingers, pen events.

What purpose do the Proprietary IP algorithms serve?  I suspect you will 
find a lot of resistance to adopting closed portions of your drivers 
unless they actually serve a novel purpose that isn't readily available 
with obvious or pre-existing algorithms.  Finger tracking, noise/ghost 
elimination and suppression and many other analytic operations you could 
perform to clean up the behavior are already well known.  What else to 
do you plan to offer?

> 4. Our driver support N-trig old firmware but we will supply a Firmware
> upgrade (MTM)
> version in order to user to enjoy the full multi-touch experience.

Glad to hear it.

> 5. Later we will be evolved with the X11 development.
> 6. You still haven't actually established why its necessary to fuss
> with pen events if we split the pen off to a separate input device - We
> need to separate Pen from Finger to allow our user space application to
> analyze Pen and Touch events

I'm confused, you do want to split pen and touch?  Cause you took out 
the line of code that does that.  Do you perchance have the multiple 
input quirk set in hid-quirks.c?  I was thinking of moving it there at 
some point soon.  The patch you sent in did not split the two streams to 
separate input devices when I tried it.

> 7. case HID_DG_CONTACTID - At develop stage we used USB analyzer and
> gizmod tool and we didn't see any problem using case HID_DG_CONTACTID.

Please clarify.  I have not seen any protocol issues with it, just that 
the values are incorrect.  Is this just the result of a single buggy 
firmware?  On my screen, contact 0 is the lowest finger, and changes 
when I move my fingers up and down (y+/y-) along the screen.  (If you 
send firmware version code, I'll send the version of firmware I'm using, 
its from the 2.172 bundle).

> 8. Even if you want to argue that you need to pull the multi-input
> quirk, that doesn't justify pulling the names. Perhaps you may wish to
> truncate the name to "N-Trig" or something. But give them some name.
> Those names simplify driver correlation in user space. In kernel 2.6.31
> - I got kernel panic, will put it in the next release.

Yes, that's my bad, there should be a guard before the switch:
list_for_each_entry(hidinput, &hdev->inputs, list) {
       input = hidinput->input;
+ if(hidinput->report->maxfield > 0)
