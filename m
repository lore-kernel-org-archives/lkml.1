Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXCTVpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXCTVpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCTVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:45:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXCTVpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:45:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] swsusp: Fix SNAPSHOT_S2RAM ioctl
Date: Tue, 20 Mar 2007 22:48:08 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202248.08665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The SNAPSHOT_S2RAM ioctl does not disable the nonboot CPUs before entering
the suspend, although it should do this.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc4/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc4.orig/kernel/power/user.c
+++ linux-2.6.21-rc4/kernel/power/user.c
@@ -374,9 +374,12 @@ static int snapshot_ioctl(struct inode *
 		if (error) {
 			printk(KERN_ERR "Failed to suspend some devices.\n");
 		} else {
-			/* Enter S3, system is already frozen */
-			suspend_enter(PM_SUSPEND_MEM);
-
+			error = disable_nonboot_cpus();
+			if (!error) {
+				/* Enter S3, system is already frozen */
+				suspend_enter(PM_SUSPEND_MEM);
+				enable_nonboot_cpus();
+			}
 			/* Wake up devices */
 			device_resume();
 		}
