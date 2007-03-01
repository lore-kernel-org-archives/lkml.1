Return-Path: <linux-kernel-owner+w=401wt.eu-S1161104AbXCAWwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161104AbXCAWwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161116AbXCAWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:52:37 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:42168 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161102AbXCAWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:52:09 -0500
Message-ID: <45E75911.3070907@simon.arlott.org.uk>
Date: Thu, 01 Mar 2007 22:52:01 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: akpm@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH (updated)] timer: Run calc_load halfway through each round_jiffies
 second
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk>
In-Reply-To: <45E720E8.1010809@simon.arlott.org.uk>
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
Without this change or an appropriate equivalent, my change to cxacru 
causes the load to stay around 1.00 even when mostly idle since it now 
runs every second using round_jiffies:
> [  332.416288] cxacru_poll_status(..), jiffies=5000 [start]
> [  332.417312] calc_load(1), count=-1, jiffies=5001 [start]
> [  332.417322] calc_load(1), count=4999, jiffies=5001 [finish]
> [  332.423382] cxacru_poll_status(..), jiffies=5007, next=993 [finish]

 kernel/timer.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index cb1b86a..ee61f6c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1225,17 +1225,19 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	static int count = LOAD_FREQ + HZ/2;
 
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
