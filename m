Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846Ab0AXPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0AXPpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 10:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0AXPpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 10:45:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0AXPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 10:45:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Jan 2010 16:45:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix use-after-free regression in FCP handler
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <4B5B0CEB.8060707@s5r6.in-berlin.de>
Message-ID: <tkrat.db8567d4fd78a1fe@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
 <tkrat.2eca556d1afddd17@s5r6.in-berlin.de>
 <4B5B0CEB.8060707@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit db5d247a "firewire: fix use of multiple AV/C devices, allow
multiple FCP listeners" introduced a regression into 2.6.33-rc3:
The core freed payloads of incoming requests to FCP_Request or
FCP_Response before a userspace driver accessed them.

We need to copy such payloads for each registered userspace client
and free the copies according to the lifetime rules of non-FCP client
request resources.

(This could possibly be optimized by reference counts instead of
copies.)

The presently only kernelspace driver which listens for FCP requests,
firedtv, was not affected because it already copies FCP frames into an
own buffer before returning to firewire-core's FCP handler dispatcher.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   50 +++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 14 deletions(-)

Index: linux-2.6.32.2/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.32.2.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.32.2/drivers/firewire/core-cdev.c
@@ -35,6 +35,7 @@
 #include <linux/preempt.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
@@ -595,13 +596,20 @@ static int ioctl_send_request(struct cli
 			    client->device->max_speed);
 }
 
+static inline bool is_fcp_request(struct fw_request *request)
+{
+	return request == NULL;
+}
+
 static void release_request(struct client *client,
 			    struct client_resource *resource)
 {
 	struct inbound_transaction_resource *r = container_of(resource,
 			struct inbound_transaction_resource, resource);
 
-	if (r->request)
+	if (is_fcp_request(r->request))
+		kfree(r->data);
+	else
 		fw_send_response(client->device->card, r->request,
 				 RCODE_CONFLICT_ERROR);
 	kfree(r);
@@ -616,6 +624,7 @@ static void handle_request(struct fw_car
 	struct address_handler_resource *handler = callback_data;
 	struct inbound_transaction_resource *r;
 	struct inbound_transaction_event *e;
+	void *fcp_frame = NULL;
 	int ret;
 
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
@@ -627,6 +636,18 @@ static void handle_request(struct fw_car
 	r->data    = payload;
 	r->length  = length;
 
+	if (is_fcp_request(request)) {
+		/*
+		 * FIXME: Let core-transaction.c manage a
+		 * single reference-counted copy?
+		 */
+		fcp_frame = kmemdup(payload, length, GFP_ATOMIC);
+		if (fcp_frame == NULL)
+			goto failed;
+
+		r->data = fcp_frame;
+	}
+
 	r->resource.release = release_request;
 	ret = add_client_resource(handler->client, &r->resource, GFP_ATOMIC);
 	if (ret < 0)
@@ -640,13 +661,15 @@ static void handle_request(struct fw_car
 	e->request.closure = handler->closure;
 
 	queue_event(handler->client, &e->event,
-		    &e->request, sizeof(e->request), payload, length);
+		    &e->request, sizeof(e->request), r->data, length);
 	return;
 
  failed:
 	kfree(r);
 	kfree(e);
-	if (request)
+	kfree(fcp_frame);
+
+	if (!is_fcp_request(request))
 		fw_send_response(card, request, RCODE_CONFLICT_ERROR);
 }
 
@@ -717,18 +740,17 @@ static int ioctl_send_response(struct cl
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (r->request) {
-		if (request->length < r->length)
-			r->length = request->length;
-		if (copy_from_user(r->data, u64_to_uptr(request->data),
-				   r->length)) {
-			ret = -EFAULT;
-			kfree(r->request);
-			goto out;
-		}
-		fw_send_response(client->device->card, r->request,
-				 request->rcode);
+	if (is_fcp_request(r->request))
+		goto out;
+
+	if (request->length < r->length)
+		r->length = request->length;
+	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length)) {
+		ret = -EFAULT;
+		kfree(r->request);
+		goto out;
 	}
+	fw_send_response(client->device->card, r->request, request->rcode);
  out:
 	kfree(r);
 

-- 
Stefan Richter
-=====-==-=- ---= ==---
http://arcgraph.de/sr/

