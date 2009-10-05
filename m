Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZJEWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZJEWw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZJEWw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:52:57 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49334 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbZJEWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:52:52 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 12/21] ceph: CRUSH mapping algorithm
Date: Mon,  5 Oct 2009 15:50:42 -0700
Message-Id: <1254783051-26217-13-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1254783051-26217-12-git-send-email-sage@newdream.net>
References: <1254783051-26217-1-git-send-email-sage@newdream.net>
 <1254783051-26217-2-git-send-email-sage@newdream.net>
 <1254783051-26217-3-git-send-email-sage@newdream.net>
 <1254783051-26217-4-git-send-email-sage@newdream.net>
 <1254783051-26217-5-git-send-email-sage@newdream.net>
 <1254783051-26217-6-git-send-email-sage@newdream.net>
 <1254783051-26217-7-git-send-email-sage@newdream.net>
 <1254783051-26217-8-git-send-email-sage@newdream.net>
 <1254783051-26217-9-git-send-email-sage@newdream.net>
 <1254783051-26217-10-git-send-email-sage@newdream.net>
 <1254783051-26217-11-git-send-email-sage@newdream.net>
 <1254783051-26217-12-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRUSH is a pseudorandom data distribution function designed to map
inputs onto a dynamic hierarchy of devices, while minimizing the
extent to which inputs are remapped when the devices are added or
removed.  It includes some features that are specifically useful for
storage, most notably the ability to map each input onto a set of N
devices that are separated across administrator-defined failure
domains.  CRUSH is used to distribute data across the cluster of Ceph
storage nodes.

More information about CRUSH can be found in this paper:

    http://www.ssrc.ucsc.edu/Papers/weil-sc06.pdf

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/crush/crush.c  |  140 ++++++++++++
 fs/ceph/crush/crush.h  |  188 +++++++++++++++
 fs/ceph/crush/hash.h   |   90 ++++++++
 fs/ceph/crush/mapper.c |  589 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crush/mapper.h |   20 ++
 5 files changed, 1027 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/crush/crush.c
 create mode 100644 fs/ceph/crush/crush.h
 create mode 100644 fs/ceph/crush/hash.h
 create mode 100644 fs/ceph/crush/mapper.c
 create mode 100644 fs/ceph/crush/mapper.h

diff --git a/fs/ceph/crush/crush.c b/fs/ceph/crush/crush.c
new file mode 100644
index 0000000..13755cd
--- /dev/null
+++ b/fs/ceph/crush/crush.c
@@ -0,0 +1,140 @@
+
+#ifdef __KERNEL__
+# include <linux/slab.h>
+#else
+# include <stdlib.h>
+# include <assert.h>
+# define kfree(x) do { if (x) free(x); } while (0)
+# define BUG_ON(x) assert(!(x))
+#endif
+
+#include "crush.h"
+
+/**
+ * crush_get_bucket_item_weight - Get weight of an item in given bucket
+ * @b: bucket pointer
+ * @p: item index in bucket
+ */
+int crush_get_bucket_item_weight(struct crush_bucket *b, int p)
+{
+	if (p >= b->size)
+		return 0;
+
+	switch (b->alg) {
+	case CRUSH_BUCKET_UNIFORM:
+		return ((struct crush_bucket_uniform *)b)->item_weight;
+	case CRUSH_BUCKET_LIST:
+		return ((struct crush_bucket_list *)b)->item_weights[p];
+	case CRUSH_BUCKET_TREE:
+		if (p & 1)
+			return ((struct crush_bucket_tree *)b)->node_weights[p];
+		return 0;
+	case CRUSH_BUCKET_STRAW:
+		return ((struct crush_bucket_straw *)b)->item_weights[p];
+	}
+	return 0;
+}
+
+/**
+ * crush_calc_parents - Calculate parent vectors for the given crush map.
+ * @map: crush_map pointer
+ */
+void crush_calc_parents(struct crush_map *map)
+{
+	int i, b, c;
+
+	for (b = 0; b < map->max_buckets; b++) {
+		if (map->buckets[b] == NULL)
+			continue;
+		for (i = 0; i < map->buckets[b]->size; i++) {
+			c = map->buckets[b]->items[i];
+			BUG_ON(c >= map->max_devices ||
+			       c < -map->max_buckets);
+			if (c >= 0)
+				map->device_parents[c] = map->buckets[b]->id;
+			else
+				map->bucket_parents[-1-c] = map->buckets[b]->id;
+		}
+	}
+}
+
+void crush_destroy_bucket_uniform(struct crush_bucket_uniform *b)
+{
+	kfree(b->h.perm);
+	kfree(b->h.items);
+	kfree(b);
+}
+
+void crush_destroy_bucket_list(struct crush_bucket_list *b)
+{
+	kfree(b->item_weights);
+	kfree(b->sum_weights);
+	kfree(b->h.perm);
+	kfree(b->h.items);
+	kfree(b);
+}
+
+void crush_destroy_bucket_tree(struct crush_bucket_tree *b)
+{
+	kfree(b->node_weights);
+	kfree(b);
+}
+
+void crush_destroy_bucket_straw(struct crush_bucket_straw *b)
+{
+	kfree(b->straws);
+	kfree(b->item_weights);
+	kfree(b->h.perm);
+	kfree(b->h.items);
+	kfree(b);
+}
+
+void crush_destroy_bucket(struct crush_bucket *b)
+{
+	switch (b->alg) {
+	case CRUSH_BUCKET_UNIFORM:
+		crush_destroy_bucket_uniform((struct crush_bucket_uniform *)b);
+		break;
+	case CRUSH_BUCKET_LIST:
+		crush_destroy_bucket_list((struct crush_bucket_list *)b);
+		break;
+	case CRUSH_BUCKET_TREE:
+		crush_destroy_bucket_tree((struct crush_bucket_tree *)b);
+		break;
+	case CRUSH_BUCKET_STRAW:
+		crush_destroy_bucket_straw((struct crush_bucket_straw *)b);
+		break;
+	}
+}
+
+/**
+ * crush_destroy - Destroy a crush_map
+ * @map: crush_map pointer
+ */
+void crush_destroy(struct crush_map *map)
+{
+	int b;
+
+	/* buckets */
+	if (map->buckets) {
+		for (b = 0; b < map->max_buckets; b++) {
+			if (map->buckets[b] == NULL)
+				continue;
+			crush_destroy_bucket(map->buckets[b]);
+		}
+		kfree(map->buckets);
+	}
+
+	/* rules */
+	if (map->rules) {
+		for (b = 0; b < map->max_rules; b++)
+			kfree(map->rules[b]);
+		kfree(map->rules);
+	}
+
+	kfree(map->bucket_parents);
+	kfree(map->device_parents);
+	kfree(map);
+}
+
+
diff --git a/fs/ceph/crush/crush.h b/fs/ceph/crush/crush.h
new file mode 100644
index 0000000..9ac7e09
--- /dev/null
+++ b/fs/ceph/crush/crush.h
@@ -0,0 +1,188 @@
+#ifndef _CRUSH_CRUSH_H
+#define _CRUSH_CRUSH_H
+
+#include <linux/types.h>
+
+/*
+ * CRUSH is a pseudo-random data distribution algorithm that
+ * efficiently distributes input values (typically, data objects)
+ * across a heterogeneous, structured storage cluster.
+ *
+ * The algorithm was originally described in detail in this paper
+ * (although the algorithm has evolved somewhat since then):
+ *
+ *     http://www.ssrc.ucsc.edu/Papers/weil-sc06.pdf
+ *
+ * LGPL2
+ */
+
+
+#define CRUSH_MAGIC 0x00010000ul   /* for detecting algorithm revisions */
+
+
+#define CRUSH_MAX_DEPTH 10  /* max crush hierarchy depth */
+#define CRUSH_MAX_SET   10  /* max size of a mapping result */
+
+
+/*
+ * CRUSH uses user-defined "rules" to describe how inputs should be
+ * mapped to devices.  A rule consists of sequence of steps to perform
+ * to generate the set of output devices.
+ */
+struct crush_rule_step {
+	__u32 op;
+	__s32 arg1;
+	__s32 arg2;
+};
+
+/* step op codes */
+enum {
+	CRUSH_RULE_NOOP = 0,
+	CRUSH_RULE_TAKE = 1,          /* arg1 = value to start with */
+	CRUSH_RULE_CHOOSE_FIRSTN = 2, /* arg1 = num items to pick */
+				      /* arg2 = type */
+	CRUSH_RULE_CHOOSE_INDEP = 3,  /* same */
+	CRUSH_RULE_EMIT = 4,          /* no args */
+	CRUSH_RULE_CHOOSE_LEAF_FIRSTN = 6,
+	CRUSH_RULE_CHOOSE_LEAF_INDEP = 7,
+};
+
+/*
+ * for specifying choose num (arg1) relative to the max parameter
+ * passed to do_rule
+ */
+#define CRUSH_CHOOSE_N            0
+#define CRUSH_CHOOSE_N_MINUS(x)   (-(x))
+
+/*
+ * The rule mask is used to describe what the rule is intended for.
+ * Given a ruleset and size of output set, we search through the
+ * rule list for a matching rule_mask.
+ */
+struct crush_rule_mask {
+	__u8 ruleset;
+	__u8 type;
+	__u8 min_size;
+	__u8 max_size;
+};
+
+struct crush_rule {
+	__u32 len;
+	struct crush_rule_mask mask;
+	struct crush_rule_step steps[0];
+};
+
+#define crush_rule_size(len) (sizeof(struct crush_rule) + \
+			      (len)*sizeof(struct crush_rule_step))
+
+
+
+/*
+ * A bucket is a named container of other items (either devices or
+ * other buckets).  Items within a bucket are chosen using one of a
+ * few different algorithms.  The table summarizes how the speed of
+ * each option measures up against mapping stability when items are
+ * added or removed.
+ *
+ *  Bucket Alg     Speed       Additions    Removals
+ *  ------------------------------------------------
+ *  uniform         O(1)       poor         poor
+ *  list            O(n)       optimal      poor
+ *  tree            O(log n)   good         good
+ *  straw           O(n)       optimal      optimal
+ */
+enum {
+	CRUSH_BUCKET_UNIFORM = 1,
+	CRUSH_BUCKET_LIST = 2,
+	CRUSH_BUCKET_TREE = 3,
+	CRUSH_BUCKET_STRAW = 4
+};
+static inline const char *crush_bucket_alg_name(int alg)
+{
+	switch (alg) {
+	case CRUSH_BUCKET_UNIFORM: return "uniform";
+	case CRUSH_BUCKET_LIST: return "list";
+	case CRUSH_BUCKET_TREE: return "tree";
+	case CRUSH_BUCKET_STRAW: return "straw";
+	default: return "unknown";
+	}
+}
+
+struct crush_bucket {
+	__s32 id;        /* this'll be negative */
+	__u16 type;      /* non-zero; type=0 is reserved for devices */
+	__u16 alg;       /* one of CRUSH_BUCKET_* */
+	__u32 weight;    /* 16-bit fixed point */
+	__u32 size;      /* num items */
+	__s32 *items;
+
+	/*
+	 * cached random permutation: used for uniform bucket and for
+	 * the linear search fallback for the other bucket types.
+	 */
+	__u32 perm_x;  /* @x for which *perm is defined */
+	__u32 perm_n;  /* num elements of *perm that are permuted/defined */
+	__u32 *perm;
+};
+
+struct crush_bucket_uniform {
+	struct crush_bucket h;
+	__u32 item_weight;  /* 16-bit fixed point; all items equally weighted */
+};
+
+struct crush_bucket_list {
+	struct crush_bucket h;
+	__u32 *item_weights;  /* 16-bit fixed point */
+	__u32 *sum_weights;   /* 16-bit fixed point.  element i is sum
+				 of weights 0..i, inclusive */
+};
+
+struct crush_bucket_tree {
+	struct crush_bucket h;  /* note: h.size is _tree_ size, not number of
+				   actual items */
+	__u8 num_nodes;
+	__u32 *node_weights;
+};
+
+struct crush_bucket_straw {
+	struct crush_bucket h;
+	__u32 *item_weights;   /* 16-bit fixed point */
+	__u32 *straws;         /* 16-bit fixed point */
+};
+
+
+
+/*
+ * CRUSH map includes all buckets, rules, etc.
+ */
+struct crush_map {
+	struct crush_bucket **buckets;
+	struct crush_rule **rules;
+
+	/*
+	 * Parent pointers to identify the parent bucket a device or
+	 * bucket in the hierarchy.  If an item appears more than
+	 * once, this is the _last_ time it appeared (where buckets
+	 * are processed in bucket id order, from -1 on down to
+	 * -max_buckets.
+	 */
+	__u32 *bucket_parents;
+	__u32 *device_parents;
+
+	__s32 max_buckets;
+	__u32 max_rules;
+	__s32 max_devices;
+};
+
+
+/* crush.c */
+extern int crush_get_bucket_item_weight(struct crush_bucket *b, int pos);
+extern void crush_calc_parents(struct crush_map *map);
+extern void crush_destroy_bucket_uniform(struct crush_bucket_uniform *b);
+extern void crush_destroy_bucket_list(struct crush_bucket_list *b);
+extern void crush_destroy_bucket_tree(struct crush_bucket_tree *b);
+extern void crush_destroy_bucket_straw(struct crush_bucket_straw *b);
+extern void crush_destroy_bucket(struct crush_bucket *b);
+extern void crush_destroy(struct crush_map *map);
+
+#endif
diff --git a/fs/ceph/crush/hash.h b/fs/ceph/crush/hash.h
new file mode 100644
index 0000000..42f3312
--- /dev/null
+++ b/fs/ceph/crush/hash.h
@@ -0,0 +1,90 @@
+#ifndef _CRUSH_HASH_H
+#define _CRUSH_HASH_H
+
+/*
+ * Robert Jenkins' function for mixing 32-bit values
+ * http://burtleburtle.net/bob/hash/evahash.html
+ * a, b = random bits, c = input and output
+ */
+#define crush_hashmix(a, b, c) do {			\
+		a = a-b;  a = a-c;  a = a^(c>>13);	\
+		b = b-c;  b = b-a;  b = b^(a<<8);	\
+		c = c-a;  c = c-b;  c = c^(b>>13);	\
+		a = a-b;  a = a-c;  a = a^(c>>12);	\
+		b = b-c;  b = b-a;  b = b^(a<<16);	\
+		c = c-a;  c = c-b;  c = c^(b>>5);	\
+		a = a-b;  a = a-c;  a = a^(c>>3);	\
+		b = b-c;  b = b-a;  b = b^(a<<10);	\
+		c = c-a;  c = c-b;  c = c^(b>>15);	\
+	} while (0)
+
+#define crush_hash_seed 1315423911
+
+static inline __u32 crush_hash32(__u32 a)
+{
+	__u32 hash = crush_hash_seed ^ a;
+	__u32 b = a;
+	__u32 x = 231232;
+	__u32 y = 1232;
+	crush_hashmix(b, x, hash);
+	crush_hashmix(y, a, hash);
+	return hash;
+}
+
+static inline __u32 crush_hash32_2(__u32 a, __u32 b)
+{
+	__u32 hash = crush_hash_seed ^ a ^ b;
+	__u32 x = 231232;
+	__u32 y = 1232;
+	crush_hashmix(a, b, hash);
+	crush_hashmix(x, a, hash);
+	crush_hashmix(b, y, hash);
+	return hash;
+}
+
+static inline __u32 crush_hash32_3(__u32 a, __u32 b, __u32 c)
+{
+	__u32 hash = crush_hash_seed ^ a ^ b ^ c;
+	__u32 x = 231232;
+	__u32 y = 1232;
+	crush_hashmix(a, b, hash);
+	crush_hashmix(c, x, hash);
+	crush_hashmix(y, a, hash);
+	crush_hashmix(b, x, hash);
+	crush_hashmix(y, c, hash);
+	return hash;
+}
+
+static inline __u32 crush_hash32_4(__u32 a, __u32 b, __u32 c,
+				   __u32 d)
+{
+	__u32 hash = crush_hash_seed ^ a ^ b ^ c ^ d;
+	__u32 x = 231232;
+	__u32 y = 1232;
+	crush_hashmix(a, b, hash);
+	crush_hashmix(c, d, hash);
+	crush_hashmix(a, x, hash);
+	crush_hashmix(y, b, hash);
+	crush_hashmix(c, x, hash);
+	crush_hashmix(y, d, hash);
+	return hash;
+}
+
+static inline __u32 crush_hash32_5(__u32 a, __u32 b, __u32 c,
+				   __u32 d, __u32 e)
+{
+	__u32 hash = crush_hash_seed ^ a ^ b ^ c ^ d ^ e;
+	__u32 x = 231232;
+	__u32 y = 1232;
+	crush_hashmix(a, b, hash);
+	crush_hashmix(c, d, hash);
+	crush_hashmix(e, x, hash);
+	crush_hashmix(y, a, hash);
+	crush_hashmix(b, x, hash);
+	crush_hashmix(y, c, hash);
+	crush_hashmix(d, x, hash);
+	crush_hashmix(y, e, hash);
+	return hash;
+}
+
+#endif
diff --git a/fs/ceph/crush/mapper.c b/fs/ceph/crush/mapper.c
new file mode 100644
index 0000000..0f0730c
--- /dev/null
+++ b/fs/ceph/crush/mapper.c
@@ -0,0 +1,589 @@
+
+#ifdef __KERNEL__
+# include <linux/string.h>
+# include <linux/slab.h>
+# include <linux/bug.h>
+# include <linux/kernel.h>
+# ifndef dprintk
+#  define dprintk(args...)
+# endif
+#else
+# include <string.h>
+# include <stdio.h>
+# include <stdlib.h>
+# include <assert.h>
+# define BUG_ON(x) assert(!(x))
+# define dprintk(args...) /* printf(args) */
+# define kmalloc(x, f) malloc(x)
+# define kfree(x) free(x)
+#endif
+
+#include "crush.h"
+#include "hash.h"
+
+/*
+ * Implement the core CRUSH mapping algorithm.
+ */
+
+/**
+ * crush_find_rule - find a crush_rule id for a given ruleset, type, and size.
+ * @map: the crush_map
+ * @ruleset: the storage ruleset id (user defined)
+ * @type: storage ruleset type (user defined)
+ * @size: output set size
+ */
+int crush_find_rule(struct crush_map *map, int ruleset, int type, int size)
+{
+	int i;
+
+	for (i = 0; i < map->max_rules; i++) {
+		if (map->rules[i] &&
+		    map->rules[i]->mask.ruleset == ruleset &&
+		    map->rules[i]->mask.type == type &&
+		    map->rules[i]->mask.min_size <= size &&
+		    map->rules[i]->mask.max_size >= size)
+			return i;
+	}
+	return -1;
+}
+
+
+/*
+ * bucket choose methods
+ *
+ * For each bucket algorithm, we have a "choose" method that, given a
+ * crush input @x and replica position (usually, position in output set) @r,
+ * will produce an item in the bucket.
+ */
+
+/*
+ * Choose based on a random permutation of the bucket.
+ *
+ * We used to use some prime number arithmetic to do this, but it
+ * wasn't very random, and had some other bad behaviors.  Instead, we
+ * calculate an actual random permutation of the bucket members.
+ * Since this is expensive, we optimize for the r=0 case, which
+ * captures the vast majority of calls.
+ */
+static int bucket_perm_choose(struct crush_bucket *bucket,
+			      int x, int r)
+{
+	unsigned pr = r % bucket->size;
+	unsigned i, s;
+
+	/* start a new permutation if @x has changed */
+	if (bucket->perm_x != x || bucket->perm_n == 0) {
+		dprintk("bucket %d new x=%d\n", bucket->id, x);
+		bucket->perm_x = x;
+
+		/* optimize common r=0 case */
+		if (pr == 0) {
+			s = crush_hash32_3(x, bucket->id, 0) %
+				bucket->size;
+			bucket->perm[0] = s;
+			bucket->perm_n = 0xffff;   /* magic value, see below */
+			goto out;
+		}
+
+		for (i = 0; i < bucket->size; i++)
+			bucket->perm[i] = i;
+		bucket->perm_n = 0;
+	} else if (bucket->perm_n == 0xffff) {
+		/* clean up after the r=0 case above */
+		for (i = 1; i < bucket->size; i++)
+			bucket->perm[i] = i;
+		bucket->perm[bucket->perm[0]] = 0;
+		bucket->perm_n = 1;
+	}
+
+	/* calculate permutation up to pr */
+	for (i = 0; i < bucket->perm_n; i++)
+		dprintk(" perm_choose have %d: %d\n", i, bucket->perm[i]);
+	while (bucket->perm_n <= pr) {
+		unsigned p = bucket->perm_n;
+		/* no point in swapping the final entry */
+		if (p < bucket->size - 1) {
+			i = crush_hash32_3(x, bucket->id, p) %
+				(bucket->size - p);
+			if (i) {
+				unsigned t = bucket->perm[p + i];
+				bucket->perm[p + i] = bucket->perm[p];
+				bucket->perm[p] = t;
+			}
+			dprintk(" perm_choose swap %d with %d\n", p, p+i);
+		}
+		bucket->perm_n++;
+	}
+	for (i = 0; i < bucket->size; i++)
+		dprintk(" perm_choose  %d: %d\n", i, bucket->perm[i]);
+
+	s = bucket->perm[pr];
+out:
+	dprintk(" perm_choose %d sz=%d x=%d r=%d (%d) s=%d\n", bucket->id,
+		bucket->size, x, r, pr, s);
+	return bucket->items[s];
+}
+
+/* uniform */
+static int bucket_uniform_choose(struct crush_bucket_uniform *bucket,
+				 int x, int r)
+{
+	return bucket_perm_choose(&bucket->h, x, r);
+}
+
+/* list */
+static int bucket_list_choose(struct crush_bucket_list *bucket,
+			      int x, int r)
+{
+	int i;
+
+	for (i = bucket->h.size-1; i >= 0; i--) {
+		__u64 w = crush_hash32_4(x, bucket->h.items[i], r,
+					 bucket->h.id);
+		w &= 0xffff;
+		dprintk("list_choose i=%d x=%d r=%d item %d weight %x "
+			"sw %x rand %llx",
+			i, x, r, bucket->h.items[i], bucket->item_weights[i],
+			bucket->sum_weights[i], w);
+		w *= bucket->sum_weights[i];
+		w = w >> 16;
+		/*dprintk(" scaled %llx\n", w);*/
+		if (w < bucket->item_weights[i])
+			return bucket->h.items[i];
+	}
+
+	BUG_ON(1);
+	return 0;
+}
+
+
+/* (binary) tree */
+static int height(int n)
+{
+	int h = 0;
+	while ((n & 1) == 0) {
+		h++;
+		n = n >> 1;
+	}
+	return h;
+}
+
+static int left(int x)
+{
+	int h = height(x);
+	return x - (1 << (h-1));
+}
+
+static int right(int x)
+{
+	int h = height(x);
+	return x + (1 << (h-1));
+}
+
+static int terminal(int x)
+{
+	return x & 1;
+}
+
+static int bucket_tree_choose(struct crush_bucket_tree *bucket,
+			      int x, int r)
+{
+	int n, l;
+	__u32 w;
+	__u64 t;
+
+	/* start at root */
+	n = bucket->num_nodes >> 1;
+
+	while (!terminal(n)) {
+		/* pick point in [0, w) */
+		w = bucket->node_weights[n];
+		t = (__u64)crush_hash32_4(x, n, r, bucket->h.id) * (__u64)w;
+		t = t >> 32;
+
+		/* descend to the left or right? */
+		l = left(n);
+		if (t < bucket->node_weights[l])
+			n = l;
+		else
+			n = right(n);
+	}
+
+	return bucket->h.items[n >> 1];
+}
+
+
+/* straw */
+
+static int bucket_straw_choose(struct crush_bucket_straw *bucket,
+			       int x, int r)
+{
+	int i;
+	int high = 0;
+	__u64 high_draw = 0;
+	__u64 draw;
+
+	for (i = 0; i < bucket->h.size; i++) {
+		draw = crush_hash32_3(x, bucket->h.items[i], r);
+		draw &= 0xffff;
+		draw *= bucket->straws[i];
+		if (i == 0 || draw > high_draw) {
+			high = i;
+			high_draw = draw;
+		}
+	}
+	return bucket->h.items[high];
+}
+
+static int crush_bucket_choose(struct crush_bucket *in, int x, int r)
+{
+	dprintk("choose %d x=%d r=%d\n", in->id, x, r);
+	switch (in->alg) {
+	case CRUSH_BUCKET_UNIFORM:
+		return bucket_uniform_choose((struct crush_bucket_uniform *)in,
+					  x, r);
+	case CRUSH_BUCKET_LIST:
+		return bucket_list_choose((struct crush_bucket_list *)in,
+					  x, r);
+	case CRUSH_BUCKET_TREE:
+		return bucket_tree_choose((struct crush_bucket_tree *)in,
+					  x, r);
+	case CRUSH_BUCKET_STRAW:
+		return bucket_straw_choose((struct crush_bucket_straw *)in,
+					   x, r);
+	default:
+		BUG_ON(1);
+/* 		return in->items[0] */;
+	}
+}
+
+/*
+ * true if device is marked "out" (failed, fully offloaded)
+ * of the cluster
+ */
+static int is_out(struct crush_map *map, __u32 *weight, int item, int x)
+{
+	if (weight[item] >= 0x1000)
+		return 0;
+	if (weight[item] == 0)
+		return 1;
+	if ((crush_hash32_2(x, item) & 0xffff) < weight[item])
+		return 0;
+	return 1;
+}
+
+/**
+ * crush_choose - choose numrep distinct items of given type
+ * @map: the crush_map
+ * @bucket: the bucket we are choose an item from
+ * @x: crush input value
+ * @numrep: the number of items to choose
+ * @type: the type of item to choose
+ * @out: pointer to output vector
+ * @outpos: our position in that vector
+ * @firstn: true if choosing "first n" items, false if choosing "indep"
+ * @recurse_to_leaf: true if we want one device under each item of given type
+ * @out2: second output vector for leaf items (if @recurse_to_leaf)
+ */
+static int crush_choose(struct crush_map *map,
+			struct crush_bucket *bucket,
+			__u32 *weight,
+			int x, int numrep, int type,
+			int *out, int outpos,
+			int firstn, int recurse_to_leaf,
+			int *out2)
+{
+	int rep;
+	int ftotal, flocal;
+	int retry_descent, retry_bucket, skip_rep;
+	struct crush_bucket *in = bucket;
+	int r;
+	int i;
+	int item;
+	int itemtype;
+	int collide, reject;
+	const int orig_tries = 5; /* attempts before we fall back to search */
+	dprintk("choose bucket %d x %d outpos %d\n", bucket->id, x, outpos);
+
+	for (rep = outpos; rep < numrep; rep++) {
+		/* keep trying until we get a non-out, non-colliding item */
+		ftotal = 0;
+		skip_rep = 0;
+		do {
+			retry_descent = 0;
+			in = bucket;               /* initial bucket */
+
+			/* choose through intervening buckets */
+			flocal = 0;
+			do {
+				retry_bucket = 0;
+				r = rep;
+				if (in->alg == CRUSH_BUCKET_UNIFORM) {
+					/* be careful */
+					if (firstn || numrep >= in->size)
+						/* r' = r + f_total */
+						r += ftotal;
+					else if (in->size % numrep == 0)
+						/* r'=r+(n+1)*f_local */
+						r += (numrep+1) *
+							(flocal+ftotal);
+					else
+						/* r' = r + n*f_local */
+						r += numrep * (flocal+ftotal);
+				} else {
+					if (firstn)
+						/* r' = r + f_total */
+						r += ftotal;
+					else
+						/* r' = r + n*f_local */
+						r += numrep * (flocal+ftotal);
+				}
+
+				/* bucket choose */
+				if (flocal >= (in->size>>1) &&
+				    flocal > orig_tries)
+					item = bucket_perm_choose(in, x, r);
+				else
+					item = crush_bucket_choose(in, x, r);
+				BUG_ON(item >= map->max_devices);
+
+				/* desired type? */
+				if (item < 0)
+					itemtype = map->buckets[-1-item]->type;
+				else
+					itemtype = 0;
+				dprintk("  item %d type %d\n", item, itemtype);
+
+				/* keep going? */
+				if (itemtype != type) {
+					BUG_ON(item >= 0 ||
+					       (-1-item) >= map->max_buckets);
+					in = map->buckets[-1-item];
+					continue;
+				}
+
+				/* collision? */
+				collide = 0;
+				for (i = 0; i < outpos; i++) {
+					if (out[i] == item) {
+						collide = 1;
+						break;
+					}
+				}
+
+				if (recurse_to_leaf &&
+				    item < 0 &&
+				    crush_choose(map, map->buckets[-1-item],
+						 weight,
+						 x, outpos+1, 0,
+						 out2, outpos,
+						 firstn, 0, NULL) <= outpos) {
+					reject = 1;
+				} else {
+					/* out? */
+					if (itemtype == 0)
+						reject = is_out(map, weight,
+								item, x);
+					else
+						reject = 0;
+				}
+
+				if (reject || collide) {
+					ftotal++;
+					flocal++;
+
+					if (collide && flocal < 3)
+						/* retry locally a few times */
+						retry_bucket = 1;
+					else if (flocal < in->size + orig_tries)
+						/* exhaustive bucket search */
+						retry_bucket = 1;
+					else if (ftotal < 20)
+						/* then retry descent */
+						retry_descent = 1;
+					else
+						/* else give up */
+						skip_rep = 1;
+					dprintk("  reject %d  collide %d  "
+						"ftotal %d  flocal %d\n",
+						reject, collide, ftotal,
+						flocal);
+				}
+			} while (retry_bucket);
+		} while (retry_descent);
+
+		if (skip_rep) {
+			dprintk("skip rep\n");
+			continue;
+		}
+
+		dprintk("choose got %d\n", item);
+		out[outpos] = item;
+		outpos++;
+	}
+
+	dprintk("choose returns %d\n", outpos);
+	return outpos;
+}
+
+
+/**
+ * crush_do_rule - calculate a mapping with the given input and rule
+ * @map: the crush_map
+ * @ruleno: the rule id
+ * @x: hash input
+ * @result: pointer to result vector
+ * @result_max: maximum result size
+ * @force: force initial replica choice; -1 for none
+ */
+int crush_do_rule(struct crush_map *map,
+		  int ruleno, int x, int *result, int result_max,
+		  int force, __u32 *weight)
+{
+	int result_len;
+	int force_context[CRUSH_MAX_DEPTH];
+	int force_pos = -1;
+	int a[CRUSH_MAX_SET];
+	int b[CRUSH_MAX_SET];
+	int c[CRUSH_MAX_SET];
+	int recurse_to_leaf;
+	int *w;
+	int wsize = 0;
+	int *o;
+	int osize;
+	int *tmp;
+	struct crush_rule *rule;
+	int step;
+	int i, j;
+	int numrep;
+	int firstn;
+	int rc = -1;
+
+	BUG_ON(ruleno >= map->max_rules);
+
+	rule = map->rules[ruleno];
+	result_len = 0;
+	w = a;
+	o = b;
+
+	/*
+	 * determine hierarchical context of force, if any.  note
+	 * that this may or may not correspond to the specific types
+	 * referenced by the crush rule.
+	 */
+	if (force >= 0) {
+		if (force >= map->max_devices ||
+		    map->device_parents[force] == 0) {
+			/*dprintk("CRUSH: forcefed device dne\n");*/
+			rc = -1;  /* force fed device dne */
+			goto out;
+		}
+		if (!is_out(map, weight, force, x)) {
+			while (1) {
+				force_context[++force_pos] = force;
+				if (force >= 0)
+					force = map->device_parents[force];
+				else
+					force = map->bucket_parents[-1-force];
+				if (force == 0)
+					break;
+			}
+		}
+	}
+
+	for (step = 0; step < rule->len; step++) {
+		firstn = 0;
+		switch (rule->steps[step].op) {
+		case CRUSH_RULE_TAKE:
+			w[0] = rule->steps[step].arg1;
+			if (force_pos >= 0) {
+				BUG_ON(force_context[force_pos] != w[0]);
+				force_pos--;
+			}
+			wsize = 1;
+			break;
+
+		case CRUSH_RULE_CHOOSE_LEAF_FIRSTN:
+		case CRUSH_RULE_CHOOSE_FIRSTN:
+			firstn = 1;
+		case CRUSH_RULE_CHOOSE_LEAF_INDEP:
+		case CRUSH_RULE_CHOOSE_INDEP:
+			BUG_ON(wsize == 0);
+
+			recurse_to_leaf =
+				rule->steps[step].op ==
+				 CRUSH_RULE_CHOOSE_LEAF_FIRSTN ||
+				rule->steps[step].op ==
+				CRUSH_RULE_CHOOSE_LEAF_INDEP;
+
+			/* reset output */
+			osize = 0;
+
+			for (i = 0; i < wsize; i++) {
+				/*
+				 * see CRUSH_N, CRUSH_N_MINUS macros.
+				 * basically, numrep <= 0 means relative to
+				 * the provided result_max
+				 */
+				numrep = rule->steps[step].arg1;
+				if (numrep <= 0) {
+					numrep += result_max;
+					if (numrep <= 0)
+						continue;
+				}
+				j = 0;
+				if (osize == 0 && force_pos >= 0) {
+					/* skip any intermediate types */
+					while (force_pos &&
+					       force_context[force_pos] < 0 &&
+					       rule->steps[step].arg2 !=
+					       map->buckets[-1 -
+					       force_context[force_pos]]->type)
+						force_pos--;
+					o[osize] = force_context[force_pos];
+					if (recurse_to_leaf)
+						c[osize] = force_context[0];
+					j++;
+					force_pos--;
+				}
+				osize += crush_choose(map,
+						      map->buckets[-1-w[i]],
+						      weight,
+						      x, numrep,
+						      rule->steps[step].arg2,
+						      o+osize, j,
+						      firstn,
+						      recurse_to_leaf, c+osize);
+			}
+
+			if (recurse_to_leaf)
+				/* copy final _leaf_ values to output set */
+				memcpy(o, c, osize*sizeof(*o));
+
+			/* swap t and w arrays */
+			tmp = o;
+			o = w;
+			w = tmp;
+			wsize = osize;
+			break;
+
+
+		case CRUSH_RULE_EMIT:
+			for (i = 0; i < wsize && result_len < result_max; i++) {
+				result[result_len] = w[i];
+				result_len++;
+			}
+			wsize = 0;
+			break;
+
+		default:
+			BUG_ON(1);
+		}
+	}
+	rc = result_len;
+
+out:
+	return rc;
+}
+
+
diff --git a/fs/ceph/crush/mapper.h b/fs/ceph/crush/mapper.h
new file mode 100644
index 0000000..98e9004
--- /dev/null
+++ b/fs/ceph/crush/mapper.h
@@ -0,0 +1,20 @@
+#ifndef _CRUSH_MAPPER_H
+#define _CRUSH_MAPPER_H
+
+/*
+ * CRUSH functions for find rules and then mapping an input to an
+ * output set.
+ *
+ * LGPL2
+ */
+
+#include "crush.h"
+
+extern int crush_find_rule(struct crush_map *map, int pool, int type, int size);
+extern int crush_do_rule(struct crush_map *map,
+			 int ruleno,
+			 int x, int *result, int result_max,
+			 int forcefeed,    /* -1 for none */
+			 __u32 *weights);
+
+#endif
-- 
1.5.6.5

