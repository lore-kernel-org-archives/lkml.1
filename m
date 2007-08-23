Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbXHWWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbXHWWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765970AbXHWW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33165 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765866AbXHWW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:14 -0400
Date: Thu, 23 Aug 2007 15:27:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/28] TCP: Fix TCP rate-halving on bidirectional flows.
Message-ID: <20070823222723.GR18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="tcp-fix-tcp-rate-halving-on-bidirectional-flows.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

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
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1851,19 +1851,22 @@ static inline u32 tcp_cwnd_min(const str
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
@@ -2060,7 +2063,7 @@ static void tcp_try_to_open(struct sock 
 		}
 		tcp_moderate_cwnd(tp);
 	} else {
-		tcp_cwnd_down(sk);
+		tcp_cwnd_down(sk, flag);
 	}
 }
 
@@ -2260,7 +2263,7 @@ tcp_fastretrans_alert(struct sock *sk, u
 
 	if (is_dupack || tcp_head_timedout(sk))
 		tcp_update_scoreboard(sk);
-	tcp_cwnd_down(sk);
+	tcp_cwnd_down(sk, flag);
 	tcp_xmit_retransmit_queue(sk);
 }
 

-- 
