Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZDXWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZDXWRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZDXWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:16:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZDXWQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM/Hibernate: Fix waiting for image device to appear on resume
Date: Sat, 25 Apr 2009 00:16:06 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904250016.07088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit c751085943362143f84346d274e0011419c84202
(PM/Hibernate: Wait for SCSI devices scan to complete during resume)
added scsi_complete_async_scans() to software_resume(), so that it
waited for the SCSI scanning to complete, but the call was added at a
wrong place.  Namely, it should have been added after
wait_for_device_probe(), which is called only if the image partition
hasn't been specified yet.  Also, it's reasonable to check if the
image partition is present and only wait for the device probing and
SCSI scanning to complete if it is not the case.

Additionally, since noresume is checked right at the beginning of
software_resume() and the function returns immediately if it's set,
it doesn't make sense to check it once again later.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |   51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -646,13 +646,6 @@ static int software_resume(void)
 		return 0;
 
 	/*
-	 * We can't depend on SCSI devices being available after loading one of
-	 * their modules if scsi_complete_async_scans() is not called and the
-	 * resume device usually is a SCSI one.
-	 */
-	scsi_complete_async_scans();
-
-	/*
 	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
 	 * is configured into the kernel. Since the regular hibernate
 	 * trigger path is via sysfs which takes a buffer mutex before
@@ -663,32 +656,42 @@ static int software_resume(void)
 	 * here to avoid lockdep complaining.
 	 */
 	mutex_lock_nested(&pm_mutex, SINGLE_DEPTH_NESTING);
+
+	if (swsusp_resume_device)
+		goto Check_image;
+
+	if (!strlen(resume_file)) {
+		error = -ENOENT;
+		goto Unlock;
+	}
+
+	pr_debug("PM: Checking image partition %s\n", resume_file);
+
+	/* Check if the device is there */
+	swsusp_resume_device = name_to_dev_t(resume_file);
 	if (!swsusp_resume_device) {
-		if (!strlen(resume_file)) {
-			mutex_unlock(&pm_mutex);
-			return -ENOENT;
-		}
 		/*
 		 * Some device discovery might still be in progress; we need
 		 * to wait for this to finish.
 		 */
 		wait_for_device_probe();
+		/*
+		 * We can't depend on SCSI devices being available after loading
+		 * one of their modules until scsi_complete_async_scans() is
+		 * called and the resume device usually is a SCSI one.
+		 */
+		scsi_complete_async_scans();
+
 		swsusp_resume_device = name_to_dev_t(resume_file);
-		pr_debug("PM: Resume from partition %s\n", resume_file);
-	} else {
-		pr_debug("PM: Resume from partition %d:%d\n",
-				MAJOR(swsusp_resume_device),
-				MINOR(swsusp_resume_device));
+		if (!swsusp_resume_device) {
+			error = -ENODEV;
+			goto Unlock;
+		}
 	}
 
-	if (noresume) {
-		/**
-		 * FIXME: If noresume is specified, we need to find the
-		 * partition and reset it back to normal swap space.
-		 */
-		mutex_unlock(&pm_mutex);
-		return 0;
-	}
+ Check_image:
+	pr_debug("PM: Resume from partition %d:%d\n",
+		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
 	pr_debug("PM: Checking hibernation image.\n");
 	error = swsusp_check();
