Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYICRkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYICRkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYICRja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:39:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:52175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbYICRj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:39:28 -0400
Date: Wed, 3 Sep 2008 10:26:01 -0700
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
       alan@lxorguk.ukuu.org.uk, Brian Haley <brian.haley@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/42] ipv6: Fix OOPS, ip -f inet6 route get fec0::1,
	linux-2.6.26, ip6_route_output, rt6_fill_node+0x175
Message-ID: <20080903172601.GV7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-ipv6-Fix-OOPS-ip-f-inet6-route-get-fec0-1-linux.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian Haley <brian.haley@hp.com>

[ Upstream commit 5e0115e500fe9dd2ca11e6f92db9123204f1327a ]

Alexey Dobriyan wrote:
> On Thu, Aug 07, 2008 at 07:00:56PM +0200, John Gumb wrote:
>> Scenario: no ipv6 default route set.
>
>> # ip -f inet6 route get fec0::1
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> IP: [<c0369b85>] rt6_fill_node+0x175/0x3b0
>> EIP is at rt6_fill_node+0x175/0x3b0
>
> 0xffffffff80424dd3 is in rt6_fill_node (net/ipv6/route.c:2191).
> 2186                    } else
> 2187    #endif
> 2188                            NLA_PUT_U32(skb, RTA_IIF, iif);
> 2189            } else if (dst) {
> 2190                    struct in6_addr saddr_buf;
> 2191      ====>         if (ipv6_dev_get_saddr(ip6_dst_idev(&rt->u.dst)->dev,
>					       ^^^^^^^^^^^^^^^^^^^^^^^^
>											NULL
>
> 2192                                           dst, 0, &saddr_buf) == 0)
> 2193                            NLA_PUT(skb, RTA_PREFSRC, 16, &saddr_buf);
> 2194            }

The commit that changed this can't be reverted easily, but the patch
below works for me.

Fix NULL de-reference in rt6_fill_node() when there's no IPv6 input
device present in the dst entry.

Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2179,8 +2179,9 @@ static int rt6_fill_node(struct sk_buff 
 #endif
 			NLA_PUT_U32(skb, RTA_IIF, iif);
 	} else if (dst) {
+		struct inet6_dev *idev = ip6_dst_idev(&rt->u.dst);
 		struct in6_addr saddr_buf;
-		if (ipv6_dev_get_saddr(ip6_dst_idev(&rt->u.dst)->dev,
+		if (ipv6_dev_get_saddr(idev ? idev->dev : NULL,
 				       dst, 0, &saddr_buf) == 0)
 			NLA_PUT(skb, RTA_PREFSRC, 16, &saddr_buf);
 	}

-- 
