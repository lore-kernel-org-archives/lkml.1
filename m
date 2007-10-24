Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXJXOsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXJXOsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXJXOsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:48:43 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56102 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbXJXOsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:48:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: USB: FIx locks and urb->status in adutux
Date: Wed, 24 Oct 2007 16:49:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-usb-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au
References: <20071022203447.db6d7950.zaitcev@redhat.com> <200710231138.38266.oliver@neukum.org> <20071023185302.5ce9d187.zaitcev@redhat.com>
In-Reply-To: <20071023185302.5ce9d187.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241649.13257.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 24 Oktober 2007 schrieb Pete Zaitcev:
> Oliver, thanks for the inftdata catch. I also fixed the sleep_on.

But you are leaving a function while still on a waitqueue left on the stack.
Here's a patch on top of yours.

	Regards
		Oliver

----

--- work/drivers/usb/misc/adutux.c.alt	2007-10-24 16:36:02.000000000 +0200
+++ work/drivers/usb/misc/adutux.c	2007-10-24 16:36:06.000000000 +0200
@@ -567,19 +567,21 @@ static ssize_t adu_write(struct file *fi
 
 	retval = mutex_lock_interruptible(&dev->mtx);
 	if (retval)
-		goto exit_nolock;
+		goto exit_nolock_intr;
 
 	/* verify that the device wasn't unplugged */
 	if (dev->udev == NULL) {
+		mutex_unlock(&dev->mtx);
 		retval = -ENODEV;
 		err("No device or device unplugged %d", retval);
-		goto exit;
+		goto exit_nolock_intr;
 	}
 
 	/* verify that we actually have some data to write */
 	if (count == 0) {
+		mutex_unlock(&dev->mtx);
 		dbg(1," %s : write request of 0 bytes", __FUNCTION__);
-		goto exit;
+		goto exit_nolock_intr;
 	}
 
 	add_wait_queue(&dev->write_wait, &waita);
@@ -649,13 +651,14 @@ static ssize_t adu_write(struct file *fi
 			bytes_written += bytes_to_write;
 		}
 	}
-	remove_wait_queue(&dev->write_wait, &waita);
 
 	retval = bytes_written;
 
 exit:
 	mutex_unlock(&dev->mtx);
 exit_nolock:
+	remove_wait_queue(&dev->write_wait, &waita);
+exit_nolock_intr:
 
 	dbg(2," %s : leave, return value %d", __FUNCTION__, retval);
 
