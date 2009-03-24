Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZCXVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZCXVRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZCXVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:32 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:37968 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZCXVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z0kQRTrBibQXIfBAG1+mc5V1VS2UvKbCPkimOwcqhma0bN6ckHqUCLQNt6Dol7GTuO
         1R7OJNinxLsyCtuYOWoEn6hJzjT8DjLSR8FEjZqY7lDgxOEuDuwLq2IDehcUZMMkyih7
         aMyvVJecxuaouHHATvyNTU8zEC2iy5dYGuz68=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:47 -0500
Message-Id: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/media/dvb/bt8xx/dst_ca.c |    7 +++++--
 drivers/media/video/dabusb.c     |   11 ++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 0258451..d3487c5 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -552,8 +552,10 @@ free_mem_and_exit:
 	return result;
 }
 
-static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long ioctl_arg)
+static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioctl_arg)
 {
+	lock_kernel();
+
 	struct dvb_device* dvbdev = (struct dvb_device*) file->private_data;
 	struct dst_state* state = (struct dst_state*) dvbdev->priv;
 	struct ca_slot_info *p_ca_slot_info;
@@ -647,6 +649,7 @@ static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 	kfree (p_ca_slot_info);
 	kfree (p_ca_caps);
 
+	unlock_kernel();
 	return result;
 }
 
@@ -684,7 +687,7 @@ static ssize_t dst_ca_write(struct file *file, const char __user *buffer, size_t
 
 static struct file_operations dst_ca_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = dst_ca_ioctl,
+	.unlocked_ioctl = dst_ca_ioctl,
 	.open = dst_ca_open,
 	.release = dst_ca_release,
 	.read = dst_ca_read,
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 298810d..ae4cd79 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -657,8 +657,9 @@ static int dabusb_release (struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
 {
+	lock_kernel();
 	pdabusb_t s = (pdabusb_t) file->private_data;
 	pbulk_transfer_t pbulk;
 	int ret = 0;
@@ -666,13 +667,16 @@ static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cm
 
 	dbg("dabusb_ioctl");
 
-	if (s->remove_pending)
+	if (s->remove_pending) {
+		unlock_kernel();
 		return -EIO;
+	}
 
 	mutex_lock(&s->mutex);
 
 	if (!s->usbdev) {
 		mutex_unlock(&s->mutex);
+		unlock_kernel();
 		return -EIO;
 	}
 
@@ -713,6 +717,7 @@ static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cm
 		break;
 	}
 	mutex_unlock(&s->mutex);
+	unlock_kernel();
 	return ret;
 }
 
@@ -721,7 +726,7 @@ static const struct file_operations dabusb_fops =
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.read =		dabusb_read,
-	.ioctl =	dabusb_ioctl,
+	.unlocked_ioctl =	dabusb_ioctl,
 	.open =		dabusb_open,
 	.release =	dabusb_release,
 };
-- 
1.6.2

