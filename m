Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYG2NgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYG2NgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYG2Nfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:35:54 -0400
Received: from mail.hevs.ch ([153.109.23.10]:51851 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYG2Nfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:35:53 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: khali@linux-fr.org
Subject: [RFC,PATCH] i2c: fix device_init_wakeup place
Date: Tue, 29 Jul 2008 15:35:44 +0200
User-Agent: KMail/1.9.9
Cc: dbrownell@users.sourceforge.net, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291535.45689.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move device_init_wakeup. At it's current place this is a noop (will be reset in
device_initialize).

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi all!

The current code calls device_init_wakeup() before device_register, but
device_register will disable device wakeup.

This patch (against 2.6.27-rc1) move the device_init_wakeup() call in the bus
probe function,just before the probe call.

This will fix 3bbb835d4c53faf0bca62f0e39835926bef40b1f ('New style devices can
support driver modle wakeup flags')which in fact has no effect. I think there
is no need to fix -stable, because there is no in-tree users of the
I2C_CLIENT_WAKE flag.

This patch also include a small functionnal change: the I2C_CLIENT_WAKE is no
more removed from the client flags, but this should't hurt.


Best regards

Marc



diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7bf38c4..99c6a13 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -108,6 +108,7 @@ static int i2c_device_probe(struct device *dev)
 	if (!driver->probe || !driver->id_table)
 		return -ENODEV;
 	client->driver = driver;
+	device_init_wakeup(&client->dev, client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
@@ -262,9 +263,8 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	client->adapter = adap;
 
 	client->dev.platform_data = info->platform_data;
-	device_init_wakeup(&client->dev, info->flags & I2C_CLIENT_WAKE);
 
-	client->flags = info->flags & ~I2C_CLIENT_WAKE;
+	client->flags = info->flags;
 	client->addr = info->addr;
 	client->irq = info->irq;
 
