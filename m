Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXIXQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXIXQmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbXIXQ2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:38 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58126 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183AbXIXQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:36 -0400
Date: Mon, 24 Sep 2007 09:22:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       David Miller <davem@davemloft.net>
Subject: [45/50] Handle snd_una in tcp_cwnd_down()
Message-ID: <20070924162238.GT13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="handle-snd_una-in-tcp_cwnd_down.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

commit 6ee8009e38006da81d2a53da1aaa27365552553e in mainline

Subject: [45/50] [PATCH 1/1] [TCP]: Also handle snd_una changes in tcp_cwnd_down

tcp_cwnd_down must check for it too as it should be conservative
in case of collapse stuff and also when receiver is trying to
lie (though it wouldn't be successful anyway).

Note:
- Separated also is_dupack and do_lost in fast_retransalert
	* Much cleaner look-and-feel now
	* This time it really fixes cumulative ACK + many new
	  SACK blocks recovery entry (I claimed this fixes with
	  last patch but it wasn't). TCP will now call
	  tcp_update_scoreboard regardless of is_dupack when
	  in recovery as long as there is enough fackets_out.
- Introduce FLAG_SND_UNA_ADVANCED
	* Some prior_snd_una arguments are unnecessary after it
- Added helper FLAG_ANY_PROGRESS to avoid long FLAG...|FLAG...
  constructs

This is a reduced version of a mainline patch.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -102,11 +102,13 @@ int sysctl_tcp_abc __read_mostly;
 #define FLAG_DATA_LOST		0x80 /* SACK detected data lossage.		*/
 #define FLAG_SLOWPATH		0x100 /* Do not skip RFC checks for window update.*/
 #define FLAG_ONLY_ORIG_SACKED	0x200 /* SACKs only non-rexmit sent before RTO */
+#define FLAG_SND_UNA_ADVANCED	0x400 /* Snd_una was changed (!= FLAG_DATA_ACKED) */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
 #define FLAG_CA_ALERT		(FLAG_DATA_SACKED|FLAG_ECE)
 #define FLAG_FORWARD_PROGRESS	(FLAG_ACKED|FLAG_DATA_SACKED)
+#define FLAG_ANY_PROGRESS	(FLAG_FORWARD_PROGRESS|FLAG_SND_UNA_ADVANCED)
 
 #define IsReno(tp) ((tp)->rx_opt.sack_ok == 0)
 #define IsFack(tp) ((tp)->rx_opt.sack_ok & 2)
@@ -1856,7 +1858,7 @@ static void tcp_cwnd_down(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 	int decr = tp->snd_cwnd_cnt + 1;
 
-	if ((flag&FLAG_FORWARD_PROGRESS) ||
+	if ((flag&FLAG_ANY_PROGRESS) ||
 	    (IsReno(tp) && !(flag&FLAG_NOT_DUP))) {
 		tp->snd_cwnd_cnt = decr&1;
 		decr >>= 1;
@@ -2112,10 +2114,9 @@ tcp_fastretrans_alert(struct sock *sk, u
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int is_dupack = (tp->snd_una == prior_snd_una &&
-			 (!(flag&FLAG_NOT_DUP) ||
-			  ((flag&FLAG_DATA_SACKED) &&
-			   (tp->fackets_out > tp->reordering))));
+	int is_dupack = !(flag&(FLAG_SND_UNA_ADVANCED|FLAG_NOT_DUP));
+	int do_lost = is_dupack || ((flag&FLAG_DATA_SACKED) &&
+				    (tp->fackets_out > tp->reordering));
 
 	/* Some technical things:
 	 * 1. Reno does not count dupacks (sacked_out) automatically. */
@@ -2199,7 +2200,7 @@ tcp_fastretrans_alert(struct sock *sk, u
 			int acked = prior_packets - tp->packets_out;
 			if (IsReno(tp))
 				tcp_remove_reno_sacks(sk, acked);
-			is_dupack = tcp_try_undo_partial(sk, acked);
+			do_lost = tcp_try_undo_partial(sk, acked);
 		}
 		break;
 	case TCP_CA_Loss:
@@ -2264,7 +2265,7 @@ tcp_fastretrans_alert(struct sock *sk, u
 		tcp_set_ca_state(sk, TCP_CA_Recovery);
 	}
 
-	if (is_dupack || tcp_head_timedout(sk))
+	if (do_lost || tcp_head_timedout(sk))
 		tcp_update_scoreboard(sk);
 	tcp_cwnd_down(sk, flag);
 	tcp_xmit_retransmit_queue(sk);
@@ -2774,6 +2775,9 @@ static int tcp_ack(struct sock *sk, stru
 	if (before(ack, prior_snd_una))
 		goto old_ack;
 
+	if (after(ack, prior_snd_una))
+		flag |= FLAG_SND_UNA_ADVANCED;
+
 	if (sysctl_tcp_abc) {
 		if (icsk->icsk_ca_state < TCP_CA_CWR)
 			tp->bytes_acked += ack - prior_snd_una;

-- 
