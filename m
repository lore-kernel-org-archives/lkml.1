Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbZGQIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbZGQIew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZGQIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:34:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55857 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179AbZGQIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:34:49 -0400
Date: Fri, 17 Jul 2009 10:34:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20090717083446.GA12135@pengutronix.de>
References: <20090616182310.GC13048@pengutronix.de> <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090619141128.GA11506@suse.de> <20090619144354.GA20985@pengutronix.de> <20090629075535.GA20155@pengutronix.de> <20090711033459.GC1344@suse.de> <20090711100014.GA9540@pengutronix.de> <20090711185920.GB25363@kroah.com> <20090711204631.GA12446@pengutronix.de> <20090716225809.GA3609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090716225809.GA3609@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

> > > This code kills the build in very bad ways :(
> > it's just a ; that didn't made it into the new version.  Don't know why.
> > 
> > If you squash the patch below into the patch I sent it should work
> > again.
> 
> I don't have the original anymore :(
See below.  I changed the wording of the output in the !HOTPLUG case to
say .devinit.text instead of .init.text and fixed a typo in the commit
log.  Other than that the patch is unchanged.
 
> As it seemed that a lot of people who controlled the problem drivers
> didn't like the patches, what are you considering doing now?
Hmm, there are only two people that expressed not being completly happy
with my suggestions.

I think I will just drop the a patches for now and later just point out
the problem.  (At least for David's nacked drivers I feel little urge to
implement the alternative fix.)

And maybe if the "warn if probe is in .init.text" patch is merged the
people seeing the problem become more numerous which I hope will either
increase the positive feedback for the other patches or someone else
will propose a patch implementing the alternative.  (Maybe I should just
BUG() instead of only printing a warning :-)

Best regards and thanks for your ping on the subject
Uwe

--->8---
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: platform_driver_register:  warn if probe is in .init.text

with HOTPLUG=y it's wrong to register a platform_driver who's probe
function lives in .init.text because the probe function can be called
(e.g. via sysfs or by registering a device late) after the init sections
are already discarded.  This results in an oops.

So warn if such a driver is registered.

Without HOTPLUG the probe function can (and should) be discarded if the
driver is registered while the init sections are still available.
In this case warn if the probe function isn't discarded later.  (As
described in the comments there is a small chance for a wrong warning.
But as HOTPLUG=n is unusual today and the situation is strage enough to
be cleaned up anyhow, I think this is OK.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c |   43 +++++++++++++++++++++++++++++++++++++------
 include/linux/kernel.h  |    2 ++
 include/linux/module.h  |   12 ++++++++++++
 kernel/extable.c        |   12 ++++++++++++
 kernel/module.c         |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 81cb01b..68ef8cc 100644
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
@@ -489,6 +485,41 @@ int platform_driver_register(struct platform_driver *drv)
 
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
+				" be moved to .devinit.text\n",
+				drv->driver.name);
+#endif
+	return ret;
+}
 EXPORT_SYMBOL_GPL(platform_driver_register);
 
 /**
@@ -525,7 +556,7 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 
 	/* temporary section violation during probe() */
 	drv->probe = probe;
-	retval = code = platform_driver_register(drv);
+	retval = code = __platform_driver_register(drv);
 
 	/* Fixup that section violation, being paranoid about code scanning
 	 * the list of drivers in order to probe new devices.  Check to see
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..2d48087 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -203,8 +203,10 @@ extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_init_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int kernel_init_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
 struct pid;
diff --git a/include/linux/module.h b/include/linux/module.h
index 098bdb7..93f47c4 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -385,9 +385,11 @@ static inline int module_is_live(struct module *mod)
 }
 
 struct module *__module_text_address(unsigned long addr);
+struct module *__module_init_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+bool is_module_init_text_address(unsigned long addr);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
@@ -556,6 +558,11 @@ static inline struct module *__module_text_address(unsigned long addr)
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
@@ -566,6 +573,11 @@ static inline bool is_module_text_address(unsigned long addr)
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
index 0a04983..f1fbeb0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2890,6 +2890,22 @@ bool is_module_text_address(unsigned long addr)
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
@@ -2909,6 +2925,26 @@ struct module *__module_text_address(unsigned long addr)
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
1.6.3.3

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
