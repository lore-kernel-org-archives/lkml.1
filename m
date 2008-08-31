Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHaQb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHaQb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYHaQbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:36208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYHaQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:15 -0400
Date: Sun, 31 Aug 2008 09:28:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@tglx.de, mingo@elte.hu, torvalds@linux-foundation.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [patch v2   0/5] Nano/Microsecond resolution for select() and
 poll()
Message-ID: <20080831092828.13ae0279@infradead.org>
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


New in this version:
* With lots of help from Thomas Gleixner, select() and poll() now
  exclusively use hrtimers
* Several key cleanups from Thomas actually simplify and clean the
  code up so that it's an overall improvement in code quality
* Various interesting bugs were encountered during the switchover on this
  level. The Fedora/Red Hat "nash" program deserves a special mention for
  both asking for a 1 nanosecond ppoll() timeout AND depending on the
  implementation to set this to 0 nanoseconds in userspace memory at
  the end of the first iteration.


 fs/compat.c                 |  187 +++++++++--------------
 fs/select.c                 |  346 +++++++++++++++++++++-----------------------
 include/linux/hrtimer.h     |    2 
 include/linux/poll.h        |    8 -
 include/linux/thread_info.h |    8 +
 include/linux/time.h        |    4 
 kernel/hrtimer.c            |   65 ++++++++
 kernel/time.c               |   18 ++
 8 files changed, 344 insertions(+), 294 deletions(-)

(the bulk of actual linecount growth is just newly added comments)
----

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

[actual behavior obviously on what resolution the hardware timers work, on
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

Note: 
even though poll() (as opposed to ppoll()) only accepts milliseconds
as userspace interface, the behavior will still improve because the current
time no longer needs to be rounded up to the next jiffie, so on average
a 500 microseconds behavior improvement.

