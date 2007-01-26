Return-Path: <linux-kernel-owner+w=401wt.eu-S1030862AbXAZQvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbXAZQvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXAZQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:50:25 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:19111 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030863AbXAZQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:50:06 -0500
Date: Fri, 26 Jan 2007 17:50:04 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Restart path verification after unsolicited interrupt.
Message-ID: <20070126165004.GK11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Restart path verification after unsolicited interrupt.

If we try to start path verification when an unsolicited interrupt
is already pending, stctl shows status pending and we delay path
verification again. We need to check for the doverify bit when the
unsolicited interrupt comes in and then do path verification.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |    2 ++
 1 files changed, 2 insertions(+)

diff -urpN linux-2.6/drivers/s390/cio/device_fsm.c linux-2.6-patched/drivers/s390/cio/device_fsm.c
--- linux-2.6/drivers/s390/cio/device_fsm.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_fsm.c	2007-01-26 17:27:56.000000000 +0100
@@ -842,6 +842,8 @@ ccw_device_irq(struct ccw_device *cdev, 
 call_handler_unsol:
 		if (cdev->handler)
 			cdev->handler (cdev, 0, irb);
+		if (cdev->private->flags.doverify)
+			ccw_device_online_verify(cdev, 0);
 		return;
 	}
 	/* Accumulate status and find out if a basic sense is needed. */
