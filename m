Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbXKGJmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbXKGJmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXKGJm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:42:28 -0500
Received: from nic2.axis.se ([193.13.178.10]:50027 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXKGJm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:42:28 -0500
Date: Wed, 7 Nov 2007 10:42:13 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRISv10 Fix timer interrupt parameters
Message-ID: <20071107094213.GA6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix timer interrupt parameters for CRIS v10.

- irq_handler_t only takes two arguments, use get_irq_regs to get
  regs for profiling.
- Call update_process_times.
- Remove CVS tag.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 time.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 575a14b..466e6b7 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -1,5 +1,4 @@
-/* $Id: time.c,v 1.5 2004/09/29 06:12:46 starvik Exp $
- *
+/*
  *  linux/arch/cris/arch-v10/kernel/time.c
  *
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
@@ -20,6 +19,7 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/rtc.h>
+#include <asm/irq_regs.h>
 
 /* define this if you need to use print_timestamp */
 /* it will make jiffies at 96 hz instead of 100 hz though */
@@ -201,8 +201,9 @@ static long last_rtc_update = 0;
 extern void cris_do_profile(struct pt_regs *regs);
 
 static inline irqreturn_t
-timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+timer_interrupt(int irq, void *dev_id)
 {
+	struct pt_regs *regs = get_irq_regs();
 	/* acknowledge the timer irq */
 
 #ifdef USE_CASCADE_TIMERS
@@ -221,9 +222,11 @@ timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 #endif
 
 	/* reset watchdog otherwise it resets us! */
-
 	reset_watchdog();
 	
+	/* Update statistics. */
+	update_process_times(user_mode(regs));
+
 	/* call the real timer interrupt handler */
 
 	do_timer(1);

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
