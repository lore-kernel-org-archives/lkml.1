Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZFVPWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZFVPWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFVPWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:22:23 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:49155 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVPWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:22:23 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/2] gpio: pl061: fix probe error handling code
Date: Mon, 22 Jun 2009 18:20:54 +0300
Message-Id: <1245684055-9185-1-git-send-email-baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that IRQ has not been initialized when kmalloc() fails.

Also, use DECLARE_BITMAP() to make the code clearer.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/gpio/pl061.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index aa8e7cb..80e4839 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -221,7 +221,7 @@ static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
 	struct pl061_gpio *chip;
 	struct list_head *chip_list;
 	int ret, irq, i;
-	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
+	static DECLARE_BITMAP(init_irq, NR_IRQS);
 
 	pdata = dev->dev.platform_data;
 	if (pdata == NULL)
@@ -280,6 +280,7 @@ static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
 	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
+			clear_bit(irq, init_irq);
 			ret = -ENOMEM;
 			goto iounmap;
 		}
-- 
1.6.3.1

