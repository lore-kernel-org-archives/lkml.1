Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYLTU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYLTU3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYLTU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:29:31 -0500
Received: from www.tglx.de ([62.245.132.106]:42460 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYLTU3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:29:31 -0500
Date: Sat, 20 Dec 2008 21:27:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Sesterhenn <snakebyte@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
In-Reply-To: <20081219172549.GA25722@alice>
Message-ID: <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain>
References: <20081219172549.GA25722@alice>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Prevent kernel crash with posix timer clockid CLOCK_MONOTONIC_RAW

commit 2d42244ae71d6c7b0884b5664cf2eda30fb2ae68 (clocksource:
introduce CLOCK_MONOTONIC_RAW) introduced a new clockid, which is only
available to read out the raw not NTP adjusted system time.

The above commit did not prevent that a posix timer can be created
with that clockid. The timer_create() syscall succeeds and initializes
the timer to a non existing hrtimer base. When the timer is deleted
either by timer_delete() or by the exit() cleanup the kernel crashes.

Prevent the creation of timers for CLOCK_MONOTONIC_RAW by setting the
posix clock function to no_timer_create which returns an error code.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 5e79c66..a140e44 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -197,6 +197,11 @@ static int common_timer_create(struct k_itimer *new_timer)
 	return 0;
 }
 
+static int no_timer_create(struct k_itimer *new_timer)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -248,6 +253,7 @@ static __init int init_posix_timers(void)
 		.clock_getres = hrtimer_get_res,
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
+		.timer_create = no_timer_create,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
