Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab0BFXRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 18:17:01 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:61894 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab0BFXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 18:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AKgnXQYbXsRx9yvjU/KVRHQpXeSaIPUCVxYdcWuC3AMFuNIDZwfOMjHgvu57a/4cN5
         h3uA+Zdpg+fO1YH8TQWo6t0/JfyrkP3mOSLk/yKhwoaPJ3XPZhJnQOkBghJbFuxHZwT9
         3zMAOTcREk9wgadaRrYxKZbuWxhOM8O78OnNA=
MIME-Version: 1.0
Date: Sun, 7 Feb 2010 10:16:59 +1100
Message-ID: <d45a3acc1002061516s3b3eab26tc2a9339613684e6f@mail.gmail.com>
Subject: [PATCH 1/2] X25: Fix x25_create errors for bad protocol and ENOBUFS
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
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
@@ -512,15 +512,20 @@ static int x25_create(struct net *net, struct
socket *sock, int protocol,
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
