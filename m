Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYLNSVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYLNSVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLNSVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:21:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35770 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYLNSVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:21:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 19:21:01 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: cdev: address handler input validation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
Message-ID: <tkrat.66d26268247e3280@s5r6.in-berlin.de>
References: <20081124163728.GA5826@redhat.com>
 <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de>
 <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like before my commit 1415d9189e8c59aa9c77a3bba419dcea062c145f,
fw_core_add_address_handler() does not align the address region now.
Instead the caller is required to pass valid parameters.

Since one of the callers of fw_core_add_address_handler() is the cdev
userspace interface, we now check for valid input.  If the client is
buggy, we give it a hint with -EINVAL.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c        |    5 +++--
 drivers/firewire/fw-transaction.c |   27 ++++++++++++++++++---------
 2 files changed, 21 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -591,9 +591,10 @@ static int ioctl_allocate(struct client 
 	handler->closure = request->closure;
 	handler->client = client;
 
-	if (fw_core_add_address_handler(&handler->handler, &region) < 0) {
+	ret = fw_core_add_address_handler(&handler->handler, &region);
+	if (ret < 0) {
 		kfree(handler);
-		return -EBUSY;
+		return ret;
 	}
 
 	handler->resource.release = release_address_handler;
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -449,16 +449,19 @@ const struct fw_address_region fw_unit_s
 #endif  /*  0  */
 
 /**
- * Allocate a range of addresses in the node space of the OHCI
- * controller.  When a request is received that falls within the
- * specified address range, the specified callback is invoked.  The
- * parameters passed to the callback give the details of the
- * particular request.
+ * fw_core_add_address_handler - register for incoming requests
+ * @handler: callback
+ * @region: region in the IEEE 1212 node space address range
+ *
+ * region->start, ->end, and handler->length have to be quadlet-aligned.
+ *
+ * When a request is received that falls within the specified address range,
+ * the specified callback is invoked.  The parameters passed to the callback
+ * give the details of the particular request.
  *
  * Return value:  0 on success, non-zero otherwise.
  * The start offset of the handler's address region is determined by
  * fw_core_add_address_handler() and is returned in handler->offset.
- * The offset is quadlet-aligned.
  */
 int
 fw_core_add_address_handler(struct fw_address_handler *handler,
@@ -468,17 +471,23 @@ fw_core_add_address_handler(struct fw_ad
 	unsigned long flags;
 	int ret = -EBUSY;
 
+	if (region->start & 0xffff000000000003ULL ||
+	    region->end   & 0xffff000000000003ULL ||
+	    region->start >= region->end ||
+	    handler->length & 3 ||
+	    handler->length == 0)
+		return -EINVAL;
+
 	spin_lock_irqsave(&address_handler_lock, flags);
 
-	handler->offset = roundup(region->start, 4);
+	handler->offset = region->start;
 	while (handler->offset + handler->length <= region->end) {
 		other =
 		    lookup_overlapping_address_handler(&address_handler_list,
 						       handler->offset,
 						       handler->length);
 		if (other != NULL) {
-			handler->offset =
-			    roundup(other->offset + other->length, 4);
+			handler->offset += other->length;
 		} else {
 			list_add_tail(&handler->link, &address_handler_list);
 			ret = 0;

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

