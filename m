Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXCEKCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXCEKCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCEKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:02:17 -0500
Received: from mail.queued.net ([207.210.101.209]:1045 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbXCEKCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:02:16 -0500
Message-ID: <45EBEA9F.9070109@debian.org>
Date: Mon, 05 Mar 2007 05:02:07 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] highres: warn on softirq handling an unsafe callback
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------010503070102030508010304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010503070102030508010304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

run_hrtimer_queue is called from a softirq context, and should never run
a callback that is classified as HRTIMER_CB_IRQSAFE_NO_SOFTIRQ.  A bug
in unrelated code had managed to trigger that bug, so let's add an
explicit warning to this function.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------010503070102030508010304
Content-Type: text/x-patch;
 name="hrtimer5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer5.patch"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 476cb0c..167c296 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1130,6 +1130,7 @@ static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+		WARN_ON_ONCE(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;

--------------010503070102030508010304--
