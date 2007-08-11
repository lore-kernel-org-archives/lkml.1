Return-Path: <linux-kernel-owner+w=401wt.eu-S1765568AbXHKTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765568AbXHKTEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbXHKS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:30 -0400
Received: from 1wt.eu ([62.212.114.60]:1576 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762604AbXHKS62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:28 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184851.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:16 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 24/28] saa7134: fix thread shutdown handling
Content-Disposition: inline; filename=0024-saa7134-fix-thread-shutdown-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the test for the thread pid from >= 0 to > 0.

When the saa7134 driver initialization fails after a certain point, it goes
through the complete shutdown process for the driver.  Part of shutting it
down includes tearing down the thread for tv audio.

The test for tearing down the thread tests for >= 0.  Since the dev
structure is kzalloc'd, the test will always be true if we haven't tried to
start the thread yet.  We end up waiting on pid 0 to complete, which will
never happen, so we lock up.

This bug was observed in Novell Bugzilla 284718, when request_irq() failed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index dd759d6..36b3fa3 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -1006,7 +1006,7 @@ int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
 	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
+	if (dev->thread.pid > 0) {
 		dev->thread.shutdown = 1;
 		wake_up_interruptible(&dev->thread.wq);
 		wait_for_completion(&dev->thread.exit);
-- 
1.5.2.4

-- 
