Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbYEVWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbYEVWAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760249AbYEVWAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:00:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756451AbYEVWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:00:00 -0400
Date: Thu, 22 May 2008 22:47:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] rio100: Push down the BKL
Message-ID: <20080522224731.10cdac01@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is actually probably not needed as the mutex seems sufficient. If
so then a further patch to drop it would be a good followup.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 330c18e..248a12a 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -104,9 +104,7 @@ static int close_rio(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
-ioctl_rio(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct RioCommand rio_cmd;
 	struct rio_usb_data *rio = &rio_instance;
@@ -116,6 +114,7 @@ ioctl_rio(struct inode *inode, struct file *file, unsigned int cmd,
 	int retries;
 	int retval=0;
 
+	lock_kernel();
 	mutex_lock(&(rio->lock));
         /* Sanity check to make sure rio is connected, powered, etc */
         if (rio->present == 0 || rio->rio_dev == NULL) {
@@ -254,6 +253,7 @@ ioctl_rio(struct inode *inode, struct file *file, unsigned int cmd,
 
 err_out:
 	mutex_unlock(&(rio->lock));
+	unlock_kernel();
 	return retval;
 }
 
@@ -433,7 +433,7 @@ file_operations usb_rio_fops = {
 	.owner =	THIS_MODULE,
 	.read =		read_rio,
 	.write =	write_rio,
-	.ioctl =	ioctl_rio,
+	.unlocked_ioctl = ioctl_rio,
 	.open =		open_rio,
 	.release =	close_rio,
 };
