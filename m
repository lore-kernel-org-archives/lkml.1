Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbYFHJD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbYFHJD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbYFHJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:03:45 -0400
Received: from 1wt.eu ([62.212.114.60]:1561 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbYFHJDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:03:44 -0400
Date: Sun, 8 Jun 2008 11:02:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Missing patch from stable [6/7]
Message-ID: <20080608090227.GF6439@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch from mainline seems suitable for -stable, but was not proposed
for inclusion. I think we should include it for next review unless the
author disagrees.

Thanks,
Willy
--

>From 199f7d24ae59894243687a234a909f44a8724506 Mon Sep 17 00:00:00 2001
From: James Chapman <jchapman@katalix.com>
Date: Wed, 4 Jun 2008 15:07:32 -0700
Subject: lt2p: Fix possible WARN_ON from socket code when UDP socket is closed

If an L2TP daemon closes a tunnel socket while packets are queued in
the tunnel's reorder queue, a kernel warning is logged because the
socket is closed while skbs are still referencing it. The fix is to
purge the queue in the socket's release handler.

WARNING: at include/net/sock.h:351 udp_lib_unhash+0x41/0x68()
Pid: 12998, comm: openl2tpd Not tainted 2.6.25 #8
 [<c0423c58>] warn_on_slowpath+0x41/0x51
 [<c05d33a7>] udp_lib_unhash+0x41/0x68
 [<c059424d>] sk_common_release+0x23/0x90
 [<c05d16be>] udp_lib_close+0x8/0xa
 [<c05d8684>] inet_release+0x42/0x48
 [<c0592599>] sock_release+0x14/0x60
 [<c059299f>] sock_close+0x29/0x30
 [<c046ef52>] __fput+0xad/0x15b
 [<c046f1d9>] fput+0x17/0x19
 [<c046c8c4>] filp_close+0x50/0x5a
 [<c046da06>] sys_close+0x69/0x9f
 [<c04048ce>] syscall_call+0x7/0xb

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/pppol2tp.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index 8db342f..04c7e5b 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -1279,6 +1279,7 @@ out:
 static int pppol2tp_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+	struct pppol2tp_session *session;
 	int error;
 
 	if (!sk)
@@ -1296,9 +1297,18 @@ static int pppol2tp_release(struct socket *sock)
 	sock_orphan(sk);
 	sock->sk = NULL;
 
+	session = pppol2tp_sock_to_session(sk);
+
 	/* Purge any queued data */
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	if (session != NULL) {
+		struct sk_buff *skb;
+		while ((skb = skb_dequeue(&session->reorder_q))) {
+			kfree_skb(skb);
+			sock_put(sk);
+		}
+	}
 
 	release_sock(sk);
 
-- 
1.5.3.8

