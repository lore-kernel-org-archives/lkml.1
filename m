Return-Path: <linux-kernel-owner+w=401wt.eu-S965375AbXCBPP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbXCBPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965366AbXCBPP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:15:26 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:38450 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375AbXCBPPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:15:25 -0500
Message-ID: <45E83F7A.9030307@simon.arlott.org.uk>
Date: Fri, 02 Mar 2007 15:15:06 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@linux.intel.com
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each
 round_jiffies second
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk> <45E75911.3070907@simon.arlott.org.uk> <20070301231003.GD10643@holomorphy.com> <45E7F92E.7090407@simon.arlott.org.uk>
In-Reply-To: <45E7F92E.7090407@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever jiffies is started at a multiple of 5*HZ or wraps, calc_load is 
run exactly on the second which is when tasks using round_jiffies will 
be scheduled to run. This has a bad effect on the load average, making 
it tend towards 1.00 if a task happens to run every time the load is 
being calculated.

This changes calc_load so that it updates load half a second after any 
tasks scheduled using round_jiffies.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
This version starts count off at 0, since LOAD_FREQ + HZ/2 is no better 
than LOAD_FREQ. The previous version is actually wrong, rounding count to 
a negative value will only happen when getting calc_load running at the
right time related to jiffies, it won't be negative running normally - 
even with NO_HZ.

 kernel/timer.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6663a87..4abead0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1226,17 +1226,19 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	static int count = 0;
 
 	count -= ticks;
-	if (unlikely(count < 0)) {
+	if (unlikely(count <= 0)) {
 		active_tasks = count_active_tasks();
 		do {
 			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
 			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
 			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
 			count += LOAD_FREQ;
-		} while (count < 0);
+		} while (count <= 0);
+
+		count = round_jiffies_relative(count + HZ/2) - HZ/2;
 	}
 }
 
-- 
1.5.0.1


-- 
Simon Arlott
