Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbXINMvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbXINMvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761698AbXINMvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:51:01 -0400
Received: from www.osadl.org ([213.239.205.134]:48325 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761672AbXINMvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:51:00 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070914123816.GE1671@elf.ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
	 <1189713695.3974.23.camel@chaos>  <20070914123816.GE1671@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 14:50:57 +0200
Message-Id: <1189774257.3100.7.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Fri, 2007-09-14 at 14:38 +0200, Pavel Machek wrote:
> > I have an yet untested fix, which preserves the broadcast state across
> > the offline state, but Len is looking into it as well, whether we can
> > just reevaluate the power states (and the broadcast flags) when a cpu
> > becomes online again. If Len can do that easily for 2.6.23, I'd prefer
> > that.
> 
> Is there a patch you want me to test? Or does Len have anything to
> play with?

Venki sent me an initial patch, but it has issues with the notify
ordering. Find below my "cache the broadcast flags" version for testing.

Thanks,

	tglx

---
 kernel/time/tick-broadcast.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c	2007-09-14 13:22:29.000000000 +0200
+++ linux-2.6/kernel/time/tick-broadcast.c	2007-09-14 13:22:29.000000000 +0200
@@ -261,10 +261,25 @@ void tick_broadcast_on_off(unsigned long
 	int cpu = get_cpu();
 
 	if (!cpu_isset(*oncpu, cpu_online_map)) {
-		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
-		       "offline CPU #%d\n", *oncpu);
-	} else {
+		unsigned long flags;
+
+		spin_lock_irqsave(&tick_broadcast_lock, flags);
+		/*
+		 * We need to cache the broadcast flag for offline
+		 * CPUs. ACPI currently does not reevaluate the
+		 * broadcast flag when a CPU goes online again. Adding
+		 * a cpu notifier to ACPI is probably the correct
+		 * solution, but it is hard to get this correct due to
+		 * notify ordering problems. So caching the flag is
+		 * the safe solution for now.
+		 */
+		if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ON)
+			cpu_set(*oncpu, tick_broadcast_mask);
+		else
+			cpu_clear(*oncpu, tick_broadcast_mask);
 
+		spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	} else {
 		if (cpu == *oncpu)
 			tick_do_broadcast_on_off(&reason);
 		else


