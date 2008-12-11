Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYLKMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYLKMdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYLKMdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:33:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:10145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYLKMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:33:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=NJyZqkfv8pho9CowO20Si8TpR6/YfGAn66hZ3OfoEffzeBen//1FqWpvZDFHvl3/pS
         MX6MV0X8E5StORDJeEfEiUoEJ63HIUUMwRUy5rqmeG6LyfOvDddlqZELiIpqbIVSPlPx
         NWnM0Hjrg/n2dkynjbkrafJpTSs452fKjQ3yI=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, Magnus Damm <magnus.damm@gmail.com>,
       mingo@redhat.com
Date: Thu, 11 Dec 2008 21:31:11 +0900
Message-Id: <20081211123111.19147.48074.sendpatchset@rx1.opensource.se>
Subject: [PATCH][RFC] early platform driver support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds support for early platform drivers. Early in this
case means earlier than initcalls. This came up since I need
early SuperH timers that can be configured with platform data.

Instead of having non-standard configuration methods for early
core devices such as timers and early serial port code we simply
reuse platform drivers early on. This way platform data can be
used to configure the device both as early platform driver and
kernel module.

The early platform driver code lets core device drivers use
early_param() and from there install our early platform driver.

 >/* early interface, used before platform devices are available */
 >static int __init my_earlytimer(char *buf)
 >{
 >       return platform_driver_register_early(&my_platform_driver, buf);
 >}
 >early_param("earlytimer", my_earlytimer);

platform_driver_register_early() simply adds the platform driver
to a list - to the head or tail of the list depending on if the
user has specified something on the kernel command line or if we
are following the default compiled-in order.

The architecture code lets the early platform code match platform
device data with registered early platform drivers:

  >void __init time_init(void)
  >{
  >       platform_device_setup_early("earlytimer",
  >                                   sh_timer_pdevs, sh_timer_nr_pdevs);

This will make sure that all early platform drivers matching
"earlytimer" get registered and compared with the platform devices
that are specified as arguments.

Later when the device handling code is up and running the early platform
device gets turned into a regular platform device.

Comments anyone? Can you recommend me a better way to do this?

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/base/platform.c         |   65 +++++++++++++++++++++++++++++++++++++++
 include/linux/init.h            |    1 
 include/linux/platform_device.h |    6 +++
 init/main.c                     |    7 +++-
 4 files changed, 78 insertions(+), 1 deletion(-)

--- 0001/drivers/base/platform.c
+++ work/drivers/base/platform.c	2008-12-11 20:52:36.000000000 +0900
@@ -982,3 +982,68 @@ u64 dma_get_required_mask(struct device 
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
+
+static LIST_HEAD(platform_driver_early_list);
+
+/**
+ * platform_driver_register_early
+ * @drv: platform driver structure
+ * @str: string passed from early_param()
+ */
+int __init platform_driver_register_early(struct platform_driver *pdrv,
+					  char *str)
+{
+	/* fallback: parse_early_options() case, use compile-in order */
+	if (!pdrv->early.next) {
+		INIT_LIST_HEAD(&pdrv->early);
+		list_add_tail(&pdrv->early, &platform_driver_early_list);
+	}
+
+	/* last driver specified on command line gets setup first */
+	if (str && !strcmp(str, pdrv->driver.name))
+		list_move(&pdrv->early, &platform_driver_early_list);
+
+	return 0;
+}
+
+/**
+ * platform_device_setup_early
+ * @str: string to match early_param()
+ * @pdevs: platform devices to match against
+ * @nr_pdevs: number of platform devices to match against
+ */
+int __init platform_device_setup_early(char *str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs)
+{
+	struct platform_device *pdev;
+	struct platform_driver *pdrv;
+	int k, n;
+
+	/* fallback: make sure our early_param() gets called even
+	 * if the parameter is missing from the kernel command line.
+	 */
+	parse_early_options(str);
+
+	n = 0;
+	list_for_each_entry(pdrv, &platform_driver_early_list, early) {
+		for (k = 0; k < nr_pdevs; k++) {
+			pdev = pdevs[k];
+			if (strcmp(pdev->name, pdrv->driver.name))
+				continue;
+
+			if (pdrv->probe(pdev)) {
+				pr_warning("%s: unable to setup %s.\n",
+					   str, pdev->name);
+				continue;
+			}
+			n++;
+		}
+	}
+
+	if (!n)
+		pr_warning("%s: no early platform devices found.\n", str);
+
+	return n;
+}
+
--- 0001/include/linux/init.h
+++ work/include/linux/init.h	2008-12-11 19:54:03.000000000 +0900
@@ -247,6 +247,7 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+void __init parse_early_options(char *cmdline);
 #endif /* __ASSEMBLY__ */
 
 /**
--- 0001/include/linux/platform_device.h
+++ work/include/linux/platform_device.h	2008-12-11 19:54:03.000000000 +0900
@@ -57,6 +57,7 @@ struct platform_driver {
 	int (*resume)(struct platform_device *);
 	struct pm_ext_ops *pm;
 	struct device_driver driver;
+	struct list_head early;
 };
 
 extern int platform_driver_register(struct platform_driver *);
@@ -71,4 +72,9 @@ extern int platform_driver_probe(struct 
 #define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
 #define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
 
+extern int platform_driver_register_early(struct platform_driver *pdrv,
+					  char *str);
+extern int platform_device_setup_early(char *str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs);
 #endif /* _PLATFORM_DEVICE_H_ */
--- 0001/init/main.c
+++ work/init/main.c	2008-12-11 19:54:03.000000000 +0900
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
 
