Return-Path: <linux-kernel-owner+w=401wt.eu-S2992841AbXDYQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992841AbXDYQih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992842AbXDYQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:38:37 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:34926
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992841AbXDYQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:38:36 -0400
Date: Wed, 25 Apr 2007 18:41:32 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in RocketPort driver v3
Message-ID: <20070425164132.GQ6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the RocketPort driver uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 76357c8..af9379b 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -702,7 +702,7 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 		}
 	}
 	spin_lock_init(&info->slock);
-	sema_init(&info->write_sem, 1);
+	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
 	if (pci_dev)
 		tty_register_device(rocket_driver, line, &pci_dev->dev);
@@ -1662,7 +1662,7 @@ static void rp_put_char(struct tty_struct *tty, unsigned char ch)
 		return;
 
 	/*  Grab the port write semaphore, locking out other processes that try to write to this port */
-	down(&info->write_sem);
+	mutex_lock(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_put_char %c...", ch);
@@ -1684,7 +1684,7 @@ static void rp_put_char(struct tty_struct *tty, unsigned char ch)
 		info->xmit_fifo_room--;
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
-	up(&info->write_sem);
+	mutex_unlock(&info->write_mtx);
 }
 
 /*
@@ -1706,7 +1706,8 @@ static int rp_write(struct tty_struct *tty,
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;
 
-	down_interruptible(&info->write_sem);
+	if (mutex_lock_interruptible(&info->write_mtx))
+		return -ERESTARTSYS;
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);
@@ -1777,7 +1778,7 @@ end:
 		wake_up_interruptible(&tty->poll_wait);
 #endif
 	}
-	up(&info->write_sem);
+	mutex_unlock(&info->write_mtx);
 	return retval;
 }
 
diff --git a/drivers/char/rocket_int.h b/drivers/char/rocket_int.h
index 3a8bcc8..04bcf61 100644
--- a/drivers/char/rocket_int.h
+++ b/drivers/char/rocket_int.h
@@ -1171,7 +1171,7 @@ struct r_port {
 	struct wait_queue *close_wait;
 #endif
 	spinlock_t slock;
-	struct semaphore write_sem;
+	struct mutex write_mtx;
 };
 
 #define RPORT_MAGIC 0x525001
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La guerra es un acto abominable en el que se matan personas que no
      se conocen, dirigidas por personas que se conocen y no se matan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
