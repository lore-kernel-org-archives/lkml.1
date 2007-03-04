Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXCDNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXCDNMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXCDNMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:12:19 -0500
Received: from mail.queued.net ([207.210.101.209]:4111 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXCDNMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:12:19 -0500
Message-ID: <45EAC5B1.2060306@debian.org>
Date: Sun, 04 Mar 2007 08:12:17 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching
 to	highres mode
References: <45E8E2F8.1030102@debian.org>	 <1172912540.24738.108.camel@localhost.localdomain>	 <45EAAA21.4040803@debian.org> <1173013794.24738.130.camel@localhost.localdomain>
In-Reply-To: <1173013794.24738.130.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060204000604000405020800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060204000604000405020800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas Gleixner wrote:
>>> The question is, how the tick timer gets enqueued in the softirq queue.
>>> Can you isolate the codepath, where this happens ?
> 
> The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
> clocksource and clock event sources are registered. The switch to high
> resolution mode happens inside of the TIMER_SOFTIRQ, but runs the
> softirq afterwards. That way the tick emulation timer, which was set up
> in the switch to highres might be executed in the softirq context, which
> is a BUG. The rbtree has not to be touched by the softirq after the
> highres switch.
> 

And an additional request, just to make it explicit that we should not
have any NO_SOFTIRQ callbacks in the tree; BUG out if we encounter such
a thing.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------060204000604000405020800
Content-Type: text/x-patch;
 name="hrtimer4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer4.patch"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 476cb0c..4dcdd09 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1130,6 +1130,7 @@ static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+		BUG_ON(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;

--------------060204000604000405020800--
