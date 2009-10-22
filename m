Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZJVPb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZJVPb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZJVPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41212 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756523AbZJVPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] regulator: Display actual settings with constraints
Date: Thu, 22 Oct 2009 16:31:31 +0100
Message-Id: <1256225495-15379-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When voltage or current constraints are either missing or specify
a range display the actual setting along with the constraints if
we can. This can aid debugging of configuration problems.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   44 +++++++++++++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1848a3f..d3be67e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -641,25 +641,43 @@ static void print_constraints(struct regulator_dev *rdev)
 {
 	struct regulation_constraints *constraints = rdev->constraints;
 	char buf[80];
-	int count;
+	int count = 0;
+	int ret;
 
-	if (rdev->desc->type == REGULATOR_VOLTAGE) {
+	if (constraints->min_uV && constraints->max_uV) {
 		if (constraints->min_uV == constraints->max_uV)
-			count = sprintf(buf, "%d mV ",
-					constraints->min_uV / 1000);
+			count += sprintf(buf + count, "%d mV ",
+					 constraints->min_uV / 1000);
 		else
-			count = sprintf(buf, "%d <--> %d mV ",
-					constraints->min_uV / 1000,
-					constraints->max_uV / 1000);
-	} else {
+			count += sprintf(buf + count, "%d <--> %d mV ",
+					 constraints->min_uV / 1000,
+					 constraints->max_uV / 1000);
+	}
+
+	if (!constraints->min_uV ||
+	    constraints->min_uV != constraints->max_uV) {
+		ret = _regulator_get_voltage(rdev);
+		if (ret > 0)
+			count += sprintf(buf + count, "at %d mV ", ret / 1000);
+	}
+
+	if (constraints->min_uA && constraints->max_uA) {
 		if (constraints->min_uA == constraints->max_uA)
-			count = sprintf(buf, "%d mA ",
-					constraints->min_uA / 1000);
+			count += sprintf(buf + count, "%d mA ",
+					 constraints->min_uA / 1000);
 		else
-			count = sprintf(buf, "%d <--> %d mA ",
-					constraints->min_uA / 1000,
-					constraints->max_uA / 1000);
+			count += sprintf(buf + count, "%d <--> %d mA ",
+					 constraints->min_uA / 1000,
+					 constraints->max_uA / 1000);
 	}
+
+	if (!constraints->min_uA ||
+	    constraints->min_uA != constraints->max_uA) {
+		ret = _regulator_get_current_limit(rdev);
+		if (ret > 0)
+			count += sprintf(buf + count, "at %d uA ", ret / 1000);
+	}
+
 	if (constraints->valid_modes_mask & REGULATOR_MODE_FAST)
 		count += sprintf(buf + count, "fast ");
 	if (constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
-- 
1.6.5

