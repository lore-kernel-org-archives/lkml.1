Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbZG0POa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbZG0POa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZG0POa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:14:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60864 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZG0PO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:14:29 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Subject: [PATCH] net/9p: Insulate the client against an invalid error code sent by a 9p server.
Date: Mon, 27 Jul 2009 09:14:22 -0600
Message-Id: <1248707662-4060-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A looney tunes server sending an invalid error code (which is !IS_ERR_VALUE)
can result in a client oops. So fix it by adding a check and converting unknown
or invalid error codes to -ESERVERFAULT.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 787ccdd... c9a5bf9... M	net/9p/client.c
:100644 100644 fdebe43... 5251851... M	net/9p/error.c
 net/9p/client.c |    7 +------
 net/9p/error.c  |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 787ccdd..c9a5bf9 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -411,14 +411,9 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 		if (c->dotu)
 			err = -ecode;
 
-		if (!err) {
+		if (!err || !IS_ERR_VALUE(err))
 			err = p9_errstr2errno(ename, strlen(ename));
 
-			/* string match failed */
-			if (!err)
-				err = -ESERVERFAULT;
-		}
-
 		P9_DPRINTK(P9_DEBUG_9P, "<<< RERROR (%d) %s\n", -ecode, ename);
 
 		kfree(ename);
diff --git a/net/9p/error.c b/net/9p/error.c
index fdebe43..5251851 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -239,7 +239,7 @@ int p9_errstr2errno(char *errstr, int len)
 		errstr[len] = 0;
 		printk(KERN_ERR "%s: server reported unknown error %s\n",
 			__func__, errstr);
-		errno = 1;
+		errno = ESERVERFAULT;
 	}
 
 	return -errno;
-- 
1.6.0.4

