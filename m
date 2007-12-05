Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXLFCbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXLFCbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbXLFCam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:30:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42033 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756459AbXLFCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:30:40 -0500
Message-Id: <20071206021909.131993721@mvista.com>
References: <20071206021906.632232033@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 00:00:03 -0800
Subject: [PATCH 3/3] printer port driver: semaphore to mutex
References: <20071206021857.826386004@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=lp-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port_mutex is actually a semaphore, so easily converted to
a struct mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/lp.c  |   11 ++++++-----
 include/linux/lp.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.23/drivers/char/lp.c
===================================================================
--- linux-2.6.23.orig/drivers/char/lp.c
+++ linux-2.6.23/drivers/char/lp.c
@@ -126,6 +126,7 @@
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/jiffies.h>
+#include <linux/mutex.h>
 
 #include <linux/parport.h>
 #undef LP_STATS
@@ -312,7 +313,7 @@ static ssize_t lp_write(struct file * fi
 	if (copy_size > LP_BUFFER_SIZE)
 		copy_size = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	if (copy_from_user (kbuf, buf, copy_size)) {
@@ -399,7 +400,7 @@ static ssize_t lp_write(struct file * fi
 		lp_release_parport (&lp_table[minor]);
 	}
 out_unlock:
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
  	return retv;
 }
@@ -421,7 +422,7 @@ static ssize_t lp_read(struct file * fil
 	if (count > LP_BUFFER_SIZE)
 		count = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	lp_claim_parport_or_block (&lp_table[minor]);
@@ -479,7 +480,7 @@ static ssize_t lp_read(struct file * fil
 	if (retval > 0 && copy_to_user (buf, kbuf, retval))
 		retval = -EFAULT;
 
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
 	return retval;
 }
@@ -888,7 +889,7 @@ static int __init lp_init (void)
 		lp_table[i].last_error = 0;
 		init_waitqueue_head (&lp_table[i].waitq);
 		init_waitqueue_head (&lp_table[i].dataq);
-		init_MUTEX (&lp_table[i].port_mutex);
+		mutex_init(&lp_table[i].port_mutex);
 		lp_table[i].timeout = 10 * HZ;
 	}
 
Index: linux-2.6.23/include/linux/lp.h
===================================================================
--- linux-2.6.23.orig/include/linux/lp.h
+++ linux-2.6.23/include/linux/lp.h
@@ -145,7 +145,7 @@ struct lp_struct {
 #endif
 	wait_queue_head_t waitq;
 	unsigned int last_error;
-	struct semaphore port_mutex;
+	struct mutex port_mutex;
 	wait_queue_head_t dataq;
 	long timeout;
 	unsigned int best_mode;

-- 
