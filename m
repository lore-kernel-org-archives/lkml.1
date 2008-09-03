Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYICViY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYICViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYICVhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:38 -0400
Received: from www.tglx.de ([62.245.132.106]:41393 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbYICVhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:36 -0400
Message-Id: <20080903212753.233424002@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:37:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 3/6] clockevents: enforce reprogram in oneshot setup
Content-Disposition: inline;
	filename=clockevents-enforce-reprogram-in-oneshot-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tick_oneshot_setup we program the device to the given next_event,
but we do not check the return value. We need to make sure that the
device is programmed enforced so the interrupt handler engine starts
working. Split out the reprogramming function from tick_program_event()
and call it with the device, which was handed in to tick_setup_oneshot().
Set the force argument, so the devices is firing an interrupt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-oneshot.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-oneshot.c
+++ linux-2.6/kernel/time/tick-oneshot.c
@@ -23,11 +23,11 @@
 #include "tick-internal.h"
 
 /**
- * tick_program_event
+ * tick_program_event internal worker function
  */
-int tick_program_event(ktime_t expires, int force)
+static int __tick_program_event(struct clock_event_device *dev,
+				ktime_t expires, int force)
 {
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	ktime_t now = ktime_get();
 
 	while (1) {
@@ -41,6 +41,16 @@ int tick_program_event(ktime_t expires, 
 }
 
 /**
+ * tick_program_event
+ */
+int tick_program_event(ktime_t expires, int force)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+
+	return __tick_program_event(dev, expires, force);
+}
+
+/**
  * tick_resume_onshot - resume oneshot mode
  */
 void tick_resume_oneshot(void)
@@ -61,7 +71,7 @@ void tick_setup_oneshot(struct clock_eve
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	clockevents_program_event(newdev, next_event, ktime_get());
+	__tick_program_event(newdev, next_event, 1);
 }
 
 /**

-- 

