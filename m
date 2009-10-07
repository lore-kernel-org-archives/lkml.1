Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZJGWlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZJGWlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZJGWlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:41:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44044 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZJGWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:41:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:39:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/8] firewire: cdev: fix memory leak in an error path
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.664e56598bafd4ac@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If copy_from_user in an FW_CDEV_IOC_SEND_RESPONSE ioctl failed, an
inbound_transaction_resource instance is no longer referenced and needs
to be freed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.31/drivers/firewire/core-cdev.c
@@ -698,6 +698,7 @@ static int ioctl_send_response(struct cl
 	struct fw_cdev_send_response *request = buffer;
 	struct client_resource *resource;
 	struct inbound_transaction_resource *r;
+	int ret = 0;
 
 	if (release_client_resource(client, request->handle,
 				    release_request, &resource) < 0)
@@ -707,13 +708,17 @@ static int ioctl_send_response(struct cl
 			 resource);
 	if (request->length < r->length)
 		r->length = request->length;
-	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length))
-		return -EFAULT;
+
+	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length)) {
+		ret = -EFAULT;
+		goto out;
+	}
 
 	fw_send_response(client->device->card, r->request, request->rcode);
+ out:
 	kfree(r);
 
-	return 0;
+	return ret;
 }
 
 static int ioctl_initiate_bus_reset(struct client *client, void *buffer)

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

