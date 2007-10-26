Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbXJZSe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbXJZSe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbXJZSeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:34:16 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:35249 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958AbXJZSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:34:14 -0400
Date: Fri, 26 Oct 2007 20:34:19 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Parallel port: Convert port_mutex to the mutex API
Message-ID: <20071026183419.GP9824@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parallel port: Convert port_mutex to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index c59e2a0..60aecf9 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -312,7 +312,7 @@ static ssize_t lp_write(struct file * file, const char __user * buf,
 	if (copy_size > LP_BUFFER_SIZE)
 		copy_size = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	if (copy_from_user (kbuf, buf, copy_size)) {
@@ -399,7 +399,7 @@ static ssize_t lp_write(struct file * file, const char __user * buf,
 		lp_release_parport (&lp_table[minor]);
 	}
 out_unlock:
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock (&lp_table[minor].port_mutex);
 
  	return retv;
 }
@@ -421,7 +421,7 @@ static ssize_t lp_read(struct file * file, char __user * buf,
 	if (count > LP_BUFFER_SIZE)
 		count = LP_BUFFER_SIZE;
 
-	if (down_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	lp_claim_parport_or_block (&lp_table[minor]);
@@ -479,7 +479,7 @@ static ssize_t lp_read(struct file * file, char __user * buf,
 	if (retval > 0 && copy_to_user (buf, kbuf, retval))
 		retval = -EFAULT;
 
-	up (&lp_table[minor].port_mutex);
+	mutex_unlock (&lp_table[minor].port_mutex);
 
 	return retval;
 }
@@ -889,7 +889,7 @@ static int __init lp_init (void)
 		lp_table[i].last_error = 0;
 		init_waitqueue_head (&lp_table[i].waitq);
 		init_waitqueue_head (&lp_table[i].dataq);
-		init_MUTEX (&lp_table[i].port_mutex);
+		mutex_init (&lp_table[i].port_mutex);
 		lp_table[i].timeout = 10 * HZ;
 	}
 
diff --git a/include/linux/lp.h b/include/linux/lp.h
index 7059b6b..0df024b 100644
--- a/include/linux/lp.h
+++ b/include/linux/lp.h
@@ -99,7 +99,7 @@
 #ifdef __KERNEL__
 
 #include <linux/wait.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 /* Magic numbers for defining port-device mappings */
 #define LP_PARPORT_UNSPEC -4
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
Matthias Kaehlcke
Linux Application Developer
Barcelona

       The yellow ships hung in the air just like bricks dont do
                 (The Hitch-Hiker's Guide to the Galaxy)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
