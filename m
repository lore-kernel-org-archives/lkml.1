Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZAVOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZAVOAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZAVOAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:00:35 -0500
Received: from cathcart.site5.com ([74.54.107.137]:33309 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZAVOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:00:34 -0500
Message-ID: <49787BFD.3020702@compulab.co.il>
Date: Thu, 22 Jan 2009 16:00:29 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: add unset_regulator_supplies to fix regulator_unregister
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently regulator_unregister does not clear regulator <--> consumer
mapping.
This patch introduces unset_regulator_supplies that clear the map.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f511a40..ab1beec 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -817,6 +817,19 @@ static void unset_consumer_device_supply(struct regulator_dev *rdev,
 	}
 }

+static void unset_regulator_supplies(struct regulator_dev *rdev)
+{
+	struct regulator_map *node, *n;
+
+	list_for_each_entry_safe(node, n, &regulator_map_list, list) {
+		if (rdev == node->regulator) {
+			list_del(&node->list);
+			kfree(node);
+			return;
+		}
+	}
+}
+
 #define REG_STR_SIZE	32

 static struct regulator *create_regulator(struct regulator_dev *rdev,
@@ -1945,6 +1958,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 		return;

 	mutex_lock(&regulator_list_mutex);
+	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
 	if (rdev->supply)
 		sysfs_remove_link(&rdev->dev.kobj, "supply");
-- 
1.5.6.4



-- 
Sincerely yours,
Mike.

