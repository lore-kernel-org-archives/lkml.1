Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbXJIXXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbXJIXXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXJIXXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:23:43 -0400
Received: from namei.org ([69.55.235.186]:44268 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751836AbXJIXXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:23:41 -0400
Date: Wed, 10 Oct 2007 09:23:04 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 5/6] SELinux: improve performance when AVC misses
In-Reply-To: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0710100922190.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: KaiGai Kohei <kaigai@ak.jp.nec.com>

* We add ebitmap_for_each_positive_bit() which enables to walk on
  any positive bit on the given ebitmap, to improve its performance
  using common bit-operations defined in linux/bitops.h.
  In the previous version, this logic was implemented using a combination
  of ebitmap_for_each_bit() and ebitmap_node_get_bit(), but is was worse
  in performance aspect.
  This logic is most frequestly used to compute a new AVC entry,
  so this patch can improve SELinux performance when AVC misses are happen.
* struct ebitmap_node is redefined as an array of "unsigned long", to get
  suitable for using find_next_bit() which is fasted than iteration of
  shift and logical operation, and to maximize memory usage allocated
  from general purpose slab.
* Any ebitmap_for_each_bit() are repleced by the new implementation
  in ss/service.c and ss/mls.c. Some of related implementation are
  changed, however, there is no incompatibility with the previous
  version.
* The width of any new line are less or equal than 80-chars.

The following benchmark shows the effect of this patch, when we
access many files which have different security context one after
another. The number is more than /selinux/avc/cache_threshold, so
any access always causes AVC misses.

      selinux-2.6      selinux-2.6-ebitmap
AVG:   22.763 [s]          8.750 [s]
STD:    0.265              0.019
------------------------------------------
1st:   22.558 [s]          8.786 [s]
2nd:   22.458 [s]          8.750 [s]
3rd:   22.478 [s]          8.754 [s]
4th:   22.724 [s]          8.745 [s]
5th:   22.918 [s]          8.748 [s]
6th:   22.905 [s]          8.764 [s]
7th:   23.238 [s]          8.726 [s]
8th:   22.822 [s]          8.729 [s]

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/ebitmap.c  |  281 ++++++++++++++++++++++-----------------
 security/selinux/ss/ebitmap.h  |   87 ++++++++++---
 security/selinux/ss/mls.c      |  156 +++++++++++------------
 security/selinux/ss/services.c |   16 +--
 4 files changed, 303 insertions(+), 237 deletions(-)

diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index ce492a6..ae44c0c 100644
--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -10,6 +10,10 @@
  *
  * (c) Copyright Hewlett-Packard Development Company, L.P., 2006
  */
+/*
+ * Updated: KaiGai Kohei <kaigai@ak.jp.nec.com>
+ *      Applied standard bit operations to improve bitmap scanning.
+ */
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -29,7 +33,7 @@ int ebitmap_cmp(struct ebitmap *e1, struct ebitmap *e2)
 	n2 = e2->node;
 	while (n1 && n2 &&
 	       (n1->startbit == n2->startbit) &&
-	       (n1->map == n2->map)) {
+	       !memcmp(n1->maps, n2->maps, EBITMAP_SIZE / 8)) {
 		n1 = n1->next;
 		n2 = n2->next;
 	}
@@ -54,7 +58,7 @@ int ebitmap_cpy(struct ebitmap *dst, struct ebitmap *src)
 			return -ENOMEM;
 		}
 		new->startbit = n->startbit;
-		new->map = n->map;
+		memcpy(new->maps, n->maps, EBITMAP_SIZE / 8);
 		new->next = NULL;
 		if (prev)
 			prev->next = new;
@@ -84,13 +88,15 @@ int ebitmap_netlbl_export(struct ebitmap *ebmap,
 {
 	struct ebitmap_node *e_iter = ebmap->node;
 	struct netlbl_lsm_secattr_catmap *c_iter;
-	u32 cmap_idx;
+	u32 cmap_idx, cmap_sft;
+	int i;
 
-	/* This function is a much simpler because SELinux's MAPTYPE happens
-	 * to be the same as NetLabel's NETLBL_CATMAP_MAPTYPE, if MAPTYPE is
-	 * changed from a u64 this function will most likely need to be changed
-	 * as well.  It's not ideal but I think the tradeoff in terms of
-	 * neatness and speed is worth it. */
+	/* NetLabel's NETLBL_CATMAP_MAPTYPE is defined as an array of u64,
+	 * however, it is not always compatible with an array of unsigned long
+	 * in ebitmap_node.
+	 * In addition, you should pay attention the following implementation
+	 * assumes unsigned long has a width equal with or less than 64-bit.
+	 */
 
 	if (e_iter == NULL) {
 		*catmap = NULL;
@@ -104,19 +110,27 @@ int ebitmap_netlbl_export(struct ebitmap *ebmap,
 	c_iter->startbit = e_iter->startbit & ~(NETLBL_CATMAP_SIZE - 1);
 
 	while (e_iter != NULL) {
-		if (e_iter->startbit >=
-		    (c_iter->startbit + NETLBL_CATMAP_SIZE)) {
-			c_iter->next = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
-			if (c_iter->next == NULL)
-				goto netlbl_export_failure;
-			c_iter = c_iter->next;
-			c_iter->startbit = e_iter->startbit &
-				           ~(NETLBL_CATMAP_SIZE - 1);
+		for (i = 0; i < EBITMAP_UNIT_NUMS; i++) {
+			unsigned int delta, e_startbit, c_endbit;
+
+			e_startbit = e_iter->startbit + i * EBITMAP_UNIT_SIZE;
+			c_endbit = c_iter->startbit + NETLBL_CATMAP_SIZE;
+			if (e_startbit >= c_endbit) {
+				c_iter->next
+				  = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+				if (c_iter->next == NULL)
+					goto netlbl_export_failure;
+				c_iter = c_iter->next;
+				c_iter->startbit
+				  = e_startbit & ~(NETLBL_CATMAP_SIZE - 1);
+			}
+			delta = e_startbit - c_iter->startbit;
+			cmap_idx = delta / NETLBL_CATMAP_MAPSIZE;
+			cmap_sft = delta % NETLBL_CATMAP_MAPSIZE;
+			c_iter->bitmap[cmap_idx]
+				|= e_iter->maps[cmap_idx] << cmap_sft;
+			e_iter = e_iter->next;
 		}
-		cmap_idx = (e_iter->startbit - c_iter->startbit) /
-			   NETLBL_CATMAP_MAPSIZE;
-		c_iter->bitmap[cmap_idx] = e_iter->map;
-		e_iter = e_iter->next;
 	}
 
 	return 0;
@@ -128,7 +142,7 @@ netlbl_export_failure:
 
 /**
  * ebitmap_netlbl_import - Import a NetLabel category bitmap into an ebitmap
- * @ebmap: the ebitmap to export
+ * @ebmap: the ebitmap to import
  * @catmap: the NetLabel category bitmap
  *
  * Description:
@@ -142,36 +156,50 @@ int ebitmap_netlbl_import(struct ebitmap *ebmap,
 	struct ebitmap_node *e_iter = NULL;
 	struct ebitmap_node *emap_prev = NULL;
 	struct netlbl_lsm_secattr_catmap *c_iter = catmap;
-	u32 c_idx;
+	u32 c_idx, c_pos, e_idx, e_sft;
 
-	/* This function is a much simpler because SELinux's MAPTYPE happens
-	 * to be the same as NetLabel's NETLBL_CATMAP_MAPTYPE, if MAPTYPE is
-	 * changed from a u64 this function will most likely need to be changed
-	 * as well.  It's not ideal but I think the tradeoff in terms of
-	 * neatness and speed is worth it. */
+	/* NetLabel's NETLBL_CATMAP_MAPTYPE is defined as an array of u64,
+	 * however, it is not always compatible with an array of unsigned long
+	 * in ebitmap_node.
+	 * In addition, you should pay attention the following implementation
+	 * assumes unsigned long has a width equal with or less than 64-bit.
+	 */
 
 	do {
 		for (c_idx = 0; c_idx < NETLBL_CATMAP_MAPCNT; c_idx++) {
-			if (c_iter->bitmap[c_idx] == 0)
+			unsigned int delta;
+			u64 map = c_iter->bitmap[c_idx];
+
+			if (!map)
 				continue;
 
-			e_iter = kzalloc(sizeof(*e_iter), GFP_ATOMIC);
-			if (e_iter == NULL)
-				goto netlbl_import_failure;
-			if (emap_prev == NULL)
-				ebmap->node = e_iter;
-			else
-				emap_prev->next = e_iter;
-			emap_prev = e_iter;
-
-			e_iter->startbit = c_iter->startbit +
-				           NETLBL_CATMAP_MAPSIZE * c_idx;
-			e_iter->map = c_iter->bitmap[c_idx];
+			c_pos = c_iter->startbit
+				+ c_idx * NETLBL_CATMAP_MAPSIZE;
+			if (!e_iter
+			    || c_pos >= e_iter->startbit + EBITMAP_SIZE) {
+				e_iter = kzalloc(sizeof(*e_iter), GFP_ATOMIC);
+				if (!e_iter)
+					goto netlbl_import_failure;
+				e_iter->startbit
+					= c_pos - (c_pos % EBITMAP_SIZE);
+				if (emap_prev == NULL)
+					ebmap->node = e_iter;
+				else
+					emap_prev->next = e_iter;
+				emap_prev = e_iter;
+			}
+			delta = c_pos - e_iter->startbit;
+			e_idx = delta / EBITMAP_UNIT_SIZE;
+			e_sft = delta % EBITMAP_UNIT_SIZE;
+			while (map) {
+				e_iter->maps[e_idx++] |= map & (-1UL);
+				map >>= EBITMAP_UNIT_SIZE;
+			}
 		}
 		c_iter = c_iter->next;
 	} while (c_iter != NULL);
 	if (e_iter != NULL)
-		ebmap->highbit = e_iter->startbit + MAPSIZE;
+		ebmap->highbit = e_iter->startbit + EBITMAP_SIZE;
 	else
 		ebitmap_destroy(ebmap);
 
@@ -186,6 +214,7 @@ netlbl_import_failure:
 int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
 {
 	struct ebitmap_node *n1, *n2;
+	int i;
 
 	if (e1->highbit < e2->highbit)
 		return 0;
@@ -197,8 +226,10 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
 			n1 = n1->next;
 			continue;
 		}
-		if ((n1->map & n2->map) != n2->map)
-			return 0;
+		for (i = 0; i < EBITMAP_UNIT_NUMS; i++) {
+			if ((n1->maps[i] & n2->maps[i]) != n2->maps[i])
+				return 0;
+		}
 
 		n1 = n1->next;
 		n2 = n2->next;
@@ -219,12 +250,8 @@ int ebitmap_get_bit(struct ebitmap *e, unsigned long bit)
 
 	n = e->node;
 	while (n && (n->startbit <= bit)) {
-		if ((n->startbit + MAPSIZE) > bit) {
-			if (n->map & (MAPBIT << (bit - n->startbit)))
-				return 1;
-			else
-				return 0;
-		}
+		if ((n->startbit + EBITMAP_SIZE) > bit)
+			return ebitmap_node_get_bit(n, bit);
 		n = n->next;
 	}
 
@@ -238,31 +265,35 @@ int ebitmap_set_bit(struct ebitmap *e, unsigned long bit, int value)
 	prev = NULL;
 	n = e->node;
 	while (n && n->startbit <= bit) {
-		if ((n->startbit + MAPSIZE) > bit) {
+		if ((n->startbit + EBITMAP_SIZE) > bit) {
 			if (value) {
-				n->map |= (MAPBIT << (bit - n->startbit));
+				ebitmap_node_set_bit(n, bit);
 			} else {
-				n->map &= ~(MAPBIT << (bit - n->startbit));
-				if (!n->map) {
-					/* drop this node from the bitmap */
-
-					if (!n->next) {
-						/*
-						 * this was the highest map
-						 * within the bitmap
-						 */
-						if (prev)
-							e->highbit = prev->startbit + MAPSIZE;
-						else
-							e->highbit = 0;
-					}
+				unsigned int s;
+
+				ebitmap_node_clr_bit(n, bit);
+
+				s = find_first_bit(n->maps, EBITMAP_SIZE);
+				if (s < EBITMAP_SIZE)
+					return 0;
+
+				/* drop this node from the bitmap */
+				if (!n->next) {
+					/*
+					 * this was the highest map
+					 * within the bitmap
+					 */
 					if (prev)
-						prev->next = n->next;
+						e->highbit = prev->startbit
+							     + EBITMAP_SIZE;
 					else
-						e->node = n->next;
-
-					kfree(n);
+						e->highbit = 0;
 				}
+				if (prev)
+					prev->next = n->next;
+				else
+					e->node = n->next;
+				kfree(n);
 			}
 			return 0;
 		}
@@ -277,12 +308,12 @@ int ebitmap_set_bit(struct ebitmap *e, unsigned long bit, int value)
 	if (!new)
 		return -ENOMEM;
 
-	new->startbit = bit & ~(MAPSIZE - 1);
-	new->map = (MAPBIT << (bit - new->startbit));
+	new->startbit = bit - (bit % EBITMAP_SIZE);
+	ebitmap_node_set_bit(new, bit);
 
 	if (!n)
 		/* this node will be the highest map within the bitmap */
-		e->highbit = new->startbit + MAPSIZE;
+		e->highbit = new->startbit + EBITMAP_SIZE;
 
 	if (prev) {
 		new->next = prev->next;
@@ -316,11 +347,11 @@ void ebitmap_destroy(struct ebitmap *e)
 
 int ebitmap_read(struct ebitmap *e, void *fp)
 {
-	int rc;
-	struct ebitmap_node *n, *l;
+	struct ebitmap_node *n = NULL;
+	u32 mapunit, count, startbit, index;
+	u64 map;
 	__le32 buf[3];
-	u32 mapsize, count, i;
-	__le64 map;
+	int rc, i;
 
 	ebitmap_init(e);
 
@@ -328,85 +359,89 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 	if (rc < 0)
 		goto out;
 
-	mapsize = le32_to_cpu(buf[0]);
+	mapunit = le32_to_cpu(buf[0]);
 	e->highbit = le32_to_cpu(buf[1]);
 	count = le32_to_cpu(buf[2]);
 
-	if (mapsize != MAPSIZE) {
+	if (mapunit != sizeof(u64) * 8) {
 		printk(KERN_ERR "security: ebitmap: map size %u does not "
-		       "match my size %Zd (high bit was %d)\n", mapsize,
-		       MAPSIZE, e->highbit);
+		       "match my size %Zd (high bit was %d)\n",
+		       mapunit, sizeof(u64) * 8, e->highbit);
 		goto bad;
 	}
+
+	/* round up e->highbit */
+	e->highbit += EBITMAP_SIZE - 1;
+	e->highbit -= (e->highbit % EBITMAP_SIZE);
+
 	if (!e->highbit) {
 		e->node = NULL;
 		goto ok;
 	}
-	if (e->highbit & (MAPSIZE - 1)) {
-		printk(KERN_ERR "security: ebitmap: high bit (%d) is not a "
-		       "multiple of the map size (%Zd)\n", e->highbit, MAPSIZE);
-		goto bad;
-	}
-	l = NULL;
+
 	for (i = 0; i < count; i++) {
-		rc = next_entry(buf, fp, sizeof(u32));
+		rc = next_entry(&startbit, fp, sizeof(u32));
 		if (rc < 0) {
 			printk(KERN_ERR "security: ebitmap: truncated map\n");
 			goto bad;
 		}
-		n = kzalloc(sizeof(*n), GFP_KERNEL);
-		if (!n) {
-			printk(KERN_ERR "security: ebitmap: out of memory\n");
-			rc = -ENOMEM;
-			goto bad;
-		}
-
-		n->startbit = le32_to_cpu(buf[0]);
+		startbit = le32_to_cpu(startbit);
 
-		if (n->startbit & (MAPSIZE - 1)) {
+		if (startbit & (mapunit - 1)) {
 			printk(KERN_ERR "security: ebitmap start bit (%d) is "
-			       "not a multiple of the map size (%Zd)\n",
-			       n->startbit, MAPSIZE);
-			goto bad_free;
+			       "not a multiple of the map unit size (%Zd)\n",
+			       startbit, mapunit);
+			goto bad;
 		}
-		if (n->startbit > (e->highbit - MAPSIZE)) {
+		if (startbit > e->highbit - mapunit) {
 			printk(KERN_ERR "security: ebitmap start bit (%d) is "
 			       "beyond the end of the bitmap (%Zd)\n",
-			       n->startbit, (e->highbit - MAPSIZE));
-			goto bad_free;
+			       startbit, (e->highbit - mapunit));
+			goto bad;
+		}
+
+		if (!n || startbit >= n->startbit + EBITMAP_SIZE) {
+			struct ebitmap_node *tmp;
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+			if (!tmp) {
+				printk(KERN_ERR
+				       "security: ebitmap: out of memory\n");
+				rc = -ENOMEM;
+				goto bad;
+			}
+			/* round down */
+			tmp->startbit = startbit - (startbit % EBITMAP_SIZE);
+			if (n) {
+				n->next = tmp;
+			} else {
+				e->node = tmp;
+			}
+			n = tmp;
+		} else if (startbit <= n->startbit) {
+			printk(KERN_ERR "security: ebitmap: start bit %d"
+			       " comes after start bit %d\n",
+			       startbit, n->startbit);
+			goto bad;
 		}
+
 		rc = next_entry(&map, fp, sizeof(u64));
 		if (rc < 0) {
 			printk(KERN_ERR "security: ebitmap: truncated map\n");
-			goto bad_free;
+			goto bad;
 		}
-		n->map = le64_to_cpu(map);
+		map = le64_to_cpu(map);
 
-		if (!n->map) {
-			printk(KERN_ERR "security: ebitmap: null map in "
-			       "ebitmap (startbit %d)\n", n->startbit);
-			goto bad_free;
+		index = (startbit - n->startbit) / EBITMAP_UNIT_SIZE;
+		while (map) {
+			n->maps[index] = map & (-1UL);
+			map = map >> EBITMAP_UNIT_SIZE;
+			index++;
 		}
-		if (l) {
-			if (n->startbit <= l->startbit) {
-				printk(KERN_ERR "security: ebitmap: start "
-				       "bit %d comes after start bit %d\n",
-				       n->startbit, l->startbit);
-				goto bad_free;
-			}
-			l->next = n;
-		} else
-			e->node = n;
-
-		l = n;
 	}
-
 ok:
 	rc = 0;
 out:
 	return rc;
-bad_free:
-	kfree(n);
 bad:
 	if (!rc)
 		rc = -EINVAL;
diff --git a/security/selinux/ss/ebitmap.h b/security/selinux/ss/ebitmap.h
index 1270e34..e38a327 100644
--- a/security/selinux/ss/ebitmap.h
+++ b/security/selinux/ss/ebitmap.h
@@ -16,14 +16,16 @@
 
 #include <net/netlabel.h>
 
-#define MAPTYPE u64			/* portion of bitmap in each node */
-#define MAPSIZE (sizeof(MAPTYPE) * 8)	/* number of bits in node bitmap */
-#define MAPBIT  1ULL			/* a bit in the node bitmap */
+#define EBITMAP_UNIT_NUMS	((32 - sizeof(void *) - sizeof(u32))	\
+					/ sizeof(unsigned long))
+#define EBITMAP_UNIT_SIZE	BITS_PER_LONG
+#define EBITMAP_SIZE		(EBITMAP_UNIT_NUMS * EBITMAP_UNIT_SIZE)
+#define EBITMAP_BIT		1ULL
 
 struct ebitmap_node {
-	u32 startbit;		/* starting position in the total bitmap */
-	MAPTYPE map;		/* this node's portion of the bitmap */
 	struct ebitmap_node *next;
+	unsigned long maps[EBITMAP_UNIT_NUMS];
+	u32 startbit;
 };
 
 struct ebitmap {
@@ -34,11 +36,17 @@ struct ebitmap {
 #define ebitmap_length(e) ((e)->highbit)
 #define ebitmap_startbit(e) ((e)->node ? (e)->node->startbit : 0)
 
-static inline unsigned int ebitmap_start(struct ebitmap *e,
-					 struct ebitmap_node **n)
+static inline unsigned int ebitmap_start_positive(struct ebitmap *e,
+						  struct ebitmap_node **n)
 {
-	*n = e->node;
-	return ebitmap_startbit(e);
+	unsigned int ofs;
+
+	for (*n = e->node; *n; *n = (*n)->next) {
+		ofs = find_first_bit((*n)->maps, EBITMAP_SIZE);
+		if (ofs < EBITMAP_SIZE)
+			return (*n)->startbit + ofs;
+	}
+	return ebitmap_length(e);
 }
 
 static inline void ebitmap_init(struct ebitmap *e)
@@ -46,28 +54,65 @@ static inline void ebitmap_init(struct ebitmap *e)
 	memset(e, 0, sizeof(*e));
 }
 
-static inline unsigned int ebitmap_next(struct ebitmap_node **n,
-					unsigned int bit)
+static inline unsigned int ebitmap_next_positive(struct ebitmap *e,
+						 struct ebitmap_node **n,
+						 unsigned int bit)
 {
-	if ((bit == ((*n)->startbit + MAPSIZE - 1)) &&
-	    (*n)->next) {
-		*n = (*n)->next;
-		return (*n)->startbit;
-	}
+	unsigned int ofs;
+
+	ofs = find_next_bit((*n)->maps, EBITMAP_SIZE, bit - (*n)->startbit + 1);
+	if (ofs < EBITMAP_SIZE)
+		return ofs + (*n)->startbit;
 
-	return (bit+1);
+	for (*n = (*n)->next; *n; *n = (*n)->next) {
+		ofs = find_first_bit((*n)->maps, EBITMAP_SIZE);
+		if (ofs < EBITMAP_SIZE)
+			return ofs + (*n)->startbit;
+	}
+	return ebitmap_length(e);
 }
 
-static inline int ebitmap_node_get_bit(struct ebitmap_node * n,
+#define EBITMAP_NODE_INDEX(node, bit)	\
+	(((bit) - (node)->startbit) / EBITMAP_UNIT_SIZE)
+#define EBITMAP_NODE_OFFSET(node, bit)	\
+	(((bit) - (node)->startbit) % EBITMAP_UNIT_SIZE)
+
+static inline int ebitmap_node_get_bit(struct ebitmap_node *n,
 				       unsigned int bit)
 {
-	if (n->map & (MAPBIT << (bit - n->startbit)))
+	unsigned int index = EBITMAP_NODE_INDEX(n, bit);
+	unsigned int ofs = EBITMAP_NODE_OFFSET(n, bit);
+
+	BUG_ON(index >= EBITMAP_UNIT_NUMS);
+	if ((n->maps[index] & (EBITMAP_BIT << ofs)))
 		return 1;
 	return 0;
 }
 
-#define ebitmap_for_each_bit(e, n, bit) \
-	for (bit = ebitmap_start(e, &n); bit < ebitmap_length(e); bit = ebitmap_next(&n, bit)) \
+static inline void ebitmap_node_set_bit(struct ebitmap_node *n,
+					unsigned int bit)
+{
+	unsigned int index = EBITMAP_NODE_INDEX(n, bit);
+	unsigned int ofs = EBITMAP_NODE_OFFSET(n, bit);
+
+	BUG_ON(index >= EBITMAP_UNIT_NUMS);
+	n->maps[index] |= (EBITMAP_BIT << ofs);
+}
+
+static inline void ebitmap_node_clr_bit(struct ebitmap_node *n,
+					unsigned int bit)
+{
+	unsigned int index = EBITMAP_NODE_INDEX(n, bit);
+	unsigned int ofs = EBITMAP_NODE_OFFSET(n, bit);
+
+	BUG_ON(index >= EBITMAP_UNIT_NUMS);
+	n->maps[index] &= ~(EBITMAP_BIT << ofs);
+}
+
+#define ebitmap_for_each_positive_bit(e, n, bit)	\
+	for (bit = ebitmap_start_positive(e, &n);	\
+	     bit < ebitmap_length(e);			\
+	     bit = ebitmap_next_positive(e, &n, bit))	\
 
 int ebitmap_cmp(struct ebitmap *e1, struct ebitmap *e2);
 int ebitmap_cpy(struct ebitmap *dst, struct ebitmap *src);
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 4a8bab2..9a11dea 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -34,7 +34,9 @@
  */
 int mls_compute_context_len(struct context * context)
 {
-	int i, l, len, range;
+	int i, l, len, head, prev;
+	char *nm;
+	struct ebitmap *e;
 	struct ebitmap_node *node;
 
 	if (!selinux_mls_enabled)
@@ -42,31 +44,33 @@ int mls_compute_context_len(struct context * context)
 
 	len = 1; /* for the beginning ":" */
 	for (l = 0; l < 2; l++) {
-		range = 0;
-		len += strlen(policydb.p_sens_val_to_name[context->range.level[l].sens - 1]);
-
-		ebitmap_for_each_bit(&context->range.level[l].cat, node, i) {
-			if (ebitmap_node_get_bit(node, i)) {
-				if (range) {
-					range++;
-					continue;
-				}
+		int index_sens = context->range.level[l].sens;
+		len += strlen(policydb.p_sens_val_to_name[index_sens - 1]);
 
-				len += strlen(policydb.p_cat_val_to_name[i]) + 1;
-				range++;
-			} else {
-				if (range > 1)
-					len += strlen(policydb.p_cat_val_to_name[i - 1]) + 1;
-				range = 0;
+		/* categories */
+		head = -2;
+		prev = -2;
+		e = &context->range.level[l].cat;
+		ebitmap_for_each_positive_bit(e, node, i) {
+			if (i - prev > 1) {
+				/* one or more negative bits are skipped */
+				if (head != prev) {
+					nm = policydb.p_cat_val_to_name[prev];
+					len += strlen(nm) + 1;
+				}
+				nm = policydb.p_cat_val_to_name[i];
+				len += strlen(nm) + 1;
+				head = i;
 			}
+			prev = i;
+		}
+		if (prev != head) {
+			nm = policydb.p_cat_val_to_name[prev];
+			len += strlen(nm) + 1;
 		}
-		/* Handle case where last category is the end of range */
-		if (range > 1)
-			len += strlen(policydb.p_cat_val_to_name[i - 1]) + 1;
-
 		if (l == 0) {
 			if (mls_level_eq(&context->range.level[0],
-			                 &context->range.level[1]))
+					 &context->range.level[1]))
 				break;
 			else
 				len++;
@@ -84,8 +88,9 @@ int mls_compute_context_len(struct context * context)
 void mls_sid_to_context(struct context *context,
                         char **scontext)
 {
-	char *scontextp;
-	int i, l, range, wrote_sep;
+	char *scontextp, *nm;
+	int i, l, head, prev;
+	struct ebitmap *e;
 	struct ebitmap_node *node;
 
 	if (!selinux_mls_enabled)
@@ -97,61 +102,54 @@ void mls_sid_to_context(struct context *context,
 	scontextp++;
 
 	for (l = 0; l < 2; l++) {
-		range = 0;
-		wrote_sep = 0;
 		strcpy(scontextp,
 		       policydb.p_sens_val_to_name[context->range.level[l].sens - 1]);
-		scontextp += strlen(policydb.p_sens_val_to_name[context->range.level[l].sens - 1]);
+		scontextp += strlen(scontextp);
 
 		/* categories */
-		ebitmap_for_each_bit(&context->range.level[l].cat, node, i) {
-			if (ebitmap_node_get_bit(node, i)) {
-				if (range) {
-					range++;
-					continue;
-				}
-
-				if (!wrote_sep) {
-					*scontextp++ = ':';
-					wrote_sep = 1;
-				} else
-					*scontextp++ = ',';
-				strcpy(scontextp, policydb.p_cat_val_to_name[i]);
-				scontextp += strlen(policydb.p_cat_val_to_name[i]);
-				range++;
-			} else {
-				if (range > 1) {
-					if (range > 2)
+		head = -2;
+		prev = -2;
+		e = &context->range.level[l].cat;
+		ebitmap_for_each_positive_bit(e, node, i) {
+			if (i - prev > 1) {
+				/* one or more negative bits are skipped */
+				if (prev != head) {
+					if (prev - head > 1)
 						*scontextp++ = '.';
 					else
 						*scontextp++ = ',';
-
-					strcpy(scontextp, policydb.p_cat_val_to_name[i - 1]);
-					scontextp += strlen(policydb.p_cat_val_to_name[i - 1]);
+					nm = policydb.p_cat_val_to_name[prev];
+					strcpy(scontextp, nm);
+					scontextp += strlen(nm);
 				}
-				range = 0;
+				if (prev < 0)
+					*scontextp++ = ':';
+				else
+					*scontextp++ = ',';
+				nm = policydb.p_cat_val_to_name[i];
+				strcpy(scontextp, nm);
+				scontextp += strlen(nm);
+				head = i;
 			}
+			prev = i;
 		}
 
-		/* Handle case where last category is the end of range */
-		if (range > 1) {
-			if (range > 2)
+		if (prev != head) {
+			if (prev - head > 1)
 				*scontextp++ = '.';
 			else
 				*scontextp++ = ',';
-
-			strcpy(scontextp, policydb.p_cat_val_to_name[i - 1]);
-			scontextp += strlen(policydb.p_cat_val_to_name[i - 1]);
+			nm = policydb.p_cat_val_to_name[prev];
+			strcpy(scontextp, nm);
+			scontextp += strlen(nm);
 		}
 
 		if (l == 0) {
 			if (mls_level_eq(&context->range.level[0],
 			                 &context->range.level[1]))
 				break;
-			else {
-				*scontextp = '-';
-				scontextp++;
-			}
+			else
+				*scontextp++ = '-';
 		}
 	}
 
@@ -190,17 +188,15 @@ int mls_context_isvalid(struct policydb *p, struct context *c)
 		if (!levdatum)
 			return 0;
 
-		ebitmap_for_each_bit(&c->range.level[l].cat, node, i) {
-			if (ebitmap_node_get_bit(node, i)) {
-				if (i > p->p_cats.nprim)
-					return 0;
-				if (!ebitmap_get_bit(&levdatum->level->cat, i))
-					/*
-					 * Category may not be associated with
-					 * sensitivity in low level.
-					 */
-					return 0;
-			}
+		ebitmap_for_each_positive_bit(&c->range.level[l].cat, node, i) {
+			if (i > p->p_cats.nprim)
+				return 0;
+			if (!ebitmap_get_bit(&levdatum->level->cat, i))
+				/*
+				 * Category may not be associated with
+				 * sensitivity in low level.
+				 */
+				return 0;
 		}
 	}
 
@@ -485,18 +481,16 @@ int mls_convert_context(struct policydb *oldp,
 		c->range.level[l].sens = levdatum->level->sens;
 
 		ebitmap_init(&bitmap);
-		ebitmap_for_each_bit(&c->range.level[l].cat, node, i) {
-			if (ebitmap_node_get_bit(node, i)) {
-				int rc;
-
-				catdatum = hashtab_search(newp->p_cats.table,
-				         	oldp->p_cat_val_to_name[i]);
-				if (!catdatum)
-					return -EINVAL;
-				rc = ebitmap_set_bit(&bitmap, catdatum->value - 1, 1);
-				if (rc)
-					return rc;
-			}
+		ebitmap_for_each_positive_bit(&c->range.level[l].cat, node, i) {
+			int rc;
+
+			catdatum = hashtab_search(newp->p_cats.table,
+						  oldp->p_cat_val_to_name[i]);
+			if (!catdatum)
+				return -EINVAL;
+			rc = ebitmap_set_bit(&bitmap, catdatum->value - 1, 1);
+			if (rc)
+				return rc;
 		}
 		ebitmap_destroy(&c->range.level[l].cat);
 		c->range.level[l].cat = bitmap;
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 03140ed..d572dc9 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -353,12 +353,8 @@ static int context_struct_compute_av(struct context *scontext,
 	avkey.specified = AVTAB_AV;
 	sattr = &policydb.type_attr_map[scontext->type - 1];
 	tattr = &policydb.type_attr_map[tcontext->type - 1];
-	ebitmap_for_each_bit(sattr, snode, i) {
-		if (!ebitmap_node_get_bit(snode, i))
-			continue;
-		ebitmap_for_each_bit(tattr, tnode, j) {
-			if (!ebitmap_node_get_bit(tnode, j))
-				continue;
+	ebitmap_for_each_positive_bit(sattr, snode, i) {
+		ebitmap_for_each_positive_bit(tattr, tnode, j) {
 			avkey.source_type = i + 1;
 			avkey.target_type = j + 1;
 			for (node = avtab_search_node(&policydb.te_avtab, &avkey);
@@ -1668,14 +1664,10 @@ int security_get_user_sids(u32 fromsid,
 		goto out_unlock;
 	}
 
-	ebitmap_for_each_bit(&user->roles, rnode, i) {
-		if (!ebitmap_node_get_bit(rnode, i))
-			continue;
+	ebitmap_for_each_positive_bit(&user->roles, rnode, i) {
 		role = policydb.role_val_to_struct[i];
 		usercon.role = i+1;
-		ebitmap_for_each_bit(&role->types, tnode, j) {
-			if (!ebitmap_node_get_bit(tnode, j))
-				continue;
+		ebitmap_for_each_positive_bit(&role->types, tnode, j) {
 			usercon.type = j+1;
 
 			if (mls_setup_user_range(fromcon, user, &usercon))
-- 
1.5.2.4

