Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXI2Djv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXI2Djv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 23:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXI2Djo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 23:39:44 -0400
Received: from ns2.mountaincable.net ([24.215.0.12]:56149 "EHLO
	ns2.mountaincable.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbXI2Djn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 23:39:43 -0400
X-Greylist: delayed 1974 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 23:39:42 EDT
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
From: Ryan Lortie <desrt@desrt.ca>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <20070703164555.GA20370@aehallh.com>
References: <20070609084800.GR6362@aehallh.com>
	 <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com>
	 <200706120135.06428.dtor@insightbb.com> <20070612054031.GY6362@aehallh.com>
	 <20070702152044.GA24665@suse.cz>  <20070703164555.GA20370@aehallh.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 23:05:47 -0400
Message-Id: <1191035147.7025.28.camel@moonpix.desrt.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-07 at 12:45 -0400, Zephaniah E. Hull wrote:
> We just want a more flexible approach then what we are already using[0].
> 
> I'll see about writing something up when I get back to my computers[1]
> and have things set back up[2].
> 
> Zephaniah E. Hull.
> 
> 0: EVIOCGRAB.
> 1: The night of the 10th.
> 2: It could be a few days after I get back.

Hello.

I have been working on a more flexible system for blocking the delivery
of input events to other agents in the system.

My approach is basically summed up as follows:

  - split the current purpose of input_handle into two parts

    - input_handle continues to exist as a mechanism for tracking which
      handlers are currently interested in a particular device

    - a new input_client now exists as a mechanism for tracking
      tracking who is interested in having events delivered from a
      particular device.

    As an example, for evdev, one input_handle will exist per event
    device in /dev/input and one input_client will exist per open().

  - cause input events to be delivered to 'clients' (ie: first argument
    is an input_client instead of input_handle)

  - add a concept of 'priority'

    - the new input_client structure has a priority field

    - the list of input_client's per device is kept sorted by this field

  - add the ability for the handler 'event' function to block further
    event propagation.  This is done by making the handler return 'int'
    instead of 'void'.  0: continue normally.  1: stop.

  - add "set priority" ioctl to evdev

  - add "set requested keys" ioctl to evdev.

    This causes delivery of only certain keycodes to this particular
    open().  I have no particular interest in doing this sort of masking
    for other (non-key) events but maybe it makes sense.

  - add "set filter" ioctl to evdev.

    This causes any "requested keys" to be consumed and not further
    delivered (ie: the event handler for this client will return 1).

  - also, as a small style issue: I made what I believe to be a
    simplification to the switch() statement in the evdev ioctl code.
    Whether this is actually a simplification or not is a matter of
    opinion. :)

  - port the non-evdev handlers (including rfkill) to the new
    handler/client interface in the most trivial way possible: open the
    input_client in the places where the old code used to call open with
    the input_handler.

The motivation is to allow arbitrary things in user-space to have a rich
support over blocking (possibly a select set of) key events from being
delivered to anything below a certain 'priority'.

I believe this will solve the problem of X wanting to block key delivery
to the VT module while still allowing the events to go through to rfkill
(which presumably will be given a higher priority).

This will also allow hal's "multimedia key" reporting code to be
improved in two ways: first, it can block the multimedia keys from being
delivered to X (and causing weird ^[[29~ things to appear in my
terminals) and second, it results in hal only waking up when an
"interesting key" is pressed (currently it wakes up on every single
keypress).

I have written a patch.  It is "over 40kb" so I don't include it
directly here.  It is available in its full form (or broken up) at this
url:

http://desrt.mcmaster.ca/code/input-patch/

This patch is not being proposed for inclusion in its current state.  In
addition to the many problems that I'm sure I don't even realise, here
are some that I would specifically like feedback on:

  - how should we decide what gets what priority level?

  - is it appropriate to have INPUT_PRIORITY_HIGH/LOW/SYSTEM/DEBUG, etc.
    macros in input.h?

  - why did the old code call flush() on the device before closing when
    disconnecting?  It seems particularly silly now that with my patch
    it will be called n times (one for each client)

  - how are switches supposed to be indented?  the "checkpatch" script
    in the kernel complained about my style despite following what was
    already in that file.

  - I haven't tested on big endian or "compat" systems at all.  As far
    as I know, the relevant code doesn't even compile.  Help here is
    appreciated (I don't have such a machine!).

  - there is small thread-safety issue with how I handle EVIOCSRKEYS on
    defined(CONFIG_COMPAT) && defined(__BIG_ENDIAN).  If events are
    delivered after the copy_from_user but before the word-swapping then
    events may be inappropriately dropped or delivered.  Do we care?

Ultimately, I'd very much like this to make it into 2.6.24 and I'm
willing to make the necessary changes to see that it happens.

Cheers

