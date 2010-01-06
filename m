Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790Ab0AFNeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0AFNeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 08:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637Ab0AFNeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 08:34:21 -0500
Received: from mail.atheros.com ([12.36.123.2]:64538 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab0AFNeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 08:34:20 -0500
Date: Wed, 6 Jan 2010 19:04:15 +0530
From: Kandukuri Vikram <vkandukuri@atheros.com>
To: <marcel@holtmann.org>, <linux-bluetooth@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
CC: <lrodriguez@atheros.com>
Subject: [PATCH] DFU Driver for Atheros bluetooth chipset AR3011
Message-ID: <20100106133415.GC13153@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Vikram Kandukuri <vikram.kandukuri@atheros.com>
Signed-off-by: Alicke Xu <sxu@atheros.com>
Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/bluetooth/Kconfig  |   13 +++-
 drivers/bluetooth/Makefile |    1 +
 drivers/bluetooth/ath3k.c  |  187 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+), 1 deletions(-)
 create mode 100644 drivers/bluetooth/ath3k.c

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 652367a..c8a7cdf 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -195,5 +195,16 @@ config BT_MRVL_SDIO
 	  Say Y here to compile support for Marvell BT-over-SDIO driver
 	  into the kernel or say M to compile it as module.
 
-endmenu
+config BT_ATH3K
+	tristate "Atheros firmware download driver"
+	depends on BT_HCIBTUSB
+	select FW_LOADER
+	help
+	  Bluetooth firmware download driver.
+	  This driver loads the firmware into the Atheros bluetooth
+          chipset.
 
+	  Say Y here to compile support for "Atheros AR30XX firmware download driver"
+          into the  kernel or say M to compile it as module (ath3k).
+
+endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index b3f57d2..6fcdeb7 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_BT_HCIBTUART)	+= btuart_cs.o
 obj-$(CONFIG_BT_HCIBTUSB)	+= btusb.o
 obj-$(CONFIG_BT_HCIBTSDIO)	+= btsdio.o
 
+obj-$(CONFIG_BT_ATH3K)	        += ath3k.o
 obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
 obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
 
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
new file mode 100644
index 0000000..2206e16
--- /dev/null
+++ b/drivers/bluetooth/ath3k.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/usb.h>
+#include <net/bluetooth/bluetooth.h>
+
+#define VERSION "1.0"
+
+
+static struct usb_device_id ath3k_table[] = {
+	/* Atheros AR3011 */
+	{ USB_DEVICE(0x0CF3, 0x3000) },
+	{ }	/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, ath3k_table);
+
+#define USB_REQ_DFU_DNLOAD	1
+#define BULK_SIZE               4096
+
+struct ath3k_data {
+	struct usb_device *udev;
+	u8 *fw_data;
+	u32 fw_size;
+	u32 fw_sent;
+};
+
+static int ath3k_load_firmware(struct ath3k_data *data,
+				unsigned char *firmware,
+				int count)
+{
+	u8 *send_buf;
+	int err, pipe, len, size, sent = 0;
+
+	BT_DBG("ath3k %p udev %p\n", data, data->udev);
+
+	pipe = usb_sndctrlpipe(data->udev, 0);
+
+	if ((usb_control_msg(data->udev, pipe,
+				USB_REQ_DFU_DNLOAD,
+				USB_TYPE_VENDOR, 0, 0,
+				firmware, 20, USB_CTRL_SET_TIMEOUT)) < 0) {
+		BT_ERR("Can't change to loading configuration err\n");
+		return -EBUSY;
+	}
+	sent += 20;
+	count -= 20;
+
+	send_buf = kmalloc(BULK_SIZE, GFP_ATOMIC);
+	if (!send_buf) {
+		BT_ERR("Can't allocate memory chunk for firmware\n");
+		return -ENOMEM;
+	}
+
+	while (count) {
+		size = min_t(uint, count, BULK_SIZE);
+		pipe = usb_sndbulkpipe(data->udev, 0x02);
+		memcpy(send_buf, firmware + sent, size);
+
+		err = usb_bulk_msg(data->udev, pipe, send_buf, size,
+					&len, 3000);
+
+		if (err || (len != size)) {
+			BT_ERR("Error in firmware loading err = %d,"
+				"len = %d, size = %d\n", err, len, size);
+			goto error;
+		}
+
+		sent  += size;
+		count -= size;
+	}
+
+	kfree(send_buf);
+	return 0;
+
+error:
+	kfree(send_buf);
+	return err;
+}
+
+static int ath3k_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	const struct firmware *firmware;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct ath3k_data *data;
+	int size;
+
+	BT_DBG("ath3k_probe intf %p id %p\n", intf, id);
+
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->udev  = udev;
+
+	if (request_firmware(&firmware, "ath3k-1.fw", &udev->dev) < 0) {
+		kfree(data);
+		return -EIO;
+	}
+
+	size = max_t(uint, firmware->size, 4096);
+	data->fw_data = kmalloc(size, GFP_KERNEL);
+	if (!data->fw_data) {
+		release_firmware(firmware);
+		kfree(data);
+		return -ENOMEM;
+	}
+
+	memcpy(data->fw_data, firmware->data, firmware->size);
+	data->fw_size = firmware->size;
+	data->fw_sent = 0;
+	release_firmware(firmware);
+
+	usb_set_intfdata(intf, data);
+	if (ath3k_load_firmware(data, data->fw_data, data->fw_size)) {
+		usb_set_intfdata(intf, NULL);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void ath3k_disconnect(struct usb_interface *intf)
+{
+	struct ath3k_data *data = usb_get_intfdata(intf);
+
+	BT_DBG("ath3k_disconnect intf %p\n", intf);
+
+	kfree(data->fw_data);
+	kfree(data);
+}
+
+static struct usb_driver ath3k_driver = {
+	.name		= "ath3k",
+	.probe		= ath3k_probe,
+	.disconnect	= ath3k_disconnect,
+	.id_table	= ath3k_table,
+};
+
+static int __init ath3k_init(void)
+{
+	BT_INFO("Atheros AR30XX firmware driver ver %s", VERSION);
+	return usb_register(&ath3k_driver);
+}
+
+static void __exit ath3k_exit(void)
+{
+	usb_deregister(&ath3k_driver);
+}
+
+module_init(ath3k_init);
+module_exit(ath3k_exit);
+
+MODULE_AUTHOR("Atheros Communications");
+MODULE_DESCRIPTION("Atheros AR30XX firmware driver");
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("ath3k-1.fw");
-- 
1.6.0.4

