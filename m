Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYGCVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYGCVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYGCVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50745 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754161AbYGCVgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:33 -0400
Message-Id: <20080703213632.088730973@attica.americas.sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 16:33:52 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 04/13] GRU Driver V3 -  kernel services header files
Content-Disposition: inline; filename=gru_services_header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the header file used to export GRU services to other
kernel drivers such as XPMEM or XPNET.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.h |  134 ++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

Index: linux-2.6.26-rc8/drivers/misc/sgi-gru/grukservices.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc8/drivers/misc/sgi-gru/grukservices.h	2008-07-03 16:16:28.000000000 -0500
@@ -0,0 +1,134 @@
+
+/*
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+#ifndef __GRU_KSERVICES_H_
+#define __GRU_KSERVICES_H_
+
+
+/*
+ * Message queues using the GRU to send/receive messages.
+ *
+ * These function allow the user to create a message queue for
+ * sending/receiving 1 or 2 cacheline messages using the GRU.
+ *
+ * Processes SENDING messages will use a kernel CBR/DSR to send
+ * the message. This is transparent to the caller.
+ *
+ * The receiver does not use any GRU resources.
+ *
+ * The functions support:
+ * 	- single receiver
+ * 	- multiple senders
+ *	- cross partition message
+ *
+ * Missing features ZZZ:
+ * 	- user options for dealing with timeouts, queue full, etc.
+ * 	- gru_create_message_queue() needs interrupt vector info
+ */
+
+/*
+ * Initialize a user allocated chunk of memory to be used as
+ * a message queue. The caller must ensure that the queue is
+ * in contiguous physical memory and is cacheline aligned.
+ *
+ * Message queue size is the total number of bytes allocated
+ * to the queue including a 2 cacheline header that is used
+ * to manage the queue.
+ *
+ *  Input:
+ * 	p	pointer to user allocated memory.
+ * 	bytes	size of message queue in bytes
+ *
+ *  Errors:
+ *  	0	OK
+ *  	>0	error
+ */
+extern int gru_create_message_queue(void *p, unsigned int bytes);
+
+/*
+ * Send a message to a message queue.
+ *
+ * Note: The message queue transport mechanism uses the first 32
+ * bits of the message. Users should avoid using these bits.
+ *
+ *
+ *   Input:
+ * 	xmq	message queue - must be a UV global physical address
+ * 	mesg	pointer to message. Must be 64-bit aligned
+ * 	bytes	size of message in bytes
+ *
+ *   Output:
+ *      0	message sent
+ *     >0	Send failure - see error codes below
+ *
+ */
+extern int gru_send_message_gpa(unsigned long mq_gpa, void *mesg,
+						unsigned int bytes);
+
+/* Status values for gru_send_message() */
+#define MQE_OK			0	/* message sent successfully */
+#define MQE_CONGESTION		1	/* temporary congestion, try again */
+#define MQE_QUEUE_FULL		2	/* queue is full */
+#define MQE_UNEXPECTED_CB_ERR	3	/* unexpected CB error */
+#define MQE_PAGE_OVERFLOW	10	/* BUG - queue overflowed a page */
+#define MQE_BUG_NO_RESOURCES	11	/* BUG - could not alloc GRU cb/dsr */
+
+/*
+ * Advance the receive pointer for the message queue to the next message.
+ * Note: current API requires messages to be gotten & freed in order. Future
+ * API extensions may allow for out-of-order freeing.
+ *
+ *   Input
+ * 	mq	message queue
+ * 	mesq	message being freed
+ */
+extern void gru_free_message(void *mq, void *mesq);
+
+/*
+ * Get next message from message queue. Returns pointer to
+ * message OR NULL if no message present.
+ * User must call gru_free_message() after message is processed
+ * in order to move the queue pointers to next message.
+ *
+ *   Input
+ * 	mq	message queue
+ *
+ *   Output:
+ *	p	pointer to message
+ *	NULL	no message available
+ */
+extern void *gru_get_next_message(void *mq);
+
+
+/*
+ * Copy data using the GRU. Source or destination can be located in a remote
+ * partition.
+ *
+ *    Input:
+ *    	dest_gpa	destination global physical address
+ *    	src_gpa		source global physical address
+ *    	bytes		number of bytes to copy
+ *
+ *    Output:
+ *	0		OK
+ *	>0		error
+ */
+extern int gru_copy_gpa(unsigned long dest_gpa, unsigned long src_gpa,
+							unsigned int bytes);
+
+#endif 		/* __GRU_KSERVICES_H_ */

-- 
