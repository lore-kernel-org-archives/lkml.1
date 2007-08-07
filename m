Return-Path: <linux-kernel-owner+w=401wt.eu-S935185AbXHGUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185AbXHGUqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934892AbXHGUpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:45:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51229 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934857AbXHGUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:45:49 -0400
Date: Tue, 7 Aug 2007 13:42:40 -0700
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
Subject: [2.6.22.2 review 02/84] TCP FRTO retransmit bug fix
Message-ID: <20070807204240.GC23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="tcp-frto-retransmit-bug-fix.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[TCP]: Verify the presence of RETRANS bit when leaving FRTO

For yet unknown reason, something cleared SACKED_RETRANS bit
underneath FRTO.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1398,7 +1398,9 @@ static void tcp_enter_frto_loss(struct s
 		 * waiting for the first ACK and did not get it)...
 		 */
 		if ((tp->frto_counter == 1) && !(flag&FLAG_DATA_ACKED)) {
-			tp->retrans_out += tcp_skb_pcount(skb);
+			/* For some reason this R-bit might get cleared? */
+			if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_RETRANS)
+				tp->retrans_out += tcp_skb_pcount(skb);
 			/* ...enter this if branch just for the first segment */
 			flag |= FLAG_DATA_ACKED;
 		} else {

-- 
