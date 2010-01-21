Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509Ab0AUE0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0AUE0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396Ab0AUE0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:26:13 -0500
Received: from kroah.org ([198.145.64.141]:60192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0AUEXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.874098077@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [26/30] i2c: Do not use device name after device_unregister
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit c556752109794a5ff199b80a1673336b4df8433a upstream.

dev_dbg outputs dev_name, which is released with device_unregister. This bug
resulted in output like this:

i2c Xy2�0: adapter [SMBus I801 adapter at 1880] unregistered

The right output would be:
i2c i2c-0: adapter [SMBus I801 adapter at 1880] unregistered

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -801,6 +801,9 @@ int i2c_del_adapter(struct i2c_adapter *
 				 adap->dev.parent);
 #endif
 
+	/* device name is gone after device_unregister */
+	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
+
 	/* clean up the sysfs representation */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -813,8 +816,6 @@ int i2c_del_adapter(struct i2c_adapter *
 	idr_remove(&i2c_adapter_idr, adap->nr);
 	mutex_unlock(&core_lock);
 
-	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));


