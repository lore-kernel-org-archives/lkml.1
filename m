Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbYAFPwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbYAFPwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYAFPvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:51:53 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39775 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYAFPvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:51:52 -0500
Date: Sun, 6 Jan 2008 16:51:45 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: marcel@holtmann.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] /net/bluetooth: Use sockfd_put
Message-ID: <Pine.LNX.4.64.0801061650370.24950@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function sockfd_lookup uses fget on the value that is stored in the
file field of the returned structure, so fput should ultimately be applied
to this value.  This can be done directly, but it seems better to use the
specific macro sockfd_put, which does the same thing.


The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression s;
@@

   s = sockfd_lookup(...)
   ...
+  sockfd_put(s);
?- fput(s->file);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
--- a/net/bluetooth/bnep/sock.c 2007-11-08 08:00:52.000000000 +0100
+++ b/net/bluetooth/bnep/sock.c 2008-01-06 11:35:17.000000000 +0100
@@ -94,7 +94,7 @@ static int bnep_sock_ioctl(struct socket
 			return err;
 
 		if (nsock->sk->sk_state != BT_CONNECTED) {
-			fput(nsock->file);
+			sockfd_put(nsock);
 			return -EBADFD;
 		}
 
@@ -103,7 +103,7 @@ static int bnep_sock_ioctl(struct socket
 			if (copy_to_user(argp, &ca, sizeof(ca)))
 				err = -EFAULT;
 		} else
-			fput(nsock->file);
+			sockfd_put(nsock);
 
 		return err;
 
diff -u -p a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
--- a/net/bluetooth/cmtp/sock.c 2007-11-08 08:00:52.000000000 +0100
+++ b/net/bluetooth/cmtp/sock.c 2008-01-06 11:35:17.000000000 +0100
@@ -88,7 +88,7 @@ static int cmtp_sock_ioctl(struct socket
 			return err;
 
 		if (nsock->sk->sk_state != BT_CONNECTED) {
-			fput(nsock->file);
+			sockfd_put(nsock);
 			return -EBADFD;
 		}
 
@@ -97,7 +97,7 @@ static int cmtp_sock_ioctl(struct socket
 			if (copy_to_user(argp, &ca, sizeof(ca)))
 				err = -EFAULT;
 		} else
-			fput(nsock->file);
+			sockfd_put(nsock);
 
 		return err;
 
diff -u -p a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
--- a/net/bluetooth/hidp/sock.c 2007-11-08 08:00:52.000000000 +0100
+++ b/net/bluetooth/hidp/sock.c 2008-01-06 11:35:18.000000000 +0100
@@ -86,13 +86,13 @@ static int hidp_sock_ioctl(struct socket
 
 		isock = sockfd_lookup(ca.intr_sock, &err);
 		if (!isock) {
-			fput(csock->file);
+			sockfd_put(csock);
 			return err;
 		}
 
 		if (csock->sk->sk_state != BT_CONNECTED || isock->sk->sk_state != BT_CONNECTED) {
-			fput(csock->file);
-			fput(isock->file);
+			sockfd_put(csock);
+			sockfd_put(isock);
 			return -EBADFD;
 		}
 
@@ -101,8 +101,8 @@ static int hidp_sock_ioctl(struct socket
 			if (copy_to_user(argp, &ca, sizeof(ca)))
 				err = -EFAULT;
 		} else {
-			fput(csock->file);
-			fput(isock->file);
+			sockfd_put(csock);
+			sockfd_put(isock);
 		}
 
 		return err;
