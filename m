Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYCJPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYCJPEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYCJPEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:04:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:54181 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYCJPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SCgbFzAmzMejfppuElI7v69g8u3WOYCCOqSpVzo3rGZWjzP2UuWt/r+GAyfYiWhzexz0Cd03k/2pYDR/flfeXyw9Vd23WjtKB6IpBT+R+jcS+tuJi2owBHl7FfgDtC1VUj8LXBfOwjGlnhhb4Ms5YuJy94avGWrYoHgyY1p/OqQ=
Date: Mon, 10 Mar 2008 23:57:05 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/5] lib: introduce call_once()
Message-ID: <20080310145704.GA6396@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_once() is an utility function which has similar functionality of
pthread_once().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/once.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile         |    2 +-
 lib/once.c           |   18 ++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

Index: 2.6-rc/include/linux/once.h
===================================================================
--- /dev/null
+++ 2.6-rc/include/linux/once.h
@@ -0,0 +1,42 @@
+#ifndef __LINUX_ONCE_H
+#define __LINUX_ONCE_H
+
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+
+struct once_control {
+	struct mutex lock;
+	int done;
+};
+
+#define __ONCE_INITIALIZER(name) {					\
+		.lock		= __MUTEX_INITIALIZER(name.lock),	\
+		.done		= 0,					\
+	}
+
+#define DEFINE_ONCE(name) struct once_control name = __ONCE_INITIALIZER(name)
+
+extern int call_once_slow(struct once_control *once_control,
+			  int (*init_rouine)(void));
+
+/*
+ * call_once - call the initialization function only once
+ *
+ * @once_control: guarantee that the init_routine will be called only once
+ * @init_routine: initialization function
+ *
+ * The first call to call_once(), with a given once_control, shall call the
+ * init_routine with no arguments and return the value init_routine returned.
+ * If the init_routine returns zero which indicates the initialization
+ * succeeded, subsequent calls of call_once() with the same once_control shall
+ * not call the init_routine and return zero.
+ */
+
+static inline int call_once(struct once_control *once_control,
+			    int (*init_rouine)(void))
+{
+	return likely(once_control->done) ? 0
+			: call_once_slow(once_control, init_rouine);
+}
+
+#endif /* __LINUX_ONCE_H */
Index: 2.6-rc/lib/once.c
===================================================================
--- /dev/null
+++ 2.6-rc/lib/once.c
@@ -0,0 +1,18 @@
+#include <linux/module.h>
+#include <linux/once.h>
+
+int call_once_slow(struct once_control *once_control, int (*init_rouine)(void))
+{
+	int err = 0;
+
+	mutex_lock(&once_control->lock);
+	if (!once_control->done) {
+		err = init_rouine();
+		if (!err)
+			once_control->done = 1;
+	}
+	mutex_unlock(&once_control->lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(call_once_slow);
Index: 2.6-rc/lib/Makefile
===================================================================
--- 2.6-rc.orig/lib/Makefile
+++ 2.6-rc/lib/Makefile
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o once.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
