Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYCOX5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYCOX5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYCOX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:57:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49791 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYCOX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:57:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 16 Mar 2008 00:56:41 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix panic in handle_at_packet
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Jarod Wilson <jwilson@redhat.com>
Message-ID: <tkrat.098225020c179827@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a use-after-free bug in the handling of split transactions.
The AT DMA handler of the request was occasionally executed after the
AR DMA handler of the response.  The AT DMA handler then accessed an
already freed packet.

Reported by Johannes Berg <johannes@sipsolutions.net>.
http://bugzilla.kernel.org/show_bug.cgi?id=9617

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -737,6 +737,12 @@ fw_core_handle_response(struct fw_card *
 		break;
 	}
 
+	/*
+	 * The response handler may be executed while the request handler
+	 * is still pending.  Cancel the request handler.
+	 */
+	card->driver->cancel_packet(card, &t->packet);
+
 	t->callback(card, rcode, data, data_length, t->callback_data);
 }
 EXPORT_SYMBOL(fw_core_handle_response);

-- 
Stefan Richter
-=====-==--- --== =----
http://arcgraph.de/sr/

