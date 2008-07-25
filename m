Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYGYXNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYGYXNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYGYXNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:13:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:58491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYGYXNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:13:17 -0400
Date: Fri, 25 Jul 2008 16:07:36 -0700
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
       Steffen Klassert <steffen.klassert@secunet.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 8/9] xfrm: fix fragmentation for ipv4 xfrm tunnel
Message-ID: <20080725230736.GI1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0008-xfrm-fix-fragmentation-for-ipv4-xfrm-tunnel.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit fe833fca2eac6b3d3ad5e35f44ad4638362f1da8 ]

When generating the ip header for the transformed packet we just copy
the frag_off field of the ip header from the original packet to the ip
header of the new generated packet. If we receive a packet as a chain
of fragments, all but the last of the new generated packets have the
IP_MF flag set. We have to mask the frag_off field to only keep the
IP_DF flag from the original packet. This got lost with git commit
36cf9acf93e8561d9faec24849e57688a81eb9c5 ("[IPSEC]: Separate
inner/outer mode processing on output")

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/xfrm4_mode_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -52,7 +52,7 @@ static int xfrm4_mode_tunnel_output(stru
 		IP_ECN_clear(top_iph);
 
 	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
-			    0 : XFRM_MODE_SKB_CB(skb)->frag_off;
+		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
 	ip_select_ident(top_iph, dst->child, NULL);
 
 	top_iph->ttl = dst_metric(dst->child, RTAX_HOPLIMIT);

-- 
