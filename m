Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbYETAz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbYETAz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYETAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:55:50 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21373 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060AbYETAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:55:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <48322191.6060909@am.sony.com>
Date: Mon, 19 May 2008 17:55:45 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
CC: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: [patch v2] LMB: Add basic spin locking to lmb
References: <4829C07A.4040407@am.sony.com>	<1210834125.8297.80.camel@pasglop>	<1210834289.8297.85.camel@pasglop> <20080515.000203.225783838.davem@davemloft.net> <48321DF9.6060807@am.sony.com>
In-Reply-To: <48321DF9.6060807@am.sony.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2008 00:55:46.0591 (UTC) FILETIME=[3D0502F0:01C8BA14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a spinlock to struct lmb to enforce concurrency in
lmb_add(), lmb_remove(), lmb_analyze(), lmb_find(), and
lmb_dump_all().

This locking is needed for SMP systems that access the lmb structure
during hot memory add and remove operations after secondary cpus
have been started.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

v2: o Add locking to lmb_find().

 include/linux/lmb.h |    1 
 lib/lmb.c           |   62 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 14 deletions(-)

--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -30,6 +30,7 @@ struct lmb_region {
 };
 
 struct lmb {
+	spinlock_t lock;
 	unsigned long debug;
 	u64 rmo_size;
 	struct lmb_region memory;
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -32,28 +32,33 @@ early_param("lmb", early_lmb);
 void lmb_dump_all(void)
 {
 	unsigned long i;
+	struct lmb tmp;
 
 	if (!lmb_debug)
 		return;
 
+	spin_lock(&lmb.lock);
+	tmp = lmb;
+	spin_unlock(&lmb.lock);
+
 	pr_info("lmb_dump_all:\n");
-	pr_info("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
+	pr_info("    memory.cnt		  = 0x%lx\n", tmp.memory.cnt);
 	pr_info("    memory.size		  = 0x%llx\n",
-	    (unsigned long long)lmb.memory.size);
-	for (i=0; i < lmb.memory.cnt ;i++) {
+	    (unsigned long long)tmp.memory.size);
+	for (i=0; i < tmp.memory.cnt ;i++) {
 		pr_info("    memory.region[0x%lx].base       = 0x%llx\n",
-		    i, (unsigned long long)lmb.memory.region[i].base);
+		    i, (unsigned long long)tmp.memory.region[i].base);
 		pr_info("		      .size     = 0x%llx\n",
-		    (unsigned long long)lmb.memory.region[i].size);
+		    (unsigned long long)tmp.memory.region[i].size);
 	}
 
-	pr_info("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
-	pr_info("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
-	for (i=0; i < lmb.reserved.cnt ;i++) {
+	pr_info("    reserved.cnt	  = 0x%lx\n", tmp.reserved.cnt);
+	pr_info("    reserved.size	  = 0x%lx\n", tmp.reserved.size);
+	for (i=0; i < tmp.reserved.cnt ;i++) {
 		pr_info("    reserved.region[0x%lx].base       = 0x%llx\n",
-		    i, (unsigned long long)lmb.reserved.region[i].base);
+		    i, (unsigned long long)tmp.reserved.region[i].base);
 		pr_info("		      .size     = 0x%llx\n",
-		    (unsigned long long)lmb.reserved.region[i].size);
+		    (unsigned long long)tmp.reserved.region[i].size);
 	}
 }
 
@@ -105,6 +110,8 @@ static void lmb_coalesce_regions(struct 
 
 void __init lmb_init(void)
 {
+	spin_lock_init(&lmb.lock);
+
 	/* Create a dummy zero size LMB which will get coalesced away later.
 	 * This simplifies the lmb_add() code below...
 	 */
@@ -122,10 +129,14 @@ void __init lmb_analyze(void)
 {
 	int i;
 
+	spin_lock(&lmb.lock);
+
 	lmb.memory.size = 0;
 
 	for (i = 0; i < lmb.memory.cnt; i++)
 		lmb.memory.size += lmb.memory.region[i].size;
+
+	spin_unlock(&lmb.lock);
 }
 
 static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
@@ -194,18 +205,25 @@ static long lmb_add_region(struct lmb_re
 
 long lmb_add(u64 base, u64 size)
 {
+	long ret;
 	struct lmb_region *_rgn = &lmb.memory;
 
+	spin_lock(&lmb.lock);
+
 	/* On pSeries LPAR systems, the first LMB is our RMO region. */
 	if (base == 0)
 		lmb.rmo_size = size;
 
-	return lmb_add_region(_rgn, base, size);
+	ret = lmb_add_region(_rgn, base, size);
+
+	spin_unlock(&lmb.lock);
+	return ret;
 
 }
 
 long lmb_remove(u64 base, u64 size)
 {
+	long ret;
 	struct lmb_region *rgn = &(lmb.memory);
 	u64 rgnbegin, rgnend;
 	u64 end = base + size;
@@ -213,6 +231,8 @@ long lmb_remove(u64 base, u64 size)
 
 	rgnbegin = rgnend = 0; /* supress gcc warnings */
 
+	spin_lock(&lmb.lock);
+
 	/* Find the region where (base, size) belongs to */
 	for (i=0; i < rgn->cnt; i++) {
 		rgnbegin = rgn->region[i].base;
@@ -223,12 +243,15 @@ long lmb_remove(u64 base, u64 size)
 	}
 
 	/* Didn't find the region */
-	if (i == rgn->cnt)
+	if (i == rgn->cnt) {
+		spin_unlock(&lmb.lock);
 		return -1;
+	}
 
 	/* Check to see if we are removing entire region */
 	if ((rgnbegin == base) && (rgnend == end)) {
 		lmb_remove_region(rgn, i);
+		spin_unlock(&lmb.lock);
 		return 0;
 	}
 
@@ -236,12 +259,14 @@ long lmb_remove(u64 base, u64 size)
 	if (rgnbegin == base) {
 		rgn->region[i].base = end;
 		rgn->region[i].size -= size;
+		spin_unlock(&lmb.lock);
 		return 0;
 	}
 
 	/* Check to see if the region is matching at the end */
 	if (rgnend == end) {
 		rgn->region[i].size -= size;
+		spin_unlock(&lmb.lock);
 		return 0;
 	}
 
@@ -250,7 +275,10 @@ long lmb_remove(u64 base, u64 size)
 	 * beginging of the hole and add the region after hole.
 	 */
 	rgn->region[i].size = base - rgn->region[i].base;
-	return lmb_add_region(rgn, end, rgnend - end);
+	ret = lmb_add_region(rgn, end, rgnend - end);
+
+	spin_unlock(&lmb.lock);
+	return ret;
 }
 
 long __init lmb_reserve(u64 base, u64 size)
@@ -502,12 +530,16 @@ int lmb_find(struct lmb_property *res)
 	rstart = res->base;
 	rend = rstart + res->size - 1;
 
+	spin_lock(&lmb.lock);
+
 	for (i = 0; i < lmb.memory.cnt; i++) {
 		u64 start = lmb.memory.region[i].base;
 		u64 end = start + lmb.memory.region[i].size - 1;
 
-		if (start > rend)
+		if (start > rend) {
+			spin_unlock(&lmb.lock);
 			return -1;
+		}
 
 		if ((end >= rstart) && (start < rend)) {
 			/* adjust the request */
@@ -517,8 +549,10 @@ int lmb_find(struct lmb_property *res)
 				rend = end;
 			res->base = rstart;
 			res->size = rend - rstart + 1;
+			spin_unlock(&lmb.lock);
 			return 0;
 		}
 	}
+	spin_unlock(&lmb.lock);
 	return -1;
 }


