Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbXLTPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbXLTPYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933606AbXLTPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:21:25 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:17361 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764000AbXLTPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:06 -0500
Message-Id: <20071220152104.005982837@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:30 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/47] cio: Reset sch->driver.
Content-Disposition: inline; filename=104-cio-reset.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

sch->driver needs to be reset to NULL on failed probe and after
remove. We also need to check for sch->driver on shutdown.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -796,32 +796,36 @@ css_bus_match (struct device *dev, struc
 	return 0;
 }
 
-static int
-css_probe (struct device *dev)
+static int css_probe(struct device *dev)
 {
 	struct subchannel *sch;
+	int ret;
 
 	sch = to_subchannel(dev);
 	sch->driver = to_cssdriver(dev->driver);
-	return (sch->driver->probe ? sch->driver->probe(sch) : 0);
+	ret = sch->driver->probe ? sch->driver->probe(sch) : 0;
+	if (ret)
+		sch->driver = NULL;
+	return ret;
 }
 
-static int
-css_remove (struct device *dev)
+static int css_remove(struct device *dev)
 {
 	struct subchannel *sch;
+	int ret;
 
 	sch = to_subchannel(dev);
-	return (sch->driver->remove ? sch->driver->remove(sch) : 0);
+	ret = sch->driver->remove ? sch->driver->remove(sch) : 0;
+	sch->driver = NULL;
+	return ret;
 }
 
-static void
-css_shutdown (struct device *dev)
+static void css_shutdown(struct device *dev)
 {
 	struct subchannel *sch;
 
 	sch = to_subchannel(dev);
-	if (sch->driver->shutdown)
+	if (sch->driver && sch->driver->shutdown)
 		sch->driver->shutdown(sch);
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

