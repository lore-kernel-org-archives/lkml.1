Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZCGK3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZCGK3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 05:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZCGK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 05:28:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZCGK2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 05:28:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH][2/8] PM: Change suspend code ordering
Date: Sat, 7 Mar 2009 11:21:47 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903071119.16651.rjw@sisk.pl>
In-Reply-To: <200903071119.16651.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071121.48780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Change the ordering of the suspend core code so that the platform
"prepare" callback is executed and the nonboot CPUs are disabled
after calling device drivers' "late suspend" methods.

This change will allow us to rework the PCI PM core so that the power
state of devices is changed in the "late" phase of suspend (and
analogously in the "early" phase of resume), which in turn will allow
us to avoid the race condition where a device using shared interrupts
is put into a low power state with interrupts enabled and then an
interrupt (for another device) comes in and confuses its driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -297,6 +297,19 @@ static int suspend_enter(suspend_state_t
 		goto Done;
 	}
 
+	if (suspend_ops->prepare) {
+		error = suspend_ops->prepare();
+		if (error)
+			goto Power_up_devices;
+	}
+
+	if (suspend_test(TEST_PLATFORM))
+		goto Platfrom_finish;
+
+	error = disable_nonboot_cpus();
+	if (error || suspend_test(TEST_CPUS))
+		goto Enable_cpus;
+
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
 
@@ -310,6 +323,14 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
+ Enable_cpus:
+	enable_nonboot_cpus();
+
+ Platfrom_finish:
+	if (suspend_ops->finish)
+		suspend_ops->finish();
+
+ Power_up_devices:
 	device_power_up(PMSG_RESUME);
 
  Done:
@@ -346,23 +367,8 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_test(TEST_DEVICES))
 		goto Recover_platform;
 
-	if (suspend_ops->prepare) {
-		error = suspend_ops->prepare();
-		if (error)
-			goto Resume_devices;
-	}
-
-	if (suspend_test(TEST_PLATFORM))
-		goto Finish;
+	suspend_enter(state);
 
-	error = disable_nonboot_cpus();
-	if (!error && !suspend_test(TEST_CPUS))
-		suspend_enter(state);
-
-	enable_nonboot_cpus();
- Finish:
-	if (suspend_ops->finish)
-		suspend_ops->finish();
  Resume_devices:
 	suspend_test_start();
 	device_resume(PMSG_RESUME);
