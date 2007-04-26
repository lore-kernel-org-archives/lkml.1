Return-Path: <linux-kernel-owner+w=401wt.eu-S1031174AbXDZKyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031174AbXDZKyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031170AbXDZKyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:54:21 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:59617
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031177AbXDZKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:54:12 -0400
Date: Thu, 26 Apr 2007 12:57:05 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: kkeil@suse.de, kai.germaschewski@gmx.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in CAPI 2.0 interface
Message-ID: <20070426105705.GD6468@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	kkeil@suse.de, kai.germaschewski@gmx.de,
	isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the CAPI 2.0 interface uses a semaphore as mutex. use the mutex
API instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index db1260f..b260bdc 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -147,7 +147,7 @@ struct capidev {
 
 	struct capincci *nccis;
 
-	struct semaphore ncci_list_sem;
+	struct mutex ncci_list_mtx;
 };
 
 /* -------- global variables ---------------------------------------- */
@@ -395,7 +395,7 @@ static struct capidev *capidev_alloc(void)
 	if (!cdev)
 		return NULL;
 
-	init_MUTEX(&cdev->ncci_list_sem);
+	mutex_init(&cdev->ncci_list_mtx);
 	skb_queue_head_init(&cdev->recvqueue);
 	init_waitqueue_head(&cdev->recvwait);
 	write_lock_irqsave(&capidev_list_lock, flags);
@@ -414,9 +414,9 @@ static void capidev_free(struct capidev *cdev)
 	}
 	skb_queue_purge(&cdev->recvqueue);
 
-	down(&cdev->ncci_list_sem);
+	mutex_lock(&cdev->ncci_list_mtx);
 	capincci_free(cdev, 0xffffffff);
-	up(&cdev->ncci_list_sem);
+	mutex_unlock(&cdev->ncci_list_mtx);
 
 	write_lock_irqsave(&capidev_list_lock, flags);
 	list_del(&cdev->list);
@@ -603,15 +603,15 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_CONF) {
 		u16 info = CAPIMSG_U16(skb->data, 12); // Info field
 		if (info == 0) {
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 		}
 	}
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_IND) {
-		down(&cdev->ncci_list_sem);
+		mutex_lock(&cdev->ncci_list_mtx);
 		capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
-		up(&cdev->ncci_list_sem);
+		mutex_unlock(&cdev->ncci_list_mtx);
 	}
 	spin_lock_irqsave(&workaround_lock, flags);
 	if (CAPIMSG_COMMAND(skb->data) != CAPI_DATA_B3) {
@@ -752,9 +752,9 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
 	CAPIMSG_SETAPPID(skb->data, cdev->ap.applid);
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_DISCONNECT_B3_RESP) {
-		down(&cdev->ncci_list_sem);
+		mutex_lock(&cdev->ncci_list_mtx);
 		capincci_free(cdev, CAPIMSG_NCCI(skb->data));
-		up(&cdev->ncci_list_sem);
+		mutex_unlock(&cdev->ncci_list_mtx);
 	}
 
 	cdev->errcode = capi20_put_message(&cdev->ap, skb);
@@ -939,9 +939,9 @@ capi_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user(&ncci, argp, sizeof(ncci)))
 				return -EFAULT;
 
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			if ((nccip = capincci_find(cdev, (u32) ncci)) == 0) {
-				up(&cdev->ncci_list_sem);
+				mutex_unlock(&cdev->ncci_list_mtx);
 				return 0;
 			}
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
@@ -949,7 +949,7 @@ capi_ioctl(struct inode *inode, struct file *file,
 				count += atomic_read(&mp->ttyopencount);
 			}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 			return count;
 		}
 		return 0;
@@ -964,14 +964,14 @@ capi_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user(&ncci, argp,
 					   sizeof(ncci)))
 				return -EFAULT;
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			nccip = capincci_find(cdev, (u32) ncci);
 			if (!nccip || (mp = nccip->minorp) == 0) {
-				up(&cdev->ncci_list_sem);
+				mutex_unlock(&cdev->ncci_list_mtx);
 				return -ESRCH;
 			}
 			unit = mp->minor;
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 			return unit;
 		}
 		return 0;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
