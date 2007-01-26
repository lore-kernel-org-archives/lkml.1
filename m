Return-Path: <linux-kernel-owner+w=401wt.eu-S1030814AbXAZQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814AbXAZQuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXAZQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:49:48 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25508 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030852AbXAZQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:49:16 -0500
Date: Fri, 26 Jan 2007 17:49:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com
Subject: [S390] sclp: invalid handling of temporary 'not operational' status
Message-ID: <20070126164908.GH11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

[S390] sclp: invalid handling of temporary 'not operational' status

Requests are aborted when the sclp interface reports 'not operational'
even though they may still be active at the sclp, leading to concurrent
writes to request memory by both the kernel and the sclp interface.
Do not abort requests for which the sclp interface reports not
operational status during request retry.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>5A
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp.c |   70 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 21 deletions(-)

diff -urpN linux-2.6/drivers/s390/char/sclp.c linux-2.6-patched/drivers/s390/char/sclp.c
--- linux-2.6/drivers/s390/char/sclp.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp.c	2007-01-26 17:27:53.000000000 +0100
@@ -59,7 +59,8 @@ static volatile enum sclp_init_state_t {
 /* Internal state: is a request active at the sclp? */
 static volatile enum sclp_running_state_t {
 	sclp_running_state_idle,
-	sclp_running_state_running
+	sclp_running_state_running,
+	sclp_running_state_reset_pending
 } sclp_running_state = sclp_running_state_idle;
 
 /* Internal state: is a read request pending? */
@@ -88,7 +89,7 @@ static volatile enum sclp_mask_state_t {
 
 /* Timeout intervals in seconds.*/
 #define SCLP_BUSY_INTERVAL	10
-#define SCLP_RETRY_INTERVAL	15
+#define SCLP_RETRY_INTERVAL	30
 
 static void sclp_process_queue(void);
 static int sclp_init_mask(int calculate);
@@ -113,19 +114,17 @@ service_call(sclp_cmdw_t command, void *
 	return 0;
 }
 
-/* Request timeout handler. Restart the request queue. If DATA is non-zero,
- * force restart of running request. */
+static inline void __sclp_make_read_req(void);
+
 static void
-sclp_request_timeout(unsigned long data)
+__sclp_queue_read_req(void)
 {
-	unsigned long flags;
-
-	if (data) {
-		spin_lock_irqsave(&sclp_lock, flags);
-		sclp_running_state = sclp_running_state_idle;
-		spin_unlock_irqrestore(&sclp_lock, flags);
+	if (sclp_reading_state == sclp_reading_state_idle) {
+		sclp_reading_state = sclp_reading_state_reading;
+		__sclp_make_read_req();
+		/* Add request to head of queue */
+		list_add(&sclp_read_req.list, &sclp_req_queue);
 	}
-	sclp_process_queue();
 }
 
 /* Set up request retry timer. Called while sclp_lock is locked. */
@@ -140,6 +139,29 @@ __sclp_set_request_timer(unsigned long t
 	add_timer(&sclp_request_timer);
 }
 
+/* Request timeout handler. Restart the request queue. If DATA is non-zero,
+ * force restart of running request. */
+static void
+sclp_request_timeout(unsigned long data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sclp_lock, flags);
+	if (data) {
+		if (sclp_running_state == sclp_running_state_running) {
+			/* Break running state and queue NOP read event request
+			 * to get a defined interface state. */
+			__sclp_queue_read_req();
+			sclp_running_state = sclp_running_state_idle;
+		}
+	} else {
+		__sclp_set_request_timer(SCLP_BUSY_INTERVAL * HZ,
+					 sclp_request_timeout, 0);
+	}
+	spin_unlock_irqrestore(&sclp_lock, flags);
+	sclp_process_queue();
+}
+
 /* Try to start a request. Return zero if the request was successfully
  * started or if it will be started at a later time. Return non-zero otherwise.
  * Called while sclp_lock is locked. */
@@ -191,7 +213,15 @@ sclp_process_queue(void)
 		rc = __sclp_start_request(req);
 		if (rc == 0)
 			break;
-		/* Request failed. */
+		/* Request failed */
+		if (req->start_count > 1) {
+			/* Cannot abort already submitted request - could still
+			 * be active at the SCLP */
+			__sclp_set_request_timer(SCLP_BUSY_INTERVAL * HZ,
+						 sclp_request_timeout, 0);
+			break;
+		}
+		/* Post-processing for aborted request */
 		list_del(&req->list);
 		if (req->callback) {
 			spin_unlock_irqrestore(&sclp_lock, flags);
@@ -221,7 +251,8 @@ sclp_add_request(struct sclp_req *req)
 	list_add_tail(&req->list, &sclp_req_queue);
 	rc = 0;
 	/* Start if request is first in list */
-	if (req->list.prev == &sclp_req_queue) {
+	if (sclp_running_state == sclp_running_state_idle &&
+	    req->list.prev == &sclp_req_queue) {
 		rc = __sclp_start_request(req);
 		if (rc)
 			list_del(&req->list);
@@ -334,6 +365,8 @@ sclp_interrupt_handler(__u16 code)
 	finished_sccb = S390_lowcore.ext_params & 0xfffffff8;
 	evbuf_pending = S390_lowcore.ext_params & 0x3;
 	if (finished_sccb) {
+		del_timer(&sclp_request_timer);
+		sclp_running_state = sclp_running_state_reset_pending;
 		req = __sclp_find_req(finished_sccb);
 		if (req) {
 			/* Request post-processing */
@@ -348,13 +381,8 @@ sclp_interrupt_handler(__u16 code)
 		sclp_running_state = sclp_running_state_idle;
 	}
 	if (evbuf_pending && sclp_receive_mask != 0 &&
-	    sclp_reading_state == sclp_reading_state_idle &&
-	    sclp_activation_state == sclp_activation_state_active ) {
-		sclp_reading_state = sclp_reading_state_reading;
-		__sclp_make_read_req();
-		/* Add request to head of queue */
-		list_add(&sclp_read_req.list, &sclp_req_queue);
-	}
+	    sclp_activation_state == sclp_activation_state_active)
+		__sclp_queue_read_req();
 	spin_unlock(&sclp_lock);
 	sclp_process_queue();
 }
