Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbYLWNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbYLWNAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYLWNAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:00:45 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35064 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWNAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:00:45 -0500
Date: Tue, 23 Dec 2008 15:00:43 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] failslab for SLUB
In-Reply-To: <20081223103616.GA7217@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0812231459580.18017@melkki.cs.Helsinki.FI>
References: <20081223103616.GA7217@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On Tue, 23 Dec 2008, Akinobu Mita wrote:
> Currently fault-injection capability for SLAB allocator is only available
> to SLAB. This patch makes it available to SLUB, too.

The code duplication in your patch is unfortunate. What do you think of 
this patch instead?

		Pekka

>From 98bb6a5dade01ab007b3994a1456b7cac6b1f905 Mon Sep 17 00:00:00 2001
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 23 Dec 2008 19:37:01 +0900
Subject: [PATCH] SLUB: failslab support

Currently fault-injection capability for SLAB allocator is only
available to SLAB. This patch makes it available to SLUB, too.

[penberg@cs.helsinki.fi: unify slab and slub implementations]
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/fault-inject.h |    9 +++++
 lib/Kconfig.debug            |    1 +
 mm/Makefile                  |    1 +
 mm/failslab.c                |   59 +++++++++++++++++++++++++++++++++
 mm/slab.c                    |   75 +++---------------------------------------
 mm/slub.c                    |    4 ++
 6 files changed, 79 insertions(+), 70 deletions(-)
 create mode 100644 mm/failslab.c

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 32368c4..06ca9b2 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -81,4 +81,13 @@ static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
 
 #endif /* CONFIG_FAULT_INJECTION */
 
+#ifdef CONFIG_FAILSLAB
+extern bool should_failslab(size_t size, gfp_t gfpflags);
+#else
+static inline bool should_failslab(size_t size, gfp_t gfpflags)
+{
+	return false;
+}
+#endif /* CONFIG_FAILSLAB */
+
 #endif /* _LINUX_FAULT_INJECT_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..af65ae7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -699,6 +699,7 @@ config FAULT_INJECTION
 config FAILSLAB
 	bool "Fault-injection capability for kmalloc"
 	depends on FAULT_INJECTION
+	depends on SLAB || SLUB
 	help
 	  Provide fault-injection capability for kmalloc.
 
diff --git a/mm/Makefile b/mm/Makefile
index c06b45a..51c2770 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
diff --git a/mm/failslab.c b/mm/failslab.c
new file mode 100644
index 0000000..7c6ea64
--- /dev/null
+++ b/mm/failslab.c
@@ -0,0 +1,59 @@
+#include <linux/fault-inject.h>
+
+static struct {
+	struct fault_attr attr;
+	u32 ignore_gfp_wait;
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+	struct dentry *ignore_gfp_wait_file;
+#endif
+} failslab = {
+	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
+};
+
+bool should_failslab(size_t size, gfp_t gfpflags)
+{
+	if (gfpflags & __GFP_NOFAIL)
+		return false;
+
+        if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
+		return false;
+
+	return should_fail(&failslab.attr, size);
+}
+
+static int __init setup_failslab(char *str)
+{
+	return setup_fault_attr(&failslab.attr, str);
+}
+__setup("failslab=", setup_failslab);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init failslab_debugfs_init(void)
+{
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	int err;
+
+	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	if (err)
+		return err;
+	dir = failslab.attr.dentries.dir;
+
+	failslab.ignore_gfp_wait_file =
+		debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				      &failslab.ignore_gfp_wait);
+
+	if (!failslab.ignore_gfp_wait_file) {
+		err = -ENOMEM;
+		debugfs_remove(failslab.ignore_gfp_wait_file);
+		cleanup_fault_attr_dentries(&failslab.attr);
+	}
+
+	return err;
+}
+
+late_initcall(failslab_debugfs_init);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
diff --git a/mm/slab.c b/mm/slab.c
index 0918751..c347dd8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3106,79 +3106,14 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 #define cache_alloc_debugcheck_after(a,b,objp,d) (objp)
 #endif
 
-#ifdef CONFIG_FAILSLAB
-
-static struct failslab_attr {
-
-	struct fault_attr attr;
-
-	u32 ignore_gfp_wait;
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-	struct dentry *ignore_gfp_wait_file;
-#endif
-
-} failslab = {
-	.attr = FAULT_ATTR_INITIALIZER,
-	.ignore_gfp_wait = 1,
-};
-
-static int __init setup_failslab(char *str)
-{
-	return setup_fault_attr(&failslab.attr, str);
-}
-__setup("failslab=", setup_failslab);
-
-static int should_failslab(struct kmem_cache *cachep, gfp_t flags)
+static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 {
 	if (cachep == &cache_cache)
-		return 0;
-	if (flags & __GFP_NOFAIL)
-		return 0;
-	if (failslab.ignore_gfp_wait && (flags & __GFP_WAIT))
-		return 0;
+		return false;
 
-	return should_fail(&failslab.attr, obj_size(cachep));
+	return should_failslab(obj_size(cachep), flags);
 }
 
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-static int __init failslab_debugfs(void)
-{
-	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
-	struct dentry *dir;
-	int err;
-
-	err = init_fault_attr_dentries(&failslab.attr, "failslab");
-	if (err)
-		return err;
-	dir = failslab.attr.dentries.dir;
-
-	failslab.ignore_gfp_wait_file =
-		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				      &failslab.ignore_gfp_wait);
-
-	if (!failslab.ignore_gfp_wait_file) {
-		err = -ENOMEM;
-		debugfs_remove(failslab.ignore_gfp_wait_file);
-		cleanup_fault_attr_dentries(&failslab.attr);
-	}
-
-	return err;
-}
-
-late_initcall(failslab_debugfs);
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-
-#else /* CONFIG_FAILSLAB */
-
-static inline int should_failslab(struct kmem_cache *cachep, gfp_t flags)
-{
-	return 0;
-}
-
-#endif /* CONFIG_FAILSLAB */
-
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *objp;
@@ -3381,7 +3316,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	unsigned long save_flags;
 	void *ptr;
 
-	if (should_failslab(cachep, flags))
+	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
 	cache_alloc_debugcheck_before(cachep, flags);
@@ -3457,7 +3392,7 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	unsigned long save_flags;
 	void *objp;
 
-	if (should_failslab(cachep, flags))
+	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
 	cache_alloc_debugcheck_before(cachep, flags);
diff --git a/mm/slub.c b/mm/slub.c
index 7ad489a..10ddc9e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -24,6 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/fault-inject.h>
 
 /*
  * Lock order:
@@ -1591,6 +1592,9 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	unsigned long flags;
 	unsigned int objsize;
 
+	if (should_failslab(s->objsize, gfpflags))
+		return NULL;
+
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
-- 
1.5.4.3

