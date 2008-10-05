Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYJEQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYJEQ3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbYJEQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756474AbYJEQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:39 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 63/76] tty: simplify ktermios allocation
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:22:38 +0100
Message-ID: <20081005162227.1997.17984.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the simplification from the pty unix98 special case to the generic one.
This allows us to kill off driver->termios_locked entirely which is nice. We
have to whack bits of the cris driver as it meddles in places it shouldn't
providing its own arrays that were never used anyway.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c    |   46 +++++++---------------------------------------
 drivers/serial/crisv10.c |    3 ---
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 9590839..502cad6 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1235,27 +1235,20 @@ struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 
 int tty_init_termios(struct tty_struct *tty)
 {
-	struct ktermios *tp, *ltp;
+	struct ktermios *tp;
 	int idx = tty->index;
 
 	tp = tty->driver->termios[idx];
-	ltp = tty->driver->termios_locked[idx];
 	if (tp == NULL) {
-		WARN_ON(ltp != NULL);
-		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
-		ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
-		if (tp == NULL || ltp == NULL) {
-			kfree(tp);
-			kfree(ltp);
+		tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
+		if (tp == NULL)
 			return -ENOMEM;
-		}
 		memcpy(tp, &tty->driver->init_termios,
 						sizeof(struct ktermios));
 		tty->driver->termios[idx] = tp;
-		tty->driver->termios_locked[idx] = ltp;
 	}
 	tty->termios = tp;
-	tty->termios_locked = ltp;
+	tty->termios_locked = tp + 1;
 
 	/* Compatibility until drivers always set this */
 	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
@@ -1439,10 +1432,6 @@ void tty_free_termios(struct tty_struct *tty)
 		tp = tty->termios;
 		tty->driver->termios[idx] = NULL;
 		kfree(tp);
-
-		tp = tty->termios_locked;
-		tty->driver->termios_locked[idx] = NULL;
-		kfree(tp);
 	}
 }
 EXPORT_SYMBOL(tty_free_termios);
@@ -1575,12 +1564,6 @@ void tty_release_dev(struct file *filp)
 			       idx, tty->name);
 			return;
 		}
-		if (tty->termios_locked != tty->driver->termios_locked[idx]) {
-			printk(KERN_DEBUG "tty_release_dev: driver.termios_locked[%d] not "
-			       "termios_locked for (%s)\n",
-			       idx, tty->name);
-			return;
-		}
 	}
 #endif
 
@@ -1604,13 +1587,6 @@ void tty_release_dev(struct file *filp)
 			       idx, tty->name);
 			return;
 		}
-		if (o_tty->termios_locked !=
-		      tty->driver->other->termios_locked[idx]) {
-			printk(KERN_DEBUG "tty_release_dev: other->termios_locked["
-					  "%d] not o_termios_locked for (%s)\n",
-			       idx, tty->name);
-			return;
-		}
 		if (o_tty->link != tty) {
 			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
 			return;
@@ -2930,18 +2906,13 @@ static void destruct_tty_driver(struct kref *kref)
 				driver->termios[i] = NULL;
 				kfree(tp);
 			}
-			tp = driver->termios_locked[i];
-			if (tp) {
-				driver->termios_locked[i] = NULL;
-				kfree(tp);
-			}
 			if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV))
 				tty_unregister_device(driver, i);
 		}
 		p = driver->ttys;
 		proc_tty_unregister_driver(driver);
 		driver->ttys = NULL;
-		driver->termios = driver->termios_locked = NULL;
+		driver->termios = NULL;
 		kfree(p);
 		cdev_del(&driver->cdev);
 	}
@@ -2978,7 +2949,7 @@ int tty_register_driver(struct tty_driver *driver)
 	void **p = NULL;
 
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
-		p = kzalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
+		p = kzalloc(driver->num * 2 * sizeof(void *), GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 	}
@@ -3002,12 +2973,9 @@ int tty_register_driver(struct tty_driver *driver)
 	if (p) {
 		driver->ttys = (struct tty_struct **)p;
 		driver->termios = (struct ktermios **)(p + driver->num);
-		driver->termios_locked = (struct ktermios **)
-							(p + driver->num * 2);
 	} else {
 		driver->ttys = NULL;
 		driver->termios = NULL;
-		driver->termios_locked = NULL;
 	}
 
 	cdev_init(&driver->cdev, &tty_fops);
@@ -3016,7 +2984,7 @@ int tty_register_driver(struct tty_driver *driver)
 	if (error) {
 		unregister_chrdev_region(dev, driver->num);
 		driver->ttys = NULL;
-		driver->termios = driver->termios_locked = NULL;
+		driver->termios = NULL;
 		kfree(p);
 		return error;
 	}
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index a467c77..211c217 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -457,7 +457,6 @@ static struct e100_serial rs_table[] = {
 #define NR_PORTS (sizeof(rs_table)/sizeof(struct e100_serial))
 
 static struct ktermios *serial_termios[NR_PORTS];
-static struct ktermios *serial_termios_locked[NR_PORTS];
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 static struct fast_timer fast_timers[NR_PORTS];
 #endif
@@ -4448,8 +4447,6 @@ rs_init(void)
 	driver->init_termios.c_ispeed = 115200;
 	driver->init_termios.c_ospeed = 115200;
 	driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-	driver->termios = serial_termios;
-	driver->termios_locked = serial_termios_locked;
 
 	tty_set_operations(driver, &rs_ops);
         serial_driver = driver;

