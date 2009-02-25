Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbZBYPRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbZBYPRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759882AbZBYPJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:21 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56739 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbZBYPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:45 -0500
Message-Id: <20090225150837.676516184@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:07:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 38/46] qdio: call qdio_free also if qdio_shutdown fails
Content-Disposition: inline; filename=137-qdio-free.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

qdio_cleanup is a wrapper function that should call qdio_shutdown and
qdio_free. qdio_free was not called if an error occured in qdio_shutdown
resulting in a missing free of allocated resources.

Call qdio_free regardless of the return value of qdio_shutdown.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio_main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: quilt-2.6/drivers/s390/cio/qdio_main.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio_main.c
+++ quilt-2.6/drivers/s390/cio/qdio_main.c
@@ -1073,8 +1073,9 @@ EXPORT_SYMBOL_GPL(qdio_get_ssqd_desc);
  * @cdev: associated ccw device
  * @how: use halt or clear to shutdown
  *
- * This function calls qdio_shutdown() for @cdev with method @how
- * and on success qdio_free() for @cdev.
+ * This function calls qdio_shutdown() for @cdev with method @how.
+ * and qdio_free(). The qdio_free() return value is ignored since
+ * !irq_ptr is already checked.
  */
 int qdio_cleanup(struct ccw_device *cdev, int how)
 {
@@ -1085,8 +1086,8 @@ int qdio_cleanup(struct ccw_device *cdev
 		return -ENODEV;
 
 	rc = qdio_shutdown(cdev, how);
-	if (rc == 0)
-		rc = qdio_free(cdev);
+
+	qdio_free(cdev);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(qdio_cleanup);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

