Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbYBRUlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbYBRUlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYBRUkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:40:49 -0500
Received: from mx1.riseup.net ([204.13.164.18]:45588 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYBRUks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:40:48 -0500
Message-Id: <20080218194534.283634243@kaehlcke.net>
References: <20080218194533.185137318@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 20:45:36 +0100
From: matthias@kaehlcke.net
To: wolfgang@iksw-muees.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 3/3] Convert ccp->mutex in a mutex
Content-Disposition: inline; filename=usb-misc-auerswald-ccp_mutex-to-mutex.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore ccp->mutex is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/usb/misc/auerswald.c
===================================================================
--- linux-2.6.orig/drivers/usb/misc/auerswald.c	2008-02-18 20:17:08.000000000 +0100
+++ linux-2.6/drivers/usb/misc/auerswald.c	2008-02-18 20:28:02.000000000 +0100
@@ -254,7 +254,7 @@
 /* character device context */
 typedef struct
 {
-	struct semaphore mutex;         /* protection in user context */
+	struct mutex mutex;		/* protection in user context */
 	pauerswald_t auerdev;           /* context pointer of assigned device */
         auerbufctl_t bufctl;            /* controls the buffer chain */
         auerscon_t scontext;            /* service context */
@@ -1390,7 +1390,7 @@
 	}
 
 	/* Initialize device descriptor */
-	init_MUTEX( &ccp->mutex);
+	mutex_init(&ccp->mutex);
 	mutex_init(&ccp->readmutex);
         auerbuf_init (&ccp->bufctl);
         ccp->scontext.id = AUH_UNASSIGNED;
@@ -1433,23 +1433,23 @@
         dbg ("ioctl");
 
 	/* get the mutexes */
-	if (down_interruptible (&ccp->mutex)) {
+	if (mutex_lock_interruptible(&ccp->mutex)) {
 		return -ERESTARTSYS;
 	}
 	cp = ccp->auerdev;
 	if (!cp) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -ENODEV;
 	}
 	if (mutex_lock_interruptible(&cp->mutex)) {
-		up(&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 
 	/* Check for removal */
 	if (!cp->usbdev) {
 		mutex_unlock(&cp->mutex);
-		up(&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -ENODEV;
 	}
 
@@ -1552,7 +1552,7 @@
         }
 	/* release the mutexes */
 	mutex_unlock(&cp->mutex);
-	up(&ccp->mutex);
+	mutex_unlock(&ccp->mutex);
 	return ret;
 }
 
@@ -1575,18 +1575,18 @@
 		return 0;
 
 	/* get the mutex */
-	if (down_interruptible (&ccp->mutex))
+	if (mutex_lock_interruptible(&ccp->mutex))
 		return -ERESTARTSYS;
 
 	/* Can we expect to read something? */
 	if (ccp->scontext.id == AUH_UNASSIGNED) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -EIO;
 	}
 
 	/* only one reader per device allowed */
 	if (mutex_lock_interruptible(&ccp->readmutex)) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 
@@ -1604,7 +1604,7 @@
 			if (copy_to_user (buf, bp->bufp+ccp->readoffset, count)) {
 				dbg ("auerswald_read: copy_to_user failed");
 				mutex_unlock(&ccp->readmutex);
-				up (&ccp->mutex);
+				mutex_unlock(&ccp->mutex);
 				return -EFAULT;
 			}
 		}
@@ -1619,7 +1619,7 @@
 		/* return with number of bytes read */
 		if (count) {
 			mutex_unlock(&ccp->readmutex);
-			up (&ccp->mutex);
+			mutex_unlock(&ccp->mutex);
 			return count;
 		}
 	}
@@ -1656,12 +1656,12 @@
 		set_current_state (TASK_RUNNING);
 		remove_wait_queue (&ccp->readwait, &wait);
 		mutex_unlock(&ccp->readmutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EAGAIN;  /* nonblocking, no data available */
         }
 
 	/* yes, we should wait! */
-	up (&ccp->mutex); /* allow other operations while we wait */
+	mutex_unlock(&ccp->mutex); /* allow other operations while we wait */
 	schedule();
 	remove_wait_queue (&ccp->readwait, &wait);
 	if (signal_pending (current)) {
@@ -1676,7 +1676,7 @@
 		return -EIO;
 	}
 
-	if (down_interruptible (&ccp->mutex)) {
+	if (mutex_lock_interruptible(&ccp->mutex)) {
 		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
@@ -1708,27 +1708,27 @@
 
 write_again:
 	/* get the mutex */
-	if (down_interruptible (&ccp->mutex))
+	if (mutex_lock_interruptible(&ccp->mutex))
 		return -ERESTARTSYS;
 
 	/* Can we expect to write something? */
 	if (ccp->scontext.id == AUH_UNASSIGNED) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -EIO;
 	}
 
 	cp = ccp->auerdev;
 	if (!cp) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 	if (mutex_lock_interruptible(&cp->mutex)) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 	if (!cp->usbdev) {
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EIO;
 	}
 	/* Prepare for sleep */
@@ -1752,7 +1752,7 @@
 	/* are there any buffers left? */
 	if (!bp) {
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 
 		/* NONBLOCK: don't wait */
 		if (file->f_flags & O_NONBLOCK) {
@@ -1785,7 +1785,7 @@
 		/* Wake up all processes waiting for a buffer */
 		wake_up (&cp->bufferwait);
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EFAULT;
 	}
 
@@ -1810,12 +1810,12 @@
 		auerbuf_releasebuf (bp);
 		/* Wake up all processes waiting for a buffer */
 		wake_up (&cp->bufferwait);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EIO;
 	}
 	else {
 		dbg ("auerchar_write: Write OK");
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return len;
 	}
 }
@@ -1828,7 +1828,7 @@
 	pauerswald_t cp;
 	dbg("release");
 
-	down(&ccp->mutex);
+	mutex_lock(&ccp->mutex);
 	cp = ccp->auerdev;
 	if (cp) {
 		mutex_lock(&cp->mutex);
@@ -1845,7 +1845,7 @@
 		cp = NULL;
 		ccp->auerdev = NULL;
 	}
-	up (&ccp->mutex);
+	mutex_unlock(&ccp->mutex);
 	auerchar_delete (ccp);
 
 	return 0;

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
