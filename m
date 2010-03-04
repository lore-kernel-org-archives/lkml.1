Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0CDRU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:20:27 -0500
Received: from [206.15.93.42] ([206.15.93.42]:26672 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932078Ab0CDRUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:20:25 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: make copy_{to/from}_user and put_user typesafe
Date: Thu, 4 Mar 2010 10:20:18 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003041020.19046.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the kernel to user space data transfers typesafe and removes
a number of unnecessary (void *) casts.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..76c9d94 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -528,6 +528,7 @@ static int dt3155_ioctl(struct inode *inode,
 			unsigned long arg)
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
+  void __user *up = (void __user *)arg;
 
   if ( minor >= MAXBOARDS || minor < 0 )
     return -ENODEV;
@@ -554,7 +555,7 @@ static int dt3155_ioctl(struct inode *inode,
 
 	{
 	  struct dt3155_config_s tmp;
-	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
+	  if (copy_from_user(&tmp, up, sizeof(tmp)))
 	      return -EFAULT;
 	  /* check for valid settings */
 	  if (tmp.rows > DT3155_MAX_ROWS ||
@@ -572,8 +573,7 @@ static int dt3155_ioctl(struct inode *inode,
       }
     case DT3155_GET_CONFIG:
       {
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
-		     sizeof(dt3155_status_t) ))
+	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
 	    return -EFAULT;
 	return 0;
       }
@@ -593,8 +593,7 @@ static int dt3155_ioctl(struct inode *inode,
 	  return 0;
 
 	quick_stop(minor);
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
-		     sizeof(dt3155_status_t)))
+	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
 	    return -EFAULT;
 	return 0;
       }
@@ -617,8 +616,7 @@ static int dt3155_ioctl(struct inode *inode,
 	  }
 
 	dt3155_init_isr(minor);
-	if (copy_to_user( (void *) arg, (void *) &dt3155_status[minor],
-		      sizeof(dt3155_status_t)))
+	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
 	    return -EFAULT;
 	return 0;
       }
@@ -819,11 +817,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /* make this an offset */
   offset = frame_info_p->addr - dt3155_status[minor].mem_addr;
 
-  put_user(offset, (unsigned int *) buf);
+  put_user(offset, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
+  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user(dt3155_status[minor].state, (unsigned int *) buf);
+  put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
   buf += sizeof(u32);
   if (copy_to_user(buf, frame_info_p, sizeof(frame_info_t)))
       return -EFAULT;
