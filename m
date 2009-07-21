Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZGUPAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZGUPAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZGUPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42581 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754035AbZGUPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] regulator: Add regulator voltage range check API
Date: Tue, 21 Jul 2009 16:00:24 +0100
Message-Id: <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify checking of support for voltage ranges by providing an API which
wraps the existing count and list operations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   29 +++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 ++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8445524..33a8c3c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1442,6 +1442,35 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 EXPORT_SYMBOL_GPL(regulator_list_voltage);
 
 /**
+ * regulator_is_supported_voltage - check if a voltage range can be supported
+ *
+ * @regulator: Regulator to check.
+ * @min_uV: Minimum required voltage in uV.
+ * @max_uV: Maximum required voltage in uV.
+ *
+ * Returns a boolean or a negative error code.
+ */
+int regulator_is_supported_voltage(struct regulator *regulator,
+				   int min_uV, int max_uV)
+{
+	int i, voltages, ret;
+
+	ret = regulator_count_voltages(regulator);
+	if (ret < 0)
+		return ret;
+	voltages = ret;
+
+	for (i = 0; i < voltages; i++) {
+		ret = regulator_list_voltage(regulator, i);
+
+		if (ret >= min_uV && ret <= max_uV)
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
  * regulator_set_voltage - set regulator output voltage
  * @regulator: regulator source
  * @min_uV: Minimum required voltage in uV
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 976b57b..490c5b3 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -146,6 +146,8 @@ void regulator_bulk_free(int num_consumers,
 
 int regulator_count_voltages(struct regulator *regulator);
 int regulator_list_voltage(struct regulator *regulator, unsigned selector);
+int regulator_is_supported_voltage(struct regulator *regulator,
+				   int min_uV, int max_uV);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
 int regulator_get_voltage(struct regulator *regulator);
 int regulator_set_current_limit(struct regulator *regulator,
-- 
1.6.3.3

