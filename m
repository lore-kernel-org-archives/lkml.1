Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYLKQFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYLKQFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYLKQFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:05:44 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:61886 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbYLKQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:05:43 -0500
Date: Thu, 11 Dec 2008 17:04:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] nohz: no softirq pending warnings for offline cpus
Message-ID: <20081211160411.GC6264@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

After a cpu was taken down during cpu hotplug (read: disabled for interrupts)
it still might have pending softirqs. However take_cpu_down makes sure
that the idle task will run next instead of ksoftirqd on the taken down cpu.
The idle task will call tick_nohz_stop_sched_tick which might warn about
pending softirqs just before the cpu kills itself completely.
However the pending softirqs on the dead cpu aren't a problem because they
will be moved to an online cpu during CPU_DEAD handling.

So make sure we warn only for online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -247,7 +247,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (need_resched())
 		goto end;
 
-	if (unlikely(local_softirq_pending())) {
+	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
 		if (ratelimit < 10) {
