Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbXLMGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbXLMGue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbXLMGit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56719 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbXLMGir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:47 -0500
Date: Wed, 12 Dec 2007 22:35:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       davem@davemloft.net, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 36/36] BRIDGE: Properly dereference the br_should_route_hook
Message-ID: <20071213063539.GK25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bridge-properly-dereference-the-br_should_route_hook.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pavel Emelyanov <xemul@openvz.org>

[BRIDGE]: Properly dereference the br_should_route_hook

[ Upstream commit: 82de382ce8e1c7645984616728dc7aaa057821e4 ]

This hook is protected with the RCU, so simple

if (br_should_route_hook)
	br_should_route_hook(...)

is not enough on some architectures.

Use the rcu_dereference/rcu_assign_pointer in this case.

Fixed Stephen's comment concerning using the typeof().

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_input.c                 |    7 ++++---
 net/bridge/netfilter/ebtable_broute.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -127,6 +127,7 @@ static inline int is_link_local(const un
 struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 {
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
+	int (*rhook)(struct sk_buff **pskb);
 
 	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
 		goto drop;
@@ -148,9 +149,9 @@ struct sk_buff *br_handle_frame(struct n
 
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
-
-		if (br_should_route_hook) {
-			if (br_should_route_hook(&skb))
+		rhook = rcu_dereference(br_should_route_hook);
+		if (rhook != NULL) {
+			if (rhook(&skb))
 				return skb;
 			dest = eth_hdr(skb)->h_dest;
 		}
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -70,13 +70,13 @@ static int __init ebtable_broute_init(vo
 	if (ret < 0)
 		return ret;
 	/* see br_input.c */
-	br_should_route_hook = ebt_broute;
+	rcu_assign_pointer(br_should_route_hook, ebt_broute);
 	return ret;
 }
 
 static void __exit ebtable_broute_fini(void)
 {
-	br_should_route_hook = NULL;
+	rcu_assign_pointer(br_should_route_hook, NULL);
 	synchronize_net();
 	ebt_unregister_table(&broute_table);
 }

-- 
