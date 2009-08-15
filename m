Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZHOKIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZHOKIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZHOKIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:08:54 -0400
Received: from www.tglx.de ([62.245.132.106]:57861 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZHOKIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:08:54 -0400
Date: Sat, 15 Aug 2009 12:08:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
In-Reply-To: <20090815095221.GA15831@elte.hu>
Message-ID: <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com> <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Ingo Molnar wrote:
> Yeah, nice cleanups!
> 
> I gave it some brief testing in tip:master and there's the new 
> lockdep assert below. Config and full bootlog attached.

Yeah, we need to call clocksource_change_rating() outside of watchdog
lock. Spotted a missing _irqrestore as well.

Thanks,

	tglx
---

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index a1657b5..02dc22d 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -307,16 +307,23 @@ static void clocksource_watchdog_work(struct work_struct *work)
 {
 	struct clocksource *cs, *tmp;
 	unsigned long flags;
+	LIST_HEAD(unstable);
 
 	spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
 			list_del_init(&cs->wd_list);
-			clocksource_change_rating(cs, 0);
+			list_add(&cs->wd_list, &unstable);
 		}
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
-	spin_unlock(&watchdog_lock);
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+
+	/* Needs to be done outside of watchdog lock */
+	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
+		list_del_init(&cs->wd_list);
+		clocksource_change_rating(cs, 0);
+	}
 }
 
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
