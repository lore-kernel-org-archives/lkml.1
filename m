Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZFDQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZFDQT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbZFDQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:06 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:58995 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZFDQTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:01 -0400
Message-Id: <20090604161901.823428795@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:18:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/38] pm: chsc subchannel driver power management callbacks
Content-Disposition: inline; filename=pm_chsc_sch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/cio/chsc_sch.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/s390/cio/chsc_sch.c
===================================================================
--- linux-2.6.orig/drivers/s390/cio/chsc_sch.c
+++ linux-2.6/drivers/s390/cio/chsc_sch.c
@@ -1,7 +1,8 @@
 /*
  * Driver for s390 chsc subchannels
  *
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008, 2009
+ *
  * Author(s): Cornelia Huck <cornelia.huck@de.ibm.com>
  *
  */
@@ -112,6 +113,31 @@ static void chsc_subchannel_shutdown(str
 	cio_disable_subchannel(sch);
 }
 
+static int chsc_subchannel_prepare(struct subchannel *sch)
+{
+	int cc;
+	struct schib schib;
+	/*
+	 * Don't allow suspend while the subchannel is not idle
+	 * since we don't have a way to clear the subchannel and
+	 * cannot disable it with a request running.
+	 */
+	cc = stsch(sch->schid, &schib);
+	if (!cc && scsw_stctl(&schib.scsw))
+		return -EAGAIN;
+	return 0;
+}
+
+static int chsc_subchannel_freeze(struct subchannel *sch)
+{
+	return cio_disable_subchannel(sch);
+}
+
+static int chsc_subchannel_restore(struct subchannel *sch)
+{
+	return cio_enable_subchannel(sch, (u32)(unsigned long)sch);
+}
+
 static struct css_device_id chsc_subchannel_ids[] = {
 	{ .match_flags = 0x1, .type =SUBCHANNEL_TYPE_CHSC, },
 	{ /* end of list */ },
@@ -125,6 +151,10 @@ static struct css_driver chsc_subchannel
 	.probe = chsc_subchannel_probe,
 	.remove = chsc_subchannel_remove,
 	.shutdown = chsc_subchannel_shutdown,
+	.prepare = chsc_subchannel_prepare,
+	.freeze = chsc_subchannel_freeze,
+	.thaw = chsc_subchannel_restore,
+	.restore = chsc_subchannel_restore,
 	.name = "chsc_subchannel",
 };
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

