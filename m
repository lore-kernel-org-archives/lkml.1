Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYLaMyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYLaMyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYLaMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:54:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2308 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbYLaMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:54:27 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 31 Dec 2008 12:54:19 +0000
Message-Id: <1230728059-9392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: catch some registration errors
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Prevent registration of duplicate "struct regulator" names.
They'd be unavailable, and clearly indicate something wrong.

[Edited to remove check for NULL consumer device until we have a
solution for things like cpufreq -- broonie]

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 895f738..fcac9e5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -775,6 +775,20 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 	if (supply == NULL)
 		return -EINVAL;
 
+	list_for_each_entry(node, &regulator_map_list, list) {
+		if (consumer_dev != node->dev)
+			continue;
+		if (strcmp(node->supply, supply) != 0)
+			continue;
+
+		dev_dbg(consumer_dev, "%s/%s is '%s' supply; fail %s/%s\n",
+				dev_name(&node->regulator->dev),
+				node->regulator->desc->name,
+				supply,
+				dev_name(&rdev->dev), rdev->desc->name);
+		return -EBUSY;
+	}
+
 	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
 	if (node == NULL)
 		return -ENOMEM;
-- 
1.5.6.3

