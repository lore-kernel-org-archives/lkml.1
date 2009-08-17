Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZHQIpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZHQIpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbZHQIpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:45:21 -0400
Received: from www.tglx.de ([62.245.132.106]:32834 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbZHQIpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:45:21 -0400
Date: Mon, 17 Aug 2009 10:45:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
In-Reply-To: <20090817094042.03fe5d38@skybase>
Message-ID: <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com> <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu> <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain>
 <20090817094042.03fe5d38@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Martin Schwidefsky wrote:
> > -	spin_unlock(&watchdog_lock);
> > +	spin_unlock_irqrestore(&watchdog_lock, flags);
> > +
> > +	/* Needs to be done outside of watchdog lock */
> > +	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
> > +		list_del_init(&cs->wd_list);
> > +		clocksource_change_rating(cs, 0);
> > +	}
> >  }
> > 
> >  #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
> 
> Autsch, the s/spin_unlock/spin_unlock_irqrestore/ is rather obvious, no?

:)

> In theory we now have a reference count problem. The call to 
> clocksource_change_rating are no done outside of the clocksource mutex
> and outside of the watchdog lock. A concurrent clocksource_unregister
> could remove the clock.

Darn, yes. But it's not hard to fix.

Thanks,

	tglx
---
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02dc22d..c6bff11 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -131,6 +131,7 @@ static cycle_t watchdog_last;
 static int watchdog_running;
 
 static void clocksource_watchdog_work(struct work_struct *work);
+static void __clocksource_change_rating(struct clocksource *cs, int rating);
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -309,6 +310,7 @@ static void clocksource_watchdog_work(struct work_struct *work)
 	unsigned long flags;
 	LIST_HEAD(unstable);
 
+	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
@@ -322,8 +324,9 @@ static void clocksource_watchdog_work(struct work_struct *work)
 	/* Needs to be done outside of watchdog lock */
 	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
 		list_del_init(&cs->wd_list);
-		clocksource_change_rating(cs, 0);
+		__clocksource_change_rating(cs, 0);
 	}
+	mutex_unlock(&clocksource_mutex);
 }
 
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
@@ -470,16 +473,21 @@ int clocksource_register(struct clocksource *cs)
 }
 EXPORT_SYMBOL(clocksource_register);
 
+static void __clocksource_change_rating(struct clocksource *cs, int rating)
+{
+	list_del(&cs->list);
+	cs->rating = rating;
+	clocksource_enqueue(cs);
+	clocksource_select();
+}
+
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	mutex_lock(&clocksource_mutex);
-	list_del(&cs->list);
-	cs->rating = rating;
-	clocksource_enqueue(cs);
-	clocksource_select();
+	__clocksource_change_rating(cs, rating);
 	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
