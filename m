Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZJOJVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZJOJVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZJOJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:21:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZJOJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:21:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=TDgDqoCv2JW7SC7bxRwF8DLiGs9uzoPRd/cwgi7Af+sGfohEPQ5hLK67Hn7LJN4ZK
	MiQXIszKy2zXV3sNa/IUw==
Date: Thu, 15 Oct 2009 02:20:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: allow stats to be cleared
Message-ID: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When collecting slub stats for particular workloads, it's necessary to
collect each statistic for all caches before the job is even started
because the counters are usually greater than zero just from boot and
initialization.

This allows a statistic to be cleared on each cpu by writing '0' to its
sysfs file.  This creates a baseline for statistics of interest before
the workload is started.

Setting a statistic to a particular value is not supported, so all values
written to these files other than '0' returns -EINVAL.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/ABI/testing/sysfs-kernel-slab |  109 ++++++++++++++-------------
 mm/slub.c                                   |   18 ++++-
 2 files changed, 75 insertions(+), 52 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/ABI/testing/sysfs-kernel-slab
--- a/Documentation/ABI/testing/sysfs-kernel-slab
+++ b/Documentation/ABI/testing/sysfs-kernel-slab
@@ -45,8 +45,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The alloc_fastpath file is read-only and specifies how many
-		objects have been allocated using the fast path.
+		The alloc_fastpath file shows how many objects have been
+		allocated using the fast path.  It can be written to clear the
+		current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/alloc_from_partial
@@ -55,9 +56,10 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The alloc_from_partial file is read-only and specifies how
-		many times a cpu slab has been full and it has been refilled
-		by using a slab from the list of partially used slabs.
+		The alloc_from_partial file shows how many times a cpu slab has
+		been full and it has been refilled by using a slab from the list
+		of partially used slabs.  It can be written to clear the current
+		count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/alloc_refill
@@ -66,9 +68,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The alloc_refill file is read-only and specifies how many
-		times the per-cpu freelist was empty but there were objects
-		available as the result of remote cpu frees.
+		The alloc_refill file shows how many times the per-cpu freelist
+		was empty but there were objects available as the result of
+		remote cpu frees.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/alloc_slab
@@ -77,8 +79,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The alloc_slab file is read-only and specifies how many times
-		a new slab had to be allocated from the page allocator.
+		The alloc_slab file is shows how many times a new slab had to
+		be allocated from the page allocator.  It can be written to
+		clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/alloc_slowpath
@@ -87,9 +90,10 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The alloc_slowpath file is read-only and specifies how many
-		objects have been allocated using the slow path because of a
-		refill or allocation from a partial or new slab.
+		The alloc_slowpath file shows how many objects have been
+		allocated using the slow path because of a refill or
+		allocation from a partial or new slab.  It can be written to
+		clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/cache_dma
@@ -117,10 +121,11 @@ KernelVersion:	2.6.31
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file cpuslab_flush is read-only and specifies how many
-		times a cache's cpu slabs have been flushed as the result of
-		destroying or shrinking a cache, a cpu going offline, or as
-		the result of forcing an allocation from a certain node.
+		The file cpuslab_flush shows how many times a cache's cpu slabs
+		have been flushed as the result of destroying or shrinking a
+		cache, a cpu going offline, or as the result of forcing an
+		allocation from a certain node.  It can be written to clear the
+		current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/ctor
@@ -139,8 +144,8 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file deactivate_empty is read-only and specifies how many
-		times an empty cpu slab was deactivated.
+		The deactivate_empty file shows how many times an empty cpu slab
+		was deactivated.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/deactivate_full
@@ -149,8 +154,8 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file deactivate_full is read-only and specifies how many
-		times a full cpu slab was deactivated.
+		The deactivate_full file shows how many times a full cpu slab
+		was deactivated.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/deactivate_remote_frees
@@ -159,9 +164,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file deactivate_remote_frees is read-only and specifies how
-		many times a cpu slab has been deactivated and contained free
-		objects that were freed remotely.
+		The deactivate_remote_frees file shows how many times a cpu slab
+		has been deactivated and contained free objects that were freed
+		remotely.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/deactivate_to_head
@@ -170,9 +175,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file deactivate_to_head is read-only and specifies how
-		many times a partial cpu slab was deactivated and added to the
-		head of its node's partial list.
+		The deactivate_to_head file shows how many times a partial cpu
+		slab was deactivated and added to the head of its node's partial
+		list.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/deactivate_to_tail
@@ -181,9 +186,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file deactivate_to_tail is read-only and specifies how
-		many times a partial cpu slab was deactivated and added to the
-		tail of its node's partial list.
+		The deactivate_to_tail file shows how many times a partial cpu
+		slab was deactivated and added to the tail of its node's partial
+		list.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/destroy_by_rcu
@@ -201,9 +206,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file free_add_partial is read-only and specifies how many
-		times an object has been freed in a full slab so that it had to
-		added to its node's partial list.
+		The free_add_partial file shows how many times an object has
+		been freed in a full slab so that it had to added to its node's
+		partial list.  It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/free_calls
@@ -222,9 +227,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The free_fastpath file is read-only and specifies how many
-		objects have been freed using the fast path because it was an
-		object from the cpu slab.
+		The free_fastpath file shows how many objects have been freed
+		using the fast path because it was an object from the cpu slab.
+		It can be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/free_frozen
@@ -233,9 +238,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The free_frozen file is read-only and specifies how many
-		objects have been freed to a frozen slab (i.e. a remote cpu
-		slab).
+		The free_frozen file shows how many objects have been freed to
+		a frozen slab (i.e. a remote cpu slab).  It can be written to
+		clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/free_remove_partial
@@ -244,9 +249,10 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file free_remove_partial is read-only and specifies how
-		many times an object has been freed to a now-empty slab so
-		that it had to be removed from its node's partial list.
+		The free_remove_partial file shows how many times an object has
+		been freed to a now-empty slab so that it had to be removed from
+		its node's partial list.  It can be written to clear the current
+		count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/free_slab
@@ -255,8 +261,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The free_slab file is read-only and specifies how many times an
-		empty slab has been freed back to the page allocator.
+		The free_slab file shows how many times an empty slab has been
+		freed back to the page allocator.  It can be written to clear
+		the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/free_slowpath
@@ -265,9 +272,9 @@ KernelVersion:	2.6.25
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The free_slowpath file is read-only and specifies how many
-		objects have been freed using the slow path (i.e. to a full or
-		partial slab).
+		The free_slowpath file shows how many objects have been freed
+		using the slow path (i.e. to a full or partial slab).  It can
+		be written to clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/hwcache_align
@@ -346,10 +353,10 @@ KernelVersion:	2.6.26
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@linux-foundation.org>
 Description:
-		The file order_fallback is read-only and specifies how many
-		times an allocation of a new slab has not been possible at the
-		cache's order and instead fallen back to its minimum possible
-		order.
+		The order_fallback file shows how many times an allocation of a
+		new slab has not been possible at the cache's order and instead
+		fallen back to its minimum possible order.  It can be written to
+		clear the current count.
 		Available when CONFIG_SLUB_STATS is enabled.
 
 What:		/sys/kernel/slab/cache/partial
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4371,12 +4371,28 @@ static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
 	return len + sprintf(buf + len, "\n");
 }
 
+static void clear_stat(struct kmem_cache *s, enum stat_item si)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		get_cpu_slab(s, cpu)->stat[si] = 0;
+}
+
 #define STAT_ATTR(si, text) 					\
 static ssize_t text##_show(struct kmem_cache *s, char *buf)	\
 {								\
 	return show_stat(s, buf, si);				\
 }								\
-SLAB_ATTR_RO(text);						\
+static ssize_t text##_store(struct kmem_cache *s,		\
+				const char *buf, size_t length)	\
+{								\
+	if (buf[0] != '0')					\
+		return -EINVAL;					\
+	clear_stat(s, si);					\
+	return length;						\
+}								\
+SLAB_ATTR(text);						\
 
 STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
 STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
