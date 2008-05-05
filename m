Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYEEVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYEEVQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYEEVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:16:36 -0400
Received: from mx1.riseup.net ([204.13.164.18]:47812 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbYEEVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:16:35 -0400
Date: Mon, 5 May 2008 23:16:23 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: rmk@arm.linux.org.uk, Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] sa1100fb: Convert ctrlr_sem in a mutex
Message-ID: <20080505211623.GH11462@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	rmk@arm.linux.org.uk, Antonino Daplas <adaplas@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sa1100fb: The semaphore ctrlr_sem is used as a mutex. Convert it to
the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index ab2b211..2dd1b8a 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -174,6 +174,7 @@
 #include <linux/cpufreq.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/mutex.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -1107,7 +1108,7 @@ static void set_ctrlr_state(struct sa1100fb_info *fbi, u_int state)
 {
 	u_int old_state;
 
-	down(&fbi->ctrlr_sem);
+	mutex_lock(&fbi->ctrlr_lock);
 
 	old_state = fbi->state;
 
@@ -1192,7 +1193,7 @@ static void set_ctrlr_state(struct sa1100fb_info *fbi, u_int state)
 		}
 		break;
 	}
-	up(&fbi->ctrlr_sem);
+	mutex_unlock(&fbi->ctrlr_lock);
 }
 
 /*
@@ -1444,7 +1445,7 @@ static struct sa1100fb_info * __init sa1100fb_init_fbinfo(struct device *dev)
 
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, sa1100fb_task);
-	init_MUTEX(&fbi->ctrlr_sem);
+	mutex_init(&fbi->ctrlr_lock);
 
 	return fbi;
 }
diff --git a/drivers/video/sa1100fb.h b/drivers/video/sa1100fb.h
index f465b27..86831db 100644
--- a/drivers/video/sa1100fb.h
+++ b/drivers/video/sa1100fb.h
@@ -100,7 +100,7 @@ struct sa1100fb_info {
 
 	volatile u_char		state;
 	volatile u_char		task_state;
-	struct semaphore	ctrlr_sem;
+	struct mutex		ctrlr_lock;
 	wait_queue_head_t	ctrlr_wait;
 	struct work_struct	task;
 

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
