Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXETOdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXETOdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXETOc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:32:58 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:56541 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbXETOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=t1+lCScRcaXGg95WZKTgPvmFYD8WA5wMC1FrN/p3dcXyun7iplI2QAfBOQcFO7cqKt9BiQVP7y67ifkeH8y1KJp07Cf4a2+6dCg3D3rJ0MaadneMjdWYYP0/vpcn/icXKYqXLn0vwRf3wjxpF+TMi3H7za8AD4haiW/gH+r1m3I=
Date: Sun, 20 May 2007 23:25:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i2o: destroy event queue only when drv->event is set
Message-ID: <20070520142539.GA4207@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Markus Lidel <Markus.Lidel@shadowconnect.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i2o_driver_register() initalizes event queue for driver
only when drv->event is set. So similarly the event queue
should be destroyed only when drv->event is set in the error path.
Otherwise destroy_workqueue() will called with NULL.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/message/i2o/driver.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: 2.6-mm/drivers/message/i2o/driver.c
===================================================================
--- 2.6-mm.orig/drivers/message/i2o/driver.c
+++ 2.6-mm/drivers/message/i2o/driver.c
@@ -123,8 +123,12 @@ int i2o_driver_register(struct i2o_drive
 	}
 
 	rc = driver_register(&drv->driver);
-	if (rc)
-		destroy_workqueue(drv->event_queue);
+	if (rc) {
+		if (drv->event) {
+			destroy_workqueue(drv->event_queue);
+			drv->event_queue = NULL;
+		}
+	}
 
 	return rc;
 };
