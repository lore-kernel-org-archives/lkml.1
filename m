Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZLDNiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZLDNiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbZLDNiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:38:07 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59472 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZLDNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uFZ8kfyFD7QiZix/GF6joKSdjGTw3CU23ulOo+rMrIH2Donl5tTzVu4ItVklvdf+ZP
         KRbLFPItUk/XaUs2SH9krX7MlDIV9rMZSZ2Tc9psTRH9FAWli8LAcwdBZK+b99lTg/3w
         WOT7yLagz9ud8BmGIt+u8alzLWkNAYQyd7EBs=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH v7 7/8] Loongson: YeeLoong: add suspend support
Date: Fri,  4 Dec 2009 21:37:41 +0800
Message-Id: <1811181c553c2c8e7e841540e57444e54c33d65f.1259932036.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1259932036.git.wuzhangjin@gmail.com>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch add support to suspend the yeeloong platform specific
devices(LCD, CRT, USB...).

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/yeeloong_laptop.c |   41 +++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index 8378926..d31824b 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -536,6 +536,45 @@ static void yeeloong_vo_exit(void)
 	}
 }
 
+#ifdef CONFIG_LOONGSON_SUSPEND
+static void usb_ports_set(int status)
+{
+	status = !!status;
+
+	ec_write(REG_USB0_FLAG, status);
+	ec_write(REG_USB1_FLAG, status);
+	ec_write(REG_USB2_FLAG, status);
+}
+
+static int yeeloong_suspend(struct platform_device *dev, pm_message_t state)
+
+{
+	/* Turn off LCD */
+	yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_OFF);
+	/* Turn off CRT */
+	yeeloong_crt_vo_set(BIT_CRT_DETECT_UNPLUG);
+	/* Poweroff three usb ports */
+	usb_ports_set(BIT_USB_FLAG_OFF);
+
+	return 0;
+}
+
+static int yeeloong_resume(struct platform_device *pdev)
+{
+	/* Resume the status of lcd & crt */
+	yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+	yeeloong_crt_vo_set(BIT_CRT_DETECT_PLUG);
+
+	/* Poweron three usb ports */
+	usb_ports_set(BIT_USB_FLAG_ON);
+
+	return 0;
+}
+#else	/* !CONFIG_LOONGSON_SUSPEND */
+#define yeeloong_suspend NULL
+#define yeeloong_resume NULL
+#endif
+
 static struct platform_device_id platform_device_ids[] = {
 	{
 		.name = "yeeloong_laptop",
@@ -551,6 +590,8 @@ static struct platform_driver platform_driver = {
 		   .owner = THIS_MODULE,
 		   },
 	.id_table = platform_device_ids,
+	.suspend = yeeloong_suspend,
+	.resume = yeeloong_resume,
 };
 
 static int __init yeeloong_init(void)
-- 
1.6.2.1

