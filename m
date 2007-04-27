Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbXD0OPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbXD0OPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXD0OGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:01 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:20287 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbXD0OE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:56 -0400
Message-Id: <20070427140513.857001722@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 09/38] cio: Use add_uevent_var.
Content-Disposition: inline; filename=107-cio-adduevent.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Convert ccw_uevent to use add_uevent_var and adapt snprint_alias.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |   66 ++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 40 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c	2007-04-27 16:04:53.000000000 +0200
+++ quilt-2.6/drivers/s390/cio/device.c	2007-04-27 16:04:54.000000000 +0200
@@ -56,13 +56,12 @@
 /* Store modalias string delimited by prefix/suffix string into buffer with
  * specified size. Return length of resulting string (excluding trailing '\0')
  * even if string doesn't fit buffer (snprintf semantics). */
-static int snprint_alias(char *buf, size_t size, const char *prefix,
+static int snprint_alias(char *buf, size_t size,
 			 struct ccw_device_id *id, const char *suffix)
 {
 	int len;
 
-	len = snprintf(buf, size, "%sccw:t%04Xm%02X", prefix, id->cu_type,
-		       id->cu_model);
+	len = snprintf(buf, size, "ccw:t%04Xm%02X", id->cu_type, id->cu_model);
 	if (len > size)
 		return len;
 	buf += len;
@@ -85,53 +84,40 @@
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct ccw_device_id *id = &(cdev->id);
 	int i = 0;
-	int len;
+	int len = 0;
+	int ret;
+	char modalias_buf[30];
 
 	/* CU_TYPE= */
-	len = snprintf(buffer, buffer_size, "CU_TYPE=%04X", id->cu_type) + 1;
-	if (len > buffer_size || i >= num_envp)
-		return -ENOMEM;
-	envp[i++] = buffer;
-	buffer += len;
-	buffer_size -= len;
+	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
+			     "CU_TYPE=%04X", id->cu_type);
+	if (ret)
+		return ret;
 
 	/* CU_MODEL= */
-	len = snprintf(buffer, buffer_size, "CU_MODEL=%02X", id->cu_model) + 1;
-	if (len > buffer_size || i >= num_envp)
-		return -ENOMEM;
-	envp[i++] = buffer;
-	buffer += len;
-	buffer_size -= len;
+	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
+			     "CU_MODEL=%02X", id->cu_model);
+	if (ret)
+		return ret;
 
 	/* The next two can be zero, that's ok for us */
 	/* DEV_TYPE= */
-	len = snprintf(buffer, buffer_size, "DEV_TYPE=%04X", id->dev_type) + 1;
-	if (len > buffer_size || i >= num_envp)
-		return -ENOMEM;
-	envp[i++] = buffer;
-	buffer += len;
-	buffer_size -= len;
+	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
+			     "DEV_TYPE=%04X", id->dev_type);
+	if (ret)
+		return ret;
 
 	/* DEV_MODEL= */
-	len = snprintf(buffer, buffer_size, "DEV_MODEL=%02X",
-			(unsigned char) id->dev_model) + 1;
-	if (len > buffer_size || i >= num_envp)
-		return -ENOMEM;
-	envp[i++] = buffer;
-	buffer += len;
-	buffer_size -= len;
+	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
+			     "DEV_MODEL=%02X", id->dev_model);
+	if (ret)
+		return ret;
 
 	/* MODALIAS=  */
-	len = snprint_alias(buffer, buffer_size, "MODALIAS=", id, "") + 1;
-	if (len > buffer_size || i >= num_envp)
-		return -ENOMEM;
-	envp[i++] = buffer;
-	buffer += len;
-	buffer_size -= len;
-
-	envp[i] = NULL;
-
-	return 0;
+	snprint_alias(modalias_buf, sizeof(modalias_buf), id, "");
+	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
+			     "MODALIAS=%s", modalias_buf);
+	return ret;
 }
 
 struct bus_type ccw_bus_type;
@@ -280,7 +266,7 @@
 	struct ccw_device_id *id = &(cdev->id);
 	int len;
 
-	len = snprint_alias(buf, PAGE_SIZE, "", id, "\n") + 1;
+	len = snprint_alias(buf, PAGE_SIZE, id, "\n") + 1;
 
 	return len > PAGE_SIZE ? PAGE_SIZE : len;
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

