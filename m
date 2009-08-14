Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZHNL3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZHNL3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZHNL3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:29:39 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:52203 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbZHNL0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:37 -0400
Message-Id: <20090814112613.709334234@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/34] cio: fix double free after failed device initialization
Content-Disposition: inline; filename=104-cio-double-free.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

If io_subchannel_initialize_dev fails it will release the only
reference to the ccw device therefore the caller should not
kfree this device since this is done in the release function.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -772,10 +772,8 @@ static struct ccw_device * io_subchannel
 	cdev = io_subchannel_allocate_dev(sch);
 	if (!IS_ERR(cdev)) {
 		ret = io_subchannel_initialize_dev(sch, cdev);
-		if (ret) {
-			kfree(cdev);
+		if (ret)
 			cdev = ERR_PTR(ret);
-		}
 	}
 	return cdev;
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

