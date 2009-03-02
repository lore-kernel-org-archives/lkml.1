Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZCBWne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZCBWne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZCBWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:43:17 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35004 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZCBWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:43:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oRaAi5XfuZJtxADD7uoKrkxTskduvpFbhYB8R/bMfb+3iX+tCHwZbAY1l/edMT4+D4
         6muf7W/q0IPFTr731O+mUS5PoOD83FMfwjPMfs2MiGNdu/bmtViS7u+Z7/3hcyj4EJSZ
         oMZsIMXYXIs93rKzz+MNY9e+9vnmIkqBixB2M=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-input@vger.kernel.org
Subject: [RFC PATCH 2/2] Add virtual "idle" device
Date: Mon,  2 Mar 2009 23:42:52 +0100
Message-Id: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This virtual device can be used to tell user space about periods of time
when user didn't "touch" input devices (keyboards, mice, touchpads, joysticks,
etc). For now it supports only keyboard events.

Notification is done through simple select/poll + ioctl interface.

It can be used to implement screen savers, automatic suspend,
autoaway/autodisconnect (e.g. in instant messangers) without
any help from X server and its overhead (context switches).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-input@vger.kernel.org
---

As this driver is finished but to make it fully functional I need to extend
input subsystem, I would like to know what do other think about this code.

Please comment.

---
 Documentation/idle/Makefile    |    1 +
 Documentation/idle/test_idle.c |  153 ++++++++++++++
 drivers/char/Kconfig           |   19 ++
 drivers/char/Makefile          |    1 +
 drivers/char/idle.c            |  445 ++++++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild           |    1 +
 include/linux/idle.h           |   22 ++
 7 files changed, 642 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/idle/Makefile
 create mode 100644 Documentation/idle/test_idle.c
 create mode 100644 drivers/char/idle.c
 create mode 100644 include/linux/idle.h

diff --git a/Documentation/idle/Makefile b/Documentation/idle/Makefile
new file mode 100644
index 0000000..3c122dd
--- /dev/null
+++ b/Documentation/idle/Makefile
@@ -0,0 +1 @@
+test_idle: test_idle.c
diff --git a/Documentation/idle/test_idle.c b/Documentation/idle/test_idle.c
new file mode 100644
index 0000000..9679599
--- /dev/null
+++ b/Documentation/idle/test_idle.c
@@ -0,0 +1,153 @@
+/*
+ * This is an example program showing how /dev/idle can be used.
+ * Usage: ./test_idle --get-current 5 10 15 20
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <sys/select.h>
+#include <sys/stat.h>
+#include <time.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#ifdef HAVE_LINUX_IDLE_H
+#include <linux/idle.h>
+#else
+#define IDLE_IOCTL_GET_EVENT        0
+#define IDLE_IOCTL_SET              1
+#define IDLE_IOCTL_REMOVE           2
+#define IDLE_IOCTL_GET_CURRENT_IDLE 3
+#endif
+
+#define printf2(format, args...) \
+	do { \
+		time_t t; \
+		struct tm *tm; \
+		time(&t); \
+		tm = localtime(&t); \
+		printf("%02d:%02d:%02d ", tm->tm_hour, tm->tm_min, tm->tm_sec); \
+		printf(format, ##args); \
+		fflush(stdout); \
+	} while (0)
+
+int send_message(int fd, unsigned int cmd, unsigned int arg)
+{
+	int r = ioctl(fd, cmd, arg);
+	if (r == 0)
+		return 0;
+
+	perror("ioctl");
+	printf2("errno: %d\n", errno);
+	return 1;
+}
+
+int set_timer(int fd, unsigned int sec)
+{
+	printf2("setting timer: %u seconds\n", sec);
+	return send_message(fd, IDLE_IOCTL_SET, sec);
+}
+
+int del_timer(int fd)
+{
+	printf2("removing timer\n");
+	return send_message(fd, IDLE_IOCTL_REMOVE, 0);
+}
+
+int main(int argc, char *argv[])
+{
+	fd_set fds;
+	int fd;
+	unsigned char buf;
+	unsigned long lbuf;
+	int r;
+	int min_tm_idx = 1;
+	unsigned int timeouts[10];
+	int timeouts_count = 0;
+	int i;
+	int idx = 0;
+	int get_current;
+	
+	printf2("opening /dev/idle\n");
+	fd = open("/dev/idle", O_RDWR);
+	if (fd < 0)
+	{
+		perror("open");
+		return 1;
+	}
+	
+	get_current = min_tm_idx < argc &&
+			strcmp(argv[min_tm_idx], "--get-current") == 0;
+	if (get_current)
+		++min_tm_idx;
+	
+	for (i = min_tm_idx; i < argc; ++i)
+		timeouts[timeouts_count++] = atoi(argv[i]);
+	
+	if (timeouts_count == 0)
+	{
+		printf2("no timeouts!\n");
+		return 0;
+	}
+
+	do
+	{
+		if (idx < timeouts_count)
+			set_timer(fd, timeouts[idx]);
+	
+		printf2("select()\n");
+
+		FD_ZERO(&fds);
+		FD_SET(fd, &fds);
+
+/*
+		struct timeval tv;
+		tv.tv_sec = 15;
+		tv.tv_usec = 0;
+		r = select(fd + 1, &fds, NULL, NULL, &tv);
+*/
+		r = select(fd + 1, &fds, NULL, NULL, NULL);
+
+		if (get_current)
+		{
+			if (ioctl(fd, IDLE_IOCTL_GET_CURRENT_IDLE, &lbuf))
+			{
+				perror("ioctl");
+				continue;
+			}
+			printf2("current idle: %lu\n", lbuf);
+		}
+
+		if (r < 0)
+		{
+			perror("select");
+			continue;
+		}
+
+		if (r == 0)
+		{
+			printf2("no data\n");
+			continue;
+		}
+
+		printf2("new event, reading from /dev/idle\n");
+		r = ioctl(fd, IDLE_IOCTL_GET_EVENT, &buf);
+		if (r)
+		{
+			perror("ioctl");
+			continue;
+		}
+
+		printf2("event: %s\n", buf == 0 ? "idle" : "wakeup");
+		if (buf == 0)
+			++idx;
+		else
+			idx = 0;
+
+	}
+	while (1);
+	
+	printf2("\nclosing /dev/idle\n");
+	close(fd);
+	return 0;
+}
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 735bbe2..8f2d773 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1093,6 +1093,25 @@ config TELCLOCK
 	  /sys/devices/platform/telco_clock, with a number of files for
 	  controlling the behavior of this hardware.
 
+config IDLEDEV
+	tristate "/dev/idle support"
+	depends on VT
+	default y
+	help
+	  If you say Y here, user space applications can be notified when you
+	  don't "touch" input devices (for now keyboard only; later it will
+	  support mice, touchpads, joysticks, etc) for long periods of time.
+
+	  It can be used to implement screen savers, automatic suspend,
+	  autodisconnects (e.g. in instant messangers) without help from
+	  X server.
+
+	  See <file:Documentation/idle/> for example program using this device.
+
+	  Note: If you compile this driver as a module, it will _not_ be loaded
+	  automatically (like usual drivers). You will need to load it manually
+	  (or add it to list of modules loaded during boot).
+
 config DEVPORT
 	bool
 	depends on !M68K
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 9caf5b5..f77ef5c 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -12,6 +12,7 @@ obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o t
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
+obj-$(CONFIG_IDLEDEV)		+= idle.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
diff --git a/drivers/char/idle.c b/drivers/char/idle.c
new file mode 100644
index 0000000..5fe792d
--- /dev/null
+++ b/drivers/char/idle.c
@@ -0,0 +1,445 @@
+/*
+ * idle.c
+ *
+ * Copyright (C) 2008,2009 Marcin Slusarz <marcin.slusarz@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/hrtimer.h>
+#include <linux/keyboard.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/poll.h>
+#include <linux/spinlock.h>
+#include <linux/time.h>
+#include <linux/wait.h>
+
+#include <linux/idle.h>
+
+/* TODO: support all input devices */
+
+/*#define DEBUG*/
+
+#ifdef DEBUG
+#define idle_printk(args...) printk(KERN_DEBUG "IDLEDEV: " args)
+#else
+#define idle_printk(args...) do {} while (0)
+#endif
+
+/* spinlock protecting all data */
+static DEFINE_SPINLOCK(idle_events_lock);
+
+/* wait queue for wakeup events */
+static DECLARE_WAIT_QUEUE_HEAD(wakeup_events_waitqueue);
+
+/* time of last user action */
+static ktime_t last_input_event_time;
+
+static int daemon_mode;
+
+/* structure connected with file */
+struct idle_file_data {
+	struct hrtimer timer; /* fires idle events */
+	ktime_t timeout;
+	bool waiting_for_wakeup;
+	bool waiting_for_idle;
+	ktime_t last_read_time; /* last time when user consumed event */
+	wait_queue_head_t idle_events_waitqueue;
+};
+
+static int idle_kb_event(struct notifier_block *this,
+			unsigned long event, void *ptr)
+{
+	unsigned long flags;
+
+	idle_printk("kb_event\n");
+
+	spin_lock_irqsave(&idle_events_lock, flags);
+
+	last_input_event_time = ktime_get_real();
+	wake_up_all(&wakeup_events_waitqueue);
+
+	spin_unlock_irqrestore(&idle_events_lock, flags);
+
+	return NOTIFY_DONE;
+}
+
+static bool idle_event_available(struct idle_file_data *d)
+{
+	ktime_t expected_idle_time, now;
+
+	if (!d->waiting_for_idle)
+		return false;
+
+	expected_idle_time = ktime_add(last_input_event_time, d->timeout);
+	now = ktime_get_real();
+
+	return ktime_compare(expected_idle_time, d->last_read_time) > 0 &&
+		ktime_compare(expected_idle_time, now) < 0;
+}
+
+static bool wakeup_event_available(struct idle_file_data *d)
+{
+	if (!d->waiting_for_wakeup)
+		return false;
+
+	return ktime_compare(last_input_event_time, d->last_read_time) > 0;
+}
+
+static bool __event_available(struct idle_file_data *d, bool *wakeup)
+{
+	if (ktime_compare(d->timeout, ktime_set(0, 0)) == 0)
+		return false;
+
+	*wakeup = wakeup_event_available(d);
+	if (*wakeup)
+		return true;
+
+	return idle_event_available(d);
+}
+
+static bool event_available(struct idle_file_data *d)
+{
+	bool wakeup;
+	return __event_available(d, &wakeup);
+}
+
+static enum hrtimer_restart idle_timer_timeout(struct hrtimer *timer)
+{
+	struct idle_file_data *d =
+			container_of(timer, struct idle_file_data, timer);
+	unsigned long flags;
+
+	idle_printk("timeout\n");
+
+	spin_lock_irqsave(&idle_events_lock, flags);
+
+	if (idle_event_available(d)) {
+		wake_up_all(&d->idle_events_waitqueue);
+		spin_unlock_irqrestore(&idle_events_lock, flags);
+		return HRTIMER_NORESTART;
+	}
+
+	hrtimer_set_expires(timer,
+				ktime_add(last_input_event_time, d->timeout));
+
+	spin_unlock_irqrestore(&idle_events_lock, flags);
+
+	return HRTIMER_RESTART;
+}
+
+static int idle_get_event(struct idle_file_data *d, u8 __user *user_event)
+{
+	bool wakeup;
+	u8 event;
+
+	idle_printk("idle_get_event\n");
+
+	spin_lock_irq(&idle_events_lock);
+
+	if (!__event_available(d, &wakeup)) {
+		spin_unlock_irq(&idle_events_lock);
+		return -EAGAIN;
+	}
+
+	if (wakeup) {
+		event = IDLE_WAKEUP;
+		d->waiting_for_idle = true;
+		d->waiting_for_wakeup = false;
+	} else {
+		event = IDLE_IDLE;
+		d->waiting_for_idle = false;
+		d->waiting_for_wakeup = true;
+	}
+
+	d->last_read_time = ktime_get_real();
+
+	spin_unlock_irq(&idle_events_lock);
+
+	if (copy_to_user(user_event, &event, sizeof(event)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int idle_set_timeout(struct idle_file_data *d, u32 secs)
+{
+	ktime_t timeout = ktime_set(secs, 0);
+	ktime_t idle_time;
+
+	if (secs == 0)
+		return -EINVAL;
+
+	if (ktime_compare(timeout, d->timeout) == 0)
+		return -EALREADY;
+
+	idle_printk("setting timeout to %u\n", secs);
+
+	hrtimer_cancel(&d->timer);
+
+	spin_lock_irq(&idle_events_lock);
+	idle_time = ktime_add(last_input_event_time, timeout);
+	spin_unlock_irq(&idle_events_lock);
+
+	d->timeout = timeout;
+	d->waiting_for_idle = true;
+	hrtimer_start(&d->timer, idle_time, HRTIMER_MODE_ABS);
+
+	return 0;
+}
+
+static int idle_remove_timeout(struct idle_file_data *d)
+{
+	idle_printk("removing timeout\n");
+
+	hrtimer_cancel(&d->timer);
+
+/*	locking not needed - we are touching file data only from
+	timer function (which we just disabled) and user context
+	owning file */
+
+	d->timeout = ktime_set(0, 0);
+	d->waiting_for_wakeup = false;
+	d->waiting_for_idle = false;
+
+	return 0;
+}
+
+static int idle_get_current_time(struct idle_file_data *d,
+				time_t __user *data)
+{
+	struct timespec ts;
+	ktime_t t;
+
+	spin_lock_irq(&idle_events_lock);
+	t = last_input_event_time;
+	spin_unlock_irq(&idle_events_lock);
+
+	t = ktime_sub(ktime_get_real(), t);
+	ts = ktime_to_timespec(t);
+
+	/* copy only seconds, because it could be used for evil things */
+	if (copy_to_user(data, &ts.tv_sec, sizeof(ts.tv_sec)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long idle_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	struct idle_file_data *d = f->private_data;
+
+	if (cmd == IDLE_IOCTL_GET_EVENT)
+		return idle_get_event(d, (u8 __user *)arg);
+	else if (cmd == IDLE_IOCTL_SET)
+		return idle_set_timeout(d, arg);
+	else if (cmd == IDLE_IOCTL_REMOVE)
+		return idle_remove_timeout(d);
+	else if (cmd == IDLE_IOCTL_GET_CURRENT_IDLE)
+		return idle_get_current_time(d, (time_t __user *)arg);
+	else
+		return -EINVAL;
+}
+
+static unsigned int idle_poll(struct file *f, poll_table *pt)
+{
+	unsigned int mask = POLLOUT | POLLWRNORM;
+	struct idle_file_data *d = f->private_data;
+
+	idle_printk("idle_poll\n");
+
+	spin_lock_irq(&idle_events_lock);
+
+	if (event_available(d)) {
+		mask |= POLLIN | POLLRDNORM;
+		idle_printk("idle data available\n");
+	}
+
+	if (d->waiting_for_wakeup)
+		poll_wait(f, &wakeup_events_waitqueue, pt);
+
+	if (d->waiting_for_idle)
+		poll_wait(f, &d->idle_events_waitqueue, pt);
+
+	spin_unlock_irq(&idle_events_lock);
+
+	return mask;
+}
+
+/* protects open_counter */
+static DEFINE_MUTEX(open_counter_mutex);
+
+/* how many times device is opened */
+static int open_counter;
+
+static struct notifier_block idle_nb = {
+	.notifier_call = idle_kb_event,
+};
+
+static int idle_new_client(void)
+{
+	int ret = 0;
+	mutex_lock(&open_counter_mutex);
+
+	if (open_counter == 0) {
+		idle_printk("first client connected\n");
+
+		last_input_event_time = ktime_get_real();
+
+		ret = register_keyboard_notifier(&idle_nb);
+		if (ret)
+			goto out;
+	}
+	++open_counter;
+
+out:
+	mutex_unlock(&open_counter_mutex);
+	return ret;
+}
+
+/* process context */
+static int idle_open(struct inode *inode, struct file *filp)
+{
+	struct idle_file_data *d = kmalloc(sizeof(*d), GFP_KERNEL);
+	int ret;
+
+	if (d == NULL)
+		return -ENOMEM;
+
+	hrtimer_init(&d->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	d->timeout = ktime_set(0, 0);
+	d->timer.function = idle_timer_timeout;
+	d->waiting_for_wakeup = false;
+	d->waiting_for_idle = false;
+	d->last_read_time = ktime_set(0, 0);
+	init_waitqueue_head(&d->idle_events_waitqueue);
+	filp->private_data = d;
+
+	ret = idle_new_client();
+	if (ret)
+		goto out;
+
+	return 0;
+out:
+	kfree(d);
+	return ret;
+}
+
+static void idle_client_leaving(void)
+{
+	mutex_lock(&open_counter_mutex);
+
+	if (--open_counter == 0) {
+		idle_printk("last client disconnected\n");
+
+		WARN_ON(unregister_keyboard_notifier(&idle_nb));
+	}
+
+	mutex_unlock(&open_counter_mutex);
+}
+
+static int idle_release(struct inode *inode, struct file *filp)
+{
+	struct idle_file_data *d = filp->private_data;
+
+	idle_remove_timeout(d);
+	idle_client_leaving();
+
+	kfree(d);
+	return 0;
+}
+
+static struct class *idle_class;
+static struct device *idle_device;
+
+/* device major number */
+static int idle_major;
+
+static const struct file_operations idle_ops = {
+	.owner		= THIS_MODULE,
+	.poll		= idle_poll,
+	.open		= idle_open,
+	.release	= idle_release,
+	.unlocked_ioctl = idle_ioctl,
+};
+
+static int __init idle_init(void)
+{
+	int err = 0;
+
+	idle_printk("starting\n");
+
+	idle_major = register_chrdev(0, "idle", &idle_ops);
+	if (idle_major < 0) {
+		idle_printk("cannot register device\n");
+		return idle_major;
+	}
+
+	idle_class = class_create(THIS_MODULE, "idle");
+	if (IS_ERR(idle_class)) {
+		err = PTR_ERR(idle_class);
+		goto out_class;
+	}
+
+	idle_device = device_create(idle_class, NULL,
+					MKDEV(idle_major, 1), NULL, "idle");
+	if (IS_ERR(idle_device)) {
+		err = PTR_ERR(idle_device);
+		goto out_device;
+	}
+
+	idle_printk("device major: %d\n", idle_major);
+
+	if (daemon_mode) {
+		err = idle_new_client();
+		if (err)
+			goto out_new_client;
+	}
+out:
+	return err;
+
+out_new_client:
+	device_destroy(idle_class, MKDEV(idle_major, 1));
+out_device:
+	class_destroy(idle_class);
+out_class:
+	unregister_chrdev(idle_major, "idle");
+	goto out;
+}
+
+static void __exit idle_exit(void)
+{
+	idle_printk("exiting\n");
+
+	if (daemon_mode)
+		idle_client_leaving();
+
+	device_destroy(idle_class, MKDEV(idle_major, 1));
+	class_destroy(idle_class);
+	unregister_chrdev(idle_major, "idle");
+}
+
+module_param(daemon_mode, int, 0);
+MODULE_PARM_DESC(daemon_mode, "Enables idle time accounting even when "
+				"no application uses this device (0 or 1)"
+				"(default=0)");
+
+module_init(idle_init);
+module_exit(idle_exit);
+
+MODULE_AUTHOR("Marcin Slusarz <marcin.slusarz@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b97cdc5..08c284f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -76,6 +76,7 @@ header-y += gigaset_dev.h
 header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
+header-y += idle.h
 header-y += if_addrlabel.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
diff --git a/include/linux/idle.h b/include/linux/idle.h
new file mode 100644
index 0000000..38f8f43
--- /dev/null
+++ b/include/linux/idle.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_IDLE_H
+#define __LINUX_IDLE_H
+
+/* ioctl commands */
+/* get current event (unsigned char) IDLE_IDLE / IDLE_WAKEUP */
+#define IDLE_IOCTL_GET_EVENT 0
+
+/* set timeout */
+#define IDLE_IOCTL_SET 1
+
+/* remove timeout */
+#define IDLE_IOCTL_REMOVE 2
+
+/* get current idle time (seconds) */
+#define IDLE_IOCTL_GET_CURRENT_IDLE 3
+/* end of ioctls */
+
+/* types of events */
+#define IDLE_IDLE   0
+#define IDLE_WAKEUP 1
+
+#endif
-- 
1.6.0.6

