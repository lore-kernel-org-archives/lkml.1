Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbXLMHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbXLMHOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXLMG6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:02 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55572 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760761AbXLMG6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:00 -0500
Date: Wed, 12 Dec 2007 22:53:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 45/60] TCP: MTUprobe: fix potential sk_send_head corruption
Message-ID: <20071213065313.GU6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="tcp-mtuprobe-fix-potential-sk_send_head-corruption.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[TCP] MTUprobe: fix potential sk_send_head corruption

[ Upstream commit: 6e42141009ff18297fe19d19296738b742f861db ]

When the abstraction functions got added, conversion here was
made incorrectly. As a result, the skb may end up pointing
to skb which got included to the probe skb and then was freed.
For it to trigger, however, skb_transmit must fail sending as
well.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/tcp.h     |    3 +++
 net/ipv4/tcp_output.c |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1256,6 +1256,9 @@ static inline void tcp_insert_write_queu
 						  struct sock *sk)
 {
 	__skb_insert(new, skb->prev, skb, &sk->sk_write_queue);
+
+	if (sk->sk_send_head == skb)
+		sk->sk_send_head = new;
 }
 
 static inline void tcp_unlink_write_queue(struct sk_buff *skb, struct sock *sk)
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1287,7 +1287,6 @@ static int tcp_mtu_probe(struct sock *sk
 
 	skb = tcp_send_head(sk);
 	tcp_insert_write_queue_before(nskb, skb, sk);
-	tcp_advance_send_head(sk, skb);
 
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;

-- 
