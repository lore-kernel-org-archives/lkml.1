Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXCZV1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXCZV1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXCZV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:27:36 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:7921 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbXCZV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:26:44 -0400
Message-Id: <20070326212641.300051199@de.ibm.com>
References: <20070326212459.711271424@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 23:25:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: [patch 7/8] dasd: Add ipldev parameter.
Content-Disposition: inline; filename=115-dasd-ipldev.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Specifying 'ipldev' in the dasd= kernel parameter will automatically
activate the boot device for use by the dasd driver.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/block/dasd_devmap.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+)

Index: linux-2.6/drivers/s390/block/dasd_devmap.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/dasd_devmap.c
+++ linux-2.6/drivers/s390/block/dasd_devmap.c
@@ -19,6 +19,7 @@
 
 #include <asm/debug.h>
 #include <asm/uaccess.h>
+#include <asm/ipl.h>
 
 /* This is ugly... */
 #define PRINTK_HEADER "dasd_devmap:"
@@ -133,6 +134,8 @@ dasd_call_setup(char *str)
 __setup ("dasd=", dasd_call_setup);
 #endif	/* #ifndef MODULE */
 
+#define	DASD_IPLDEV	"ipldev"
+
 /*
  * Read a device busid/devno from a string.
  */
@@ -141,6 +144,20 @@ dasd_busid(char **str, int *id0, int *id
 {
 	int val, old_style;
 
+	/* Interpret ipldev busid */
+	if (strncmp(DASD_IPLDEV, *str, strlen(DASD_IPLDEV)) == 0) {
+		if (ipl_info.type != IPL_TYPE_CCW) {
+			MESSAGE(KERN_ERR, "%s", "ipl device is not a ccw "
+				"device");
+			return -EINVAL;
+		}
+		*id0 = 0;
+		*id1 = ipl_info.data.ccw.dev_id.ssid;
+		*devno = ipl_info.data.ccw.dev_id.devno;
+		*str += strlen(DASD_IPLDEV);
+
+		return 0;
+	}
 	/* check for leading '0x' */
 	old_style = 0;
 	if ((*str)[0] == '0' && (*str)[1] == 'x') {

-- 
