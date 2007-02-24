Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXBXWNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXBXWNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933568AbXBXWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:13:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXBXWNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:13:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: stable@kernel.org
Subject: [PATCH] swsusp: Fix possible oops in userland interface
Date: Sat, 24 Feb 2007 23:06:43 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Stefan Seyfried <seife@suse.de>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702242306.44445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@suse.de>

Fix the Oops occuring when SNAPSHOT_PMOPS or SNAPSHOT_S2RAM ioctl is called on
a system without pm_ops defined (eg. a non-ACPI kernel on x86 PC).

Signed-off-by: Stefan Seyfried <seife@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 user.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/kernel/power/user.c	2007-02-01 01:07:38.000000000 +0100
+++ b/kernel/power/user.c	2007-02-01 22:25:48.000000000 +0100
@@ -292,7 +292,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
-		if (pm_ops->prepare) {
+		if (pm_ops && pm_ops->prepare) {
 			error = pm_ops->prepare(PM_SUSPEND_MEM);
 			if (error)
 				goto OutS3;
@@ -311,7 +311,7 @@ static int snapshot_ioctl(struct inode *
 			device_resume();
 		}
 		resume_console();
-		if (pm_ops->finish)
+		if (pm_ops && pm_ops->finish)
 			pm_ops->finish(PM_SUSPEND_MEM);
 
  OutS3:
@@ -322,20 +322,25 @@ static int snapshot_ioctl(struct inode *
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			if (pm_ops->prepare) {
+			if (pm_ops && pm_ops->prepare)
 				error = pm_ops->prepare(PM_SUSPEND_DISK);
-			}
+			else
+				error = -ENOSYS;
 			break;
 
 		case PMOPS_ENTER:
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			error = pm_ops->enter(PM_SUSPEND_DISK);
+			if (pm_ops && pm_ops->enter)
+				error = pm_ops->enter(PM_SUSPEND_DISK);
+			else
+				error = -ENOSYS;
 			break;
 
 		case PMOPS_FINISH:
-			if (pm_ops && pm_ops->finish) {
+			if (pm_ops && pm_ops->finish)
 				pm_ops->finish(PM_SUSPEND_DISK);
-			}
+			else
+				error = -ENOSYS;
 			break;
 
 		default:
