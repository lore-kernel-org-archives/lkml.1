Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYIWVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYIWVu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYIWVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:50:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:47902 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYIWVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TrKE/KgTJUwxJWotXvApVaBeJJWJQtkBlyTHO6EiNQLatbebYjLSgq4OoXd4aAllQS
         2nXVF34VFPg9kq2CJkYorZnzqumBrT+DIRcY7pJynBcRPAx3cymoOvpXrYRuKCERcQOY
         B/rST1SPRqJRhWMgsiNyRbnxd4jrc59Xj9AIs=
Message-ID: <a4e6962a0809231450p1f0a7469i6f40c1159181f7f@mail.gmail.com>
Date: Tue, 23 Sep 2008 16:50:45 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Abhishek Kulkarni" <kulkarni@lanl.gov>
Subject: [PATCH] 9p: fix put_data error handling
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Kulkarni pointed out an inconsistency in the way
errors are returned from p9_put_data.  On deeper exploration it
seems the error handling for this path was completely wrong.
This patch adds checks for allocation problems and propagates
errors correctly.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/conv.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/9p/conv.c b/net/9p/conv.c
index 4454720..5ad3a3b 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -451,8 +451,10 @@ p9_put_data(struct cbuf *bufp, const char *data, int count,
                   unsigned char **pdata)
 {
        *pdata = buf_alloc(bufp, count);
+       if (*pdata == NULL)
+               return -ENOMEM;
        memmove(*pdata, data, count);
-       return count;
+       return 0;
 }

 static int
@@ -460,6 +462,8 @@ p9_put_user_data(struct cbuf *bufp, const char
__user *data, int count,
                   unsigned char **pdata)
 {
        *pdata = buf_alloc(bufp, count);
+       if (*pdata == NULL)
+               return -ENOMEM;
        return copy_from_user(*pdata, data, count);
 }

--
1.5.4.3
