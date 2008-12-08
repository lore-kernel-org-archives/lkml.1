Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYLHQN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYLHQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLHQNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:13:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:58719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYLHQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:13:16 -0500
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, oliver@hartkopp.net
In-Reply-To: <1228385830.5092.43.camel@twins>
References: <1227613431.4259.1537.camel@twins>
	 <1228385830.5092.43.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Dec 2008 17:13:02 +0100
Message-Id: <1228752782.6939.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 11:17 +0100, Peter Zijlstra wrote:
> On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
> > Hi,
> > 
> > This is an attempt at removing some of the hrtimer complexity by
> > reducing the number of callback modes to 1.
> > 
> > This means that all hrtimer callback functions will be ran from HARD-irq
> > context.
> > 
> > I went through all the 30 odd hrtimer callback functions in the kernel
> > and saw only one that I'm not quite sure of, which is the one in
> > net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
> > 
> > Furthermore, the hrtimer core now calls callbacks directly with IRQs
> > disabled in case you try to enqueue an expired timer. If this timer is a
> > periodic timer (which should use hrtimer_forward() to advance its time)
> > then it might be possible to end up in an inf. recursive loop due to the
> > fact that hrtimer_forward() doesn't round up to the next timer
> > granularity, and therefore keeps on calling the callback - obviously
> > this needs a fix.
> > 
> > Aside from that, this seems to compile and actually boot on my dual core
> > test box - although I'm sure there are some bugs in, me not hitting any
> > makes me certain :-)
> > 
> > Not-Quite-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ingo, this addition fixes the hotplug issue on my machine

And because we're all human...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b09c7a2..e14af46 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1571,7 +1571,7 @@ static void tickle_timers(void *arg)
 static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
-	int dcpu = -1, scpu = (long)hcpu;
+	int dcpu, scpu = (long)hcpu;
 
 	switch (action) {
 
@@ -1585,9 +1585,6 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD_FROZEN:
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		dcpu = migrate_hrtimers(scpu);
-		break;
-
-	case CPU_POST_DEAD:
 		if (dcpu == -1)
 			break;
 

