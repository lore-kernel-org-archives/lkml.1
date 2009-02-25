Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbZBYE6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbZBYE6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZBYE6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:58:13 -0500
Received: from mailout5.samsung.com ([203.254.224.35]:53042 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZBYE6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:58:12 -0500
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Feb 2009 23:58:12 EST
Date: Wed, 25 Feb 2009 13:47:30 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Input notifier support
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com
Message-id: <20090225044730.GA9106@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 25 Feb 2009 04:47:35.0412 (UTC)
 FILETIME=[2D666B40:01C99704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.

So add input notifier and then use it at other frameworks such as led.
Of course, other input device can use this one.

Any commnets are welcome.

Thank you,
Kyungmin Park

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 4c9c745..99feb46 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-objs := input.o input-compat.o ff-core.o
+input-core-objs := input.o input-compat.o ff-core.o input_notify.o
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1730d73..7e96635 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -274,6 +274,8 @@ void input_event(struct input_dev *dev,
 		add_input_randomness(type, code, value);
 		input_handle_event(dev, type, code, value);
 		spin_unlock_irqrestore(&dev->event_lock, flags);
+		if (type == EV_KEY)
+			input_notifier_call_chain(value, &code);
 	}
 }
 EXPORT_SYMBOL(input_event);
diff --git a/drivers/input/input_notify.c b/drivers/input/input_notify.c
new file mode 100644
index 0000000..a89cfb6
--- /dev/null
+++ b/drivers/input/input_notify.c
@@ -0,0 +1,43 @@
+/*
+ * Input Notifier
+ *
+ * Copyright (C) 2009 Samsung Electronics
+ * Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/input.h>
+#include <linux/notifier.h>
+
+static BLOCKING_NOTIFIER_HEAD(input_notifier_list);
+
+/**
+ *	input_register_client - register a client notifier
+ *	@nb: notifier block to callback on events
+ */
+int input_register_client(struct notifier_block *nb)
+{
+        return blocking_notifier_chain_register(&input_notifier_list, nb);
+}
+EXPORT_SYMBOL(input_register_client);
+
+/**
+ *	input_unregister_client - unregister a client notifier
+ *	@nb: notifier block to callback on events
+ */
+int input_unregister_client(struct notifier_block *nb)
+{
+        return blocking_notifier_chain_unregister(&input_notifier_list, nb);
+}
+EXPORT_SYMBOL(input_unregister_client);
+
+/**
+ *	input_notifier_call_chain - notify clients of input_events
+ */
+int input_notifier_call_chain(unsigned long val, void *v)
+{
+        return blocking_notifier_call_chain(&input_notifier_list, val, v);
+}
+EXPORT_SYMBOL(input_notifier_call_chain);
diff --git a/include/linux/input.h b/include/linux/input.h
index 1249a0c..7e07bf3 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1325,6 +1325,10 @@ static inline void input_set_abs_params(struct input_dev *dev, int axis, int min
 int input_get_keycode(struct input_dev *dev, int scancode, int *keycode);
 int input_set_keycode(struct input_dev *dev, int scancode, int keycode);
 
+extern int input_register_client(struct notifier_block *nb);
+extern int input_unregister_client(struct notifier_block *nb);
+extern int input_notifier_call_chain(unsigned long val, void *v);
+
 extern struct class input_class;
 
 /**
