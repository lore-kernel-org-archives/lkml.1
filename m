Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXEYIij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXEYIij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbXEYIhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:35 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40501 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758623AbXEYIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:30 -0400
Message-Id: <20070525083632.276306000@sonycom.com>
References: <20070525083607.784351000@sonycom.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 May 2007 10:36:09 +0200
From: Geert.Uytterhoeven@sonycom.com
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [patch 2/7] ps3: Extract ps3_repository_find_bus()
Content-Disposition: inline; filename=ps3_repository_find_bus.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Repository updates:
  - Extract ps3_repository_find_bus() from ps3_repository_find_device(), as the
    storage driver needs it
  - Make ps3_repository_find_device() return -ENODEV if a device is not found,
    just like if a bus is not found

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 arch/powerpc/platforms/ps3/platform.h   |    2 +
 arch/powerpc/platforms/ps3/repository.c |   50 ++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 18 deletions(-)

--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -134,6 +134,8 @@ struct ps3_repository_device {
 	struct ps3_device_id did;
 };
 
+int ps3_repository_find_bus(enum ps3_bus_type bus_type, unsigned int from,
+	unsigned int *bus_index);
 int ps3_repository_find_device(enum ps3_bus_type bus_type,
 	enum ps3_dev_type dev_type,
 	const struct ps3_repository_device *start_dev,
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -513,6 +513,31 @@ int ps3_repository_dump_bus_info(void)
 }
 #endif /* defined(DEBUG) */
 
+int ps3_repository_find_bus(enum ps3_bus_type bus_type, unsigned int from,
+	unsigned int *bus_index)
+{
+	unsigned int i;
+	enum ps3_bus_type type;
+	int error;
+
+	for (i = from; i < 10; i++) {
+		error = ps3_repository_read_bus_type(i, &type);
+		if (error) {
+			pr_debug("%s:%d read_bus_type failed\n",
+				__func__, __LINE__);
+			*bus_index = UINT_MAX;
+			return error;
+		}
+		if (type == bus_type) {
+			*bus_index = i;
+			return 0;
+		}
+	}
+	*bus_index = UINT_MAX;
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(ps3_repository_find_bus);
+
 static int find_device(unsigned int bus_index, unsigned int num_dev,
 	unsigned int start_dev_index, enum ps3_dev_type dev_type,
 	struct ps3_repository_device *dev)
@@ -541,7 +566,7 @@ static int find_device(unsigned int bus_
 	}
 
 	if (dev_index == num_dev)
-		return -1;
+		return -ENODEV;
 
 	pr_debug("%s:%d: found dev_type %u at dev_index %u\n",
 		__func__, __LINE__, dev_type, dev_index);
@@ -577,25 +602,14 @@ int ps3_repository_find_device (enum ps3
 
 	BUG_ON(start_dev && start_dev->bus_index > 10);
 
-	for (bus_index = start_dev ? start_dev->bus_index : 0; bus_index < 10;
-		bus_index++) {
-		enum ps3_bus_type x;
-
-		result = ps3_repository_read_bus_type(bus_index, &x);
-
-		if (result) {
-			pr_debug("%s:%d read_bus_type failed\n",
-				__func__, __LINE__);
-			dev->bus_index = UINT_MAX;
-			return result;
-		}
-		if (x == bus_type)
-			break;
+	result = ps3_repository_find_bus(bus_type,
+					 start_dev ? start_dev->bus_index : 0,
+					 &bus_index);
+	if (result) {
+		dev->bus_index = UINT_MAX;
+		return result;
 	}
 
-	if (bus_index >= 10)
-		return -ENODEV;
-
 	pr_debug("%s:%d: found bus_type %u at bus_index %u\n",
 		__func__, __LINE__, bus_type, bus_index);
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

