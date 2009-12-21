Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZLUVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZLUVH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZLUVHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:07:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbZLUVHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:07:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/5] PM: Use pm_runtime_put_sync in system resume
Date: Mon, 21 Dec 2009 22:05:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200912212201.47920.rjw@sisk.pl>
In-Reply-To: <200912212201.47920.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <200912212205.12343.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1317) fixes a bug in the PM core.  When a device is
resumed following a system sleep, the core decrements the device's
runtime PM usage counter but doesn't issue an idle notification if the
counter reaches 0.  This could prevent an otherwise unused device from
being runtime-suspended again after the system sleep.

The fix is to call pm_runtime_put_sync() instead of
pm_runtime_put_noidle().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -607,7 +607,7 @@ static void dpm_complete(pm_message_t st
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
-			pm_runtime_put_noidle(dev);
+			pm_runtime_put_sync(dev);
 
 			mutex_lock(&dpm_list_mtx);
 		}
@@ -880,7 +880,7 @@ static int dpm_prepare(pm_message_t stat
 		pm_runtime_get_noresume(dev);
 		if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
 			/* Wake-up requested during system sleep transition. */
-			pm_runtime_put_noidle(dev);
+			pm_runtime_put_sync(dev);
 			error = -EBUSY;
 		} else {
 			error = device_prepare(dev, state);

