Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYHZXPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYHZXPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYHZXPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:15:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:55774 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYHZXPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:15:34 -0400
Date: Tue, 26 Aug 2008 17:15:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, hjk@linutronix.de
Subject: [PATCH, RFC] uio BKL removal
Message-ID: <20080826171532.2414c7a2@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a moment to dedicate to the BKL removal cause, so I went for the
UIO driver, which seemed simple.  The main thing I found was that there
was locking around some idr accesses, but not all, so I filled that
in.  With that in place, removing the BKL from uio_open() seems safe,
especially since none of the in-tree UIO drivers have open() or
release() methods.  

(Incidentally, I don't see how uio_pdrv.c could ever work - who initializes
uioinfo?)

If there's no complaints, I'll feed this into linux-next via the
bkl-removal tree.

Thanks,

jon

---
UIO: BKL removal

Remove the BKL from the UIO driver, and add complete locking where needed
to serialize idr accesses.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3a6934b..4f28f4b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -47,6 +47,9 @@ static struct uio_class {
 	struct class *class;
 } *uio_class;
 
+/* Protect idr accesses */
+static DEFINE_MUTEX(minor_lock);
+
 /*
  * attributes
  */
@@ -231,7 +234,6 @@ static void uio_dev_del_attributes(struct uio_device *idev)
 
 static int uio_get_minor(struct uio_device *idev)
 {
-	static DEFINE_MUTEX(minor_lock);
 	int retval = -ENOMEM;
 	int id;
 
@@ -253,7 +255,9 @@ exit:
 
 static void uio_free_minor(struct uio_device *idev)
 {
+	mutex_lock(&minor_lock);
 	idr_remove(&uio_idr, idev->minor);
+	mutex_unlock(&minor_lock);
 }
 
 /**
@@ -297,8 +301,9 @@ static int uio_open(struct inode *inode, struct file *filep)
 	struct uio_listener *listener;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&minor_lock);
 	idev = idr_find(&uio_idr, iminor(inode));
+	mutex_unlock(&minor_lock);
 	if (!idev) {
 		ret = -ENODEV;
 		goto out;
@@ -324,18 +329,15 @@ static int uio_open(struct inode *inode, struct file *filep)
 		if (ret)
 			goto err_infoopen;
 	}
-	unlock_kernel();
 	return 0;
 
 err_infoopen:
-
 	kfree(listener);
-err_alloc_listener:
 
+err_alloc_listener:
 	module_put(idev->owner);
 
 out:
-	unlock_kernel();
 	return ret;
 }
 
