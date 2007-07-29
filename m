Return-Path: <linux-kernel-owner+w=401wt.eu-S937187AbXG2Vl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937187AbXG2Vl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbXG2VlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:41:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:40942
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752446AbXG2VlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:41:18 -0400
Date: Sun, 29 Jul 2007 23:41:05 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/5] Use mutex instead of semaphore in ISDN subsystem common functions
Message-ID: <20070729214105.GG3432@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	kkeil@suse.de, kai.germaschewski@gmx.de,
	isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070729212909.GC3432@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729212909.GC3432@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ISDN subsystem common functions use a semaphore as mutex. Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index c97330b..a5d3db4 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1364,7 +1364,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				} else {
 					s = NULL;
 				}
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_new(s, NULL))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1374,7 +1374,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					}
 				} else
 					ret = -ENODEV;
-				up(&dev->sem);
+				mutex_unlock(&dev->mtx);
 				return ret;
 			case IIOCNETASL:
 				/* Add a slave to a network-interface */
@@ -1383,7 +1383,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 						return -EFAULT;
 				} else
 					return -EINVAL;
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_newslave(bname))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1393,17 +1393,17 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 					}
 				} else
 					ret = -ENODEV;
-				up(&dev->sem);
+				mutex_unlock(&dev->mtx);
 				return ret;
 			case IIOCNETDIF:
 				/* Delete a network-interface */
 				if (arg) {
 					if (copy_from_user(name, argp, sizeof(name)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_rm(name);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1432,10 +1432,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_addphone(&phone);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1444,10 +1444,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_getphones(&phone, argp);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1456,10 +1456,10 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_delphone(&phone);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -2303,7 +2303,7 @@ static int __init isdn_init(void)
 #ifdef MODULE
 	dev->owner = THIS_MODULE;
 #endif
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mtx);
 	init_waitqueue_head(&dev->info_waitq);
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 		dev->drvmap[i] = -1;
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 3c7875b..5a77203 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -15,6 +15,7 @@
 #define __ISDN_H__
 
 #include <linux/ioctl.h>
+#include <linux/mutex.h>
 
 #ifdef CONFIG_COBALT_MICRO_SERVER
 /* Save memory */
@@ -624,7 +625,7 @@ typedef struct isdn_devt {
 	int               v110emu[ISDN_MAX_CHANNELS]; /* V.110 emulator-mode 0=none */
 	atomic_t          v110use[ISDN_MAX_CHANNELS]; /* Usage-Semaphore for stream */
 	isdn_v110_stream  *v110[ISDN_MAX_CHANNELS];   /* V.110 private data         */
-	struct semaphore  sem;                        /* serialize list access*/
+	struct mutex      mtx;                        /* serialize list access*/
 	unsigned long     global_features;
 } isdn_dev;
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera.
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
