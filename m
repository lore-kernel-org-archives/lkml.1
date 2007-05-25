Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbXEYMQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbXEYMQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbXEYMPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbXEYMP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/4] swsusp: Fix hibernation code ordering
Date: Fri, 25 May 2007 14:20:01 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200705251409.55644.rjw@sisk.pl>
In-Reply-To: <200705251409.55644.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251420.02104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Change the code ordering so that hibernation_ops->prepare() is called after
device_suspend().  This is needed so that we don't violate the ACPI
specification, which states that the _PTS and _GTS system-control methods,
executed from acpi_sleep_prepare(), ought to be called after devices have been
put in low power states.

The "Finish" label in hibernation_restore() is moved, because device_suspend()
resumes devices if the suspending of them fails and the restore code ordering
should reflect the hibernation code ordering.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/disk.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc2/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/disk.c
+++ linux-2.6.22-rc2/kernel/power/disk.c
@@ -133,15 +133,15 @@ int hibernation_snapshot(int platform_mo
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		goto Finish;
-
-	error = platform_prepare(platform_mode);
-	if (error)
-		goto Finish;
+		return error;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
+		goto Resume_console;
+
+	error = platform_prepare(platform_mode);
+	if (error)
 		goto Resume_devices;
 
 	error = disable_nonboot_cpus();
@@ -159,8 +159,8 @@ int hibernation_snapshot(int platform_mo
  Resume_devices:
 	platform_finish(platform_mode);
 	device_resume();
+ Resume_console:
 	resume_console();
- Finish:
 	return error;
 }
 
@@ -191,8 +191,8 @@ int hibernation_restore(int platform_mod
 		enable_nonboot_cpus();
 	}
 	platform_restore_cleanup(platform_mode);
- Finish:
 	device_resume();
+ Finish:
 	resume_console();
 	pm_restore_console();
 	return error;
