Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYBRUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYBRUt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBRUtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:49:17 -0500
Received: from mx1.riseup.net ([204.13.164.18]:53880 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYBRUtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:49:16 -0500
Message-Id: <20080218194533.903955589@kaehlcke.net>
References: <20080218194533.185137318@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 20:45:35 +0100
From: matthias@kaehlcke.net
To: wolfgang@iksw-muees.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 2/3] Convert ccp->readmutex in a mutex
Content-Disposition: inline; filename=usb-misc-auerswald-ccp_readmutex-to-mutex.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore ccp->readmutex is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/usb/misc/auerswald.c
===================================================================
--- linux-2.6.orig/drivers/usb/misc/auerswald.c	2008-02-18 20:12:55.000000000 +0100
+++ linux-2.6/drivers/usb/misc/auerswald.c	2008-02-18 20:10:00.000000000 +0100
@@ -259,7 +259,7 @@
         auerbufctl_t bufctl;            /* controls the buffer chain */
         auerscon_t scontext;            /* service context */
 	wait_queue_head_t readwait;     /* for synchronous reading */
-	struct semaphore readmutex;     /* protection against multiple reads */
+	struct mutex readmutex;		/* protection against multiple reads */
 	pauerbuf_t readbuf;		/* buffer held for partial reading */
 	unsigned int readoffset;	/* current offset in readbuf */
 	unsigned int removed;		/* is != 0 if device is removed */
@@ -1391,7 +1391,7 @@
 
 	/* Initialize device descriptor */
 	init_MUTEX( &ccp->mutex);
-	init_MUTEX( &ccp->readmutex);
+	mutex_init(&ccp->readmutex);
         auerbuf_init (&ccp->bufctl);
         ccp->scontext.id = AUH_UNASSIGNED;
         ccp->scontext.dispatch = auerchar_ctrlread_dispatch;
@@ -1585,7 +1585,7 @@
 	}
 
 	/* only one reader per device allowed */
-	if (down_interruptible (&ccp->readmutex)) {
+	if (mutex_lock_interruptible(&ccp->readmutex)) {
 		up (&ccp->mutex);
 		return -ERESTARTSYS;
 	}
@@ -1603,7 +1603,7 @@
 		if (count) {
 			if (copy_to_user (buf, bp->bufp+ccp->readoffset, count)) {
 				dbg ("auerswald_read: copy_to_user failed");
-				up (&ccp->readmutex);
+				mutex_unlock(&ccp->readmutex);
 				up (&ccp->mutex);
 				return -EFAULT;
 			}
@@ -1618,7 +1618,7 @@
 		}
 		/* return with number of bytes read */
 		if (count) {
-			up (&ccp->readmutex);
+			mutex_unlock(&ccp->readmutex);
 			up (&ccp->mutex);
 			return count;
 		}
@@ -1655,7 +1655,7 @@
                 dbg ("No read buffer available, returning -EAGAIN");
 		set_current_state (TASK_RUNNING);
 		remove_wait_queue (&ccp->readwait, &wait);
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		up (&ccp->mutex);
 		return -EAGAIN;  /* nonblocking, no data available */
         }
@@ -1666,18 +1666,18 @@
 	remove_wait_queue (&ccp->readwait, &wait);
 	if (signal_pending (current)) {
 		/* waked up by a signal */
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
 
 	/* Anything left to read? */
 	if ((ccp->scontext.id == AUH_UNASSIGNED) || ccp->removed) {
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -EIO;
 	}
 
 	if (down_interruptible (&ccp->mutex)) {
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
 

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
