Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYFNATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYFNATY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761436AbYFNAN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:34370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbYFNANx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:53 -0400
Date: Fri, 13 Jun 2008 17:11:19 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 21/47] ipsec: Use the correct ip_local_out function
Message-ID: <20080614001119.GU24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipsec-use-the-correct-ip_local_out-function.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ upstream commit: 1ac06e0306d0192a7a4d9ea1c9e06d355ce7e7d3 ]

Because the IPsec output function xfrm_output_resume does its
own dst_output call it should always call __ip_local_output
instead of ip_local_output as the latter may invoke dst_output
directly.  Otherwise the return values from nf_hook and dst_output
may clash as they both use the value 1 but for different purposes.

When that clash occurs this can cause a packet to be used after
it has been freed which usually leads to a crash.  Because the
offending value is only returned from dst_output with qdiscs
such as HTB, this bug is normally not visible.

Thanks to Marco Berizzi for his perseverance in tracking this
down.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/route.c |    2 +-
 net/ipv6/route.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -162,7 +162,7 @@ static struct dst_ops ipv4_dst_ops = {
 	.negative_advice =	ipv4_negative_advice,
 	.link_failure =		ipv4_link_failure,
 	.update_pmtu =		ip_rt_update_pmtu,
-	.local_out =		ip_local_out,
+	.local_out =		__ip_local_out,
 	.entry_size =		sizeof(struct rtable),
 	.entries =		ATOMIC_INIT(0),
 };
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -105,7 +105,7 @@ static struct dst_ops ip6_dst_ops = {
 	.negative_advice	=	ip6_negative_advice,
 	.link_failure		=	ip6_link_failure,
 	.update_pmtu		=	ip6_rt_update_pmtu,
-	.local_out		=	ip6_local_out,
+	.local_out		=	__ip6_local_out,
 	.entry_size		=	sizeof(struct rt6_info),
 	.entries		=	ATOMIC_INIT(0),
 };

-- 
