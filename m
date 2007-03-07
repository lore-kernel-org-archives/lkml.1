Return-Path: <linux-kernel-owner+w=401wt.eu-S2992504AbXCGTlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992504AbXCGTlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992513AbXCGTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:41:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992504AbXCGTlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:41:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Wed, 7 Mar 2007 20:44:11 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703072044.12021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
from triggering by disabling nonboot CPUs before we finally enter the platform
suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    1 +
 kernel/power/user.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
+++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
@@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
+			disable_nonboot_cpus();
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 			pm_ops->enter(PM_SUSPEND_DISK);
 			break;
Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
+++ linux-2.6.21-rc2-mm2/kernel/power/user.c
@@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
 
 		case PMOPS_ENTER:
 			if (data->platform_suspend) {
+				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
-				error = 0;
 			}
 			break;
 
