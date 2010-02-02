Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0BBOAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:00:05 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56901 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab0BBN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=mtH7oyXGWnV4xJ34uWm++AIOz727FlN0l9O+hQdlLAmjXCT6317/RrJKUvp4wnsbov
         1nY/77S6do1boqG+y6NJebifseMydRy75LUkwEfD2YwaGP4FtbtsAZuOqSmYhGDrJOkg
         /vooSdJAEnyeEidcpsAMp34EaJusvePP7CS2A=
From: Alessio Igor Bogani <abogani@texware.it>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alessio Igor Bogani <abogani@texware.it>,
       Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] USB: ftdi_sio: Remove BKL
Date: Tue,  2 Feb 2010 14:58:14 +0100
Message-Id: <1265119094-3356-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to me that BKL don't protect nothing here anymore. So I would want suggest to remove it.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/usb/serial/ftdi_sio.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 216f187..592dc5f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -33,7 +33,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
@@ -1210,7 +1209,6 @@ static int set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
 		return -EFAULT;
 
-	lock_kernel();
 	old_priv = *priv;
 
 	/* Do error checking and permission checking */
@@ -1218,7 +1216,6 @@ static int set_serial_info(struct tty_struct *tty,
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (priv->flags & ~ASYNC_USR_MASK))) {
-			unlock_kernel();
 			return -EPERM;
 		}
 		priv->flags = ((priv->flags & ~ASYNC_USR_MASK) |
@@ -1229,7 +1226,6 @@ static int set_serial_info(struct tty_struct *tty,
 
 	if ((new_serial.baud_base != priv->baud_base) &&
 	    (new_serial.baud_base < 9600)) {
-	    	unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -1259,11 +1255,8 @@ check_and_exit:
 	     (priv->flags & ASYNC_SPD_MASK)) ||
 	    (((priv->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) &&
 	     (old_priv.custom_divisor != priv->custom_divisor))) {
-		unlock_kernel();
 		change_speed(tty, port);
 	}
-	else
-		unlock_kernel();
 	return 0;
 
 } /* set_serial_info */
-- 
1.6.3.3

