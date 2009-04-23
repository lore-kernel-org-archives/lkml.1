Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZDWNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZDWNIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZDWNIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:08:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17204 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZDWNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:08:19 -0400
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: [PATCH] TWL4030: Make sure the regulator is active after calling twl4030reg_enable
Date: Thu, 23 Apr 2009 16:08:09 +0300
Message-Id: <1240492089-14410-2-git-send-email-peter.de-schrijver@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1240492089-14410-1-git-send-email-peter.de-schrijver@nokia.com>
References: <1240492089-14410-1-git-send-email-peter.de-schrijver@nokia.com>
X-OriginalArrivalTime: 23 Apr 2009 13:08:12.0504 (UTC) FILETIME=[8E72AD80:01C9C414]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure a regulator is active when enabled. After a warm reboot, only adding
a regulator to a power group is not enough to activate it.

Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index df9a94b..80a4e10 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -177,14 +177,21 @@ static int twl4030reg_is_enabled(struct regulator_dev *rdev)
 static int twl4030reg_enable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			grp;
+	int			grp, status;
+	unsigned 		message;
 
 	grp = twl4030reg_read(info, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp |= P1_GRP;
-	return twl4030reg_write(info, VREG_GRP, grp);
+	status =  twl4030reg_write(info, VREG_GRP, grp);
+	if (status < 0)
+		return status;
+
+	message = MSG_SINGULAR(DEV_GRP_P1, info->id, RES_STATE_ACTIVE);
+
+	return twl4030_send_pb_msg(message);
 }
 
 static int twl4030reg_disable(struct regulator_dev *rdev)
-- 
1.5.6.3

