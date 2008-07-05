Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYGEKcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYGEKcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYGEKb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:31:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:51422 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYGEKb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:31:56 -0400
Subject: [PATCH] dsp56k: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, noring@nocrew.org, lars@nocrew.org,
       tomas@nocrew.org
Content-Type: text/plain
Date: Sat, 05 Jul 2008 15:54:56 +0530
Message-Id: <1215253496.7816.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 drivers/char/dsp56k.c              |   84 ++++++++++++++----------------------
 firmware/Makefile                  |    1 +
 firmware/WHENCE                    |   10 ++++
 firmware/dsp56k/bootstrap.bin.ihex |   26 +++++++++++
 4 files changed, 70 insertions(+), 51 deletions(-)
 create mode 100644 firmware/dsp56k/bootstrap.bin.ihex

diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index a69c652..88f55b5 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -33,6 +33,8 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
 
 #include <asm/atarihw.h>
 #include <asm/traps.h>
@@ -92,49 +94,6 @@
 	} \
 }
 
-/* DSP56001 bootstrap code */
-static char bootstrap[] = {
-	0x0c, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x60, 0xf4, 0x00, 0x00, 0x00, 0x4f, 0x61, 0xf4,
-	0x00, 0x00, 0x7e, 0xa9, 0x06, 0x2e, 0x80, 0x00, 0x00, 0x47,
-	0x07, 0xd8, 0x84, 0x07, 0x59, 0x84, 0x08, 0xf4, 0xa8, 0x00,
-	0x00, 0x04, 0x08, 0xf4, 0xbf, 0x00, 0x0c, 0x00, 0x00, 0xfe,
-	0xb8, 0x0a, 0xf0, 0x80, 0x00, 0x7e, 0xa9, 0x08, 0xf4, 0xa0,
-	0x00, 0x00, 0x01, 0x08, 0xf4, 0xbe, 0x00, 0x00, 0x00, 0x0a,
-	0xa9, 0x80, 0x00, 0x7e, 0xad, 0x08, 0x4e, 0x2b, 0x44, 0xf4,
-	0x00, 0x00, 0x00, 0x03, 0x44, 0xf4, 0x45, 0x00, 0x00, 0x01,
-	0x0e, 0xa0, 0x00, 0x0a, 0xa9, 0x80, 0x00, 0x7e, 0xb5, 0x08,
-	0x50, 0x2b, 0x0a, 0xa9, 0x80, 0x00, 0x7e, 0xb8, 0x08, 0x46,
-	0x2b, 0x44, 0xf4, 0x45, 0x00, 0x00, 0x02, 0x0a, 0xf0, 0xaa,
-	0x00, 0x7e, 0xc9, 0x20, 0x00, 0x45, 0x0a, 0xf0, 0xaa, 0x00,
-	0x7e, 0xd0, 0x06, 0xc6, 0x00, 0x00, 0x7e, 0xc6, 0x0a, 0xa9,
-	0x80, 0x00, 0x7e, 0xc4, 0x08, 0x58, 0x6b, 0x0a, 0xf0, 0x80,
-	0x00, 0x7e, 0xad, 0x06, 0xc6, 0x00, 0x00, 0x7e, 0xcd, 0x0a,
-	0xa9, 0x80, 0x00, 0x7e, 0xcb, 0x08, 0x58, 0xab, 0x0a, 0xf0,
-	0x80, 0x00, 0x7e, 0xad, 0x06, 0xc6, 0x00, 0x00, 0x7e, 0xd4,
-	0x0a, 0xa9, 0x80, 0x00, 0x7e, 0xd2, 0x08, 0x58, 0xeb, 0x0a,
-	0xf0, 0x80, 0x00, 0x7e, 0xad};
-static int sizeof_bootstrap = 375;
-
-
 static struct dsp56k_device {
 	unsigned long in_use;
 	long maxio, timeout;
@@ -164,18 +123,40 @@ static int dsp56k_reset(void)
 
 static int dsp56k_upload(u_char __user *bin, int len)
 {
+	struct platform_device *pdev;
+	const struct firmware *fw;
+	const char fw_name[] = "dsp56k/bootstrap.bin";
+	int err;
 	int i;
-	u_char *p;
-	
+
 	dsp56k_reset();
-  
-	p = bootstrap;
-	for (i = 0; i < sizeof_bootstrap/3; i++) {
+
+	pdev = platform_device_register_simple("dsp56k", 0, NULL, 0);
+	if (IS_ERR(pdev)) {
+		printk(KERN_ERR "Failed to register device for \"%s\"\n",
+		       fw_name);
+		return -EINVAL;
+	}
+	err = request_firmware(&fw, fw_name, &pdev->dev);
+	platform_device_unregister(pdev);
+	if (err) {
+		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
+		       fw_name, err);
+		return err;
+	}
+	if (fw->size % 3) {
+		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		       fw->size, fw_name);
+		release_firmware(fw);
+		return -EINVAL;
+	}
+	for (i = 0; i < fw->size; i + 3) {
 		/* tx_wait(10); */
-		dsp56k_host_interface.data.b[1] = *p++;
-		dsp56k_host_interface.data.b[2] = *p++;
-		dsp56k_host_interface.data.b[3] = *p++;
+		dsp56k_host_interface.data.b[1] = fw->data[i];
+		dsp56k_host_interface.data.b[2] = fw->data[i + 1];
+		dsp56k_host_interface.data.b[3] = fw->data[i + 2];
 	}
+	release_firmware(fw);
 	for (; i < 512; i++) {
 		/* tx_wait(10); */
 		dsp56k_host_interface.data.b[1] = 0;
@@ -534,3 +515,4 @@ static void __exit dsp56k_cleanup_driver(void)
 module_exit(dsp56k_cleanup_driver);
 
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dsp56k/bootstrap.bin");
diff --git a/firmware/Makefile b/firmware/Makefile
index 0f91f3f..58ee6ed 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -13,6 +13,7 @@ ifneq ($(CONFIG_ACENIC_OMIT_TIGON_I),y)
 fw-shipped-$(CONFIG_ACENIC) += acenic/tg1.bin
 endif
 fw-shipped-$(CONFIG_ACENIC) += acenic/tg2.bin
+fw-shipped-$(CONFIG_ATARI_DSP56K) += dsp56k/bootstrap.bin
 fw-shipped-$(CONFIG_ATM_AMBASSADOR) += atmsar11.fw
 fw-shipped-$(CONFIG_COMPUTONE) += intelliport2.bin
 fw-shipped-$(CONFIG_DVB_AV7110) += av7110/bootcode.bin
diff --git a/firmware/WHENCE b/firmware/WHENCE
index 4c120b3..dd4ead5 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -362,3 +362,13 @@ Licence:
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
+
+Driver: ATARI_DSP56K - Atari DSP56k support
+
+File: dsp56k/bootstap.bin
+
+Licence: Unknown
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------
diff --git a/firmware/dsp56k/bootstrap.bin.ihex b/firmware/dsp56k/bootstrap.bin.ihex
new file mode 100644
index 0000000..233f21f
--- /dev/null
+++ b/firmware/dsp56k/bootstrap.bin.ihex
@@ -0,0 +1,26 @@
+:100000000C004000000000000000000000000000A4
+:1000100000000000000000000000000000000000E0
+:1000200000000000000000000000000000000000D0
+:1000300000000000000000000000000000000000C0
+:1000400000000000000000000000000000000000B0
+:1000500000000000000000000000000000000000A0
+:100060000000000000000000000000000000000090
+:100070000000000000000000000000000000000080
+:100080000000000000000000000000000000000070
+:100090000000000000000000000000000000000060
+:1000A0000000000000000000000000000000000050
+:1000B0000000000000000000000000000000000040
+:1000C00060F40000004F61F400007EA9062E80005D
+:1000D000004707D88407598408F4A800000408F4EE
+:1000E000BF000C0000FEB80AF080007EA908F4A052
+:1000F00000000108F4BE0000000AA980007EAD08DF
+:100100004E2B44F40000000344F4450000010EA00F
+:10011000000AA980007EB508502B0AA980007EB88D
+:1001200008462B44F4450000020AF0AA007EC920CC
+:1001300000450AF0AA007ED006C600007EC60AA9C5
+:1001400080007EC408586B0AF080007EAD06C600B1
+:10015000007ECD0AA980007ECB0858AB0AF0800053
+:100160007EAD06C600007ED40AA980007ED2085863
+:07017000EB0AF080007EADF8
+:00000001FF
+/* DSP56001 bootstrap code */
-- 
1.5.5.1



