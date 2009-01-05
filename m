Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZAET2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZAET2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZAET2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:28:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50192 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZAET2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:28:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 5 Jan 2009 20:28:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: shut down iso context before freeing the
 buffer
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.28a059519eb6d782@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA must be halted before we DMA-unmap and free the DMA buffer.  Since
we cannot rely on the client to stop the context before it closes the
fd, we have to reorder fw_iso_buffer_destroy vs. fw_iso_context_destroy.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1386,12 +1386,12 @@ static int fw_device_op_release(struct i
 	list_del(&client->link);
 	mutex_unlock(&client->device->client_list_mutex);
 
-	if (client->buffer.pages)
-		fw_iso_buffer_destroy(&client->buffer, client->device->card);
-
 	if (client->iso_context)
 		fw_iso_context_destroy(client->iso_context);
 
+	if (client->buffer.pages)
+		fw_iso_buffer_destroy(&client->buffer, client->device->card);
+
 	/* Freeze client->resource_idr and client->event_list */
 	spin_lock_irq(&client->lock);
 	client->in_shutdown = true;

-- 
Stefan Richter
-=====-==--= ---= --=-=
http://arcgraph.de/sr/

