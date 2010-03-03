Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0CCLCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:02:51 -0500
Received: from poutre.nerim.net ([62.4.16.124]:49748 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0CCLCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:02:50 -0500
Date: Wed, 3 Mar 2010 12:02:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303120244.371882a9@hyperion.delvare>
In-Reply-To: <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	<404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	<20100303103405.127020d8@hyperion.delvare>
	<404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 02:29:09 -0800, Dima Zavin wrote:
> Jean,
> 
> Thanks for the prompt reply.
> 
> >> I definitely see the need for what you guys are trying to accomplish.
> >> For example, currently, we use an input device for reporting events,
> >> and a separate misc device node for control
> >> (enable/disable/configure). It's definitely suboptimal, but there
> >> currently isn't anything there would let us do things cleanly.
> >>
> >> What I would love to see is a more generic sensors framework that
> >> handles different kinds of sensor devices, and different data
> >> acquisition schemes (sampled vs. change notifications).
> >>
> >> I would love to work with you to design something more generic.
> >
> > This can happen later, I see no reason to block the creation of the ALS
> > subsystem. Having a common framework for all ambient light sensor
> > drivers will already be a step forward compared to the current
> 
> Following the logic of putting the ALS subsystem under drivers/als, we
> would then put the proximity subsystem under drivers/proximity, and
> then an accelerometer subsystem under drivers/accelerometer, etc. Each
> with their own implementation of very similar set of interfaces. Is
> that what you envision? I just figured that instead of creating
> one-off interfaces for some subset of environmental sensors such as
> als, we can add a sensors subsystem of which als is just an instance.

We need ALS support yesterday, so it can't build on top of a more
generic framework that doesn't exist today. If you want to design such
a generic framework, feel free, go ahead, and when it's ready, merge
everything you want in it. But we will not wait for you.

> > situation. If improvements are needed on top of this, this can happen
> > later.
> 
> I'm just concerned that instead of solving the actual problem, you are
> adding what is essentially a temporary solution.

This is certainly true. But you have to realize that _all_ the kernel
code is a temporary solution. We change over 2000 lines of code every
day on average.

> This will only make
> it harder to solve the real issue by introducing new interfaces which
> will need to be obsoleted unless they are designed with care. What you
> are proposing already needs improvements since there are plenty of
> drivers floating out there from many OEMs/vendors that are not ALSs,
> but essentially need a similar interface (e.g. proximity sensor).

I don't care at all. I want ALS support, and I want it now. If you or
others want something else, go work on it. And if several subsystems
should share something, it can happen later. The point is, you won't
know what they need to share exactly until they are all already there
each with a decent set of drivers. So there is no real benefit in
designing the big thing first, because you'd have to adjust it later
anyway.

> Furthermore, are there more patches coming for this subsystem? Based
> on the above tree, it just seems to be a class device (without any
> standard attributes) and a register/unregister function. It doesn't
> seem to actually be doing anything. Registering with the als subsystem
> at the moment buys the driver nothing. So, in its current state, I'm
> not sure I see what this new common framework actually provides us,
> and thus I'm not sure that it's actually a step forward.

There are two major benefits:
1* The set of available ALS drivers become visible: just look into
  drivers/als and you get most of them, search for callers of the
  registration function and you get them all. This will avoid redundant
  code development, and will make adding new drivers easier.
2* All ALS devices will be reachable at the same location in sysfs.
  There is no way user-space can consume whatever the drivers provide
  without this common entry point. And we need user-space consumers,
  otherwise we just don't know what the real needs are.

> The drivers
> are still responsible to provide all their own non-standard,
> incompatible sysfs interfaces for exporting the sensor values.

Apparently you did not read the patches all that carefully. One of them
creates a documentation file describing the standard sysfs files for ALS
drivers. All ALS driver must comply with it, so they are neither
non-standard nor incompatible. Note that the sysfs files are defined as
a "testing ABI", because we are well aware that it might change in a
near feature. We will move it to "stable ABI" when ready.

> If
> there are other patches for the als subsys that are then used by the
> two drivers that got moved into drivers/als, I'd love to take a look
> at them.

Not that I am aware of. But again, it doesn't mean this won't happen
later, if the need arises. How do you expect us to know what code
should be common as long as we don't have a central place to store all
drivers and a common interface to their devices?

-- 
Jean Delvare
