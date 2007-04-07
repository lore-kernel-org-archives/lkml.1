Return-Path: <linux-kernel-owner+w=401wt.eu-S965786AbXDGLpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786AbXDGLpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965791AbXDGLpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:45:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:11872 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965786AbXDGLpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:45:44 -0400
Message-ID: <4617845F.7080203@sw.ru>
Date: Sat, 07 Apr 2007 15:45:35 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH nf-2.6.22] [netfilter] early_drop imrovement
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net>
In-Reply-To: <4616626C.9020100@trash.net>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the number of conntracks is reached nf_conntrack_max limit, early_drop() is
called and tries to free one of already used conntracks in one of the hash
buckets. If it does not find any conntracks that may be freed, it
leads to transmission errors.
However it is not fair because of current hash bucket may be empty but the
neighbour ones can have the number of conntracks that can be freed. On the other
hand the number of checked conntracks is not limited and it can cause a long delay.
The following patch limits the number of checked conntracks by average number of
conntracks in one hash bucket and allows to search conntracks in other hash buckets.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e132c8a..d0b5794 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -525,7 +525,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);

 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(struct list_head *chain)
+static int __early_drop(struct list_head *chain, unsigned int *cnt)
 {
 	/* Traverse backwards: gives us oldest, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
@@ -540,6 +540,10 @@ static int early_drop(struct list_head *chain)
 			atomic_inc(&ct->ct_general.use);
 			break;
 		}
+		if (!--(*cnt)) {
+			dropped = 1;
+			break;
+		}
 	}
 	read_unlock_bh(&nf_conntrack_lock);

@@ -555,6 +559,21 @@ static int early_drop(struct list_head *chain)
 	return dropped;
 }

+static int early_drop(const struct nf_conntrack_tuple *orig)
+{
+	unsigned int i, hash, cnt;
+	int ret = 0;
+
+	hash = hash_conntrack(orig);
+	cnt = (nf_conntrack_max/nf_conntrack_htable_size) + 1;
+
+	for (i = 0;
+	 	!ret && i < nf_conntrack_htable_size;
+			++i, hash = ++hash % nf_conntrack_htable_size)
+		ret = __early_drop(&nf_conntrack_hash[hash], &cnt);
+	return ret;
+}
+
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
@@ -574,9 +593,7 @@ __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,

 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
-		unsigned int hash = hash_conntrack(orig);
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
+		if (!early_drop(orig)) {
 			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
