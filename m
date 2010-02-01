Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0BAEPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:15:48 -0500
Received: from ozlabs.org ([203.10.76.45]:36586 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0BAEPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:15:47 -0500
Date: Mon, 1 Feb 2010 15:14:30 +1100
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] panic: Fix panic_timeout accuracy when running on a
 hypervisor
Message-ID: <20100201041430.GQ2996@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've had some complaints about panic_timeout being wildly innacurate on
shared processor PowerPC partitions (a 3 minute panic_timeout taking 30
minutes).

The problem is we loop on mdelay(1) and with a 1ms in 10ms hypervisor
timeslice each of these will take 10ms (ie 10x) longer. I expect other
platforms with shared processor hypervisors will see the same issue.

This patch keeps the old behaviour if we have a panic_blink (only keyboard
LEDs right now) and does 1 second mdelays if we don't.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-cpumask/kernel/panic.c
===================================================================
--- linux-cpumask.orig/kernel/panic.c	2010-02-01 14:17:40.140961595 +1100
+++ linux-cpumask/kernel/panic.c	2010-02-01 14:30:45.549711407 +1100
@@ -36,15 +36,36 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-static long no_blink(long time)
-{
-	return 0;
-}
-
 /* Returns how long it waited in ms */
 long (*panic_blink)(long time);
 EXPORT_SYMBOL(panic_blink);
 
+static void panic_blink_one_second(void)
+{
+	static long i = 0, end;
+
+	if (panic_blink) {
+		end = i + MSEC_PER_SEC;
+
+		while (i < end) {
+			i += panic_blink(i);
+			mdelay(1);
+			i++;
+		}
+	} else {
+		/*
+		 * When running under a hypervisor a small mdelay may get
+		 * rounded up to the hypervisor timeslice. For example, with
+		 * a 1ms in 10ms hypervisor timeslice we might inflate a
+		 * mdelay(1) loop by 10x.
+		 *
+		 * If we have nothing to blink, spin on 1 second calls to
+		 * mdelay to avoid this.
+		 */
+		mdelay(MSEC_PER_SEC);
+	}
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -95,9 +116,6 @@ NORET_TYPE void panic(const char * fmt, 
 
 	bust_spinlocks(0);
 
-	if (!panic_blink)
-		panic_blink = no_blink;
-
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
@@ -105,11 +123,9 @@ NORET_TYPE void panic(const char * fmt, 
 		 */
 		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
 
-		for (i = 0; i < panic_timeout*1000; ) {
+		for (i = 0; i < panic_timeout; i++) {
 			touch_nmi_watchdog();
-			i += panic_blink(i);
-			mdelay(1);
-			i++;
+			panic_blink_one_second();
 		}
 		/*
 		 * This will not be a clean reboot, with everything
@@ -135,11 +151,9 @@ NORET_TYPE void panic(const char * fmt, 
 	}
 #endif
 	local_irq_enable();
-	for (i = 0; ; ) {
+	while (1) {
 		touch_softlockup_watchdog();
-		i += panic_blink(i);
-		mdelay(1);
-		i++;
+		panic_blink_one_second();
 	}
 }
 
