Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbYHRTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbYHRTgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764931AbYHRTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:34:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:41427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYHRTe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:34:56 -0400
Date: Mon, 18 Aug 2008 12:20:10 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/49] ipv6: Fix ip6_xmit to send fragments if ipfragok is
	true
Message-ID: <20080818192010.GY10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-fix-ip6_xmit-to-send-fragments-if-ipfragok-is-true.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit 77e2f14f71d68d05945f1d30ca55b5194d6ab1ce ]

SCTP used ip6_xmit() to send fragments after received ICMP packet too
big message. But while send packet used ip6_xmit, the skb->local_df is
not initialized. So when skb if enter ip6_fragment(), the following
code will discard the skb.

ip6_fragment(...)
{
    if (!skb->local_df) {
        ...
        return -EMSGSIZE;
    }
    ...
}

SCTP do the following step:
1. send packet ip6_xmit(skb, ipfragok=0)
2. received ICMP packet too big message
3. if PMTUD_ENABLE: ip6_xmit(skb, ipfragok=1)

This patch fixed the problem by set local_df if ipfragok is true.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_output.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -229,6 +229,10 @@ int ip6_xmit(struct sock *sk, struct sk_
 	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
 
+	/* Allow local fragmentation. */
+	if (ipfragok)
+		skb->local_df = 1;
+
 	/*
 	 *	Fill in the IPv6 header
 	 */

-- 
