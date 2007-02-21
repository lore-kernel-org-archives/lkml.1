Return-Path: <linux-kernel-owner+w=401wt.eu-S1161318AbXBUTzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161318AbXBUTzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXBUTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:55:40 -0500
Received: from www.osadl.org ([213.239.205.134]:38399 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161318AbXBUTzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:55:39 -0500
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 21:00:44 +0100
Message-Id: <1172088044.25076.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Wed, 2007-02-21 at 16:38 +0100, Michal Piotrowski wrote:
> > But you still have those softirq pending messages, right ?
> 
> Yes
> 
> (+ new NOHZ: local_softirq_pending 02)

Yike, that's the timer softirq.

Can you add the patch below, maybe it gives us some useful info. Please
enable lockdep (your last config had it already)

Thanks,

	tglx

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 512a4a9..cc705c7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -165,9 +165,11 @@ void tick_nohz_stop_sched_tick(void)
 		goto end;
 
 	cpu = smp_processor_id();
-	if (unlikely(local_softirq_pending()))
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       local_softirq_pending());
+	if (unlikely(local_softirq_pending())) {
+		print_irqtrace_events(current);
+		printk(KERN_ERR "NOHZ: local_softirq_pending %02x, %08x\n",
+		       local_softirq_pending(), preempt_count());
+	}
 
 	now = ktime_get();
 	/*


