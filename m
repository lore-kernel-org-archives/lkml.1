Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYJEU1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYJEU1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 16:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYJEU1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 16:27:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39283
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbYJEU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:27:47 -0400
Date: Sun, 05 Oct 2008 13:27:22 -0700 (PDT)
Message-Id: <20081005.132722.203253085.davem@davemloft.net>
To: lkml@pengaru.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080921220926.GA18569@fc6222126.aspadmin.net>
References: <20080921145134.GT2761@fc6222126.aspadmin.net>
	<20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
	<20080921220926.GA18569@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Give this patch a try:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1ab341e..0e43875 100644
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
+		if (target >= tp->rcv_nxt - tp->copied_seq)
 			mask |= POLLIN | POLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
