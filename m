Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbXL2BBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbXL2BBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXL2BAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:00:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXL2BAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:00:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=f9Ft5/3QAAnqYrhZ0wr5SzhmSl8XpEQn5KoZ7pvq6kNZiPov5xowNbyJw4QtWYml2oKaEw7Y0av0Rq6jW33SOP377g79Yv6ckL9gbQ9+T277jAPB0xQ7QL3H9V7e5yamz7/ltigYMyvWejHEXri1jm3s0qJt88QRERtd0ghESEE=
Date: Sat, 29 Dec 2007 09:04:35 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 02/12] Documentation : Use mutex instead of semaphore in
	driver core
Message-ID: <20071229010435.GC2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
Documentation/usb/power-management.txt |   14 +++++++-------
1 file changed, 7 insertions(+), 7 deletions(-)

diff -upr linux/Documentation/usb/power-management.txt linux.new/Documentation/usb/power-management.txt
--- linux/Documentation/usb/power-management.txt	2007-12-28 09:55:07.000000000 +0800
+++ linux.new/Documentation/usb/power-management.txt	2007-12-28 09:58:57.000000000 +0800
@@ -429,8 +429,8 @@ interface.
 
 All three suspend/resume methods are always called while holding the
 usb_device's PM mutex.  For external events -- but not necessarily for
-autosuspend or autoresume -- the device semaphore (udev->dev.sem) will
-also be held.  This implies that external suspend/resume events are
+autosuspend or autoresume -- the device mutex (udev->dev.mutex) will
+also be locked.  This implies that external suspend/resume events are
 mutually exclusive with calls to probe, disconnect, pre_reset, and
 post_reset; the USB core guarantees that this is true of internal
 suspend/resume events as well.
@@ -440,29 +440,29 @@ critical section, it can simply acquire 
 Alternatively, if the critical section might call some of the
 usb_autopm_* routines, the driver can avoid deadlock by doing:
 
-	down(&udev->dev.sem);
+	mutex_lock(&udev->dev.mutex);
 	rc = usb_autopm_get_interface(intf);
 
 and at the end of the critical section:
 
 	if (!rc)
 		usb_autopm_put_interface(intf);
-	up(&udev->dev.sem);
+	mutex_unlock(&udev->dev.mutex);
 
-Holding the device semaphore will block all external PM calls, and the
+Lock the device mutex will block all external PM calls, and the
 usb_autopm_get_interface() will prevent any internal PM calls, even if
 it fails.  (Exercise: Why?)
 
 The rules for locking order are:
 
-	Never acquire any device semaphore while holding any PM mutex.
+	Never acquire any device mutex while holding any PM mutex.
 
 	Never acquire udev->pm_mutex while holding the PM mutex for
 	a device that isn't a descendant of udev.
 
 In other words, PM mutexes should only be acquired going up the device
 tree, and they should be acquired only after locking all the device
-semaphores you need to hold.  These rules don't matter to drivers very
+mutexes.  These rules don't matter to drivers very
 much; they usually affect just the USB core.
 
 Still, drivers do need to be careful.  For example, many drivers use a
