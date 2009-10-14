Return-Path: <linux-kernel-owner+w=401wt.eu-S934596AbZJNPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596AbZJNPpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934587AbZJNPpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:45:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:33877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934585AbZJNPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:45:37 -0400
Date: Wed, 14 Oct 2009 15:44:46 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091010153349.405590702@linutronix.de>
References: <20091010153349.405590702@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/core] sys: Remove BKL from sys_reboot
Message-ID: <tip-6f15fa50087c8317e353145319466afbeb27a75d@git.kernel.org>
Git-Commit-ID: 6f15fa50087c8317e353145319466afbeb27a75d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:44:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f15fa50087c8317e353145319466afbeb27a75d
Gitweb:     http://git.kernel.org/tip/6f15fa50087c8317e353145319466afbeb27a75d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 9 Oct 2009 20:31:33 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:31:10 +0200

sys: Remove BKL from sys_reboot

Serialization of sys_reboot can be done local. The BKL is not
protecting anything else.

LKML-Reference: <20091010153349.405590702@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sys.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..22ea955 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/prctl.h>
@@ -349,6 +348,9 @@ void kernel_power_off(void)
 	machine_power_off();
 }
 EXPORT_SYMBOL_GPL(kernel_power_off);
+
+static DEFINE_MUTEX(reboot_mutex);
+
 /*
  * Reboot system call: for obvious reasons only root may call it,
  * and even root needs to set up some magic numbers in the registers
@@ -381,7 +383,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
 		cmd = LINUX_REBOOT_CMD_HALT;
 
-	lock_kernel();
+	mutex_lock(&reboot_mutex);
 	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART:
 		kernel_restart(NULL);
@@ -397,20 +399,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	case LINUX_REBOOT_CMD_HALT:
 		kernel_halt();
-		unlock_kernel();
 		do_exit(0);
 		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
-		unlock_kernel();
 		do_exit(0);
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
 		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
-			unlock_kernel();
-			return -EFAULT;
+			ret = -EFAULT;
+			break;
 		}
 		buffer[sizeof(buffer) - 1] = '\0';
 
@@ -433,7 +433,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		ret = -EINVAL;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&reboot_mutex);
 	return ret;
 }
 
