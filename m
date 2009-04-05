Return-Path: <linux-kernel-owner+w=401wt.eu-S1751599AbZDEQkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbZDEQkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZDEQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:39:49 -0400
Received: from mail.pxnet.com ([195.227.45.7]:56699 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZDEQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:39:49 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/3] bas_gigaset: use tasklet_hi_schedule for timing critical tasklets
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090404-patch-01.tilman@imap.cc>
In-Reply-To: <20090404-patch-00.tilman@imap.cc>
References: <20090404-patch-00.tilman@imap.cc>
Date: Sun,  5 Apr 2009 18:39:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tasklets for isochronous data transfer need to run within 8 msec
to avoid over/underruns, so schedule them with high priority to fix
reported issues with occasional over/underruns.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/bas-gigaset.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 831ddce..781c404 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -821,7 +821,7 @@ static void read_iso_callback(struct urb *urb)
 		/* pass URB to tasklet */
 		ubc->isoindone = urb;
 		ubc->isoinstatus = status;
-		tasklet_schedule(&ubc->rcvd_tasklet);
+		tasklet_hi_schedule(&ubc->rcvd_tasklet);
 	} else {
 		/* tasklet still busy, drop data and resubmit URB */
 		ubc->loststatus = status;
@@ -888,7 +888,7 @@ static void write_iso_callback(struct urb *urb)
 	ubc->isooutovfl = ubc->isooutdone;
 	ubc->isooutdone = ucx;
 	spin_unlock_irqrestore(&ubc->isooutlock, flags);
-	tasklet_schedule(&ubc->sent_tasklet);
+	tasklet_hi_schedule(&ubc->sent_tasklet);
 }
 
 /* starturbs
-- 
1.6.2.1.214.ge986c

