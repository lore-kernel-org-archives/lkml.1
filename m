Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZHMT7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZHMT7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZHMT7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:21 -0400
Received: from kroah.org ([198.145.64.141]:41667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZHMT7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.321194634@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/74] inet: Call skb_orphan before tproxy activates
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=inet-call-skb_orphan-before-tproxy-activates.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 71f9dacd2e4d233029e9e956ca3f79531f411827 ]

As transparent proxying looks up the socket early and assigns
it to the skb for later processing, we must drop any existing
socket ownership prior to that in order to distinguish between
the case where tproxy is active and where it is not.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ip_input.c  |    3 +++
 net/ipv6/ip6_input.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -437,6 +437,9 @@ int ip_rcv(struct sk_buff *skb, struct n
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 
+	/* Must drop socket now because of tproxy. */
+	skb_orphan(skb);
+
 	return NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip_rcv_finish);
 
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -139,6 +139,9 @@ int ipv6_rcv(struct sk_buff *skb, struct
 
 	rcu_read_unlock();
 
+	/* Must drop socket now because of tproxy. */
+	skb_orphan(skb);
+
 	return NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip6_rcv_finish);
 err:


