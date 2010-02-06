Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab0BFXRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 18:17:20 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:61894 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab0BFXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 18:17:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gmjHHneARsL8cPCgqywXUa2qiVUPLalNxcusY0/NS8aT8BfTdHh31oZsSF/U2jHaEO
         MWmR3DjRc5JSS0Xe135D4mA/Mf37DGa9UF3btlnY3U6hJGNTzlaaxWNz1os4yRx6E6ql
         5JKhkmKVZnaV3xdsoPCX9Z6QFYahfanQ/jj2s=
MIME-Version: 1.0
Date: Sun, 7 Feb 2010 10:17:07 +1100
Message-ID: <d45a3acc1002061517k2f702b73ja937728f47abea43@mail.gmail.com>
Subject: [PATCH 2/2] X25: Dont let x25_bind use addresses containing 
	characters
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses should be all digits. Stops x25_bind using addresses
containing characters.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

---
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 6c7104e..8cc7583 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -55,6 +55,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/compat.h>
+#include <linux/ctype.h>

 #include <net/x25.h>
 #include <net/compat.h>
@@ -648,7 +649,7 @@ static int x25_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
 	struct sockaddr_x25 *addr = (struct sockaddr_x25 *)uaddr;
-	int rc = 0;
+	int len, i, rc = 0;

 	lock_kernel();
 	if (!sock_flag(sk, SOCK_ZAPPED) ||
@@ -658,6 +659,14 @@ static int x25_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)
 		goto out;
 	}

+	len = strlen(addr->sx25_addr.x25_addr);
+	for (i = 0; i < len; i++) {
+		if (!isdigit(addr->sx25_addr.x25_addr[i])) {
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
 	x25_sk(sk)->source_addr = addr->sx25_addr;
 	x25_insert_socket(sk);
 	sock_reset_flag(sk, SOCK_ZAPPED);
-- 
1.6.3.3
