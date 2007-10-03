Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXJCSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXJCSDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXJCSDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:03:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbXJCSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:03:34 -0400
Date: Wed, 3 Oct 2007 11:02:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
In-Reply-To: <4703D212.6040304@redhat.com>
Message-ID: <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
 <20071002150748.906970bc.akpm@linux-foundation.org> <4702C756.8090108@redhat.com>
 <20071002162613.54c3ef43@laptopd505.fenrus.org>
 <4703D212.6040304@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Chuck Ebbert wrote:
> 
> But we reduce the number of samples because some ticks just never
> happen when the timers get rounded:
> 
> No rounding:
> 
>       tick ............... tick
>      1 running            1 running
> 
> Rounded:
> 
>       tick
>      2 running
> 
> In the first case the average is 1, but it's 2 in the second.

In fact, I think this is it!

The load average is not calculated every tick, because that's not just 
expensive, but we also want to have some time-based decay. So it's 
calculated every LOAD_FREQ ticks.

And guess what: LOAD_FREQ is defined to be exactly five seconds.

So imagine if the timer gets to be in sync with another event that happens 
every five seconds - let's pick at random a 5-second JBD transaction 
thing?

Anders - does this idiotic patch make a difference for you?

Without this, I can easily imagine that the rounding code tends to try to 
round to an even second, and the load-average code generally also runs at 
even seconds!

		Linus

---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a01ac6d..643de0f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -113,7 +113,7 @@ extern unsigned long avenrun[];		/* Load averages */
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
-#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
+#define LOAD_FREQ	(5*HZ+1)	/* ~5 sec intervals */
 #define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
 #define EXP_5		2014		/* 1/exp(5sec/5min) */
 #define EXP_15		2037		/* 1/exp(5sec/15min) */
