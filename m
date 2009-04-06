Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZDFQMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZDFQMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZDFQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59741 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752411AbZDFQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:16 -0400
Message-Id: <20090406161014.083929000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:17 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 08/13] GRU - fix handling of mesq failures
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_mesq_fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix endcase in handling GRU message queue failures due to NACKs
of PUT requests. Must ensure that the "present" bits are cleared
before resending the message.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-03-07 16:00:29.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-03-11 10:16:34.000000000 -0500
@@ -503,6 +503,29 @@ static void send_message_queue_interrupt
 				mqd->interrupt_vector);
 }
 
+/*
+ * Handle a PUT failure. Note: if message was a 2-line message, one of the
+ * lines might have successfully have been written. Before sending the
+ * message, "present" must be cleared in BOTH lines to prevent the receiver
+ * from prematurely seeing the full message.
+ */
+static int send_message_put_nacked(void *cb, struct gru_message_queue_desc *mqd,
+			void *mesg, int lines)
+{
+	unsigned long m;
+
+	m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
+	if (lines == 2) {
+		gru_vset(cb, m, 0, XTYPE_CL, lines, 1, IMA);
+		if (gru_wait(cb) != CBS_IDLE)
+			return MQE_UNEXPECTED_CB_ERR;
+	}
+	gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
+	if (gru_wait(cb) != CBS_IDLE)
+		return MQE_UNEXPECTED_CB_ERR;
+	send_message_queue_interrupt(mqd);
+	return MQE_OK;
+}
 
 /*
  * Handle a gru_mesq failure. Some of these failures are software recoverable
@@ -512,7 +535,6 @@ static int send_message_failure(void *cb
 				void *mesg, int lines)
 {
 	int substatus, ret = 0;
-	unsigned long m;
 
 	substatus = gru_get_cb_message_queue_substatus(cb);
 	switch (substatus) {
@@ -534,14 +556,7 @@ static int send_message_failure(void *cb
 		break;
 	case CBSS_PUT_NACKED:
 		STAT(mesq_send_put_nacked);
-		m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
-		gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
-		if (gru_wait(cb) == CBS_IDLE) {
-			ret = MQE_OK;
-			send_message_queue_interrupt(mqd);
-		} else {
-			ret = MQE_UNEXPECTED_CB_ERR;
-		}
+		ret = send_message_put_nacked(cb, mqd, mesg, lines);
 		break;
 	default:
 		BUG();

