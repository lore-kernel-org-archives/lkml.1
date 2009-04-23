Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZDWNKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZDWNKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZDWNK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:10:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:43517 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbZDWNK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:10:28 -0400
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: [PATCH 1/1] TWL4030: Activate VDD1, VDD2 and VPLL1 at startup
Date: Thu, 23 Apr 2009 16:10:08 +0300
Message-Id: <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com>
References: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com>
X-OriginalArrivalTime: 23 Apr 2009 13:10:11.0947 (UTC) FILETIME=[D5A43BB0:01C9C414]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch activates VDD1, VDD2 and VPLL1 when booting. This is necessary
because these resources are in warm reset state after a reboot. This means
their voltage levels cannot be modified so DVFS and smartreflex don't work.

Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 80a4e10..ab2a726 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -506,6 +506,22 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rdev);
 
+	/* VDD1, VDD2 and VPLL1 are left in warm reset state after a reboot.
+	 * We need to put them back to active state for DVFS and smartreflex.
+	 */
+
+	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD1,
+		RES_STATE_ACTIVE)) < 0)
+		pr_err("Unable to activate VDD1\n");
+
+	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD2,
+		RES_STATE_ACTIVE)) < 0)
+		pr_err("Unable to activate VDD2\n");
+
+	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VPLL1,
+		RES_STATE_ACTIVE)) < 0)
+		pr_err("Unable to activate VPLL1\n");
+
 	/* NOTE:  many regulators support short-circuit IRQs (presentable
 	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
 	 *  - SC_CONFIG
-- 
1.5.6.3

