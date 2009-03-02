Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZCBVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZCBVB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZCBVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:01:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35369 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZCBVBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:01:19 -0500
Date: Mon, 2 Mar 2009 13:01:06 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] lm90: Support the MAX6648/6692 chips
Message-ID: <20090302210106.GD6550@plum>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max6648 chip has nearly the same register set as the 6657 and
seems to have a working manufacturer/chip id so we can detect it.
This patch adds support for it.  Tested on a Nvidia Quadro FX 1500
card.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/Kconfig |    4 ++--
 drivers/hwmon/lm90.c  |    7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8c312c6..7da49d3 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -550,8 +550,8 @@ config SENSORS_LM90
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
 	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, and Maxim
-	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680 and
-	  MAX6681 sensor chips.
+	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680,
+	  MAX6648, MAX6692 and MAX6681 sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 96a7018..1802366 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -776,7 +776,12 @@ static int lm90_detect(struct i2c_client *new_client, int kind,
 			 && (reg_config1 & 0x3f) == 0x00
 			 && reg_convrate <= 0x07) {
 				kind = max6646;
-			}
+			} else
+			/* The MAX6648/6692 chips have a working man/chip id
+			 * and the same register set as the 6657.
+			 */
+			if (chip_id == 0x59 && address == 0x4C)
+				kind = max6657;
 		}
 
 		if (kind <= 0) { /* identification failed */
