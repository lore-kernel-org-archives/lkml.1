Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbYD0Ltc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbYD0Ltc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYD0LtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:49:22 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:33287 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755038AbYD0LtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:49:21 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [RFC v2 1/8] modpost: add support for hid
Date: Sun, 27 Apr 2008 13:48:59 +0200
Message-Id: <1209296946-18454-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	
I respun the patches, here comes the turn two.

v1..v2 diff:
- generating hid aliases in uevent, so that we can handle
  MODULE_DEVICE_TABLE(hid) directly. This also solves bluetooth modules
  autoloading. It needed rework of matching and hid_device_id table
  structure. BT and USB designator is needed for each table entry, that
  means three things: 1) bigger tables, 2) mod aliases might be handled
  smoothly, 3) tables might be mixed BT and USB or any other subsystem
  -- no longer table per subsystem is needed (but still possible).
- some bug fixes and cleanups

KNOWN ISSUES
- bus_id is ugly
- IGNORE_MOUSE leaves hid device allocated to wait for incoming driver
  (it's unbounded)
- report parsing is done only once. When a device needs special
  processing and e.g. generic driver grabbed the device before, the device
  is already parsed and unbind followed by bind to another driver won't
  trigger the new driver's report_fixup().
- untested with BT devices
- compat autoload method still missing

--

Generate aliases for hid device modules to support autoloading.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/hid.h             |    1 +
 include/linux/mod_devicetable.h |    9 +++++++++
 scripts/mod/file2alias.c        |   18 ++++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index d951ec4..fe28e44 100644
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
index 139d49d..abb5da3 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -131,6 +131,15 @@ struct usb_device_id {
 #define USB_DEVICE_ID_MATCH_INT_SUBCLASS	0x0100
 #define USB_DEVICE_ID_MATCH_INT_PROTOCOL	0x0200
 
+#define HID_ANY_ID				(~0)
+
+struct hid_device_id {
+	__u16 bus;
+	__u32 vendor;
+	__u32 product;
+	kernel_ulong_t driver_data;
+};
+
 /* s390 CCW devices */
 struct ccw_device_id {
 	__u16	match_flags;	/* which fields to match against */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 769b69d..03d5c8e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -199,6 +199,20 @@ static void do_usb_table(void *symval, unsigned long size,
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
@@ -642,6 +656,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
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

