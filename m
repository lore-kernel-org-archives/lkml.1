Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbYCEL71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbYCEL71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764996AbYCEL5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:57:25 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2776 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761732AbYCEL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:57:20 -0500
Message-Id: <20080305115714.023087298@de.ibm.com>
References: <20080305115432.691030908@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 12:54:37 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/10] dasd: fix reference counting in display method for proc/dasd/devices
Content-Disposition: inline; filename=005-dasd-refcount.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

Using the /proc/dasd/devices interface leaves the reference counter
of alias devices in an inconsistent state. A process that tries to set
such a device offline afterwards will hang.
The dasd_devices_show function returns immediately for alias devices
and this code path was missing a dasd_put_device call.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_proc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/block/dasd_proc.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_proc.c
+++ quilt-2.6/drivers/s390/block/dasd_proc.c
@@ -62,8 +62,10 @@ dasd_devices_show(struct seq_file *m, vo
 		return 0;
 	if (device->block)
 		block = device->block;
-	else
+	else {
+		dasd_put_device(device);
 		return 0;
+	}
 	/* Print device number. */
 	seq_printf(m, "%s", device->cdev->dev.bus_id);
 	/* Print discipline string. */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

