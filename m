Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbZJJPh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbZJJPh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbZJJPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:54 -0400
Received: from www.tglx.de ([62.245.132.106]:55404 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761945AbZJJPhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:52 -0400
Message-Id: <20091010153349.405590702@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 09/28] sys: Remove BKL from sys_reboot
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=sys-remove-bkl-from-reboot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serialization of sys_reboot can be done local. The BKL is not
protecting anything else.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sys.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/kernel/sys.c
===================================================================
--- linux-2.6-tip.orig/kernel/sys.c
+++ linux-2.6-tip/kernel/sys.c
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
@@ -381,7 +383,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
 		cmd = LINUX_REBOOT_CMD_HALT;
 
-	lock_kernel();
+	mutex_lock(&reboot_mutex);
 	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART:
 		kernel_restart(NULL);
@@ -397,20 +399,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 
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
 
@@ -433,7 +433,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 		ret = -EINVAL;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&reboot_mutex);
 	return ret;
 }
 


