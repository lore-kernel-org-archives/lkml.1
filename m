Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXJ3Jd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXJ3Jd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXJ3Jd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:33:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:2167 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbXJ3JdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:33:24 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55176148:sNHT35581427"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/2] Blackfin I2C/TWI driver: add missing pin mux operation
Date: Tue, 30 Oct 2007 17:33:17 +0800
Message-Id: <1193736797-9005-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193736797-9005-1-git-send-email-bryan.wu@analog.com>
References: <1193736797-9005-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   49 ++++++++++++++++++++++++++++--------
 1 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index acae7ef..832ba66 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -38,8 +38,18 @@
 #include <linux/platform_device.h>
 
 #include <asm/blackfin.h>
+#include <asm/portmux.h>
 #include <asm/irq.h>
 
+#define DRV_NAME	"i2c-bfin-twi"
+#define DRV_AUTHOR	"Sonic Zhang, Bryan Wu"
+#define DRV_DESC	"Blackfin BF5xx on-chip I2C TWI Contoller Driver"
+#define DRV_VERSION	"1.8"
+
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
+MODULE_LICENSE("GPL");
+
 #define POLL_TIMEOUT       (2 * HZ)
 
 /* SMBus mode*/
@@ -67,6 +77,7 @@ struct bfin_twi_iface {
 	int			msg_num;
 	int			cur_msg;
 	u32			regs_base;
+	int			bus_num;
 };
 
 
@@ -93,6 +104,24 @@ DEFINE_TWI_REG(XMT_DATA16, 0x84)
 DEFINE_TWI_REG(RCV_DATA8, 0x88)
 DEFINE_TWI_REG(RCV_DATA16, 0x8C)
 
+static int setup_pin_mux(int action, struct bfin_twi_iface *iface)
+{
+
+	u16 pin_req[2][3] = {
+		{P_TWI0_SCL, P_TWI0_SDA, 0},
+		{P_TWI1_SCL, P_TWI1_SDA, 0},
+	};
+
+	if (action) {
+		if (peripheral_request_list(pin_req[iface->bus_num], DRV_NAME))
+			return -EFAULT;
+	} else {
+		peripheral_free_list(pin_req[iface->bus_num]);
+	}
+
+	return 0;
+}
+
 static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 {
 	unsigned short twi_int_status = read_INT_STAT(iface);
@@ -310,8 +339,7 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 
 	pmsg = &msgs[0];
 	if (pmsg->flags & I2C_M_TEN) {
-		dev_err(&(adap->dev), "i2c-bfin-twi: 10 bits addr "
-			"not supported !\n");
+		dev_err(&(adap->dev), "10 bits addr not supported !\n");
 		return -EINVAL;
 	}
 
@@ -645,6 +673,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 		goto out_error_no_irq;
 	}
 
+	iface->bus_num = pdev->id;
 	init_timer(&(iface->timeout_timer));
 	iface->timeout_timer.function = bfin_twi_timeout;
 	iface->timeout_timer.data = (unsigned long)iface;
@@ -657,11 +686,12 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	p_adap->class = I2C_CLASS_ALL;
 	p_adap->dev.parent = &pdev->dev;
 
+	setup_pin_mux(1, iface);
+
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
 		IRQF_DISABLED, pdev->name, iface);
 	if (rc) {
-		dev_err(&(pdev->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
-			iface->irq);
+		dev_err(&(pdev->dev), "can't get IRQ %d !\n", iface->irq);
 		rc = -ENODEV;
 		goto out_error_req_irq;
 	}
@@ -684,8 +714,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	else
 		platform_set_drvdata(pdev, iface);
 
-	dev_info(&(pdev->dev), "Blackfin I2C TWI driver, regs_base @ 0x%08x\n",
-		iface->regs_base);
+	dev_info(&(pdev->dev), "%s, Version %s, regs_base@0x%08x\n",
+		DRV_DESC, DRV_VERSION, iface->regs_base);
 
 	return rc;
 
@@ -707,6 +737,7 @@ static int i2c_bfin_twi_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&(iface->adap));
 	free_irq(iface->irq, iface);
+	setup_pin_mux(0, iface);
 
 	return 0;
 }
@@ -717,7 +748,7 @@ static struct platform_driver i2c_bfin_twi_driver = {
 	.suspend	= i2c_bfin_twi_suspend,
 	.resume		= i2c_bfin_twi_resume,
 	.driver		= {
-		.name	= "i2c-bfin-twi",
+		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
 };
@@ -732,9 +763,5 @@ static void __exit i2c_bfin_twi_exit(void)
 	platform_driver_unregister(&i2c_bfin_twi_driver);
 }
 
-MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
-MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin TWI");
-MODULE_LICENSE("GPL");
-
 module_init(i2c_bfin_twi_init);
 module_exit(i2c_bfin_twi_exit);
-- 
1.5.3.4
