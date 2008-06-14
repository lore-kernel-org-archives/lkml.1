Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbYFNAX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbYFNAX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYFNAOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:52077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762076AbYFNAOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:42 -0400
Date: Fri, 13 Jun 2008 17:11:49 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Ilpo =?utf-8?B?SsOD4oKscnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 33/47] tcp FRTO: work-around inorder receivers
Message-ID: <20080614001149.GG24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="tcp-frto-work-around-inorder-receivers.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ upstream commit: 79d44516b4b178ffb6e2159c75584cfcfc097914 ]

If receiver consumes segments successfully only in-order, FRTO
fallback to conventional recovery produces RTO loop because
FRTO's forward transmissions will always get dropped and need to
be resent, yet by default they're not marked as lost (which are
the only segments we will retransmit in CA_Loss).

Price to pay about this is occassionally unnecessarily
retransmitting the forward transmission(s). SACK blocks help
a bit to avoid this, so it's mainly a concern for NewReno case
though SACK is not fully immune either.

This change has a side-effect of fixing SACKFRTO problem where
it didn't have snd_nxt of the RTO time available anymore when
fallback become necessary (this problem would have only occured
when RTO would occur for two or more segments and ECE arrives
in step 3; no need to figure out how to fix that unless the
TODO item of selective behavior is considered in future).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Reported-by: Damon L. Chesser <damon@damtek.com>
Tested-by: Damon L. Chesser <damon@damtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_input.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1841,9 +1841,16 @@ static void tcp_enter_frto_loss(struct s
 			TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
 		}
 
-		/* Don't lost mark skbs that were fwd transmitted after RTO */
-		if (!(TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) &&
-		    !after(TCP_SKB_CB(skb)->end_seq, tp->frto_highmark)) {
+		/* Marking forward transmissions that were made after RTO lost
+		 * can cause unnecessary retransmissions in some scenarios,
+		 * SACK blocks will mitigate that in some but not in all cases.
+		 * We used to not mark them but it was causing break-ups with
+		 * receivers that do only in-order receival.
+		 *
+		 * TODO: we could detect presence of such receiver and select
+		 * different behavior per flow.
+		 */
+		if (!(TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)) {
 			TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
 			tp->lost_out += tcp_skb_pcount(skb);
 		}
@@ -1859,7 +1866,7 @@ static void tcp_enter_frto_loss(struct s
 	tp->reordering = min_t(unsigned int, tp->reordering,
 			       sysctl_tcp_reordering);
 	tcp_set_ca_state(sk, TCP_CA_Loss);
-	tp->high_seq = tp->frto_highmark;
+	tp->high_seq = tp->snd_nxt;
 	TCP_ECN_queue_cwr(tp);
 
 	tcp_clear_retrans_hints_partial(tp);

-- 
