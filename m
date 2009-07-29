Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZG2Tyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZG2Tyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZG2Tyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:54:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:15357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZG2Tyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:54:36 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RESEND 2/2] net/9p: Insulate the client against an invalid error code sent by a 9p server.
Date: Wed, 29 Jul 2009 13:49:02 -0600
Message-Id: <1248896942-13027-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248896942-13027-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248896942-13027-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A looney tunes server sending an invalid error code (which is !IS_ERR_VALUE)
can result in a client oops. So fix it by adding a check and converting unknown
or invalid error codes to -ESERVERFAULT.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 7bbd2d5... 5bf5f22... M	net/9p/client.c
:100644 100644 fdebe43... 5251851... M	net/9p/error.c
 net/9p/client.c |    7 +------
 net/9p/error.c  |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 7bbd2d5..5bf5f22 100644
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
1.6.3.3

