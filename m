Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYEEUvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYEEUvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYEEUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:50:53 -0400
Received: from mx1.riseup.net ([204.13.164.18]:46749 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYEEUux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:50:53 -0400
Date: Mon, 5 May 2008 22:50:42 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Daniel Mack <daniel@caiaq.de>, Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Antonino Daplas <adaplas@gmail.com>
Subject: [PATCH] pxafb: Convert ctrlr_sem in a mutex
Message-ID: <20080505205042.GG11462@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Daniel Mack <daniel@caiaq.de>, Eric Miao <eric.miao@marvell.com>,
	Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Antonino Daplas <adaplas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxafb: The semaphore ctrlr_sem is used as a mutex. Convert it to the
mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 3ab6e3d..a63b77b 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -40,6 +40,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
@@ -1059,7 +1060,7 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 {
 	u_int old_state;
 
-	down(&fbi->ctrlr_sem);
+	mutex_lock(&fbi->ctrlr_lock);
 
 	old_state = fbi->state;
 
@@ -1147,7 +1148,7 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 		}
 		break;
 	}
-	up(&fbi->ctrlr_sem);
+	mutex_unlock(&fbi->ctrlr_lock);
 }
 
 /*
@@ -1399,7 +1400,7 @@ static struct pxafb_info * __init pxafb_init_fbinfo(struct device *dev)
 
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, pxafb_task);
-	init_MUTEX(&fbi->ctrlr_sem);
+	mutex_init(&fbi->ctrlr_lock);
 	init_completion(&fbi->disable_done);
 #ifdef CONFIG_FB_PXA_SMARTPANEL
 	init_completion(&fbi->command_done);
diff --git a/drivers/video/pxafb.h b/drivers/video/pxafb.h
index 8238dc8..31541b8 100644
--- a/drivers/video/pxafb.h
+++ b/drivers/video/pxafb.h
@@ -106,7 +106,7 @@ struct pxafb_info {
 
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

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
