Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXEDJi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXEDJi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXEDJi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:38:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422906AbXEDJiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:38:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFT][PATCH] swsusp: Change code ordering related to ACPI
Date: Fri, 4 May 2007 11:43:01 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcus Better <marcus@better.se>, Pavel Machek <pavel@ucw.cz>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041143.02451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The change of the hibernation/suspend code ordering made before 2.6.21 has
caused some systems to have problems related to ACPI.  In particular, the
'platform' hibernation mode doesn't work any more on some systems.

It has been confirmed that the appended patch fixes the problem, but it's not
certain if this changes don't break some other systems.  For this reason, all
users of hibernation (swsusp, uswsusp) are gently requested to verify if this
patch doesn't break their systems.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

The current code ordering in the hibernation code paths causes some systems to
have problems.  It has been confirmed by testers that these problems do not
appear if the acpi_pm_finish() function (called via platform_finish()) is
executed after device_suspend().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    4 ++--
 kernel/power/user.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.21/kernel/power/disk.c
===================================================================
--- linux-2.6.21.orig/kernel/power/disk.c	2007-05-04 10:31:51.000000000 +0200
+++ linux-2.6.21/kernel/power/disk.c	2007-05-04 10:32:12.000000000 +0200
@@ -195,9 +195,9 @@ int hibernate(void)
 
 	if (in_suspend) {
 		enable_nonboot_cpus();
-		platform_finish();
 		device_resume();
 		resume_console();
+		platform_finish();
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
 		if (!error)
@@ -214,9 +214,9 @@ int hibernate(void)
  Enable_cpus:
 	enable_nonboot_cpus();
  Resume_devices:
-	platform_finish();
 	device_resume();
 	resume_console();
+	platform_finish();
  Thaw:
 	mutex_unlock(&pm_mutex);
 	unprepare_processes();
Index: linux-2.6.21/kernel/power/user.c
===================================================================
--- linux-2.6.21.orig/kernel/power/user.c	2007-05-04 10:31:51.000000000 +0200
+++ linux-2.6.21/kernel/power/user.c	2007-05-04 10:32:12.000000000 +0200
@@ -169,11 +169,11 @@ static inline int snapshot_suspend(int p
 	}
 	enable_nonboot_cpus();
  Resume_devices:
+	device_resume();
+	resume_console();
 	if (platform_suspend)
 		platform_finish();
 
-	device_resume();
-	resume_console();
  Finish:
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -201,11 +201,11 @@ static inline int snapshot_restore(int p
 
 	enable_nonboot_cpus();
  Resume_devices:
+	device_resume();
+	resume_console();
 	if (platform_suspend)
 		platform_finish();
 
-	device_resume();
-	resume_console();
  Finish:
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
