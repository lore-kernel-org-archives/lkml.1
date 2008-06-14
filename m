Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbYFNAZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbYFNAZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbYFNAPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762247AbYFNAPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:04 -0400
Date: Fri, 13 Jun 2008 17:12:02 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 38/47] tcp: Fix inconsistency source (CA_Open only when
	!tcp_left_out(tp))
Message-ID: <20080614001202.GL24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="tcp-fix-inconsistency-source.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ upstream commit: 8aca6cb1179ed9bef9351028c8d8af852903eae2 ]

It is possible that this skip path causes TCP to end up into an
invalid state where ca_state was left to CA_Open while some
segments already came into sacked_out. If next valid ACK doesn't
contain new SACK information TCP fails to enter into
tcp_fastretrans_alert(). Thus at least high_seq is set
incorrectly to a too high seqno because some new data segments
could be sent in between (and also, limited transmit is not
being correctly invoked there). Reordering in both directions
can easily cause this situation to occur.

I guess we would want to use tcp_moderate_cwnd(tp) there as well
as it may be possible to use this to trigger oversized burst to
network by sending an old ACK with huge amount of SACK info, but
I'm a bit unsure about its effects (mainly to FlightSize), so to
be on the safe side I just currently fixed it minimally to keep
TCP's state consistent (obviously, such nasty ACKs have been
possible this far). Though it seems that FlightSize is already
underestimated by some amount, so probably on the long term we
might want to trigger recovery there too, if appropriate, to make
FlightSize calculation to resemble reality at the time when the
losses where discovered (but such change scares me too much now
and requires some more thinking anyway how to do that as it
likely involves some code shuffling).

This bug was found by Brian Vowell while running my TCP debug
patch to find cause of another TCP issue (fackets_out
miscount).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2469,6 +2469,20 @@ static inline void tcp_complete_cwr(stru
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
 }
 
+static void tcp_try_keep_open(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	int state = TCP_CA_Open;
+
+	if (tcp_left_out(tp) || tp->retrans_out || tp->undo_marker)
+		state = TCP_CA_Disorder;
+
+	if (inet_csk(sk)->icsk_ca_state != state) {
+		tcp_set_ca_state(sk, state);
+		tp->high_seq = tp->snd_nxt;
+	}
+}
+
 static void tcp_try_to_open(struct sock *sk, int flag)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2482,15 +2496,7 @@ static void tcp_try_to_open(struct sock 
 		tcp_enter_cwr(sk, 1);
 
 	if (inet_csk(sk)->icsk_ca_state != TCP_CA_CWR) {
-		int state = TCP_CA_Open;
-
-		if (tcp_left_out(tp) || tp->retrans_out || tp->undo_marker)
-			state = TCP_CA_Disorder;
-
-		if (inet_csk(sk)->icsk_ca_state != state) {
-			tcp_set_ca_state(sk, state);
-			tp->high_seq = tp->snd_nxt;
-		}
+		tcp_try_keep_open(sk);
 		tcp_moderate_cwnd(tp);
 	} else {
 		tcp_cwnd_down(sk, flag);
@@ -3296,8 +3302,11 @@ no_queue:
 	return 1;
 
 old_ack:
-	if (TCP_SKB_CB(skb)->sacked)
+	if (TCP_SKB_CB(skb)->sacked) {
 		tcp_sacktag_write_queue(sk, skb, prior_snd_una);
+		if (icsk->icsk_ca_state == TCP_CA_Open)
+			tcp_try_keep_open(sk);
+	}
 
 uninteresting_ack:
 	SOCK_DEBUG(sk, "Ack %u out of %u:%u\n", ack, tp->snd_una, tp->snd_nxt);

-- 
