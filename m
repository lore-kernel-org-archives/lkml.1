Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbYHHXCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbYHHXCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHHXCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:02:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYHHXCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:02:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] PM: Remove WARN_ON from device_pm_add
Date: Sat, 9 Aug 2008 01:05:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090105.14770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM: Remove WARN_ON from device_pm_add

Fix message in device_pm_add() saying that the device will not be
added to dpm_list, although in fact the device is going to be added
to the list regardless of the ordering violation.

Remove the WARN_ON(true) triggered in that situation, because it is
hit by USB very often and spams the users' logs.

This patch fixes bug #11263

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
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
