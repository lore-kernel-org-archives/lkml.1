Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZK0IoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZK0IoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZK0IoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:44:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55330 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZK0IoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=mvDROZXGcRVx1LHsJJurDiJhEPTgEyfHjlUsiq+e5wxRXekdxSZJZwIaEwfb4yIADN
         5OmGxHPr/Bs1JscLt/ZWlfYsRApzq2k8RJ/SihHc6OxgQpNHGXY0jpbQHPl+Gzy5JBp0
         JcD0AMfB1k/H9cVLqEQ3npiVTueyqbzfOdhPM=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de, tglx@linutronix.de,
       akpm@linux-foundation.org, lethal@linux-sh.org
Date: Fri, 27 Nov 2009 17:38:51 +0900
Message-Id: <20091127083851.31006.12516.sendpatchset@rxone.opensource.se>
Subject: [PATCH] Driver Core: Early platform driver buffer
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
---

 Sent earlier to the linux-sh list as part of serial rework RFC:
 http://thread.gmane.org/gmane.linux.ports.sh.devel/6878

 I'd be happy to document and/or rewrite parts if needed.

 drivers/base/platform.c         |   29 ++++++++++++++++++++++-------
 include/linux/platform_device.h |   20 +++++++++++++++-----
 2 files changed, 37 insertions(+), 12 deletions(-)

--- 0001/drivers/base/platform.c
+++ work/drivers/base/platform.c	2009-11-05 23:18:06.000000000 +0900
@@ -1000,7 +1000,7 @@ static __initdata LIST_HEAD(early_platfo
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf)
 {
-	unsigned long index;
+	char *tmp;
 	int n;
 
 	/* Simply add the driver to the end of the global list.
@@ -1019,13 +1019,28 @@ int __init early_platform_driver_registe
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
--- 0001/include/linux/platform_device.h
+++ work/include/linux/platform_device.h	2009-11-05 22:24:51.000000000 +0900
@@ -83,6 +83,8 @@ struct early_platform_driver {
 	struct platform_driver *pdrv;
 	struct list_head list;
 	int requested_id;
+	char *buffer;
+	int bufsize;
 };
 
 #define EARLY_PLATFORM_ID_UNSET -2
@@ -102,21 +104,29 @@ extern int early_platform_driver_probe(c
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
