Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXEYMPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXEYMPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbXEYMP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550AbXEYMP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/4] swsusp: Remove incorrect code from user.c
Date: Fri, 25 May 2007 14:12:19 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200705251409.55644.rjw@sisk.pl>
In-Reply-To: <200705251409.55644.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705251412.19783.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the code hibernation code in kernel/power/user.c be functionally equivalent
to the corresponding code in kernel/power/disk.c , as it should be.

The calls to the platform functions removed by this patch are incorrect.  They
should be replaced with some other "platform" invocations that will be
introduced in one of the subsequent patches.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/user.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6.22-rc2/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/user.c
+++ linux-2.6.22-rc2/kernel/power/user.c
@@ -179,34 +179,25 @@ static inline int snapshot_suspend(int p
 	return error;
 }
 
-static inline int snapshot_restore(int platform_suspend)
+static inline int snapshot_restore(void)
 {
 	int error;
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
-	if (platform_suspend) {
-		error = platform_prepare();
-		if (error)
-			goto Finish;
-	}
 	suspend_console();
 	error = device_suspend(PMSG_PRETHAW);
 	if (error)
-		goto Resume_devices;
+		goto Finish;
 
 	error = disable_nonboot_cpus();
 	if (!error)
 		error = swsusp_resume();
 
 	enable_nonboot_cpus();
- Resume_devices:
-	if (platform_suspend)
-		platform_finish();
-
+ Finish:
 	device_resume();
 	resume_console();
- Finish:
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -272,7 +263,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_restore(data->platform_suspend);
+		error = snapshot_restore();
 		break;
 
 	case SNAPSHOT_FREE:
