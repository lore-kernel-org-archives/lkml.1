Return-Path: <linux-kernel-owner+w=401wt.eu-S1031100AbXDYPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031100AbXDYPqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031102AbXDYPqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:46:39 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37318
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031100AbXDYPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:46:38 -0400
Date: Wed, 25 Apr 2007 17:49:34 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070425154934.GP6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/tty_io.c uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7a32df5..4496fd2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -137,7 +137,7 @@ EXPORT_SYMBOL(tty_mutex);
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
 extern int pty_limit;		/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_MUTEX(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
@@ -2471,9 +2471,9 @@ static void release_dev(struct file * filp)
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
 	if (devpts) {
-		down(&allocated_ptys_lock);
+		mutex_lock(&allocated_ptys_lock);
 		idr_remove(&allocated_ptys, idx);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 	}
 #endif
 
@@ -2639,24 +2639,24 @@ static int ptmx_open(struct inode * inode, struct file * filp)
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -ENOMEM;
 	}
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			return -ENOMEM;
 		return -EIO;
 	}
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
@@ -2681,9 +2681,9 @@ out1:
 	release_dev(filp);
 	return retval;
 out:
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, index);
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 	return retval;
 }
 #endif

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
