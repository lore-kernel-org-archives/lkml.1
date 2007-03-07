Return-Path: <linux-kernel-owner+w=401wt.eu-S1422777AbXCGR57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777AbXCGR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422772AbXCGRN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:42827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422774AbXCGRN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:57 -0500
Message-Id: <20070307171219.765403323@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       John Heffner <jheffner@psc.edu>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 019/101] Fix TCP FIN handling
Content-Disposition: inline; filename=fix-tcp-fin-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Heffner <jheffner@psc.edu>

We can accidently spit out a huge burst of packets with TSO
when the FIN back is piggybacked onto the final packet.

[TCP]: Don't apply FIN exception to full TSO segments.

Signed-off-by: John Heffner <jheffner@psc.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/net/ipv4/tcp_output.c
+++ linux-2.6.20.1/net/ipv4/tcp_output.c
@@ -965,7 +965,8 @@ static inline unsigned int tcp_cwnd_test
 	u32 in_flight, cwnd;
 
 	/* Don't be strict about the congestion window for the final FIN.  */
-	if (TCP_SKB_CB(skb)->flags & TCPCB_FLAG_FIN)
+	if ((TCP_SKB_CB(skb)->flags & TCPCB_FLAG_FIN) &&
+	    tcp_skb_pcount(skb) == 1)
 		return 1;
 
 	in_flight = tcp_packets_in_flight(tp);

--
