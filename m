Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZCNASz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZCNASz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZCNASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:23 -0400
Received: from kroah.org ([198.145.64.141]:46576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbZCNASW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000738.882313230@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:10 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/96] bridge: netfilter: fix update_pmtu crash with GRE
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=bridge-netfilter-fix-update_pmtu-crash-with-gre.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 631339f1e544a4d39a63cfe6708c5bddcd5a2c48 ]

As GRE tries to call the update_pmtu function on skb->dst and
bridge supplies an skb->dst that has a NULL ops field, all is
not well.

This patch fixes this by giving the bridge device an ops field
with an update_pmtu function.  For the moment I've left all
other fields blank but we can fill them in later should the
need arise.

Based on report and patch by Philip Craig.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_netfilter.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -101,6 +101,18 @@ static inline __be16 pppoe_proto(const s
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
 	 brnf_filter_pppoe_tagged)
 
+static void fake_update_pmtu(struct dst_entry *dst, u32 mtu)
+{
+}
+
+static struct dst_ops fake_dst_ops = {
+	.family =		AF_INET,
+	.protocol =		__constant_htons(ETH_P_IP),
+	.update_pmtu =		fake_update_pmtu,
+	.entry_size =		sizeof(struct rtable),
+	.entries =		ATOMIC_INIT(0),
+};
+
 /*
  * Initialize bogus route table used to keep netfilter happy.
  * Currently, we fill in the PMTU entry because netfilter
@@ -117,6 +129,7 @@ void br_netfilter_rtable_init(struct net
 	rt->u.dst.path = &rt->u.dst;
 	rt->u.dst.metrics[RTAX_MTU - 1] = 1500;
 	rt->u.dst.flags	= DST_NOXFRM;
+	rt->u.dst.ops = &fake_dst_ops;
 }
 
 static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)


