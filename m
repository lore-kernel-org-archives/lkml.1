Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYDGL5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYDGL5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYDGLz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:55:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60044 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbYDGLzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:55:52 -0400
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Robin H. Johnson" <robbat2@gentoo.org>,
       Georgi Chorbadzhiyski <gf@unixsol.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Denys Fedoryshchenko <denys@visp.net.lb>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCHv2 net-2.6 3/4] [TCP]: tcp_simple_retransmit can cause S+L
Date: Mon,  7 Apr 2008 14:55:43 +0300
Message-Id: <1207569344-19687-4-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1207569344-19687-3-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1207569344-19687-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1207569344-19687-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1207569344-19687-3-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes Bugzilla #10384

tcp_simple_retransmit does L increment without any checking
whatsoever for overflowing S+L when Reno is in use.

The simplest scenario I can currently think of is rather
complex in practice (there might be some more straightforward
cases though). Ie., if mss is reduced during mtu probing, it
may end up marking everything lost and if some duplicate ACKs
arrived prior to that sacked_out will be non-zero as well,
leading to S+L > packets_out, tcp_clean_rtx_queue on the next
cumulative ACK or tcp_fastretrans_alert on the next duplicate
ACK will fix the S counter.

More straightforward (but questionable) solution would be to
just call tcp_reset_reno_sack() in tcp_simple_retransmit but
it would negatively impact the probe's retransmission, ie.,
the retransmissions would not occur if some duplicate ACKs
had arrived.

So I had to add reno sacked_out reseting to CA_Loss state
when the first cumulative ACK arrives (this stale sacked_out
might actually be the explanation for the reports of left_out
overflows in kernel prior to 2.6.23 and S+L overflow reports
of 2.6.24). However, this alone won't be enough to fix kernel
before 2.6.24 because it is building on top of the commit
1b6d427bb7e ([TCP]: Reduce sacked_out with reno when purging
write_queue) to keep the sacked_out from overflowing.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
---
 include/net/tcp.h     |    2 ++
 net/ipv4/tcp_input.c  |   24 ++++++++++++++++++------
 net/ipv4/tcp_output.c |    3 +++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 723b368..8f5fc52 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -760,6 +760,8 @@ static inline unsigned int tcp_packets_in_flight(const struct tcp_sock *tp)
 	return tp->packets_out - tcp_left_out(tp) + tp->retrans_out;
 }
 
+extern int tcp_limit_reno_sacked(struct tcp_sock *tp);
+
 /* If cwnd > ssthresh, we may raise ssthresh to be half-way to cwnd.
  * The exception is rate halving phase, when cwnd is decreasing towards
  * ssthresh.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f053bfe..a2a06d6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1625,13 +1625,11 @@ out:
 	return flag;
 }
 
-/* If we receive more dupacks than we expected counting segments
- * in assumption of absent reordering, interpret this as reordering.
- * The only another reason could be bug in receiver TCP.
+/* Limits sacked_out so that sum with lost_out isn't ever larger than
+ * packets_out. Returns zero if sacked_out adjustement wasn't necessary.
  */
-static void tcp_check_reno_reordering(struct sock *sk, const int addend)
+int tcp_limit_reno_sacked(struct tcp_sock *tp)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
 	u32 holes;
 
 	holes = max(tp->lost_out, 1U);
@@ -1639,8 +1637,20 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 
 	if ((tp->sacked_out + holes) > tp->packets_out) {
 		tp->sacked_out = tp->packets_out - holes;
-		tcp_update_reordering(sk, tp->packets_out + addend, 0);
+		return 1;
 	}
+	return 0;
+}
+
+/* If we receive more dupacks than we expected counting segments
+ * in assumption of absent reordering, interpret this as reordering.
+ * The only another reason could be bug in receiver TCP.
+ */
+static void tcp_check_reno_reordering(struct sock *sk, const int addend)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	if (tcp_limit_reno_sacked(tp))
+		tcp_update_reordering(sk, tp->packets_out + addend, 0);
 }
 
 /* Emulate SACKs for SACKless connection: account for a new dupack. */
@@ -2600,6 +2610,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked, int flag)
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
 			icsk->icsk_retransmits = 0;
+		if (tcp_is_reno(tp) && flag & FLAG_SND_UNA_ADVANCED)
+			tcp_reset_reno_sack(tp);
 		if (!tcp_try_undo_loss(sk)) {
 			tcp_moderate_cwnd(tp);
 			tcp_xmit_retransmit_queue(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6e25540..441fdd3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1808,6 +1808,9 @@ void tcp_simple_retransmit(struct sock *sk)
 	if (!lost)
 		return;
 
+	if (tcp_is_reno(tp))
+		tcp_limit_reno_sacked(tp);
+
 	tcp_verify_left_out(tp);
 
 	/* Don't muck with the congestion window here.
-- 
1.5.2.2

