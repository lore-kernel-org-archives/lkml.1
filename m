Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbXJWNVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbXJWNVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXJWNVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:21:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:25823 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXJWNVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PLwTxyJujAdYMEI70y/xHp9AkkbWEZOjdZwjrUa66kOP348RjS2Ie5+/EnDyT1gm7zYImotUYe2+KwIoB//85TIFw3Ddoc8qLKMQPdmm2pXVIjLFGWpH/rj5wvA4SoQh5PcSo8ST/UOa7O0WQJI6ExYcBm76j90LKe2+NQfdG+s=
Message-ID: <d120d5000710230621j3913384cn37dbab1a764de31c@mail.gmail.com>
Date: Tue, 23 Oct 2007 09:21:41 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ryan Lortie" <desrt@desrt.ca>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Cc: "Zephaniah E. Hull" <warp@aehallh.com>, linux-kernel@vger.kernel.org,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <1191035147.7025.28.camel@moonpix.desrt.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070609084800.GR6362@aehallh.com>
	 <200706120120.00494.dtor@insightbb.com>
	 <20070612052316.GX6362@aehallh.com>
	 <200706120135.06428.dtor@insightbb.com>
	 <20070612054031.GY6362@aehallh.com> <20070702152044.GA24665@suse.cz>
	 <20070703164555.GA20370@aehallh.com>
	 <1191035147.7025.28.camel@moonpix.desrt.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On 9/28/07, Ryan Lortie <desrt@desrt.ca> wrote:
>
> Hello.
>
> I have been working on a more flexible system for blocking the delivery
> of input events to other agents in the system.
>
> My approach is basically summed up as follows:
>
>  - split the current purpose of input_handle into two parts
>
>    - input_handle continues to exist as a mechanism for tracking which
>      handlers are currently interested in a particular device
>
>    - a new input_client now exists as a mechanism for tracking
>      tracking who is interested in having events delivered from a
>      particular device.
>
>    As an example, for evdev, one input_handle will exist per event
>    device in /dev/input and one input_client will exist per open().
>
>  - cause input events to be delivered to 'clients' (ie: first argument
>    is an input_client instead of input_handle)
>
>  - add a concept of 'priority'
>
>    - the new input_client structure has a priority field
>
>    - the list of input_client's per device is kept sorted by this field
>
>  - add the ability for the handler 'event' function to block further
>    event propagation.  This is done by making the handler return 'int'
>    instead of 'void'.  0: continue normally.  1: stop.
>
>  - add "set priority" ioctl to evdev
>
>  - add "set requested keys" ioctl to evdev.
>
>    This causes delivery of only certain keycodes to this particular
>    open().  I have no particular interest in doing this sort of masking
>    for other (non-key) events but maybe it makes sense.
>
>  - add "set filter" ioctl to evdev.
>
>    This causes any "requested keys" to be consumed and not further
>    delivered (ie: the event handler for this client will return 1).
>
>  - also, as a small style issue: I made what I believe to be a
>    simplification to the switch() statement in the evdev ioctl code.
>    Whether this is actually a simplification or not is a matter of
>    opinion. :)
>
>  - port the non-evdev handlers (including rfkill) to the new
>    handler/client interface in the most trivial way possible: open the
>    input_client in the places where the old code used to call open with
>    the input_handler.
>
> The motivation is to allow arbitrary things in user-space to have a rich
> support over blocking (possibly a select set of) key events from being
> delivered to anything below a certain 'priority'.
>
> I believe this will solve the problem of X wanting to block key delivery
> to the VT module while still allowing the events to go through to rfkill
> (which presumably will be given a higher priority).
>
> This will also allow hal's "multimedia key" reporting code to be
> improved in two ways: first, it can block the multimedia keys from being
> delivered to X (and causing weird ^[[29~ things to appear in my
> terminals) and second, it results in hal only waking up when an
> "interesting key" is pressed (currently it wakes up on every single
> keypress).
>

I like the idea of limiting number of events that client wants to be
delivered to it. I think we need to extend it from keybit only to
event bitmask + keybit. This way, if keyboard has a scrollwheel or a
touchpad installed, HAL can still specify EV_KEY + KEY_XXX and ignore
all REL_* and ABS_* events.

Priority/filter idea is different matter. I don't think it is a giood
solution. There will always be an "arms race", new applications would
like to get in front of the queue all the time and it will be hard to
manage. X should just keep console open in raw mode and simply ignore
all events coming from it while using evdev driver. I understand that
X's hotplug support is getting there so you should be able to switch
to pure evdev setup pretty easy.

> I have written a patch.  It is "over 40kb" so I don't include it
> directly here.  It is available in its full form (or broken up) at this
> url:
>
> http://desrt.mcmaster.ca/code/input-patch/
>
> This patch is not being proposed for inclusion in its current state.  In
> addition to the many problems that I'm sure I don't even realise, here
> are some that I would specifically like feedback on:
>
>  - how should we decide what gets what priority level?
>

Exactly. You can't predict all future uses. There will always be
someone wanting to get in front of the line.

>  - is it appropriate to have INPUT_PRIORITY_HIGH/LOW/SYSTEM/DEBUG, etc.
>    macros in input.h?
>
>  - why did the old code call flush() on the device before closing when
>    disconnecting?  It seems particularly silly now that with my patch
>    it will be called n times (one for each client)

To remove any force-feedback effects installed by client that is being
disconnected.

>
>  - how are switches supposed to be indented?  the "checkpatch" script
>    in the kernel complained about my style despite following what was
>    already in that file.

I think I fixed this.

>
>  - I haven't tested on big endian or "compat" systems at all.  As far
>    as I know, the relevant code doesn't even compile.  Help here is
>    appreciated (I don't have such a machine!).
>
>  - there is small thread-safety issue with how I handle EVIOCSRKEYS on
>    defined(CONFIG_COMPAT) && defined(__BIG_ENDIAN).  If events are
>    delivered after the copy_from_user but before the word-swapping then
>    events may be inappropriately dropped or delivered.  Do we care?

Input core now has prper locking. You may take device's event_lock to
stop event propagation.

-- 
Dmitry
