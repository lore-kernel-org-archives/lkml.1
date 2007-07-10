Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbXGJUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbXGJUFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXGJUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:05:44 -0400
Received: from mail.ccur.com ([66.10.65.12]:6444 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbXGJUFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:05:43 -0400
Subject: [PATCH] fix idr_get_new_above id alias bugs
From: Jim Houston <jim.houston@ccur.com>
Reply-To: jim.houston@ccur.com
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200707041611.30056.hnguyen@linux.vnet.ibm.com>
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
	 <1183422700.3130.27.camel@localhost.localdomain>
	 <200707041611.30056.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Concurrent Computer
Date: Tue, 10 Jul 2007 16:05:31 -0400
Message-Id: <1184097931.3020.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jul 2007 20:05:42.0134 (UTC) FILETIME=[B1722160:01C7C32D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Everyone,

Hoang-Nam Nguyen reported a bug in idr_get_new_above() 
which occurred with a starting id value like 0x3ffffffc.
His test module easily reproduced the problem.  Thanks.

The test revealed the following bugs:

1. Relying on shift operations which have undefined results
   e.g.: 1 << n where n > word size.  On i386 an integer shift
   only uses the low 5 bits of the shift count.

2. An off by one error which prevented the top most layer
   of the radix tree from being allocated.  This meant that
   sub_alloc() would allocate an entry in the existing portion
   of the radix tree which aliased the requested address.  When
   it tried to allocate id 0x40000000, it might use the slot 
   belonging to id 0.

3. There was also a failure in the code which walked back up
   the tree if an allocation failed.  The normal case is to
   descend the tree checking the starting id value against the
   bitmap at each level.  If the bit is set, we know that the
   entire sub-tree is full and we can short cut the search.
   We may still descend to the lowest level and find that the
   portion of the id space we want is full.  In this case we
   need to walk back up the tree and continue the search.
   The existing code just returned to the previous level and
   continued.  This resulted in an attempt to allocate an id
   above 0x3ffffffc using the slot for id 0x3ffffc00 instead of
   0x40000000 which it then claimed to have allocated.  The same
   problem occurs with 0x3ff as the requested id value if it
   is already in use.

With this patch, idr.c should work as advertised allocating id
values in the range 0...0x7fffffff.  Andrew had speculated that
it should allow the full range 0...0xffffffff to be used.  I was
tempted to make changes to allow this, but it would require changes
to API, e.g. making the starting id value and the return value
unsigned.

Signed-off-by: Jim Houston <jim.houston@ccur.com>

--

Index: linux-2.6.22-rc7/include/linux/idr.h
===================================================================
--- linux-2.6.22-rc7.orig/include/linux/idr.h	2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.22-rc7/include/linux/idr.h	2007-07-06 16:46:31.000000000 -0400
@@ -18,17 +18,9 @@
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
 # define IDR_FULL 0xfffffffful
-/* We can only use two of the bits in the top level because there is
-   only one possible bit in the top level (5 bits * 7 levels = 35
-   bits, but you only use 31 bits in the id). */
-# define TOP_LEVEL_FULL (IDR_FULL >> 30)
 #elif BITS_PER_LONG == 64
 # define IDR_BITS 6
 # define IDR_FULL 0xfffffffffffffffful
-/* We can only use two of the bits in the top level because there is
-   only one possible bit in the top level (6 bits * 6 levels = 36
-   bits, but you only use 31 bits in the id). */
-# define TOP_LEVEL_FULL (IDR_FULL >> 62)
 #else
 # error "BITS_PER_LONG is not 32 or 64"
 #endif
Index: linux-2.6.22-rc7/lib/idr.c
===================================================================
--- linux-2.6.22-rc7.orig/lib/idr.c	2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.22-rc7/lib/idr.c	2007-07-10 11:05:19.000000000 -0400
@@ -105,8 +105,8 @@
 
 	id = *starting_id;
 	p = idp->top;
-	l = idp->layers;
-	pa[l--] = NULL;
+	l = idp->layers - 1;
+	pa[l] = NULL;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...
@@ -117,8 +117,14 @@
 		if (m == IDR_SIZE) {
 			/* no space available go back to previous layer. */
 			l++;
-			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
-			if (!(p = pa[l])) {
+			id = (id | ((1 << (IDR_BITS * l)) - 1));
+			while (((id >> (IDR_BITS * l)) & IDR_MASK) == IDR_MASK)
+				l++;
+			id++;
+			p = pa[l-1];
+			if ((id >= MAX_ID_BIT) || (id < 0))
+				return -3;
+			if (!p) {
 				*starting_id = id;
 				return -2;
 			}
@@ -141,7 +147,7 @@
 			p->ary[m] = new;
 			p->count++;
 		}
-		pa[l--] = p;
+		pa[--l] = p;
 		p = p->ary[m];
 	}
 	/*
@@ -159,7 +165,7 @@
 	 */
 	n = id;
 	while (p->bitmap == IDR_FULL) {
-		if (!(p = pa[++l]))
+		if (!(p = pa[l++]))
 			break;
 		n = n >> IDR_BITS;
 		__set_bit((n & IDR_MASK), &p->bitmap);
@@ -186,7 +192,7 @@
 	 * Add a new layer to the top of the tree if the requested
 	 * id is larger than the currently allocated space.
 	 */
-	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
+	while ((layers < MAX_LEVEL) && (id & ((~0) << (layers*IDR_BITS)))) {
 		layers++;
 		if (!p->count)
 			continue;
@@ -299,7 +305,7 @@
 static void sub_remove(struct idr *idp, int shift, int id)
 {
 	struct idr_layer *p = idp->top;
-	struct idr_layer **pa[MAX_LEVEL];
+	struct idr_layer **pa[MAX_LEVEL+1];
 	struct idr_layer ***paa = &pa[0];
 	int n;
 
@@ -392,7 +398,7 @@
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
 
-	if (id >= (1 << n))
+	if ((n <= MAX_ID_SHIFT) && (id & ((~0) << n)))
 		return NULL;
 
 	while (n > 0 && p) {
@@ -425,7 +431,7 @@
 
 	id &= MAX_ID_MASK;
 
-	if (id >= (1 << n))
+	if ((n <= MAX_ID_SHIFT) && (id & ((~0) << n)))
 		return ERR_PTR(-EINVAL);
 
 	n -= IDR_BITS;






