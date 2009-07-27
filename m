Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZG1SrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZG1SrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZG1SrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:47:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:19913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZG1SrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:to:cc;
        b=Cj9OiuZ4C5bgAJd1juxpeHxH0E97K58yFYVzlDvN11+p20uBkSI8W0x/o4ieENBwcA
         18NIrHjUoubLyhEAQDcVzP/5YyJEnzsKtm9Ut4O/7QcyWW1VQcf3kUYBo8zN76NLUL5g
         KAZVEw7ytgpJ3EXCNeoW+n5CT95DY0P+ZAt2w=
Message-Id: <200907281845.n6SIjdjC025315@home.pavel.comp>
From: Paul Fertser <fercerpav@gmail.com>
Date: Tue, 28 Jul 2009 00:58:48 +0400
Subject: [PATCH] pcf50633: revise locking for ADC
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation is prone to races, this patch attempts to remove all
but one (in pcf50633_adc_sync_read).

The idea is that we need to guard the queue access only on inserting and
removing items. If we insert and there're no more items in the queue it
means that the last irq already happened and we need to trigger ADC
manually. If not, then the next conversion will be triggered by the irq
handler upon completion of the previous.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-adc.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index c2d05be..3d31e97 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -73,15 +73,10 @@ static void trigger_next_adc_job_if_any(struct pcf50633 *pcf)
 	struct pcf50633_adc *adc = __to_adc(pcf);
 	int head;
 
-	mutex_lock(&adc->queue_mutex);
-
 	head = adc->queue_head;
 
-	if (!adc->queue[head]) {
-		mutex_unlock(&adc->queue_mutex);
+	if (!adc->queue[head])
 		return;
-	}
-	mutex_unlock(&adc->queue_mutex);
 
 	adc_setup(pcf, adc->queue[head]->mux, adc->queue[head]->avg);
 }
@@ -99,16 +94,17 @@ adc_enqueue_request(struct pcf50633 *pcf, struct pcf50633_adc_request *req)
 
 	if (adc->queue[tail]) {
 		mutex_unlock(&adc->queue_mutex);
+		dev_err(pcf->dev, "ADC queue is full, dropping request\n");
 		return -EBUSY;
 	}
 
 	adc->queue[tail] = req;
+	if (head == tail)
+		trigger_next_adc_job_if_any(pcf);
 	adc->queue_tail = (tail + 1) & (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
 
 	mutex_unlock(&adc->queue_mutex);
 
-	trigger_next_adc_job_if_any(pcf);
-
 	return 0;
 }
 
@@ -124,6 +120,7 @@ pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param, int result)
 int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
 {
 	struct pcf50633_adc_request *req;
+	int err;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
@@ -136,9 +133,13 @@ int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
 	req->callback_param = req;
 
 	init_completion(&req->completion);
-	adc_enqueue_request(pcf, req);
+	err = adc_enqueue_request(pcf, req);
+	if (err)
+		return err;
+
 	wait_for_completion(&req->completion);
 
+	/* FIXME by this time req might be already freed */
 	return req->result;
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_sync_read);
@@ -159,9 +160,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 	req->callback = callback;
 	req->callback_param = callback_param;
 
-	adc_enqueue_request(pcf, req);
-
-	return 0;
+	return adc_enqueue_request(pcf, req);
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
 
@@ -184,7 +183,7 @@ static void pcf50633_adc_irq(int irq, void *data)
 	struct pcf50633_adc *adc = data;
 	struct pcf50633 *pcf = adc->pcf;
 	struct pcf50633_adc_request *req;
-	int head;
+	int head, res;
 
 	mutex_lock(&adc->queue_mutex);
 	head = adc->queue_head;
@@ -199,12 +198,13 @@ static void pcf50633_adc_irq(int irq, void *data)
 	adc->queue_head = (head + 1) &
 				      (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
 
+	res = adc_result(pcf);
+	trigger_next_adc_job_if_any(pcf);
+
 	mutex_unlock(&adc->queue_mutex);
 
-	req->callback(pcf, req->callback_param, adc_result(pcf));
+	req->callback(pcf, req->callback_param, res);
 	kfree(req);
-
-	trigger_next_adc_job_if_any(pcf);
 }
 
 static int __devinit pcf50633_adc_probe(struct platform_device *pdev)
-- 
1.6.0.6

