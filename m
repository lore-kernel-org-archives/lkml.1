Return-Path: <linux-kernel-owner+w=401wt.eu-S1422727AbXCXHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422727AbXCXHbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965375AbXCXHbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:31:36 -0400
Received: from peabody.ximian.com ([130.57.169.10]:36813 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbXCXHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:31:25 -0400
Subject: [RFC][PATCH 1/3] cpuidle governor API changes
From: Adam Belay <abelay@novell.com>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Shaohua Li <shaohua.li@intel.com>, Pallipadi@vger.kernel.org,
       Venkatesh <venkatesh.pallipadi@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Sat, 24 Mar 2007 03:46:58 -0400
Message-Id: <1174722418.32554.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares cpuidle for the menu governor.  It adds an optional
stage after idle state entry to give the governor an opportunity to
check why the state was exited.  Also it makes sure the idle loop
returns after each state entry, allowing the appropriate dynticks code
to run.

Thanks,
Adam

 drivers/cpuidle/cpuidle.c          |   33 ++++++++++++++-------------------
 drivers/cpuidle/governor.c         |    2 +-
 drivers/cpuidle/governors/ladder.c |    2 +-
 include/linux/cpuidle.h            |    4 ++--
 4 files changed, 18 insertions(+), 23 deletions(-)


diff -urN a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c	2007-03-23 23:09:45.000000000 -0400
+++ b/drivers/cpuidle/cpuidle.c	2007-03-24 00:22:09.000000000 -0400
@@ -30,12 +30,10 @@
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
- * FIXME: DYNTICKS handling
  */
 static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = &__get_cpu_var(cpuidle_devices);
-
 	struct cpuidle_state *target_state;
 	int next_state;
 
@@ -46,24 +44,21 @@
 		return;
 	}
 
-	if (cpuidle_curr_governor->prepare_idle)
-		cpuidle_curr_governor->prepare_idle(dev);
-
-	while(!need_resched()) {
-		next_state = cpuidle_curr_governor->select_state(dev);
-		if (need_resched())
-			break;
-
-		target_state = &dev->states[next_state];
-
-		dev->last_residency = target_state->enter(dev, target_state);
-		dev->last_state = target_state;
-		target_state->time += dev->last_residency;
-		target_state->usage++;
+	/* ask the governor for the next state */
+	next_state = cpuidle_curr_governor->select(dev);
+	if (need_resched())
+		return;
+	target_state = &dev->states[next_state];
 
-		if (dev->status != CPUIDLE_STATUS_DOIDLE)
-			break;
-	}
+	/* enter the state and update stats */
+	dev->last_residency = target_state->enter(dev, target_state);
+	dev->last_state = target_state;
+	target_state->time += dev->last_residency;
+	target_state->usage++;
+
+	/* give the governor an opportunity to reflect on the outcome */
+	if (cpuidle_curr_governor->reflect)
+		cpuidle_curr_governor->reflect(dev);
 }
 
 /**
diff -urN a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
--- a/drivers/cpuidle/governor.c	2007-03-23 23:09:45.000000000 -0400
+++ b/drivers/cpuidle/governor.c	2007-03-24 00:31:04.000000000 -0400
@@ -124,7 +124,7 @@
 {
 	int ret = -EEXIST;
 
-	if (!gov || !gov->select_state)
+	if (!gov || !gov->select)
 		return -EINVAL;
 
 	mutex_lock(&cpuidle_lock);
diff -urN a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c	2007-03-23 23:09:45.000000000 -0400
+++ b/drivers/cpuidle/governors/ladder.c	2007-03-23 23:26:06.000000000 -0400
@@ -202,7 +202,7 @@
 	.init =		ladder_init_device,
 	.exit =		ladder_exit_device,
 	.scan =		ladder_scan_device,
-	.select_state =	ladder_select_state,
+	.select =	ladder_select_state,
 	.owner =	THIS_MODULE,
 };
 
diff -urN a/include/linux/cpuidle.h b/include/linux/cpuidle.h
--- a/include/linux/cpuidle.h	2007-03-23 23:09:46.000000000 -0400
+++ b/include/linux/cpuidle.h	2007-03-23 23:24:02.000000000 -0400
@@ -158,8 +158,8 @@
 	void (*exit)		(struct cpuidle_device *dev);
 	void (*scan)		(struct cpuidle_device *dev);
 
-	void (*prepare_idle)	(struct cpuidle_device *dev);
-	int  (*select_state)	(struct cpuidle_device *dev);
+	int  (*select)		(struct cpuidle_device *dev);
+	void (*reflect)		(struct cpuidle_device *dev);
 
 	struct module 		*owner;
 };


