Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZCNLjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZCNLjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZCNLgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:36:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbZCNLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/11] kexec: Change kexec jump code ordering
Date: Sat, 14 Mar 2009 12:29:30 +0100
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
Message-Id: <200903141229.31860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Change the ordering of the kexec jump code so that the nonboot CPUs
are disabled after calling device drivers' "late suspend" methods.

This change reflects the recent modifications of the power management
code that is also used by kexec jump.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kexec.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1450,9 +1450,6 @@ int kernel_kexec(void)
 		error = device_suspend(PMSG_FREEZE);
 		if (error)
 			goto Resume_console;
-		error = disable_nonboot_cpus();
-		if (error)
-			goto Resume_devices;
 		device_pm_lock();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
@@ -1463,13 +1460,15 @@ int kernel_kexec(void)
 		 */
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
-			goto Unlock_pm;
-
+			goto Resume_devices;
+		error = disable_nonboot_cpus();
+		if (error)
+			goto Enable_cpus;
 		local_irq_disable();
 		/* Suspend system devices */
 		error = sysdev_suspend(PMSG_FREEZE);
 		if (error)
-			goto Power_up_devices;
+			goto Enable_irqs;
 	} else
 #endif
 	{
@@ -1483,13 +1482,13 @@ int kernel_kexec(void)
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		sysdev_resume();
- Power_up_devices:
+ Enable_irqs:
 		local_irq_enable();
-		device_power_up(PMSG_RESTORE);
- Unlock_pm:
-		device_pm_unlock();
+ Enable_cpus:
 		enable_nonboot_cpus();
+		device_power_up(PMSG_RESTORE);
  Resume_devices:
+		device_pm_unlock();
 		device_resume(PMSG_RESTORE);
  Resume_console:
 		resume_console();
