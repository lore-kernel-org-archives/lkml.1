Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbXEXWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbXEXWGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbXEXWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:06:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56740
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXEXWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:06:37 -0400
Date: Thu, 24 May 2007 15:06:40 -0700 (PDT)
Message-Id: <20070524.150640.31659488.davem@davemloft.net>
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: [BUG]: hrtimer overflow bug on 64-bit systems
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've been tracing this problem on sparc64 now that it uses hi-res
timers, and I finally figured it out.

The symptom is that ksoftirqd on most of the cpus of an idle SMP
system chew up around %10 of cpu time.

The raise_softirq_irqoff() is constantly being invoked via
tick_nohz_stop_sched_tick(), but why?

Tracing revealed that delta_ticks is enormous, which is correct
because no timers are pending on the cpu so we should schedule the
hrtimer as far into the future as possible.

tick_nohz_stop_sched_tick() then proceeds to start the hrtimer, and
then it checks hrtimer_active() but for some reason this is always
false.

Why?

The reason is that the expires calculation here:

		expires = ktime_add_ns(last_update, tick_period.tv64 *
				       delta_jiffies);

overflows on 64-bit systems.

On 32-bit systems, LONG_MAX is a 32-bit quantity so the largest
possible delta_jiffies don't cause an overflow in this multiply
(which is 64-bit).  (LONG_MAX determines how large a value
will be returned to indicate "infinity" from get_next_timer_interrupt(),
specifically it's the initialization of local variable 'expires'
in __next_timer_interrupt).

Because of this 'expires' is zero and of course that causes the
hrtimer to not get scheduled at all.

I'm surprised this problem is not seen with the x86_64 hrtimer patches
applied :-)

I'm not exactly sure how to best fix this, we could either make
__next_timer_interrupt use INT_MAX or we could make
tick_nohz_stop_sched_tick() realize and handle the overflow
properly.  Neither of those solutions are fully satisfactory in
my opinion :-)

FWIW, I've verified that using INT_MAX in __next_timer_interrupt()
makes the problem go away.

