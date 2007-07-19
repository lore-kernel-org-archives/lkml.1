Return-Path: <linux-kernel-owner+w=401wt.eu-S937968AbXGSJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937968AbXGSJfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbXGSJfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:35:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:26275 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbXGSJfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mycB7EMYtGLPc+Exx2dexl2zqMoq3HtGHc02yAUeFaFkOFexKGcKG5UTMfRPyoTI2A2AKZYZ/uweGIegd9dAlB8XbSiMhISN+fGKS4c3zXdN5q8thLfG+BvisL9RkNFwBN3Bg3yv2csC1gjuej6zQxQMImAVbHD/qqdJWZ49N2o=
From: Denis Cheng <crquan@gmail.com>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Steven Whitehouse <steve@chygwyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denis Cheng <crquan@gmail.com>
Subject: [PATCH 2/2] nbd: change a parameter's type to remove a memcpy call
Date: Thu, 19 Jul 2007 17:34:31 +0800
Message-Id: <11848377013773-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848376711601-git-send-email-crquan@gmail.com>
References: <11848376711601-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this memcpy looks so strange, in fact it's merely a pointer dereference,
so I change the parameter's type to refer it more directly,
this could make the memcpy not needed anymore.

in the function nbd_read_stat where nbd_find_request is only once called,
the parameter served should be transformed accordingly.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/block/nbd.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 86639c0..a4d8508 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -235,14 +235,11 @@ error_out:
 	return 1;
 }
 
-static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
+static struct request *nbd_find_request(struct nbd_device *lo, struct request *xreq)
 {
 	struct request *req, *n;
-	struct request *xreq;
 	int err;
 
-	memcpy(&xreq, handle, sizeof(xreq));
-
 	err = wait_event_interruptible(lo->active_wq, lo->active_req != xreq);
 	if (unlikely(err))
 		goto out;
@@ -297,7 +294,7 @@ static struct request *nbd_read_stat(struct nbd_device *lo)
 		goto harderror;
 	}
 
-	req = nbd_find_request(lo, reply.handle);
+	req = nbd_find_request(lo, *(struct request **)reply.handle);
 	if (unlikely(IS_ERR(req))) {
 		result = PTR_ERR(req);
 		if (result != -ENOENT)
-- 
1.5.2.2

