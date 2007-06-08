Return-Path: <linux-kernel-owner+w=401wt.eu-S939047AbXFHHne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939047AbXFHHne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967801AbXFHHYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55205 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938332AbXFHHYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:31 -0400
Message-Id: <20070608072153.471136000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       davem@davemloft.net, kernel@prachanda.info, tglx@linutronix.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/54] Prevent going idle with softirq pending
Content-Disposition: inline; filename=prevent-going-idle-with-softirq-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

 
The NOHZ patch contains a check for softirqs pending when a CPU goes 
idle. The BUG is unrelated to NOHZ, it just was made visible by the NOHZ 
patch. The BUG showed up mainly on P4 / hyperthreading enabled machines 
which lead the investigations into the wrong direction in the first 
place.  The real cause is in cond_resched_softirq():
 
cond_resched_softirq() is enabling softirqs without invoking the softirq 
daemon when softirqs are pending.  This leads to the warning message in 
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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anant Nitya <kernel@prachanda.info>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.21.4.orig/kernel/sched.c
+++ linux-2.6.21.4/kernel/sched.c
@@ -4545,9 +4545,7 @@ int __sched cond_resched_softirq(void)
 	BUG_ON(!in_softirq());
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
-		raw_local_irq_disable();
-		_local_bh_enable();
-		raw_local_irq_enable();
+		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
 		return 1;

-- 
