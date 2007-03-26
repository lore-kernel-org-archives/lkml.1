Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbXCZUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbXCZUxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXCZUxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:53:22 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:16466 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXCZUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:52:57 -0400
Message-Id: <20070326205254.130459124@de.ibm.com>
References: <20070326205225.438154546@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:52:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ralph Wuerthner <rwuerthn@de.ibm.com>
Subject: [patch 6/6] zcrypt: Fix ap_poll_requests counter in lost requests error path.
Content-Disposition: inline; filename=006-zcrypt-req.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

In the unlikely event that an AP device lost requests, don't forget to
update the ap_poll_requests counter too. Same must happen in case an AP
device is removed while there are still outstanding requests.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/crypto/ap_bus.c |    4 ++++
 1 files changed, 4 insertions(+)

Index: linux-2.6/drivers/s390/crypto/ap_bus.c
===================================================================
--- linux-2.6.orig/drivers/s390/crypto/ap_bus.c
+++ linux-2.6/drivers/s390/crypto/ap_bus.c
@@ -505,6 +505,9 @@ static int ap_device_remove(struct devic
 	spin_lock_bh(&ap_device_lock);
 	list_del_init(&ap_dev->list);
 	spin_unlock_bh(&ap_device_lock);
+	spin_lock_bh(&ap_dev->lock);
+	atomic_sub(ap_dev->queue_count, &ap_poll_requests);
+	spin_unlock_bh(&ap_dev->lock);
 	return 0;
 }
 
@@ -867,6 +870,7 @@ static int ap_poll_read(struct ap_device
 	case AP_RESPONSE_NO_PENDING_REPLY:
 		if (status.queue_empty) {
 			/* The card shouldn't forget requests but who knows. */
+			atomic_sub(ap_dev->queue_count, &ap_poll_requests);
 			ap_dev->queue_count = 0;
 			list_splice_init(&ap_dev->pendingq, &ap_dev->requestq);
 			ap_dev->requestq_count += ap_dev->pendingq_count;

-- 
