Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0BNMGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:06:07 -0500
Received: from mail-px0-f184.google.com ([209.85.216.184]:40337 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0BNMGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:06:04 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Feb 2010 07:06:04 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=n0ibcMi1f4Z5pjs8NMspjVfAv6eyTrLqadHivgxaD0qoqz6Uxz8loN7O+GR82I6OZf
         uKHiBIFWnfijAYjsP3Qk6qa70bLdmmfkPHoNyfdICnq+RZ0UpLx68kc5BIsgRAtnIqrj
         9kEFyJ2W3RN/why2+FnSz6ntdexu5m4qSeXxM=
Subject: [PATCH 1/2] X25: Fix x25_create errors for bad protocol and ENOBUFS
From: Andrew Hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 23:00:11 +1100
Message-ID: <1266148811.4731.43.camel@ibex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_socket failures should return -ENOBUFS
a bad protocol should return -EINVAL

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

---
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index e3219e4..6c7104e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -512,15 +512,20 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 {
 	struct sock *sk;
 	struct x25_sock *x25;
-	int rc = -ESOCKTNOSUPPORT;
+	int rc = -EAFNOSUPPORT;
 
 	if (!net_eq(net, &init_net))
-		return -EAFNOSUPPORT;
+		goto out;
+
+	rc = -ESOCKTNOSUPPORT;
+	if (sock->type != SOCK_SEQPACKET)
+		goto out;
 
-	if (sock->type != SOCK_SEQPACKET || protocol)
+	rc = -EINVAL;
+	if (protocol)
 		goto out;
 
-	rc = -ENOMEM;
+	rc = -ENOBUFS;
 	if ((sk = x25_alloc_socket(net)) == NULL)
 		goto out;
 
-- 
1.6.3.3



