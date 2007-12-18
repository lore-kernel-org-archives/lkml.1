Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXLRNtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXLRNtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:49:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbXLRNsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:48:54 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3157 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755088AbXLRNsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:48:53 -0500
Date: Tue, 18 Dec 2007 14:48:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] dmi: Let drivers walk the DMI table
Message-ID: <20071218144850.55e916c1@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch is for review and comments, not merge. As the first user for
this new functionality is a hardware monitoring driver [1], this patch
will be better merged via the hwmon tree. If anyone has objections with
regards to this patch, please let me know.

[1] http://lists.lm-sensors.org/pipermail/lm-sensors/2007-December/022164.html

* * * * *

Let drivers walk the DMI table for their own needs. Some drivers need
data stored in OEM-specific DMI records for proper operation.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/firmware/dmi_scan.c |   61 +++++++++++++++++++++++++++++++++----------
 include/linux/dmi.h         |    3 ++
 2 files changed, 50 insertions(+), 14 deletions(-)

--- linux-2.6.24-rc5.orig/drivers/firmware/dmi_scan.c	2007-12-12 12:36:34.000000000 +0100
+++ linux-2.6.24-rc5/drivers/firmware/dmi_scan.c	2007-12-18 14:27:28.000000000 +0100
@@ -36,18 +36,12 @@ static char * __init dmi_string(const st
  *	We have to be cautious here. We have seen BIOSes with DMI pointers
  *	pointing to completely the wrong place for example
  */
-static int __init dmi_table(u32 base, int len, int num,
-			    void (*decode)(const struct dmi_header *))
+static void dmi_table(u8 *buf, int len, int num,
+		      void (*decode)(const struct dmi_header *))
 {
-	u8 *buf, *data;
+	u8 *data = buf;
 	int i = 0;
 
-	buf = dmi_ioremap(base, len);
-	if (buf == NULL)
-		return -1;
-
-	data = buf;
-
 	/*
 	 *	Stop when we see all the items the table claimed to have
 	 *	OR we run off the end of the table (also happens)
@@ -68,7 +62,23 @@ static int __init dmi_table(u32 base, in
 		data += 2;
 		i++;
 	}
-	dmi_iounmap(buf, len);
+}
+
+static u32 dmi_base;
+static u16 dmi_len;
+static u16 dmi_num;
+
+static int __init dmi_walk_early(void (*decode)(const struct dmi_header *))
+{
+	u8 *buf;
+
+	buf = dmi_ioremap(dmi_base, dmi_len);
+	if (buf == NULL)
+		return -1;
+
+	dmi_table(buf, dmi_len, dmi_num, decode);
+
+	dmi_iounmap(buf, dmi_len);
 	return 0;
 }
 
@@ -273,9 +283,9 @@ static int __init dmi_present(const char
 
 	memcpy_fromio(buf, p, 15);
 	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
-		u16 num = (buf[13] << 8) | buf[12];
-		u16 len = (buf[7] << 8) | buf[6];
-		u32 base = (buf[11] << 24) | (buf[10] << 16) |
+		dmi_num = (buf[13] << 8) | buf[12];
+		dmi_len = (buf[7] << 8) | buf[6];
+		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
 		/*
@@ -287,7 +297,7 @@ static int __init dmi_present(const char
 			       buf[14] >> 4, buf[14] & 0xF);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_table(base,len, num, dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0)
 			return 0;
 	}
 	return 1;
@@ -470,3 +480,26 @@ int dmi_get_year(int field)
 	return year;
 }
 
+/**
+ *	dmi_walk - Walk the DMI table and get called back for every record
+ *	@decode: Callback function
+ *
+ *	Returns -1 when the DMI table can't be reached, 0 on success.
+ */
+int dmi_walk(void (*decode)(const struct dmi_header *))
+{
+	u8 *buf;
+
+	if (!dmi_available)
+		return -1;
+
+	buf = ioremap(dmi_base, dmi_len);
+	if (buf == NULL)
+		return -1;
+
+	dmi_table(buf, dmi_len, dmi_num, decode);
+
+	iounmap(buf);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmi_walk);
--- linux-2.6.24-rc5.orig/include/linux/dmi.h	2007-12-12 12:36:34.000000000 +0100
+++ linux-2.6.24-rc5/include/linux/dmi.h	2007-12-18 14:27:28.000000000 +0100
@@ -78,6 +78,7 @@ extern const struct dmi_device * dmi_fin
 extern void dmi_scan_machine(void);
 extern int dmi_get_year(int field);
 extern int dmi_name_in_vendors(const char *str);
+extern int dmi_walk(void (*decode)(const struct dmi_header *));
 
 #else
 
@@ -87,6 +88,8 @@ static inline const struct dmi_device * 
 	const struct dmi_device *from) { return NULL; }
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
+static inline int dmi_walk(void (*decode)(const struct dmi_header *))
+	{ return -1; }
 
 #endif
 


-- 
Jean Delvare
