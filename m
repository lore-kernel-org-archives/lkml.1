Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859Ab0ANWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0ANWwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877Ab0ANWwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:52:18 -0500
Received: from kroah.org ([198.145.64.141]:58201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab0ANWwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:07 2010
Message-Id: <20100114224807.515390123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [9/9] ipv6: skb_dst() can be NULL in ipv6_hop_jumbo().
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 2570a4f5428bcdb1077622342181755741e7fa60 upstream.

This fixes CERT-FI FICORA #341748

Discovered by Olli Jarva and Tuomo Untinen from the CROSS
project at Codenomicon Ltd.

Just like in CVE-2007-4567, we can't rely upon skb_dst() being
non-NULL at this point.  We fixed that in commit
e76b2b2567b83448c2ee85a896433b96150c92e6 ("[IPV6]: Do no rely on
skb->dst before it is assigned.")

However commit 483a47d2fe794328d29950fe00ce26dd405d9437 ("ipv6: added
net argument to IP6_INC_STATS_BH") put a new version of the same bug
into this function.

Complicating analysis further, this bug can only trigger when network
namespaces are enabled in the build.  When namespaces are turned off,
the dev_net() does not evaluate it's argument, so the dereference
would not occur.

So, for a long time, namespaces couldn't be turned on unless SYSFS was
disabled.  Therefore, this code has largely been disabled except by
people turning it on explicitly for namespace development.

With help from Eugene Teo <eugene@redhat.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/exthdrs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -559,6 +559,11 @@ static inline struct inet6_dev *ipv6_skb
 	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) : __in6_dev_get(skb->dev);
 }
 
+static inline struct net *ipv6_skb_net(struct sk_buff *skb)
+{
+	return skb_dst(skb) ? dev_net(skb_dst(skb)->dev) : dev_net(skb->dev);
+}
+
 /* Router Alert as of RFC 2711 */
 
 static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
@@ -580,8 +585,8 @@ static int ipv6_hop_ra(struct sk_buff *s
 static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
+	struct net *net = ipv6_skb_net(skb);
 	u32 pkt_len;
-	struct net *net = dev_net(skb_dst(skb)->dev);
 
 	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
 		LIMIT_NETDEBUG(KERN_DEBUG "ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",


