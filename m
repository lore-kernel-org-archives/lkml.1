Return-Path: <linux-kernel-owner+w=401wt.eu-S933364AbXGSH3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbXGSH3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbXGSH2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:28:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37700 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbXGSH2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:28:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 19 Jul 2007 09:28:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y] firewire: fix memory leak of fw_request instances
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.25648a77ea40c9e3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Tue, 17 Jul 2007 02:15:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fix memory leak of fw_request instances

Found and debugged by Jay Fenlason <fenlason@redhat.com>.
The bug was especially noticeable with direct I/O over fw-sbp2.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---
Same as commit 9c9bdf4d50730fd04b06077e22d7a83b585f26b5.

 drivers/firewire/fw-transaction.c |    4 +++-
 drivers/firewire/fw-transaction.h |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.22/drivers/firewire/fw-transaction.c
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-transaction.c
+++ linux-2.6.22/drivers/firewire/fw-transaction.c
@@ -605,8 +605,10 @@ fw_send_response(struct fw_card *card, s
 	 * check is sufficient to ensure we don't send response to
 	 * broadcast packets or posted writes.
 	 */
-	if (request->ack != ACK_PENDING)
+	if (request->ack != ACK_PENDING) {
+		kfree(request);
 		return;
+	}
 
 	if (rcode == RCODE_COMPLETE)
 		fw_fill_response(&request->response, request->request_header,
Index: linux-2.6.22/drivers/firewire/fw-transaction.h
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-transaction.h
+++ linux-2.6.22/drivers/firewire/fw-transaction.h
@@ -124,6 +124,10 @@ typedef void (*fw_transaction_callback_t
 					  size_t length,
 					  void *callback_data);
 
+/*
+ * Important note:  The callback must guarantee that either fw_send_response()
+ * or kfree() is called on the @request.
+ */
 typedef void (*fw_address_callback_t)(struct fw_card *card,
 				      struct fw_request *request,
 				      int tcode, int destination, int source,

-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/

