Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZGUPAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZGUPAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZGUPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42578 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753814AbZGUPAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] regulator: Fix support for deviceless supply mappings
Date: Tue, 21 Jul 2009 16:00:26 +0100
Message-Id: <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch to add support for looking up consumers by device name
had the side effect of causing us to require a device which is
at best premature since at least cpufreq still operates outside
the device model. Remove that requirement.

Reported-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e5ccc9f..cba10ec 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -872,6 +872,7 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 	const char *supply)
 {
 	struct regulator_map *node;
+	int has_dev;
 
 	if (consumer_dev && consumer_dev_name)
 		return -EINVAL;
@@ -882,6 +883,11 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 	if (supply == NULL)
 		return -EINVAL;
 
+	if (consumer_dev_name != NULL)
+		has_dev = 1;
+	else
+		has_dev = 0;
+
 	list_for_each_entry(node, &regulator_map_list, list) {
 		if (consumer_dev_name != node->dev_name)
 			continue;
@@ -896,17 +902,19 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 		return -EBUSY;
 	}
 
-	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
+	node = kzalloc(sizeof(struct regulator_map), GFP_KERNEL);
 	if (node == NULL)
 		return -ENOMEM;
 
 	node->regulator = rdev;
-	node->dev_name = kstrdup(consumer_dev_name, GFP_KERNEL);
 	node->supply = supply;
 
-	if (node->dev_name == NULL) {
-		kfree(node);
-		return -ENOMEM;
+	if (has_dev) {
+		node->dev_name = kstrdup(consumer_dev_name, GFP_KERNEL);
+		if (node->dev_name == NULL) {
+			kfree(node);
+			return -ENOMEM;
+		}
 	}
 
 	list_add(&node->list, &regulator_map_list);
-- 
1.6.3.3

