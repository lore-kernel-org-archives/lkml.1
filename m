Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYCXMjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYCXMjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYCXMjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:39:23 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:55074 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbYCXMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:39:22 -0400
Message-Id: <20080324123922.087515000@chello.nl>
References: <20080324122424.671168000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 24 Mar 2008 13:24:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] time: xtime lock vs printk
Content-Disposition: inline; filename=time-printk-vs-xtime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This printk() can deadlock because it can wake up klogd(), and
task enqueueing will try to read the time in order to set a hrtimer.

Use the new printk_nowakeup() which will avoid waking klogd.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/time/timekeeping.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6-2/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-2.orig/kernel/time/timekeeping.c
+++ linux-2.6-2/kernel/time/timekeeping.c
@@ -191,7 +191,11 @@ static void change_clocksource(void)
 
 	tick_clock_notify();
 
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+	/*
+	 * We're holding xtime lock and waking up klogd would deadlock
+	 * us on enqueue. Print without waking.
+	 */
+	printk_nowakeup(KERN_INFO "Time: %s clocksource has been installed.\n",
 	       clock->name);
 }
 #else

--

