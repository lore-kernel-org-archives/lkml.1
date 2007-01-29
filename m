Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbXA2N6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbXA2N6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXA2N6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:58:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:60960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751387AbXA2N6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:58:42 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	<87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
	<87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz>
	<873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz>
	<878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
	<20070127192034.GA17652@suse.cz>
Date: Mon, 29 Jan 2007 14:58:38 +0100
Message-ID: <874pqanddd.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik <vojtech@suse.cz> writes:

   On Sat, Jan 27, 2007 at 05:45:25PM +0000, Pavel Machek wrote:
   > Hi!
   >
   > >    Well, I do not think your kernel code is mergeable. But bits to enable
   > >    similar functionality in userspace probably would be mergeable.
   > >
   > > You said it :-)
   > >
   > > This patch exports to the user space the inactivity time (in msecs) of a given
   > > input device. Example follows:
   >
   > Looks okay to me. I guess you should sign it off, and ask Dmitry
   > (input maintainer) for a merge?

Pavel, the submitted patch was not meant for production use: it still suffers
of the time-warp problem. To fix it I need to know when the system goes to
sleep/resumes. In SIN I've solved via the platform driver, introducing
suspend() resume() callbacks. What do you think about?

   The /proc/bus/input/devices has an extensible structure. You can just
   add an "A:" line (for Activity) instead of adding a new proc file.

I know, but IMO there is too much stuff to parse in there. Activity counters
are frequently accessed by daemons, and four or five concurrent daemons are the
norm in a typical X11 linux box...

   Anyway, I believe this should be also available through sysfs, if not
   only there.

Pavel gives me clearance for only bits of code, so I've recycled something
already done. No problem for me to switch /sys.

   Also, the activity counters should IMO coincide with the event times
   passed through /dev/input/event, and should not be jiffies based.
   Ideally, both should be based on clock_gettime(CLOCK_MONOTONIC).

In evdev.c do_gettimeofday() is used. Anyway I just need of a monotonic
counter, so get_jiffies_64() wouldn't be better? It isn't affected by wrapping
issues and it is probably faster than do_gtod().

Best,

--
Ambition is a poor excuse for not having sense enough to be lazy. - Edgar Bergen
