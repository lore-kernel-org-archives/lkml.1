Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXJMTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXJMTNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbXJMTNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:13:04 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50667 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755823AbXJMTNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:13:01 -0400
Message-ID: <471118B5.7050503@overt.org>
Date: Sat, 13 Oct 2007 12:12:53 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: Refactor evdev 32bit compat to be shareable with uinput
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, evdev has working 32bit compatibility and uinput does not. uinput
needs the input_event code that evdev uses, so let's refactor it so it can
be shared.

Signed-off-by: Philip Langdale <philipl@overt.org>
---

drivers/input/Makefile       |    2
drivers/input/evdev.c        |  118 ++-----------------------------------------
drivers/input/input_compat.c |   89 ++++++++++++++++++++++++++++++++
drivers/input/misc/uinput.c  |   23 ++++++--
include/linux/input_compat.h |   61 ++++++++++++++++++++++
5 files changed, 175 insertions(+), 118 deletions(-)

diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 15eb752..92f34da 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.

 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-objs := input.o ff-core.o
+input-core-objs := input.o input_compat.o ff-core.o

 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 27026f7..91b086c 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -17,9 +17,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
+#include <linux/input_compat.h>
 #include <linux/major.h>
 #include <linux/device.h>
-#include <linux/compat.h>

 struct evdev {
 	int exist;
@@ -294,110 +294,6 @@ static int evdev_open(struct inode *inode, struct file *file)
 	return error;
 }

-#ifdef CONFIG_COMPAT
-
-struct input_event_compat {
-	struct compat_timeval time;
-	__u16 type;
-	__u16 code;
-	__s32 value;
-};
-
-/* Note to the author of this code: did it ever occur to
-   you why the ifdefs are needed? Think about it again. -AK */
-#ifdef CONFIG_X86_64
-#  define COMPAT_TEST is_compat_task()
-#elif defined(CONFIG_IA64)
-#  define COMPAT_TEST IS_IA32_PROCESS(task_pt_regs(current))
-#elif defined(CONFIG_S390)
-#  define COMPAT_TEST test_thread_flag(TIF_31BIT)
-#elif defined(CONFIG_MIPS)
-#  define COMPAT_TEST test_thread_flag(TIF_32BIT_ADDR)
-#else
-#  define COMPAT_TEST test_thread_flag(TIF_32BIT)
-#endif
-
-static inline size_t evdev_event_size(void)
-{
-	return COMPAT_TEST ?
-		sizeof(struct input_event_compat) : sizeof(struct input_event);
-}
-
-static int evdev_event_from_user(const char __user *buffer,
-				 struct input_event *event)
-{
-	if (COMPAT_TEST) {
-		struct input_event_compat compat_event;
-
-		if (copy_from_user(&compat_event, buffer,
-				   sizeof(struct input_event_compat)))
-			return -EFAULT;
-
-		event->time.tv_sec = compat_event.time.tv_sec;
-		event->time.tv_usec = compat_event.time.tv_usec;
-		event->type = compat_event.type;
-		event->code = compat_event.code;
-		event->value = compat_event.value;
-
-	} else {
-		if (copy_from_user(event, buffer, sizeof(struct input_event)))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-static int evdev_event_to_user(char __user *buffer,
-				const struct input_event *event)
-{
-	if (COMPAT_TEST) {
-		struct input_event_compat compat_event;
-
-		compat_event.time.tv_sec = event->time.tv_sec;
-		compat_event.time.tv_usec = event->time.tv_usec;
-		compat_event.type = event->type;
-		compat_event.code = event->code;
-		compat_event.value = event->value;
-
-		if (copy_to_user(buffer, &compat_event,
-				 sizeof(struct input_event_compat)))
-			return -EFAULT;
-
-	} else {
-		if (copy_to_user(buffer, event, sizeof(struct input_event)))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-#else
-
-static inline size_t evdev_event_size(void)
-{
-	return sizeof(struct input_event);
-}
-
-static int evdev_event_from_user(const char __user *buffer,
-				 struct input_event *event)
-{
-	if (copy_from_user(event, buffer, sizeof(struct input_event)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int evdev_event_to_user(char __user *buffer,
-				const struct input_event *event)
-{
-	if (copy_to_user(buffer, event, sizeof(struct input_event)))
-		return -EFAULT;
-
-	return 0;
-}
-
-#endif /* CONFIG_COMPAT */
-
 static ssize_t evdev_write(struct file *file, const char __user *buffer,
 			   size_t count, loff_t *ppos)
 {
@@ -417,14 +313,14 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,

 	while (retval < count) {

-		if (evdev_event_from_user(buffer + retval, &event)) {
+		if (input_event_from_user(buffer + retval, &event)) {
 			retval = -EFAULT;
 			goto out;
 		}

 		input_inject_event(&evdev->handle,
 				   event.type, event.code, event.value);
-		retval += evdev_event_size();
+		retval += input_event_size();
 	}

  out:
@@ -458,7 +354,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	struct input_event event;
 	int retval;

-	if (count < evdev_event_size())
+	if (count < input_event_size())
 		return -EINVAL;

 	if (client->head == client->tail && evdev->exist &&
@@ -473,13 +369,13 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	if (!evdev->exist)
 		return -ENODEV;

-	while (retval + evdev_event_size() <= count &&
+	while (retval + input_event_size() <= count &&
 	       evdev_fetch_next_event(client, &event)) {

-		if (evdev_event_to_user(buffer + retval, &event))
+		if (input_event_to_user(buffer + retval, &event))
 			return -EFAULT;

-		retval += evdev_event_size();
+		retval += input_event_size();
 	}

 	return retval;
diff --git a/drivers/input/input_compat.c b/drivers/input/input_compat.c
new file mode 100644
index 0000000..d1db814
--- /dev/null
+++ b/drivers/input/input_compat.c
@@ -0,0 +1,89 @@
+/*
+ * 32bit compatibility wrappers for the input subsystem.
+ *
+ * Very heavily based on evdev.c - Copyright (c) 1999-2002 Vojtech Pavlik
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/poll.h>
+#include <linux/input.h>
+#include <linux/input_compat.h>
+
+#ifdef CONFIG_COMPAT
+
+int input_event_from_user(const char __user *buffer,
+			 struct input_event *event)
+{
+	if (COMPAT_TEST) {
+		struct input_event_compat compat_event;
+
+		if (copy_from_user(&compat_event, buffer,
+				   sizeof(struct input_event_compat)))
+			return -EFAULT;
+
+		event->time.tv_sec = compat_event.time.tv_sec;
+		event->time.tv_usec = compat_event.time.tv_usec;
+		event->type = compat_event.type;
+		event->code = compat_event.code;
+		event->value = compat_event.value;
+
+	} else {
+		if (copy_from_user(event, buffer, sizeof(struct input_event)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+int input_event_to_user(char __user *buffer,
+			const struct input_event *event)
+{
+	if (COMPAT_TEST) {
+		struct input_event_compat compat_event;
+
+		compat_event.time.tv_sec = event->time.tv_sec;
+		compat_event.time.tv_usec = event->time.tv_usec;
+		compat_event.type = event->type;
+		compat_event.code = event->code;
+		compat_event.value = event->value;
+
+		if (copy_to_user(buffer, &compat_event,
+				 sizeof(struct input_event_compat)))
+			return -EFAULT;
+
+	} else {
+		if (copy_to_user(buffer, event, sizeof(struct input_event)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+#else
+
+int input_event_from_user(const char __user *buffer,
+			 struct input_event *event)
+{
+	if (copy_from_user(event, buffer, sizeof(struct input_event)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int input_event_to_user(char __user *buffer,
+			const struct input_event *event)
+{
+	if (copy_to_user(buffer, event, sizeof(struct input_event)))
+		return -EFAULT;
+
+	return 0;
+}
+
+#endif /* CONFIG_COMPAT */
+
+EXPORT_SYMBOL_GPL(input_event_from_user);
+EXPORT_SYMBOL_GPL(input_event_to_user);
+
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index a56ad4b..e8641b2 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
+#include <linux/input_compat.h>

 static int uinput_dev_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
@@ -351,15 +352,15 @@ static inline ssize_t uinput_inject_event(struct uinput_device *udev, const char
 {
 	struct input_event ev;

-	if (count != sizeof(struct input_event))
+	if (count < input_event_size())
 		return -EINVAL;

-	if (copy_from_user(&ev, buffer, sizeof(struct input_event)))
+	if (input_event_from_user(buffer, &ev))
 		return -EFAULT;

 	input_event(udev->dev, ev.type, ev.code, ev.value);

-	return sizeof(struct input_event);
+	return input_event_size();
 }

 static ssize_t uinput_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
@@ -405,13 +406,13 @@ static ssize_t uinput_read(struct file *file, char __user *buffer, size_t count,
 		goto out;
 	}

-	while (udev->head != udev->tail && retval + sizeof(struct input_event) <= count) {
-		if (copy_to_user(buffer + retval, &udev->buff[udev->tail], sizeof(struct input_event))) {
+	while (udev->head != udev->tail && retval + input_event_size() <= count) {
+		if (input_event_to_user(buffer + retval, &udev->buff[udev->tail])) {
 			retval = -EFAULT;
 			goto out;
 		}
 		udev->tail = (udev->tail + 1) % UINPUT_BUFFER_SIZE;
-		retval += sizeof(struct input_event);
+		retval += input_event_size();
 	}

  out:
@@ -624,6 +625,13 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return retval;
 }

+#ifdef CONFIG_COMPAT
+static long uinput_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return uinput_ioctl(file, cmd, compat_ptr(arg));
+}
+#endif
+
 static const struct file_operations uinput_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uinput_open,
@@ -632,6 +640,9 @@ static const struct file_operations uinput_fops = {
 	.write		= uinput_write,
 	.poll		= uinput_poll,
 	.unlocked_ioctl	= uinput_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= uinput_compat_ioctl,
+#endif
 };

 static struct miscdevice uinput_misc = {
diff --git a/include/linux/input_compat.h b/include/linux/input_compat.h
new file mode 100644
index 0000000..b7d5487
--- /dev/null
+++ b/include/linux/input_compat.h
@@ -0,0 +1,61 @@
+#ifndef _INPUT_COMPAT_H
+#define _INPUT_COMPAT_H
+
+/*
+ * 32bit compatibility wrappers for the input subsystem.
+ *
+ * Very heavily based on evdev.c - Copyright (c) 1999-2002 Vojtech Pavlik
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/input.h>
+#include <linux/compat.h>
+
+#ifdef CONFIG_COMPAT
+
+/* Note to the author of this code: did it ever occur to
+   you why the ifdefs are needed? Think about it again. -AK */
+#ifdef CONFIG_X86_64
+#  define COMPAT_TEST is_compat_task()
+#elif defined(CONFIG_IA64)
+#  define COMPAT_TEST IS_IA32_PROCESS(task_pt_regs(current))
+#elif defined(CONFIG_S390)
+#  define COMPAT_TEST test_thread_flag(TIF_31BIT)
+#elif defined(CONFIG_MIPS)
+#  define COMPAT_TEST test_thread_flag(TIF_32BIT_ADDR)
+#else
+#  define COMPAT_TEST test_thread_flag(TIF_32BIT)
+#endif
+
+struct input_event_compat {
+	struct compat_timeval time;
+	__u16 type;
+	__u16 code;
+	__s32 value;
+};
+
+static inline size_t input_event_size(void)
+{
+	return COMPAT_TEST ?
+		sizeof(struct input_event_compat) : sizeof(struct input_event);
+}
+
+#else
+
+static inline size_t input_event_size(void)
+{
+	return sizeof(struct input_event);
+}
+
+#endif /* CONFIG_COMPAT */
+
+int input_event_from_user(const char __user *buffer,
+			 struct input_event *event);
+
+int input_event_to_user(char __user *buffer,
+			const struct input_event *event);
+
+#endif /* _INPUT_COMPAT_H */
