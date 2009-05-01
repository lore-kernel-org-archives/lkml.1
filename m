Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZEAFso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZEAFso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZEAFse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:48:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:49939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZEAFsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=lgCMIskwFEDkz24qvYSTP9WXy2smwmTkXfauR3GF8eyv0NueR0BI9rP3pCFsfqPs9r
         ild5/NIjaD48cZh0B9ak4B8UlWtt1t7iait5UdZp/mHr7LCID/agp4IvDvdPA7YmpZCi
         e/My3egYPA3JeuTawyJnc8eGMAIYb7UNjGyp4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 01 May 2009 14:45:46 +0900
Message-Id: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
Subject: [PATCH] clocksource: setup mult_orig in clocksource_enable()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Setup clocksource mult_orig in clocksource_enable().

Clocksource drivers can save power by using keeping the
device clock disabled while the clocksource is unused.

In practice this means that the enable() and disable()
callbacks perform clk_enable() and clk_disable().

The enable() callback may also use clk_get_rate() to get
the clock rate from the clock framework. This information
can then be used to calculate the shift and mult variables.

Currently the mult_orig variable is setup from mult at
registration time only. This is conflicting with the above
case since the clock is disabled and the mult variable is
not yet calculated at the time of registration.

Moving the mult_orig setup code to clocksource_enable()
allows us to both handle the common case with no enable()
callback and the mult-changed-after-enable() case.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/clocksource.h |   10 +++++++++-
 kernel/time/clocksource.c   |    3 ---
 2 files changed, 9 insertions(+), 4 deletions(-)

--- 0001/include/linux/clocksource.h
+++ work/include/linux/clocksource.h	2009-05-01 12:59:27.000000000 +0900
@@ -288,7 +288,15 @@ static inline cycle_t clocksource_read(s
  */
 static inline int clocksource_enable(struct clocksource *cs)
 {
-	return cs->enable ? cs->enable(cs) : 0;
+	int ret = 0;
+
+	if (cs->enable)
+		ret = cs->enable(cs);
+
+	/* save mult_orig on enable */
+	cs->mult_orig = cs->mult;
+
+	return ret;
 }
 
 /**
--- 0001/kernel/time/clocksource.c
+++ work/kernel/time/clocksource.c	2009-05-01 12:59:40.000000000 +0900
@@ -402,9 +402,6 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 	int ret;
 
-	/* save mult_orig on registration */
-	c->mult_orig = c->mult;
-
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
