Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZD1KJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZD1KJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZD1KJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:09:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50578 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063AbZD1KJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:09:40 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.30] regulator: Fix default constraints for fixed voltage regulators
Date: Tue, 28 Apr 2009 11:09:38 +0100
Message-Id: <1240913378-22201-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default voltage constraints were being provided for fixed voltage
regulator where board constraints were not provided but these constraints
used INT_MIN as the default minimum voltage which is not a valid value
since it is less than zero. Use 1uV instead.

Also set the default values we set in the constraints themselves since
otherwise the max_uV constraint we determine will not be stored in the
actual constraint strucutre and will therefore not be used.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 01f7702..dccf94d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -703,10 +703,13 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		int	cmin = constraints->min_uV;
 		int	cmax = constraints->max_uV;
 
-		/* it's safe to autoconfigure fixed-voltage supplies */
+		/* it's safe to autoconfigure fixed-voltage supplies
+		   and the constraints are used by list_voltage. */
 		if (count == 1 && !cmin) {
-			cmin = INT_MIN;
+			cmin = 1;
 			cmax = INT_MAX;
+			constraints->min_uV = cmin;
+			constraints->max_uV = cmax;
 		}
 
 		/* voltage constraints are optional */
-- 
1.6.2.4

