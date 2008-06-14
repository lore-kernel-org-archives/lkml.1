Return-Path: <linux-kernel-owner+w=401wt.eu-S1762986AbYFNAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762986AbYFNAVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbYFNAOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:23 -0400
Received: from mx1.suse.de ([195.135.220.2]:34464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896AbYFNAOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:21 -0400
Date: Fri, 13 Jun 2008 17:11:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 28/47] l2tp: Fix possible WARN_ON from socket code when UDP
	socket is closed
Message-ID: <20080614001137.GB24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="l2tp-fix-possible-warn_on-from-socket-code-when-udp-socket-is-closed.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Chapman <jchapman@katalix.com>

[ upstream commit: 199f7d24ae59894243687a234a909f44a8724506 ]

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/pppol2tp.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -1279,6 +1279,7 @@ out:
 static int pppol2tp_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+	struct pppol2tp_session *session;
 	int error;
 
 	if (!sk)
@@ -1296,9 +1297,18 @@ static int pppol2tp_release(struct socke
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
