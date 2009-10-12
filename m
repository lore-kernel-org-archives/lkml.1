Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZJLOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZJLOEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZJLOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:04:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:10641 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbZJLOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MWAKBV59uKGR0wFEZB8ueV3VfUehxo1Qh355xSN+aDzopcZGd4PkOXPIN0R+QfKyH0
         cVn8ew7yChzKsR0JsffVbzBXeuc+GRy5+l4A+m1T0KT0OBQ7Un6+VJFEHPwcgfcTDthi
         P+dDUo8ErOJruZKKt0W3V4G/rGtR4oa0p7SMU=
Message-ID: <4AD33958.7020900@gmail.com>
Date: Mon, 12 Oct 2009 16:12:40 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: alek.du@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong test was used, gpio is unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 5711ce5..0d0cbc0 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -123,8 +123,11 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
 
-	if (gpio < 0 || gpio > lnw->chip.ngpio)
+	if (irq < lnw->irq_base || gpio > lnw->chip.ngpio ||
+			reg >= ARRAY_SIZE(lnw->reg_base->GRER)
+			reg >= ARRAY_SIZE(lnw->reg_base->GFER))
 		return -EINVAL;
+
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
 		value = readl(grer) | BIT(gpio % 32);
