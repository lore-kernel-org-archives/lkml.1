Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZF0LSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZF0LSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZF0LSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:18:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38363 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbZF0LSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:18:32 -0400
Date: Sat, 27 Jun 2009 19:18:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Oops] 2.6.31-rc1: tun
Message-ID: <20090627111832.GA22621@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625235335.42ba26be@mosly.slynet.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Trofimovich <slyich@gmail.com> wrote:
> 
> Updated from 2.6.30 to 2.6.31-rc1
> 
> $ uname -a
> Linux mosly 2.6.31-rc1 #16 SMP PREEMPT Thu Jun 25 22:14:24 EEST 2009 x86_64 Intel(R) Core(TM)2 Duo CPU U7600 @ 1.20GHz GenuineIntel GNU/Linux
> 
> All my tun interfaces stopped working. ICMP works but IP(TCP/UDP) does not.
> Machine started to hang. I tried to reproduce in linux console. You see the .png result.
> .config attached

This patch should help (already merged by davem).

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 490ce20..db46b4b 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -440,6 +440,9 @@ int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 
+	/* Must drop socket now because of tproxy. */
+	skb_orphan(skb);
+
 	return NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip_rcv_finish);
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index c3a07d7..6d6a427 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -139,6 +139,9 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 
 	rcu_read_unlock();
 
+	/* Must drop socket now because of tproxy. */
+	skb_orphan(skb);
+
 	return NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip6_rcv_finish);
 err:

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
