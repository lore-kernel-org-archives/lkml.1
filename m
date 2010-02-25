Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab0BYWGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:06:00 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52478 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab0BYWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ntSPgw+wZvV3mm+Y6Cf996GjkGSyRgLyfDTgFfuxqU3tjR7ijS8J1s4PoVJapCDwXk
         JwaM9VoKkefRld5KF7weH4lJln9jMkNYneCCPcLzqKLQyTtTj1D5dY49m4bZcwEg4kb8
         5tlQzvDX3/LYJQ3AqSbextoFI0JRZsmKYB6lU=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Tanaka Akira <akr@fsij.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] sisusbvga: Remove the BKL from ioctl
Date: Thu, 25 Feb 2010 23:04:59 +0100
Message-Id: <1267135499-21427-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to me that BKL is not needed here because necessary locking is already
provided by mutex sisusb->lock.

Also change the returned value to long.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 8b37a4b..79b4175 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -47,7 +47,6 @@
 #include <linux/spinlock.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 
 #include "sisusb.h"
@@ -2964,13 +2963,12 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct sisusb_usb_data *sisusb;
 	struct sisusb_info x;
 	struct sisusb_command y;
-	int	retval = 0;
+	long retval = 0;
 	u32 __user *argp = (u32 __user *)arg;
 
 	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
 		return -ENODEV;
 
-	lock_kernel();
 	mutex_lock(&sisusb->lock);
 
 	/* Sanity check */
@@ -3029,7 +3027,6 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 err_out:
 	mutex_unlock(&sisusb->lock);
-	unlock_kernel();
 	return retval;
 }
 
-- 
1.6.3.3

