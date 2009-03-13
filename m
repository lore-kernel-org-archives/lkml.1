Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZCMQRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZCMQRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCMQRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:17:25 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38041 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZCMQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ohdxLW+v4Q6+DuArUECzjn4NzKOWZPH9qtlGN2zdk/LKNxuf0TPy0JEjESiLYyoqHf
         fXuS23gBXeUonAebgkd0qEal0pHEFNEpsg+yyggHzxL2VE5PWA5kg2Ax9mAqnpCP+uly
         rONjOmV2G+L9LGV5lKDt0WxlphjSo9uGYRq9I=
Message-ID: <49BA8710.20808@gmail.com>
Date: Fri, 13 Mar 2009 17:17:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: build bug on pointer type
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was thinking about forcing a build bug if anyone attempts to kfree a
struct sk_buff*, like this:

#define PTR_OR_BB_ON_TYPE(x, type) (&x[sizeof(char[0 -			\
			__builtin_types_compatible_p(typeof(x), type)])])

and:

#define kfree(x) _kfree(PTR_OR_BB_ON_TYPE((x), struct sk_buff*))

with _kfree as the function that is currently kfree.

It appears to work in my test.c.

I also compile this with (defconfig) and there were several errors, which I
fixed, included in the patch below, and also increased sparse warnings, like
this

In file included from /home/roel/dnld/src/kernel/git/linux-2.6/include/linux/vmstat.h:5,
                 from /home/roel/dnld/src/kernel/git/linux-2.6/include/linux/mm.h:595,
                 from /home/roel/dnld/src/kernel/git/linux-2.6/kernel/exit.c:7:
/home/roel/dnld/src/kernel/git/linux-2.6/include/linux/percpu.h: In function 'percpu_free':
/home/roel/dnld/src/kernel/git/linux-2.6/include/linux/percpu.h:98: warning: dereferencing 'void *' pointer

This is mostly due to wrappers for kfree that take a void* argument. and can be
fixed after compiling with sparse by:

sed -n -r "s/^([^:]*):([^:]*):.*derefer.*$/\2{s\/^\(.*[^[:alnum:]_]\)kfree$s\\\\\\\\\(\/\\\\\\\\1_kfree\\\\\\\\\(\/} \1/p" ../logs/make_def_log_20090313164543 | while read l f; do sed -i -r  "$l" "$f"; done

My question, is there something fundamentally wrong with this?

Not yet meant for inclusion, and only compile tested.
---
 block/genhd.c                      |    2 +-
 drivers/firmware/dmi-id.c          |    2 +-
 drivers/gpu/drm/i915/intel_modes.c |    2 +-
 include/linux/kernel.h             |    5 +++++
 include/linux/slab.h               |    5 ++++-
 kernel/exit.c                      |    2 +-
 lib/kref.c                         |    2 +-
 mm/slab.c                          |    4 ++--
 mm/slob.c                          |    4 ++--
 mm/slub.c                          |    4 ++--
 net/core/dev.c                     |    4 ++--
 security/selinux/ss/services.c     |    2 +-
 12 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..e732530 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -972,7 +972,7 @@ static void disk_release(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	kfree(disk->random);
+	_kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	kfree(disk);
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 5a76d05..e4517d7 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -160,7 +160,7 @@ static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct class dmi_class = {
 	.name = "dmi",
-	.dev_release = (void(*)(struct device *)) kfree,
+	.dev_release = (void(*)(struct device *)) _kfree,
 	.dev_uevent = dmi_dev_uevent,
 };
 
diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index e42019e..0ca35e5 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -76,7 +76,7 @@ int intel_ddc_get_modes(struct intel_output *intel_output)
 		drm_mode_connector_update_edid_property(&intel_output->base,
 							edid);
 		ret = drm_add_edid_modes(&intel_output->base, edid);
-		kfree(edid);
+		_kfree(edid);
 	}
 
 	return ret;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7fa3718..8809c9c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -526,6 +526,11 @@ struct sysinfo {
    aren't permitted). */
 #define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
 
+/* If the type of pointer x matches type, force a compilation error,
+   otherwise produce x as a result */
+#define PTR_OR_BB_ON_TYPE(x, type) (&x[sizeof(char[0 -			\
+			__builtin_types_compatible_p(typeof(x), type)])])
+
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 24c5602..7a17c3e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -121,12 +121,15 @@ int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 #define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
 #define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_HIGH - PAGE_SHIFT)
 
+/* This ensures that kfree is not called with a struct sk_buff* */
+#define kfree(x) _kfree(PTR_OR_BB_ON_TYPE((x), struct sk_buff*))
+
 /*
  * Common kmalloc functions provided by all allocators
  */
 void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
-void kfree(const void *);
+void _kfree(const void *);
 void kzfree(const void *);
 size_t ksize(const void *);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index efd30cc..96eb98a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1103,7 +1103,7 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
-		kfree(current->pi_state_cache);
+		_kfree(current->pi_state_cache);
 #endif
 	/*
 	 * Make sure we are holding no locks:
diff --git a/lib/kref.c b/lib/kref.c
index 9ecd6e8..a6364df 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -62,7 +62,7 @@ void kref_get(struct kref *kref)
 int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 {
 	WARN_ON(release == NULL);
-	WARN_ON(release == (void (*)(struct kref *))kfree);
+	WARN_ON(release == (void (*)(struct kref *))_kfree);
 
 	if (atomic_dec_and_test(&kref->refcount)) {
 		release(kref);
diff --git a/mm/slab.c b/mm/slab.c
index 4d00855..3acefac 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3711,7 +3711,7 @@ EXPORT_SYMBOL(kmem_cache_free);
  * Don't free memory not originally allocated by kmalloc()
  * or you will run into trouble.
  */
-void kfree(const void *objp)
+void _kfree(const void *objp)
 {
 	struct kmem_cache *c;
 	unsigned long flags;
@@ -3726,7 +3726,7 @@ void kfree(const void *objp)
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(kfree);
+EXPORT_SYMBOL(_kfree);
 
 unsigned int kmem_cache_size(struct kmem_cache *cachep)
 {
diff --git a/mm/slob.c b/mm/slob.c
index 52bc8a2..1d8a3c4 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -487,7 +487,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
-void kfree(const void *block)
+void _kfree(const void *block)
 {
 	struct slob_page *sp;
 
@@ -502,7 +502,7 @@ void kfree(const void *block)
 	} else
 		put_page(&sp->page);
 }
-EXPORT_SYMBOL(kfree);
+EXPORT_SYMBOL(_kfree);
 
 /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t ksize(const void *block)
diff --git a/mm/slub.c b/mm/slub.c
index 0280eee..f9fa9e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2738,7 +2738,7 @@ size_t ksize(const void *object)
 }
 EXPORT_SYMBOL(ksize);
 
-void kfree(const void *x)
+void _kfree(const void *x)
 {
 	struct page *page;
 	void *object = (void *)x;
@@ -2754,7 +2754,7 @@ void kfree(const void *x)
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
 }
-EXPORT_SYMBOL(kfree);
+EXPORT_SYMBOL(_kfree);
 
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
diff --git a/net/core/dev.c b/net/core/dev.c
index f112970..74038ef 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2671,7 +2671,7 @@ void netif_napi_del(struct napi_struct *napi)
 	struct sk_buff *skb, *next;
 
 	list_del_init(&napi->dev_list);
-	kfree(napi->skb);
+	_kfree(napi->skb);
 
 	for (skb = napi->gro_list; skb; skb = next) {
 		next = skb->next;
@@ -4720,7 +4720,7 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 	if (!tx) {
 		printk(KERN_ERR "alloc_netdev: Unable to allocate "
 		       "tx qdiscs.\n");
-		kfree(p);
+		_kfree(p);
 		return NULL;
 	}
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index c65e4fe..cefe043 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2862,7 +2862,7 @@ static void security_netlbl_cache_add(struct netlbl_lsm_secattr *secattr,
 	}
 
 	*sid_cache = sid;
-	secattr->cache->free = kfree;
+	secattr->cache->free = _kfree;
 	secattr->cache->data = sid_cache;
 	secattr->flags |= NETLBL_SECATTR_CACHE;
 }
