Return-Path: <linux-kernel-owner+w=401wt.eu-S965503AbXCASwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503AbXCASwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965504AbXCASwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:52:33 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:47850 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965503AbXCASwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:52:33 -0500
Message-ID: <45E720E8.1010809@simon.arlott.org.uk>
Date: Thu, 01 Mar 2007 18:52:24 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: akpm@linux-foundation.org, arjan@linux.intel.com
Subject: [PATCH] timer: Add an initial 0.5s delay to calc_load
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk>
In-Reply-To: <45E698DF.4010006@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an initial 0.5s delay to calc_load so that it avoids updating 
load at the same time as tasks scheduled using round_jiffies, otherwise 
the load average is badly affected by tasks that run every time calc_load 
does (currently every 5s).

I'm assuming this change doesn't affect the intention of round_jiffies, 
to avoid tasks waking the cpu at different times, because calc_load is 
already run very often by a call from update_times(ticks) on every timer 
interrupt.

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

 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index cb1b86a..4bb21b5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1225,7 +1225,7 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	static int count = LOAD_FREQ + HZ/2;
 
 	count -= ticks;
 	if (unlikely(count < 0)) {
-- 
1.5.0.1


-- 
Simon Arlott
