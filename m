Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXKBGYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXKBGYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXKBGYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:24:31 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:37232 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXKBGY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:24:29 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="42907912:sNHT26239864"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/4] Blackfin I2C/TWI driver: add missing pin mux operation
Date: Fri,  2 Nov 2007 14:24:23 +0800
Message-Id: <1193984664-10609-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Blackfin TWI controller hardware pin should be requested from GPIO port controller
Before BF54x, there is no need to do this. But as long as BF54x and BF52x
are supported by this generic driver, the missing pin mux operation should be
added.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index e495454..727625b 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -34,6 +34,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/blackfin.h>
+#include <asm/portmux.h>
 #include <asm/irq.h>
 
 #define POLL_TIMEOUT       (2 * HZ)
@@ -63,6 +64,7 @@ struct bfin_twi_iface {
 	int			msg_num;
 	int			cur_msg;
 	void __iomem		*regs_base;
+	int			bus_num;
 };
 
 
@@ -89,6 +91,24 @@ DEFINE_TWI_REG(XMT_DATA16, 0x84)
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
@@ -640,6 +660,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 		goto out_error_no_irq;
 	}
 
+	iface->bus_num = pdev->id;
 	init_timer(&(iface->timeout_timer));
 	iface->timeout_timer.function = bfin_twi_timeout;
 	iface->timeout_timer.data = (unsigned long)iface;
@@ -652,6 +673,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	p_adap->class = I2C_CLASS_ALL;
 	p_adap->dev.parent = &pdev->dev;
 
+	setup_pin_mux(1, iface);
+
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
 		IRQF_DISABLED, pdev->name, iface);
 	if (rc) {
@@ -701,6 +724,7 @@ static int i2c_bfin_twi_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&(iface->adap));
 	free_irq(iface->irq, iface);
+	setup_pin_mux(0, iface);
 
 	return 0;
 }
-- 
1.5.3.4
