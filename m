Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYJEQXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYJEQXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbYJEQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:20:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57947 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758673AbYJEQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:20:40 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 51/76] tty: kref the tty driver object
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:20:40 +0100
Message-ID: <20081005161937.1997.39297.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/ip2/ip2main.c |    6 +-
 drivers/char/pty.c         |    5 ++
 drivers/char/tty_io.c      |  110 ++++++++++++++++++++++++--------------------
 drivers/net/wan/Kconfig    |    2 -
 include/linux/tty_driver.h |   15 ++++--
 5 files changed, 80 insertions(+), 58 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 66f52a2..6774572 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -264,8 +264,8 @@ static int tracewrap;
 /**********/
 
 #if defined(MODULE) && defined(IP2DEBUG_OPEN)
-#define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] refc=%d, ttyc=%d, modc=%x -> %s\n", \
-		    tty->name,(pCh->flags),ip2_tty_driver->refcount, \
+#define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] ttyc=%d, modc=%x -> %s\n", \
+		    tty->name,(pCh->flags), \
 		    tty->count,/*GET_USE_COUNT(module)*/0,s)
 #else
 #define DBG_CNT(s)
@@ -2893,7 +2893,7 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 	case 13:
 		switch ( cmd ) {
 		case 64:	/* Driver - ip2stat */
-			rc = put_user(ip2_tty_driver->refcount, pIndex++ );
+			rc = put_user(-1, pIndex++ );
 			rc = put_user(irq_counter, pIndex++  );
 			rc = put_user(bh_counter, pIndex++  );
 			break;
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e148ad..0fdfa05 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -571,8 +571,11 @@ static void __init unix98_pty_init(void)
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
+	/* FIXME: WTF */
+#if 0	
 	pty_table[1].data = &ptm_driver->refcount;
-	register_sysctl_table(pty_root_table);
+#endif	
+	register_sysctl_table(pty_root_table);	
 
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index ac41af8..47aa437 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -276,7 +276,7 @@ static struct tty_driver *get_tty_driver(dev_t device, int *index)
 		if (device < base || device >= base + p->num)
 			continue;
 		*index = device - base;
-		return p;
+		return tty_driver_kref_get(p);
 	}
 	return NULL;
 }
@@ -320,7 +320,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 
 		if (tty_line >= 0 && tty_line <= p->num && p->ops &&
 		    p->ops->poll_init && !p->ops->poll_init(p, tty_line, str)) {
-			res = p;
+			res = tty_driver_kref_get(p);
 			*line = tty_line;
 			break;
 		}
@@ -1410,7 +1410,7 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 			*o_ltp_loc = o_ltp;
 		o_tty->termios = *o_tp_loc;
 		o_tty->termios_locked = *o_ltp_loc;
-		driver->other->refcount++;
+		tty_driver_kref_get(driver->other);
 		if (driver->subtype == PTY_TYPE_MASTER)
 			o_tty->count++;
 
@@ -1438,7 +1438,7 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	/* Compatibility until drivers always set this */
 	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
 	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
-	driver->refcount++;
+	tty_driver_kref_get(driver);
 	tty->count++;
 
 	/*
@@ -1530,8 +1530,7 @@ static void release_one_tty(struct kref *kref)
 	else
 		tty_shutdown(tty);
 	tty->magic = 0;
-	/* FIXME: locking on tty->driver->refcount */
-	tty->driver->refcount--;
+	tty_driver_kref_put(driver);
 	module_put(driver->owner);
 
 	file_list_lock();
@@ -1854,7 +1853,7 @@ retry_open:
 			mutex_unlock(&tty_mutex);
 			return -ENXIO;
 		}
-		driver = tty->driver;
+		driver = tty_driver_kref_get(tty->driver);
 		index = tty->index;
 		filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
 		/* noctty = 1; */
@@ -1865,14 +1864,14 @@ retry_open:
 #ifdef CONFIG_VT
 	if (device == MKDEV(TTY_MAJOR, 0)) {
 		extern struct tty_driver *console_driver;
-		driver = console_driver;
+		driver = tty_driver_kref_get(console_driver);
 		index = fg_console;
 		noctty = 1;
 		goto got_driver;
 	}
 #endif
 	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
-		driver = console_device(&index);
+		driver = tty_driver_kref_get(console_device(&index));
 		if (driver) {
 			/* Don't let /dev/console block */
 			filp->f_flags |= O_NONBLOCK;
@@ -1891,6 +1890,7 @@ retry_open:
 got_driver:
 	retval = tty_init_dev(driver, index, &tty, 0);
 	mutex_unlock(&tty_mutex);
+	tty_driver_kref_put(driver);
 	if (retval)
 		return retval;
 
@@ -2866,7 +2866,6 @@ int tty_put_char(struct tty_struct *tty, unsigned char ch)
 		return tty->ops->put_char(tty, ch);
 	return tty->ops->write(tty, &ch, 1);
 }
-
 EXPORT_SYMBOL_GPL(tty_put_char);
 
 struct class *tty_class;
@@ -2909,6 +2908,7 @@ struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 
 	return device_create_drvdata(tty_class, device, dev, NULL, name);
 }
+EXPORT_SYMBOL(tty_register_device);
 
 /**
  * 	tty_unregister_device - unregister a tty device
@@ -2926,8 +2926,6 @@ void tty_unregister_device(struct tty_driver *driver, unsigned index)
 	device_destroy(tty_class,
 		MKDEV(driver->major, driver->minor_start) + index);
 }
-
-EXPORT_SYMBOL(tty_register_device);
 EXPORT_SYMBOL(tty_unregister_device);
 
 struct tty_driver *alloc_tty_driver(int lines)
@@ -2936,27 +2934,70 @@ struct tty_driver *alloc_tty_driver(int lines)
 
 	driver = kzalloc(sizeof(struct tty_driver), GFP_KERNEL);
 	if (driver) {
+		kref_init(&driver->kref);
 		driver->magic = TTY_DRIVER_MAGIC;
 		driver->num = lines;
 		/* later we'll move allocation of tables here */
 	}
 	return driver;
 }
+EXPORT_SYMBOL(alloc_tty_driver);
 
-void put_tty_driver(struct tty_driver *driver)
+static void destruct_tty_driver(struct kref *kref)
 {
+	struct tty_driver *driver = container_of(kref, struct tty_driver, kref);
+	int i;
+	struct ktermios *tp;
+	void *p;
+
+	if (driver->flags & TTY_DRIVER_INSTALLED) {
+		/*
+		 * Free the termios and termios_locked structures because
+		 * we don't want to get memory leaks when modular tty
+		 * drivers are removed from the kernel.
+		 */
+		for (i = 0; i < driver->num; i++) {
+			tp = driver->termios[i];
+			if (tp) {
+				driver->termios[i] = NULL;
+				kfree(tp);
+			}
+			tp = driver->termios_locked[i];
+			if (tp) {
+				driver->termios_locked[i] = NULL;
+				kfree(tp);
+			}
+			if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV))
+				tty_unregister_device(driver, i);
+		}
+		p = driver->ttys;
+		proc_tty_unregister_driver(driver);
+		driver->ttys = NULL;
+		driver->termios = driver->termios_locked = NULL;
+		kfree(p);
+		cdev_del(&driver->cdev);
+	}
 	kfree(driver);
 }
 
+void tty_driver_kref_put(struct tty_driver *driver)
+{
+	kref_put(&driver->kref, destruct_tty_driver);
+}
+EXPORT_SYMBOL(tty_driver_kref_put);
+
 void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op)
 {
 	driver->ops = op;
 };
+EXPORT_SYMBOL(tty_set_operations);
 
-EXPORT_SYMBOL(alloc_tty_driver);
+void put_tty_driver(struct tty_driver *d)
+{
+	tty_driver_kref_put(d);
+}
 EXPORT_SYMBOL(put_tty_driver);
-EXPORT_SYMBOL(tty_set_operations);
 
 /*
  * Called by a tty driver to register itself.
@@ -2968,9 +3009,6 @@ int tty_register_driver(struct tty_driver *driver)
 	dev_t dev;
 	void **p = NULL;
 
-	if (driver->flags & TTY_DRIVER_INSTALLED)
-		return 0;
-
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
 		p = kzalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
 		if (!p)
@@ -3024,6 +3062,7 @@ int tty_register_driver(struct tty_driver *driver)
 		    tty_register_device(driver, i, NULL);
 	}
 	proc_tty_register_driver(driver);
+	driver->flags |= TTY_DRIVER_INSTALLED;
 	return 0;
 }
 
@@ -3034,46 +3073,19 @@ EXPORT_SYMBOL(tty_register_driver);
  */
 int tty_unregister_driver(struct tty_driver *driver)
 {
-	int i;
-	struct ktermios *tp;
-	void *p;
-
+#if 0
+	/* FIXME */
 	if (driver->refcount)
 		return -EBUSY;
-
+#endif
 	unregister_chrdev_region(MKDEV(driver->major, driver->minor_start),
 				driver->num);
 	mutex_lock(&tty_mutex);
 	list_del(&driver->tty_drivers);
 	mutex_unlock(&tty_mutex);
-
-	/*
-	 * Free the termios and termios_locked structures because
-	 * we don't want to get memory leaks when modular tty
-	 * drivers are removed from the kernel.
-	 */
-	for (i = 0; i < driver->num; i++) {
-		tp = driver->termios[i];
-		if (tp) {
-			driver->termios[i] = NULL;
-			kfree(tp);
-		}
-		tp = driver->termios_locked[i];
-		if (tp) {
-			driver->termios_locked[i] = NULL;
-			kfree(tp);
-		}
-		if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV))
-			tty_unregister_device(driver, i);
-	}
-	p = driver->ttys;
-	proc_tty_unregister_driver(driver);
-	driver->ttys = NULL;
-	driver->termios = driver->termios_locked = NULL;
-	kfree(p);
-	cdev_del(&driver->cdev);
 	return 0;
 }
+
 EXPORT_SYMBOL(tty_unregister_driver);
 
 dev_t tty_devnum(struct tty_struct *tty)
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 2ae2ec4..21efd99 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -205,7 +205,7 @@ config WANXL_BUILD_FIRMWARE
 
 config PC300
 	tristate "Cyclades-PC300 support (RS-232/V.35, X.21, T1/E1 boards)"
-	depends on HDLC && PCI
+	depends on HDLC && PCI && BROKEN
 	---help---
 	  Driver for the Cyclades-PC300 synchronous communication boards.
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 2c5c35c..ba891dd 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -253,6 +253,7 @@ struct tty_operations {
 
 struct tty_driver {
 	int	magic;		/* magic number for this structure */
+	struct kref kref;	/* Reference management */
 	struct cdev cdev;
 	struct module	*owner;
 	const char	*driver_name;
@@ -266,7 +267,6 @@ struct tty_driver {
 	short	subtype;	/* subtype of tty driver */
 	struct ktermios init_termios; /* Initial termios */
 	int	flags;		/* tty driver flags */
-	int	refcount;	/* for loadable tty drivers */
 	struct proc_dir_entry *proc_entry; /* /proc fs entry */
 	struct tty_driver *other; /* only used for the PTY driver */
 
@@ -288,12 +288,19 @@ struct tty_driver {
 
 extern struct list_head tty_drivers;
 
-struct tty_driver *alloc_tty_driver(int lines);
-void put_tty_driver(struct tty_driver *driver);
-void tty_set_operations(struct tty_driver *driver,
+extern struct tty_driver *alloc_tty_driver(int lines);
+extern void put_tty_driver(struct tty_driver *driver);
+extern void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op);
 extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
+extern void tty_driver_kref_put(struct tty_driver *driver);
+extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
+{
+	kref_get(&d->kref);
+	return d;
+}
+
 /* tty driver magic number */
 #define TTY_DRIVER_MAGIC		0x5402
 

