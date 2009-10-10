Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbZJJPia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbZJJPia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbZJJPi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:27 -0400
Received: from www.tglx.de ([62.245.132.106]:55537 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401AbZJJPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:25 -0400
Message-Id: <20091010153349.723047498@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/28] sparc: Remove BKL from apc
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=sparc-Remove-BKL-from-apc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ab772027 (sparc: arch/sparc/kernel/apc.c to unlocked_ioctl)
added lock/unlock_kernel() to the apc ioctl code.

The code needs no serialization at all. Neither put/get_user nor the
read/write access to the sbus devices require it. Remove BKL.

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/apc.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

Index: linux-2.6-tip/arch/sparc/kernel/apc.c
===================================================================
--- linux-2.6-tip.orig/arch/sparc/kernel/apc.c
+++ linux-2.6-tip/arch/sparc/kernel/apc.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -76,7 +75,6 @@ static inline void apc_free(struct of_de
 
 static int apc_open(struct inode *inode, struct file *f)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -87,61 +85,46 @@ static int apc_release(struct inode *ino
 
 static long apc_ioctl(struct file *f, unsigned int cmd, unsigned long __arg)
 {
-	__u8 inarg, __user *arg;
-
-	arg = (__u8 __user *) __arg;
-
-	lock_kernel();
+	__u8 inarg, __user *arg = (__u8 __user *) __arg;
 
 	switch (cmd) {
 	case APCIOCGFANCTL:
-		if (put_user(apc_readb(APC_FANCTL_REG) & APC_REGMASK, arg)) {
-			unlock_kernel();
+		if (put_user(apc_readb(APC_FANCTL_REG) & APC_REGMASK, arg))
 			return -EFAULT;
-		}
 		break;
 
 	case APCIOCGCPWR:
-		if (put_user(apc_readb(APC_CPOWER_REG) & APC_REGMASK, arg)) {
-			unlock_kernel();
+		if (put_user(apc_readb(APC_CPOWER_REG) & APC_REGMASK, arg))
 			return -EFAULT;
-		}
 		break;
 
 	case APCIOCGBPORT:
-		if (put_user(apc_readb(APC_BPORT_REG) & APC_BPMASK, arg)) {
-			unlock_kernel();
+		if (put_user(apc_readb(APC_BPORT_REG) & APC_BPMASK, arg))
 			return -EFAULT;
-		}
 		break;
 
 	case APCIOCSFANCTL:
-		if (get_user(inarg, arg)) {
-			unlock_kernel();
+		if (get_user(inarg, arg))
 			return -EFAULT;
-		}
 		apc_writeb(inarg & APC_REGMASK, APC_FANCTL_REG);
 		break;
+
 	case APCIOCSCPWR:
-		if (get_user(inarg, arg)) {
-			unlock_kernel();
+		if (get_user(inarg, arg))
 			return -EFAULT;
-		}
 		apc_writeb(inarg & APC_REGMASK, APC_CPOWER_REG);
 		break;
+
 	case APCIOCSBPORT:
-		if (get_user(inarg, arg)) {
-			unlock_kernel();
+		if (get_user(inarg, arg))
 			return -EFAULT;
-		}
 		apc_writeb(inarg & APC_BPMASK, APC_BPORT_REG);
 		break;
+
 	default:
-		unlock_kernel();
 		return -EINVAL;
 	};
 
-	unlock_kernel();
 	return 0;
 }
 


