Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZCJQ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZCJQ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZCJQ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:28:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55670 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754112AbZCJQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:28:40 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Don't warn on omitted voltage constraints
Date: Tue, 10 Mar 2009 16:28:36 +0000
Message-Id: <1236702516-30733-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236702516-30733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236702516-30733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying voltage constraints is optional (and only needed if the
consumer is allowed to change the voltage) so don't complain unless
a voltage has been specified.

Also avoid surprises with a dangling else while we're here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 464e9b1..08441e2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -709,8 +709,12 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			cmax = INT_MAX;
 		}
 
+		/* voltage constraints are optional */
+		if ((cmin == 0) && (cmax == 0))
+			goto out;
+
 		/* else require explicit machine-level constraints */
-		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
 			pr_err("%s: %s '%s' voltage constraints\n",
 				       __func__, "invalid", name);
 			ret = -EINVAL;
-- 
1.6.2

