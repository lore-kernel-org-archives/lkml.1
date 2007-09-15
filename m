Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbXIOTob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbXIOTob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXIOToY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:44:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:16470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbXIOToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KCCjEmszkn+mpL9DLd9isR0ts/Y870+4qICY3pSRAGEEMAC9sXznIquWWuNZBol3Rd/kiLyzT2F9kNpXRGSmV7jCutgGaqkF7sE+YE2LENnm8E3ICkQwpcjwu+7lkRIWC6agFB6OBbPVQa6ldEffa8RKOEVAUP/Tg0ETHmNDGaU=
Message-ID: <8b67d60709151244o7aadf3efi592eb9d56559bc7@mail.gmail.com>
Date: Sat, 15 Sep 2007 20:44:22 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 3/2] Add Maple bus support for the SEGA Dreamcast - the missing header files
Cc: "Greg KH" <greg@kroah.com>, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies - these are the patches to add header files to the series
beginning here: http://lkml.org/lkml/2007/9/15/181

Add maplebus headers

Signed off by Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/include/linux/input.h b/include/linux/input.h
diff --git a/include/linux/maple.h b/include/linux/maple.h
new file mode 100644
index 0000000..e297cce
--- /dev/null
+++ b/include/linux/maple.h
@@ -0,0 +1,87 @@
+/**
+ * maple.h
+ *
+ * porting to 2.6 driver model
+ * copyright Adrian McMenamin, 2007
+ *
+ */
+#ifndef __LINUX_MAPLE_H
+#define __LINUX_MAPLE_H
+
+extern struct bus_type maple_bus_type;
+
+/* Maple Bus command and response codes */
+enum maple_code {
+	MAPLE_RESPONSE_FILEERR = -5,
+	MAPLE_RESPONSE_AGAIN = -4,	/* request should be retransmitted */
+	MAPLE_RESPONSE_BADCMD = -3,
+	MAPLE_RESPONSE_BADFUNC = -2,
+	MAPLE_RESPONSE_NONE = -1,	/* unit didn't respond at all */
+	MAPLE_COMMAND_DEVINFO = 1,
+	MAPLE_COMMAND_ALLINFO = 2,
+	MAPLE_COMMAND_RESET = 3,
+	MAPLE_COMMAND_KILL = 4,
+	MAPLE_RESPONSE_DEVINFO = 5,
+	MAPLE_RESPONSE_ALLINFO = 6,
+	MAPLE_RESPONSE_OK = 7,
+	MAPLE_RESPONSE_DATATRF = 8,
+	MAPLE_COMMAND_GETCOND = 9,
+	MAPLE_COMMAND_GETMINFO = 10,
+	MAPLE_COMMAND_BREAD = 11,
+	MAPLE_COMMAND_BWRITE = 12,
+	MAPLE_COMMAND_SETCOND = 14
+};
+
+struct mapleq {
+	struct list_head list;
+	struct maple_device *dev;
+	void *sendbuf, *recvbuf, *recvbufdcsp;
+	unsigned char length;
+	enum maple_code command;
+};
+
+struct maple_devinfo {
+	unsigned long function;
+	unsigned long function_data[3];
+	unsigned char area_code;
+	unsigned char connector_directon;
+	char product_name[31];
+	char product_licence[61];
+	unsigned short standby_power;
+	unsigned short max_power;
+};
+
+struct maple_device {
+	struct maple_driver *driver;
+	struct mapleq *mq;
+	void *private_data;
+	void (*callback) (struct mapleq * mq);
+	unsigned long when, interval, function;
+	struct maple_devinfo devinfo;
+	unsigned char port, unit;
+	char product_name[32];
+	char product_licence[64];
+	int registered;
+	struct device dev;
+};
+
+struct maple_driver {
+	unsigned long function;
+	int (*connect) (struct maple_device * dev);
+	void (*disconnect) (struct maple_device * dev);
+	struct device_driver drv;
+};
+
+void maple_getcond_callback(struct maple_device *dev,
+			    void (*callback) (struct mapleq * mq),
+			    unsigned long interval,
+			    unsigned long function);
+
+int maple_driver_register(struct device_driver *drv);
+
+void maple_add_packet(struct mapleq *mq);
+
+#define to_maple_dev(n) container_of(n, struct maple_device, dev)
+#define to_maple_driver(n) container_of(n, struct maple_driver, drv)
+
+#endif /* __LINUX_MAPLE_H */
diff --git a/include/asm-sh/dreamcast/maple.h b/include/asm-sh/dreamcast/maple.h
new file mode 100644
index 0000000..4836d24
--- /dev/null
+++ b/include/asm-sh/dreamcast/maple.h
@@ -0,0 +1,36 @@
+#ifndef __ASM_MAPLE_H
+#define __ASM_MAPLE_H
+
+#define MAPLE_PORTS 4
+#define MAPLE_PNP_INTERVAL HZ
+#define MAPLE_MAXPACKETS 8
+#define MAPLE_DMA_ORDER 14
+#define MAPLE_DMA_SIZE (1 << MAPLE_DMA_ORDER)
+#define MAPLE_DMA_PAGES ((MAPLE_DMA_ORDER > PAGE_SHIFT) ?
MAPLE_DMA_ORDER - PAGE_SHIFT : 0)
+
+/* Maple Bus registers */
+#define MAPLE_BASE	0xa05f6c00
+#define MAPLE_DMAADDR	(MAPLE_BASE+0x04)
+#define MAPLE_TRIGTYPE	(MAPLE_BASE+0x10)
+#define MAPLE_ENABLE	(MAPLE_BASE+0x14)
+#define MAPLE_STATE	(MAPLE_BASE+0x18)
+#define MAPLE_SPEED	(MAPLE_BASE+0x80)
+#define MAPLE_RESET	(MAPLE_BASE+0x8c)
+
+#define MAPLE_MAGIC	0x6155404f
+#define MAPLE_2MBPS	0
+#define	MAPLE_TIMEOUT(n) ((n)<<15)
+
+/* Function codes */
+#define MAPLE_FUNC_CONTROLLER 0x001
+#define MAPLE_FUNC_MEMCARD    0x002
+#define MAPLE_FUNC_LCD        0x004
+#define MAPLE_FUNC_CLOCK      0x008
+#define MAPLE_FUNC_MICROPHONE 0x010
+#define MAPLE_FUNC_ARGUN      0x020
+#define MAPLE_FUNC_KEYBOARD   0x040
+#define MAPLE_FUNC_LIGHTGUN   0x080
+#define MAPLE_FUNC_PURUPURU   0x100
+#define MAPLE_FUNC_MOUSE      0x200
+
+#endif /* __ASM_MAPLE_H */
