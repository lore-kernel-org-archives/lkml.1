Return-Path: <linux-kernel-owner+w=401wt.eu-S1764630AbXILDw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764630AbXILDw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbXILDwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:52:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10955 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbXILDwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:52:16 -0400
X-IronPort-AV: i="4.20,242,1186372800"; 
   d="scan'208"; a="39417951:sNHT28954408"
Subject: [PATCH] bfin_twi: Remove useless twi_lock mutex
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Francis Moreau <francis.moro@gmail.com>,
       Sonic Zhang <sonic.zhang@analog.com>, Jean Delvare <khali@linux-fr.org>,
       i2c@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 12 Sep 2007 11:48:34 +0800
Message-Id: <1189568914.6150.7.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Sep 2007 03:52:15.0254 (UTC) FILETIME=[4EAB8360:01C7F4F0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes this unneeded mutex. Indeed it was used
to serialized access to the hardware, but this is already
done by the i2c-core layer, see 'bus_lock' mutex used by
i2c_transfer().

Signed-off-by: Francis Moreau <francis.moro@gmail.com>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 6311039..67224a4 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -44,7 +44,6 @@
 #define TWI_I2C_MODE_COMBINED		0x04
 
 struct bfin_twi_iface {
-	struct mutex		twi_lock;
 	int			irq;
 	spinlock_t		lock;
 	char			read_write;
@@ -228,12 +227,8 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
-	mutex_lock(&iface->twi_lock);
-
 	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
-		mutex_unlock(&iface->twi_lock);
 		yield();
-		mutex_lock(&iface->twi_lock);
 	}
 
 	ret = 0;
@@ -310,9 +305,6 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 			break;
 	}
 
-	/* Release mutex */
-	mutex_unlock(&iface->twi_lock);
-
 	return ret;
 }
 
@@ -330,12 +322,8 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
-	mutex_lock(&iface->twi_lock);
-
 	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
-		mutex_unlock(&iface->twi_lock);
 		yield();
-		mutex_lock(&iface->twi_lock);
 	}
 
 	iface->writeNum = 0;
@@ -502,9 +490,6 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 
 	rc = (iface->result >= 0) ? 0 : -1;
 
-	/* Release mutex */
-	mutex_unlock(&iface->twi_lock);
-
 	return rc;
 }
 
@@ -555,7 +540,6 @@ static int i2c_bfin_twi_probe(struct platform_device *dev)
 	struct i2c_adapter *p_adap;
 	int rc;
 
-	mutex_init(&(iface->twi_lock));
 	spin_lock_init(&(iface->lock));
 	init_completion(&(iface->complete));
 	iface->irq = IRQ_TWI;
