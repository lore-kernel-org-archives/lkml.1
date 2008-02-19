Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYBSOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYBSOqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYBSOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:16 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:8120 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYBSOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:09 -0500
Message-Id: <20080219144503.221183779@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:49 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 02/13] cio: Do timed recovery on workqueue.
Content-Disposition: inline; filename=002-cio-recovery.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

We can't do our recovery in softirq context, so we schedule it from
our timer function.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -1535,7 +1535,7 @@ static int recovery_check(struct device 
 	return 0;
 }
 
-static void recovery_func(unsigned long data)
+static void recovery_work_func(struct work_struct *unused)
 {
 	int redo = 0;
 
@@ -1553,6 +1553,17 @@ static void recovery_func(unsigned long 
 		CIO_MSG_EVENT(2, "recovery: end\n");
 }
 
+static DECLARE_WORK(recovery_work, recovery_work_func);
+
+static void recovery_func(unsigned long data)
+{
+	/*
+	 * We can't do our recovery in softirq context and it's not
+	 * performance critical, so we schedule it.
+	 */
+	schedule_work(&recovery_work);
+}
+
 void ccw_device_schedule_recovery(void)
 {
 	unsigned long flags;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

