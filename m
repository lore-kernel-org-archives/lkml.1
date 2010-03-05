Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0CEWYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:24:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:44179 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0CEWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=R5f07AuctxfttUbHkg/KtN24YQJBl9daXPQLMTCCJJMDy8bBP4ozYcZc4d6uIhRJEv
         fvfGwHRuCPhWGrwHItrLM5TQhYqyTKGx08iuQkWf/3WAcLMRNB8HlByJRW4aTFtyRmFN
         vCMSW3uWkV7ezanJHEpUPhVEhUW1eTU0Mx4mQ=
Date: Sat, 6 Mar 2010 06:23:47 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, petr@vmware.com,
       Eli Collins <ecollins@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB vmware-7.0.1
Message-ID: <Pine.LNX.4.64.1003060621380.6420@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linux version v2.6.33-5399-gcc7889f with reiser3 and vmware-7.0.1

Starting vmware just hang even before displaying the main GUI. Reverting 
554f76962d3a6eb5110415f1591aca83f96a84ae solves the problem.

It seems vmware is trying to access the USB but this commit blocks it.

So, is this a vmware problem or shall this be reverted?


Thanks,
Jeff


commit 554f76962d3a6eb5110415f1591aca83f96a84ae
Author: Oliver Neukum <oliver@neukum.org>
Date:   Wed Jan 13 15:30:47 2010 +0100

     USB: Remove BKL from poll()

     Replace BKL with usbfs_mutex to protect a global counter
     and a per file data structure

     Signed-off-by: Oliver Neukum <oliver@neukum.org>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 355dffc..175529f 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -118,6 +118,7 @@ static const char *format_endpt =
   */

  static DECLARE_WAIT_QUEUE_HEAD(deviceconndiscwq);
+/* guarded by usbfs_mutex */
  static unsigned int conndiscevcnt;

  /* this struct stores the poll state for <mountpoint>/devices pollers */
@@ -156,7 +157,9 @@ static const struct class_info clas_info[] =

  void usbfs_conn_disc_event(void)
  {
+	mutex_lock(&usbfs_mutex);
  	conndiscevcnt++;
+	mutex_unlock(&usbfs_mutex);
  	wake_up(&deviceconndiscwq);
  }

@@ -629,42 +632,29 @@ static ssize_t usb_device_read(struct file *file, char 
__user *buf,
  static unsigned int usb_device_poll(struct file *file,
  				    struct poll_table_struct *wait)
  {
-	struct usb_device_status *st = file->private_data;
+	struct usb_device_status *st;
  	unsigned int mask = 0;

-	lock_kernel();
+	mutex_lock(&usbfs_mutex);
+	st = file->private_data;
  	if (!st) {
  		st = kmalloc(sizeof(struct usb_device_status), GFP_KERNEL);
-
-		/* we may have dropped BKL -
-		 * need to check for having lost the race */
-		if (file->private_data) {
-			kfree(st);
-			st = file->private_data;
-			goto lost_race;
-		}
-		/* we haven't lost - check for allocation failure now */
  		if (!st) {
-			unlock_kernel();
+			mutex_unlock(&usbfs_mutex);
  			return POLLIN;
  		}

-		/*
-		 * need to prevent the module from being unloaded, since
-		 * proc_unregister does not call the release method and
-		 * we would have a memory leak
-		 */
  		st->lastev = conndiscevcnt;
  		file->private_data = st;
  		mask = POLLIN;
  	}
-lost_race:
+
  	if (file->f_mode & FMODE_READ)
  		poll_wait(file, &deviceconndiscwq, wait);
  	if (st->lastev != conndiscevcnt)
  		mask |= POLLIN;
  	st->lastev = conndiscevcnt;
-	unlock_kernel();
+	mutex_unlock(&usbfs_mutex);
  	return mask;
  }

