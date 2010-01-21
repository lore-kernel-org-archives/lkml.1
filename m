Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677Ab0AUEvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0AUEvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AUEvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:51:32 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60573 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0AUEva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=pKCLCzKqvxu79I987U9SpC2gqzcd2BioHrBMIEe6fj+e8Rn1fdu4k+ng7I/lE6r9QR
         2DsCGxzFm8tRrp+N3eLqZxOUNU1C6Gl45124BR/XKA0g69Svs7PfBHCUBalf2BzHf0hU
         270UtszocHZpoWhf+Hg9rxOkhcWZ1hanMv0mI=
From: Don Mullis <don.mullis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com,
       dedekind@infradead.org
Subject: [PATCH 1/2] lib: more scalable list_sort()
Date: Wed, 20 Jan 2010 20:51:26 -0800
Message-ID: <87fx609i29.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of list_sort() by UBIFS looks like it could generate long
lists; this alternative implementation scales better, reaching ~3x
performance gain as list length approaches the L2 cache size.

Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object
size is 552 bytes versus 405 for Mark J. Roberts' code.

Worst case for either implementation is a list length just over a POT,
and to roughly the same degree, so here are results for a range of
2^N+1 lengths.  List elements were 16 bytes each including malloc
overhead; random initial order.

                      time (msec)
                      Roberts
                      |       Mullis
loop_count  length    |       |    ratio
2000000       3     188     211    1.122
1000000       5     193     158    0.818
 500000       9     232     160    0.689
 250000      17     235     161    0.685
 125000      33     254     178    0.700
  62500      65     284     200    0.704
  31250     129     301     213    0.707
  15625     257     313     224    0.715
   7812     513     332     237    0.713
   3906    1025     361     261    0.722
   1953    2049     390     276    0.707  ~ L1 size
    976    4097     553     323    0.584
    488    8193     678     362    0.533
    244   16385     771     396    0.513
    122   32769     848     430    0.507
     61   65537     918     458    0.498
     30  131073    1216     550    0.452
     15  262145    2557     961    0.375  ~ L2 size
      7  524289    5650    1764    0.312
      3 1048577    6287    2141    0.340
      1 2097153    3650    1588    0.435


Mark's code does not actually implement the usual or generic
mergesort, but rather a variant from Simon Tatham described here:

    http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html

Simon's algorithm performs O(log N) passes over the entire input list,
doing merges of sublists that double in size on each pass.  The
generic algorithm instead merges pairs of equal length lists as early
as possible, in recursive order.  For either algorithm, the elements
that extend the list beyond power-of-two length are a special case
handled as nearly as possible as a "rounding-up" to a full POT.

Some intuition for the locality of reference implications of merge
order may be gotten by watching this animation:

    http://www.sorting-algorithms.com/merge-sort

Simon's algorithm requires only O(1) extra space rather than the
generic algorithm's O(log N), but in my non-recursive implementation
the actual O(log N) data is merely a vector of ~20 pointers, which
I've put on the stack.

Stability of the sort: distinct elements that compare equal emerge
from the sort in the same order as with Mark's code, for simple test
cases.

A kernel that uses drm.ko appears to run normally with this change; I
have no suitable hardware to similarly test the use by UBIFS.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
---
 lib/list_sort.c |  135 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 70 insertions(+), 65 deletions(-)

Index: linux-2.6/lib/list_sort.c
===================================================================
--- linux-2.6.orig/lib/list_sort.c	2010-01-19 20:10:31.000000000 -0800
+++ linux-2.6/lib/list_sort.c	2010-01-19 20:19:26.000000000 -0800
@@ -4,94 +4,99 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 
+#define MAX_LIST_SIZE_BITS 20
+
+static struct list_head *merge(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+static void restore_back_links(struct list_head *head)
+{
+	struct list_head *p;
+
+	for (p = head; p->next; p = p->next)
+		p->next->prev = p;
+	head->prev = p;
+}
+
 /**
  * list_sort - sort a list.
  * @priv: private data, passed to @cmp
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
- * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
- * in ascending order.
+ * This function implements "merge sort" which has O(nlog(n)) complexity.
+ * The list is sorted in ascending order.
  *
  * The comparison function @cmp is supposed to return a negative value if @a is
  * less than @b, and a positive value if @a is greater than @b. If @a and @b
  * are equivalent, then it does not matter what this function returns.
  */
 void list_sort(void *priv, struct list_head *head,
-	       int (*cmp)(void *priv, struct list_head *a,
-			  struct list_head *b))
+		int (*cmp)(void *priv, struct list_head *a,
+			struct list_head *b))
 {
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
+	struct list_head *part[MAX_LIST_SIZE_BITS+1]; /* sorted partial lists --
+							 last slot a sentinel */
+	int lev;  /* index into part[] */
+	int max_lev = -1;
+	struct list_head *list;
 
 	if (list_empty(head))
 		return;
 
+	memset(part, 0, sizeof(part));
+
+	/*
+	 * Rather than take time to maintain the back links through the merges,
+	 * we'll recreate them afterward.  Null-terminate the input list too.
+	 */
 	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
+	head->prev->next = NULL;
 
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(priv, p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
+	while (list) {
+		struct list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
+				printk_once(KERN_DEBUG "list passed to"
+					" list_sort() too long for"
+					" efficiency\n");
+				lev--;
 			}
-			p = q;
+			max_lev = lev;
 		}
+		part[lev] = cur;
+	}
 
-		tail->next = list;
-		list->prev = tail;
-
-		if (nmerges <= 1)
-			break;
+	for (lev = 0; lev <= max_lev; lev++)
+		list = merge(priv, cmp, list, part[lev]);
 
-		insize *= 2;
-	}
+	restore_back_links(list);
 
 	head->next = list;
 	head->prev = list->prev;
