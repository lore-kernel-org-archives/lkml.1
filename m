Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZGCQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZGCQZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbZGCQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:25:07 -0400
Received: from mail.atmel.fr ([81.80.104.162]:44158 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZGCQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:25:06 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, haavard.skinnemoen@atmel.com
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: [PATCH] dmaengine: dmatest: add a maximum number of test iterations
Date: Fri,  3 Jul 2009 19:26:51 +0200
Message-Id: <1246642011-21749-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Message-Id: <448c4e65b62b87188ff0beb21133b60435b1f6bd.1246641180.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmatest usually waits for the killing of its kthreads to stop
running tests.  This patch adds a parameter that sets a maximum
number of test iterations.

This feature is quite interesting for debugging when you set a lot of
traces in your dmaengine controller driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/dmatest.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index fb7da51..0131a1f 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -38,6 +38,11 @@ module_param(max_channels, uint, S_IRUGO);
 MODULE_PARM_DESC(max_channels,
 		"Maximum number of channels to use (default: all)");
 
+static unsigned int iteration_nbr = 0;
+module_param(iteration_nbr, uint, S_IRUGO);
+MODULE_PARM_DESC(iteration_nbr,
+		"Iteration number before stopping test (default: infinite)");
+
 static unsigned int xor_sources = 3;
 module_param(xor_sources, uint, S_IRUGO);
 MODULE_PARM_DESC(xor_sources,
@@ -270,7 +275,8 @@ static int dmatest_func(void *data)
 
 	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT;
 
-	while (!kthread_should_stop()) {
+	while (!kthread_should_stop()
+	       && !(iteration_nbr && total_tests >= iteration_nbr)) {
 		struct dma_device *dev = chan->device;
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
@@ -416,6 +422,13 @@ err_srcbuf:
 err_srcs:
 	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
 			thread_name, total_tests, failed_tests, ret);
+
+	if (iteration_nbr > 0)
+		while (!kthread_should_stop()) {
+			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			interruptible_sleep_on(&wait_dmatest_exit);
+		}
+
 	return ret;
 }
 
-- 
1.5.3.7

