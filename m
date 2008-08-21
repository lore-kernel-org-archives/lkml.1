Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYHURjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYHURjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760087AbYHURjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:39:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:47965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYHURjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:39:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/15] PM: Remove WARN_ON from device_pm_add
Date: Thu, 21 Aug 2008 10:32:57 -0700
Message-Id: <1219339983-9634-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

PM: Remove WARN_ON from device_pm_add

Fix message in device_pm_add() saying that the device will not be
added to dpm_list, although in fact the device is going to be added
to the list regardless of the ordering violation.

Remove the WARN_ON(true) triggered in that situation, because it is
hit by USB very often and spams the users' logs.

This patch fixes bug #11263

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 284f564..273a944 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -74,11 +74,9 @@ void device_pm_add(struct device *dev)
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	if (dev->parent) {
-		if (dev->parent->power.status >= DPM_SUSPENDING) {
-			dev_warn(dev, "parent %s is sleeping, will not add\n",
+		if (dev->parent->power.status >= DPM_SUSPENDING)
+			dev_warn(dev, "parent %s should not be sleeping\n",
 				dev->parent->bus_id);
-			WARN_ON(true);
-		}
 	} else if (transition_started) {
 		/*
 		 * We refuse to register parentless devices while a PM
-- 
1.5.6.5

