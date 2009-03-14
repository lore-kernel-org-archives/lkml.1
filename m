Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZCNLgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZCNLgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZCNLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:35:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZCNLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/11] PM: Change suspend code ordering
Date: Sat, 14 Mar 2009 12:28:08 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141228.09631.rjw@sisk.pl>
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
