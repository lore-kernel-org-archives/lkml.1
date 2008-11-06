Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYKFA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYKFA2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYKFA2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:28:09 -0500
Received: from mail.es335.com ([67.65.19.105]:19653 "EHLO mail.es335.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYKFA2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:28:08 -0500
X-Greylist: delayed 1269 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2008 19:28:08 EST
Message-ID: <49123520.9050700@opengridcomputing.com>
Date: Wed, 05 Nov 2008 18:06:56 -0600
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>
CC: linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       Latchesar Ionkov <lionkov@lanl.gov>
Subject: [PATCH] 9pnet: Use list_del_init when removing req_list elements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The p9_req_t structures are reused when tags are reused. For this reason,
the req_list list heads need to be re-initialized when deleted or a
subsequent list_add can corrupt the list and/or BUG_ON if list debug is
enabled.
    
Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
---
 net/9p/trans_fd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 1df0356..fc78336 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -213,7 +213,7 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 	spin_unlock_irqrestore(&m->client->lock, flags);
 
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
-		list_del(&req->req_list);
+		list_del_init(&req->req_list);
 		P9_DPRINTK(P9_DEBUG_ERROR, "call back req %p\n", req);
 		p9_client_cb(m->client, req);
 	}
@@ -361,7 +361,7 @@ static void p9_read_work(struct work_struct *work)
 	if ((m->req) && (m->rpos == m->rsize)) { /* packet is read in */
 		P9_DPRINTK(P9_DEBUG_TRANS, "got new packet\n");
 		spin_lock(&m->client->lock);
-		list_del(&m->req->req_list);
+		list_del_init(&m->req->req_list);
 		spin_unlock(&m->client->lock);
 		p9_client_cb(m->client, m->req);
 
@@ -683,7 +683,7 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 	P9_DPRINTK(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
 	spin_lock(&client->lock);
-	list_del(&req->req_list);
+	list_del_init(&req->req_list);
 
 	if (req->status == REQ_STATUS_UNSENT) {
 		req->status = REQ_STATUS_FLSHD;

