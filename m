Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYLDPwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYLDPwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYLDPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:52:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52319 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbYLDPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:52:38 -0500
Date: Thu, 4 Dec 2008 15:52:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: [PATCH] watchdog: New library code
Message-ID: <20081204155250.59a1d30c@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Handles the temperature device
- You pass it the ident and other structs
- It handles stop not being supported (and stop/start fails)
- It does all the reboot, nowayout and module locking and housekeeping
- I've used static objects for most things so they can be initialised
  by the compiler making more of the code "table filling".

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/watchdog/watchdog.c b/drivers/watchdog/watchdog.c
new file mode 100644
index 0000000..3474011
--- /dev/null
+++ b/drivers/watchdog/watchdog.c
@@ -0,0 +1,304 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include "watchdog.h"
+
+/* For now we track a single watchdog */
+static struct watchdog *watchdog;
+static unsigned long watchdog_busy;
+
+static void watchdog_ping(struct watchdog *w)
+{
+	if (w->ops->ping)
+		w->ops->ping(w);
+	else	/* Default to the start method and keep restarting */
+		w->ops->start(w);
+}
+
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	struct watchdog *w = file->private_data;
+	int val = 0;
+	int r;
+
+	if (w->ops->ioctl) {
+		r = w->ops->ioctl(w, cmd, arg);
+		if (r != -ENOIOCTLCMD)
+			return r;
+	}
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, w->info,
+					sizeof(struct watchdog_info));
+	case WDIOC_GETSTATUS:
+		if (w->ops->status)
+			val = w->ops->status(w);		
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(w->boot_status, p);
+	case WDIOC_KEEPALIVE:
+		watchdog_ping(w);
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (w->ops->set_timeout == NULL)
+			return -EOPNOTSUPP;
+		if (get_user(val, p))
+			return -EFAULT;
+		r = w->ops->set_timeout(w, val);
+		if (r < 0)
+			return r;
+		w->timeout = val;
+		watchdog_ping(w);
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		if (w->timeout)
+			return put_user(w->timeout, p);
+		return -EOPNOTSUPP;
+	case WDIOC_SETOPTIONS:
+		if (get_user(val, p))
+			return -EFAULT;
+		if (val & WDIOS_DISABLECARD) {
+			if (w->ops->stop == NULL)
+				return -EOPNOTSUPP;
+			r = w->ops->stop(w);
+			if (r < 0)
+				return r;
+		}
+		if (val & WDIOS_ENABLECARD) {
+			r = w->ops->start(w);
+			if (r < 0)
+				return r;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int r = -EBUSY;
+	/* We will need to rework this when we support multiple dogs */
+	struct watchdog *w = watchdog;
+
+	if (!try_module_get(w->owner))
+		return r;
+	if (test_and_set_bit(WDOG_OPEN, &w->status))
+		goto out;
+	file->private_data = w;
+	
+	r = w->ops->start(w);
+	if (r < 0)
+		goto out_bit;
+
+	clear_bit(WDOG_EXPECT_RELEASE, &w->status);
+	r = nonseekable_open(inode, file);
+	if (r == 0) {
+		/* We leaked a reference to lock the module in on close
+		   now we can reclaim it as we re-opened before triggering */
+		if (test_and_clear_bit(WDOG_ORPHAN, &w->status))
+			module_put(w->owner);
+		return 0;
+	}
+	if (w->ops->stop)
+		w->ops->stop(w);
+out_bit:
+	clear_bit(WDOG_OPEN, &w->status);
+out:
+	module_put(watchdog->owner);
+	return r;
+}
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	struct watchdog *w = file->private_data;
+	if (test_bit(WDOG_EXPECT_RELEASE, &w->status) &&
+	    !test_bit(WDOG_NO_WAY_OUT, &w->status) &&
+						w->ops->stop != NULL) {
+		if (w->ops->stop(w) == 0) {
+			module_put(watchdog->owner);
+			return 0;
+		}
+	}
+	printk(KERN_CRIT "%s: not stopping watchdog.\n", w->name);
+	set_bit(WDOG_ORPHAN, &w->status);
+	/* Deliberately leak a module reference in this case */
+	return 0;
+}
+
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	struct watchdog *w = file->private_data;
+	size_t i;
+	if (len == 0)	/* Can we see this even ? */
+		return 0;
+
+	clear_bit(WDOG_EXPECT_RELEASE, &w->status);
+	/* scan to see whether or not we got the magic character */
+	for (i = 0; i != len; i++) {
+		char c;
+		if (get_user(c, data+i))
+			return -EFAULT;
+		if (c == 'V')
+			set_bit(WDOG_EXPECT_RELEASE, &w->status);
+	}
+	/* And fire the ping timer */
+	watchdog_ping(w);
+	return len;
+}
+
+static ssize_t watchdog_temp_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ptr)
+{
+	struct watchdog *w = file->private_data;
+	u8 temperature = w->ops->temperature(w);
+	if (copy_to_user(buf, &temperature, 1))
+		return -EFAULT;
+	return 1;
+}
+
+static int watchdog_temp_open(struct inode *inode, struct file *file)
+{
+	int r;
+	file->private_data = watchdog;
+	if (!try_module_get(watchdog->owner))
+		return -EBUSY;
+	r = nonseekable_open(inode, file);
+	if (r < 0)
+		module_put(watchdog->owner);
+	return r;
+}
+
+static int watchdog_temp_release(struct inode *inode, struct file *file)
+{
+	struct watchdog *w = file->private_data;
+	module_put(w->owner);
+	return 0;
+}
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+};
+
+static struct miscdevice watchdog_misc = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &watchdog_fops,
+};
+
+static const struct file_operations temperature_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= watchdog_temp_read,
+	.open		= watchdog_temp_open,
+	.release	= watchdog_temp_release,
+};
+
+static struct miscdevice temperature_misc = {
+	.minor = TEMP_MINOR,
+	.name = "temperature",
+	.fops = &temperature_fops,
+};
+
+int watchdog_register(struct watchdog *w, int nwo)
+{
+	int r;
+
+	if (test_and_set_bit(0, &watchdog_busy)) {
+		printk(KERN_ERR "watchdog: only one watchdog at a time currently supported.\n");
+		return -EBUSY;
+	}
+	
+	watchdog = w;
+	
+	w->status = 0;
+	if (nwo)
+		set_bit(WDOG_NO_WAY_OUT, &w->status);
+
+	if (w->ops->temperature) {
+		r = misc_register(&temperature_misc);
+		if (r < 0) {
+			printk(KERN_ERR
+			 "%s: cannot register miscdev on minor=%d (err=%d)\n",
+						w->name, TEMP_MINOR, r);
+			goto out_clear;
+		}
+	}
+	r = misc_register(&watchdog_misc);
+	if (r == 0)
+		return 0;
+	printk(KERN_ERR	"%s: cannot register miscdev on minor=%d (err=%d)\n",
+						w->name, WATCHDOG_MINOR, r);
+	if (w->ops->temperature)
+		misc_deregister(&temperature_misc);
+out_clear:
+	watchdog = NULL;
+	clear_bit(0, &watchdog_busy);
+	return r;
+}
+EXPORT_SYMBOL_GPL(watchdog_register);
+
+void watchdog_unregister(struct watchdog *w)
+{
+	watchdog = NULL;
+	misc_deregister(&watchdog_misc);
+	if (w->ops->temperature)
+		misc_deregister(&temperature_misc);
+	clear_bit(0, &watchdog_busy);
+}
+EXPORT_SYMBOL_GPL(watchdog_unregister);
+
+/* The notifier will need to change for multiple dogs, but at that point
+   hopefully we have a class and class based power methods anyway */
+
+static int watchdog_notify(struct notifier_block *this, unsigned long code,
+	void *dog)
+{
+	if (watchdog && (code == SYS_DOWN || code == SYS_HALT)) {
+		if (watchdog->ops->reboot)
+			watchdog->ops->reboot(watchdog);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block watchdog_notifier = {
+	.notifier_call = watchdog_notify,
+};
+
+static int __init watchdog_init(void)
+{
+	int r = register_reboot_notifier(&watchdog_notifier);
+	if (r < 0)
+		printk(KERN_ERR "watchdog: unable to register notifier.\n");
+	return r;
+}
+
+static void __devexit watchdog_exit(void)
+{
+	unregister_reboot_notifier(&watchdog_notifier);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
diff --git a/drivers/watchdog/watchdog.h b/drivers/watchdog/watchdog.h
new file mode 100644
index 0000000..0d22eaa
--- /dev/null
+++ b/drivers/watchdog/watchdog.h
@@ -0,0 +1,35 @@
+struct watchdog;
+
+struct watchdog_ops
+{
+	int (*start)(struct watchdog *w);
+	int (*stop)(struct watchdog *w);
+	void (*ping)(struct watchdog *w);
+	int (*status)(struct watchdog *w);
+	int (*temperature)(struct watchdog *w);
+	int (*set_timeout)(struct watchdog *w, int t);
+	int (*reboot)(struct watchdog *w);
+	long (*ioctl)(struct watchdog *w, unsigned int cmd, unsigned long arg);
+};
+
+struct watchdog
+{
+	char *name;
+	const struct watchdog_info *info;
+	const struct watchdog_ops *ops;
+	int timeout;
+	int boot_status;
+	long status;
+#define WDOG_OPEN		0
+#define WDOG_EXPECT_RELEASE	1
+#define WDOG_ORPHAN		2
+#define WDOG_NO_WAY_OUT		3
+	struct module *owner;
+};
+
+
+extern void watchdog_unregister(struct watchdog *w);
+extern int watchdog_register(struct watchdog *w, int nwo);
+
+
+
