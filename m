Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbXJMOqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbXJMOqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761669AbXJMOmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2956 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761609AbXJMOmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:21 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143451.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:33 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 11/35] TCP: Fix TCP rate-halving on bidirectional flows.
Content-Disposition: inline; filename=0039-TCP-Fix-TCP-rate-halving-on-bidirectional-flows.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, the ratehalving seems to work too well, as cwnd is
reduced on every second ACK even though the packets in flight
remains unchanged. Recoveries in a bidirectional flows suffer
quite badly because of this, both NewReno and SACK are affected.

After this patch, rate halving is performed for ACK only if
packets in flight was supposedly changed too.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

Index: 2.6/net/ipv4/tcp_input.c
===================================================================
--- 2.6.orig/net/ipv4/tcp_input.c
+++ 2.6/net/ipv4/tcp_input.c
@@ -1702,19 +1702,22 @@ static inline u32 tcp_cwnd_min(const str
 }
 
 /* Decrease cwnd each second ack. */
-static void tcp_cwnd_down(struct sock *sk)
+static void tcp_cwnd_down(struct sock *sk, int flag)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int decr = tp->snd_cwnd_cnt + 1;
 
-	tp->snd_cwnd_cnt = decr&1;
-	decr >>= 1;
+	if ((flag&FLAG_FORWARD_PROGRESS) ||
+	    (IsReno(tp) && !(flag&FLAG_NOT_DUP))) {
+		tp->snd_cwnd_cnt = decr&1;
+		decr >>= 1;
 
-	if (decr && tp->snd_cwnd > tcp_cwnd_min(sk))
-		tp->snd_cwnd -= decr;
+		if (decr && tp->snd_cwnd > tcp_cwnd_min(sk))
+			tp->snd_cwnd -= decr;
 
-	tp->snd_cwnd = min(tp->snd_cwnd, tcp_packets_in_flight(tp)+1);
-	tp->snd_cwnd_stamp = tcp_time_stamp;
+		tp->snd_cwnd = min(tp->snd_cwnd, tcp_packets_in_flight(tp)+1);
+		tp->snd_cwnd_stamp = tcp_time_stamp;
+	}
 }
 
 /* Nothing was retransmitted or returned timestamp is less
@@ -1899,7 +1902,7 @@ static void tcp_try_to_open(struct sock 
 		}
 		tcp_moderate_cwnd(tp);
 	} else {
-		tcp_cwnd_down(sk);
+		tcp_cwnd_down(sk, flag);
 	}
 }
 
@@ -2100,7 +2103,7 @@ tcp_fastretrans_alert(struct sock *sk, u
 
 	if (is_dupack || tcp_head_timedout(sk, tp))
 		tcp_update_scoreboard(sk, tp);
-	tcp_cwnd_down(sk);
+	tcp_cwnd_down(sk, flag);
 	tcp_xmit_retransmit_queue(sk);
 }
 

-- 
