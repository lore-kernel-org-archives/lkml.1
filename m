Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXEUVef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXEUVef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXEUVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:34:27 -0400
Received: from www.osadl.org ([213.239.205.134]:45331 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755162AbXEUVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:34:26 -0400
Subject: [PATCH] Prevent going idle with softirq pending
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>,
       Stable Team <stable@kernel.org>, Anant Nitya <kernel@prachanda.info>
Content-Type: text/plain
Date: Mon, 21 May 2007 23:34:24 +0200
Message-Id: <1179783264.12708.70.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The NOHZ patch contains a check for softirqs pending when a CPU goes
idle. The BUG is unrelated to NOHZ, it just was made visible by the NOHZ
patch. The BUG showed up mainly on P4 / hyperthreading enabled machines
which lead the investigations into the wrong direction in the first
place. The real cause is in cond_resched_softirq():

cond_resched_softirq() is enabling softirqs without invoking the softirq
daemon when softirqs are pending. This leads to the warning message in
the NOHZ idle code:

t1 runs softirq disabled code on CPU#0
interrupt happens, softirq is raised, but deferred (softirqs disabled)
t1 calls cond_resched_softirq()
	enables softirqs via _local_bh_enable()
	calls schedule()
t2 runs
t1 is migrated to CPU#1
t2 is done and invokes idle()
NOHZ detects the pending softirq

Fix: change _local_bh_enable() to local_bh_enable() so the softirq
daemon is invoked.

Thanks to Anant Nitya for debugging this with great patience !

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4776,7 +4776,7 @@ int __sched cond_resched_softirq(void)
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		raw_local_irq_disable();
-		_local_bh_enable();
+		local_bh_enable();
 		raw_local_irq_enable();
 		__cond_resched();
 		local_bh_disable();


