Return-Path: <linux-kernel-owner+w=401wt.eu-S1764432AbZBYPXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432AbZBYPXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbZBYPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:51 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51723 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760209AbZBYPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:09:21 -0500
Message-Id: <20090225150837.920755895@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:07:01 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 39/46] qdio: move ACK to newest buffer for devices without QEBSM
Content-Disposition: inline; filename=138-qdio-acks.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

The ACKnowledgement state should be set on the newest SBAL so an
adapter interrupt surpression check needs to scan fewer SBALs.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio_main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: quilt-2.6/drivers/s390/cio/qdio_main.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio_main.c
+++ quilt-2.6/drivers/s390/cio/qdio_main.c
@@ -440,12 +440,16 @@ static inline void inbound_primed(struct
 		/* reset the previous ACK but first set the new one */
 		set_buf_state(q, new, SLSB_P_INPUT_ACK);
 		set_buf_state(q, q->last_move_ftc, SLSB_P_INPUT_NOT_INIT);
-	}
-	else {
+	} else {
 		q->u.in.polling = 1;
-		set_buf_state(q, q->first_to_check, SLSB_P_INPUT_ACK);
+		set_buf_state(q, new, SLSB_P_INPUT_ACK);
 	}
 
+	/*
+	 * last_move_ftc points to the ACK'ed buffer and not to the last turns
+	 * first_to_check like for qebsm. Since it is only used to check if
+	 * the queue front moved in qdio_inbound_q_done this is not a problem.
+	 */
 	q->last_move_ftc = new;
 	count--;
 	if (!count)
@@ -455,7 +459,7 @@ static inline void inbound_primed(struct
 	 * Need to change all PRIMED buffers to NOT_INIT, otherwise
 	 * we're loosing initiative in the thinint code.
 	 */
-	set_buf_states(q, next_buf(q->first_to_check), SLSB_P_INPUT_NOT_INIT,
+	set_buf_states(q, q->first_to_check, SLSB_P_INPUT_NOT_INIT,
 		       count);
 }
 
@@ -1480,7 +1484,6 @@ static void handle_inbound(struct qdio_q
 			if (q->u.in.ack_count <= 0) {
 				q->u.in.polling = 0;
 				q->u.in.ack_count = 0;
-				/* TODO: must we set last_move_ftc to something meaningful? */
 				goto set;
 			}
 			q->last_move_ftc = add_buf(q->last_move_ftc, diff);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

