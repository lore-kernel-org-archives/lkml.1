Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbXF0Mwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbXF0Mwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbXF0MwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:52:16 -0400
Received: from stinky.trash.net ([213.144.137.162]:56161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbXF0MwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:52:15 -0400
Message-ID: <46825D63.3060500@trash.net>
Date: Wed, 27 Jun 2007 14:51:47 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "David S. Miller" <davem@davemloft.net>, devel@openvz.org
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net> <4682523F.6000002@trash.net> <4682582D.7080501@sw.ru>
In-Reply-To: <4682582D.7080501@sw.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: multipart/mixed;
 boundary="------------020009030000050303070108"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020009030000050303070108
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Vasily Averin wrote:
> Patrick McHardy wrote:
> 
>>+	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
>>+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
>>+			tmp = nf_ct_tuplehash_to_ctrack(h);
>>+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
>>+				ct = tmp;
>>+		}
>>+		if (ct) {
>>+			atomic_inc(&ct->ct_general.use);
>>+			break;
>>+		}
>>+		hash = (hash + 1) % nf_conntrack_htable_size;
> 
> 
> it is incorrect,
> We should count the number of checked _conntracks_, but you count the number of
> hash buckets. I.e "i" should be incremented/checked inside the nested loop.


I misunderstood your patch then. This one should be better.

--------------020009030000050303070108
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack: early_drop improvement

When the maximum number of conntrack entries is reached and a new
one needs to be allocated, conntrack tries to drop an unassured
connection from the same hash bucket the new conntrack would hash
to. Since with a properly sized hash the average number of entries
per bucket is 1, the chances of actually finding one are not very
good. This patch increases those chances by walking over the hash
until 8 entries are checked.

Based on patch by Vasily Averin <vvs@sw.ru>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit df9f4fc41d7d6a7a51d2fe4b28db2557cb9a0d05
tree 8beb115ce12126b28ce3e5eb3f95b36b71462ea5
parent 665d98d03473cab252830129f414e1b38fb2b038
author Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 14:51:38 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 14:51:38 +0200

 net/netfilter/nf_conntrack_core.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e62ad..bbb52e5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -377,21 +377,29 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
+#define NF_CT_EVICTION_RANGE	8
+
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(struct hlist_head *chain)
+static int early_drop(unsigned int hash)
 {
 	/* Use oldest entry, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct = NULL, *tmp;
 	struct hlist_node *n;
-	int dropped = 0;
+	unsigned int i;
+	int dropped = 0, cnt = NF_CT_EVICTION_RANGE;
 
 	read_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry(h, n, chain, hnode) {
-		tmp = nf_ct_tuplehash_to_ctrack(h);
-		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
-			ct = tmp;
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+			tmp = nf_ct_tuplehash_to_ctrack(h);
+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+				ct = tmp;
+			if (--cnt <= 0)
+				break;
+		}
+		hash = (hash + 1) % nf_conntrack_htable_size;
 	}
 	if (ct)
 		atomic_inc(&ct->ct_general.use);
@@ -425,8 +433,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
+		if (!early_drop(hash)) {
 			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING

--------------020009030000050303070108--
