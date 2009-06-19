Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZFSNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZFSNmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZFSNmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:42:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38632 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZFSNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:42:32 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] platform_driver_register:  warn if probe is in .init.text
Date: Fri, 19 Jun 2009 15:42:19 +0200
Message-Id: <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616182310.GC13048@pengutronix.de>
References: <20090616182310.GC13048@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c |   42 ++++++++++++++++++++++++++++++++++++------
 include/linux/kernel.h  |    2 ++
 include/linux/module.h  |   12 ++++++++++++
 kernel/extable.c        |   12 ++++++++++++
 kernel/module.c         |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 81cb01b..851ba84 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -470,11 +470,7 @@ static void platform_drv_shutdown(struct device *_dev)
 	drv->shutdown(dev);
 }
 
-/**
- * platform_driver_register
- * @drv: platform driver structure
- */
-int platform_driver_register(struct platform_driver *drv)
+static int __platform_driver_register(struct platform_driver *drv)
 {
 	drv->driver.bus = &platform_bus_type;
 	if (drv->probe)
@@ -489,6 +485,40 @@ int platform_driver_register(struct platform_driver *drv)
 
 	return driver_register(&drv->driver);
 }
+
+/**
+ * platform_driver_register
+ * @drv: platform driver structure
+ */
+int platform_driver_register(struct platform_driver *drv)
+{
+	int ret = __platform_driver_register(drv);
+
+#if defined(CONFIG_HOTPLUG)
+	/*
+	 * drivers that are registered by platform_driver_register
+	 * should not have their probe function in .init.text.  The
+	 * reason is that a probe can happen after .init.text is
+	 * discarded which then results in an oops.  The alternatives
+	 * are using .devinit.text for the probe function or "register"
+	 * with platform_driver_probe.
+	 */
+	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
+		pr_warning("oops-warning: probe function of platform driver %s"
+			       " lives in .init.text\n", drv->driver.name);
+#else
+	/*
+	 * without HOTPLUG probe functions can be discarded after the driver is
+	 * loaded.
+	 * There is a little chance for false positives, namely if the driver is
+	 * registered after the .init sections are discarded.
+	 */
+	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
+		pr_info("probably the probe function of platform driver %s can"
+				" be moved to .init.text\n", drv->driver.name);
+#endif
+	return ret;
+}
 EXPORT_SYMBOL_GPL(platform_driver_register);
 
 /**
@@ -525,7 +555,7 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 
 	/* temporary section violation during probe() */
 	drv->probe = probe;
-	retval = code = platform_driver_register(drv);
+	retval = code = __platform_driver_register(drv);
 
 	/* Fixup that section violation, being paranoid about code scanning
 	 * the list of drivers in order to probe new devices.  Check to see
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c5a71c3..5db1817 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -203,8 +203,10 @@ extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_init_text(unsigned long addr)
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int kernel_init_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
 struct pid;
diff --git a/include/linux/module.h b/include/linux/module.h
index 505f20d..ff07937 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -379,9 +379,11 @@ static inline int module_is_live(struct module *mod)
 }
 
 struct module *__module_text_address(unsigned long addr);
+struct module *__module_init_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+bool is_module_init_text_address(unsigned long addr);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
@@ -550,6 +552,11 @@ static inline struct module *__module_text_address(unsigned long addr)
 	return NULL;
 }
 
+static inline struct module *__module_init_text_address(unsigned long addr)
+{
+	return NULL;
+}
+
 static inline bool is_module_address(unsigned long addr)
 {
 	return false;
@@ -560,6 +567,11 @@ static inline bool is_module_text_address(unsigned long addr)
 	return false;
 }
 
+static inline bool is_module_init_text_address(unsigned long addr)
+{
+	return false;
+}
+
 /* Get/put a kernel symbol (calls should be symmetric) */
 #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
 #define symbol_put(x) do { } while(0)
diff --git a/kernel/extable.c b/kernel/extable.c
index 7f8f263..bfd7bda 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -66,6 +66,11 @@ int core_kernel_text(unsigned long addr)
 	    addr <= (unsigned long)_etext)
 		return 1;
 
+	return core_kernel_init_text;
+}
+
+int core_kernel_init_text(unsigned long addr)
+{
 	if (system_state == SYSTEM_BOOTING &&
 	    init_kernel_text(addr))
 		return 1;
@@ -98,6 +103,13 @@ int kernel_text_address(unsigned long addr)
 	return is_module_text_address(addr);
 }
 
+int kernel_init_text_address(unsigned long addr)
+{
+	if (core_kernel_init_text(addr))
+		return 1;
+	return is_module_init_text_address(addr);
+}
+
 /*
  * On some architectures (PPC64, IA64) function pointers
  * are actually only tokens to some data that then holds the
diff --git a/kernel/module.c b/kernel/module.c
index 215aaab..a637213 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2874,6 +2874,22 @@ bool is_module_text_address(unsigned long addr)
 }
 
 /*
+ * is_module_init_text_address - is this address inside a module's .init.text
+ * section?
+ * @addr: the address to check.
+ */
+bool is_module_init_text_address(unsigned long addr)
+{
+	bool ret;
+
+	preempt_disable();
+	ret = __module_init_text_address(addr) != NULL;
+	preempt_enable();
+
+	return ret;
+}
+
+/*
  * __module_text_address - get the module whose code contains an address.
  * @addr: the address.
  *
@@ -2893,6 +2909,26 @@ struct module *__module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(__module_text_address);
 
+/*
+ * __module_init_text_address - get the module whose .init.text contains an
+ * address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_init_text_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+	if (mod) {
+		/* Make sure it's within the .init.text section. */
+		if (!within(addr, mod->module_init, mod->init_text_size))
+			mod = NULL;
+	}
+	return mod;
+}
+EXPORT_SYMBOL_GPL(__module_init_text_address);
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
-- 
1.6.3.1

