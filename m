Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYJFRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYJFRSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYJFRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:18:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35890
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbYJFRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:18:38 -0400
Date: Mon, 06 Oct 2008 10:18:14 -0700 (PDT)
Message-Id: <20081006.101814.193697461.davem@davemloft.net>
To: lkml@pengaru.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081006051718.GA2811@fc6222126.aspadmin.net>
References: <20081005214556.GL18569@fc6222126.aspadmin.net>
	<20081005.153059.111120997.davem@davemloft.net>
	<20081006051718.GA2811@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lkml@pengaru.com
Date: Mon, 6 Oct 2008 00:17:18 -0500

> Looks like the RCVLOWAT patch breaks the tcp poll logic in the normal
> case.

Sorry, the condition was reversed, try this one instead:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1ab341e..7d81a1e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -384,13 +384,17 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 
 	/* Connected? */
 	if ((1 << sk->sk_state) & ~(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
+		int target = sock_rcvlowat(sk, 0, INT_MAX);
+
+		if (tp->urg_seq == tp->copied_seq &&
+		    !sock_flag(sk, SOCK_URGINLINE) &&
+		    tp->urg_data)
+			target--;
+
 		/* Potential race condition. If read of tp below will
 		 * escape above sk->sk_state, we can be illegally awaken
 		 * in SYN_* states. */
-		if ((tp->rcv_nxt != tp->copied_seq) &&
-		    (tp->urg_seq != tp->copied_seq ||
-		     tp->rcv_nxt != tp->copied_seq + 1 ||
-		     sock_flag(sk, SOCK_URGINLINE) || !tp->urg_data))
+		if (tp->rcv_nxt - tp->copied_seq >= target)
 			mask |= POLLIN | POLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
