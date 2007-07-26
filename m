Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXGZQeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXGZQeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934077AbXGZQdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055AbXGZQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] netfilter endian regressions
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IE6H9-0005Bd-Fg@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


no real bugs, just misannotations cropping up

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/netfilter/xt_connlimit.h     |    4 ++--
 include/net/netfilter/nf_conntrack_tuple.h |    4 ++--
 net/ipv4/netfilter/nf_nat_core.c           |    3 ++-
 net/ipv4/netfilter/nf_nat_rule.c           |    2 +-
 net/netfilter/nf_conntrack_core.c          |    3 ++-
 net/netfilter/nf_conntrack_expect.c        |    8 ++++----
 net/netfilter/nf_conntrack_helper.c        |    2 +-
 net/netfilter/xt_connlimit.c               |    6 +++---
 net/netfilter/xt_u32.c                     |   11 ++++++-----
 9 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 90ae8b4..37e933c 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -5,8 +5,8 @@ struct xt_connlimit_data;
 
 struct xt_connlimit_info {
 	union {
-		u_int32_t v4_mask;
-		u_int32_t v6_mask[4];
+		__be32 v4_mask;
+		__be32 v6_mask[4];
 	};
 	unsigned int limit, inverse;
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 040dae5..c48e390 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -35,7 +35,7 @@ union nf_conntrack_address {
 union nf_conntrack_man_proto
 {
 	/* Add other protocols here. */
-	u_int16_t all;
+	__be16 all;
 
 	struct {
 		__be16 port;
@@ -73,7 +73,7 @@ struct nf_conntrack_tuple
 		union nf_conntrack_address u3;
 		union {
 			/* Add other protocols here. */
-			u_int16_t all;
+			__be16 all;
 
 			struct {
 				__be16 port;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index e848d8d..deab27f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -77,7 +77,8 @@ static inline unsigned int
 hash_by_src(const struct nf_conntrack_tuple *tuple)
 {
 	/* Original src, to ensure we map it consistently if poss. */
-	return jhash_3words((__force u32)tuple->src.u3.ip, tuple->src.u.all,
+	return jhash_3words((__force u32)tuple->src.u3.ip,
+			    (__force u32)tuple->src.u.all,
 			    tuple->dst.protonum, 0) % nf_nat_htable_size;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 0f45427..76ec59a 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -192,7 +192,7 @@ alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum)
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
 		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
 		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
-	u_int16_t all
+	__be16 all
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
 		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
 		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.all);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aa086c8..0fe1188 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -79,7 +79,8 @@ static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 	a = jhash2(tuple->src.u3.all, ARRAY_SIZE(tuple->src.u3.all),
 		   (tuple->src.l3num << 16) | tuple->dst.protonum);
 	b = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
-		   (tuple->src.u.all << 16) | tuple->dst.u.all);
+		   ((__force __u16)tuple->src.u.all << 16) |
+		    (__force __u16)tuple->dst.u.all);
 
 	return jhash_2words(a, b, rnd) % size;
 }
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 1aa6229..eb6695d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -80,7 +80,7 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
 
 	return jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
 		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
-		       tuple->dst.u.all) ^ nf_ct_expect_hash_rnd) %
+		       (__force __u16)tuple->dst.u.all) ^ nf_ct_expect_hash_rnd) %
 	       nf_ct_expect_hsize;
 }
 
@@ -259,8 +259,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 	}
 
 	if (src) {
-		exp->tuple.src.u.all = (__force u16)*src;
-		exp->mask.src.u.all = 0xFFFF;
+		exp->tuple.src.u.all = *src;
+		exp->mask.src.u.all = htons(0xFFFF);
 	} else {
 		exp->tuple.src.u.all = 0;
 		exp->mask.src.u.all = 0;
@@ -272,7 +272,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 		memset((void *)&exp->tuple.dst.u3 + len, 0x00,
 		       sizeof(exp->tuple.dst.u3) - len);
 
-	exp->tuple.dst.u.all = (__force u16)*dst;
+	exp->tuple.dst.u.all = *dst;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ca10df4..96aa637 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -39,7 +39,7 @@ static int nf_ct_helper_vmalloc;
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
 {
 	return (((tuple->src.l3num << 8) | tuple->dst.protonum) ^
-		tuple->src.u.all) % nf_ct_helper_hsize;
+		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
 }
 
 struct nf_conntrack_helper *
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 3335dd5..06cff1d 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -42,13 +42,13 @@ struct xt_connlimit_data {
 static u_int32_t connlimit_rnd;
 static bool connlimit_rnd_inited;
 
-static inline unsigned int connlimit_iphash(u_int32_t addr)
+static inline unsigned int connlimit_iphash(__be32 addr)
 {
 	if (unlikely(!connlimit_rnd_inited)) {
 		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
 		connlimit_rnd_inited = true;
 	}
-	return jhash_1word(addr, connlimit_rnd) & 0xFF;
+	return jhash_1word((__force __u32)addr, connlimit_rnd) & 0xFF;
 }
 
 static inline unsigned int
@@ -66,7 +66,7 @@ connlimit_iphash6(const union nf_conntrack_address *addr,
 	for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i)
 		res.ip6[i] = addr->ip6[i] & mask->ip6[i];
 
-	return jhash2(res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
+	return jhash2((u32 *)res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
 }
 
 static inline bool already_closed(const struct nf_conn *conn)
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 04b677a..74f9b14 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -21,6 +21,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 	unsigned int nnums;
 	unsigned int nvals;
 	unsigned int i;
+	__be32 n;
 	u_int32_t pos;
 	u_int32_t val;
 	u_int32_t at;
@@ -38,9 +39,9 @@ static bool u32_match_it(const struct xt_u32 *data,
 		if (skb->len < 4 || pos > skb->len - 4);
 			return false;
 
-		ret   = skb_copy_bits(skb, pos, &val, sizeof(val));
+		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));
 		BUG_ON(ret < 0);
-		val   = ntohl(val);
+		val   = ntohl(n);
 		nnums = ct->nnums;
 
 		/* Inner loop runs over "&", "<<", ">>" and "@" operands */
@@ -65,10 +66,10 @@ static bool u32_match_it(const struct xt_u32 *data,
 				    pos > skb->len - at - 4)
 					return false;
 
-				ret = skb_copy_bits(skb, at + pos, &val,
-						    sizeof(val));
+				ret = skb_copy_bits(skb, at + pos, &n,
+						    sizeof(n));
 				BUG_ON(ret < 0);
-				val = ntohl(val);
+				val = ntohl(n);
 				break;
 			}
 		}
-- 
1.5.3.GIT


