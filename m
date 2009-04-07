Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbZDGWgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbZDGWgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZDGWga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:36:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52883 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbZDGWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:36:30 -0400
Date: Wed, 8 Apr 2009 00:36:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Clean up sys_shutdown
Message-ID: <20090407223626.GA25557@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up sys_shutdown exit path

Impact: cleanup, fix

Clean up sys_shutdown exit path. Factor out common code. Return
correct error code instead of always 0 on failure.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sys.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c	2009-04-07 16:09:58.000000000 +0200
+++ linux/kernel/sys.c	2009-04-07 16:43:17.000000000 +0200
@@ -360,6 +360,7 @@
 		void __user *, arg)
 {
 	char buffer[256];
+	int ret = 0;
 
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT))
@@ -397,7 +398,7 @@
 		kernel_halt();
 		unlock_kernel();
 		do_exit(0);
-		break;
+		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
@@ -417,29 +418,22 @@
 
 #ifdef CONFIG_KEXEC
 	case LINUX_REBOOT_CMD_KEXEC:
-		{
-			int ret;
-			ret = kernel_kexec();
-			unlock_kernel();
-			return ret;
-		}
+		ret = kernel_kexec();
+		break;
 #endif
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
-		{
-			int ret = hibernate();
-			unlock_kernel();
-			return ret;
-		}
+		ret = hibernate();
+		break;
 #endif
 
 	default:
-		unlock_kernel();
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
 	unlock_kernel();
-	return 0;
+	return ret;
 }
 
 static void deferred_cad(struct work_struct *dummy)
