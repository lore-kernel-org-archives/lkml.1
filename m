Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXDBHWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXDBHWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXDBHWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:22:23 -0400
Received: from www.osadl.org ([213.239.205.134]:37977 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbXDBHWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:22:22 -0400
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
	 <1175418341.28263.64.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 09:22:28 +0200
Message-Id: <1175498549.28263.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 10:00 -0700, Davide Libenzi wrote:
> > For periodic timers we probably want to know also about missed ticks,
> > i.e. when the timer was delayed.
> > 
> > I changed recently the rearm handling code of itimers to prevent DoS
> > attacks. See commit 8bfd9a7a229b5f3d3eda5d7d45c2eebec5b4ba16. The posix
> > timer code has a similar mechanism.
> > 
> > Probably we should do the same here. That means that we defer the
> > restart of the timer to the process context.
> 
> But timerfd has that implicit, in the ticks counter. So if you get ticks > 1
> it means you did not read-out (miss) one or more.
> By re-arming the timer whenever you read it, that may be some time after 
> it expired. IMO the behaviour is better as it is now, and if you want the 
> new timer sequence start at a new timeframe, you just use timerfd with the 
> same fd.
> I do not know about DoS on timers (did not follow the thread), but I could 
> easily implement it here, by capping the counter to some value, and return 
> POLLERR in poll().
> I'd prefer that instead of the re-arm on read thing.

The DoS is simple: create a bunch of periodic timers with 10usec period.
This can be done by any user.

There is no inaccuracy when you rearm the timer on read: hrtimer_forward
takes care, that the period is accurate. It does not start the timer out
of the periodic order, i.e. on a different time frame.

Where is the win of keeping the timer running, when nobody cares about
the expiry at all ? It just generates interrupts and events for nothing.

	tglx




