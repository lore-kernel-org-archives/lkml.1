Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYGYXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYGYXM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbYGYXMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:12:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:33501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbYGYXMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:12:06 -0400
Date: Fri, 25 Jul 2008 16:07:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 5/9] net pppoe: Check packet length on all receive paths
Message-ID: <20080725230728.GF1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-net-pppoe-Check-packet-length-on-all-receive-paths.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 392fdb0e35055b96faa9c1cd6ab537805337cdce ]

The length field in the PPPOE header wasn't checked completely.
This patch causes all packets shorter than the declared length
to be dropped.

It also changes the memcpy_toiovec call to skb_copy_datagram_iovec
so that paged packets (rare for PPPOE) are handled properly.

Thanks to Ilja of the Netric Security Team for discovering and
reporting this bug, and Chris Wright for the total_len check.

[ Incorporate warning fix from Stephen Hemminger. -DaveM ]

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pppoe.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/net/pppoe.c
+++ b/drivers/net/pppoe.c
@@ -341,12 +341,6 @@ static int pppoe_rcv_core(struct sock *s
 	struct pppox_sock *relay_po;
 
 	if (sk->sk_state & PPPOX_BOUND) {
-		struct pppoe_hdr *ph = pppoe_hdr(skb);
-		int len = ntohs(ph->length);
-		skb_pull_rcsum(skb, sizeof(struct pppoe_hdr));
-		if (pskb_trim_rcsum(skb, len))
-			goto abort_kfree;
-
 		ppp_input(&po->chan, skb);
 	} else if (sk->sk_state & PPPOX_RELAY) {
 		relay_po = get_item_by_addr(&po->pppoe_relay);
@@ -357,7 +351,6 @@ static int pppoe_rcv_core(struct sock *s
 		if ((sk_pppox(relay_po)->sk_state & PPPOX_CONNECTED) == 0)
 			goto abort_put;
 
-		skb_pull(skb, sizeof(struct pppoe_hdr));
 		if (!__pppoe_xmit(sk_pppox(relay_po), skb))
 			goto abort_put;
 	} else {
@@ -388,6 +381,7 @@ static int pppoe_rcv(struct sk_buff *skb
 {
 	struct pppoe_hdr *ph;
 	struct pppox_sock *po;
+	int len;
 
 	if (!(skb = skb_share_check(skb, GFP_ATOMIC)))
 		goto out;
@@ -399,10 +393,21 @@ static int pppoe_rcv(struct sk_buff *skb
 		goto drop;
 
 	ph = pppoe_hdr(skb);
+	len = ntohs(ph->length);
+
+	skb_pull_rcsum(skb, sizeof(*ph));
+	if (skb->len < len)
+		goto drop;
 
 	po = get_item(ph->sid, eth_hdr(skb)->h_source, dev->ifindex);
-	if (po != NULL)
-		return sk_receive_skb(sk_pppox(po), skb, 0);
+	if (!po)
+		goto drop;
+
+	if (pskb_trim_rcsum(skb, len))
+		goto drop;
+
+	return sk_receive_skb(sk_pppox(po), skb, 0);
+
 drop:
 	kfree_skb(skb);
 out:
@@ -937,12 +942,10 @@ static int pppoe_recvmsg(struct kiocb *i
 	m->msg_namelen = 0;
 
 	if (skb) {
-		struct pppoe_hdr *ph = pppoe_hdr(skb);
-		const int len = ntohs(ph->length);
-
-		error = memcpy_toiovec(m->msg_iov, (unsigned char *) &ph->tag[0], len);
+		total_len = min_t(size_t, total_len, skb->len);
+		error = skb_copy_datagram_iovec(skb, 0, m->msg_iov, total_len);
 		if (error == 0)
-			error = len;
+			error = total_len;
 	}
 
 	kfree_skb(skb);

-- 
