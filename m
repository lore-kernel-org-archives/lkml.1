Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYHFSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYHFSsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYHFSsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:48:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49656 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbYHFSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:48:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 6 Aug 2008 20:47:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire regression fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.92208df5a924adbe@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a FireWire subsystem fix-for-a-fix.

David Moore (1):
      firewire: Preserve response data alignment bug when it is harmless

 drivers/firewire/fw-cdev.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)



commit 8401d92ba46a1e859464cbd9c9ee304f6e361da3
Author: David Moore <dcm@acm.org>
Date:   Tue Jul 29 23:46:25 2008 -0700

    firewire: Preserve response data alignment bug when it is harmless
    
    Recently, a bug having to do with the alignment of transaction response
    data was fixed.  However, some apps such as libdc1394 relied on the
    presence of that bug in order to function correctly.  In order to stay
    compatible with old versions of those apps, this patch preserves the bug
    in cases where it is harmless to normal operation (such as the single
    quadlet read) due to a simple duplication of data.  This guarantees
    maximum compatability for those users who are using the old app with the
    fixed kernel.
    
    Signed-off-by: David Moore <dcm@acm.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index bc81d6f..2e6d584 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -369,22 +369,33 @@ complete_transaction(struct fw_card *card, int rcode,
 	struct response *response = data;
 	struct client *client = response->client;
 	unsigned long flags;
+	struct fw_cdev_event_response *r = &response->response;
 
-	if (length < response->response.length)
-		response->response.length = length;
+	if (length < r->length)
+		r->length = length;
 	if (rcode == RCODE_COMPLETE)
-		memcpy(response->response.data, payload,
-		       response->response.length);
+		memcpy(r->data, payload, r->length);
 
 	spin_lock_irqsave(&client->lock, flags);
 	list_del(&response->resource.link);
 	spin_unlock_irqrestore(&client->lock, flags);
 
-	response->response.type   = FW_CDEV_EVENT_RESPONSE;
-	response->response.rcode  = rcode;
-	queue_event(client, &response->event, &response->response,
-		    sizeof(response->response) + response->response.length,
-		    NULL, 0);
+	r->type   = FW_CDEV_EVENT_RESPONSE;
+	r->rcode  = rcode;
+
+	/*
+	 * In the case that sizeof(*r) doesn't align with the position of the
+	 * data, and the read is short, preserve an extra copy of the data
+	 * to stay compatible with a pre-2.6.27 bug.  Since the bug is harmless
+	 * for short reads and some apps depended on it, this is both safe
+	 * and prudent for compatibility.
+	 */
+	if (r->length <= sizeof(*r) - offsetof(typeof(*r), data))
+		queue_event(client, &response->event, r, sizeof(*r),
+			    r->data, r->length);
+	else
+		queue_event(client, &response->event, r, sizeof(*r) + r->length,
+			    NULL, 0);
 }
 
 static int ioctl_send_request(struct client *client, void *buffer)


Thanks,
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/

