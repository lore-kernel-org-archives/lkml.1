Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbXIXQmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbXIXQmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761210AbXIXQ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58135 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbXIXQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:40 -0400
Date: Mon, 24 Sep 2007 09:22:41 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: [46/50] Fix TCP DSACK cwnd handling
Message-ID: <20070924162241.GU13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-tcp-dsack-cwnd-handling.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

commit 49ff4bb4cd4c04acf8f9e3d3ec2148305a1db445 in mainline.

[TCP]: DSACK signals data receival, be conservative

In case a DSACK is received, it's better to lower cwnd as it's
a sign of data receival.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -103,6 +103,7 @@ int sysctl_tcp_abc __read_mostly;
 #define FLAG_SLOWPATH		0x100 /* Do not skip RFC checks for window update.*/
 #define FLAG_ONLY_ORIG_SACKED	0x200 /* SACKs only non-rexmit sent before RTO */
 #define FLAG_SND_UNA_ADVANCED	0x400 /* Snd_una was changed (!= FLAG_DATA_ACKED) */
+#define FLAG_DSACKING_ACK	0x800 /* SACK blocks contained DSACK info */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -966,12 +967,14 @@ tcp_sacktag_write_queue(struct sock *sk,
 
 	/* Check for D-SACK. */
 	if (before(ntohl(sp[0].start_seq), TCP_SKB_CB(ack_skb)->ack_seq)) {
+		flag |= FLAG_DSACKING_ACK;
 		found_dup_sack = 1;
 		tp->rx_opt.sack_ok |= 4;
 		NET_INC_STATS_BH(LINUX_MIB_TCPDSACKRECV);
 	} else if (num_sacks > 1 &&
 			!after(ntohl(sp[0].end_seq), ntohl(sp[1].end_seq)) &&
 			!before(ntohl(sp[0].start_seq), ntohl(sp[1].start_seq))) {
+		flag |= FLAG_DSACKING_ACK;
 		found_dup_sack = 1;
 		tp->rx_opt.sack_ok |= 4;
 		NET_INC_STATS_BH(LINUX_MIB_TCPDSACKOFORECV);
@@ -1858,7 +1861,7 @@ static void tcp_cwnd_down(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 	int decr = tp->snd_cwnd_cnt + 1;
 
-	if ((flag&FLAG_ANY_PROGRESS) ||
+	if ((flag&(FLAG_ANY_PROGRESS|FLAG_DSACKING_ACK)) ||
 	    (IsReno(tp) && !(flag&FLAG_NOT_DUP))) {
 		tp->snd_cwnd_cnt = decr&1;
 		decr >>= 1;

-- 
