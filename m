Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0BXHiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:50 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0BXHiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=IUJXTaOP9K6hwebvW6dAvVXDlp+XqeEdBF20tI5XuFTKLPAe4jONXcZt7bfx2VPcJO
         YmW7X2skOIZZjDeRl5cRONYQ7kqs6D5nYkt0uYcOrrEZrxDOgxUugdz9WabkOp5DKyv3
         650XfjiGMH5dcvEP44+KNgQkgM0UkyVtU22DI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 12/14] Regulators: wm8994 - clean up driver data after removal
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:44 -0800
Message-ID: <20100224073844.15964.61692.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a good tone to reset driver data after unbinding the device.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/wm8994-regulator.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index d09e018..95454a4 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -26,7 +26,7 @@
 
 struct wm8994_ldo {
 	int enable;
-	int is_enabled;
+	bool is_enabled;
 	struct regulator_dev *regulator;
 	struct wm8994 *wm8994;
 };
@@ -43,7 +43,7 @@ static int wm8994_ldo_enable(struct regulator_dev *rdev)
 		return 0;
 
 	gpio_set_value(ldo->enable, 1);
-	ldo->is_enabled = 1;
+	ldo->is_enabled = true;
 
 	return 0;
 }
@@ -57,7 +57,7 @@ static int wm8994_ldo_disable(struct regulator_dev *rdev)
 		return -EINVAL;
 
 	gpio_set_value(ldo->enable, 0);
-	ldo->is_enabled = 0;
+	ldo->is_enabled = false;
 
 	return 0;
 }
@@ -218,7 +218,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 
 	ldo->wm8994 = wm8994;
 
-	ldo->is_enabled = 1;
+	ldo->is_enabled = true;
 
 	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
 		ldo->enable = pdata->ldo[id].enable;
@@ -263,6 +263,8 @@ static __devexit int wm8994_ldo_remove(struct platform_device *pdev)
 {
 	struct wm8994_ldo *ldo = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
+
 	regulator_unregister(ldo->regulator);
 	if (gpio_is_valid(ldo->enable))
 		gpio_free(ldo->enable);
@@ -276,6 +278,7 @@ static struct platform_driver wm8994_ldo_driver = {
 	.remove = __devexit_p(wm8994_ldo_remove),
 	.driver		= {
 		.name	= "wm8994-ldo",
+		.owner	= THIS_MODULE,
 	},
 };
 

