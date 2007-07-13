Return-Path: <linux-kernel-owner+w=401wt.eu-S937171AbXGMTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937171AbXGMTYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbXGMTYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:24:07 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:39815
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932248AbXGMTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:24:03 -0400
Date: Fri, 13 Jul 2007 21:25:25 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: dbrownell@users.sourceforge.net, linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/5] use mutex instead of semaphore in the USB gadget serial driver
Message-ID: <20070713192525.GF18159@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	dbrownell@users.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070713192023.GD18159@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713192023.GD18159@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The USB gadget serial driver uses a semaphore as mutex. Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index dd33ff0..4192d24 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -33,6 +33,7 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/mutex.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -258,7 +259,7 @@ static const char *EP_IN_NAME;
 static const char *EP_OUT_NAME;
 static const char *EP_NOTIFY_NAME;
 
-static struct semaphore	gs_open_close_sem[GS_NUM_PORTS];
+static struct mutex gs_open_close_lock[GS_NUM_PORTS];
 
 static unsigned int read_q_size = GS_DEFAULT_READ_Q_SIZE;
 static unsigned int write_q_size = GS_DEFAULT_WRITE_Q_SIZE;
@@ -595,7 +596,7 @@ static int __init gs_module_init(void)
 	tty_set_operations(gs_tty_driver, &gs_tty_ops);
 
 	for (i=0; i < GS_NUM_PORTS; i++)
-		sema_init(&gs_open_close_sem[i], 1);
+		mutex_init(&gs_open_close_lock[i]);
 
 	retval = tty_register_driver(gs_tty_driver);
 	if (retval) {
@@ -635,7 +636,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	struct gs_port *port;
 	struct gs_dev *dev;
 	struct gs_buf *buf;
-	struct semaphore *sem;
+	struct mutex *mtx;
 	int ret;
 
 	port_num = tty->index;
@@ -656,10 +657,10 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 		return -ENODEV;
 	}
 
-	sem = &gs_open_close_sem[port_num];
-	if (down_interruptible(sem)) {
+	mtx = &gs_open_close_lock[port_num];
+	if (mutex_lock_interruptible(mtx)) {
 		printk(KERN_ERR
-		"gs_open: (%d,%p,%p) interrupted waiting for semaphore\n",
+		"gs_open: (%d,%p,%p) interrupted waiting for mutex\n",
 			port_num, tty, file);
 		return -ERESTARTSYS;
 	}
@@ -754,12 +755,12 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 
 exit_unlock_port:
 	spin_unlock_irqrestore(&port->port_lock, flags);
-	up(sem);
+	mutex_unlock(mtx);
 	return ret;
 
 exit_unlock_dev:
 	spin_unlock_irqrestore(&dev->dev_lock, flags);
-	up(sem);
+	mutex_unlock(mtx);
 	return ret;
 
 }
@@ -781,7 +782,7 @@ exit_unlock_dev:
 static void gs_close(struct tty_struct *tty, struct file *file)
 {
 	struct gs_port *port = tty->driver_data;
-	struct semaphore *sem;
+	struct mutex *mtx;
 
 	if (port == NULL) {
 		printk(KERN_ERR "gs_close: NULL port pointer\n");
@@ -790,8 +791,8 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	gs_debug("gs_close: (%d,%p,%p)\n", port->port_num, tty, file);
 
-	sem = &gs_open_close_sem[port->port_num];
-	down(sem);
+	mtx = &gs_open_close_lock[port->port_num];
+	mutex_lock(mtx);
 
 	spin_lock_irq(&port->port_lock);
 
@@ -846,7 +847,7 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 exit:
 	spin_unlock_irq(&port->port_lock);
-	up(sem);
+	mutex_unlock(mtx);
 }
 
 /*

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
