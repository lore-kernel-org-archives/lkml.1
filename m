Return-Path: <linux-kernel-owner+w=401wt.eu-S1750756AbXBZXc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756AbXBZXc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXBZXc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:32:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58127
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXBZXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:32:58 -0500
Date: Mon, 26 Feb 2007 15:32:57 -0800 (PST)
Message-Id: <20070226.153257.71091651.davem@davemloft.net>
To: tglx@linutronix.de
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: Re: [PATCH]: tick-sched.c build fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070226.112239.112290727.davem@davemloft.net>
References: <20070224.214201.126577744.davem@davemloft.net>
	<1172394281.25076.361.camel@localhost.localdomain>
	<20070226.112239.112290727.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 26 Feb 2007 11:22:39 -0800 (PST)

> With this, nobody will get bit by problems again.  We should
> provide something similar, if not identical, for clocksources
> too.  Perhaps we could even start trying at initial shift values
> larger than 32.
> 
> What do you think?

Just for completeness, here is the suggested set of interfaces
as a patch.

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 4ea7e7b..b35c06f 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -115,6 +115,8 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 /* Clock event layer functions */
 extern unsigned long clockevent_delta2ns(unsigned long latch,
 					 struct clock_event_device *evt);
+extern void clockevent_set_multshift(struct clock_event_device *edev,
+				     unsigned long hz);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index daa4940..cd0ed26 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -120,7 +120,7 @@ static inline u32 clocksource_khz2mult(u32 khz, u32 shift_constant)
  * frequency to a timsource multiplier, given the
  * clocksource shift value
  */
-static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
+static inline u64 clocksource_hz2mult(u32 hz, u32 shift_constant)
 {
 	/*  hz = cyc/(Billion ns)
 	 *  mult/2^shift  = ns/cyc
@@ -134,7 +134,7 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 	tmp += hz/2; /* round for do_div */
 	do_div(tmp, hz);
 
-	return (u32)tmp;
+	return tmp;
 }
 
 /**
@@ -194,6 +194,8 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 }
 
 
+extern void clocksource_set_multshift(struct clocksource *cs, unsigned long hz);
+
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern struct clocksource* clocksource_get_next(void);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 67932ea..9fd5aa3 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -50,6 +50,23 @@ unsigned long clockevent_delta2ns(unsigned long latch,
 	return (unsigned long) clc;
 }
 
+void clockevent_set_multshift(struct clock_event_device *edev, unsigned long hz)
+{
+	u64 mult;
+	int shift = 32;
+
+	while (1) {
+		mult = div_sc(hz, NSEC_PER_SEC, shift);
+		if (mult && (mult >> 32UL) == 0UL)
+			break;
+
+		shift--;
+	}
+
+	edev->shift = shift;
+	edev->mult = (u32) mult;
+}
+
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
  * @dev:	device to modify
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 193a079..1802dc8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -181,6 +181,23 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 }
 #endif
 
+void clocksource_set_multshift(struct clocksource *cs, unsigned long hz)
+{
+	u64 mult;
+	int shift = 16;
+
+	while (1) {
+		mult = clocksource_hz2mult(hz, shift);
+		if (mult && (mult >> 32UL) == 0UL)
+			break;
+
+		shift--;
+	}
+
+	cs->shift = shift;
+	cs->mult = (u32) mult;
+}
+
 /**
  * clocksource_get_next - Returns the selected clocksource
  *
