Return-Path: <linux-kernel-owner+w=401wt.eu-S1161062AbXCNUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbXCNUuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:50:39 -0400
Received: from www.osadl.org ([213.239.205.134]:39844 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161062AbXCNUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:50:39 -0400
Subject: [PATCH] hrtimer: Fixup unlocked access to wall_to_monotonic
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 21:57:20 +0100
Message-Id: <1173905840.13341.192.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit f4304ab21513b834c8fe3403927c60c2b81a72d7 (HZ free NTP) moved the
access to wall_to_monotonic in hrtimer_get_softirq_time() out of the
xtime_lock protection.

Move it back into the seq_lock section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ec4cb9f..e2053da 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, tomono;
-	struct timespec xts;
+	struct timespec xts, tom;
 	unsigned long seq;
 
 	do {
@@ -145,10 +145,11 @@ #ifdef CONFIG_NO_HZ
 #else
 		xts = xtime;
 #endif
+		tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
-	tomono = timespec_to_ktime(wall_to_monotonic);
+	tomono = timespec_to_ktime(tom);
 	base->clock_base[CLOCK_REALTIME].softirq_time = xtim;
 	base->clock_base[CLOCK_MONOTONIC].softirq_time =
 		ktime_add(xtim, tomono);


