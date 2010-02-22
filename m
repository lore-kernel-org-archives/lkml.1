Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0BVRRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:17:23 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:48663 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0BVRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eNXHNH8Lkqx5f0z+ur+DRJGEw8de4a900ZJkP8DZbRCQp9AdkssrS5OjqjWXtGHEEa
         0P/uWM/4Zk0B9D5qBonOngw6RSJDj/jpwjw7hgy5xCDJf5LaSeHupm3I41tH0x51yxt5
         idNsNV8Rvgnt+u7OmVdfINJVdrIvgkRqf25Ak=
From: mturquette@gmail.com
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Mike Turquette <mturquette@ti.com>
Subject: [PATCH] MFD: TWL4030: introduce remove_script function
Date: Mon, 22 Feb 2010 11:16:30 -0600
Message-Id: <1266858990-3915-1-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@ti.com>

New function twl4030_remove_script(u8 flags) takes a script type as
defined in twl.h and prevents any script already loaded in that position
from running.  This is accomplished by programming SEQ_ADD_* to 0x3f,
the END_OF_SCRIPT value, where SEQ_ADD_* is determined by flags.

Signed-off-by: Mike Turquette <mturquette@ti.com>
---

Based on MFD for-next branch.

Future users of this function include OMAP board files for machines
facing a race condition between sleep and warm reset.

 drivers/mfd/twl4030-power.c |   50 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl.h     |    1 +
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 5b045ff..7efa878 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -461,6 +461,56 @@ out:
 	return err;
 }
 
+int twl4030_remove_script(u8 flags)
+{
+	int err = 0;
+
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_1,
+			R_PROTECT_KEY);
+	if (err) {
+		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
+		return err;
+	}
+
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_2,
+			R_PROTECT_KEY);
+	if (err) {
+		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
+		return err;
+	}
+
+	if (flags & TWL4030_WRST_SCRIPT) {
+		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
+				R_SEQ_ADD_WARM);
+		if (err)
+			return err;
+	}
+	if (flags & TWL4030_WAKEUP12_SCRIPT) {
+		if (err)
+		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
+				R_SEQ_ADD_S2A12);
+			return err;
+	}
+	if (flags & TWL4030_WAKEUP3_SCRIPT) {
+		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
+				R_SEQ_ADD_S2A3);
+		if (err)
+			return err;
+	}
+	if (flags & TWL4030_SLEEP_SCRIPT) {
+		err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, END_OF_SCRIPT,
+				R_SEQ_ADD_A2S);
+		if (err)
+			return err;
+	}
+
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY);
+	if (err)
+		pr_err("TWL4030 Unable to relock registers\n");
+
+	return err;
+}
+
 void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 {
 	int err = 0;
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 33d9d5c..d4baff8 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -550,6 +550,7 @@ struct twl4030_power_data {
 };
 
 extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
+extern int twl4030_remove_script(u8 flags);
 
 struct twl4030_codec_audio_data {
 	unsigned int	audio_mclk;
-- 
1.6.3.2

