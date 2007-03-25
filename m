Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXCYMfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXCYMfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXCYMfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:35:22 -0400
Received: from www.osadl.org ([213.239.205.134]:57542 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501AbXCYMfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:35:21 -0400
Subject: [PATCH] clocksource: Fix thinko in watchdog selection
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David L <idht4n@hotmail.com>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <1174692936.10840.392.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174677338.10840.321.camel@localhost.localdomain>
	 <46045355.1020105@redhat.com>
	 <1174689791.10840.377.camel@localhost.localdomain>
	 <1174692936.10840.392.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 14:42:51 +0200
Message-Id: <1174826571.10840.512.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog implementation excludes low res / non continuous
clocksources from being selected as a watchdog reference
unintentionally.

Allow using jiffies/PIT as a watchdog reference as long as no better
clocksource is available. This is necessary to detect TSC breakage on
systems, which have no pmtimer/hpet.

The main goal of the initial patch (preventing to switch to highres/nohz
when no reliable fallback clocksource is available) is still guaranteed
by the checks in clocksource_watchdog().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5b0e46b..fe5c7db 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -151,7 +151,8 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer(&watchdog_timer);
 		}
-	} else if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
+	} else {
+		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 
 		if (!watchdog || cs->rating > watchdog->rating) {


