Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbXEUTs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbXEUTs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765648AbXEUT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52612 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765868AbXEUT2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:30 -0400
Message-Id: <20070521191730.708428000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Srinivas Aji <Aji_Srinivas@emc.com>
Subject: [patch 36/69] TCP: zero out rx_opt in tcp_disconnect()
Content-Disposition: inline; filename=tcp-zero-out-rx_opt-in-tcp_disconnect.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Srinivas Aji <Aji_Srinivas@emc.com>

When the server drops its connection, NFS client reconnects using the
same socket after disconnecting. If the new connection's SYN,ACK
doesn't contain the TCP timestamp option and the old connection's did,
tp->tcp_header_len is recomputed assuming no timestamp header but
tp->rx_opt.tstamp_ok remains set. Then tcp_build_and_update_options()
adds in a timestamp option past the end of the allocated TCP header,
overwriting TCP data, or when the data is in skb_shinfo(skb)->frags[],
overwriting skb_shinfo(skb) causing a crash soon after. (The issue was
debugged from such a crash.)

Similarly, wscale_ok and sack_ok also get set based on the SYN,ACK
packet but not reset on disconnect, since they are zeroed out at
initialization. The patch zeroes out the entire tp->rx_opt struct in
tcp_disconnect() to avoid this sort of problem.

Signed-off-by: Srinivas Aji <Aji_Srinivas@emc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/tcp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.21.1.orig/net/ipv4/tcp.c
+++ linux-2.6.21.1/net/ipv4/tcp.c
@@ -1759,8 +1759,7 @@ int tcp_disconnect(struct sock *sk, int 
 	tcp_clear_retrans(tp);
 	inet_csk_delack_init(sk);
 	sk->sk_send_head = NULL;
-	tp->rx_opt.saw_tstamp = 0;
-	tcp_sack_reset(&tp->rx_opt);
+	memset(&tp->rx_opt, 0, sizeof(tp->rx_opt));
 	__sk_dst_reset(sk);
 
 	BUG_TRAP(!inet->num || icsk->icsk_bind_hash);

-- 
