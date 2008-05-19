Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbYESNuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbYESNuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYESNun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:50:43 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:46614 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751991AbYESNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:50:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2] modpost: add support for hid
Date: Mon, 19 May 2008 15:50:01 +0200
Message-Id: <1211205001-11888-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate aliases for hid device modules to support autoloading.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/hid.h             |    1 +
 include/linux/mod_devicetable.h |   10 ++++++++++
 scripts/mod/file2alias.c        |   18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 6fc10d1..8466292 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -69,6 +69,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h> /* hid_device_id */
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index d73ecea..3511694 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -131,6 +131,16 @@ struct usb_device_id {
 #define USB_DEVICE_ID_MATCH_INT_SUBCLASS	0x0100
 #define USB_DEVICE_ID_MATCH_INT_PROTOCOL	0x0200
 
+#define HID_ANY_ID				(~0)
+
+struct hid_device_id {
+	__u16 bus;
+	__u32 vendor;
+	__u32 product;
+	kernel_ulong_t driver_data
+		__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 /* s390 CCW devices */
 struct ccw_device_id {
 	__u16	match_flags;	/* which fields to match against */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index cea4a79..383af1b 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -206,6 +206,20 @@ static void do_usb_table(void *symval, unsigned long size,
 		do_usb_entry_multi(symval + i, mod);
 }
 
+/* Looks like: hid:bNvNpN */
+static int do_hid_entry(const char *filename,
+			     struct hid_device_id *id, char *alias)
+{
+	id->vendor = TO_NATIVE(id->vendor);
+	id->product = TO_NATIVE(id->product);
+
+	sprintf(alias, "hid:b%04X", id->bus);
+	ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
+	ADD(alias, "p", id->product != HID_ANY_ID, id->product);
+
+	return 1;
+}
+
 /* Looks like: ieee1394:venNmoNspNverN */
 static int do_ieee1394_entry(const char *filename,
 			     struct ieee1394_device_id *id, char *alias)
@@ -668,6 +682,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	else if (sym_is(symname, "__mod_usb_device_table"))
 		/* special case to handle bcdDevice ranges */
 		do_usb_table(symval, sym->st_size, mod);
+	else if (sym_is(symname, "__mod_hid_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct hid_device_id), "hid",
+			 do_hid_entry, mod);
 	else if (sym_is(symname, "__mod_ieee1394_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct ieee1394_device_id), "ieee1394",
-- 
1.5.4.5

