Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYJHBP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYJHBP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 21:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJHBPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 21:15:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:39549 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYJHBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BPXHUn1Od+pzYXG3WouMFUg7H00DkSvubH786qmxPBLCxEAgfz5XS5+IkgvZyG9mjS
         d7aq2lvldqas6dcWIyn9ut8ZOnjtNyqW3XJumx9JEHp+hDeF9Hak3FayzXAc1dVVSkNt
         wypQAXerXdmCVywf8RE2HU1y2o8QO24JWxUEk=
Date: Tue, 7 Oct 2008 21:15:43 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: Refactor evdev 32bit compat to be shareable
	with uinput
Message-ID: <20081008011543.GA2813@amd.corenet.prv>
References: <471118B5.7050503@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471118B5.7050503@overt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

On Sat, Oct 13, 2007 at 12:12:53PM -0700, Philip Langdale wrote:
> Currently, evdev has working 32bit compatibility and uinput does not. uinput
> needs the input_event code that evdev uses, so let's refactor it so it can
> be shared.
> 

It was a pleasure talking to you yesterday. As I promised, here is the
revision of your patch that I would like to commit to the next branch
and I would appreciate if you could give it a try. The changes from the
version you sent to me include hiding all uglies in drivers/input and
also adding compat handling for the force feedback effects.

Sorry for sitting on it for so long.

-- 
Dmitry

Input: refactor evdev 32bit compat to be shareable with uinput

From: Philip Langdale <philipl@overt.org>

Currently, evdev has working 32bit compatibility and uinput does not. uinput
needs the input_event code that evdev uses, so let's refactor it so it can
be shared.

[dtor@mail.ru: add fix for force feedback compat issues]
Signed-off-by: Philip Langdale <philipl@overt.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/Makefile       |    2 
 drivers/input/evdev.c        |  197 ++----------------------------------------
 drivers/input/input-compat.c |  135 +++++++++++++++++++++++++++++
 drivers/input/input-compat.h |   94 ++++++++++++++++++++
 drivers/input/misc/uinput.c  |  172 +++++++++++++++++++++++++++++++------
 5 files changed, 383 insertions(+), 217 deletions(-)
 create mode 100644 drivers/input/input-compat.c
 create mode 100644 drivers/input/input-compat.h


diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 98c4f9a..4c9c745 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-objs := input.o ff-core.o
+input-core-objs := input.o input-compat.o ff-core.o
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 3524bef..377b200 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -19,7 +19,7 @@
 #include <linux/input.h>
 #include <linux/major.h>
 #include <linux/device.h>
-#include <linux/compat.h>
+#include "input-compat.h"
 
 struct evdev {
 	int exist;
@@ -291,187 +291,6 @@ static int evdev_open(struct inode *inode, struct file *file)
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
-struct ff_periodic_effect_compat {
-	__u16 waveform;
-	__u16 period;
-	__s16 magnitude;
-	__s16 offset;
-	__u16 phase;
-
-	struct ff_envelope envelope;
-
-	__u32 custom_len;
-	compat_uptr_t custom_data;
-};
-
-struct ff_effect_compat {
-	__u16 type;
-	__s16 id;
-	__u16 direction;
-	struct ff_trigger trigger;
-	struct ff_replay replay;
-
-	union {
-		struct ff_constant_effect constant;
-		struct ff_ramp_effect ramp;
-		struct ff_periodic_effect_compat periodic;
-		struct ff_condition_effect condition[2]; /* One for each axis */
-		struct ff_rumble_effect rumble;
-	} u;
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
-static int evdev_ff_effect_from_user(const char __user *buffer, size_t size,
-				     struct ff_effect *effect)
-{
-	if (COMPAT_TEST) {
-		struct ff_effect_compat *compat_effect;
-
-		if (size != sizeof(struct ff_effect_compat))
-			return -EINVAL;
-
-		/*
-		 * It so happens that the pointer which needs to be changed
-		 * is the last field in the structure, so we can copy the
-		 * whole thing and replace just the pointer.
-		 */
-
-		compat_effect = (struct ff_effect_compat *)effect;
-
-		if (copy_from_user(compat_effect, buffer,
-				   sizeof(struct ff_effect_compat)))
-			return -EFAULT;
-
-		if (compat_effect->type == FF_PERIODIC &&
-		    compat_effect->u.periodic.waveform == FF_CUSTOM)
-			effect->u.periodic.custom_data =
-				compat_ptr(compat_effect->u.periodic.custom_data);
-	} else {
-		if (size != sizeof(struct ff_effect))
-			return -EINVAL;
-
-		if (copy_from_user(effect, buffer, sizeof(struct ff_effect)))
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
-static int evdev_ff_effect_from_user(const char __user *buffer, size_t size,
-				     struct ff_effect *effect)
-{
-	if (size != sizeof(struct ff_effect))
-		return -EINVAL;
-
-	if (copy_from_user(effect, buffer, sizeof(struct ff_effect)))
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
@@ -491,14 +310,14 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 
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
@@ -532,7 +351,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	struct input_event event;
 	int retval;
 
-	if (count < evdev_event_size())
+	if (count < input_event_size())
 		return -EINVAL;
 
 	if (client->head == client->tail && evdev->exist &&
@@ -547,13 +366,13 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
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
@@ -824,7 +643,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 			if (_IOC_NR(cmd) == _IOC_NR(EVIOCSFF)) {
 
-				if (evdev_ff_effect_from_user(p, _IOC_SIZE(cmd), &effect))
+				if (input_ff_effect_from_user(p, _IOC_SIZE(cmd), &effect))
 					return -EFAULT;
 
 				error = input_ff_upload(dev, &effect, file);
diff --git a/drivers/input/input-compat.c b/drivers/input/input-compat.c
new file mode 100644
index 0000000..1accb89
--- /dev/null
+++ b/drivers/input/input-compat.c
@@ -0,0 +1,135 @@
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
+#include <asm/uaccess.h>
+#include "input-compat.h"
+
+#ifdef CONFIG_COMPAT
+
+int input_event_from_user(const char __user *buffer,
+			  struct input_event *event)
+{
+	if (INPUT_COMPAT_TEST) {
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
+	if (INPUT_COMPAT_TEST) {
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
+int input_ff_effect_from_user(const char __user *buffer, size_t size,
+			      struct ff_effect *effect)
+{
+	if (INPUT_COMPAT_TEST) {
+		struct ff_effect_compat *compat_effect;
+
+		if (size != sizeof(struct ff_effect_compat))
+			return -EINVAL;
+
+		/*
+		 * It so happens that the pointer which needs to be changed
+		 * is the last field in the structure, so we can retrieve the
+		 * whole thing and replace just the pointer.
+		 */
+		compat_effect = (struct ff_effect_compat *)effect;
+
+		if (copy_from_user(compat_effect, buffer,
+				   sizeof(struct ff_effect_compat)))
+			return -EFAULT;
+
+		if (compat_effect->type == FF_PERIODIC &&
+		    compat_effect->u.periodic.waveform == FF_CUSTOM)
+			effect->u.periodic.custom_data =
+				compat_ptr(compat_effect->u.periodic.custom_data);
+	} else {
+		if (size != sizeof(struct ff_effect))
+			return -EINVAL;
+
+		if (copy_from_user(effect, buffer, sizeof(struct ff_effect)))
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
+int input_ff_effect_from_user(const char __user *buffer, size_t size,
+			      struct ff_effect *effect)
+{
+	if (size != sizeof(struct ff_effect))
+		return -EINVAL;
+
+	if (copy_from_user(effect, buffer, sizeof(struct ff_effect)))
+		return -EFAULT;
+
+	return 0;
+}
+
+#endif /* CONFIG_COMPAT */
+
+EXPORT_SYMBOL_GPL(input_event_from_user);
+EXPORT_SYMBOL_GPL(input_event_to_user);
+EXPORT_SYMBOL_GPL(input_ff_effect_from_user);
diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
new file mode 100644
index 0000000..47cd9ea
--- /dev/null
+++ b/drivers/input/input-compat.h
@@ -0,0 +1,94 @@
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
+#include <linux/compiler.h>
+#include <linux/compat.h>
+#include <linux/input.h>
+
+#ifdef CONFIG_COMPAT
+
+/* Note to the author of this code: did it ever occur to
+   you why the ifdefs are needed? Think about it again. -AK */
+#ifdef CONFIG_X86_64
+#  define INPUT_COMPAT_TEST is_compat_task()
+#elif defined(CONFIG_IA64)
+#  define INPUT_COMPAT_TEST IS_IA32_PROCESS(task_pt_regs(current))
+#elif defined(CONFIG_S390)
+#  define INPUT_COMPAT_TEST test_thread_flag(TIF_31BIT)
+#elif defined(CONFIG_MIPS)
+#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT_ADDR)
+#else
+#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT)
+#endif
+
+struct input_event_compat {
+	struct compat_timeval time;
+	__u16 type;
+	__u16 code;
+	__s32 value;
+};
+
+struct ff_periodic_effect_compat {
+	__u16 waveform;
+	__u16 period;
+	__s16 magnitude;
+	__s16 offset;
+	__u16 phase;
+
+	struct ff_envelope envelope;
+
+	__u32 custom_len;
+	compat_uptr_t custom_data;
+};
+
+struct ff_effect_compat {
+	__u16 type;
+	__s16 id;
+	__u16 direction;
+	struct ff_trigger trigger;
+	struct ff_replay replay;
+
+	union {
+		struct ff_constant_effect constant;
+		struct ff_ramp_effect ramp;
+		struct ff_periodic_effect_compat periodic;
+		struct ff_condition_effect condition[2]; /* One for each axis */
+		struct ff_rumble_effect rumble;
+	} u;
+};
+
+static inline size_t input_event_size(void)
+{
+	return INPUT_COMPAT_TEST ?
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
+int input_ff_effect_from_user(const char __user *buffer, size_t size,
+			      struct ff_effect *effect);
+
+#endif /* _INPUT_COMPAT_H */
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 223d56d..a08c270 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
+#include "../input-compat.h"
 
 static int uinput_dev_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
@@ -78,6 +79,7 @@ static struct uinput_request* uinput_request_find(struct uinput_device *udev, in
 	/* Find an input request, by ID. Returns NULL if the ID isn't valid. */
 	if (id >= UINPUT_NUM_REQUESTS || id < 0)
 		return NULL;
+
 	return udev->requests[id];
 }
 
@@ -127,6 +129,17 @@ static int uinput_dev_upload_effect(struct input_dev *dev, struct ff_effect *eff
 	struct uinput_request request;
 	int retval;
 
+	/*
+	 * uinput driver does not currently support periodic effects with
+	 * custom waveform since it does not have a way to pass buffer of
+	 * samples (custom_data) to userspace. If ever there is a device
+	 * supporting custom waveforms we would need to define an additional
+	 * ioctl (UI_UPLOAD_SAMPLES) but for now we just bail out.
+	 */
+	if (effect->type == FF_PERIODIC &&
+			effect->u.periodic.waveform == FF_CUSTOM)
+		return -EINVAL;
+
 	request.id = -1;
 	init_completion(&request.done);
 	request.code = UI_FF_UPLOAD;
@@ -353,15 +366,15 @@ static inline ssize_t uinput_inject_event(struct uinput_device *udev, const char
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
@@ -407,13 +420,13 @@ static ssize_t uinput_read(struct file *file, char __user *buffer, size_t count,
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
@@ -444,6 +457,93 @@ static int uinput_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+struct uinput_ff_upload_compat {
+	int			request_id;
+	int			retval;
+	struct ff_effect_compat	effect;
+	struct ff_effect_compat	old;
+};
+
+static int uinput_ff_upload_to_user(char __user *buffer,
+				    const struct uinput_ff_upload *ff_up)
+{
+	if (INPUT_COMPAT_TEST) {
+		struct uinput_ff_upload_compat ff_up_compat;
+
+		ff_up_cmopat.request_id = ff_up->request_id;
+		ff_up_compat.retval = ff_up->retval;
+		/*
+		 * It so happens that the pointer that gives us the trouble
+		 * is the last field in the structure. Since we don't support
+		 * custom waveforms in uinput anyway we can just copy the whole
+		 * thing (to the compat size) and ignore the pointer.
+		 */
+		memcpy(&ff_compat->effect, &ff_up_compat.effect,
+			sizeof(struct ff_compat_effect));
+		memcpy(&ff_compat.old, &ff_up->old,
+			sizeof(struct ff_compat_effect));
+
+		if (copy_to_user(buffer, &ff_compat_up,
+				 sizeof(struct uinput_ff_upload_compat)))
+			retval = -EFAULT;
+	} else {
+		if (copy_to_user(buffer, ff_up,
+				 sizeof(struct uinput_ff_upload)))
+			retval = -EFAULT;
+	}
+
+	return 0;
+}
+
+static int uinput_ff_upload_from_user(const char __user *buffer
+				      struct uinput_ff_upload *ff_up)
+{
+	if (INPUT_COMPAT_TEST) {
+		struct uinput_ff_upload_compat ff_up_compat;
+
+		if (copy_from_user(&ff_up_compat, buffer,
+				   sizeof(struct uinput_ff_upload_compat)))
+			return -EFAULT;
+
+		ff_up->request_id = ff_up_compat.request_id;
+		ff_up->retval = ff_up_compat.retval;
+		memcpy(&ff->effect, &ff_up_compat.effect,
+			sizeof(struct ff_compat_effect));
+		memcpy(&ff->old, &ff_up_compat.old,
+			sizeof(struct ff_compat_effect));
+
+	} else {
+		if (copy_from_user(ff_up, buffer,
+				   sizeof(struct uinput_ff_upload)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+#else
+
+static int uinput_ff_upload_to_user(char __user *buffer,
+				    const struct uinput_ff_upload *ff_up)
+{
+	if (copy_to_user(buffer, ff_up, sizeof(struct uinput_ff_upload)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int uinput_ff_upload_from_user(const char __user *buffer,
+				      struct uinput_ff_upload *ff_up)
+{
+	if (copy_from_user(ff_up, buffer, sizeof(struct uinput_ff_upload)))
+		return -EFAULT;
+
+	return 0;
+}
+
+#endif
+
 #define uinput_set_bit(_arg, _bit, _max)		\
 ({							\
 	int __ret = 0;					\
@@ -455,19 +555,17 @@ static int uinput_release(struct inode *inode, struct file *file)
 	__ret;						\
 })
 
-static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
+				 unsigned long arg, void __user *p)
 {
 	int			retval;
-	struct uinput_device	*udev;
-	void __user             *p = (void __user *)arg;
+	struct uinput_device	*udev = file->private_data;
 	struct uinput_ff_upload ff_up;
 	struct uinput_ff_erase  ff_erase;
 	struct uinput_request   *req;
 	int                     length;
 	char			*phys;
 
-	udev = file->private_data;
-
 	retval = mutex_lock_interruptible(&udev->mutex);
 	if (retval)
 		return retval;
@@ -549,26 +647,24 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 
 		case UI_BEGIN_FF_UPLOAD:
-			if (copy_from_user(&ff_up, p, sizeof(ff_up))) {
-				retval = -EFAULT;
+			retval = uinput_ff_upload_from_user(p, &ff_up);
+			if (retval)
 				break;
-			}
+
 			req = uinput_request_find(udev, ff_up.request_id);
-			if (!(req && req->code == UI_FF_UPLOAD && req->u.upload.effect)) {
+			if (!req || req->code != UI_FF_UPLOAD || !req->u.upload.effect) {
 				retval = -EINVAL;
 				break;
 			}
+
 			ff_up.retval = 0;
-			memcpy(&ff_up.effect, req->u.upload.effect, sizeof(struct ff_effect));
+			ff_up.effect = *req->u.upload.effect;
 			if (req->u.upload.old)
-				memcpy(&ff_up.old, req->u.upload.old, sizeof(struct ff_effect));
+				ff_up.old = *req->u.upload.old;
 			else
 				memset(&ff_up.old, 0, sizeof(struct ff_effect));
 
-			if (copy_to_user(p, &ff_up, sizeof(ff_up))) {
-				retval = -EFAULT;
-				break;
-			}
+			retval = uinput_ff_upload_to_user(p, &ff_up);
 			break;
 
 		case UI_BEGIN_FF_ERASE:
@@ -576,29 +672,34 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				retval = -EFAULT;
 				break;
 			}
+
 			req = uinput_request_find(udev, ff_erase.request_id);
-			if (!(req && req->code == UI_FF_ERASE)) {
+			if (!req || req->code != UI_FF_ERASE) {
 				retval = -EINVAL;
 				break;
 			}
+
 			ff_erase.retval = 0;
 			ff_erase.effect_id = req->u.effect_id;
 			if (copy_to_user(p, &ff_erase, sizeof(ff_erase))) {
 				retval = -EFAULT;
 				break;
 			}
+
 			break;
 
 		case UI_END_FF_UPLOAD:
-			if (copy_from_user(&ff_up, p, sizeof(ff_up))) {
-				retval = -EFAULT;
+			retval = uinput_ff_upload_from_user(p, &ff_up);
+			if (retval)
 				break;
-			}
+
 			req = uinput_request_find(udev, ff_up.request_id);
-			if (!(req && req->code == UI_FF_UPLOAD && req->u.upload.effect)) {
+			if (!req || req->code != UI_FF_UPLOAD ||
+			    !req->u.upload.effect) {
 				retval = -EINVAL;
 				break;
 			}
+
 			req->retval = ff_up.retval;
 			uinput_request_done(udev, req);
 			break;
@@ -608,11 +709,13 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				retval = -EFAULT;
 				break;
 			}
+
 			req = uinput_request_find(udev, ff_erase.request_id);
-			if (!(req && req->code == UI_FF_ERASE)) {
+			if (!req || req->code != UI_FF_ERASE) {
 				retval = -EINVAL;
 				break;
 			}
+
 			req->retval = ff_erase.retval;
 			uinput_request_done(udev, req);
 			break;
@@ -626,6 +729,18 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return retval;
 }
 
+static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return uinput_ioctl_handler(file, cmd, arg, (void __user *)arg);
+}
+
+#ifdef CONFIG_COMPAT
+static long uinput_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return uinput_ioctl_handler(file, cmd, arg, compat_ptr(arg));
+}
+#endif
+
 static const struct file_operations uinput_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uinput_open,
@@ -634,6 +749,9 @@ static const struct file_operations uinput_fops = {
 	.write		= uinput_write,
 	.poll		= uinput_poll,
 	.unlocked_ioctl	= uinput_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= uinput_compat_ioctl,
+#endif
 };
 
 static struct miscdevice uinput_misc = {
