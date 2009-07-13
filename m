Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZGMNuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZGMNuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZGMNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:50:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39641 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbZGMNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:50:15 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: ericvh@gmail.com, Abhishek Kulkarni <adkulkar@umail.iu.edu>,
       v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] [net/9p] Possible regression in p9_client_stat
Date: Mon, 13 Jul 2009 07:49:50 -0600
Message-Id: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a possible regression with p9_client_stat where it can try to kfree an ERR_PTR
after an erroneous p9pdu_readf. Also remove an unnecessary data buffer increment
in p9_client_read.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 dd43a82... cc25e63... M	net/9p/client.c
 net/9p/client.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index dd43a82..cc25e63 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1098,7 +1098,6 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
 
 	if (data) {
 		memmove(data, dataptr, count);
-		data += count;
 	}
 
 	if (udata) {
@@ -1192,9 +1191,9 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 
 	err = p9pdu_readf(req->rc, clnt->dotu, "wS", &ignored, ret);
 	if (err) {
-		ret = ERR_PTR(err);
 		p9pdu_dump(1, req->rc);
-		goto free_and_error;
+		p9_free_req(clnt, req);
+		goto error;
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P,
@@ -1211,8 +1210,6 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 	p9_free_req(clnt, req);
 	return ret;
 
-free_and_error:
-	p9_free_req(clnt, req);
 error:
 	kfree(ret);
 	return ERR_PTR(err);
-- 
1.6.0.4

