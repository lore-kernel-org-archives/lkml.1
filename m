Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0CEWst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:48:49 -0500
Received: from fep02.xtra.co.nz ([210.54.141.244]:48699 "EHLO fep02.xtra.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0CEWss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:48:48 -0500
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 17:48:47 EST
Date: Sat, 6 Mar 2010 06:18:17 +0800 (SGT)
From: Jeff Chua <jeff.tw.chua@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, petr@vmware.com,
       Eli Collins <ecollins@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for vmware
 7.0.1
Message-ID: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>
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

@@ -629,42 +632,29 @@ static ssize_t usb_device_read(struct file *file, char __user *buf,
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

