Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYKELh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYKELh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 06:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKELhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 06:37:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59599
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752925AbYKELhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:37:12 -0500
Date: Wed, 05 Nov 2008 03:36:47 -0800 (PST)
Message-Id: <20081105.033647.118893751.davem@davemloft.net>
To: swivel@shells.gnugeneration.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081020035819.GG2811@fc6222126.aspadmin.net>
References: <20081013083214.GN2811@fc6222126.aspadmin.net>
	<20081013.025816.197282812.davem@davemloft.net>
	<20081020035819.GG2811@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: swivel@shells.gnugeneration.com
Date: Sun, 19 Oct 2008 22:58:19 -0500

> From what I can see the recv() MSG_PEEK fix is trivial anyways, why not
> fix it?

Does this patch work for you?

tcp: Fix recvmsg MSG_PEEK influence of blocking behavior.

Vito Caputo noticed that tcp_recvmsg() returns immediately from
partial reads when MSG_PEEK is used.  In particular, this means that
SO_RCVLOWAT is not respected.

Simply remove the test.  And this matches the behavior of several
other systems, including BSD.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index eccb716..c5aca0b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1374,8 +1374,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			    sk->sk_state == TCP_CLOSE ||
 			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 			    !timeo ||
-			    signal_pending(current) ||
-			    (flags & MSG_PEEK))
+			    signal_pending(current))
 				break;
 		} else {
 			if (sock_flag(sk, SOCK_DONE))
-- 
1.5.6.5

