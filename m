Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYJ2Scf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYJ2Scf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJ2Sc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:32:26 -0400
Received: from xes-mad.com ([216.165.139.214]:38167 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYJ2ScZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:32:25 -0400
X-Greylist: delayed 3762 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 14:32:25 EDT
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Nate Case <ncase@xes-inc.com>
Subject: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
Date: Wed, 29 Oct 2008 12:29:37 -0500
Message-Id: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the M41T00, registers are in a random state if the Vbat power
was lost before the driver probes it (regardless of whether or
not the oscillator is still running).  In this case, give all
registers valid values so that the bogus values don't cause it to
error out and skip the device.

Signed-off-by: Nate Case <ncase@xes-inc.com>
---
 drivers/rtc/rtc-ds1307.c |   61 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 162330b..aec17bb 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -198,6 +198,29 @@ static irqreturn_t ds1307_irq(int irq, void *dev_id)
 
 /*----------------------------------------------------------------------*/
 
+static int ds1307_regs_valid(struct ds1307 *ds1307)
+{
+	int tmp, valid = 1;
+
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_SECS] & 0x7f);
+	if (tmp > 60)
+		valid = 0;
+
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
+	if (tmp > 60)
+		valid = 0;
+
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
+	if (tmp == 0 || tmp > 31)
+		valid = 0;
+
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
+	if (tmp == 0 || tmp > 12)
+		valid = 0;
+
+	return valid;
+}
+
 static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 {
 	struct ds1307	*ds1307 = dev_get_drvdata(dev);
@@ -571,6 +594,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
+	int			already_reset = false;
 
 	if (!i2c_check_functionality(adapter,
 			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
@@ -663,6 +687,28 @@ read_rtc:
 	switch (ds1307->type) {
 	case ds_1307:
 	case m41t00:
+		/*
+		 * Registers can be in random state if the Vbat power
+		 * was lost, and sometimes this will happen even with
+		 * the oscillator running.  Give all registers valid
+		 * values so that the bogus values don't cause it to
+		 * error out later on.
+		 */
+		if (!ds1307_regs_valid(ds1307)) {
+			if (already_reset)
+				goto exit_bad;
+			i2c_smbus_write_byte_data(client, DS1307_REG_YEAR, 1);
+			i2c_smbus_write_byte_data(client, DS1307_REG_MONTH, 1);
+			i2c_smbus_write_byte_data(client, DS1307_REG_MDAY, 1);
+			i2c_smbus_write_byte_data(client, DS1307_REG_WDAY, 1);
+			i2c_smbus_write_byte_data(client, DS1307_REG_HOUR, 0);
+			i2c_smbus_write_byte_data(client, DS1307_REG_MIN, 0);
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 1);
+			dev_warn(&client->dev, "reset bogus registers\n");
+			already_reset = true;
+			goto read_rtc;
+		}
+
 		/* clock halted?  turn it on, so clock can tick. */
 		if (tmp & DS1307_BIT_CH) {
 			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
@@ -707,20 +753,7 @@ read_rtc:
 		break;
 	}
 
-	tmp = ds1307->regs[DS1307_REG_SECS];
-	tmp = bcd2bin(tmp & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
-	tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
-
-	tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
-	if (tmp == 0 || tmp > 31)
-		goto exit_bad;
-
-	tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
-	if (tmp == 0 || tmp > 12)
+	if (!ds1307_regs_valid(ds1307))
 		goto exit_bad;
 
 	tmp = ds1307->regs[DS1307_REG_HOUR];
-- 
1.6.0.2

