Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbZLKWbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbZLKWbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934167AbZLKWbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:31:22 -0500
Received: from kroah.org ([198.145.64.141]:32838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762763AbZLKWZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/27] Driver Core: Early platform driver buffer
Date: Fri, 11 Dec 2009 14:24:48 -0800
Message-Id: <1260570289-6997-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add early_platform_init_buffer() support and update the
early platform driver code to allow passing parameters
to the driver on the kernel command line.

early_platform_init_buffer() simply allows early platform
drivers to provide a pointer and length to a memory area
where the remaining part of the kernel command line option
will be stored.

Needed to pass baud rate and other serial port options
to the reworked early serial console code on SuperH.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |   29 ++++++++++++++++++++++-------
 include/linux/platform_device.h |   20 +++++++++++++++-----
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4fa954b..9d2ee25 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1000,7 +1000,7 @@ static __initdata LIST_HEAD(early_platform_device_list);
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf)
 {
-	unsigned long index;
+	char *tmp;
 	int n;
 
 	/* Simply add the driver to the end of the global list.
@@ -1019,13 +1019,28 @@ int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 	if (buf && !strncmp(buf, epdrv->pdrv->driver.name, n)) {
 		list_move(&epdrv->list, &early_platform_driver_list);
 
-		if (!strcmp(buf, epdrv->pdrv->driver.name))
+		/* Allow passing parameters after device name */
+		if (buf[n] == '\0' || buf[n] == ',')
 			epdrv->requested_id = -1;
-		else if (buf[n] == '.' && strict_strtoul(&buf[n + 1], 10,
-							 &index) == 0)
-			epdrv->requested_id = index;
-		else
-			epdrv->requested_id = EARLY_PLATFORM_ID_ERROR;
+		else {
+			epdrv->requested_id = simple_strtoul(&buf[n + 1],
+							     &tmp, 10);
+
+			if (buf[n] != '.' || (tmp == &buf[n + 1])) {
+				epdrv->requested_id = EARLY_PLATFORM_ID_ERROR;
+				n = 0;
+			} else
+				n += strcspn(&buf[n + 1], ",") + 1;
+		}
+
+		if (buf[n] == ',')
+			n++;
+
+		if (epdrv->bufsize) {
+			memcpy(epdrv->buffer, &buf[n],
+			       min_t(int, epdrv->bufsize, strlen(&buf[n]) + 1));
+			epdrv->buffer[epdrv->bufsize - 1] = '\0';
+		}
 	}
 
 	return 0;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 3c6675c..71ff887 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -83,6 +83,8 @@ struct early_platform_driver {
 	struct platform_driver *pdrv;
 	struct list_head list;
 	int requested_id;
+	char *buffer;
+	int bufsize;
 };
 
 #define EARLY_PLATFORM_ID_UNSET -2
@@ -102,21 +104,29 @@ extern int early_platform_driver_probe(char *class_str,
 				       int nr_probe, int user_only);
 extern void early_platform_cleanup(void);
 
+#define early_platform_init(class_string, platdrv)		\
+	early_platform_init_buffer(class_string, platdrv, NULL, 0)
 
 #ifndef MODULE
-#define early_platform_init(class_string, platform_driver)		\
+#define early_platform_init_buffer(class_string, platdrv, buf, bufsiz)	\
 static __initdata struct early_platform_driver early_driver = {		\
 	.class_str = class_string,					\
-	.pdrv = platform_driver,					\
+	.buffer = buf,							\
+	.bufsize = bufsiz,						\
+	.pdrv = platdrv,						\
 	.requested_id = EARLY_PLATFORM_ID_UNSET,			\
 };									\
-static int __init early_platform_driver_setup_func(char *buf)		\
+static int __init early_platform_driver_setup_func(char *buffer)	\
 {									\
-	return early_platform_driver_register(&early_driver, buf);	\
+	return early_platform_driver_register(&early_driver, buffer);	\
 }									\
 early_param(class_string, early_platform_driver_setup_func)
 #else /* MODULE */
-#define early_platform_init(class_string, platform_driver)
+#define early_platform_init_buffer(class_string, platdrv, buf, bufsiz)	\
+static inline char *early_platform_driver_setup_func(void)		\
+{									\
+	return bufsiz ? buf : NULL;					\
+}
 #endif /* MODULE */
 
 #endif /* _PLATFORM_DEVICE_H_ */
-- 
1.6.5.5

