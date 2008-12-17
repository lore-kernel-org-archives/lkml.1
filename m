Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759033AbYLQLsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbYLQLsj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYLQLsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:48:19 -0500
Received: from ozlabs.org ([203.10.76.45]:55400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYLQLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:48:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/1] cpumask: add alloc_cpumask_var_node V2
Date: Wed, 17 Dec 2008 22:18:12 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@redhat.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <49471353.9070204@sgi.com> <494724E7.4090701@sgi.com> <49472C59.4030104@sgi.com>
In-Reply-To: <49472C59.4030104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172218.12608.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008 14:49:37 Mike Travis wrote:
> Add alloc_cpumask_var_node.  This will be needed in x86 code to
> allocate the domain and old_domain cpumasks on the same node as
> where the containing irq_cfg struct is allocated.

OK, this is understandable.  If you don't mind I'll split this patch
into documentation and node patches separately.

Since kmalloc(size, gfp) == kmalloc_node(size, gfp, -1), I think
we can change this to implement alloc_cpumask_var() in terms of
alloc_cpumask_var_node(..., numa_node_id()).

Here's what I ended up with:

Add alloc_cpumask_var_node()

This will be needed in x86 code to allocate the domain and old_domain
cpumasks on the same node as where the containing irq_cfg struct is
allocated.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (re-impl alloc_cpumask_var)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1011,6 +1011,7 @@ static inline size_t cpumask_size(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
 
+bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
 void free_cpumask_var(cpumask_var_t mask);
@@ -1020,6 +1021,12 @@ typedef struct cpumask cpumask_var_t[1];
 typedef struct cpumask cpumask_var_t[1];
 
 static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return true;
+}
+
+static inline bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags,
+					  int node)
 {
 	return true;
 }
diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -76,15 +76,14 @@ int cpumask_any_but(const struct cpumask
 
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
-bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
 	if (likely(slab_is_available()))
-		*mask = kmalloc(cpumask_size(), flags);
+		*mask = kmalloc_node(cpumask_size(), flags, node);
 	else {
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 		printk(KERN_ERR
 			"=> alloc_cpumask_var: kmalloc not available!\n");
-		dump_stack();
 #endif
 		*mask = NULL;
 	}
@@ -95,6 +94,12 @@ bool alloc_cpumask_var(cpumask_var_t *ma
 	}
 #endif
 	return *mask != NULL;
+}
+EXPORT_SYMBOL(alloc_cpumask_var_node);
+
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return alloc_cpumask_var_node(mask, flag, numa_node_id());
 }
 EXPORT_SYMBOL(alloc_cpumask_var);
 
cpumask: documentation for cpumask_var_t

Additional documentation added to all the alloc_cpumask and free_cpumask
functions.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (minor additions)

diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -76,6 +76,20 @@ int cpumask_any_but(const struct cpumask
 
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
+/**
+ * alloc_cpumask_var_node - allocate a struct cpumask on a given node
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ * @flags: GFP_ flags
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop returning a constant 1 (in <linux/cpumask.h>)
+ * Returns TRUE if memory allocation succeeded, FALSE otherwise.
+ *
+ * In addition, mask will be NULL if this fails.  Note that gcc is
+ * usually smart enough to know that mask can never be NULL if
+ * CONFIG_CPUMASK_OFFSTACK=n, so does code elimination in that case
+ * too.
+ */
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
 	if (likely(slab_is_available()))
@@ -97,23 +111,52 @@ bool alloc_cpumask_var_node(cpumask_var_
 }
 EXPORT_SYMBOL(alloc_cpumask_var_node);
 
+/**
+ * alloc_cpumask_var - allocate a struct cpumask
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ * @flags: GFP_ flags
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop returning a constant 1 (in <linux/cpumask.h>).
+ *
+ * See alloc_cpumask_var_node.
+ */
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
 	return alloc_cpumask_var_node(mask, flag, numa_node_id());
 }
 EXPORT_SYMBOL(alloc_cpumask_var);
 
+/**
+ * alloc_bootmem_cpumask_var - allocate a struct cpumask from the bootmem arena.
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop returning a constant 1 (in <linux/cpumask.h>)
+ * Either returns an allocated (zero-filled) cpumask, or causes the
+ * system to panic.
+ */
 void __init alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 {
 	*mask = alloc_bootmem(cpumask_size());
 }
 
+/**
+ * free_cpumask_var - frees memory allocated for a struct cpumask.
+ * @mask: cpumask to free
+ *
+ * This is safe on a NULL mask.
+ */
 void free_cpumask_var(cpumask_var_t mask)
 {
 	kfree(mask);
 }
 EXPORT_SYMBOL(free_cpumask_var);
 
+/**
+ * free_bootmem_cpumask_var - frees result of alloc_bootmem_cpumask_var
+ * @mask: cpumask to free
+ */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
 	free_bootmem((unsigned long)mask, cpumask_size());
