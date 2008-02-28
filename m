Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbYB1OLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbYB1OLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYB1OLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:11:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:2486 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYB1OLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=CNSQjDK7GbIeQOew7HjcmPNEVhsol5DGVz6t0lfPSOyXZI8XPwFdAB/EOmgmcgzwF59DjTNJRCrgXDlpGmIAWAzs/BC9OdWIrU7bwMDgPBp3zEFRcAbVzFOGwxqAwtv6C5z6AxjrBhD00S/Bt8hFgjzr90CKA9R8EtbYGJ8YD0U=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Optimise tick_nohz_stop_sched_tick() a bit
Date: Thu, 28 Feb 2008 15:10:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281510.51191.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Call
	ts = &per_cpu(tick_cpu_sched, cpu);
and
	cpu = smp_processor_id();
once instead of twice.

No functional change done, as changed code runs with local irq off.
Reduces source lines and text size (20bytes on x86_64).

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 kernel/time/tick-sched.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 686da82..851a852 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -158,9 +158,8 @@ void tick_nohz_stop_idle(int cpu)
 	}
 }
 
-static ktime_t tick_nohz_start_idle(int cpu)
+static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, delta;
 
 	now = ktime_get();
@@ -201,8 +200,8 @@ void tick_nohz_stop_sched_tick(void)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	now = tick_nohz_start_idle(cpu);
 	ts = &per_cpu(tick_cpu_sched, cpu);
+	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -222,7 +221,6 @@ void tick_nohz_stop_sched_tick(void)
 	if (need_resched())
 		goto end;
 
-	cpu = smp_processor_id();
 	if (unlikely(local_softirq_pending())) {
 		static int ratelimit;
 
-- 
1.5.3.3
