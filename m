Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXDPLex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXDPLex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXDPLex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:34:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36388 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXDPLew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:34:52 -0400
Message-ID: <46236082.3000101@sw.ru>
Date: Mon, 16 Apr 2007 15:39:46 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Don't attach callback to a going-away netlink socket
Content-Type: multipart/mixed;
 boundary="------------090809030000090201070201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090809030000090201070201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

From: Denis Lunev <den@openvz.org>

There is a race between netlink_dump_start() and netlink_release()
that can lead to the situation when a netlink socket with non-zero
callback is freed.

--------------090809030000090201070201
Content-Type: text/plain;
 name="diff-netlink-dont-dump-in-dead-socket"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-netlink-dont-dump-in-dead-socket"

--- a/net/netlink/af_netlink.c	2004-10-25 12:12:23.000000000 +0400
+++ b/net/netlink/af_netlink.c	2004-10-28 16:26:12.000000000 +0400
@@ -255,6 +255,7 @@ static int netlink_release(struct socket
 		return 0;
 
 	netlink_remove(sk);
+	sock_orphan(sk);
 	nlk = nlk_sk(sk);
 
 	spin_lock(&nlk->cb_lock);
@@ -269,7 +270,6 @@ static int netlink_release(struct socket
 	/* OK. Socket is unlinked, and, therefore,
 	   no new packets will arrive */
 
-	sock_orphan(sk);
 	sock->sk = NULL;
 	wake_up_interruptible_all(&nlk->wait);
 
@@ -942,9 +942,9 @@ int netlink_dump_start(struct sock *ssk,
 		return -ECONNREFUSED;
 	}
 	nlk = nlk_sk(sk);
-	/* A dump is in progress... */
+	/* A dump or destruction is in progress... */
 	spin_lock(&nlk->cb_lock);
-	if (nlk->cb) {
+	if (nlk->cb || sock_flag(sk, SOCK_DEAD)) {
 		spin_unlock(&nlk->cb_lock);
 		netlink_destroy_callback(cb);
 		sock_put(sk);

--------------090809030000090201070201--
