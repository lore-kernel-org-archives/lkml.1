Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555Ab0ADSRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0ADSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051Ab0ADSRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:17:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37059 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551Ab0ADSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:17:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regulator: Add notifier event on regulator disable
Date: Mon,  4 Jan 2010 18:17:44 +0000
Message-Id: <1262629066-18398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <20100104181634.GA18258@rakim.wolfsonmicro.main>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intended use case is for drivers which disable regulators to save
power but need to do some work to restore the hardware state when
restarting.  If the supplies are not actually disabled due to board
limits or sharing with other active devices this notifier allows the
driver to avoid unneeded reinitialisation, particularly when used with
runtime PM.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |    7 +++++--
 include/linux/regulator/consumer.h |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 686ef27..cce76a8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1341,6 +1341,9 @@ static int _regulator_disable(struct regulator_dev *rdev)
 				       __func__, rdev_get_name(rdev));
 				return ret;
 			}
+
+			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
+					     NULL);
 		}
 
 		/* decrease our supplies ref count and disable if required */
@@ -1399,8 +1402,8 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 			return ret;
 		}
 		/* notify other consumers that power has been forced off */
-		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE,
-			NULL);
+		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
+			REGULATOR_EVENT_DISABLE, NULL);
 	}
 
 	/* decrease our supplies ref count and disable if required */
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 030d922..28c9fd0 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -89,8 +89,9 @@
  * REGULATION_OUT Regulator output is out of regulation.
  * FAIL           Regulator output has failed.
  * OVER_TEMP      Regulator over temp.
- * FORCE_DISABLE  Regulator shut down by software.
+ * FORCE_DISABLE  Regulator forcibly shut down by software.
  * VOLTAGE_CHANGE Regulator voltage changed.
+ * DISABLE        Regulator was disabled.
  *
  * NOTE: These events can be OR'ed together when passed into handler.
  */
@@ -102,6 +103,7 @@
 #define REGULATOR_EVENT_OVER_TEMP		0x10
 #define REGULATOR_EVENT_FORCE_DISABLE		0x20
 #define REGULATOR_EVENT_VOLTAGE_CHANGE		0x40
+#define REGULATOR_EVENT_DISABLE 		0x80
 
 struct regulator;
 
-- 
1.6.5.7

