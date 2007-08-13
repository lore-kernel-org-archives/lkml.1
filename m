Return-Path: <linux-kernel-owner+w=401wt.eu-S937582AbXHMX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937582AbXHMX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbXHMX1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:27:10 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:59684 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756404AbXHMX1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:27:09 -0400
Date: Mon, 13 Aug 2007 19:26:26 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] hres_timers_resume must block interrupts
Message-ID: <20070813232626.GA24938@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Retrigger_next_event() must be called with interrupts disabled.

All internal (to hrtimer.c) uses of retrigger_next_event() are correct.
But the version exported to other files, hres_timers_resume(), does not
do the IRQ blocking, nor does the (single) external caller of it.

Rather than require that users of hres_timers_resume() do the IRQ blocking,
this patch makes the blocking part of the hres_timers_resume() functionality.

(Also remove the meaningless WARN_ON_ONCE() call in hres_timers_resume)

Signed-off-by: Joe Korty (joe.korty@ccur.com)

Index: 2.6.23-rc3/kernel/hrtimer.c
===================================================================
--- 2.6.23-rc3.orig/kernel/hrtimer.c	2007-08-13 18:30:09.000000000 -0400
+++ 2.6.23-rc3/kernel/hrtimer.c	2007-08-13 18:38:48.000000000 -0400
@@ -463,10 +463,11 @@
  */
 void hres_timers_resume(void)
 {
-	WARN_ON_ONCE(num_online_cpus() > 1);
+	unsigned long flags;
 
-	/* Retrigger the CPU local events: */
+	local_irq_save(flags);
 	retrigger_next_event(NULL);
+	local_irq_restore(flags);
 }
 
 /*

