Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853Ab0AEAny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0AEAny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839Ab0AEAnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:43:49 -0500
Received: from kroah.org ([198.145.64.141]:34493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0AEAfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 66/97] ipv6: reassembly: use seperate reassembly queues for conntrack and local delivery
Date: Mon,  4 Jan 2010 16:33:19 -0800
Message-Id: <1262651630-7354-66-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

commit 0b5ccb2ee250136dd7385b1c7da28417d0d4d32d upstream.

Currently the same reassembly queue might be used for packets reassembled
by conntrack in different positions in the stack (PREROUTING/LOCAL_OUT),
as well as local delivery. This can cause "packet jumps" when the fragment
completing a reassembled packet is queued from a different position in the
stack than the previous ones.

Add a "user" identifier to the reassembly queue key to seperate the queues
of each caller, similar to what we do for IPv4.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/ipv6.h                             |    7 +++++++
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   13 +++++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 ++++---
 net/ipv6/reassembly.c                          |    5 ++++-
 5 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 8c31d8a..a496499 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -354,8 +354,15 @@ static inline int ipv6_prefix_equal(const struct in6_addr *a1,
 
 struct inet_frag_queue;
 
+enum ip6_defrag_users {
+	IP6_DEFRAG_LOCAL_DELIVER,
+	IP6_DEFRAG_CONNTRACK_IN,
+	IP6_DEFRAG_CONNTRACK_OUT,
+};
+
 struct ip6_create_arg {
 	__be32 id;
+	u32 user;
 	struct in6_addr *src;
 	struct in6_addr *dst;
 };
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index abc55ad..1ee717e 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -9,7 +9,7 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
-extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
+extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user);
 extern void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 			       struct net_device *in,
 			       struct net_device *out,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 5f2ec20..c0a82fe 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -187,6 +187,16 @@ out:
 	return nf_conntrack_confirm(skb);
 }
 
+static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
+						struct sk_buff *skb)
+{
+	if (hooknum == NF_INET_PRE_ROUTING)
+		return IP6_DEFRAG_CONNTRACK_IN;
+	else
+		return IP6_DEFRAG_CONNTRACK_OUT;
+
+}
+
 static unsigned int ipv6_defrag(unsigned int hooknum,
 				struct sk_buff *skb,
 				const struct net_device *in,
@@ -199,8 +209,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	if (skb->nfct)
 		return NF_ACCEPT;
 
-	reasm = nf_ct_frag6_gather(skb);
-
+	reasm = nf_ct_frag6_gather(skb, nf_ct6_defrag_user(hooknum, skb));
 	/* queued */
 	if (reasm == NULL)
 		return NF_STOLEN;
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index f3aba25..4b6a539 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -170,13 +170,14 @@ out:
 /* Creation primitives. */
 
 static __inline__ struct nf_ct_frag6_queue *
-fq_find(__be32 id, struct in6_addr *src, struct in6_addr *dst)
+fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 {
 	struct inet_frag_queue *q;
 	struct ip6_create_arg arg;
 	unsigned int hash;
 
 	arg.id = id;
+	arg.user = user;
 	arg.src = src;
 	arg.dst = dst;
 
@@ -561,7 +562,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 	return 0;
 }
 
-struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
+struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 {
 	struct sk_buff *clone;
 	struct net_device *dev = skb->dev;
@@ -607,7 +608,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 	if (atomic_read(&nf_init_frags.mem) > nf_init_frags.high_thresh)
 		nf_ct_frag6_evictor();
 
-	fq = fq_find(fhdr->identification, &hdr->saddr, &hdr->daddr);
+	fq = fq_find(fhdr->identification, user, &hdr->saddr, &hdr->daddr);
 	if (fq == NULL) {
 		pr_debug("Can't find and can't create new queue\n");
 		goto ret_orig;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index da5bd0e..4d18699 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -72,6 +72,7 @@ struct frag_queue
 	struct inet_frag_queue	q;
 
 	__be32			id;		/* fragment id		*/
+	u32			user;
 	struct in6_addr		saddr;
 	struct in6_addr		daddr;
 
@@ -141,7 +142,7 @@ int ip6_frag_match(struct inet_frag_queue *q, void *a)
 	struct ip6_create_arg *arg = a;
 
 	fq = container_of(q, struct frag_queue, q);
-	return (fq->id == arg->id &&
+	return (fq->id == arg->id && fq->user == arg->user &&
 			ipv6_addr_equal(&fq->saddr, arg->src) &&
 			ipv6_addr_equal(&fq->daddr, arg->dst));
 }
@@ -163,6 +164,7 @@ void ip6_frag_init(struct inet_frag_queue *q, void *a)
 	struct ip6_create_arg *arg = a;
 
 	fq->id = arg->id;
+	fq->user = arg->user;
 	ipv6_addr_copy(&fq->saddr, arg->src);
 	ipv6_addr_copy(&fq->daddr, arg->dst);
 }
@@ -244,6 +246,7 @@ fq_find(struct net *net, __be32 id, struct in6_addr *src, struct in6_addr *dst,
 	unsigned int hash;
 
 	arg.id = id;
+	arg.user = IP6_DEFRAG_LOCAL_DELIVER;
 	arg.src = src;
 	arg.dst = dst;
 
-- 
1.6.6

