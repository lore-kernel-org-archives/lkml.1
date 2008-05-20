Return-Path: <linux-kernel-owner+w=401wt.eu-S935067AbYETWje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935067AbYETWje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbYETWgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:03 -0400
Received: from mail.suse.de ([195.135.220.2]:53346 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934949AbYETWgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:36:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 07/13] Power Supply: fix race in device_create
Date: Tue, 20 May 2008 15:34:54 -0700
Message-Id: <1211322900-12705-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/power/power_supply_core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 138dd76..af1633e 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -91,15 +91,13 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
 
-	psy->dev = device_create(power_supply_class, parent, 0,
-				 "%s", psy->name);
+	psy->dev = device_create_drvdata(power_supply_class, parent, 0,
+					 psy, "%s", psy->name);
 	if (IS_ERR(psy->dev)) {
 		rc = PTR_ERR(psy->dev);
 		goto dev_create_failed;
 	}
 
-	dev_set_drvdata(psy->dev, psy);
-
 	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
 	rc = power_supply_create_attrs(psy);
-- 
1.5.5.1

