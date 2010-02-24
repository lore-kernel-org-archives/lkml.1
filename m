Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0BXSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:38:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44174 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0BXSiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=kOiv4VS/KKpEtlS1zrv6xB4pnE3j8shHgHH5ev8wnljR9RMU5DMVw966UTkvMMY195
         pytSj6X/FDEKUfLGwvpRZq83hnQKUhSOAk5HWDYUic7oUW1Z49ThcjSSbtb+kLZstN1Q
         Q711R7lXkWhvswPaJwEATnsp+C0+klxQcSFCI=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: [PATCH] failslab: add ability to filter slab caches
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
	<alpine.DEB.2.00.1002231432530.8693@chino.kir.corp.google.com>
Date: Wed, 24 Feb 2010 21:38:04 +0300
In-Reply-To: <alpine.DEB.2.00.1002231432530.8693@chino.kir.corp.google.com>
	(David Rientjes's message of "Tue, 23 Feb 2010 14:36:00 -0800 (PST)")
Message-ID: <87bpfe8ooj.fsf_-_@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

David Rientjes <rientjes@google.com> writes:

> On Tue, 23 Feb 2010, Dmitry Monakhov wrote:
>
>> Example:
>> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
>> echo 1 > /sys/kernel/debug/failslab/cache-filter
>> 
>
> Where's the changelog?
I've hoped than subject is enough. But if you want more verbose
changelog, take following version.

--=-=-=
Content-Disposition: inline;
 filename=0001-failslab-add-abitily-to-filter-slab-caches.patch

>From 2decbe704aa0e4acfd7fd87437c28ca151e39b32 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 23 Feb 2010 16:17:47 +0300
Subject: [PATCH] failslab: add ability to filter slab caches

This patch allow to inject faults only for specific slabs.
In order to preserve default behavior cache filter is off by
default (all caches are faulty).

One may define specific set of slabs like this:
# mark skbuff_head_cache as faulty
echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
# Turn on cache filter (off by default)
echo 1 > /sys/kernel/debug/failslab/cache-filter
# Turn on fault injection
echo 1 > /sys/kernel/debug/failslab/times
echo 1 > /sys/kernel/debug/failslab/probability

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/fault-inject.h |    4 ++--
 include/linux/slab.h         |    4 +++-
 mm/failslab.c                |   18 +++++++++++++++---
 mm/slab.c                    |    2 +-
 mm/slub.c                    |   31 +++++++++++++++++++++++++++++--
 5 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 06ca9b2..d935647 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -82,9 +82,9 @@ static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
 #endif /* CONFIG_FAULT_INJECTION */
 
 #ifdef CONFIG_FAILSLAB
-extern bool should_failslab(size_t size, gfp_t gfpflags);
+extern bool should_failslab(size_t size, gfp_t gfpflags, unsigned long c_flags);
 #else
-static inline bool should_failslab(size_t size, gfp_t gfpflags)
+static inline bool should_failslab(size_t size, gfp_t gfpflags, unsigned long f)
 {
 	return false;
 }
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2da8372..9e03a81 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -70,7 +70,9 @@
 #else
 # define SLAB_NOTRACK		0x00000000UL
 #endif
-
+#ifdef CONFIG_FAILSLAB
+# define SLAB_FAILSLAB	0x02000000UL	/* Fault injection filter mark */
+#endif 
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/mm/failslab.c b/mm/failslab.c
index 9339de5..bb41f98 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -1,18 +1,22 @@
 #include <linux/fault-inject.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 static struct {
 	struct fault_attr attr;
 	u32 ignore_gfp_wait;
+	int cache_filter;
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 	struct dentry *ignore_gfp_wait_file;
+	struct dentry *cache_filter_file;
 #endif
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
+	.cache_filter = 0,
 };
 
-bool should_failslab(size_t size, gfp_t gfpflags)
+bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
 {
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
@@ -20,6 +24,9 @@ bool should_failslab(size_t size, gfp_t gfpflags)
         if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
 		return false;
 
+	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
+		return false;
+
 	return should_fail(&failslab.attr, size);
 }
 
@@ -30,7 +37,6 @@ static int __init setup_failslab(char *str)
 __setup("failslab=", setup_failslab);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
 static int __init failslab_debugfs_init(void)
 {
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
@@ -46,8 +52,14 @@ static int __init failslab_debugfs_init(void)
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
 				      &failslab.ignore_gfp_wait);
 
-	if (!failslab.ignore_gfp_wait_file) {
+	failslab.cache_filter_file =
+		debugfs_create_bool("cache-filter", mode, dir,
+				      &failslab.cache_filter);
+
+	if (!failslab.ignore_gfp_wait_file ||
+	    !failslab.cache_filter_file) {
 		err = -ENOMEM;
+		debugfs_remove(failslab.cache_filter_file);
 		debugfs_remove(failslab.ignore_gfp_wait_file);
 		cleanup_fault_attr_dentries(&failslab.attr);
 	}
diff --git a/mm/slab.c b/mm/slab.c
index 7451bda..33496b7 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3101,7 +3101,7 @@ static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 	if (cachep == &cache_cache)
 		return false;
 
-	return should_failslab(obj_size(cachep), flags);
+	return should_failslab(obj_size(cachep), flags, cachep->flags);
 }
 
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
diff --git a/mm/slub.c b/mm/slub.c
index 8d71aaf..64114fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -151,7 +151,8 @@
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
+		SLAB_FAILSLAB)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA | SLAB_NOTRACK)
@@ -1020,6 +1021,11 @@ static int __init setup_slub_debug(char *str)
 		case 't':
 			slub_debug |= SLAB_TRACE;
 			break;
+#ifdef CONFIG_FAILSLAB
+		case 'a':
+			slub_debug |= SLAB_FAILSLAB;
+			break;
+#endif
 		default:
 			printk(KERN_ERR "slub_debug option '%c' "
 				"unknown. skipped\n", *str);
@@ -1718,7 +1724,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	lockdep_trace_alloc(gfpflags);
 	might_sleep_if(gfpflags & __GFP_WAIT);
 
-	if (should_failslab(s->objsize, gfpflags))
+	if (should_failslab(s->objsize, gfpflags, s->flags))
 		return NULL;
 
 	local_irq_save(flags);
@@ -4171,6 +4177,23 @@ static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 }
 SLAB_ATTR(trace);
 
+#ifdef CONFIG_FAILSLAB
+static ssize_t failslab_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
+}
+
+static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
+							size_t length)
+{
+	s->flags &= ~SLAB_FAILSLAB;
+	if (buf[0] == '1')
+		s->flags |= SLAB_FAILSLAB;
+	return length;
+}
+SLAB_ATTR(failslab);
+#endif
+
 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
@@ -4467,6 +4490,10 @@ static struct attribute *slab_attrs[] = {
 	&deactivate_remote_frees_attr.attr,
 	&order_fallback_attr.attr,
 #endif
+#ifdef CONFIG_FAILSLAB
+	&failslab_attr.attr,
+#endif
+
 	NULL
 };
 
-- 
1.6.6


--=-=-=--
