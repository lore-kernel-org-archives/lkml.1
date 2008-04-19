Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYDSWir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYDSWir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYDSWii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:38:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48506 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751816AbYDSWih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:38:37 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: HID bus
Date: Sun, 20 Apr 2008 00:38:15 +0200
Message-Id: <1208644696-29129-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz>
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I must admit, I didn't know how exactly autoloading works. On suse,
at least, module aliases are used. So autoloading works for me after this
patch and slight modifications of the previous patches. The pro of this
is that it's in-kernel modification of modpost phase.

Now, I wonder for exactly what purpose are module.*map files in
/lib/modules/`uname -r`/ dir, i.e. what would break, if the devices won't
be listed there on systems with unpatched module-init-tools.

--

Generate aliases for usb hid device modules to support autoloading.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/hid.h             |    7 +++++++
 include/linux/mod_devicetable.h |    8 ++++++++
 scripts/mod/file2alias.c        |   21 +++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index d951ec4..44c1b8b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -29,11 +29,18 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#ifdef __KERNEL__
+#include <linux/mod_devicetable.h>
+#endif
+
 /*
  * USB HID (Human Interface Device) interface class code
  */
 
+/* this one is for userspace, we define this in linux/mod_devicetable.h */
+#ifndef USB_INTERFACE_CLASS_HID
 #define USB_INTERFACE_CLASS_HID		3
+#endif
 
 /*
  * USB HID interface subclass and protocol codes
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 139d49d..2227c43 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -131,6 +131,14 @@ struct usb_device_id {
 #define USB_DEVICE_ID_MATCH_INT_SUBCLASS	0x0100
 #define USB_DEVICE_ID_MATCH_INT_PROTOCOL	0x0200
 
+#define USB_INTERFACE_CLASS_HID			3
+#define HID_ANY_ID				(~0)
+
+struct hid_device_id {
+	__u32 vendor, product;
+	kernel_ulong_t driver_data;
+};
+
 /* s390 CCW devices */
 struct ccw_device_id {
 	__u16	match_flags;	/* which fields to match against */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 769b69d..d92445e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -199,6 +199,23 @@ static void do_usb_table(void *symval, unsigned long size,
 		do_usb_entry_multi(symval + i, mod);
 }
 
+/* Looks like: usb */
+static int do_hid_usb_entry(const char *filename,
+			     struct hid_device_id *id, char *alias)
+{
+	__u16 v = TO_NATIVE((__u16)id->vendor);
+	__u16 p = TO_NATIVE((__u16)id->product);
+
+	strcpy(alias, "usb:");
+	ADD(alias, "v", id->vendor != HID_ANY_ID, v);
+	ADD(alias, "p", id->product != HID_ANY_ID, p);
+
+	sprintf(alias + strlen(alias), "d*dc*dsc*dp*ic%02Xisc*ip*",
+			USB_INTERFACE_CLASS_HID);
+
+	return 1;
+}
+
 /* Looks like: ieee1394:venNmoNspNverN */
 static int do_ieee1394_entry(const char *filename,
 			     struct ieee1394_device_id *id, char *alias)
@@ -642,6 +659,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	else if (sym_is(symname, "__mod_usb_device_table"))
 		/* special case to handle bcdDevice ranges */
 		do_usb_table(symval, sym->st_size, mod);
+	else if (sym_is(symname, "__mod_hid_usb_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct hid_device_id), "hid_usb",
+			 do_hid_usb_entry, mod);
 	else if (sym_is(symname, "__mod_ieee1394_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct ieee1394_device_id), "ieee1394",
-- 
1.5.4.5

