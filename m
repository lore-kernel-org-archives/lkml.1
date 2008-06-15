Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYFOOBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYFOOBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbYFOOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:01:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39863 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757561AbYFOOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:00:14 -0400
Message-Id: <20080615140012.487188841@attica.americas.sgi.com>
References: <20080615135906.091354918@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jun 2008 08:59:10 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 04/13] GRU Driver V2 - kernel services header files
Content-Disposition: inline; filename=gru_services_header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the header file used to export GRU services to other
kernel drivers such as XPMEM or XPNET.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukservices.h |  130 ++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

Index: linux/drivers/misc/sgi-gru/grukservices.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/misc/sgi-gru/grukservices.h	2008-06-14 18:51:47.450820295 -0500
@@ -0,0 +1,130 @@
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
+ * Send a message to a message queue
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
+#define MQE_PAGE_OVERFLOW	3	/* queue overflowed a page */
+#define MQE_UNEXPECTED_CB_ERR	4	/* unexpected CB error */
+#define MQE_BUG_NO_RESOURCES	10	/* BUG - could not alloc GRU cb/dsr */
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
