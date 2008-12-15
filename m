Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYLOKdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYLOKdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYLOKdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:33:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:45255 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYLOKde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=njw0hEK9M09FG7dqAlYEezvF+Zl5AUY0RymRVoov0M6kmDTRKQWyncLrX/15tCK5M9
         0uO2BR4SVK4M9EqBPr/v1G6jdv/FjuVyQmh2SZKxbi5WphQZatsXbRHyYnPW+CaRRAnf
         VLhAWqGgmNkQTwUnM+Bv4ked0LdFCRsqJ5Kyg=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, mingo@redhat.com, Magnus Damm <magnus.damm@gmail.com>,
       tglx@linutronix.de
Date: Mon, 15 Dec 2008 19:31:43 +0900
Message-Id: <20081215103143.4254.76464.sendpatchset@rx1.opensource.se>
Subject: [PATCH] early platform drivers V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch is V2 of the early platform driver implementation.

Platform drivers are great for embedded platforms because we
can separate driver configuration from the actual driver. So
base addresses, interrupts and other configuration can be kept
with the processor or board code, and the platform driver can
be reused by many different platforms.

For early devices we have nothing today. For instance, to configure
early timers and early serial ports we cannot use platform devices.
This because the setup order during boot. Timers are needed before
the platform driver core code is available. The same goes for early
printk support. Early in this case means before initcalls.

These early drivers today have their configuration either hard coded
or they receive it using some special configuration method. This is
working quite well, but if we want to support both regular kernel
modules and early devices then we need to have two ways of configuring
the same driver. A single way would be better.

The early platform driver patch is basically a set of functions that
allow drivers to register themselves and architecture code to locate
them and probe. Registration happens through early_param(). The time
for the probe is decided by the architecture code.

The drivers are regular compiled-in modules with the exception that
they also register themselves using early_platform_init():

 +static int __init sh_cmt_init(void)
 +{
 +       return platform_driver_register(&sh_cmt_device_driver);
 +}
 +
 +static void __exit sh_cmt_exit(void)
 +{
 +       platform_driver_unregister(&sh_cmt_device_driver);
 +}
 +
 +early_platform_init("earlytimer", &sh_cmt_device_driver);
 +module_init(sh_cmt_init);
 +module_exit(sh_cmt_exit);

The architecture code can then decide whenever it wants to probe for
early platform devices. The architecture code simply does:

 +void __init time_init(void)
 +{
 +       early_platform_driver_probe("earlytimer", sh_timer_pdevs,
 +                                   sh_timer_nr_pdevs, 1);

This will first make sure that all compiled-in early platform drivers
belonging to the class "earlytimer" get registered. After that the
platform devices passed to the function are scanned through and matched
against the registered early platform drivers. The user can select which
device that should be prioritized by specifying the classname and platform
device name together with id on the kernel commandline. For instance the
string "earlytimer=cmt0" will match the driver named "cmt" with id 0.

Later when the platform device core code is up and running the driver
can turn itself into a regular platform device in the regular probe()
callback.

Comments anyone? Maybe there are better ways to do this?

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
 - changed function names to use "early_" prefix
 - use struct early_platform_driver for data
 - added support for matching against pdev->id
 - use early_platform_init() in device drivers
 - added more comments

 drivers/base/platform.c         |  139 +++++++++++++++++++++++++++++++++++++++
 include/linux/init.h            |    1 
 include/linux/platform_device.h |   29 ++++++++
 init/main.c                     |    7 +
 4 files changed, 175 insertions(+), 1 deletion(-)

--- 0001/drivers/base/platform.c
+++ work/drivers/base/platform.c	2008-12-15 18:03:53.000000000 +0900
@@ -982,3 +982,142 @@ u64 dma_get_required_mask(struct device 
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
+
+static LIST_HEAD(early_platform_driver_list);
+
+/**
+ * early_platform_driver_register
+ * @edrv: early_platform driver structure
+ * @buf: string passed from early_param()
+ */
+int __init early_platform_driver_register(struct early_platform_driver *epdrv,
+					  char *buf)
+{
+	int id = -1;
+
+	/* Simply add the driver to the end of the global list.
+	 * Drivers will by default be put on the list in compiled-in order.
+	 */
+	if (!epdrv->list.next) {
+		INIT_LIST_HEAD(&epdrv->list);
+		list_add_tail(&epdrv->list, &early_platform_driver_list);
+	}
+
+	/* If the user has specified device then make sure the driver
+	 * gets prioritized. The driver of the last device specified on
+	 * command line will be put first on the list.
+	 */
+	if (buf && !strncmp(buf, epdrv->pdrv->driver.name, strlen(buf))) {
+		list_move(&epdrv->list, &early_platform_driver_list);
+		if (strcmp(buf, epdrv->pdrv->driver.name))
+			id = simple_strtoul(buf +
+					    strlen(epdrv->pdrv->driver.name),
+					    NULL, 0);
+	}
+
+	epdrv->requested_id = id;
+	return 0;
+}
+
+/**
+ * early_platform_match
+ * @edrv: early platform driver structure
+ * @pdevs: platform devices to match against
+ * @nr_pdevs: number of platform devices to match against
+ * @id: id to match against
+ * @match: matching platform device
+ */
+static int __init early_platform_match(struct early_platform_driver *epdrv,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int id,
+				       struct platform_device **match)
+{
+	struct platform_device *pdev;
+	int k, n, match_id;
+
+	if (id == -2)
+		match_id = epdrv->requested_id;
+	else
+		match_id = id;
+
+	n = 0;
+	*match = NULL;
+	for (k = 0; k < nr_pdevs; k++) {
+		pdev = pdevs[k];
+		if (platform_match(&pdev->dev, &epdrv->pdrv->driver)) {
+			if (id != -2) /* skip previously checked device */
+				if (match_id == epdrv->requested_id)
+					goto skip;
+
+			if (pdev->id == match_id)
+				*match = pdev;
+
+skip:
+			if (pdev->id > match_id)
+				n++;
+		}
+	}
+
+	return n;
+}
+
+/**
+ * early_platform_driver_probe
+ * @class_str: string to identify early platform driver class
+ * @pdevs: platform devices to match against
+ * @nr_pdevs: number of platform devices to match against
+ * @nr_probe: number of platform devices to successfully probe before exiting
+ */
+int __init early_platform_driver_probe(char *class_str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int nr_probe)
+{
+	struct early_platform_driver *epdrv;
+	struct platform_device *match;
+	int k, n, i;
+
+	/* The "class_str" parameter may or may not be present on the kernel
+	 * command line. If it is present then there may be more than one
+	 * matching parameter.
+	 *
+	 * Since we register our early platform drivers using early_param()
+	 * we need to make sure that they also get registered in the case
+	 * when the parameter is missing from the kernel command line.
+	 *
+	 * We use parse_early_options() to make sure the early_param() gets
+	 * called at least once. The early_param() may be called more than
+	 * once since the name of the preferred device may be specified on
+	 * the kernel command line. early_platform_driver_register() handles
+	 * this case for us.
+	 */
+	parse_early_options(class_str);
+
+	n = 0;
+	list_for_each_entry(epdrv, &early_platform_driver_list, list) {
+		/* only use drivers matching our class_str */
+		if (strcmp(class_str, epdrv->class_str))
+			continue;
+
+		/* start with exact device match, continue with any device */
+		k = 1;
+		for (i = -2; k && n < nr_probe; i++) {
+			k = early_platform_match(epdrv, pdevs, nr_pdevs,
+						 i, &match);
+			if (!match)
+				continue;
+
+			if (epdrv->pdrv->probe(match)) {
+				pr_warning("%s: unable to probe %s early.\n",
+					   class_str, match->name);
+				continue;
+			}
+			n++;
+		}
+	}
+
+	if (!n)
+		pr_warning("%s: no early platform devices found.\n", class_str);
+
+	return n;
+}
+
--- 0001/include/linux/init.h
+++ work/include/linux/init.h	2008-12-15 18:00:09.000000000 +0900
@@ -247,6 +247,7 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+void __init parse_early_options(char *cmdline);
 #endif /* __ASSEMBLY__ */
 
 /**
--- 0001/include/linux/platform_device.h
+++ work/include/linux/platform_device.h	2008-12-15 18:00:09.000000000 +0900
@@ -71,4 +71,33 @@ extern int platform_driver_probe(struct 
 #define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
 #define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
 
+/* early platform driver interface */
+struct early_platform_driver {
+	const char *class_str;
+	struct platform_driver *pdrv;
+	struct list_head list;
+	int requested_id;
+};
+
+extern int early_platform_driver_register(struct early_platform_driver *epdrv,
+					  char *buf);
+extern int early_platform_driver_probe(char *class_str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int nr_probe);
+
+#ifndef MODULE
+#define early_platform_init(class_string, platform_driver)		\
+static __initdata struct early_platform_driver early_driver = {		\
+	.class_str = class_string,					\
+	.pdrv = platform_driver,					\
+};									\
+static int __init early_platform_driver_setup_func(char *buf)		\
+{									\
+	return early_platform_driver_register(&early_driver, buf);	\
+}									\
+early_param(class_string, early_platform_driver_setup_func)
+#else /* MODULE */
+#define early_platform_init(class_string, platform_driver)
+#endif /* MODULE */
+
 #endif /* _PLATFORM_DEVICE_H_ */
--- 0001/init/main.c
+++ work/init/main.c	2008-12-15 18:00:09.000000000 +0900
@@ -503,6 +503,11 @@ static int __init do_early_param(char *p
 	return 0;
 }
 
+void __init parse_early_options(char *cmdline)
+{
+	parse_args("early options", cmdline, NULL, 0, do_early_param);
+}
+
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
@@ -514,7 +519,7 @@ void __init parse_early_param(void)
 
 	/* All fall through to do_early_param. */
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param);
+	parse_early_options(tmp_cmdline);
 	done = 1;
 }
 
