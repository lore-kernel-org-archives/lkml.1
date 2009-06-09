Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbZFIKQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbZFIKQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbZFIKPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:51 -0400
Received: from kroah.org ([198.145.64.141]:59746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759949AbZFIKPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:49 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:53 2009
Message-Id: <20090609094053.693915417@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:55 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/87] net: fix rtable leak in net/ipv4/route.c
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=net-fix-rtable-leak-in-net-ipv4-route.c.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit 1ddbcb005c395518c2cd0df504cff3d4b5c85853 ]

Alexander V. Lukyanov found a regression in 2.6.29 and made a complete
analysis found in http://bugzilla.kernel.org/show_bug.cgi?id=13339
Quoted here because its a perfect one :

begin_of_quotation
 2.6.29 patch has introduced flexible route cache rebuilding. Unfortunately the
 patch has at least one critical flaw, and another problem.

 rt_intern_hash calculates rthi pointer, which is later used for new entry
 insertion. The same loop calculates cand pointer which is used to clean the
 list. If the pointers are the same, rtable leak occurs, as first the cand is
 removed then the new entry is appended to it.

 This leak leads to unregister_netdevice problem (usage count > 0).

 Another problem of the patch is that it tries to insert the entries in certain
 order, to facilitate counting of entries distinct by all but QoS parameters.
 Unfortunately, referencing an existing rtable entry moves it to list beginning,
 to speed up further lookups, so the carefully built order is destroyed.

 For the first problem the simplest patch it to set rthi=0 when rthi==cand, but
 it will also destroy the ordering.
end_of_quotation

Problematic commit is 1080d709fb9d8cd4392f93476ee46a9d6ea05a5b
(net: implement emergency route cache rebulds when gc_elasticity is exceeded)

Trying to keep dst_entries ordered is too complex and breaks the fact that
order should depend on the frequency of use for garbage collection.

A possible fix is to make rt_intern_hash() simpler, and only makes
rt_check_expire() a litle bit smarter, being able to cope with an arbitrary
entries order. The added loop is running on cache hot data, while cpu
is prefetching next object, so should be unnoticied.

Reported-and-analyzed-by: Alexander V. Lukyanov <lav@yar.ru>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |   55 +++++++++++++++++--------------------------------------
 1 file changed, 17 insertions(+), 38 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -784,7 +784,7 @@ static void rt_check_expire(void)
 {
 	static unsigned int rover;
 	unsigned int i = rover, goal;
-	struct rtable *rth, **rthp;
+	struct rtable *rth, *aux, **rthp;
 	unsigned long samples = 0;
 	unsigned long sum = 0, sum2 = 0;
 	u64 mult;
@@ -812,6 +812,7 @@ static void rt_check_expire(void)
 		length = 0;
 		spin_lock_bh(rt_hash_lock_addr(i));
 		while ((rth = *rthp) != NULL) {
+			prefetch(rth->u.dst.rt_next);
 			if (rt_is_expired(rth)) {
 				*rthp = rth->u.dst.rt_next;
 				rt_free(rth);
@@ -820,33 +821,30 @@ static void rt_check_expire(void)
 			if (rth->u.dst.expires) {
 				/* Entry is expired even if it is in use */
 				if (time_before_eq(jiffies, rth->u.dst.expires)) {
+nofree:
 					tmo >>= 1;
 					rthp = &rth->u.dst.rt_next;
 					/*
-					 * Only bump our length if the hash
-					 * inputs on entries n and n+1 are not
-					 * the same, we only count entries on
+					 * We only count entries on
 					 * a chain with equal hash inputs once
 					 * so that entries for different QOS
 					 * levels, and other non-hash input
 					 * attributes don't unfairly skew
 					 * the length computation
 					 */
-					if ((*rthp == NULL) ||
-					    !compare_hash_inputs(&(*rthp)->fl,
-								 &rth->fl))
-						length += ONE;
+					for (aux = rt_hash_table[i].chain;;) {
+						if (aux == rth) {
+							length += ONE;
+							break;
+						}
+						if (compare_hash_inputs(&aux->fl, &rth->fl))
+							break;
+						aux = aux->u.dst.rt_next;
+					}
 					continue;
 				}
-			} else if (!rt_may_expire(rth, tmo, ip_rt_gc_timeout)) {
-				tmo >>= 1;
-				rthp = &rth->u.dst.rt_next;
-				if ((*rthp == NULL) ||
-				    !compare_hash_inputs(&(*rthp)->fl,
-							 &rth->fl))
-					length += ONE;
-				continue;
-			}
+			} else if (!rt_may_expire(rth, tmo, ip_rt_gc_timeout))
+				goto nofree;
 
 			/* Cleanup aged off entries. */
 			*rthp = rth->u.dst.rt_next;
@@ -1069,7 +1067,6 @@ out:	return 0;
 static int rt_intern_hash(unsigned hash, struct rtable *rt, struct rtable **rp)
 {
 	struct rtable	*rth, **rthp;
-	struct rtable	*rthi;
 	unsigned long	now;
 	struct rtable *cand, **candp;
 	u32 		min_score;
@@ -1089,7 +1086,6 @@ restart:
 	}
 
 	rthp = &rt_hash_table[hash].chain;
-	rthi = NULL;
 
 	spin_lock_bh(rt_hash_lock_addr(hash));
 	while ((rth = *rthp) != NULL) {
@@ -1135,17 +1131,6 @@ restart:
 		chain_length++;
 
 		rthp = &rth->u.dst.rt_next;
-
-		/*
-		 * check to see if the next entry in the chain
-		 * contains the same hash input values as rt.  If it does
-		 * This is where we will insert into the list, instead of
-		 * at the head.  This groups entries that differ by aspects not
-		 * relvant to the hash function together, which we use to adjust
-		 * our chain length
-		 */
-		if (*rthp && compare_hash_inputs(&(*rthp)->fl, &rt->fl))
-			rthi = rth;
 	}
 
 	if (cand) {
@@ -1206,10 +1191,7 @@ restart:
 		}
 	}
 
-	if (rthi)
-		rt->u.dst.rt_next = rthi->u.dst.rt_next;
-	else
-		rt->u.dst.rt_next = rt_hash_table[hash].chain;
+	rt->u.dst.rt_next = rt_hash_table[hash].chain;
 
 #if RT_CACHE_DEBUG >= 2
 	if (rt->u.dst.rt_next) {
@@ -1225,10 +1207,7 @@ restart:
 	 * previous writes to rt are comitted to memory
 	 * before making rt visible to other CPUS.
 	 */
-	if (rthi)
-		rcu_assign_pointer(rthi->u.dst.rt_next, rt);
-	else
-		rcu_assign_pointer(rt_hash_table[hash].chain, rt);
+	rcu_assign_pointer(rt_hash_table[hash].chain, rt);
 
 	spin_unlock_bh(rt_hash_lock_addr(hash));
 	*rp = rt;


