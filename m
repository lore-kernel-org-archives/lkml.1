Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0BBPSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:18:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:64339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0BBPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=w4egEYxp1n2PP2j8doG4j2Kz0BTq6LcmFGXi5UpJi5AdN4Ed/E6X/SF3Y9K0u7eR8c
         VbhfiGjuBYO3Gm7SKzYKM9nd9u3RtF/gLazPFV3Fcw2I5klP/vO+d2HaRevmSUlUOYWC
         XLSx1dmIRCwCtxaY7va9Cxw/yBRCh7wa78Hu4=
From: Alessio Igor Bogani <abogani@texware.it>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alessio Igor Bogani <abogani@texware.it>,
       Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] USB: ftdi_sio: Replace BKL with a mutex
Date: Tue,  2 Feb 2010 16:18:28 +0100
Message-Id: <1265123908-17092-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100202141320.38e89229@lxorguk.ukuu.org.uk>
References: <20100202141320.38e89229@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Alan Cox have pinpointed the driver still required protection against
parallels calls to the config ioctl(). If lock is still necessary the use of
BKL is abused here. So replace BKL with a more convenient mutex.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/usb/serial/ftdi_sio.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 216f187..23d3de7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -33,12 +33,12 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/serial.h>
@@ -92,6 +92,7 @@ struct ftdi_private {
 	unsigned long tx_outstanding_bytes;
 	unsigned long tx_outstanding_urbs;
 	unsigned short max_packet_size;
+	struct mutex cfg_lock; /* Avoid mess by parallel calls of config ioctl() */
 };
 
 /* struct ftdi_sio_quirk is used by devices requiring special attention. */
@@ -1210,7 +1211,7 @@ static int set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
 		return -EFAULT;
 
-	lock_kernel();
+	mutex_lock(&priv->cfg_lock);
 	old_priv = *priv;
 
 	/* Do error checking and permission checking */
@@ -1218,7 +1219,7 @@ static int set_serial_info(struct tty_struct *tty,
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (priv->flags & ~ASYNC_USR_MASK))) {
-			unlock_kernel();
+			mutex_unlock(&priv->cfg_lock);
 			return -EPERM;
 		}
 		priv->flags = ((priv->flags & ~ASYNC_USR_MASK) |
@@ -1229,7 +1230,7 @@ static int set_serial_info(struct tty_struct *tty,
 
 	if ((new_serial.baud_base != priv->baud_base) &&
 	    (new_serial.baud_base < 9600)) {
-	    	unlock_kernel();
+		mutex_unlock(&priv->cfg_lock);
 		return -EINVAL;
 	}
 
@@ -1259,11 +1260,11 @@ check_and_exit:
 	     (priv->flags & ASYNC_SPD_MASK)) ||
 	    (((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) &&
 	     (old_priv.custom_divisor != priv->custom_divisor))) {
-		unlock_kernel();
+		mutex_unlock(&priv->cfg_lock);
 		change_speed(tty, port);
 	}
 	else
-		unlock_kernel();
+		mutex_unlock(&priv->cfg_lock);
 	return 0;
 
 } /* set_serial_info */
@@ -1532,6 +1533,7 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 
 	kref_init(&priv->kref);
 	spin_lock_init(&priv->tx_lock);
+	mutex_init(&priv->cfg_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
 	/* This will push the characters through immediately rather
 	   than queue a task to deliver them */
-- 
1.6.3.3

