Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXELLlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXELLlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXELLlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:41:11 -0400
Received: from www.osadl.org ([213.239.205.134]:48262 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755828AbXELLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:41:09 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070512030754.90488f79.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1178961489.22481.133.camel@localhost.localdomain>
	 <20070512030754.90488f79.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 May 2007 13:44:13 +0200
Message-Id: <1178970253.22481.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 03:07 -0700, Andrew Morton wrote:
> On Sat, 12 May 2007 11:18:09 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > It's peculiar that the hang happens when acpi_evaluate_object() hits its
> > > return statement.  Any theories there?
> > 
> > Only stack or memory corruption come into mind, but I have no clue how
> > this is related to the resume logic changes.
> 
> So I had the brilliant idea of turning on some kernel debugging.  It's
> a shame that CONFIG_SOFTWARE_SUSPEND disables CONFIG_DEBUG_PAGEALLOC.

Really brilliant. I tried to reproduce your problem and stumbled across
something else.

	tglx

------------------------------->
Subject: clocksource fix lock order in the resume path

lockdep complains about the lock nesting of clocksource and watchdog
lock in the resume path. Move watchdog resume out of the clocksource
lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.21/kernel/time/clocksource.c
===================================================================
--- linux-2.6.21.orig/kernel/time/clocksource.c
+++ linux-2.6.21/kernel/time/clocksource.c
@@ -151,9 +151,11 @@ static void clocksource_watchdog(unsigne
 }
 static void clocksource_resume_watchdog(void)
 {
-	spin_lock(&watchdog_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
 	watchdog_resumed = 1;
-	spin_unlock(&watchdog_lock);
+	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_check_watchdog(struct clocksource *cs)
@@ -224,9 +226,9 @@ void clocksource_resume(void)
 			cs->resume();
 	}
 
-	clocksource_resume_watchdog();
-
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	clocksource_resume_watchdog();
 }
 
 /**


