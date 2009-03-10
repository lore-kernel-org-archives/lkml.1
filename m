Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZCJUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZCJUCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZCJUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:02:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48127 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbZCJUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:02:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:01:54 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] firewire: cdev: simplify FW_CDEV_IOC_SEND_REQUEST return
 value
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
Message-ID: <tkrat.17de29258b0b7558@s5r6.in-berlin.de>
References: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the ioctl() return value of FW_CDEV_IOC_SEND_REQUEST and of
the as yet unreleased FW_CDEV_IOC_SEND_BROADCAST_REQUEST.  They used to
return
	sizeof(struct fw_cdev_send_request *) + data_length

which is obviously a failed attempt to emulate the return value of
raw1394's respective interface which uses write() instead of ioctl().

However, the first summand, as size of a kernel pointer, is entirely
meaningless to clients and the second summand is already known to
clients.  And the result does not resemble raw1394's write() return
code anyway.

So simplify it to a constant non-negative value, i.e. 0.  The only
dangers here would be that future client implementations check for error
by ret != 0 instead of ret < 0 when running on top of an old kernel; or
that current clients interpret ret = 0 or more as failure.  But both are
hypothetical cases which don't justify to return irritating values.

While we touch this code, also remove "& 0x1f" from tcode in the call of
fw_send_request.  The tcode cannot be bigger than 0x1f at this point.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -549,15 +549,11 @@ static int init_request(struct client *c
 	client_get(client);
 
 	fw_send_request(client->device->card, &e->r.transaction,
-			request->tcode & 0x1f, destination_id,
-			request->generation, speed, request->offset,
-			e->response.data, request->length,
-			complete_transaction, e);
+			request->tcode, destination_id, request->generation,
+			speed, request->offset, e->response.data,
+			request->length, complete_transaction, e);
+	return 0;
 
-	if (request->data)
-		return sizeof(request) + request->length;
-	else
-		return sizeof(request);
  failed:
 	kfree(e);
 

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

