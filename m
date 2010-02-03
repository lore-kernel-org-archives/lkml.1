Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0BCTMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:12:47 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50088 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab0BCTMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qGSkR67xsGYZBeUBr9T6YYjRPDlCfJ48ycJ3UnyqnAOVym8MSEDoErLVA1qPo3Xm39
         V9cpB/Fx/Qb3NStKhobHrw30XKzYIj6OdTpFCAehQNEDV7iLqnpoRAvqF6jVJMkwjzBu
         LyIVgCW8xc2TsxNvP6UScuCBIet6AmvIo+bHY=
Message-ID: <4B69CC24.3050503@gmail.com>
Date: Wed, 03 Feb 2010 20:19:00 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MX1/MX2: -EINVAL overwritten in second iteration in mxc_gpio_setup_multiple_pins()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the `ret = gpio_request()' below in the loop, the initial -EINVAL value
of ret is overwritten. 

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Not 100% sure this is needed, please review. One more question: is it ok
to return 0 when count is 0 (and nothing is done)?

diff --git a/arch/arm/plat-mxc/iomux-mx1-mx2.c b/arch/arm/plat-mxc/iomux-mx1-mx2.c
index a37163c..25023ac 100644
--- a/arch/arm/plat-mxc/iomux-mx1-mx2.c
+++ b/arch/arm/plat-mxc/iomux-mx1-mx2.c
@@ -116,14 +116,16 @@ int mxc_gpio_setup_multiple_pins(const int *pin_list, unsigned count,
 	int i;
 	unsigned gpio;
 	unsigned mode;
-	int ret = -EINVAL;
+	int ret;
 
 	for (i = 0; i < count; i++) {
 		gpio = *p & (GPIO_PIN_MASK | GPIO_PORT_MASK);
 		mode = *p & ~(GPIO_PIN_MASK | GPIO_PORT_MASK);
 
-		if (gpio >= (GPIO_PORT_MAX + 1) * 32)
+		if (gpio >= (GPIO_PORT_MAX + 1) * 32) {
+			ret = -EINVAL;
 			goto setup_error;
+		}
 
 		ret = gpio_request(gpio, label);
 		if (ret)
