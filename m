Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYH2PIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYH2PIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYH2PIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:08:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:51071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYH2PIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:08:44 -0400
Date: Fri, 29 Aug 2008 08:05:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [patch 0/5] Nano/Microsecond resolution for select() and poll()
Message-ID: <20080829080549.6906b744@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today in Linux, select() and poll() operate in jiffies resolution
(granularity), meaning an effective resolution of 1 millisecond (HZ=1000) to
10 milliseconds (HZ=100). Delays shorter than this are not possible, and all
delays are in multiples of this granularity.

The effect is that applications that want (on average) to specify more
accurate delays (for example multimedia or other interactive apps) just
cannot do that; this creates more than needed jitter.

With this patch series, the internals of select() and poll() interfaces are
changed such that they work on the nanosecond level (using hrtimers). The
userspace interface for select() is in microseconds, for pselect() and
ppoll() this is in nanoseconds.

[actual behavior obviously depends on what resolution the hardware timers work, on
modern PCs this is pretty good though]

To show this effect I made a test application to measure the error made
in the select() timing.

For example, a userspace application asking for a 1200 microsecond delay, on
a HZ=1000 kernel, will in practice get a 1997 microsecond delay, a delta of
almost 800 microseconds (which is of course a high percentage of 1200). The
extreme case is asking for 1 microsecond, and getting 998 microseconds
delay... with the patch we get a 250 times improvement in behavior (!).

A graph of various inputs with the jitter can be seen at
http://www.tglx.de/~arjan/select_benefits.png

One thing to note is that on my machine, the current select() implementation
will return after 1997 microseconds when asked for 1999 microseconds; this
can be seen in a zoom in of the graph above:
http://www.tglx.de/~arjan/zoom.png
E.g. select() is returning too early in current Linux kernels; and this is
also fixed (by nature) by this patch series.
In the graph there's a 4 microsecond delta for most data points, this is
basically the measurement overhead (C-state exit, a few system calls, a 
loop and some math).


About the patches:

Patch 1: Introduces infrastructure where select() and poll() start tracking
	 the end time in a "struct timespec" rather than in jiffies, so in
	 nanosecond resolution.
Patch 2: Uses the now available end time in nanoseconds to calculate at the
	 end of a select()/ppoll() how much time is left and returns this 
	 in a high resolution rather than jiffies granularity
Patch 3: Introduces a schedule_hrtimeout(); a high resolution version of the
	 equivalent schedule_timeout() function.
Patch 4: Converts over select() to schedule_hrtimeout()
Patch 5: Converts over poll() to schedule_hrtimeout()


Note: 
even though poll() (as opposed to ppoll()) only accepts milliseconds
as userspace interface, the behavior will still improve because the current
time no longer needs to be rounded up to the next jiffie, so on average
a 500 milliseconds behavior improvement.

Note 2:
I'm a bit unsure about the restart code and how that works; I'd like to
request a bit of help on figuring out how that code is supposed to work.

Future work:
I'd like to get rid of the jiffies timeout entirely over time, and
only use hrtimers (makes the code a lot nicer) but that's for now
a separate step, first I'd like to see how this change pans out.


 
