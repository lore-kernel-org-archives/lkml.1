Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZINRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZINRqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZINRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:46:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55922 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZINRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:46:19 -0400
Date: Mon, 14 Sep 2009 20:46:18 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, aaro.koskinen@nokia.com, amwang@redhat.com,
       dfeng@redhat.com, eric.dumazet@gmail.com, fengguang.wu@intel.com,
       Larry.Finger@lwfinger.net, rientjes@google.com,
       yanmin_zhang@linux.intel.com, zdenek.kabelac@gmail.com
Subject: [GIT PULL] SLAB updates for 2.6.32-rc0
Message-ID: <alpine.DEB.2.00.0909142025290.5303@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the usual batch of SLAB allocator fixes and cleanups accumulated 
over the past few months.

 			Pekka

The following changes since commit 0cc6d77e55eca9557bbe41bf2db94b31aa8fcb2a:
   Linus Torvalds (1):
         Merge branch 'x86-setup-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Aaro Koskinen (1):
       SLUB: fix ARCH_KMALLOC_MINALIGN cases 64 and 256

Amerigo Wang (1):
       SLUB: Fix some coding style issues

David Rientjes (2):
       slub: add option to disable higher order debugging slabs
       slub: use size and objsize orders to disable debug flags

Eric Dumazet (1):
       slub: fix slab_pad_check()

Pekka Enberg (1):
       Merge branches 'slab/cleanups' and 'slab/fixes' into for-linus

WANG Cong (1):
       SLUB: Drop write permission to /proc/slabinfo

Wu Fengguang (1):
       slab: remove duplicate kmem_cache_init_late() declarations

Xiaotian Feng (1):
       slub: release kobject if sysfs_create_group failed in sysfs_slab_add

Zhang, Yanmin (1):
       slub: change kmem_cache->align to record the real alignment

  Documentation/vm/slub.txt |   10 +++++
  include/linux/slob_def.h  |    5 ---
  include/linux/slub_def.h  |    8 +---
  mm/slob.c                 |    5 +++
  mm/slub.c                 |   82 +++++++++++++++++++++++++++++++++++++--------
  5 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index bb1f5c6..510917f 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -41,6 +41,8 @@ Possible debug options are
  	P		Poisoning (object and padding)
  	U		User tracking (free and alloc)
  	T		Trace (please only use on single slabs)
+	O		Switch debugging off for caches that would have
+			caused higher minimum slab orders
  	-		Switch all debugging off (useful if the kernel is
  			configured with CONFIG_SLUB_DEBUG_ON)

@@ -59,6 +61,14 @@ to the dentry cache with

  	slub_debug=F,dentry

+Debugging options may require the minimum possible slab order to increase as
+a result of storing the metadata (for example, caches with PAGE_SIZE object
+sizes).  This has a higher liklihood of resulting in slab allocation errors
+in low memory situations or if there's high fragmentation of memory.  To
+switch off debugging for such caches by default, use
+
+	slub_debug=O
+
  In case you forgot to enable debugging on the kernel command line: It is
  possible to enable debugging manually when the kernel is up. Look at the
  contents of:
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index bb5368d..0ec00b3 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -34,9 +34,4 @@ static __always_inline void *__kmalloc(size_t size, gfp_t flags)
  	return kmalloc(size, flags);
  }

-static inline void kmem_cache_init_late(void)
-{
-	/* Nothing to do */
-}
-
  #endif /* __LINUX_SLOB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c1c862b..5ad70a6 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -153,12 +153,10 @@ static __always_inline int kmalloc_index(size_t size)
  	if (size <= KMALLOC_MIN_SIZE)
  		return KMALLOC_SHIFT_LOW;

-#if KMALLOC_MIN_SIZE <= 64
-	if (size > 64 && size <= 96)
+	if (KMALLOC_MIN_SIZE <= 32 && size > 64 && size <= 96)
  		return 1;
-	if (size > 128 && size <= 192)
+	if (KMALLOC_MIN_SIZE <= 64 && size > 128 && size <= 192)
  		return 2;
-#endif
  	if (size <=          8) return 3;
  	if (size <=         16) return 4;
  	if (size <=         32) return 5;
@@ -304,6 +302,4 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  }
  #endif

-void __init kmem_cache_init_late(void);
-
  #endif /* _LINUX_SLUB_DEF_H */
diff --git a/mm/slob.c b/mm/slob.c
index 9641da3..837ebd6 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -692,3 +692,8 @@ void __init kmem_cache_init(void)
  {
  	slob_ready = 1;
  }
+
+void __init kmem_cache_init_late(void)
+{
+	/* Nothing to do */
+}
diff --git a/mm/slub.c b/mm/slub.c
index b627675..417ed84 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -141,6 +141,13 @@
  				SLAB_POISON | SLAB_STORE_USER)

  /*
+ * Debugging flags that require metadata to be stored in the slab.  These get
+ * disabled when slub_debug=O is used and a cache's min order increases with
+ * metadata.
+ */
+#define DEBUG_METADATA_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
+
+/*
   * Set of flags that will prevent slab merging
   */
  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
@@ -325,6 +332,7 @@ static int slub_debug;
  #endif

  static char *slub_debug_slabs;
+static int disable_higher_order_debug;

  /*
   * Object debugging
@@ -646,7 +654,7 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
  	slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
  	print_section("Padding", end - remainder, remainder);

-	restore_bytes(s, "slab padding", POISON_INUSE, start, end);
+	restore_bytes(s, "slab padding", POISON_INUSE, end - remainder, end);
  	return 0;
  }

@@ -976,6 +984,15 @@ static int __init setup_slub_debug(char *str)
  		 */
  		goto check_slabs;

+	if (tolower(*str) == 'o') {
+		/*
+		 * Avoid enabling debugging on caches if its minimum order
+		 * would increase as a result.
+		 */
+		disable_higher_order_debug = 1;
+		goto out;
+	}
+
  	slub_debug = 0;
  	if (*str == '-')
  		/*
@@ -1026,8 +1043,8 @@ static unsigned long kmem_cache_flags(unsigned long objsize,
  	 * Enable debugging if selected on the kernel commandline.
  	 */
  	if (slub_debug && (!slub_debug_slabs ||
-	    strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs)) == 0))
-			flags |= slub_debug;
+		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
+		flags |= slub_debug;

  	return flags;
  }
@@ -1109,8 +1126,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  	}

  	if (kmemcheck_enabled
-		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
-	{
+		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
  		int pages = 1 << oo_order(oo);

  		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
@@ -1560,6 +1576,10 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
  		"default order: %d, min order: %d\n", s->name, s->objsize,
  		s->size, oo_order(s->oo), oo_order(s->min));

+	if (oo_order(s->min) > get_order(s->objsize))
+		printk(KERN_WARNING "  %s debugging increased min order, use "
+		       "slub_debug=O to disable.\n", s->name);
+
  	for_each_online_node(node) {
  		struct kmem_cache_node *n = get_node(s, node);
  		unsigned long nr_slabs;
@@ -2001,7 +2021,7 @@ static inline int calculate_order(int size)
  				return order;
  			fraction /= 2;
  		}
-		min_objects --;
+		min_objects--;
  	}

  	/*
@@ -2400,6 +2420,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
  	 * on bootup.
  	 */
  	align = calculate_alignment(flags, align, s->objsize);
+	s->align = align;

  	/*
  	 * SLUB stores one object immediately after another beginning from
@@ -2452,6 +2473,18 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,

  	if (!calculate_sizes(s, -1))
  		goto error;
+	if (disable_higher_order_debug) {
+		/*
+		 * Disable debugging flags that store metadata if the min slab
+		 * order increased.
+		 */
+		if (get_order(s->size) > get_order(s->objsize)) {
+			s->flags &= ~DEBUG_METADATA_FLAGS;
+			s->offset = 0;
+			if (!calculate_sizes(s, -1))
+				goto error;
+		}
+	}

  	/*
  	 * The larger the object size is, the more pages we want on the partial
@@ -2790,6 +2823,11 @@ static s8 size_index[24] = {
  	2	/* 192 */
  };

+static inline int size_index_elem(size_t bytes)
+{
+	return (bytes - 1) / 8;
+}
+
  static struct kmem_cache *get_slab(size_t size, gfp_t flags)
  {
  	int index;
@@ -2798,7 +2836,7 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
  		if (!size)
  			return ZERO_SIZE_PTR;

-		index = size_index[(size - 1) / 8];
+		index = size_index[size_index_elem(size)];
  	} else
  		index = fls(size - 1);

@@ -3156,10 +3194,12 @@ void __init kmem_cache_init(void)
  	slab_state = PARTIAL;

  	/* Caches that are not of the two-to-the-power-of size */
-	if (KMALLOC_MIN_SIZE <= 64) {
+	if (KMALLOC_MIN_SIZE <= 32) {
  		create_kmalloc_cache(&kmalloc_caches[1],
  				"kmalloc-96", 96, GFP_NOWAIT);
  		caches++;
+	}
+	if (KMALLOC_MIN_SIZE <= 64) {
  		create_kmalloc_cache(&kmalloc_caches[2],
  				"kmalloc-192", 192, GFP_NOWAIT);
  		caches++;
@@ -3186,17 +3226,28 @@ void __init kmem_cache_init(void)
  	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 256 ||
  		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));

-	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
-		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
+	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8) {
+		int elem = size_index_elem(i);
+		if (elem >= ARRAY_SIZE(size_index))
+			break;
+		size_index[elem] = KMALLOC_SHIFT_LOW;
+	}

-	if (KMALLOC_MIN_SIZE == 128) {
+	if (KMALLOC_MIN_SIZE == 64) {
+		/*
+		 * The 96 byte size cache is not used if the alignment
+		 * is 64 byte.
+		 */
+		for (i = 64 + 8; i <= 96; i += 8)
+			size_index[size_index_elem(i)] = 7;
+	} else if (KMALLOC_MIN_SIZE == 128) {
  		/*
  		 * The 192 byte sized cache is not used if the alignment
  		 * is 128 byte. Redirect kmalloc to use the 256 byte cache
  		 * instead.
  		 */
  		for (i = 128 + 8; i <= 192; i += 8)
-			size_index[(i - 1) / 8] = 8;
+			size_index[size_index_elem(i)] = 8;
  	}

  	slab_state = UP;
@@ -4543,8 +4594,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
  	}

  	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err)
+	if (err) {
+		kobject_del(&s->kobj);
+		kobject_put(&s->kobj);
  		return err;
+	}
  	kobject_uevent(&s->kobj, KOBJ_ADD);
  	if (!unmergeable) {
  		/* Setup first alias */
@@ -4726,7 +4780,7 @@ static const struct file_operations proc_slabinfo_operations = {

  static int __init slab_proc_init(void)
  {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo", S_IRUGO, NULL, &proc_slabinfo_operations);
  	return 0;
  }
  module_init(slab_proc_init);
