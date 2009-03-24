Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZCXVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZCXVPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZCXVNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:53122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZCXVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R6l8+/hD+MLO/EbSSpENilpCHFIGdkyV4eKehalR8WkdEgUxR2NSOwfQsGr5Fz1Qt6
         TMB9Rx8qfdvejYdn4Hfv5Wu430xcBK/0LyWwNnVfjOsU+M83enMZpfOBn0pdN6SUhlQX
         5ZlfLxpmSrlDaVkQW5gsJTf+mxljjMgPbwTrs=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH 07/13] [usb] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:42 -0500
Message-Id: <1237929168-15341-8-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/usb/mon/mon_bin.c |   53 ++++++++++++++++++++++++++++++++------------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 4cf27c7..7789b7b 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -836,9 +836,10 @@ static int mon_bin_queued(struct mon_reader_bin *rp)
 
 /*
  */
-static int mon_bin_ioctl(struct inode *inode, struct file *file,
-    unsigned int cmd, unsigned long arg)
+static long mon_bin_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
+	lock_kernel();
 	struct mon_reader_bin *rp = file->private_data;
 	// struct mon_bus* mbus = rp->r.m_bus;
 	int ret = 0;
@@ -874,8 +875,10 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 		int size;
 		struct mon_pgmap *vec;
 
-		if (arg < BUFF_MIN || arg > BUFF_MAX)
+		if (arg < BUFF_MIN || arg > BUFF_MAX) {
+			unlock_kernel();
 			return -EINVAL;
+		}
 
 		size = CHUNK_ALIGN(arg);
 		if ((vec = kzalloc(sizeof(struct mon_pgmap) * (size/CHUNK_SIZE),
@@ -912,11 +915,15 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 		struct mon_bin_get getb;
 
 		if (copy_from_user(&getb, (void __user *)arg,
-					    sizeof(struct mon_bin_get)))
+					    sizeof(struct mon_bin_get))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
-		if (getb.alloc > 0x10000000)	/* Want to cast to u32 */
+		if (getb.alloc > 0x10000000) {	/* Want to cast to u32 */
+			unlock_kernel();
 			return -EINVAL;
+		}
 		ret = mon_bin_get_event(file, rp,
 			  getb.hdr, getb.data, (unsigned int)getb.alloc);
 		}
@@ -929,21 +936,31 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 
 		uptr = (struct mon_bin_mfetch __user *)arg;
 
-		if (copy_from_user(&mfetch, uptr, sizeof(mfetch)))
+		if (copy_from_user(&mfetch, uptr, sizeof(mfetch))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		if (mfetch.nflush) {
 			ret = mon_bin_flush(rp, mfetch.nflush);
-			if (ret < 0)
+			if (ret < 0) {
+				unlock_kernel();
 				return ret;
-			if (put_user(ret, &uptr->nflush))
+			}
+			if (put_user(ret, &uptr->nflush)) {
+				unlock_kernel();
 				return -EFAULT;
+			}
 		}
 		ret = mon_bin_fetch(file, rp, mfetch.offvec, mfetch.nfetch);
-		if (ret < 0)
+		if (ret < 0) {
+			unlock_kernel();
 			return ret;
-		if (put_user(ret, &uptr->nfetch))
+		}
+		if (put_user(ret, &uptr->nfetch)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 		ret = 0;
 		}
 		break;
@@ -960,18 +977,24 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 		nevents = mon_bin_queued(rp);
 
 		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
+		if (put_user(rp->cnt_lost, &sp->dropped)) {
+			unlock_kernel();
 			return -EFAULT;
-		if (put_user(nevents, &sp->queued))
+		}
+		if (put_user(nevents, &sp->queued)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		}
 		break;
 
 	default:
+		unlock_kernel();
 		return -ENOTTY;
 	}
 
+	unlock_kernel();
 	return ret;
 }
 
@@ -1026,14 +1049,14 @@ static long mon_bin_compat_ioctl(struct file *file,
 		return 0;
 
 	case MON_IOCG_STATS:
-		return mon_bin_ioctl(NULL, file, cmd,
+		return mon_bin_ioctl(file, cmd,
 					    (unsigned long) compat_ptr(arg));
 
 	case MON_IOCQ_URB_LEN:
 	case MON_IOCQ_RING_SIZE:
 	case MON_IOCT_RING_SIZE:
 	case MON_IOCH_MFLUSH:
-		return mon_bin_ioctl(NULL, file, cmd, arg);
+		return mon_bin_ioctl(file, cmd, arg);
 
 	default:
 		;
@@ -1117,7 +1140,7 @@ static const struct file_operations mon_fops_binary = {
 	.read =		mon_bin_read,
 	/* .write =	mon_text_write, */
 	.poll =		mon_bin_poll,
-	.ioctl =	mon_bin_ioctl,
+	.unlocked_ioctl =	mon_bin_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
-- 
1.6.2

