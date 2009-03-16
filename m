Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbZCPThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbZCPThA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbZCPTgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:36:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46143 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761523AbZCPTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:36:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Don't increment use_count for boot_on regulators
Date: Mon, 16 Mar 2009 19:36:33 +0000
Message-Id: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't set use_count for regulators that are enabled at boot since this
stops the supply being disabled by well-behaved consumers which do
balanced enables and disabled. Any consumers which don't do disables
which are not matched by enables are unable to share regulators - shared
regulators are the common case so the API should facilitate them.

Consumers that want to disable regulators that are enabled when they
start have two options:

 - Do a regulator_enable() prior to the disable to bring the use count
   in sync with the hardware state; this will ensure that if the
   regulator was enabled by another driver then this consumer will play
   nicely with it.
 - Use regulator_force_disable(); this explicitly bypasses any checks
   done by the core and documents the inability of the driver to share
   the supply.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9448875..8588a24 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -814,7 +814,6 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			rdev->constraints = NULL;
 			goto out;
 		}
-		rdev->use_count = 1;
 	}
 
 	print_constraints(rdev);
-- 
1.6.2

